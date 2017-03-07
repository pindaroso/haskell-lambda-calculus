module Main where

import           Lib (eval, prog)

main = do
  print prog
  putStrLn "...evaluates to..."
  print $ eval prog
