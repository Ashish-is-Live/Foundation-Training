-- 1 Create Database (if not exists)


IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CareerHub')
BEGIN
    CREATE DATABASE CareerHub;
END;
GO

-- Use the CareerHub database
USE CareerHub;
GO

-- 2 Create Companies Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Companies')
BEGIN
    CREATE TABLE Companies (
        CompanyID INT PRIMARY KEY, 
        CompanyName VARCHAR(255) NOT NULL,
        Location VARCHAR(255) NOT NULL
    );
END;
GO

-- 3 Create Jobs Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Jobs')
BEGIN
    CREATE TABLE Jobs (
        JobID INT PRIMARY KEY,  
        CompanyID INT NOT NULL, 
        JobTitle VARCHAR(255) NOT NULL,
        JobDescription TEXT NOT NULL,
        JobLocation VARCHAR(255) NOT NULL,
        Salary DECIMAL(10,2) CHECK (Salary > 0),
        JobType VARCHAR(50) CHECK (JobType IN ('Full-time', 'Part-time', 'Contract')),
        PostedDate DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID) ON DELETE CASCADE
    );
END;
GO



-- 4 Create Applicants Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Applicants')
BEGIN
    CREATE TABLE Applicants (
        ApplicantID INT PRIMARY KEY,  -- Unique identifier for each applicant
        FirstName VARCHAR(100) NOT NULL,
        LastName VARCHAR(100) NOT NULL,
        Email VARCHAR(255) UNIQUE NOT NULL, -- Ensure unique emails
        Phone VARCHAR(20) UNIQUE NOT NULL, -- Ensure unique phone numbers
        Resume TEXT NOT NULL,
        Experience INT CHECK (Experience >= 0), -- Experience must be non-negative
        City VARCHAR(100),
        State VARCHAR(100)
    );
END;
GO

-- 5 Create Applications Table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Applications')
BEGIN
    CREATE TABLE Applications (
        ApplicationID INT PRIMARY KEY,  
        JobID INT NOT NULL, 
        ApplicantID INT NOT NULL,  
        ApplicationDate DATETIME DEFAULT  GETDATE(),
        CoverLetter TEXT NOT NULL,
        FOREIGN KEY (JobID) REFERENCES Jobs(JobID) ON DELETE CASCADE,
        FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID) ON DELETE CASCADE
    );
END;
GO
select * from Applicants;
drop table Applicants;

select * from Companies;
-- 7. Insert Sample Data into Companies
INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(1, 'TCS', 'Mumbai'),
(2, 'Infosys', 'Bangalore'),
(3, 'Wipro', 'Pune'),
(4, 'HCL Technologies', 'Noida'),
(5, 'Tech Mahindra', 'Hyderabad');
GO

-- 8. Insert Sample Data into Jobs
INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType) VALUES
(101, 1, 'Software Engineer', 'Develop and maintain web applications.', 'Mumbai', 700000.00, 'Full-time'),
(102, 2, 'Data Analyst', 'Analyze and visualize business data.', 'Bangalore', 650000.00, 'Full-time'),
(103, 3, 'Cybersecurity Specialist', 'Monitor and secure network systems.', 'Pune', 800000.00, 'Full-time'),
(104, 4, 'Cloud Engineer', 'Manage cloud-based infrastructure.', 'Noida', 900000.00, 'Full-time'),
(105, 5, 'AI/ML Engineer', 'Develop machine learning models.', 'Hyderabad', 950000.00, 'Full-time');

GO
select * from Jobs;
-- 9. Insert Sample Data into Applicants
INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, Resume) VALUES
(1, 'Rohan', 'Sharma', 'rohan.sharma@example.com', '9876543210', 'Experienced software engineer with 3 years in web development.'),
(2, 'Sneha', 'Patel', 'sneha.patel@example.com', '9876543211', 'Data analyst with expertise in Python, SQL, and Power BI.'),
(3, 'Amit', 'Verma', 'amit.verma@example.com', '9876543212', 'Cybersecurity specialist with strong experience in network security.'),
(4, 'Pooja', 'Nair', 'pooja.nair@example.com', '9876543213', 'Cloud engineer skilled in AWS, Azure, and DevOps.'),
(5, 'Vikas', 'Reddy', 'vikas.reddy@example.com', '9876543214', 'AI/ML engineer with expertise in deep learning and NLP.');
GO
select * from Applications;
-- 10. Insert Sample Data into Applications
INSERT INTO Applications (ApplicationID, JobID, ApplicantID, CoverLetter) VALUES
(201, 101, 1, 'I am excited to apply for the Software Engineer role at TCS.'),
(202, 102, 2, 'I am passionate about data analysis and eager to join Infosys.'),
(203, 103, 3, 'I have experience in cybersecurity and would love to work at Wipro.'),
(204, 104, 4, 'Cloud computing is my expertise, and I am interested in HCL.'),
(205, 105, 5, 'AI/ML is my field of interest, and I would love to join Tech Mahindra.');

select * from Applications;

/**
5. Write an SQL query to count the number of applications received for each job listing in the
"Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all
jobs, even if they have no applications.
**/

SELECT Jobs.JobTitle,Jobs.JobID,COUNT(Applications.ApplicantID) AS TotalApplications FROM Jobs
LEFT JOIN Applications
ON Applications.JobID=Jobs.JobID
GROUP BY Jobs.JobID,Jobs.JobTitle;

/**
6 Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary
range. Allow parameters for the minimum and maximum salary values. Display the job title,
company name, location, and salary for each matching job.
**/

DECLARE @minSalary INT
SET @minSalary=30000

DECLARE @maxSalary INT
SET @maxSalary=800000

SELECT Jobs.JobTitle,Companies.CompanyName,Companies.Location,Jobs.Salary FROM Jobs
INNER JOIN Companies
ON Companies.CompanyID=Jobs.CompanyID
WHERE Jobs.Salary BETWEEN @minSalary AND @maxSalary;


/**
7. Write an SQL query that retrieves the job application history for a specific applicant. Allow a
parameter for the ApplicantID, and return a result set with the job titles, company names, and
application dates for all the jobs the applicant has applied to.


**/
DECLARE @ApplicantID INT = 1;  -- Set the desired applicant's ID

SELECT 
    Jobs.JobTitle, 
    Companies.CompanyName, 
    Applications.ApplicationDate
FROM Applications
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Applications.ApplicantID = @ApplicantID
ORDER BY Applications.ApplicationDate DESC;  


select * from Jobs;


/**
8. Create an SQL query that calculates and displays the average salary offered by all companies for
job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.


**/
SELECT Companies.CompanyID,Companies.CompanyName,AVG(jobs.Salary) AS AverageSalary FROM Companies
INNER JOIN Jobs
ON Companies.CompanyID=Jobs.CompanyID
WHERE Jobs.Salary>0
GROUP BY Companies.CompanyID,Companies.CompanyName;


/**
9. Write an SQL query to identify the company that has posted the most job listings. Display the
company name along with the count of job listings they have posted. Handle ties if multiple
companies have the same maximum count.

**/
INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType) VALUES
(106, 1, 'Software Engineer 2', 'Develop and maintain web applications.', 'Mumbai', 700000.00, 'Full-time');


SELECT TOP 1 WITH TIES Companies.CompanyName,COUNT(Jobs.JobID) AS jobsPosted FROM Companies
INNER JOIN Jobs
ON Companies.CompanyID=Jobs.CompanyID
GROUP BY Companies.CompanyID,Companies.CompanyName
ORDER BY jobsPosted DESC;


/**
10. Find the applicants who have applied for positions in companies located in 'CityX' and have at
least 3 years of experience.
**/

SELECT * FROM Applicants;

DECLARE @city VARCHAR(50) = 'Mumbai';

SELECT DISTINCT Applicants.ApplicantID, Applicants.FirstName, Applicants.LastName, Applicants.Email, Applicants.Experience
FROM Applicants
INNER JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID
WHERE Companies.Location = @city AND Applicants.Experience >= 3;


/**
11. Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.
**/
SELECT DISTINCT JobTitle 
FROM Jobs 
WHERE Salary BETWEEN 600000 AND 800000;

/**
12. Find the jobs that have not received any applications.
**/
SELECT * FROM Jobs
LEFT JOIN Applications
ON Applications.JobID=Jobs.JobID
WHERE Applications.JobID IS NULL;

/**
13. Retrieve a list of job applicants along with the companies they have applied to and the positions
they have applied for.

**/
SELECT 
    Applicants.ApplicantID, 
    Applicants.FirstName, 
    Applicants.LastName, 
    Applicants.Email, 
    Companies.CompanyName, 
    Jobs.JobTitle 
FROM Applications
INNER JOIN Applicants ON Applications.ApplicantID = Applicants.ApplicantID
INNER JOIN Jobs ON Applications.JobID = Jobs.JobID
INNER JOIN Companies ON Jobs.CompanyID = Companies.CompanyID;


/**

 14 Retrieve a list of companies along with the count of jobs they have posted, even if they have not
received any applications.
**/
SELECT Companies.CompanyID,Companies.CompanyName,COUNT(Jobs.JobID) AS TotalJobPosted FROM Companies
LEFT JOIN Jobs
ON Jobs.CompanyID=Companies.CompanyID
GROUP BY Companies.CompanyID,Companies.CompanyName


/**
15. List all applicants along with the companies and positions they have applied for, including those
who have not applied.

**/
SELECT 
    Applicants.ApplicantID, 
    Applicants.FirstName, 
    Applicants.LastName, 
    Applicants.Email, 
    Companies.CompanyName, 
    Jobs.JobTitle 
FROM Applicants
LEFT JOIN Applications ON Applicants.ApplicantID = Applications.ApplicantID
LEFT JOIN Jobs ON Applications.JobID = Jobs.JobID
LEFT JOIN Companies ON Jobs.CompanyID = Companies.CompanyID;



/**
16. Find companies that have posted jobs with a salary higher than the average salary of all jobs.

**/
SELECT * FROM Companies
INNER JOIN Jobs
ON Jobs.CompanyID=Companies.CompanyID
WHERE  JOBS.Salary>(SELECT AVG(Jobs.Salary) FROM Jobs)


/**
17. Display a list of applicants with their names and a concatenated string of their city and state.

**/


SELECT 
    ApplicantID, 
    FirstName + ' ' + LastName AS FullName, 
    City + ', ' + State AS Location 
FROM Applicants;


/**
18. Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.
**/
SELECT * FROM JOBS 
WHERE Jobs.JobTitle LIKE '%Developer%' OR Jobs.JobTitle LIKE '%Engineer%'


/**
19. Retrieve a list of applicants and the jobs they have applied for, including those who have not
applied and jobs without applicants.

**/
SELECT 
   *
FROM Applicants
FULL OUTER JOIN Applications ON Applications.ApplicantID = Applicants.ApplicantID
FULL OUTER JOIN Jobs ON Jobs.JobID = Applications.JobID;



/**
20. List all combinations of applicants and companies where the company is in a specific city and the
applicant has more than 2 years of experience. For example: city=Chennai
**/
SELECT * FROM Applicants
CROSS JOIN Companies
WHERE Applicants.Experience>2 AND Companies.Location='Mumbai';

select * from Applicants;