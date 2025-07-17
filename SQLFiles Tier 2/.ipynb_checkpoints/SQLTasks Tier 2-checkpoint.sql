/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name
FROM Facilities
WHERE membercost > 0;

/* Q2: How many facilities do not charge a fee to members? */

SELECT name
FROM Facilities
WHERE membercost = 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
    AND membercost < 0.2 * monthlymaintenance;

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

SELECT *
FROM Facilities
WHERE facid IN (1, 5);

/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance AS cheap
FROM Facilities
WHERE monthlymaintenance < 100

UNION ALL

SELECT name, monthlymaintenance AS expensive
FROM Facilities
WHERE monthlymaintenance > 100;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM Members
WHERE joindate = (
    SELECT MAX(joindate)
    FROM Members);


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT 
    Facilities.name as court_name,
    CONCAT(firstname, ' ', surname) AS member_name
FROM Members
INNER JOIN Facilities
ON memid = facid
WHERE name LIKE 'Tennis Court%'
ORDER BY member_name;


/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT
    f.name AS facility_name,
    CONCAT(m.firstname, ' ', m.surname) AS member_name,
    (b.slots * f.guestcost * (b.memid = 0) +
     b.slots * f.membercost * (b.membid <> 0)) AS cost

FROM Bookings AS b
INNER JOIN Facilities AS f
ON b.facid = f.facid
INNER JOIN Members AS m
ON b.memid = m.memid
WHERE DATE(b.starttime) = '2012-09-14'
    AND (b.slots * f.guestcost * (b.memid = 0) +
         b.slots * f.guestcost * (b.memid <> 0)) > 30
ORDER BY cost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT
    f.name AS facility_name,
    CONCAT(m.firstname, ' ', m.surname) AS member_name,
    (SELECT
        IF(b.memid = 0, b.slots * f.guestcost, b.slots * f.membercost)) AS cost

FROM Bookings AS b
INNER JOIN Facilities AS f
ON b.facid = f.facid
INNER JOIN Members AS m
ON b.memid = m.memid
WHERE DATE(b.starttime) = '2012-09-14'
    AND (SELECT
            IF(b.memid = 0, b.slots * f.guestcost, b.slots * f.membercost)) > 30
ORDER BY cost DESC;

/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


# PLEASE CHECK THE JUPYTER NOTEBOOK THAT IS IN THIS FOLDER FOR THE REST OF THE QUESTIONS 10-13


('Table Tennis', 180)
('Snooker Table', 240)
('Pool Table', 270)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

('Bader', 'Florence', 'Stibbons', 'Ponder')
('Baker', 'Anne', 'Stibbons', 'Ponder')
('Baker', 'Timothy', 'Farrell', 'Jemima')
('Boothe', 'Tim', 'Rownam', 'Tim')
('Butters', 'Gerald', 'Smith', 'Darren')
('Coplin', 'Joan', 'Baker', 'Timothy')
('Crumpet', 'Erica', 'Smith', 'Tracy')
('Dare', 'Nancy', 'Joplette', 'Janice')
('Farrell', 'David', None, None)
('Farrell', 'Jemima', None, None)
('GUEST', 'GUEST', None, None)
('Genting', 'Matthew', 'Butters', 'Gerald')
('Hunt', 'John', 'Purview', 'Millicent')
('Jones', 'David', 'Joplette', 'Janice')
('Jones', 'Douglas', 'Jones', 'David')
('Joplette', 'Janice', 'Smith', 'Darren')
('Mackenzie', 'Anna', 'Smith', 'Darren')
('Owen', 'Charles', 'Smith', 'Darren')
('Pinker', 'David', 'Farrell', 'Jemima')
('Purview', 'Millicent', 'Smith', 'Tracy')
('Rownam', 'Tim', None, None)
('Rumney', 'Henrietta', 'Genting', 'Matthew')
('Sarwin', 'Ramnaresh', 'Bader', 'Florence')
('Smith', 'Darren', None, None)
('Smith', 'Jack', 'Smith', 'Darren')
('Smith', 'Tracy', None, None)
('Stibbons', 'Ponder', 'Tracy', 'Burton')
('Tracy', 'Burton', None, None)
('Tupperware', 'Hyacinth', None, None)
('Worthington-Smyth', 'Henry', 'Smith', 'Tracy')


/* Q12: Find the facilities with their usage by member, but not guests */

('Badminton Court', 1086)
('Massage Room 1', 884)
('Massage Room 2', 54)
('Pool Table', 856)
('Snooker Table', 860)
('Squash Court', 418)
('Table Tennis', 794)
('Tennis Court 1', 957)
('Tennis Court 2', 882)

/* Q13: Find the facilities usage by month, but not guests */

('Badminton Court', '08', 414)
('Badminton Court', '09', 507)
('Massage Room 1', '07', 166)
('Massage Room 1', '08', 316)
('Massage Room 1', '09', 402)
('Massage Room 2', '07', 8)
('Massage Room 2', '08', 18)
('Massage Room 2', '09', 28)
('Pool Table', '07', 110)
('Pool Table', '08', 303)
('Pool Table', '09', 443)
('Snooker Table', '07', 140)
('Snooker Table', '08', 316)
('Snooker Table', '09', 404)
('Squash Court', '07', 50)
('Squash Court', '08', 184)
('Squash Court', '09', 184)
('Table Tennis', '07', 98)
('Table Tennis', '08', 296)
('Table Tennis', '09', 400)
('Tennis Court 1', '07', 201)
('Tennis Court 1', '08', 339)
('Tennis Court 1', '09', 417)
('Tennis Court 2', '07', 123)
('Tennis Court 2', '08', 345)
('Tennis Court 2', '09', 414)



