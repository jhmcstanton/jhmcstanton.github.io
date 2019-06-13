module Site.Posts.Brews.IO
  (
    fetchProfile,
    fetchPage, -- TODO remove this export
    filterTable -- TODO remove this export
  )
where

import           Control.Lens
import qualified Data.ByteString.Lazy as BS
import           Network.Wreq
import           Text.HTML.TagSoup

import           Site.Posts.Brews.Types

fetchProfile :: String -> IO WaterProfile
fetchProfile = undefined

fetchPage :: String -> IO BS.ByteString
fetchPage url = do
  response <- get url
  if response ^?! responseStatus . statusCode /= 200
  then error $ "Yo, url is broken! " ++ url
  else pure $ response ^?! responseBody

justProfile :: BS.ByteString -> Tag BS.ByteString
justProfile body = undefined
  where
    table = takeWhile (~/= "<br>") . dropWhile (~/= "<a name=section_OverallWater>") $ soup
    soup = parseTagsOptions parseOptionsFast body

filterTable :: [Tag BS.ByteString] -> [Tag BS.ByteString]
filterTable tags =
  enclosingTable -- takeWhile (~/= "<br>") .
  where
    enclosingTable = takeWhile (~/= "</table>") . dropWhile (~/= "<a name=section_OverallWater>") $ tags
