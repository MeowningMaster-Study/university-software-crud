module Main (main) where

import DB

main :: IO ()
main = do
    conn <- connectDB
    getDBName conn >>= print
    closeDB conn