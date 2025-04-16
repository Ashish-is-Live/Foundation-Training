from dao.database_manager import DatabaseManager
from entity.model.company import Company
from entity.model.applicant import Applicant
from datetime import datetime

def main():
    db = DatabaseManager()
    db.initialize_database()

    while True:
        print("\n=== CareerHub Menu ===")
        print("1. Add Company")
        print("2. Post Job")
        print("3. Add Applicant")
        print("4. Apply for Job")
        print("5. View All Jobs")
        print("6. View Applications for a Job")
        print("7. Search Jobs by Salary Range")
        print("8. View All Companies")
        print("9. View All Applicants")
        print("10. Exit")

        choice = input("Enter choice: ")

        try:
            if choice == "1":
                company = Company(int(input("ID: ")), input("Name: "), input("Location: "))
                db.insert_company(company)
                print('company added successfully')

            elif choice == "2":
                company_id = int(input("Company ID: "))
                company = Company(company_id, "", "")
                job = company.post_job(
                    int(input("Job ID: ")), input("Title: "), input("Desc: "),
                    input("Location: "), float(input("Salary: ")),
                    input("Job Type: "), input("Deadline (YYYY-MM-DD): ")
                )
                db.insert_job_listing(job)
                print("job posted successfully")

            elif choice == "3":
                applicant = Applicant(
                    int(input("ID: ")), input("First: "), input("Last: "),
                    input("Email: "), input("Phone: "), input("Resume File Path: ")
                )
                db.insert_applicant(applicant)
                print('Applicant added successfully')

            elif choice == "4":
                applicant_id = int(input("Applicant ID: "))
                job_id = int(input("Job ID: "))
                cover = input("Cover Letter: ")
                app = Applicant(applicant_id, "", "", "a@a.com", "123", "resume.txt").apply_for_job(job_id, cover)
                db.insert_job_application(app)
                print('applied for job successfully')

            elif choice == "5":
                
                for job in db.get_job_listings():
                    print(job)
                    print('jobs fetched successfully')

            elif choice == "6":
                job_id = int(input("Enter JobID: "))
                for app in db.get_applications_for_job(job_id):
                    print(app)
                print('Applicants fetched successfully')
                

            elif choice == "7":
                min_sal = float(input("Min Salary: "))
                max_sal = float(input("Max Salary: "))
                for job in db.get_jobs_by_salary_range(min_sal, max_sal):
                    print(job)
                print('job fetched successfully')

            elif choice == "8":
                for company in db.get_companies():
                    print(company)
                print('companies fetched successfully')

            elif choice == "9":
                for applicant in db.get_applicants():
                    print(applicant)
                print('Applicants fetched successfully')

            elif choice == "10":
                print("Exited from system successfully")
                break
            
            

        except Exception as e:
            print(" Error:", e)

if __name__ == "__main__":
    main()
