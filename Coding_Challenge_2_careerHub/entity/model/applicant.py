import os
from exception.custom_exceptions import InvalidEmailException, ResumeFileException
from entity.model.job_application import JobApplication
from datetime import datetime

class Applicant:
    def __init__(self, applicant_id, first_name, last_name, email, phone, resume):
        if '@' not in email:
            raise InvalidEmailException("Invalid email format.")
        # if not os.path.exists(resume):
        #     raise ResumeFileException("Resume file not found.")
        self.applicant_id = applicant_id
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.phone = phone
        self.resume = resume

    def apply_for_job(self, job_id, cover_letter):
        return JobApplication(None, job_id, self.applicant_id, str(datetime.now()), cover_letter)

    def create_profile(self):
        return {
            "id": self.applicant_id,
            "name": f"{self.first_name} {self.last_name}",
            "email": self.email,
            "phone": self.phone
        }
