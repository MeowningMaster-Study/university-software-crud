module PersonType where

import qualified Data.Text as T (Text, pack)
import Database.MySQL.Base
import Data.Int (Int32)

import SQLConnection
import Table
import Converter

data PersonTypeInfo = PersonTypeInfo
  { tableName :: String,
    fieldNames :: [String],
    personTypeIds :: [Int32],
    personTypeNames :: [String]
  }
  deriving (Show)

emptyPersonTypeInstance :: PersonTypeInfo
emptyPersonTypeInstance =
  PersonTypeInfo
    "PersonType"
    ["id", "name"]
    []
    []

instance Table PersonTypeInfo where
  getName tableInfo = tableName tableInfo

  getFieldNames tableInfo =
    [fieldNames tableInfo !! 0 | not (null (personTypeIds tableInfo))]
      ++ [fieldNames tableInfo !! 1 | not (null (personTypeNames tableInfo))]

  getFieldValues (PersonTypeInfo _ _ ids typeNames) =
    map MySQLInt32 ids
      ++ map (MySQLText . T.pack) typeNames

  getMainFieldTables tableInfo =
    PersonTypeInfo
      { tableName = tableName tableInfo,
        fieldNames = fieldNames tableInfo,
        personTypeIds = ids tableInfo,
        personTypeNames = typeNames tableInfo
      }

  isEmpty tableInfo =
    null (personTypeIds tableInfo)
      || null (personTypeNames tableInfo)

  len tableInfo =
    fromEnum (not (null (personTypeIds tableInfo)))
      + fromEnum (not (null (personTypeNames tableInfo)))

  fromMySQLValues res = do
    vals <- res
    return
      PersonTypeInfo
        { tableName = tableName emptyPersonTypeInstance,
          fieldNames = fieldNames emptyPersonTypeInstance,
          personTypeIds = map myToInt32 (genStruct vals 0),
          personTypeNames = map myToString (genStruct vals 1)
        }
