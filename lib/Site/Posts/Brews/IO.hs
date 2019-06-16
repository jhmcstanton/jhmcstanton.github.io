{-# LANGUAGE OverloadedStrings #-}
module Site.Posts.Brews.IO
  (
    fetchProfile
  )
where

import           Control.Concurrent (threadDelay)
import           Control.Monad.Trans.Class
import           Data.Text hiding (drop, dropWhile)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import           System.Directory (
    createDirectoryIfMissing,
    doesFileExist
  )
import           Test.WebDriver
import           Test.WebDriver.Class
import           Test.WebDriver.Session

pageLoadSeconds = 1
cacheRoot = "_cache/water_profile/"

ids :: [Text]
ids =
  [
    "Ca"
  , "Mg"
  , "Na"
  , "Cl"
  , "SO4"
  , "Alk"
  , "RA"
  ]

type URL = String
type ID  = String

fetchProfile :: URL -> IO [Text]
fetchProfile url = do
  maybeProf <- getCache url
  case maybeProf of
    Just prof -> pure prof
    Nothing   -> do
      session <- runSession defaultConfig (openPage url >> getSession)
      threadDelay $ pageLoadSeconds * 1000000
      elems <- runWD session $ do
                 elems <- getElems
                 closeSession
                 pure elems
      putCache url elems
      pure elems

getElems :: WebDriver wd => wd [Text]
getElems =
  sequence . fmap (\id -> getElemText ("Overall_" <> id)) $ ids
  where
    getElemText id = findElem (ById id) >>= getText

profileID :: URL -> ID
profileID = drop 1 . dropWhile (/= '=')

getCache :: URL -> IO (Maybe [Text])
getCache url =
  let id = profileID url
  in
  doesFileExist (cacheFile id) >>= \exists ->
    if exists
    then do
      contents <- T.readFile (cacheFile id)
      pure (Just $ T.words contents)
    else pure Nothing

putCache :: URL -> [Text] -> IO ()
putCache url prof = do
  let contents = T.unwords prof
  createDirectoryIfMissing False cacheRoot
  T.writeFile (cacheFile . profileID $ url) contents

cacheFile :: ID -> FilePath
cacheFile = (cacheRoot <>)
