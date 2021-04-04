module WalkDir (listFilesDirFiltered) where

import Data.Foldable (traverse_)
import Data.List
import System.Directory.Tree
  ( AnchoredDirTree (..),
    DirTree (..),
    filterDir,
    readDirectoryWith,
  )
import System.FilePath (takeExtension)
import System.IO (readFile)

listFilesDirFiltered :: IO ()
listFilesDirFiltered = do
  _ :/ tree <- readDirectoryWith return "../target"
  traverse_ scanFile $ filterDir myPred tree
  where
    myPred (Dir ('.' : _) _) = False
    myPred (File n _) = takeExtension n == ".txt"
    myPred _ = True

scanFile :: FilePath -> IO ()
scanFile f = do
  file <- readFile f
  lines <- return $ zip [1 ..] (lines file)
  let filteredLines = [l | l <- lines, "debugger" `isInfixOf` snd l]
  print ((0, f) : filteredLines)
