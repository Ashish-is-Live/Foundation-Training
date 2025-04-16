from abc import ABC, abstractmethod

class DatabaseInterface(ABC):

    @abstractmethod
    def initialize_database(self): pass

    @abstractmethod
    def insert_job_listing(self, job): pass

    @abstractmethod
    def insert_company(self, company): pass

    @abstractmethod
    def insert_applicant(self, applicant): pass

    @abstractmethod
    def insert_job_application(self, application): pass

    @abstractmethod
    def get_job_listings(self): pass

    @abstractmethod
    def get_companies(self): pass

    @abstractmethod
    def get_applicants(self): pass

    @abstractmethod
    def get_applications_for_job(self, job_id): pass

    @abstractmethod
    def get_jobs_by_salary_range(self, min_salary, max_salary): pass
