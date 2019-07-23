--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad.IO.Class
import           Control.Concurrent.ParallelIO
import qualified Data.ByteString.Lazy.Char8 as C
import           Data.List ((\\))
import           Data.Monoid (mappend, All(..))
import           GHC.Conc (numCapabilities)
import           Hakyll
import           Hakyll.Images
import           Hakyll.Images.CompressJpg
import           System.Directory.Extra (listFilesRecursive)
import           Text.Jasmine

import           Site.Posts.Brews.Context

--------------------------------------------------------------------------------
main :: IO ()
main = do
  dirtyPaths      <- listFilesRecursive "."
  let nonHidden   = filter (not . startsWith ".") . fmap (drop 2) $ dirtyPaths
  let nonWork     = filter (not . startsWith "_") nonHidden
  let allImages   = filter (startsWith "images/") nonWork
  let jpgs        = filter (endsWith ".jpg") allImages
  let otherImages = allImages \\ jpgs
  let allRules    = reverse $ mainRules : compileJpgs jpgs
  putStrLn $ "Attempting to compile with " <> show numCapabilities <> " cores"
  parHakyll parallel allRules
  stopGlobalPool

mainRules :: Rules ()
mainRules = do
    match ("images/" .&&. complement "images/**.jpg") $ do
        route   idRoute
        compile $ copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "scripts/**" $ do
        route   idRoute
        compile compressJsCompiler

    match "resume/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/**/*" $ do
        route $ setExtension "html"
        compile $ getUnderlying
            >>= addWaterProfile
            >>= \waterProf -> let postCtx' = postCtx <> waterProf in
            getResourceString
            >>= applyAsTemplate postCtx' -- allows posts to include partials
            >>= renderPandoc
            >>= loadAndApplyTemplate "templates/post.html"    postCtx'
            >>= loadAndApplyTemplate "templates/default.html" postCtx'
            >>= relativizeUrls

    createArchiveLanding "posts/blog/index.html" "Posts" "posts/blog/*.markdown"
    createArchiveLanding "posts/brews/index.html" "Brews" "posts/brews/*.markdown"
    createArchiveLanding "posts/projects/index.html" "Projects" "posts/projects/*.markdown"
    createArchiveLanding "archive.html" "Archives" "posts/**/*.markdown"

    match "index.html" $ do
        route idRoute
        compile $ do
            allPosts <- recentFirst =<< loadAll "posts/**/*.markdown"
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

compressJsCompiler :: Compiler (Item String)
compressJsCompiler = do
  let minifyJS = C.unpack . minify . C.pack . itemBody
  s <- getResourceString
  return $ itemSetBody (minifyJS s) s

---------------------------------------------------------------------
-- helper matchers
startsWith :: FilePath -> FilePath -> Bool
startsWith xs ys = getAll . foldMap All $ zipWith (==) xs ys

endsWith :: FilePath -> FilePath -> Bool
endsWith xs ys = startsWith xs' ys' where
  xs' = reverse xs
  ys' = reverse ys

compileJpgs :: [FilePath] -> [Rules ()]
compileJpgs ps = match' <$> ps where
  match' p = match (fromGlob p) $ do
    route idRoute
    compile $ loadImage >>= compressJpgCompiler 50
