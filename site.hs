--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Lazy.Char8 as C
import           Data.Monoid                 (mappend)
import           Hakyll
import           Hakyll.Images
import           Hakyll.Images.CompressJpg
import           Hakyll.Typescript.TS        (compressJtsCompiler)
import           Text.Jasmine
import           Text.Pandoc.Extensions
import           Text.Pandoc.Options

import           Site.Posts.Brews.Context
import           Site.Posts.Literate.Compile

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "posts/**/*.lhs" $ blogPostRules $
      getResourceFilePath >>= unsafeCompiler . runghcPost

    match "404.lhs" $ do
        route $ setExtension "html"
        compile $
          getResourceFilePath
          >>= unsafeCompiler . runghcPost
          >> pandocCompiler
          >>= loadAndApplyTemplate "templates/default.html" defaultContext

    match "images/**.jpg" $ do
        route   idRoute
        compile $ loadImage >>= compressJpgCompiler 50

    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "scripts/**" $ do
        route $ setExtension "js"
        compile compressJtsCompiler

    match "resume/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/**/*.markdown" $ blogPostRules (pure ())

    let postsPattern = "posts/blog/*" .&&. (complement "**/*.html")
    createArchiveLanding "posts/blog/index.html" "Posts" postsPattern
    createArchiveLanding "posts/brews/index.html" "Brews" "posts/brews/*.markdown"
    createArchiveLanding "posts/projects/index.html" "Projects" "posts/projects/*.markdown"

    let archivePattern = "posts/**/*" .&&. (complement "**/*.html")
    createArchiveLanding "archive.html" "Archives" archivePattern

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
blogPostRules :: Compiler () -> Rules ()
blogPostRules preProcess = do
  route $ setExtension "html"
  compile $
      preProcess
      >> getUnderlying
      >>= addWaterProfile
      >>= \waterProf -> let postCtx' = postCtx <> waterProf in
      getResourceString
      >>= applyAsTemplate postCtx' -- allows posts to include partials
      >>= myRenderPandoc
      >>= loadAndApplyTemplate "templates/post.html"    postCtx'
      >>= loadAndApplyTemplate "templates/default.html" postCtx'
      >>= relativizeUrls

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
