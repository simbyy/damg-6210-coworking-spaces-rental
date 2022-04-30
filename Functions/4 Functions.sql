-- Function 1 -----------------------------------------------------------------------------------------------------------
create or replace FUNCTION CHECK_RENTAL_AVAILABILITY 
(
  RID IN NUMBER 
, BOOKING_SDATE IN DATE 
, BOOKING_EDATE IN DATE
, SEATS IN NUMBER 
) RETURN VARCHAR2 AS 
BEGIN
    DECLARE
        rid_valid numeric;
        rid_e exception;
        null_e exception;
        seats_e exception;
        seats_valid numeric;
        available_seats_a numeric;
        available_seats_b numeric;
        date_e exception;
        current_date date;
        availability numeric;
    BEGIN
        select sysdate into current_date from dual;
        select count(*) into rid_valid from rental_posting where r_id = rid;
        IF rid_valid is not null then
            select r_totalseatspace into seats_valid from rental_posting where r_id = rid;
        ELSE seats_valid:=null;
        END IF;
        
        CASE
            WHEN RID is null then raise null_e;
            WHEN booking_sdate is null then raise null_e;
            WHEN booking_edate is null then raise null_e;
            WHEN seats<0 then raise null_e;
            WHEN rid_valid is null then raise rid_e;
            WHEN seats_valid is null then raise seats_e;
            WHEN booking_sdate < current_date then raise date_e;
            WHEN booking_edate < current_date then raise date_e;
            WHEN booking_sdate > booking_edate then raise date_e;
            ELSE null;
        END CASE;
        
        select count(*) into available_seats_a from rental_booking_backlog where b_active = 1 and r_id=rid and booking_sdate between b_startdate and b_enddate;
        select count(*) into available_seats_b from rental_booking_backlog where b_active = 1 and r_id=rid and booking_edate between b_startdate and b_enddate;
        
        IF available_seats_a is not null and available_seats_b is not null then
            IF available_seats_a = 0 and available_seats_b = 0 then
                AVAILABILITY := 1;
            ELSE
                AVAILABILITY := 0;
            END IF;
        ELSE
            AVAILABILITY := 0;
        END IF;
        return AVAILABILITY;
    EXCEPTION
        WHEN rid_e THEN RAISE_APPLICATION_ERROR(-20030, 'This Rental Id does not exist. Please re-enter');
        WHEN null_e THEN RAISE_APPLICATION_ERROR(-20031, 'Enter valid values for parameters.');
        WHEN date_e THEN RAISE_APPLICATION_ERROR(-20032, 'Enter valid dates.');
    END;
END CHECK_RENTAL_AVAILABILITY;