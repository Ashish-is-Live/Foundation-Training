
-- Check if the 'Companies' table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Companies')
BEGIN
    CREATE TABLE Companies (
        CompanyID INT PRIMARY KEY,
        CompanyName VARCHAR(255),
        Location VARCHAR(255)
    );
END;

-- Check if the 'Jobs' table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Jobs')
BEGIN
    CREATE TABLE Jobs (
        JobID INT PRIMARY KEY,
        CompanyID INT,
        JobTitle VARCHAR(255),
        JobDescription TEXT,
        JobLocation VARCHAR(255),
        Salary DECIMAL(10, 2),
        JobType VARCHAR(50),
        PostedDate DATETIME,
        Deadline DATETIME,
        FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
    );
END;

-- Check if the 'Applicants' table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Applicants')
BEGIN
    CREATE TABLE Applicants (
        ApplicantID INT PRIMARY KEY,
        FirstName VARCHAR(100),
        LastName VARCHAR(100),
        Email VARCHAR(100),
        Phone VARCHAR(20),
        Resume VARCHAR(255)
    );
END;

-- Check if the 'Applications' table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Applications')
BEGIN
    CREATE TABLE Applications (
        ApplicationID INT PRIMARY KEY IDENTITY(1,1),  -- Corrected for SQL Server
        JobID INT,
        ApplicantID INT,
        ApplicationDate DATETIME,
        CoverLetter TEXT,
        FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
        FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
    );
END;

-- Check if the 'Meta' table exists, otherwise create it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Meta')
BEGIN
    CREATE TABLE Meta (
        Initialized BIT
    );
    INSERT INTO Meta (Initialized) VALUES (1);
END;

