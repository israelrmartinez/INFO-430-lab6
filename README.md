# INFO-430-lab6
 
This lab covers the latest programming examples from Lecture 15, including Common Table Expressions (CTE),  table variables as well as #temp tables. Please write the SQL for the following queries in three ways (first as a CTE, second using a table variable and finally using a #temp). Total of 9 queries need to be submitted!

Grade Point Average (GPA)  --> (SUM(COURSE.Credits * CLASS_LIST.Grade) / (SUM(COURSE.Credits)

1) RANK() + PARTITION

* Write the SQL to determine the 300 students with the lowest GPA (all students/classes) during years 1975 -1981 partitioned by StudentPermState.


2) DENSE_RANK()

* Write the SQL to determine the 26th highest GPA during the 1970's for all business classes


3) NTILE

* Write the SQL to divide ALL students into 100 groups based on GPA for Arts & Sciences classes during 1980's