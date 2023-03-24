# damg-6210-coworking-spaces-rental

## Team members:
Simran Bhatia, Netra Awate

## Project topic:
Database Design for Booking Rental Co-Working Spaces![image](https://user-images.githubusercontent.com/37814899/227425200-bb54fc84-ecaa-40d4-af2f-be5513ab838d.png)

## Description:
Capstone project for DAMG 6210 Data Management and Database Design class at Northeastern University. This project develops a database management system that allows individuals or groups to rent co-working spaces temporarily (in 2 hour blocks).

## Problem statement:
Budding startups and freelancers often forgo spending large amounts of money on an office setup in order to establish a designated workplace. However, working remotely comes with its own pains of blurred boundaries, lost concentration and myriad distractions. Using temporary office spaces for a few hours is the perfect solution to their dilemma.

1.	It’s inefficient and time-consuming to log onto different platforms to look at what co-working spaces they have available.
2.	It is frustrating to manage different login and credentials for each platform.
3.	Overbooking and conflicting bookings can cause issues and waste time.
4.	To avoid inconsistency and double booking, a single platform is ideal.

## Problem solution:
This database design enables users who are individual workers (customers) to find a co-working office space nearby and book it for a certain period defined by the customer. Office or buildings will be posted by their owners with the name of rental, available time, address, photo, rental rate, and available spots.

To create a database for an office space rental company that has the features listed below:
1.	A Business User profile will be created with all the attributes from OWNER, and the rental posted by the owner with location details will be added to the RENTAL table.
2.	A Customer profile will be created with all the attributes required for the CUSTOMER table, including but not limited to first name, last name, and contact details.
3.	To ensure the transaction of money for booking a rental space, the customer must add credit card details as per CUSTOMER_CARD_DETAILS.
4.	Customers can view rental listing information from the RENTAL _POSTING table 
5.	Customers can book a space by filtering with specific attributes like location, date, or time.
6.	Customers can edit their bookings from their rental history.
7.	Customers can cancel their bookings from their rental history.
8.	Customers can add a review or lodge a complaint about a rental once the booking duration is completed and the records will be stored in RENTAL_FEEDBACK or RENTAL_COMPLAINT tables respectively.
