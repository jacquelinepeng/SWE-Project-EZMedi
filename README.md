# SWE-Project
## Project Proposal
**Project Title:** EZMedi - an iOS application that combines medicine search and daily reminder

**Project Description:**\
Allow people to identify medicines by scanning the barcode using their phone camera or by inputting the name of the medicine. By accessing the open-source medicine database RxNorm, the application should be able to present the user with medicine descriptions and instructions for medication usage after the search. The application should grab data like name, usage, dosage, and NDC from the database and present it to the user. Then the user could choose to add the medicine to their medicine library. The user could be able to edit or delete the medicine library on the profile page and set daily reminders for the medicine.

**Project Objectives:**\
Develop user-friendly applications aimed at assisting individuals with specific symptoms or diseases in maintaining a regular and effective medication intake process. Remind patients to have their medicine on time.

**Business Goals:**\
Develop a reliable and user-friendly system that allows users to identify their medications through barcode scanning and give users some basic instructions about certain medications. 
It will also facilitate the process of remembering to take said medications through an effective reminder system that reduces the possibility of missing dosages, which ensures the effectiveness of treatment.\
Revenue Generation Strategies: Consider offering in-app purchases for extended library capacity and numbers of reminders. 

Potential partnerships: Cooperate with medicine companies, pharmacies, and healthcare providers to provide better user service.

User Acquisition and Retention: Ensure a smooth UI experience for the users and maintain an easy and effective way of the functionalities. Continuously update the application with the RxNorm database so that the database contains the most up-to-date medication information. Use promotion to attract targeted users.

Global Expansion: Develop app localization to gain global users by providing content in multiple languages in the future. Convey research and questionnaires to identify regions with high demand for medicine management and reminder service applications.

**Main Features:**\
User Authentication: 
1. Login Page with email and password verification
2. Register Page and user could register with email, username and password

Medicine barcode Identification: Barcode scanning using the camera and user could choose to add the corresponding medicine to the personal medicine library.

Medicine Search: Link with RxNorm API and get up-to-date medicine information from the open source database. The user could search the medicine through inputting the medicine name in the search bar, and the user could choose to add the searched medicine to the medicine Library.

Personal Medicine Profile: Stores the medicine that the user chose to add to their profile. Able to edit, delete and add medication.

Medicine Reminders: Opting in for medication reminder and entry of details, setting the time for taking the medication and the application will push notification on time.

**Expected Values:**\
Expectation: Developing user friendly applications that could help the user with certain symptoms or diseases to maintain regular and effective medication take-in process, which could help reduce or delay the progression of symptoms. Satisfies overall 95% Positive rating.\
Metrices: Conduct usability testing, Regularly release User Satisfaction Survey

Expectation: Accuracy and Relevance of Search Results (Over 98% correctness)\
Metrices: 
Regularly update the RxNorm database we connected to and update license for National library of medicine
Optimize fuzzy search algorithm
In surveys collect user feedback on the relevance of search

Expectation: A reduction in healthcare costs caused by non-adherence to medication properly and increased healthcare provider visits.\
Metrices: Cooperate with healthcare providers institution and pharmacies and follow up the National pharmaceutical budget

Expectation: Follow security requirements relevant data protection regulations with 99.9% safety\
Metrices: Compliance with medical information regulations such as HIPAA. 

Expectation: Increase users’ awareness of their own health and the understanding of medicines.\
Metrices: Offer user with correct medicine information and Count users’ medication frequency

**Scope:**\
The system is primarily intended to connect users with a list of their own medications and reminders. It is not meant to be integrated with other health providers at this stage or utilized for healthcare providers’ own records.\
The project governance will be overseen by the development team, key stakeholders, and decision-makers. The ultimate decision authority rests with the Project Manager. When the project satisfied all the user requirements and passed 99% of the testing, the project would be regarded as finished.\
It will manufacture a mobile application on iOS and provide user manuals, technical documentation. It will integrate with Firebase and RxNorm databases, also with security standards documentations.

**Stakeholders:**\
Users: Patients with chronic diseases who will use the system.\
Software Developers: Those responsible for designing, coding, and maintaining the application.\
Health Organization and Pharmacies: We could cooperate with them and follow up the user’s medication.

**Constraints:**\
The system should be developed within 4 months. Handled with developing a complete plan with certain deadlines and regularly conducts system development and organizes team meetings.\
The system should be operational 24/7 to ensure that customers consistently receive their reminders and have constant access to their medication database. The system should ensure that unauthorized users can not access confidential patient information. Both are handled by using Google Firebase (24/7 database) to store user information and protect their privacy.\
Low budget given that the application is being developed by a student group,which requires effective resource allocation, prioritizing essential features to develop a minimum viable product. Handled by using open-source tools and cost-effective platforms like Google Firebase to reduce development costs significantly. To offset financial limitations, the project can explore crowdfunding, seek grants, and form partnerships with healthcare entities.

**Risks:**\
Data Privacy: Breaches in confidential patient information. A way to mitigate this is robust data encryption and compliance with medical information regulations such as HIPAA.\
Budget Risks: Being over budget and falling short on revenue. This can be mitigated through careful financial planning and considering revenue outlets such as partnerships, attract investment, and user subscriptions.

**Approach:**\
The project will adopt the waterfall approach for system development, following the structure of gathering requirements, design, development, testing, deployment, and maintenance over a specific timeline. The waterfall approach enables the project team to execute the development process within a minimal timeframe, as it has clear deadlines at each phase, reducing the likelihood of conducting iterative revisions that can extend project timelines.

**Project Team:** 
Jacqueline Peng, jp5982\
Zhuotong Xie, zx1370\
Feiluan Feng, ff2171\
Sally Kattab, sk8850

**Project Timeline:**\
September 19th - Brainstorming and Project Proposal Phase
- Milestone: Finalize the project idea and scope.
- Deliverables: A complete project proposal, including the project name, business goals, and a summary of main features, following the system request template.

October 12th - Requirements Gathering Phase
- Milestone: Comprehensive understanding of project requirements.
- Deliverables: A detailed Software Requirements Specifications document, providing both functional and non-functional requirements of the software system.
November 7th - Design Phase
- Milestone 1: Define primary use cases.
- Deliverable: Detailed design for three primary use cases, including implementation and testing plans. Designing corresponding System Sequence Diagrams that clearly depict the interactions between the users and the system, one domain model, operation contracts, and UML Interaction Diagram that visualizes the interactions between objects during the execution of the selected operation.
- Milestone 2: Initiate user interface design.
- Deliverable: Preliminary designs for the user interface.
- Milestone 3: Establish database access.
- Deliverable: Application and approval for RxNorm database access.
November 28th - Development and Testing Phase
- Milestone 1: Application Development
- Deliverables: Decide the programming languages, integrated development environments (IDEs), and other necessary tools for application development. Execution of the implementation as outlined in the project workplan, ensuring alignment with the design and requirements. Development of a comprehensive test plan for the system, detailing scope, approach, objectives, resources, and schedule. This plan should clearly identify the specific use cases to be tested, the responsible parties for testing, define pass/fail criteria, and establish the testing schedule. Implementation of the system according to the planned models, with a focus on ensuring that at least the three significant use cases are fully functional. Continuous updating and maintenance of all source code and scripts on the GitHub repository.
- Milestone 2: Conduct Testing
- Deliverables: Design of test cases for the significant functionalities, covering both typical and potential alternate scenarios. Rigorous testing of the system to confirm alignment with the specified requirements. Thorough analysis and tracing of the root causes of any issues encountered during testing, along with strategies and actions taken to resolve them.

**Budget:**\
$0\
Free for limited users: Google Firebase\
Open Source free medication database: RxNorm

**Approval:**



**Appendix:**\
https://doi.org/10.1016/j.procs.2016.02.090
Zanjal, Samir V., and Girish R. Talmale. "Medicine reminder and monitoring system for secure health using IOT." Procedia Computer Science 78 (2016): 471-476.
