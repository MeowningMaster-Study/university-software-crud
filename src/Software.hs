module Software where

import qualified Data.Text as T (Text, pack)
import Database.MySQL.Base
import Data.Int (Int32)

import SQLConnection
import Table
import Converter

data SoftwareInfo = SoftwareInfo
  { tableName :: String,
    fieldNames :: [String],
    softwareIds :: [Int32],
    softwareNames :: [String]
  }
  deriving (Show)

emptySoftwareInstance :: SoftwareInfo
emptySoftwareInstance =
  SoftwareInfo
    "Software"
    ["id", "name"]
    []
    []

instance Table SoftwareInfo where
  getName tableInfo = tableName tableInfo

  getFieldNames tableInfo =
    [fieldNames tableInfo !! 0 | not (null (softwareIds tableInfo))]
      ++ [fieldNames tableInfo !! 1 | not (null (softwareNames tableInfo))]

  getFieldValues (SoftwareInfo _ _ ids names) =
    map MySQLInt32 ids
      ++ map (MySQLText . T.pack) names

  getMainFieldTables tableInfo =
    SoftwareInfo
      { tableName = tableName tableInfo,
        fieldNames = fieldNames tableInfo,
        softwareIds = ids tableInfo,
        softwareNames = names tableInfo
      }

  isEmpty tableInfo =
    null (softwareIds tableInfo)
      || null (softwareNames tableInfo)

  len tableInfo =
    fromEnum (not (null (softwareIds tableInfo)))
      + fromEnum (not (null (softwareNames tableInfo)))

  fromMySQLValues res = do
    vals <- res
    return
      SoftwareInfo
        { tableName = tableName emptySoftwareInstance,
          fieldNames = fieldNames emptySoftwareInstance,
          softwareIds = map myToInt32 (genStruct vals 0),
          softwareNames = map myToString (genStruct vals 1)
        }
