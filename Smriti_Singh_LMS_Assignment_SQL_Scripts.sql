CREATE DATABASE LMS;
USE LMS;

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(255),
    role ENUM('student', 'instructor', 'admin'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (name, email, password_hash, role) VALUES
('Smriti Singh', 'smriti01@example.com', 'pwd123', 'student'),
('Amit Instructor', 'amit.instructor@example.com', 'pwd456', 'instructor'),
('Neha Admin', 'neha.admin@example.com', 'pwd789', 'admin'),
('Ravi Student', 'ravi.student@example.com', 'pwd999', 'student'),
('Priya Instructor', 'priya.instructor@example.com', 'pwd321','instructor');

-- Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255),
    description TEXT,
    category VARCHAR(100),
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);


-- courses table
INSERT INTO Courses (title, description, category, created_by) VALUES
('SQL Basics', 'Learn SQL from scratch', 'Database', 2),
('Python','Learn Python from basics','programming language',5),
('HTML& CSS','Web Development Fundamentals','Web Development',2);

SELECT*FROM users;

SELECT*FROM Courses;

INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, CURDATE()),
(2,2,CURDATE());

SELECT*FROM Enrollments;

-- Progress Table
CREATE TABLE Progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    module_name VARCHAR(255),
    completed BOOLEAN,
    FOREIGN KEY (student_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Progress (student_id, course_id, module_name, completed) VALUES
(1, 1, 'Introduction to SQL', TRUE),
(2,2,'Introduction to Python',TRUE);

SELECT*FROM Progress;


-- Course Content Table
CREATE TABLE CourseContent (
    content_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    module_name VARCHAR(255),
    content_type VARCHAR(50),
    file_path TEXT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO CourseContent (course_id, module_name, content_type, file_path) VALUES
(1, 'Introduction to SQL', 'video', 'intro.mp4'),
(3,'Introduction to Python','video','intro.mp4');

SELECT*FROM CourseContent;

-- Quizzes Table
CREATE TABLE Quizzes (
    quiz_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    title VARCHAR(255),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Quizzes (course_id, title) VALUES
(1, 'SQL Basics Quiz'),
(2,'HTML&CSS');

SELECT*FROM Quizzes;

-- Questions Table
CREATE TABLE Questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    quiz_id INT,
    question_text TEXT,
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id)
);

INSERT INTO Questions (quiz_id, question_text) VALUES
(1, 'What does SQL stand for?'),
(2,'What is known as HTML');

SELECT*FROM Questions;

-- Options Table
CREATE TABLE Options (
    option_id INT PRIMARY KEY AUTO_INCREMENT,
    question_id INT,
    option_text VARCHAR(255),
    is_correct BOOLEAN,
    FOREIGN KEY (question_id) REFERENCES Questions(question_id)
);

INSERT INTO Options (question_id, option_text, is_correct) VALUES
(1, 'Structured Query Language', TRUE),
(1, 'Simple Query Language', FALSE);

SELECT*FROM Options;

-- Quiz Attempts Table
CREATE TABLE QuizAttempts (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    quiz_id INT,
    score INT,
    attempt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (quiz_id) REFERENCES Quizzes(quiz_id)
);


INSERT INTO QuizAttempts (user_id, quiz_id, score) VALUES
(1, 1, 10),
(2,2,5);

SELECT*FROM QuizAttempts;


-- Grades Table
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    course_id INT,
    final_score DECIMAL(5,2),
    status ENUM('pass', 'fail'),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);


-- FINAL GRADE GENERATION
INSERT INTO Grades (user_id, course_id, final_score, status) VALUES
(1, 1, 85.00, 'pass'),
(2,2,89.00,'pass');


SELECT*FROM Grades;


-- ASSIGNMENT QUERIES

 -- 1. Show all students enrolled in each course (with course title and student name)

SELECT 
    c.title AS course_title,
    u.name AS student_name
FROM Enrollments e
JOIN Users u ON e.student_id = u.user_id
JOIN Courses c ON e.course_id = c.course_id
WHERE u.role = 'student';


-- 2. Get average quiz scores per student (with student name)

SELECT 
    u.name AS student_name,
    AVG(q.score) AS average_score
FROM QuizAttempts q
JOIN Users u ON q.user_id = u.user_id
WHERE u.role = 'student'
GROUP BY q.user_id;


 -- 3. Show overall course progress (percentage completed) for each student per course

SELECT 
    u.name AS student_name,
    c.title AS course_title,
    ROUND(100 * SUM(CASE WHEN p.completed THEN 1 ELSE 0 END) / COUNT(*), 2) AS completion_percentage
FROM Progress p
JOIN Users u ON p.student_id = u.user_id
JOIN Courses c ON p.course_id = c.course_id
GROUP BY u.name, c.title;

 -- 4. List instructors and the number of courses they created

SELECT 
    u.name AS instructor_name,
    COUNT(c.course_id) AS total_courses
FROM Courses c
JOIN Users u ON c.created_by = u.user_id
WHERE u.role = 'instructor'
GROUP BY u.name;








