-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100),
    student_major VARCHAR(100)
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_description VARCHAR(255)
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert data into Students table
INSERT INTO Students (student_id, student_name, student_major) VALUES
(1, 'Alice', 'Computer Science'),
(2, 'Bob', 'Biology'),
(3, 'Charlie', 'History'),
(4, 'Diana', 'Mathematics');

-- Insert data into Courses table
INSERT INTO Courses (course_id, course_name, course_description) VALUES
(101, 'Introduction to CS', 'Basics of Computer Science'),
(102, 'Biology Basics', 'Fundamentals of Biology'),
(103, 'World History', 'Historical events and cultures'),
(104, 'Calculus I', 'Introduction to Calculus'),
(105, 'Data Structures', 'Advanced topics in CS');

-- Insert data into Enrollments table
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1, 1, 101, '2023-01-15'),
(2, 2, 102, '2023-01-20'),
(3, 3, 103, '2023-02-01'),
(4, 1, 105, '2023-02-05'),
(5, 4, 104, '2023-02-10'),
(6, 2, 101, '2023-02-12'),
(7, 3, 105, '2023-02-15'),
(8, 4, 101, '2023-02-20'),
(9, 1, 104, '2023-03-01'),
(10, 2, 104, '2023-03-05');

--(1) Retrieve the list of students and their enrolled courses? (Inner Join)
SELECT student_name, course_name
	FROM Students s
JOIN Enrollments e
	ON s.student_id = e.student_id
JOIN Courses c
	ON c.course_id = e.course_id;

--(2) List all students and their enrolled courses, including those who haven't enrolled in any course? (Left Join)
SELECT student_name, course_name
	FROM Students s
LEFT JOIN Enrollments e
	ON s.student_id = e.student_id
LEFT JOIN Courses c
	ON c.course_id = e.course_id;

--(3) Display all courses and the students enrolled in each course, including courses with no enrolled students? (Right Join)
SELECT student_name, course_name
	FROM Students s
RIGHT JOIN Enrollments e
	ON s.student_id = e.student_id
RIGHT JOIN Courses c
	ON c.course_id = e.course_id;

--(4) Find pairs of students who are enrolled in at least one common course? (Self Join)
SELECT DISTINCT
    e1.student_id AS student1_id,
    s1.student_name AS student1_name,
    e2.student_id AS student2_id,
    s2.student_name AS student2_name,
    e1.course_id
FROM
    Enrollments e1
    JOIN Enrollments e2 ON e1.course_id = e2.course_id AND e1.student_id < e2.student_id
    JOIN Students s1 ON e1.student_id = s1.student_id
    JOIN Students s2 ON e2.student_id = s2.student_id;


--(5) Retrieve students who are enrolled in 'Introduction to CS' but not in 'Data Structures'? (Complex Join)
SELECT s.student_id, student_name, course_name
	FROM Students s
JOIN Enrollments e
	ON s.student_id = e.student_id
JOIN Courses c
	ON c.course_id = e.course_id
WHERE c.course_name = 'Introduction to CS' AND s.student_id NOT IN (
	SELECT en1.student_id
	FROM Enrollments en1
	JOIN Courses c2
	ON en1.course_id = c2.course_id
	WHERE c2.course_name = 'Data Structures'
);

--Windows function:
--(1) List all students along with a row number based on their enrollment date in ascending order? (ROW_NUMBER())
SELECT s.student_id, student_name, enrollment_date,
ROW_NUMBER() OVER(
	ORDER BY e.enrollment_date
)
FROM Students s
JOIN Enrollments e
	ON s.student_id = e.student_id;

--(2) Rank students based on the number of courses they are enrolled in, handling ties by assigning the same rank? (RANK())
SELECT e.student_id, COUNT(e.student_id) AS Num_of_courses, 
RANK() OVER (
	ORDER BY COUNT(e.student_id) DESC
) AS Student_Rank 
FROM Students s 
JOIN Enrollments e
	ON s.student_id = e.student_id
	GROUP BY e.student_id;

--(3) Determine the dense rank of courses based on their enrollment count across all students? (DENSE_RANK())
SELECT e.course_id, COUNT(e.student_id) AS Num_of_students, 
DENSE_RANK() OVER (
	ORDER BY COUNT(e.course_id) DESC
) AS Course_rank 
FROM Students s 
JOIN Enrollments e
	ON s.student_id = e.student_id
	GROUP BY e.course_id;