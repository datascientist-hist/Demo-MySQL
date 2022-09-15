# Demo MySQL

We  want  to  create  and  query  a  database  for  managing  mobile  telephone  companies,  containing  the following relations with corresponding information:

- Company: name,country.
- Plan:  name,  monthly  cost,  minutes  included,  GBs  included.  If  minutes  or  GB  is  a  negative number, it means “unlimited”. Phone numbers of different companies can have the same plan.•User: name, surname, country.
- Phone  number:  number,  number  activation  date.  Each  phone  number  is  associated  to  a company, a user and a plan. Each phone number stores date plan activation date.

The resulting database schema can be structured as follows:

- Company(id, name, country)
- Plan(id, name, cost, minutes, gbs)
- User(id, name, surname, country)
- Phone(id, number, company_id, user_id, plan_id, number_activation_date, plan_activation_date)
  - FK: company_id→ Company(id)
  - FK: user_id → User (id)
  - FK: plan_id → Plan (id)
  
  *Requests*
  
  1.Create  the  database  schema,  with  referential  integrity  constraints.  Fill  the  database  with  the provided data file.
  
  2.Show users(name,  surname)  who  have  phone  numbers  with British  companies.Each usershould appear only once in the result.
  
  3.Show  Italian users(name,  surname)  who activated  a  phone  number  before  2015(included)  with companies whose country starts with “U”. Each usershould appear       only once in the result.
  
  4.For each  and  allItaliancompanies,  show  their  name  and  average  number  of  phone  numbers  per user.  You  can  count  the sum of phone  numbersof  each  company  and  the sum  of  users  of  each company, and divide the two amounts.
  
  5.For each  and allcompanies, compute the number of phones of that company that have plans with unlimited minutes or unlimited GBs.
  
  6.Compute,  for each  and  allcompanies  (show  the  name),  the  average  number  of  years  for  which aphone number has been active and the average number of years for which numbers have activated their current plan. The two results must be shown in the same row.
  
