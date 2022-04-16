CREATE OR REPLACE PROCEDURE CREATE_ALL_TABLES AS 
BEGIN
    begin
      execute immediate 'drop table rental_feedback';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
      execute immediate 'drop table rental_complaint';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
      execute immediate 'drop table customer_card_details';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
      execute immediate 'drop table rental_booking_backlog';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
      execute immediate 'drop table rental_posting';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
      execute immediate 'drop table owner';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
      execute immediate 'drop table customer';
    exception
        when others then
            if sqlcode != -942 then
                raise;
            end if;
    end;
    
    begin
        execute immediate 'create table customer (
            c_id number(10) primary key,
            c_firstname varchar2(20) not null,
            c_lastname varchar2(20) not null,
            c_email	varchar2(20) not null unique,
            c_contact number(10) not null unique,
            c_username varchar2(10) not null unique,
            c_password varchar2(30)	not null,
            c_city	varchar2(30) not null,
            c_state	varchar2(30) not null,
            c_zipcode varchar2(5) not null,
            c_creationdate date default SYSDATE
        )';
        
        execute immediate 'create table owner (
            o_id number(10)	primary key,
            o_firstname varchar2(20) not null,
            o_lasttname varchar2(20) not null,
            o_email varchar2(20) not null unique,
            o_contact number not null unique,
            o_username varchar2(10) not null unique,
            o_password varchar2(30) not null,
            o_city  varchar2(30) not null,
            o_state varchar2(30) not null,
            o_zipcode varchar2(5) not null,
            o_creationdate date default SYSDATE
        )';
        
        execute immediate 'create table rental_posting (
            r_id number(10)	primary key,
            o_id number(10),
            r_type varchar2(6) not null,
            r_rateperhour number(3) not null,
            r_street varchar2(20) not null unique,
            r_city varchar2(30) not null,
            r_state varchar2(30) not null,
            r_zipcode varchar2(5) not null,
            r_creationdate date default SYSDATE,
            r_spotorspace number(1) not null,
            r_totalseatspace number(3) not null,
            r_utilitywifi number(1) not null,
            r_utilitycafeteria number(1) not null,
            r_description varchar2(255) not null,
            r_photo varchar2(100),
            foreign key (o_id) references owner(o_id) on delete cascade
        )';
        
        execute immediate 'create table rental_booking_backlog(
            b_id number(10)	primary key,
            r_id number(10),
            c_id number(10),
            b_startdate	date,
            b_enddate date,
            b_active number(1),
            foreign key (r_id) references rental_posting(r_id) on delete cascade,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        
        execute immediate 'create table customer_card_details(
            card_number number(16) primary key,
            c_id number(10),
            card_name varchar2(20) not null,
            card_type varchar2(6) not null,
            card_expirydate varchar2(5) not null,
            card_cvv number(3) not null,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        
        execute immediate 'create table rental_complaint(
            complaint_id number(10)	primary key,
            r_id number(10),
            c_id number(10),
            complaint_date date	default SYSDATE,
            complaint_status varchar2(30) not null,
            complaint_description varchar2(255)	not null,
            complaint_severity varchar2(8) not null,
            foreign key (r_id) references rental_posting(r_id) on delete cascade,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
        
        execute immediate 'create table rental_feedback(
            feedback_id number(10) primary key,
            b_id number(10),
            c_id number(10),
            feedback_date date default SYSDATE,
            feedback_review	varchar2(255) not null,
            feedback_rating  number(1) not null,
            foreign key (b_id) references rental_booking_backlog(b_id) on delete cascade,
            foreign key (c_id) references customer(c_id) on delete cascade
        )';
    end;
END CREATE_ALL_TABLES;