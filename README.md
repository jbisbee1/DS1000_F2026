# DS 1000-01: How Data Shape Our World (Fall 2026)
Course Material for DS1000: How Data Shape our World

## Table of Contents

1. [Overview](#overview)
2. [Required Applications](#required-applications)
3. [Evaluation & Responsibilities](#evaluation--responsibilities)
4. [Course Policies](#course-policies)
5. [Office Hours](#office-hours)
6. [Syllabus](#syllabus)
7. [Helpful Resources](#helpful-resources)
8. [Acknowledgements](#acknowledgements)

## Overview
The target audience is someone who is interested in Data Science, but who has no prior experience. The class is designed to be application-forward -- demonstrating what you can do with the tools of data science in the hopes of motivating and encouraging students to go deeper and further. As an introductory class with no prerequisites, the statistical and programming fundamentals behind what we do is only briefly mentioned; the goal is to provide a sense of what can be done with data science rather than to provide a comprehensive foundation on a smaller set of topics. The contents of this repository represent a work-in-progress and revisions and edits are likely frequent.

The main text for the course is "R For Data Science" which can accessed free online [here](https://r4ds.had.co.nz/introduction.html).

Large language models (ChatGPT, Claude, or similar) are a required part of this course's workflow. Students are expected to have a free account with at least one such tool.

*[Back to ToC](#table-of-contents)*

## Required Applications

### Brightspace
This is the course management software used at Vanderbilt to support course learning. I will use this to post readings, lectures, assignments, and news for the course. I will post announcements and changes to the home page of the site; though I will always announce changes in class, please keep an eye out. *If a change to the syllabus or requirements is posted in the announcements on this site, you are responsible for those changes.*

Don't forget to download the related app, which is called Pulse, to your phone and set it to alert you if there are new content or announcements for the course.

**Respondus LockDown Browser** is required for all Daily Quizzes and Unit Tests, and is enabled directly through our Brightspace site. You must install it *before the first Daily Quiz on 8/31*. We will do a short practice run before the first graded assessment so day-of is not the first time you have used it.

### Campuswire
I have set up a Campuswire workspace for our use this semester to help us better communicate with each other and the TAs. You will need to create an account and join our workspace by following this link (posted on Brightspace). **The secret PIN can be found on the first announcement on Brightspace.** You are encouraged to adopt these [Slack etiquette tips](https://slack.com/blog/collaboration/etiquette-tips-in-slack).

Here is the list of channels you should see upon joining the Campuswire workspace:

- **Class feed**: A space to post questions and respond to other posts.

- **#announcements**: A space for all course announcements.

- **#general**: A space for you to share and discuss stories you've seen in the news or on social media that are relevant to our class.

- **Calendar**: A calendar containing all lectures, due dates, office hours, and labs.

- **Files**: A space for course materials (**NOT USED. VISIT BRIGHTSPACE INSTEAD.**)

- **Grades**: A space for grades (**NOT USED. VISIT BRIGHTSPACE INSTEAD.**)

### GitHub
I have created a [`GitHub`](https://github.com/jbisbee1/DS1000_F2026) repository to prepare and share all course-related content. This very syllabus is available as the repository's README and all links below are connected to the appropriate folders, sub-folders, and files in this repository.

You are expected to adopt the following workflow for this class:

1. Prior to each lecture, download the appropriate `.Rmd` file, open it in `RStudio`, and read through it. **This is your primary (ungraded) homework assignment!** As you work through it, try to tweak some of the code and answer the toy examples where provided -- use your LLM of choice freely here to explain concepts, debug code, or explore extensions. Each time you make a change, click the `knit` button in `RStudio` to see if everything still loads.

2. During each lecture, create a new `.Rmd` file to take notes in. As with the homework, you should be tweaking and adjusting things on your own, extending your learning beyond what is covered in lecture.

3. After each lecture, tweak the notes `.Rmd` file further to test out new ideas that you come up with which were not covered in class. Each lecture's slides will be made available as `PDF` for you use to help you review.

*[Back to ToC](#table-of-contents)*

## Evaluation & Responsibilities

The assessment structure distinguishes **practice**, **component mastery**, **integration**, and **authentic application**. Homework is low-stakes and AI-enabled; Daily Quizzes and Unit Tests are completed independently in class under Respondus LockDown Browser; Evidence Debates and the Project Defense assess judgment, communication, and transfer.

The working grading architecture for the redesigned course is:

- **Weekly Homework (5 pts):** Short, low-stakes preparation for the next independent assessment. AI use is expected and often explicitly required. Homework emphasizes specification, verification, and practice rather than unaided code production.
- **Daily Quizzes (15 pts):** Very short, in-class checks at the beginning of most instructional meetings. These assess the component skill from the preceding lecture/homework and are completed without AI or internet access.
- **Unit Tests (40 pts):** Five in-class, case-based assessments (8 pts each) that ask you to integrate several skills on an unfamiliar empirical problem. Unit Tests emphasize reasoning from claims to evidence rather than memorizing R syntax.
- **Evidence Debates (10 pts):** Two structured evidence-adjudication exercises. Small groups temporarily defend competing interpretations of a factual claim; each student then submits an independent verdict about what the evidence actually supports.
- **Project & Defense (15 pts):** You will be randomly assigned to a team of 3-4. Teams develop a data science project (question + dataset + analysis) outside of class -- AI use is expected and encouraged here -- but the grade is based primarily on a live, in-class poster-session defense where you explain and field questions about the whole project. See the rubric below.
- **Remaining 15 pts:** Reserved while the redesign is finalized. The current plan is to use these points for a cumulative independent assessment or to redistribute them across Unit Tests and the Project Defense. This will be finalized before the course begins.

### How the pieces fit together

**Homework = coached rehearsal.** You may use AI, notes, classmates, and outside resources to practice the analytical task.

**Daily Quiz = independent component check.** Can you perform the key reasoning move from the previous class without assistance?

**Unit Test = independent transfer.** Can you integrate several component skills to adjudicate an unfamiliar empirical case?

**Evidence Debate = judgment under disagreement.** Can you evaluate competing interpretations and decide what the evidence warrants?

**Project Defense = authentic synthesis.** Can you formulate, conduct, explain, and defend your own empirical analysis?

Letter grades are determined as per the standard Vanderbilt grading system, reproduced below:

- A: 94+
- A-: 90-93
- B+: 87-89
- B: 84-86
- B-: 80-83
- C+: 77-79
- C: 74-76
- C-: 70-73
- D+: 67-69
- D: 64-66
- D-: 60-63
- F: <60

### Project Defense Rubric (15 pts, graded per student)

Defenses take place as an in-class poster session across two class periods (12/7 and 12/9). Each team presents at a station; the professor (and any TAs) circulate to grade each team over roughly 8-10 minutes: a short team walkthrough followed by individual Q&A directed at specific students by name. The individual-accountability line is scored separately for each student -- everyone on the team must be able to explain the *entire* project, not just their own piece.

| Criterion | Points | Scored | What's being assessed |
| --- | --- | --- | --- |
| Research question & motivation | 2 | Team | Is the question clear, non-trivial, with a reasoned expectation of the answer? |
| Method selection & correct application | 4 | Team | Appropriate technique from the course, applied correctly |
| Interpretation & model evaluation | 3 | Team | Can they read their own output and evaluate fit/uncertainty? |
| Individual command of the material | 4 | **Individual** | Can *this* student explain any part of the project, not just "their part"? |
| Communication & clarity | 2 | Team | Legible poster/slide, clear question-method-finding narrative |

If a team member is absent on their defense day, they receive a 5-minute makeup slot during office hours rather than the whole team rescheduling.

### Extra Credit opportunities

Students who are below a C- in the class can make up a missing or low Lab Quiz score by conducting an extra credit research assignment (up to 3). These involve the following steps:

1. Search for an interesting dataset on kaggle.com.
2. Ask a research question.
3. Formulate a theoretically-justified hypothesis for your research question.
4. Email the professor with the answers to steps 1-3 for approval.
5. Conduct the following data science analyses:
	- Univariate analyses of the X and Y variables
	- Multivariate visualization of the X and Y variables
	- Regression analysis of the relationship between the X and Y variables
	- Evaluation of model fit via univariate and multivariate visualization of the errors
	- Evaluation of model fit via k-fold cross validation to estimate RMSE
6. **Present your findings in a 5-minute one-on-one walkthrough during office hours** (rather than submitting a written report), consistent with this course's in-person assessment policy.

*[Back to ToC](#table-of-contents)*

## Course Policies

### Missed or Late Assessments

Daily Quizzes and Unit Tests happen during class and cannot be submitted late. If you miss one for an excused reason (documented illness, religious observance, etc.), contact the professor **in advance when possible** to arrange a makeup. Homework is low-stakes preparation; specific due-date and completion rules will be posted with each assignment.

### Cell Phones, Laptops, Tablets, etc.

You are expected to bring your laptop to class in order to work through the `.Rmd` file during the lecture and to take Daily Quizzes and Unit Tests under Respondus LockDown Browser. These `.Rmd` files will be posted to the GitHub repository at least 24 hours prior to the lecture. Students are encouraged to download these files and work through them prior to class.

You are asked to silence your cell phone / tablet / smart watch before class begins.

### AI & Academic Honor Code

Students are assumed to have read and agreed with the Vanderbilt University Academic Honesty policy, found at URL: https://www.vanderbilt.edu/student_handbook/the-honor-system/

**Use of AI Tools.** Large language models (ChatGPT, Claude, Copilot, and similar tools) are standard tools in the data scientist's toolkit, and you are expected to use them for the ungraded pre-lecture homework and for developing your team project. Using AI well -- knowing what to ask, how to evaluate what it gives you, and how to catch its mistakes -- is itself a skill this course teaches.

All **independent graded assessments** (Daily Quizzes and Unit Tests) take place in class under Respondus LockDown Browser with no AI or internet access. This isn't a statement of distrust in AI -- it's what lets the rest of the course treat AI as a normal, encouraged tool without compromising our ability to certify that you've learned the material. Your project defense is graded on your live, unaided explanation of your own work, not on the submitted artifact, for the same reason.

Presenting AI-generated work as your own unaided reasoning during a graded assessment, or attempting to access outside tools during a locked-browser Daily Quiz or Unit Test, is an academic integrity violation under Vanderbilt's Honor Code, as is having someone else take an assessment for you, falsifying results, or facilitating dishonesty by another student.

### Accommodations for Learning or Access Disabilities

This class respects and welcomes students of all backgrounds, identities, and abilities. If there are circumstances that make our learning environment and activities difficult, if you have medical information that you need to share with me, or if you need specific arrangements in case the building needs to be evacuated, please let me know. I am committed to creating an effective learning environment for all students, but I can only do so if you discuss your needs with me as early as possible. I promise to maintain the confidentiality of these discussions. If appropriate, also contact the Vanderbilt Student Access office to get more information about specific accommodations; please visit https://www.vanderbilt.edu/student-access/ as soon as possible to become registered and ensure that accommodations are implemented in a timely fashion. Requests for academic accommodations are to be made during the first three weeks of the semester, except for unusual circumstances.

### Illness / Attendance

If you are too ill to attend class, please do not come -- email the professor as soon as reasonably possible so we can arrange a Daily Quiz or Unit Test makeup if needed (see [Missed or Late Assessments](#course-policies)). Lecture recordings are posted the evening following class, but recordings do not replace attendance for graded, in-class work.

I will be holding my office hours in-person in Commons #348, Wednesdays 10AM-12PM. The TAs are free to determine how best to hold their office hours, and their choices will be communicated to the students as soon as they are decided.

### If You Need Help

There are many things that you might be dealing with that can hinder your ability to succeed in this course, your college career, and your life. You might be struggling with illness, socioeconomic issues, or personal issues that make it hard to concentrate, to work, or to attend class. If any of these or other things begin to hinder your ability to do your best, you can reach out to the office of Student Care Coordination for programs, training, accommodations, and assistance (find more information or make an appointment here: https://www.vanderbilt.edu/carecoordination/). The Student Care Coordination can help guide you to whatever assistance you might need, whether it be short term or long term. *If you specifically need help or accommodation in this course due to your difficulties, please come meet with me so we can find a solution that allows you to succeed while being fair to others.*

### Mandatory Reporting

Title IX makes it clear that violence and harassment based on sex and gender are Civil Rights offenses subject to the same kinds of accountability and the same kinds of support applied to offenses against other protected categories such as race, national origin, etc. If you or someone you know has been harassed or assaulted, you can call the Project Safe 24-hour crisis/support hotline at 615-322-7233 and you can find a list of resources at Project Safe. You may also contact the University's Title IX Coordinator (615-322-4705) and you can find the appropriate contacts for resources and confidence here: https://www.vanderbilt.edu/title-ix/

As a faculty member, one of my responsibilities is to help create a safe learning environment on our campus, no matter their identity or circumstances. I also have a mandatory reporting responsibility. It is my goal that you feel able to share information related to your life experiences in classroom discussions, in your written work, and in our one-on-one meetings. I will seek to keep information you share private to the greatest extent possible. However, I must note that I am a representative of an institution that we want to make safer for all people, therefore I am a mandatory reporter. University faculty, many staff members, and some student leaders are required to report incidents of sexual assault, sexual harassment, dating violence, domestic violence, stalking, and child abuse, as well as any suspected discrimination (about age, race, color, creed, religion, ancestry, national or ethnic origin, sex/gender, sexual orientation, disability, genetic information, military status, familial status or other protected categories under local, state or federal law) to the University's Title IX Coordinator (615-322-4705), as required by University policy and state and federal law. If you disclose an experience of interpersonal violence and/or child abuse to me or to classmates with mandatory reporting, whether in class discussion, through a course assignment, or in private communication with me, your disclosure will be kept as private as possible but may not be able to be kept confidential.

### Diversity Statement

Data science is, at its core, about thinking creatively to answer challenging questions. Creative thinking requires exposure to different perspectives, which are themselves borne of diverse experiences. I value diversity in all its forms including age, ability or disability, ethnicity, national origin, race, religion, sex, gender, sexual orientation, and family and marital status. I expect that all students participating in this class will respect differences and strive to understand how other peoples' perspectives, behaviors, and worldviews may be different from their own.

### Religious Holidays

The observance of religious holidays (activities observed by a religious group of which a student is a member) and cultural practices are an important reflection of diversity. As your instructor, I am committed to providing equivalent educational opportunities to students of all belief systems. At the beginning of the semester, you should review the course requirements to identify foreseeable conflicts with assignments, exams, or other required attendance. If at all possible, please contact me within the first two weeks of the first class meeting to allow time for us to discuss and make fair and reasonable adjustments to the schedule and/or tasks.

*[Back to ToC](#table-of-contents)*

## Office Hours
* Prof. Bisbee: W 10AM-12PM in Commons #348
* TA OH: please see Campuswire calendar

All these can also be found on the Campuswire calendar, along with the Zoom links for those hosting their office hours remotely.

*[Back to ToC](#table-of-contents)*

## Syllabus

Class meets **Monday/Wednesday, 8:40-9:55 AM**. Dates below follow Vanderbilt's published 2026-27 academic calendar (classes 8/26-12/10; fall break 10/22-10/23; Thanksgiving break 11/21-11/29). This is the **working roadmap for the redesigned course**; later-unit titles may shift as individual lectures are rebuilt.

The semester is organized into units. Most instructional meetings begin with a short Daily Quiz on the preceding lecture/homework. Each unit culminates in a case-based Unit Test requiring transfer to an unfamiliar empirical problem.

| Date | Session | Unit / Topic | Core Question | Assessment |
| ---: | :--- | :--- | :--- | :--- |
| 08/26 | 1 | **Unit 1: From Claims to Evidence** — How Do We Know What's True? | What evidence would let us evaluate a factual claim? | |
| 08/31 | 2 | Questions → Data | How do concepts become variables and observations? | **Daily Quiz 1** |
| 09/02 | 3 | Know Your Variables | What does each variable actually measure and look like? | **Daily Quiz 2** |
| 09/07 | 4 | Prepare the Evidence | What decisions turn raw observations into defensible evidence? | **Daily Quiz 3** |
| 09/09 | 5 | **Unit Test 1: From Claims to Evidence** | Can you integrate the full workflow on an unfamiliar empirical case? | **Unit Test 1** |
| 09/14 | 6 | **Unit 2: Relationships** — Variables Together I | How do we begin answering a question by putting variables together? | |
| 09/16 | 7 | Variables Together II | Which multivariate visualization matches the question and variable types? | **Daily Quiz** |
| 09/21 | 8 | Variables Together III | How should we describe and communicate relationships? | **Daily Quiz** |
| 09/23 | 9 | Evidence Debate 1 | What should we believe when reasonable interpretations compete? | **Evidence Debate 1** |
| 09/28 | 10 | **Unit Test 2: Relationships** | Can you evaluate multivariate evidence in a new context? | **Unit Test 2** |
| 09/30 | 11 | **Unit 3: Uncertainty & Inference** — Uncertainty I | How much should samples make us uncertain about conclusions? | |
| 10/05 | 12 | Uncertainty II | What does a confidence statement actually justify? | **Daily Quiz** |
| 10/07 | 13 | Regression I | How can a model summarize a relationship? | **Daily Quiz** |
| 10/12 | 14 | Regression II | How do we interpret and evaluate regression evidence? | **Daily Quiz** |
| 10/14 | 15 | Evidence Debate 2 | How do uncertainty, confounding, and competing explanations affect a claim? | **Evidence Debate 2** |
| 10/19 | 16 | **Unit Test 3: Uncertainty & Inference** | Can you judge what relational evidence does and does not establish? | **Unit Test 3** |
| 10/21 | 17 | **Unit 4: Models & Prediction** — Prediction vs. Explanation | When is prediction the goal, and how does that change evaluation? | **Daily Quiz** |
| *10/22-23* | | *Fall Break* | | |
| 10/26 | 18 | Classification I | How do we predict categories? | |
| 10/28 | 19 | Classification II | How should classification performance be evaluated? | **Daily Quiz** |
| 11/02 | 20 | Clustering / Unsupervised Learning | What can we learn when groups are not supplied in advance? | **Daily Quiz** |
| 11/04 | 21 | **Unit Test 4: Models & Prediction** | Can you choose and evaluate predictive approaches in a new case? | **Unit Test 4** |
| 11/09 | 22 | **Unit 5: Text, AI & Judgment** — Text as Data | How can unstructured text become evidence? | |
| 11/11 | 23 | NLP / Sentiment | What do text measures capture, and what do they miss? | **Daily Quiz** |
| 11/16 | 24 | Bias & Misinformation | How can data and AI systems produce misleading claims? | **Daily Quiz** |
| 11/18 | 25 | AI, Judgment & Responsibility | What should humans remain responsible for when AI can perform the analysis? | **Daily Quiz** |
| *11/23, 11/25* | | *Thanksgiving Break* | | |
| 11/30 | 26 | **Unit Test 5: Text, AI & Judgment** | Can you critically evaluate unfamiliar data/AI evidence? | **Unit Test 5** |
| 12/02 | 27 | Project Workshop | Can your team defend every step from question to conclusion? | |
| 12/07 | 28 | Project Defenses | Formulate, analyze, evaluate, and communicate your own empirical claim | **Project Defense** |
| 12/09 | 29 | Project Defenses | Formulate, analyze, evaluate, and communicate your own empirical claim | **Project Defense** |

### Recurring analytical workflow

Across units, the technical tools change but the reasoning process remains stable:

**Claim / Question → Concepts → Operationalization → Unit of analysis → Understand the variables → Prepare the evidence → Choose an approach → Analyze → Evaluate → Communicate**

AI may assist with implementation during homework, activities, and project development. Independent assessments focus on whether you can judge what should be done, whether an analysis is appropriate, and what the resulting evidence does and does not support.

## Helpful Resources

[Rstudio Cheat Sheet: Data Wrangling](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

[Rstudio Cheat Sheet: ggplot2 ](https://github.com/rstudio/cheatsheets/raw/master/data-visualization.pdf)

[R-graphics Cookbook](http://www.cookbook-r.com/Graphs/)

[... And the full list of Rstudio cheat sheets](https://www.rstudio.com/resources/cheatsheets/)

[Tidymodels Resources](https://www.tidymodels.org/learn/)

*[Back to ToC](#table-of-contents)*

## Acknowledgements
The contents of this course and of my teaching pedagogy are influenced and inspired by:
* Emily Hencken Ritter, Vanderbilt University
* Andrew Princep, MarketWatch & Oxford University
* Josh Clinton, Vanderbilt University
* William Doyle, Vanderbilt University
* Matthew Salganik, Princeton University

This course is modeled on the course of the same name, taught by Professors Josh Clinton and William Doyle in the spring of 2022 at Vanderbilt University. The lectures on data science & ethics are inspired by content prepared for the Summer Institutes for Computational Social Sciences ([SICSS](https://sicss.io/about)), and by presentations on machine learning and ethics prepared by Andrew Princep ([@AJPrincep](https://twitter.com/AJPrincep)). The syllabus is heavily inspired by [Emily Hencken Ritter](https://www.emilyhenckenritter.com/)'s syllabi for PSCI 3270, Politics of Human Rights.

*[Back to ToC](#table-of-contents)*
