module Site.Posts.Literate
  (
    module Diagrams.Prelude
  , module Diagrams.Backend.SVG
  , ResourceMode(..)
  , getArgs
  , overwriteWithFile
  , withFile
  )
  where

import           Diagrams.Prelude
import           Diagrams.Backend.SVG
import           Diagrams.Backend.SVG.CmdLine
import           System.Directory
import           System.Environment
import           System.IO hiding (withFile)
import qualified System.IO as S

-- |Analagous to a 'System.IO.IOMode', but only
-- supports write and append modes.
data ResourceMode = RWriteMode | RAppendMode

resourceToIOMode :: ResourceMode -> IOMode
resourceToIOMode RWriteMode  = WriteMode
resourceToIOMode RAppendMode = AppendMode

overwriteWithFile :: FilePath -> (Handle -> IO r) -> IO r
overwriteWithFile f = withFile f RWriteMode

-- |Performs the provided operation on the file. If the parent
-- directories are missing they will be created as well.
withFile :: FilePath -> ResourceMode -> (Handle -> IO r) -> IO r
withFile p r op = do
  createDirectoryIfMissing True (parentDir p)
  let mode = resourceToIOMode r
  S.withFile p mode op

parentDir :: FilePath -> FilePath
parentDir = reverse . dropWhile (/= '/') . reverse
