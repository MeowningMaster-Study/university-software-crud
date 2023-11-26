-- Table for defining types of persons (student or teacher)
CREATE TABLE person_type (
    id INT PRIMARY KEY,
    name VARCHAR(255) COMMENT 'student | teacher'
);

-- Table for storing information about persons (students and teachers)
CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    person_type INT,
    FOREIGN KEY (person_type) REFERENCES person_type(id)
);

-- Table for storing information about software
CREATE TABLE software (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Table for storing information about events
CREATE TABLE event (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    date DATETIME
);

-- Table for defining types of events (seminar, demonstration, testing)
CREATE TABLE event_type (
    id INT PRIMARY KEY,
    name VARCHAR(255) COMMENT 'seminar | demonstration | testing'
);

-- Table for connecting software to its developers
CREATE TABLE developer (
    software_id INT,
    person_id INT,
    PRIMARY KEY (software_id, person_id),
    FOREIGN KEY (software_id) REFERENCES software(id),
    FOREIGN KEY (person_id) REFERENCES person(id)
);
