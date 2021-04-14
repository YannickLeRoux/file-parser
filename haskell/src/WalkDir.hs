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

listFilesDirFiltered :: String -> IO ()
listFilesDirFiltered path = do
  _ :/ tree <- readDirectoryWith return path
  traverse_ scanFile $ filterDir myPred tree
  putStrLn "Done."
  where
    myPred (Dir ('.' : _) _) = False
    myPred (File n _) = takeExtension n `elem` [".txt", ".js", ".jsx", ".ts", ".tsx"]
    myPred _ = True

scanFile :: FilePath -> IO ()
scanFile f = do
  file <- readFile f
  let parsedLines = zip [1 ..] (lines file)
  targetedWords <- readFile "../words.txt"
  let filteredLines = [l | l <- parsedLines, any (\w -> w `isInfixOf` snd l) (lines targetedWords)]
  print ((0, f) : filteredLines)
