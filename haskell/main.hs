import System.Directory

main :: IO ()
main = do
  files <- getDirectoryContents "../target"
  print files