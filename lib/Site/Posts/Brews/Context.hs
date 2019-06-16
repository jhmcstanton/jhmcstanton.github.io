module Site.Posts.Brews.Context
  (
    addWaterProfile
  )
where

import           Site.Posts.Brews.IO

import           Control.Monad
import           Data.Text
import           Hakyll

addWaterProfile :: Identifier -> Compiler (Context b)
addWaterProfile identifier = do
  prof <- getWaterProfile identifier
  pure $ addWaterProfile' prof

getWaterProfile :: Identifier -> Compiler (Maybe WaterProfile)
getWaterProfile ident = do
  metadata <- getMetadata ident
  let url  = lookupString "water_profile_url" metadata
  sequence $ fmap fetchComponents url

type WaterProfile = [Double]

fetchComponents :: String -> Compiler WaterProfile
fetchComponents url = unsafeCompiler dirtyIOProfile where
  dirtyIOProfile = do
    ts <- fetchProfile url
    pure $ fmap (read . unpack) ts

addWaterProfile' m = maybe mempty addProf m where
  elem = field "element" $ \item -> pure (itemBody item)
  items = sequence . fmap (makeItem . show)
  addProf xs = listField "water_profile" elem (items xs)

