{-# LANGUAGE OverloadedStrings #-}
module Site.Posts.Brews.IO
  (
    fetchProfile
  )
where

import           Control.Concurrent (threadDelay)
import           Control.Monad.Trans.Class
import           Data.Text
import           Test.WebDriver
import           Test.WebDriver.Class
import           Test.WebDriver.Session

pageLoadSeconds = 1

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

fetchProfile :: String -> IO [Text]
fetchProfile url = do
  session <- runSession defaultConfig (openPage url >> getSession)
  threadDelay $ pageLoadSeconds * 1000000
  runWD session $ do
    elems <- getElems
    closeSession
    pure elems

getElems :: WebDriver wd => wd [Text]
getElems =
  sequence . fmap (\id -> getElemText ("Overall_" <> id)) $ ids
  where
    getElemText id = findElem (ById id) >>= getText
