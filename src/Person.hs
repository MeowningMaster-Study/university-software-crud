module Person where

import qualified Data.Text as T (Text, pack)
import Database.MySQL.Base
import Data.Int (Int32)
import qualified Text.PrettyPrint as TPrettyP (Doc, render, text, vcat, (<>), ($+$))

import SQLConnection
import Table
import Converter

data PersonInfo = PersonInfo
  { tableName :: String,
    fieldNames :: [String],
    personIds :: [Int32],
    personNames :: [String],
    personTypeIds :: [Int32]
  }
  deriving (Show)

emptyPersonInstance :: PersonInfo
emptyPersonInstance =
  PersonInfo
    "Person"
    ["id", "name", "person_type"]
    []
    []
    []

instance Table PersonInfo where
  getName tableInfo = tableName tableInfo

  getFieldNames tableInfo =
    [fieldNames tableInfo !! 0 | not (null (personIds tableInfo))]
      ++ [fieldNames tableInfo !! 1 | not (null (personNames tableInfo))]
      ++ [fieldNames tableInfo !! 2 | not (null (personTypeIds tableInfo))]

  getFieldValues (PersonInfo _ _ ids names typeIds) =
    map MySQLInt32 ids
      ++ map (MySQLText . T.pack) names
      ++ map MySQLInt32 typeIds

  getMainFieldTables tableInfo =
    PersonInfo
      { tableName = tableName tableInfo,
        fieldNames = fieldNames tableInfo,
        personIds = [],
        personNames = names tableInfo,
        personTypeIds = []
      }

  isEmpty tableInfo =
    null (personIds tableInfo)
      || null (personNames tableInfo)
      || null (personTypeIds tableInfo)

  len tableInfo =
    fromEnum (not (null (personIds tableInfo)))
      + fromEnum (not (null (personNames tableInfo)))
      + fromEnum (not (null (personTypeIds tableInfo)))

  fromMySQLValues res = do
    vals <- res
    return
      PersonInfo
        { tableName = tableName emptyPersonInstance,
          fieldNames = fieldNames emptyPersonInstance,
          personIds = map myToInt32 (genStruct vals 0),
          personNames = map myToString (genStruct vals 1),
          personTypeIds = map myToInt32 (genStruct vals 2)
        }
