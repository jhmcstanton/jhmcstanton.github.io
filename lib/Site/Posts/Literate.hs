module Site.Posts.Literate
  (
    module Diagrams.Prelude
  , module Diagrams.Backend.SVG
  , ResourceMode(..)
  , getArgs
  , resourceHandle
  , unsafeResourceHandle
  , unsafeWriteHandle
  , writeHandle
  )
  where

import Diagrams.Prelude
import Diagrams.Backend.SVG
import Diagrams.Backend.SVG.CmdLine
import System.Environment
import System.IO

-- |Analagous to a 'System.IO.IOMode', but only
-- supports write and append modes.
data ResourceMode = RWriteMode | RAppendMode

resourceToIOMode :: ResourceMode -> IOMode
resourceToIOMode RWriteMode  = WriteMode
resourceToIOMode RAppendMode = AppendMode

-- |Returns an open file 'System.IO.Handle' in 'Write' mode to the provided path.
-- Any directories missing in the path will be created.
unsafeWriteHandle :: FilePath -> Handle
unsafeWriteHandle = unsafeResourceHandle RWriteMode

-- |Returns a file 'System.IO.Handle' in the specified 'ResourceMode' at the
-- provided path. Any directories missing in the path will be created.
unsafeResourceHandle :: ResourceMode -> FilePath -> Handle
unsafeResourceHandle mode path =
  case resourceHandle mode path of
    Nothing -> error $ "Path: " ++ path ++ " already exists!"
    Just h  -> h

-- |Returns a 'Just System.IO.Handle' at the provided path.
-- Any directories missing in the path will be created.
writeHandle :: FilePath -> Maybe Handle
writeHandle = resourceHandle RWriteMode

-- |Returns a 'Just System.IO.Handle' in the specified 'ResourceMode' at
-- the provided path. Any directories missing in the path will be created.
resourceHandle :: ResourceMode -> FilePath -> Maybe Handle
resourceHandle mode path = undefined
