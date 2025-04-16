from util.db_conn_util import DBConnUtil
from exception.custom_exceptions import NegativeSalaryException
from dao.database_interface import DatabaseInterface
import os
from datetime import datetime
class DatabaseManager(DatabaseInterface):
    def __init__(self):
        self.conn = DBConnUtil.get_connection("db_config.properties")
        self.cursor = self.conn.cursor()

   
    def initialize_database(self):
        try:
            # Check if Meta table exists (i.e., DB initialized)
            self.cursor.execute("""
                IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Meta')
                SELECT 1 ELSE SELECT 0
            """)
            already_initialized = self.cursor.fetchone()[0]

            if already_initialized:
                print("Database already initialized.")
                return  # Skip running schema again

            # Otherwise, run schema.sql
            base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
            schema_path = os.path.join(base_dir, "schema.sql")

            with open(schema_path, "r") as f:
                sql_script = f.read()

            for stmt in sql_script.strip().split("GO"):
                if stmt.strip():
                    self.cursor.execute(stmt)
            self.conn.commit()
            print("Database initialized successfully.")
        except Exception as e:
            self.conn.rollback()
            print(f"Error initializing the database: {e}")
            raise e

    def insert_job_listing(self, job):
        year, month, day = map(int, job.deadline.split('-'))
        deadline=datetime(year,month,day)
        PostedDate=datetime.now()
        if job.salary < 0:
            raise NegativeSalaryException("Salary cannot be negative.")
        query = """INSERT INTO Jobs (JobID, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate, Deadline)
                   VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"""
        self.cursor.execute(query, (job.job_id, job.company_id, job.title, job.description, job.location,
                                    job.salary, job.job_type, PostedDate,deadline ))
        self.conn.commit()

    def insert_company(self, company):
        self.cursor.execute("INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES (?, ?, ?)",
                            (company.company_id, company.name, company.location))
        self.conn.commit()

    def insert_applicant(self, applicant):
        query = """INSERT INTO Applicants (ApplicantID, FirstName, LastName, Email, Phone, Resume)
                   VALUES (?, ?, ?, ?, ?, ?)"""
        self.cursor.execute(query, (applicant.applicant_id, applicant.first_name, applicant.last_name,
                                    applicant.email, applicant.phone, applicant.resume))
        self.conn.commit()

    def insert_job_application(self, application):
        ApplicationDate=datetime.now()
        query = """INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, CoverLetter)
                   VALUES (?, ?, ?, ?)"""
        self.cursor.execute(query, (application.job_id,application.applicant_id, ApplicationDate,
                                     application.cover_letter))
        self.conn.commit()

    def get_job_listings(self):
        self.cursor.execute("SELECT * FROM Jobs")
        return self.cursor.fetchall()

    def get_jobs_by_salary_range(self, min_salary, max_salary):
        self.cursor.execute("""SELECT j.JobTitle, c.CompanyName, j.Salary
                               FROM Jobs j JOIN Companies c ON j.CompanyID = c.CompanyID
                               WHERE j.Salary BETWEEN ? AND ?""", (min_salary, max_salary))
        return self.cursor.fetchall()

    def get_applications_for_job(self, job_id):
        self.cursor.execute("SELECT * FROM Applications WHERE JobID = ?", (job_id,))
        return self.cursor.fetchall()

    def get_companies(self):
        self.cursor.execute("SELECT * FROM Companies")
        return self.cursor.fetchall()

    def get_applicants(self):
        self.cursor.execute("SELECT * FROM Applicants")
        return self.cursor.fetchall()
