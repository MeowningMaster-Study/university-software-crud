module Developer where

import Database.MySQL.Base
import Data.Int (Int32)

import SQLConnection
import Table
import Converter

data DeveloperInfo = DeveloperInfo
  { tableName :: String,
    fieldNames :: [String],
    softwareIds :: [Int32],
    personIds :: [Int32]
  }
  deriving (Show)

emptyDeveloperInstance :: DeveloperInfo
emptyDeveloperInstance =
  DeveloperInfo
    "Developer"
    ["software_id", "person_id"]
    []
    []

instance Table DeveloperInfo where
  getName tableInfo = tableName tableInfo

  getFieldNames tableInfo =
    [fieldNames tableInfo !! 0 | not (null (softwareIds tableInfo))]
      ++ [fieldNames tableInfo !! 1 | not (null (personIds tableInfo))]

  getFieldValues (DeveloperInfo _ _ softwareIds personIds) =
    map MySQLInt32 softwareIds
      ++ map MySQLInt32 personIds

  getMainFieldTables tableInfo =
    DeveloperInfo
      { tableName = tableName tableInfo,
        fieldNames = fieldNames tableInfo,
        softwareIds = softwareIds tableInfo,
        personIds = personIds tableInfo
      }

  isEmpty tableInfo =
    null (softwareIds tableInfo)
      || null (personIds tableInfo)

  len tableInfo =
    fromEnum (not (null (softwareIds tableInfo)))
      + fromEnum (not (null (personIds tableInfo)))

  fromMySQLValues res = do
    vals <- res
    return
      DeveloperInfo
        { tableName = tableName emptyDeveloperInstance,
          fieldNames = fieldNames emptyDeveloperInstance,
          softwareIds = map myToInt32 (genStruct vals 0),
          personIds = map myToInt32 (genStruct vals 1)
        }
