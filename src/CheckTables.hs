module CheckTables where

import Database.MySQL.Base

import Table
import Person
import PersonType
import Software
import Event
import EventType
import Developer
import SQLConnection

checkPersons :: MySQLConn -> IO ()
checkPersons conn = do
    res <- addValue (PersonInfo "person" ["id", "name", "person_type"] [] ["John"] [1]) conn
    print (res)

    res <- readAllValues emptyPersonInstance conn
    print (res)

    res <- readValue (PersonInfo "person" ["id", "name", "person_type"] [] ["John"] [1]) conn
    print res

    res <- updateValue (PersonInfo "person" ["id", "name", "person_type"] [] ["Jane"] [1]) (PersonInfo "person" ["id", "name", "person_type"] [] ["John"] [1]) conn
    print res

    res <- readAllValues emptyPersonInstance conn
    print res

    deleteValue (PersonInfo "person" ["id", "name", "person_type"] [] ["Jane"] [1]) conn
    print res

    res <- readAllValues emptyPersonInstance conn
    print res

checkPersonTypes :: MySQLConn -> IO ()
checkPersonTypes conn = do
    res <- addValue (PersonTypeInfo "person_type" ["id", "name"] [] ["Student"]) conn
    print (res)

    res <- readAllValues emptyPersonTypeInstance conn
    print (res)

    res <- readValue (PersonTypeInfo "person_type" ["id", "name"] [] ["Student"]) conn
    print res

    res <- updateValue (PersonTypeInfo "person_type" ["id", "name"] [] ["Teacher"]) (PersonTypeInfo "person_type" ["id", "name"] [] ["Student"]) conn
    print res

    res <- readAllValues emptyPersonTypeInstance conn
    print res

    deleteValue (PersonTypeInfo "person_type" ["id", "name"] [] ["Teacher"]) conn
    print res

    res <- readAllValues emptyPersonTypeInstance conn
    print res

checkSoftware :: MySQLConn -> IO ()
checkSoftware conn = do
    res <- addValue (SoftwareInfo "software" ["id", "name"] [] ["App1"]) conn
    print (res)

    res <- readAllValues emptySoftwareInstance conn
    print (res)

    res <- readValue (SoftwareInfo "software" ["id", "name"] [] ["App1"]) conn
    print res

    res <- updateValue (SoftwareInfo "software" ["id", "name"] [] ["App2"]) (SoftwareInfo "software" ["id", "name"] [] ["App1"]) conn
    print res

    res <- readAllValues emptySoftwareInstance conn
    print res

    deleteValue (SoftwareInfo "software" ["id", "name"] [] ["App2"]) conn
    print res

    res <- readAllValues emptySoftwareInstance conn
    print res

checkEvents :: MySQLConn -> IO ()
checkEvents conn = do
    res <- addValue (EventInfo "event" ["id", "name", "date"] [] ["Event1"] ["2023-01-01 12:00:00"]) conn
    print (res)

    res <- readAllValues emptyEventInstance conn
    print (res)

    res <- readValue (EventInfo "event" ["id", "name", "date"] [] ["Event1"] ["2023-01-01 12:00:00"]) conn
    print res

    res <- updateValue (EventInfo "event" ["id", "name", "date"] [] ["Event2"] ["2023-01-02 14:00:00"]) (EventInfo "event" ["id", "name", "date"] [] ["Event1"] ["2023-01-01 12:00:00"]) conn
    print res

    res <- readAllValues emptyEventInstance conn
    print res

    deleteValue (EventInfo "event" ["id", "name", "date"] [] ["Event2"] ["2023-01-02 14:00:00"]) conn
    print res

    res <- readAllValues emptyEventInstance conn
    print res

checkEventTypes :: MySQLConn -> IO ()
checkEventTypes conn = do
    res <- addValue (EventTypeInfo "event_type" ["id", "name"] [] ["Seminar"]) conn
    print (res)

    res <- readAllValues emptyEventTypeInstance conn
    print (res)

    res <- readValue (EventTypeInfo "event_type" ["id", "name"] [] ["Seminar"]) conn
    print res

    res <- updateValue (EventTypeInfo "event_type" ["id", "name"] [] ["Workshop"]) (EventTypeInfo "event_type" ["id", "name"] [] ["Seminar"]) conn
    print res

    res <- readAllValues emptyEventTypeInstance conn
    print res

    deleteValue (EventTypeInfo "event_type" ["id", "name"] [] ["Workshop"]) conn
    print res

    res <- readAllValues emptyEventTypeInstance conn
    print res

checkDevelopers :: MySQLConn -> IO ()
checkDevelopers conn = do
    res <- addValue (DeveloperInfo "developer" ["software_id", "person_id"] [] [1] [1]) conn
    print (res)

    res <- readAllValues emptyDeveloperInstance conn
    print (res)

    res <- readValue (DeveloperInfo "developer" ["software_id", "person_id"] [] [1] [1]) conn
    print res

    res <- updateValue (DeveloperInfo "developer" ["software_id", "person_id"] [] [2] [2]) (DeveloperInfo "developer" ["software_id", "person_id"] [] [1] [1]) conn
    print res

    res <- readAllValues emptyDeveloperInstance conn
    print res

    deleteValue (DeveloperInfo "developer" ["software_id", "person_id"] [] [2] [2]) conn
    print res

    res <- readAllValues emptyDeveloperInstance conn
    print res

checkAllTables :: MySQLConn -> IO ()
checkAllTables conn = do 
    checkPersons conn
    checkPersonTypes conn
    checkSoftware conn
    checkEvents conn
    checkEventTypes conn
    checkDevelopers conn
