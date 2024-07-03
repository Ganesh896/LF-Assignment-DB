CREATE TABLE Grades (
    grade_id INT PRIMARY KEY,
    grade_name VARCHAR(10)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    student_age INT,
    student_grade_id INT,
    FOREIGN KEY (student_grade_id) REFERENCES Grades(grade_id)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

INSERT INTO Grades (grade_id, grade_name) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C');

INSERT INTO Courses (course_id, course_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

INSERT INTO Students (student_id, student_name, student_age, student_grade_id) VALUES
(1, 'Alice', 17, 1),
(2, 'Bob', 16, 2),
(3, 'Charlie', 18, 1),
(4, 'David', 16, 2),
(5, 'Eve', 17, 1),
(6, 'Frank', 18, 3),
(7, 'Grace', 17, 2),
(8, 'Henry', 16, 1),
(9, 'Ivy', 18, 2),
(10, 'Jack', 17, 3);

INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1, 1, 101, '2023-09-01'),
(2, 1, 102, '2023-09-01'),
(3, 2, 102, '2023-09-01'),
(4, 3, 101, '2023-09-01'),
(5, 3, 103, '2023-09-01'),
(6, 4, 101, '2023-09-01'),
(7, 4, 102, '2023-09-01'),
(8, 5, 102, '2023-09-01'),
(9, 6, 101, '2023-09-01'),
(10, 7, 103, '2023-09-01');

--(1) Find all students enrolled in the Math course.
	--using subquery
	SELECT *
		FROM students
		WHERE student_id IN (
			SELECT student_id
			FROM enrollments
			WHERE course_id = (
				SELECT course_id
				FROM courses
				WHERE course_name='Math'
			)
		);

	--using JOIN
	SELECT *
	FROM students s 
		JOIN enrollments e ON s.student_id=e.student_id 
		JOIN courses c ON c.course_id=e.course_id
	WHERE course_name='Math';

--(2) List all courses taken by students named Bob.
	--using subquery
	SELECT course_name
	FROM Courses
	WHERE course_id IN (
	    SELECT e.course_id
	    FROM Enrollments e
	    WHERE e.student_id IN (
	        SELECT s.student_id
	        FROM Students s
	        WHERE s.student_name = 'Bob'
	    )
	);

	--using JOIN
	SELECT course_name
	FROM courses c
	JOIN enrollments e ON c.course_id=e.course_id
	JOIN students s ON s.student_id=e.student_id
	WHERE student_name='Bob';

--(3) Find the names of students who are enrolled in more than one course.
	--using Subquery
	SELECT student_name
	FROM Students
	WHERE student_id IN (
	    SELECT student_id
	    FROM Enrollments
	    GROUP BY student_id
	    HAVING COUNT(course_id) > 1
	);

	--using JOIN
	SELECT student_name
	FROM students s
	JOIN enrollments e ON s.student_id=e.student_id
	GROUP BY e.student_id, student_name
	HAVING COUNT(e.student_id)>1;

--(4) List all students who are in Grade A (grade_id = 1).
SELECT *
FROM students
WHERE student_grade_id=1;

--(5) Find the number of students enrolled in each course.
	--using subquery
	SELECT course_name, (
	    SELECT COUNT(*)
	    	FROM Enrollments e
	    	WHERE e.course_id = c.course_id
		) AS number_of_student_enrolled
	FROM Courses c;

	--using JOIN
	SELECT course_name, count(e.course_id) as number_of_student_enrolled
	FROM courses c
		JOIN enrollments e ON c.course_id=e.course_id
	GROUP BY e.course_id, course_name;

--(6) Retrieve the course with the highest number of enrollments.
	--using Subquery
	SELECT course_id, course_name
	FROM Courses
	WHERE course_id = (
	    SELECT course_id
	    FROM Enrollments
	    GROUP BY course_id
	    ORDER BY COUNT(student_id) DESC
	    LIMIT 1
	);

	--using JOIN
	SELECT e.course_id, course_name, count(e.course_id) as number_of_enrollment
	FROM courses c
		JOIN enrollments e ON c.course_id=e.course_id
	GROUP BY e.course_id, course_name
		ORDER BY number_of_enrollment DESC
		LIMIT 1;

--(7) List students who are enrolled in all available courses.
SELECT s.student_id, s.student_name
FROM Students s
WHERE (
    SELECT COUNT(DISTINCT course_id)
    FROM Courses
) = (
    SELECT COUNT(DISTINCT e.course_id)
    FROM Enrollments e
    WHERE e.student_id = s.student_id
);

--(8) Find students who are not enrolled in any courses.
SELECT student_id, student_name
FROM students
WHERE student_id NOT IN (
	SELECT DISTINCT student_id
	FROM enrollments
);

--(9) Retrieve the average age of students enrolled in the Science course.
	--using subquery
	SELECT AVG(student_age) AS average_age
	FROM Students
	WHERE student_id IN (
	    SELECT student_id
	    FROM Enrollments
	    WHERE course_id = (
	        SELECT course_id
	        FROM Courses
	        WHERE course_name = 'Science'
	    )
	);

	--using JOIN
	SELECT AVG(s.student_age) AS average_age
	FROM Students s
	JOIN Enrollments e ON s.student_id = e.student_id
	JOIN Courses c ON e.course_id = c.course_id
	WHERE c.course_name = 'Science';

--(10) Find the grade of students enrolled in the History course.
	--using subquery
	SELECT student_name, (
    SELECT grade_name
    FROM Grades
    WHERE grade_id = Students.student_grade_id
	) AS grade_name
	FROM Students
	WHERE student_id IN (
	    SELECT student_id
	    FROM Enrollments
	    WHERE course_id = (
	        SELECT course_id
	        FROM Courses
	        WHERE course_name = 'History'
	    )
	);


	--using JOIN
	SELECT DISTINCT student_name, grade_name
	FROM students s
		JOIN enrollments e ON s.student_id=e.student_id
	JOIN courses c ON c.course_id=e.course_id
	JOIN grades g ON g.grade_id=s.student_grade_id
		WHERE course_name='History';
