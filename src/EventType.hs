module EventType where

import qualified Data.Text as T (Text, pack)
import Database.MySQL.Base
import Data.Int (Int32)

import SQLConnection
import Table
import Converter

data EventTypeInfo = EventTypeInfo
  { tableName :: String,
    fieldNames :: [String],
    eventTypeIds :: [Int32],
    eventTypeNames :: [String]
  }
  deriving (Show)

emptyEventTypeInstance :: EventTypeInfo
emptyEventTypeInstance =
  EventTypeInfo
    "EventType"
    ["id", "name"]
    []
    []

instance Table EventTypeInfo where
  getName tableInfo = tableName tableInfo

  getFieldNames tableInfo =
    [fieldNames tableInfo !! 0 | not (null (eventTypeIds tableInfo))]
      ++ [fieldNames tableInfo !! 1 | not (null (eventTypeNames tableInfo))]

  getFieldValues (EventTypeInfo _ _ ids names) =
    map MySQLInt32 ids
      ++ map (MySQLText . T.pack) names

  getMainFieldTables tableInfo =
    EventTypeInfo
      { tableName = tableName tableInfo,
        fieldNames = fieldNames tableInfo,
        eventTypeIds = ids tableInfo,
        eventTypeNames = names tableInfo
      }

  isEmpty tableInfo =
    null (eventTypeIds tableInfo)
      || null (eventTypeNames tableInfo)

  len tableInfo =
    fromEnum (not (null (eventTypeIds tableInfo)))
      + fromEnum (not (null (eventTypeNames tableInfo)))

  fromMySQLValues res = do
    vals <- res
    return
      EventTypeInfo
        { tableName = tableName emptyEventTypeInstance,
          fieldNames = fieldNames emptyEventTypeInstance,
          eventTypeIds = map myToInt32 (genStruct vals 0),
          eventTypeNames = map myToString (genStruct vals 1)
        }
