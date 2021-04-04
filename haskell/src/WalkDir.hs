module WalkDir (listFilesDirFiltered) where

import Data.Foldable (traverse_)
import System.Directory.Tree
  ( AnchoredDirTree (..),
    DirTree (..),
    filterDir,
    readDirectoryWith,
  )
import System.FilePath (takeExtension)

listFilesDirFiltered = do
  _ :/ tree <- readDirectoryWith return "../target"
  traverse_ print $ filterDir myPred tree
  where
    myPred (Dir ('.' : _) _) = False
    myPred (File n _) = takeExtension n == ".png"
    myPred _ = True
