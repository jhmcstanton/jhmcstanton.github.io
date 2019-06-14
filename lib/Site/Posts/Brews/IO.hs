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

type TagFound = Bool

tableContents :: [Tag BS.ByteString] -> [Tag BS.ByteString]
tableContents tags = reverse contents where
  (_, contents) = foldr acc (False, []) tags
  ids' = fmap ("Overall_" ++ ) ids
  acc :: Tag BS.ByteString -> (TagFound, [Tag BS.ByteString]) -> (TagFound, [Tag BS.ByteString])
  acc found (True, acc) = (False, found : acc)
  acc tag (False, acc)
    | any (\id -> tag ~== ("<span id=" ++ id ++ ">")) ids' = (True, acc)
    | otherwise = (False, acc)
