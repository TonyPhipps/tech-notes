# Course Syllabus & Transcript Documentation
## Mobile App Development: Android, Kotlin & AI-Assisted Engineering

**Course Credit:** 1.0 High School Career & Technical Education (CTE) / Computer Science Credit (150–180 Instructional Hours)  
**Grade Level:** High School (Grades 10–12)  
**Instructional Method:** Independent Laboratory, Guided Textbook Implementation, & Project-Based Assessment  
**Primary Textbook:** *Android Programming for Beginners: Learn Android, Kotlin & Jetpack from scratch and Turbocharge progress with AI* (4th Edition, John Horton, Packt, ISBN-13: `978-1806698431`)  

---

## Course Description

This rigorous, full-year high school computer science course introduces students to modern native mobile software engineering using the **Kotlin** programming language, **Android Studio**, and **Jetpack Compose**. Beginning with foundational programming concepts and progressing to object-oriented architecture, persistent local databases, and interactive user interfaces, students develop practical software engineering skills through incremental, hands-on application builds. The curriculum also integrates structured, ethical **AI-assisted development workflows**, training students to leverage large language models for code explanation, debugging, and test generation while maintaining strict human code verification and comprehension.

---

## Course Objectives & Standards Alignment

Aligns with **CSTA K–12 Computer Science Standards (Levels 3A & 3B)** across *Algorithms & Programming*, *Computing Systems*, and *Impacts of Computing*:

1. **Kotlin Programming Fundamentals:** Design and write type-safe, object-oriented, and functional code utilizing variables, control flow, functions, collections, classes, inheritance, and null safety.
2. **Modern Declarative UI Engineering:** Construct responsive, accessible user interfaces using **Jetpack Compose**, unidirectional data flow, state management, and Material Design 3 guidelines.
3. **Software Architecture & Data Persistence:** Implement multi-screen navigation, lifecycle-aware `ViewModel` components, asynchronous execution, and local data storage via **DataStore** and **Room (SQLite)**.
4. **AI-Augmented Engineering & Verification:** Utilize AI coding assistants responsibly to analyze stack traces, scaffold boilerplate, and generate unit tests, verified through manual code audits and offline syntax assessments.

---

## Required Instructional Materials & Lab Environment

* **Primary Text:** *Android Programming for Beginners* (4th Edition) by John Horton
* **Development Environment:** Android Studio (latest stable release), Java Development Kit (JDK), and Git/GitHub for version control and portfolio documentation
* **Hardware:** Workstation running Windows, macOS, or Linux (16GB RAM recommended) and a physical Android test device configured for USB debugging
* **AI Tooling:** Supervised access to an AI coding assistant (e.g., Gemini in Android Studio or GitHub Copilot) governed by assignment-specific AI usage tiers

---

## Scope, Sequence & Instructional Hours (160 Total Hours)

*(Meets and exceeds the standard Carnegie Unit requirement of 120–150 hours for 1.0 high school credit.)*

| Weeks | Unit | Core Concepts & Textbook Alignment | Lab Deliverable & AI Integration | Expected Hours |
| :--- | :--- | :--- | :--- | :---: |
| **1–4** | **Unit 1: Environment & First UI** | Android Studio IDE setup, project hierarchy, Gradle build basics, Kotlin syntax introduction, and declarative **Jetpack Compose** layouts (`Column`, `Row`, `Text`, `Button`, modifiers). | **Lab:** *Interactive Bio / Digital Business Card App*<br>**AI Tier (Tutor):** Using AI to explain Gradle configuration files and layout modifiers. | **16 hrs** |
| **5–8** | **Unit 2: Kotlin Core & Logic** | Primitive data types, immutable vs. mutable variables (`val`/`var`), operators, control flow (`if`/`when`), loops, functions, and Kotlin null safety (`?`, `?:`). | **Lab:** *Text-Based Adventure or Math Quiz Engine*<br>**AI Tier (Restricted/Tutor):** Closed-AI syntax drills; prompting AI for edge-case test inputs. | **18 hrs** |
| **9–12** | **Unit 3: State & Interactive Compose UI** | Recomposition lifecycle, `remember`, `mutableStateOf`, state hoisting, user text input (`TextField`), and Material Design 3 components. | **Lab:** *Tip & Split Calculator / Unit Converter*<br>**AI Tier (Tutor):** Diagnosing broken state hoisting via AI stack-trace analysis. | **18 hrs** |
| **13–16** | **Unit 4: Object-Oriented Kotlin** | Classes, objects, primary/secondary constructors, inheritance, interfaces, `data class` structures, and collections (`List`, `MutableList`). | **Lab:** *Flashcard Study Deck or Inventory Tracker*<br>**AI Tier (Co-Pilot):** Generating structured mock datasets (`data class` lists) with manual validation. | **18 hrs** |
| **17–18** | **Midterm Capstone Project** | Requirements scoping, UI wireframing, incremental Git commits, and peer/family usability testing. | **Deliverable:** Functional Android application + **AI Usage & Verification Log** documenting prompts used and manual bug fixes. | **12 hrs** |
| **19–22** | **Unit 5: Dynamic Lists & Navigation** | Efficient scrolling lists (`LazyColumn`, `LazyRow`), custom item cards, multi-screen architecture with **Jetpack Navigation**, and argument passing. | **Lab:** *Local Community Guide / Resource Directory App*<br>**AI Tier (Co-Pilot):** Refactoring repetitive UI blocks into reusable `@Composable` functions. | **18 hrs** |
| **23–26** | **Unit 6: Architecture & Persistence** | MVVM pattern, `ViewModel`, unidirectional data flow, key-value storage (**DataStore**), and relational local databases (**Room** / SQLite). | **Lab:** *Persistent Habit Tracker or Task Manager*<br>**AI Tier (Audit):** Auditing AI-generated Room DAO queries and schemas for logic errors. | **20 hrs** |
| **27–30** | **Unit 7: Media, Graphics & Device APIs** | Vector assets, custom app icons, audio playback (`SoundPool`/`MediaPlayer`), Compose animations, and device permissions/sensors. | **Lab:** *2D Arcade Mini-Game or Interactive Soundboard*<br>**AI Tier (Tutor):** Troubleshooting animation curves and media lifecycle states. | **16 hrs** |
| **31–32** | **Unit 8: Polish, Testing & Deployment** | Logcat debugging, accessibility compliance (content descriptions, touch targets, contrast), unit testing, and building signed/debug APKs. | **Lab:** *Full App Polish & Accessibility Audit*<br>**AI Tier (Co-Pilot):** Generating JUnit test cases for `ViewModel` state transitions. | **10 hrs** |
| **33–35** | **Semester 2 Final Capstone** | Independent full-cycle software engineering: project proposal, Minimum Viable Product (MVP), iterative debugging, and GitHub documentation. | **Deliverable:** Original published APK, public GitHub repository with technical `README.md`, and live demonstration. | **10 hrs** |
| **36** | **Comprehensive Final Exam & Defense** | Cumulative closed-AI written/coding exam + oral code defense of the Final Capstone project. | **Deliverable:** Completed Final Exam & Capstone Defense Rubric (see below). | **4 hrs** |
| | | | **Total Instructional & Lab Hours:** | **160 hrs** |

---

## Comprehensive Final Assessment (Week 36)

To validate mastery independently of AI assistance, the course concludes with a two-part summative final assessment worth **20% of the final course grade**:

### Part 1: Closed-AI Practical & Written Exam (2 Hours — 50% of Final Exam Grade)
Conducted in an offline/AI-disabled environment to verify core competency:
* **Section A — Kotlin Syntax & Logic (25 pts):** Short-answer and code-tracing questions covering `val`/`var`, null safety operators, `when` expressions, collections, and OOP class design.
* **Section B — Code Reading & Debugging (25 pts):** Identify and correct three intentional bugs in provided Kotlin/Jetpack Compose snippets (e.g., missing `remember` state wrapper, `NullPointerException` risk, broken `LazyColumn` key/item rendering).
* **Section C — Live Mini-Build (50 pts):** Build a single-screen interactive Android counter/tracker app from scratch within 60 minutes using Android Studio (without internet or AI access), demonstrating working state updates and clean layout structure.

### Part 2: Final Capstone Oral Code Defense & Demo (2 Hours Prep/Presentation — 50% of Final Exam Grade)
The student presents their Semester 2 Capstone App and walks the instructor/evaluator through the source code repository:
* **Live Demonstration (20 pts):** Showcase core user flows, edge-case handling, and persistent storage on a physical Android device or emulator.
* **Architectural Walkthrough (40 pts):** Explain how data flows between the UI (`@Composable`), `ViewModel`, and local database (`Room`/`DataStore`).
* **AI Attribution & Line-by-Line Defense (40 pts):** Review git commit history and explain any AI-assisted code blocks line-by-line, demonstrating full comprehension of how the code executes.

---

## Grading & Evaluation Rubric

| Assessment Category | Weight | Documentation & Verification Evidence |
| :--- | :---: | :--- |
| **Weekly Textbook Labs & Git Commits** | 25% | Timestamped GitHub repository commits and functional app checkpoints across Units 1–8. |
| **AI Code Audits & Debugging Logs** | 15% | Written logs documenting AI prompts, identified hallucinations/bugs, and manual fixes. |
| **Unit Quizzes (Closed-AI)** | 15% | Offline concept checks verifying Kotlin syntax, OOP, and Compose state mechanics. |
| **Midterm & Final Capstone Projects** | 25% | Two original Android applications evaluated on functionality, UI/UX, and code structure. |
| **Comprehensive Final Exam & Code Defense** | 20% | Week 36 Closed-AI Practical Exam (10%) + Capstone Oral Code Defense (10%). |

---

## Academic Integrity & AI Usage Policy

Assignments follow a **Three-Tier AI Policy** to ensure authentic skill acquisition:
1. **Red Light (AI Off):** Unit quizzes, syntax drills, and Part 1 of the Final Exam. All code must be written unaided.
2. **Yellow Light (AI as Tutor/Debugger):** Weekly guided textbook labs. AI may be used to explain compiler errors or clarify documentation, but all code must be typed and assembled by the student.
3. **Green Light (AI Co-Pilot):** Capstone projects and refactoring exercises. AI may generate boilerplate or mock data only when accompanied by a **Code Verification Note** and verified during oral code review.