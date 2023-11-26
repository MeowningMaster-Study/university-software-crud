module Event where

import qualified Data.Text as T (Text, pack)
import Database.MySQL.Base
import Data.Int (Int32)

import SQLConnection
import Table
import Converter

data EventInfo = EventInfo
  { tableName :: String,
    fieldNames :: [String],
    eventIds :: [Int32],
    eventNames :: [String],
    eventDates :: [String]
  }
  deriving (Show)

emptyEventInstance :: EventInfo
emptyEventInstance =
  EventInfo
    "Event"
    ["id", "name", "date"]
    []
    []
    []

instance Table EventInfo where
  getName tableInfo = tableName tableInfo

  getFieldNames tableInfo =
    [fieldNames tableInfo !! 0 | not (null (eventIds tableInfo))]
      ++ [fieldNames tableInfo !! 1 | not (null (eventNames tableInfo))]
      ++ [fieldNames tableInfo !! 2 | not (null (eventDates tableInfo))]

  getFieldValues (EventInfo _ _ ids names dates) =
    map MySQLInt32 ids
      ++ map (MySQLText . T.pack) names
      ++ map (MySQLText . T.pack) dates

  getMainFieldTables tableInfo =
    EventInfo
      { tableName = tableName tableInfo,
        fieldNames = fieldNames tableInfo,
        eventIds = ids tableInfo,
        eventNames = names tableInfo,
        eventDates = dates tableInfo
      }

  isEmpty tableInfo =
    null (eventIds tableInfo)
      || null (eventNames tableInfo)
      || null (eventDates tableInfo)

  len tableInfo =
    fromEnum (not (null (eventIds tableInfo)))
      + fromEnum (not (null (eventNames tableInfo)))
      + fromEnum (not (null (eventDates tableInfo)))

  fromMySQLValues res = do
    vals <- res
    return
      EventInfo
        { tableName = tableName emptyEventInstance,
          fieldNames = fieldNames emptyEventInstance,
          eventIds = map myToInt32 (genStruct vals 0),
          eventNames = map myToString (genStruct vals 1),
          eventDates = map myToString (genStruct vals 2)
        }
