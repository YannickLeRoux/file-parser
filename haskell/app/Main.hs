module Main where

import System.Environment
import WalkDir

main :: IO ()
main = do
  args <- getArgs
  listFilesDirFiltered $ head args