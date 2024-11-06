create database Hr_Analytics;

/* 1. Average Attrition Rate for All Departments */
create table Kpi_1
select department, concat(round((avg(attrition_value))*100,2),'%') as Avg_Attrition_Rate
from hr_1 group by department;
select * from kpi_1 ;

/* 2. Average Hourly Rate of Male Research Scientist */
create table Kpi_2
select JobRole, Gender, round(avg(HourlyRate),2) as Avg_Hourly_Rate from hr_1
where JobRole="Research Scientist" AND Gender="Male";
select * from kpi_2 ;

/* 3. Attrition Rate Vs Monthly Income Stats */
create table Kpi_3
select department,concat(round((avg(Attrition_Value))*100,2),'%') as Average_Attrition_Rate,
round(avg(MonthlyIncome)) as Average_Monthly_Income from hr_1
  group by department;
select * from Kpi_3 ;

/* 4. Average Working Years For Each Department */
create table Kpi_4
select department , round(avg(TotalWorkingYears))as Average_Working_Years from hr_1
group by Department ;
select * from kpi_4 ;

/* 5. Job Role Vs Work Life Balance */
create table Kpi_5
select JobRole,round((avg(WorkLifeBalance)),1) as Average_work_life_balance from hr_1
group by JobRole;
select * from kpi_5;

/*  6. Attrition Rate Vs Year Since Last Promotion Relation */
create table Kpi_6
select JobRole,concat(round((avg(Attrition_value))*100,2),'%') as Average_Attrition_Rate,
round((avg(YearsSinceLastPromotion)),1) as Avg_years_since_last_promotion from hr_1 
  group by JobRole;
select * from kpi_6;
