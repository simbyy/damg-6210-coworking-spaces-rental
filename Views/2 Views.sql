-- Views
-- View 1 - unresolved complaints ------------------------------------------------------------------------------
call  remove_objects ('all_unresolved_complaints','view');
create view all_unresolved_complaints as
SELECT RENTAL_COMPLAINT.COMPLAINT_ID,RENTAL_COMPLAINT.COMPLAINT_SEVERITY,OWNER.O_FIRSTNAME, OWNER.O_LASTNAME, RENTAL_COMPLAINT.COMPLAINT_STATUS, RENTAL_COMPLAINT.COMPLAINT_DATE, RENTAL_COMPLAINT.COMPLAINT_DESCRIPTION
FROM RENTAL_POSTING
INNER JOIN RENTAL_COMPLAINT ON RENTAL_COMPLAINT.R_ID = RENTAL_POSTING.R_ID
INNER JOIN OWNER ON OWNER.O_ID = RENTAL_POSTING.O_ID
WHERE RENTAL_COMPLAINT.COMPLAINT_STATUS <> 'RESOLVED'
ORDER BY RENTAL_COMPLAINT.COMPLAINT_SEVERITY ASC;

select * from all_unresolved_complaints;

-- View 2 - all deleted bookings ----------------------------------------------------------------------------------
call  remove_objects ('Deleted_bookings','view');
CREATE VIEW Deleted_bookings AS
SELECT owner.o_firstname, owner.o_lastname, RENTAL_POSTING.R_STREET, RENTAL_POSTING.R_CITY, rental_booking_backlog.B_STARTDATE, rental_booking_backlog.B_ENDDATE, count(rental_posting.r_street) as total_cancellation
FROM (RENTAL_POSTING inner join owner on owner.o_id = RENTAL_POSTING.o_id)
INNER JOIN rental_booking_backloG ON rental_booking_backloG.R_ID = RENTAL_POSTING.R_ID where RENTAL_BOOKING_BACKLOG.B_ACTIVE = '0'
group by owner.o_firstname, owner.o_lastname, RENTAL_POSTING.R_STREET, RENTAL_POSTING.R_CITY, rental_booking_backlog.B_STARTDATE, rental_booking_backlog.B_ENDDATE;

SELECT * FROM Deleted_bookings;

-- View 3 - rating average of posting --------------------------------------------------------------------------------- 
call  remove_objects ('rating_average_of_posting','view');
create view rating_average_of_posting AS
SELECT  rental_booking_backlog.r_id,RENTAL_POSTING.R_STREET,RENTAL_POSTING.R_CITY,RENTAL_POSTING.R_STATE, RENTAL_POSTING.R_ZIPCODE, avg(rental_feedback.feedback_rating) as average_rating,
(SELECT OWNER.O_FIRSTNAME FROM OWNER INNER JOIN RENTAL_POSTING ON OWNER.O_ID = RENTAL_POSTING.O_ID WHERE OWNER.O_ID = RENTAL_POSTING.O_ID AND RENTAL_POSTING.R_ID = RENTAL_BOOKING_BACKLOG.R_ID) OWNERNAME
FROM RENTAL_BOOKING_BACKLOG  
INNER JOIN RENTAL_FEEDBACK ON rental_booking_backlog.B_id = RENTAL_FEEDBACK.B_ID
INNER JOIN RENTAL_POSTING ON rental_booking_backlog.R_id = RENTAL_POSTING.R_ID
GROUP BY rental_booking_backlog.r_id,RENTAL_POSTING.R_STREET, RENTAL_POSTING.R_CITY,RENTAL_POSTING.R_STATE, RENTAL_POSTING.R_ZIPCODE
order by average_rating;

SELECT * FROM rating_average_of_posting;

-- View 4 - top 5 bookings ------------------------------------------------------------------------------------------------------
call  remove_objects ('Top5_rental_bookings','view');
create view Top5_rental_bookings as
SELECT  OWNER.O_FIRSTNAME,OWNER.O_LASTNAME, RENTAL_POSTING.R_STREET,RENTAL_POSTING.R_CITY,RENTAL_POSTING.R_ZIPCODE, COUNT(*) AS TOTAL_BOOKING 
FROM RENTAL_POSTING   
INNER JOIN RENTAL_BOOKING_BACKLOG ON rental_booking_backlog.r_id = RENTAL_POSTING.R_ID
INNER JOIN OWNER ON OWNER.O_id = RENTAL_POSTING.O_ID
WHERE RENTAL_BOOKING_BACKLOG.B_ACTIVE = '1'
GROUP BY RENTAL_POSTING.R_STREET,RENTAL_POSTING.R_CITY, OWNER.O_FIRSTNAME,OWNER.O_LASTNAME, RENTAL_POSTING.R_ZIPCODE
ORDER BY TOTAL_BOOKING DESC
FETCH FIRST 5 ROWS ONLY;

SELECT * FROM Top5_rental_bookings;

-- View 5 - Bottom5_rental_bookings ---------------------------------------------------------------------------------------------------
call  remove_objects ('Bottom5_rental_bookings','view');
create view Bottom5_rental_bookings as
SELECT rental_posting.r_id,COUNT(*) AS TOTAL_BOOKING, OWNER.O_FIRSTNAME,OWNER.O_LASTNAME, RENTAL_POSTING.R_STREET,RENTAL_POSTING.R_CITY,RENTAL_POSTING.R_ZIPCODE 
FROM RENTAL_POSTING   
INNER JOIN RENTAL_BOOKING_BACKLOG ON rental_booking_backlog.r_id = RENTAL_POSTING.R_ID
INNER JOIN OWNER ON OWNER.O_id = RENTAL_POSTING.O_ID
WHERE RENTAL_BOOKING_BACKLOG.B_ACTIVE = '1'
GROUP BY rental_posting.r_id, RENTAL_POSTING.R_STREET,RENTAL_POSTING.R_CITY, OWNER.O_FIRSTNAME,OWNER.O_LASTNAME, RENTAL_POSTING.R_ZIPCODE
ORDER BY TOTAL_BOOKING ASC
FETCH FIRST 5 ROWS ONLY;

select * from Bottom5_rental_bookings;

-- View 6 - view to encrypt owner ----------------------------------------------------------------------------------------------------
call  remove_objects ('Owner_encrypted_details','view');
CREATE VIEW Owner_encrypted_details AS
select o_firstname, o_lastname, o_city, o_state, o_zipcode, o_creationdate, concat('******', substr(o_contact,6,10))as phone_number ,o_username from owner;

select * from owner_encrypted_details;

-- View 7 - view to encrypt customer -------------------------------------------------------------------------------------------------
call  remove_objects ('Customer_encrypted_details','view');
CREATE VIEW Customer_encrypted_details AS
select c_firstname, c_lastname, c_city, c_state, c_zipcode, c_creationdate, concat('******', substr(c_contact,6,10))as phone_number ,c_username from customer;

select * from Customer_encrypted_details;

-- View 8 - view rental booking table ------------------------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "ADMIN"."READ_RENTAL_BOOKING_BACKLOG" ("BOOKINGID", "RENTALID", "CUSTOMERID", "STARTDATE", "ENDDATE", "ACTIVEBOOKING") DEFAULT COLLATION "USING_NLS_COMP"  AS 
SELECT 
b_id as BookingId, r_id as RentalId, c_id as CustomerId, b_startdate as StartDate, b_enddate as EndDate, b_active as ActiveBooking    
FROM RENTAL_BOOKING_BACKLOG;

-- View 9 - view rental complaint table ---------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "ADMIN"."READ_RENTAL_COMPLAINT" ("COMPLAINTID", "RENTALID", "CUSTOMERID", "COMPLAINTDATE", "COMPLAINTSTATUS", "COMPLAINTDESCRIPTION", "COMPLAINTSEVERITY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
SELECT 
complaint_id as ComplaintId,
r_id as RentalId,
c_id as CustomerId,
complaint_date as ComplaintDate,
complaint_status as ComplaintStatus,
complaint_description as ComplaintDescription,
complaint_severity as ComplaintSeverity
FROM rental_complaint;

-- View 10 - view read rental feedback table -----------------------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "ADMIN"."READ_RENTAL_FEEDBACK" ("FEEDBACKID", "BOOKINGID", "CUSTOMERID", "FEEDBACKDATE", "REVIEW", "RATING") DEFAULT COLLATION "USING_NLS_COMP"  AS 
SELECT 
feedback_id as FeedbackId, b_id as BookingId, c_id as CustomerId, feedback_date as FeedbackDate, feedback_review as Review, feedback_rating as Rating  
FROM rental_feedback;

-- View 11 - view read rental posting table --------------------------------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "ADMIN"."READ_RENTAL_POSTING_TABLE" ("RENTALID", "OWNERID", "RENTALTYPE", "RATEPERHOUR", "STREETADDRESS", "RENTALCAPACITY", "WIFI", "CAFETERIA", "RENTAL_DESCRIPTION") DEFAULT COLLATION "USING_NLS_COMP"  AS 
SELECT r_id as RentalId,
o_id as OwnerId,
r_type as RentalType,
r_rateperhour as RatePerHour,
r_street || ' ' || r_city || ', ' || r_state || '- ' || r_zipcode as StreetAddress,
r_totalseatspace as RentalCapacity,
r_utilitywifi as Wifi,
r_utilitycafeteria as Cafeteria,
r_description as Rental_Description
FROM rental_posting;

-- View 12 - view customer card details ------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "ADMIN"."CUSTOMER_CARD_V" ("C_ID", "CARD_NAME", "CARD_TYPE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
SELECT c_id,card_name,card_type FROM Customer_Card_Details;