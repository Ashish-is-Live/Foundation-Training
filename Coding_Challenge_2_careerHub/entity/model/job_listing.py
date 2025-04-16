from datetime import datetime
from exception.custom_exceptions import DeadlinePassedException
from entity.model.job_application import JobApplication

class JobListing:
    def __init__(self, job_id, company_id, title, description, location, salary, job_type, posted_date, deadline):
        self.job_id = job_id
        self.company_id = company_id
        self.title = title
        self.description = description
        self.location = location
        self.salary = salary
        self.job_type = job_type
        self.posted_date = posted_date
        self.deadline = deadline

    def apply(self, applicant_id, cover_letter):
        if datetime.now() > datetime.strptime(self.deadline, "%Y-%m-%d"):
            raise DeadlinePassedException("Deadline has passed.")
        return JobApplication(None, self.job_id, applicant_id, str(datetime.now()), cover_letter)

    def get_applicants(self, db):
        return db.get_applications_for_job(self.job_id)
