#  app/python/data_processing/job_posts/process_job_post.py

from app.python.ai_processing.job_description_extraction.train_job_description_extraction import (
    inspect_job_description_predictions,
)
from app.python.ai_processing.utils.logger import BLUE, RED, RESET


def process_job_post_descriptions(job_description):
    try:
        entity_data = inspect_job_description_predictions(job_description)

        if not entity_data:
            raise ValueError("Entity data is empty or None")


        description = entity_data.get('DESCRIPTION', [])
        responsibilities = entity_data.get('RESPONSIBILITIES', [])
        qualifications = entity_data.get('QUALIFICATIONS', [])

        credentials = entity_data.get('CREDENTIALS', [])
        education = entity_data.get('EDUCATION', [])
        experience = entity_data.get('EXPERIENCE', [])

        job_role = entity_data.get('JOB_ROLE', [])
        job_seniority = entity_data.get('JOB_SENIORITY', [])
        job_dept = entity_data.get('JOB_DEPT', [])
        job_team = entity_data.get('JOB_TEAM', [])

        commitment = entity_data.get('COMMITMENT', [])
        job_setting = entity_data.get('JOB_SETTING', [])

        job_country = entity_data.get('JOB_COUNTRY', [])
        job_city = entity_data.get('JOB_CITY', [])
        job_state = entity_data.get('JOB_STATE', [])

        compensation = entity_data.get('COMPENSATION', [])
        retirement = entity_data.get('RETIREMENT', [])
        office_life = entity_data.get('OFFICE_LIFE', [])
        professional_development = entity_data.get('PROFESSIONAL_DEVELOPMENT', [])
        wellness = entity_data.get('WELLNESS', [])
        parental = entity_data.get('PARENTAL', [])
        work_life_balance = entity_data.get('WORK_LIFE_BALANCE', [])
        visa_sponsorship = entity_data.get('VISA_SPONSORSHIP', [])
        additional_perks = entity_data.get('ADDITIONAL_PERKS', [])

        print(f"Description: {description}")
        print(f"Responsibilities: {responsibilities}")
        print(f"Qualifications: {qualifications}")
        print(f"Credentials: {credentials}")
        print(f"Education: {education}")
        print(f"Experience: {experience}")
        print(f"Job Role: {job_role}")
        print(f"Job Seniority: {job_seniority}")
        print(f"Job Department: {job_dept}")
        print(f"Job Team: {job_team}")
        print(f"Commitment: {commitment}")
        print(f"Job Setting: {job_setting}")
        print(f"Job Country: {job_country}")
        print(f"Job City: {job_city}")
        print(f"Job State: {job_state}")
        print(f"Compensation: {compensation}")
        print(f"Retirement: {retirement}")
        print(f"Office Life: {office_life}")
        print(f"Professional Development: {professional_development}")
        print(f"Wellness: {wellness}")
        print(f"Parental: {parental}")
        print(f"Work Life Balance: {work_life_balance}")
        print(f"Visa Sponsorship: {visa_sponsorship}")
        print(f"Additional Perks: {additional_perks}")
    except Exception as e:
        print(
            f"{RED}An error occurred during Google Sheet update for {e}{RESET}"
        )

job_description = """Your Impact: As a Senior Sales Director focused on EIQ's Workers Compensation & Disability product offerings, you are responsible for managing the entire sales life cycle from start to finish, including prospecting, identifying needs, presenting, defining solutions, establishing plans, structuring deals, and managing and growing our relationships with both prospects and customers within US and Canadian territories. You must be sales-driven, fast-moving, and have a strong customer focus. You are passionate about creating value for your customers, which ultimately leads to profitable business for both us and them. You know how to identify the right decision makers and influencers, how to listen, and how to ask the right questions. You have excellent communication skills--you know what to say and more importantly, how to say it.

About You:

A sophisticated sales executive who brings with them 10+ years of experience selling complex SaaS technology to enterprise accounts, in the worker’s comp insurance space, in a closing role, using a consultative approach to determine customer needs
A proven hunter who has consistently met or beaten quota
You're familiar and comfortable selling across stakeholders at multiple levels in an organization, communicating well with everyone from the business champion to the product user to the C-level executive
You can confidently and persuasively tell a compelling story and own the room
You have strong analytical skills and the ability to develop and run long-term account plans
You're comfortable in a startup environment that moves at a fast pace, with a direct, open, and honest culture; you care about getting the best answer, not about being right or wrong. You're motivated by results, not by your ego
You're naturally inquisitive and driven to dig deeper. You do the research and know how to uncover opportunities others miss
You're a team player and can work with our teams to find efficient paths to successful and profitable customers
You're motivated by overcoming challenges and pushing yourself harder when faced with adversity
You have the drive and personal accountability to own your results
You hold a BA/BS degree or equivalent
In This Role, You Will:

Effectively prospect, identify and drive a large number of sales opportunities through a typically complex enterprise sales cycle, from first contact to closure
Drive business growth by cultivating a network of executive level contacts and utilizing pre-call planning, post-call analysis and consistent follow-up
Lead the Evolution IQ relationship with prospects and internal stakeholders within enterprise accounts
Schedule, customize, and deliver sales presentations and manage meetings with our prospects' executives
Represent EvolutionIQ at conferences, educational forums, and other industry events
Utilize our CRM product to manage life cycle activity of each prospect and client
Collaborate with product management to refine product direction
Communicate progress and strategic priorities to the leadership team
Likely travel 10-20% of the time
Work-life, Culture & Perks:

Compensation: Competitive salary and meaningful equity. The base salary range for this role 175-200K+ (BoE) plus lucrative uncapped commission + company equity (stock options)
Well-Being: Full medical, dental, vision, short- & long-term disability, 401k matching. 100% of the employee contribution up to 3% and 50% of the next 2%
Work/Life Balance: Work from home / work from NYC (whether you’re local to NYC or visiting us on a company-paid trip), or join us at our annual company offsite
Home & Family: Flexible PTO, 100% paid parental leave (4 months for primary caregivers and 3 months for secondary caregivers), sick days, paid time off. For new parents returning to work we offer a flexible schedule. We also offer sleep training to help you and your family navigate life schedules with a newborn
We also have a flexible vacation policy and are closed for winter break at the end of the year
Office Life: Catered lunches, happy hours, and pet-friendly office space. $500 for your in home office setup and $200/year for upgrades every year after your initial setup
Growth & Training: $1,000/year for each employee for professional development, as well as upskilling opportunities internally
Sponsorship: We are open to sponsoring candidates currently in the U.S. who need to transfer their active H1-B visa"""



# from app.python.ai_processing.salary_extraction.train_salary_extraction import (
#     inspect_salary_model_predictions,
# )

# def process_job_salary(job_description):
#     try:
#         _, biluo_tags = inspect_salary_model_predictions(job_description)
#         job_description = [
#             token.ent_type_ for token, tag in zip(_, biluo_tags) if tag != "O"
#         ]

#         print(f"{job_description}")

#         job_description_str = ", ".join(set(job_description))

#         print(
#             f"{BLUE}Job description found for {job_description}: {job_description_str}{RESET}"
#         )
#     except Exception as e:
#         print(
#             f"{RED}An error occurred during Google Sheet update for {job_description}: {e}{RESET}"
#         )


if __name__ == "__main__":
    process_job_post_descriptions(job_description)
