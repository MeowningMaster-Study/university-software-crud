module Main (main) where

import SQLConnection

main :: IO ()
main = do
    conn <- connectDB
    getDBName conn >>= print
    closeDB conn