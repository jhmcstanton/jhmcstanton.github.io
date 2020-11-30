--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Lazy.Char8 as C
import           Data.Monoid                 (mappend)
import           Hakyll
import qualified Hakyll.Core.Configuration  as Config
import           Hakyll.Images
import           Hakyll.Images.CompressJpg
import           Hakyll.Process
import           Hakyll.Typescript.TS        (compressJtsCompiler)
import qualified Options.Applicative        as OA
import           System.Environment          (getArgs)
import           Text.Jasmine
import           Text.Pandoc.Extensions
import           Text.Pandoc.Options

import           Site.Posts.Brews.Context
import           Site.Posts.Literate.Compile

data WaterProfiles = WPActive | WPInactive deriving Show
data CompressJpgs  = CJActive | CJInactive deriving Show
data SiteOptions = SiteOptions {
    useWaterProfiles :: WaterProfiles,
    compressJpgs :: CompressJpgs,
    hakyllOpts :: Options
  } deriving Show

parser :: OA.Parser SiteOptions
parser = SiteOptions <$> water <*> compress <*> optionParser (Config.defaultConfiguration) where
  water    = OA.flag WPInactive WPActive (OA.long "use-water-profiles" <> OA.help "Pull water profiles defined in posts")
  compress = OA.flag CJInactive CJActive (OA.long "compress-jpgs" <> OA.help "Compress jpgs")

parserInfo :: OA.ParserInfo SiteOptions
parserInfo = OA.info (OA.helper <*> parser) (OA.fullDesc <> OA.progDesc "jhmcstanton.com site builder")

--------------------------------------------------------------------------------
main :: IO ()
main = do
  args <- getArgs
  options <- OA.handleParseResult $ OA.execParserPure defaultParserPrefs parserInfo args
  let blogPostRules' = blogPostRules (useWaterProfiles options)
  hakyllWithArgs Config.defaultConfiguration (hakyllOpts options) $ do
    match "posts/**/*.lhs" $ blogPostRules' $
      getResourceFilePath >>= unsafeCompiler . runghcPost

    match "404.lhs" $ do
        route $ setExtension "html"
        compile $
          getResourceFilePath
          >>= unsafeCompiler . runghcPost
          >>  pandocCompiler
          >>= loadAndApplyTemplate "templates/default.html" defaultContext

    match "images/**.jpg" $ do
        route   idRoute
        imageCompressionRules (compressJpgs options)

    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "scripts/**" $ do
        route $ setExtension "js"
        compile compressJtsCompiler

    match "resume/*.tex" $ do
        route   $ setExtension "pdf"
        compile $ execCompilerWith (execName "xelatex") [ProcArg "-output-directory=resume/", HakFilePath] (newExtOutFilePath "pdf")

    match (fromList ["about.rst"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/**/*.markdown" $ blogPostRules' (pure ())

    let postsPattern = "posts/blog/*" .&&. (complement "**/*.html")
    createArchiveLanding "posts/blog/index.html"        "Posts"    postsPattern
    createArchiveLanding "posts/brews/index.html"       "Brews"    "posts/brews/*.markdown"
    createArchiveLanding "posts/projects/index.html"    "Projects" "posts/projects/*.markdown"
    createArchiveLanding "posts/music/index.html"       "Music"    "posts/music/*.markdown"
    createArchiveLanding "posts/music/daily/index.html" "Daily"    "posts/music/daily/*.markdown"
    match "posts/music/daily/*.ly" $ do
      route   $ setExtension "png"
      compile $ execCompilerWith (execName "lilypond")
                  [ProcArg "-dbackend=eps", ProcArg "-dno-gs-load-fonts", ProcArg "-dinclude-eps-fonts",
                   ProcArg "-dmidi-extension=mid", ProcArg "--output=posts/music/daily/", ProcArg "--png", HakFilePath]
                  (newExtOutFilePath "png")
                >>= saveSnapshot "_final"
    match "posts/music/daily/*.mid" $ do
      route   idRoute
      compile copyFileCompiler

    let archivePattern = "posts/**/*" .&&. (complement "**/*.html") .&&. (complement "**/music/daily/*")
    createArchiveLanding "archive.html" "Archives" archivePattern

    createArchiveLanding "contact.html" "Contact" ""

    match "index.html" $ do
        route idRoute
        compile $ do
            allPosts <- recentFirst =<< loadAll archivePattern
            let posts = take 10 allPosts
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/**" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
myWriterOptions :: WriterOptions
myWriterOptions =
  let exts = writerExtensions defaultHakyllWriterOptions in
  defaultHakyllWriterOptions {
    writerExtensions = enableExtension Ext_literate_haskell exts
  }


--------------------------------------------------------------------------------
myRenderPandoc :: Item String -> Compiler (Item String)
myRenderPandoc = renderPandocWith defaultHakyllReaderOptions myWriterOptions

--------------------------------------------------------------------------------
blogPostRules :: WaterProfiles -> Compiler () -> Rules ()
blogPostRules useWaterProfile preProcess = do
  route $ setExtension "html"
  compile $
      preProcess
      >> getUnderlying
      >>= (case useWaterProfile of
             WPActive   -> addWaterProfile
             WPInactive -> pure . const mempty)
      >>= \waterProf -> let postCtx' = postCtx <> waterProf in
      getResourceString
      >>= applyAsTemplate postCtx' -- allows posts to include partials
      >>= myRenderPandoc
      >>= loadAndApplyTemplate "templates/post.html"    postCtx'
      >>= loadAndApplyTemplate "templates/default.html" postCtx'
      >>= relativizeUrls

--------------------------------------------------------------------------------
imageCompressionRules :: CompressJpgs -> Rules ()
imageCompressionRules CJActive   = compile $ loadImage >>= compressJpgCompiler 50
imageCompressionRules CJInactive = compile copyFileCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

createArchiveLanding :: String -> String -> Pattern -> Rules ()
createArchiveLanding page title glob =
  create [fromFilePath page] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll glob
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" title            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate (fromFilePath $ "templates/" <> page) archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls
