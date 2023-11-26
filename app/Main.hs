module Main (main) where

import SQLConnection
import CheckTables

main :: IO ()
main = do
    conn <- connectDB
    getDBName conn >>= print
    checkAllTables conn
    closeDB conn