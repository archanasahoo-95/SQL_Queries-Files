create database HEALTHCARE_ANALYTICS;

use healthcare_analytics;

show variables like "secure_file_priv";
create table dialysis_1 (ProviderNumber varchar(250),
	FacilityName varchar(250),
	City varchar(250),
	State varchar(250),
	County	varchar(250),
    ProfitorNonProfit varchar(250),	ChainOwned varchar(250),
	ChainOrganization varchar(250),	DialysisStations varchar(250),	
    FiveStar varchar(250),	PatientTransfusioncategorytext varchar(250),
	Numberofpatientsincludedinthetransfusionsummary varchar(250),
	Numberofpatientsinhypercalcemiasummary varchar(250),
	NumberofpatientsinSerumphosphorussummary varchar(250),	Patienthospitalizationcategorytext varchar(250),
	PatientHospitalReadmissionCategory varchar(250),PatientSurvivalCategoryText varchar(250),Numberofpatientsincludedinhospitalizationsummary varchar(250),
	Numberofhospitalizationsincludedinhospitalreadmissionsummary varchar(250),	NumberofPatientsincludedinsurvivalsummary varchar(250),
	PatientInfectioncategorytext varchar(250),	FistulaCategoryText varchar(250),	NumberofPatientsincludedinfistulasummary varchar(250),
	Numberofpatientsinlongtermcathetersummary varchar(250),	Numberofpatientmonthsinlongtermcathetersummary varchar(250),
	NumberofpatientsinnPCRsummary varchar(250),	NumberofpatientmonthsinnPCRsummary	varchar(250),
    SWRcategorytext varchar(250),	NumberofpatientsinthisfacilityforSWR varchar(250),
	PPPWcategorytext varchar(250),	NumberofpatientsforPPPW varchar(250));

select* from dialysis_1;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Dialysis_1_Cleaned.csv'
INTO TABLE dialysis_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table dialysis_2(CMSCertificationNumber varchar(250),
	City varchar(250),
	State varchar(250),
	ZipCode varchar(250),
	TotalPerformanceScore varchar(250),
	PaymentReductionPercentage varchar(250),
	CMSCertificationDate Date);
 select* from dialysis_2;
 
 LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Dialysis_2.csv' 
 INTO TABLE dialysis_2
 FIELDS TERMINATED BY ','
 ENCLOSED BY'"'
 LINES TERMINATED BY '\n'
 IGNORE 1 ROWS;
 
 ----------------------------------------- KPI 1 ---------------------------------------------------
 ########################## NUMBER OF PATIENTS ACROSS VARIOUS SUMMARY ############################## ok
 select sum(Numberofpatientsincludedinthetransfusionsummary) as Transfusion_summary,+sum(Numberofpatientsinhypercalcemiasummary) as Hypercalcemia_summary,
 +sum(NumberofpatientsinSerumphosphorussummary) as serumphosphorus_summary,
 +sum(Numberofpatientsincludedinhospitalizationsummary) as Hospitalization_summary,+sum(NumberofPatientsincludedinsurvivalsummary) as Survival_summary,
 +sum( NumberofPatientsincludedinfistulasummary) as Fistula_summary,+sum(Numberofpatientsinlongtermcathetersummary) as Longtermcatheter_summary,
 +sum(NumberofpatientsinnPCRsummary) as nPCR_Summary from dialysis_1;
 
 ----------------------------------------- KPI 2 ---------------------------------------------------
 ########################### PROFIT OR NON-PROFIT STATS ############################
 select ChainOwned,count(ProfitorNonProfit)from dialysis_1 group by ChainOwned;
 
 ----------------------------------------- KPI 3 ---------------------------------------------------
 ########################## CHAIN ORGANIZATIONS W.r.t TOTAL PERFORMANCE SCORE AS NO SCORE ################################ ok
  select d1.ChainOrganization,count( d2.TotalPerformanceScore) from dialysis_1 as d1 join dialysis_2 as d2
 on d1.ProviderNumber = d2.CMSCertificationNumber where d2.TotalPerformanceScore = "0" group by d1.chainorganization order by d2.totalperformancescore desc;
 
 ----------------------------------------- KPI 4 ----------------------------------------------------
########################## DIALYSIS STATION BY STATE ################################ ok
  select State,sum(DialysisStations) as Dialysis_Station from dialysis_1 group by state order by Dialysis_Station desc;
  
 ----------------------------------------- KPI 5 ----------------------------------------------------
 ######################## CATEGORY TEXT - AS EXPECTED ################################# ok
select
sum(case when PatientTransfusioncategorytext = "As Expected" THEN 1 ELSE 0 END) as Transfusion_Category_Text,
sum(case when Patienthospitalizationcategorytext = "As Expected" THEN 1 ELSE 0 END) as Hospitalization_Category_Text,
sum(case when PatientSurvivalCategoryText = "As Expected" THEN 1 ELSE 0 END) as Survival_Category_Text,
sum(case when PatientInfectioncategorytext = "As Expected" THEN 1 ELSE 0 END) as Infection_Category_Text,
sum(case when FistulaCategoryText = "As Expected" THEN 1 ELSE 0 END) as Fistula_Category_Text,
sum(case when SWRcategorytext = "As Expected" THEN 1 ELSE 0 END) as SWR_Category_Text,
sum(case when PPPWcategorytext  = "As Expected" THEN 1 ELSE 0 END) as PPPW_Category_Text from dialysis_1;
 
 ----------------------------------------- KPI 6 ----------------------------------------------------
 ####################### AVERAGE PAYMENT REDUCTION RATE ###############################
 select d1.chainorganization,round(avg(d1.FiveStar),2) as Average_Five_Star, concat(round(avg(PaymentReductionPercentage),2),"%") as Average_Payment_Reduction_Rate
 from dialysis_1 as d1 join dialysis_2 as d2
 on d1.ProviderNumber = d2.CMSCertificationNumber group by d1.chainorganization order by d1.chainorganization;
 
 