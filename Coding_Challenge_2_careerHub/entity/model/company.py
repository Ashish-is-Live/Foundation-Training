from entity.model.job_listing import JobListing
from datetime import datetime

class Company:
    def __init__(self, company_id, name, location):
        self.company_id = company_id
        self.name = name
        self.location = location

    def post_job(self, job_id, title, description, location, salary, job_type, deadline):
        return JobListing(job_id, self.company_id, title, description, location, salary, job_type, str(datetime.now()), deadline)

    def get_jobs(self, db):
        return [job for job in db.get_job_listings() if job[1] == self.company_id]
