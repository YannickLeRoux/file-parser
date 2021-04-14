module WalkDir (listFilesDirFiltered) where

import Control.Monad (unless)
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

targetedWords :: [String]
targetedWords =
  ["debugger", "it.only("]

targetedExtensions :: [String]
targetedExtensions =
  [".js", ".jsx", ".ts", ".tsx"]

listFilesDirFiltered :: String -> IO ()
listFilesDirFiltered path = do
  putStrLn "Started..."
  _ :/ tree <- readDirectoryWith return path
  traverse_ scanFile $ filterDir myPred tree
  putStrLn "Done."
  where
    myPred (Dir ('.' : _) _) = False
    myPred (Dir "node_modules" _) = False
    myPred (Dir "coverage" _) = False
    myPred (File n _) = takeExtension n `elem` targetedExtensions
    myPred _ = True

scanFile :: FilePath -> IO ()
scanFile f = do
  file <- readFile f
  let parsedLines = zip [1 ..] (lines file)
  let filteredLines = [l | l <- parsedLines, any (\w -> w `isInfixOf` snd l) targetedWords]
  unless (null filteredLines) $ print ((0, f) : filteredLines)
