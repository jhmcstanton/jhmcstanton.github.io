module Site.Posts.Literate.Compile
  (
    runghcPost
  )
  where

import System.Process.Typed

-- |Runs a literate haskell post
-- using locally installed packages.
runghcPost :: FilePath -> IO ()
runghcPost f = do
  let pconf = shell $ "stack runghc -- " ++ f
  withProcess pconf checkExitCode
  -- let pconf = proc "stack" ["runghc", "--", f]
  -- withProcess_ pconf (const $ pure ())
