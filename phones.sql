
drop database if exists phones;
create database phones;
use phones;


create table Company(
    id int primary key,
    name varchar(30),
    country varchar(30)
);

create table Plan(
    id int primary key,
    name varchar(30),
    cost float,
    minutes int,
    gbs int
);

create table User(
    id int primary key,
    name varchar(30),
    surname varchar(30),
    country varchar(30)
);

create table Phone(
    id int primary key, 
    number varchar(10),
    Company_id int, 
    User_id int, 
    Plan_id int, 
    number_activation_date date,
    plan_activation_date date,

    foreign key (Company_id) references Company(ID),
    foreign key (User_id) references User(ID),
    foreign key (Plan_id) references Plan(ID)
);



insert into User values(1, 'Andrew', 'Anderson', 'Italy');
insert into User values(2, 'Bob', 'Robson', 'Italy');
insert into User values(3, 'Carl', 'Carlson', 'Italy');
insert into User values(4, 'Don', 'Donaldson', 'Italy');

insert into Company values(1, 'O2', 'UK');
insert into Company values(2, '3', 'UK');
insert into Company values(3, 'Tim', 'Italy');
insert into Company values(4, 'Orange', 'USA');
insert into Company values(5, 'Wind', 'Italy');
insert into Company values(6, 'Omnitel', 'Italy');

insert into Plan values(1, 'UMinutes', 10, -1, 5);
insert into Plan values(2, 'UGBs', 15, 200, -1);
insert into Plan values(3, 'Cheap', 5, 100, 1);
insert into Plan values(4, 'Large', 20, 500, 20);

insert into Phone values(1, '11111', 1, 1, 1, '2015-01-01', '2017-01-01');
insert into Phone values(2, '22222', 2, 2, 2, '2016-01-01', '2018-01-01');
insert into Phone values(3, '33333', 3, 3, 3, '2014-01-01', '2019-01-01');
insert into Phone values(4, '44444', 2, 1, 4, '2017-01-01', '2020-01-01');
insert into Phone values(5, '55555', 2, 1, 3, '2012-01-01', '2019-01-01');
insert into Phone values(6, '66666', 3, 4, 2, '2015-01-01', '2018-01-01');
insert into Phone values(7, '77777', 3, 4, 1, '2018-01-01', '2021-01-01');
insert into Phone values(8, '88888', 5, 4, 2, '2017-01-01', '2020-01-01');



/* Relax dataset

group: PHONES

USER = {
    id name surname country
    1 Andrew Anderson Italy
    2 Bob Robson Italy
    3 Carl Carlson Italy
    4 Don Donaldson Italy
}

COMPANY = {
    id name country
    1 O2 UK
    2 3 UK
    3 Tim Italy
    4 Orange USA
    5 Wind Italy
    6 Omnitel Italy
}

PLAN = {
    id name cost minutes gbs
    1,UMinutes,10,-1,5
    2,UGBs,15,200,-1
    3,Cheap,5,100,1
    4,Large,20,500,20
}

PHONE = {
    id number company_id user_id plan_id number_activation_date plan_activation_date
    1,11111,1,1,1,2015-01-01,2017-01-01
    2,22222,2,2,2,2016-01-01,2018-01-01
    3,33333,3,3,3,2014-01-01,2019-01-01
    4,44444,2,1,4,2017-01-01,2020-01-01
    5,55555,2,1,3,2012-01-01,2019-01-01
    6,66666,3,4,2,2015-01-01,2018-01-01
    7,77777,3,4,1,2018-01-01,2021-01-01
    8,88888,5,4,2,2017-01-01,2020-01-01
}

*/


-- 2. Show users (name, surname) who have phone numbers with British companies. Each user should appear only once in the result.

select distinct U.name as name, U.surname as surname
from Phone P join User U join Company C on P.user_id = U.id and P.Company_id = C.ID
where C.country = "UK";

/*
pi USER.name, USER.surname (
    sigma COMPANY.country = 'UK' (
        PHONE join PHONE.user_id=USER.id USER join PHONE.company_id=COMPANY.id COMPANY))

*/


-- 3. Show Italian users (name, surname) who activated a phone number before 2015 (included) with companies whose country starts 
--    with “U”. Each user should appear only once in the result.

select distinct U.name as name, U.surname as surname
from Phone P join User U join Company C on P.user_id = U.id and P.Company_id = C.ID
where C.country like "U%" and year(P.number_activation_date) <= 2015 and U.country = "Italy";

/*
pi USER.name, USER.surname (
    sigma COMPANY.country like 'U%' and year(PHONE.number_activation_date) <= 2015 and USER.country = 'Italy' (
        PHONE join PHONE.user_id=USER.id USER join PHONE.company_id=COMPANY.id COMPANY))

*/


-- 4. For each and all Italian companies, show their name and average number of phone numbers peruser. You can count the 
--    sum of phone numbers of each company and the sum of users of each company, and divide the two amounts.

drop view if exists CompanyNumbers;
create view CompanyNumbers as
select company_id as company, count(id) as numbers
from Phone
group by company_id;

drop view if exists CompanyUsers;
create view CompanyUsers as
select company_id as company, count(distinct user_id) as users
from Phone
group by company_id;

drop view if exists CompanyComplete;
create view CompanyComplete as
select CU.company as company, CU.users as users, CN.numbers as numbers
from CompanyUsers CU join CompanyNumbers CN on CU.company = CN.company;

/*
select C.ID as company, ifnull(CC.users,0) as users, ifnull(CC.numbers,0) as numbers
from Company C left join CompanyComplete CC on C.ID = CC.company
where C.country = "Italy";
*/

select C.ID as company, ifnull(ifnull(CC.numbers,0)/ifnull(CC.users,0),0) as avg
from Company C left join CompanyComplete CC on C.ID = CC.company
where C.country = "Italy";


-- 5. For each and all companies, compute the number of phones of that company that have plans with unlimited minutes or unlimited GBs.

drop view if exists CompanyNumbersUnlimited;
create view CompanyNumbersUnlimited as
select company_id as company, count(P.id) as NumbersUnlimited
from Phone P join Plan PL on P.plan_id = PL.ID
where PL.minutes = -1 or PL.gbs = -1 
group by company_id;

select C.ID as company, ifnull(NumbersUnlimited,0) as NumbersUnlimited
from Company C left join CompanyNumbersUnlimited CC on C.ID = CC.company;


-- 6. Compute, for each and all companies (show the name), the average number of years for which a phone number has been active 
--    and the average number of years for which numbers have activated their current plan. The two results must be shown in the same row

drop view if exists CompanyAVGNumberActive;
create view CompanyAVGNumberActive as
select company_id as company, avg(year(CURDATE()) - year(number_activation_date)) as AVGNumberOfYearsActive
from Phone
group by company_id;

drop view if exists CompanyAVGPlanActive;
create view CompanyAVGPlanActive as
select company_id as company, avg(year(CURDATE()) - year(plan_activation_date)) as AVGNumberOfYearsActive
from Phone
group by company_id;

--select * from CompanyAVGPlanActive;

drop view if exists CompanyAVGComplete;
create view CompanyAVGComplete as
select CN.company as company, CN.AVGNumberOfYearsActive as AVGNumbers, CA.AVGNumberOfYearsActive as AVGPlans
from CompanyAVGNumberActive CN join CompanyAVGPlanActive CA on CN.company = CA.company;

--select * from CompanyAVGComplete;

select C.name as company, ifnull(AVGNumbers,0) as AVGNumbers, ifnull(AVGPlans,0) as AVGPlans
from Company C left join CompanyAVGComplete CA on C.ID = CA.company;


