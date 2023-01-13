
/*
New  Headcount file
Created to report 3 headcount numbers
UWT Official headcount - same as UW Registrar, UWT Majors in credit bearing courses
UWT Students Served - all enrolled persons on the UWT campus
UWT Distinct Major headcount (OPB) - All Tacoma majors enrolled in any course

UWT Colleges - using EDW FAS Org

Only one record per student per quarter.  Multiple majors are flattened with majors falling into 1st, 2nd, and 3rd without implied favor

Changes in the code for Summer moving forward:


1.Fee based majors - as we discovered at Winter Census the method for identifying fee based majors changed in January without notification. 
◦old method (prior to Winter 2018):  uses the major_ss_inelig flag 'Y' in the sr_major table in UWSDB
◦new method (Win 2018 to present): uses the major_fee_mgr value of 'DPT' or 'PCE'  in the sr_major table in UWSDB

1a. Online = assumes 100% online ts.dist_learn_type=3 and ts.online_learn_type=10 


2.Study Abroad Students - we have been asked by Cindy and Akane to update the curriculum criteria we use to identify Study Abroad Student
◦old method (prior to Spring 2018 - waiting on confirmation): uses curriculum code 'T INTL' as an active registration to flag Study Abroad
◦new method (Spring 2018 - present) uses curriculum code 'FSTDY' as an active registration to flag Study Abroad

3.Updates to 'Combined Ethnic' - over the past year we have added new Ethnic, Race, and International options to the Census Day data
◦International (w/Visa) - students with residence code '5' in UWSDB student table
◦International - students with residence code '5' or '6' in UWSDB student table 
◦Combined Ethnic Two or More - uses the current IPEDS methodology for associating a student in a single Race/Ethnic category.  If a student self-associates in more than one of the following: American Indian or Alaska Native, Asian, Black or African American, Native Hawaiian or other Pacific Islander,  or White or Caucasian they will fall into the "Two or More Races".  If an International student, they will be reported as "International" or removed from the count.  If reporting "Hispanic" they will be reported as "Hispanic".  Null and "Decline to respond" will be listed as Null or "Decline to respond" appropriately.  Note:  Again, this is only for instances where we have to report a single, combine race and ethnic group.

4.EthnicGrp (specific see below) Ind - from EDWPresentation for comprehensive counting of ethnic groups.  Value of 1= student self-associates with a specific ethnicity which rolls up into this group, 0 indicates no association. Caution!  Creating totals from these numbers will never equate to a campus, college, department, or major headcount.
◦EthnicGrpAfricanAmerInd
◦EthnicGrpAmerIndianInd
◦EthnicGrpAsianInd
◦EthnicGrpCaucasianInd
◦EthnicGrpHawaiiPacIslanderInd
◦EthnicGrpMultipleInd - aka two or more
◦EthnicGrpNotIndicatedInd

5.New SAT scores - in addition to SAT_m, SAT_v, and SAT_w, will be SATMTH, SATR, SATRW, and SATWL

6.AcademicCareerEntryTypeTacoma -Experimental and I'm looking for your input.  I am pushing to get this coded and tested for Summer review and feed back from you.  This is entirely for internal UWT use only and should be consider experimental for the next several quarters. I'm not trying to usurp the current system, just tinkering to see what happens and I thought some of you might enjoy investigating with me.
◦Based on a student's first application to a UW Tacoma UG program an undergraduate student will fall into one of the following categories
◾FTFY - (current definition) first time first year student - high school application
◾FTFY_highschool - first time first year student - high school application, no 2yr or 4 yr credits, no running start, no AP or IB test scores
◾FTFY_college prep - first time first year student - high school application, may have 2yr or 4 yr credits, running start, AP or IB test scores
◾WACTC_transfer - 2 yr or 4 yr application where the majority of the transfer credits are from a WA 2yr community or technical college
◾2yr_transfer - 2 yr transfer application where the majority of the transfer credits are NOT from a WA 2yr community or technical college
◾4yr_transfer - 4 yr transfer application where the majority of the transfer credits are NOT from a WA 2yr community or technical college
◾UW_transfer - transfer application where there exists a prior enrollment at the UW Seattle or UW Bothell campuses

◦Based on a student's first application to a UW Tacoma UG program 5th year student will fall into one of the following categories 
◾WACTC_transfer - 2 yr or 4 yr application where their 1st Bachelors came from a  WA 2yr community or technical college
◾2yr_transfer - 2 yr transfer application where  their 1st Bachelors is NOT from a WA 2yr community or technical college
◾4yr_transfer - 4 yr transfer application where  their 1st Bachelors is from a 4 yr institution
◾UW_transfer - transfer application where  their 1st Bachelors is from UW Seattle or UW Bothell campus

◦Based on a student's first application to a UW Tacoma graduate program a graduate student will fall into one of the following categories.
◾4yr_transfer - 4 yr transfer application not from the UW system
◾UW_transfer - a graduate application with their most recent UG or 5th year UW enrollment in UW Seattle or UW Bothell campus
◾UW_returning - a graduate student with their most recent UG or 5th year UW enrollment in Tacoma

◦Reasons for proposing this new term:  
◾Several times over the past few months, questions have been asked that could only be answer by running special adhoc queries OR were not perused because this data isn't available. 
◾I'm curious
◾The UWProfiles data which normally supplies this information is usually behind us by a week or more.  We will keep the Profiles "AcademicCareerEntryType" which equates to the UWProfiles "FTFY", "2YR Transfer", etc  for students who have an entry.  
◾UWProfiles doesn't provide this data for Graduate Students

Not new, but in context possibly helpful!
1."Ethnic Specific" -  The specific ethnicity chosen which rolls up into an ethnic group.  For example: a student can choose Samoan and it would show up as Samoan in this field and roll up into Hawaiian/Pacific Islander in any ethnic group field.

2/1/2019
Adding information for international students

*/


set nocount on
go
set ansi_warnings off
go


drop table ##census_population
drop table ##MinimasterMajors
drop table ##Minimaster
drop table ##census_tac
drop table ##guardian
drop table ##temp_county
drop table ##max_sat_parts
drop table ##max_sat_grid
drop table ##max_act_grid
drop table ##max_act_parts
drop table ##max_gre_grid
drop table ##max_gre_parts
drop table ##sat_attempts
drop table ##last_degree
drop table ##maj_dept
drop table ##major_dept
drop table ##last_degree_gr
drop table ##last_degree_ug
drop table ##majors
drop table ##majors_and_minors
drop table ##origin 
drop table ##county_origin
drop table ##levelgpa
drop table ##gpa
drop table ##study_abroad
drop table ##tcore
drop table ##college_prep_hs
drop table ##cumgpa
drop table ##multi_major
drop table ##course_types
drop table ##firstmmrecord 
drop table ##FA
drop table ##allethnic_edw
drop table ##allethnic_sdb
drop table ##test_applications
drop table ##uwt_entering_profile

declare @yr int, @qtr int, @proc_ind int, @yrqtr int, @fayr int, @runforyrqtr int
declare @biennium date  --used to select the most current FINORG for majors and courses


/*
This file is used to create only one quarter of data using the 
current Registrar's rules for inclusion in 'official' numbers
*/

set @yr=2019
set @qtr=3
set @runforyrqtr=20193
set @yrqtr=20193
set @biennium='6-30-2021'  --next will be 6-30-2023
set @proc_ind=2 -- 1=1st day, 2=Census Day, 3=cohort 
set @fayr=2019



/* 
create a temp table with zipcode to county conversions 
each quarter check this for nulls on zip
*/

create table ##temp_county (county varchar(50), zip varchar(5))
insert into ##temp_county (county, zip) values ('King','98001')
insert into ##temp_county (county, zip) values ('King','98002')
insert into ##temp_county (county, zip) values ('King','98003')
insert into ##temp_county (county, zip) values ('King','98004')
insert into ##temp_county (county, zip) values ('King','98005')
insert into ##temp_county (county, zip) values ('King','98006')
insert into ##temp_county (county, zip) values ('King','98007')
insert into ##temp_county (county, zip) values ('King','98008')
insert into ##temp_county (county, zip) values ('King','98009')
insert into ##temp_county (county, zip) values ('King','98010')
insert into ##temp_county (county, zip) values ('King','98011')
insert into ##temp_county (county, zip) values ('Snohomish','98012')
insert into ##temp_county (county, zip) values ('King','98013')
insert into ##temp_county (county, zip) values ('King','98014')
insert into ##temp_county (county, zip) values ('King','98015')
insert into ##temp_county (county, zip) values ('King','98019')
insert into ##temp_county (county, zip) values ('Snohomish','98020')
insert into ##temp_county (county, zip) values ('Snohomish','98021')
insert into ##temp_county (county, zip) values ('King','98022')
insert into ##temp_county (county, zip) values ('King','98023')
insert into ##temp_county (county, zip) values ('King','98024')
insert into ##temp_county (county, zip) values ('King','98025')
insert into ##temp_county (county, zip) values ('Snohomish','98026')
insert into ##temp_county (county, zip) values ('King','98027')
insert into ##temp_county (county, zip) values ('King','98028')
insert into ##temp_county (county, zip) values ('King','98029')
insert into ##temp_county (county, zip) values ('King','98030')
insert into ##temp_county (county, zip) values ('King','98031')
insert into ##temp_county (county, zip) values ('King','98032')
insert into ##temp_county (county, zip) values ('King','98033')
insert into ##temp_county (county, zip) values ('King','98034')
insert into ##temp_county (county, zip) values ('King','98035')
insert into ##temp_county (county, zip) values ('Snohomish','98036')
insert into ##temp_county (county, zip) values ('Snohomish','98037')
insert into ##temp_county (county, zip) values ('King','98038')
insert into ##temp_county (county, zip) values ('King','98039')
insert into ##temp_county (county, zip) values ('King','98040')
insert into ##temp_county (county, zip) values ('King','98041')
insert into ##temp_county (county, zip) values ('King','98042')
insert into ##temp_county (county, zip) values ('Snohomish','98043')
insert into ##temp_county (county, zip) values ('King','98045')
insert into ##temp_county (county, zip) values ('Snohomish','98046')
insert into ##temp_county (county, zip) values ('King','98047')
insert into ##temp_county (county, zip) values ('King','98050')
insert into ##temp_county (county, zip) values ('King','98051')
insert into ##temp_county (county, zip) values ('King','98052')
insert into ##temp_county (county, zip) values ('King','98053')
insert into ##temp_county (county, zip) values ('King','98054')
insert into ##temp_county (county, zip) values ('King','98055')
insert into ##temp_county (county, zip) values ('King','98056')
insert into ##temp_county (county, zip) values ('King','98057')
insert into ##temp_county (county, zip) values ('King','98058')
insert into ##temp_county (county, zip) values ('King','98059')
insert into ##temp_county (county, zip) values ('Kitsap','98061')
insert into ##temp_county (county, zip) values ('King','98062')
insert into ##temp_county (county, zip) values ('King','98063')
insert into ##temp_county (county, zip) values ('King','98064')
insert into ##temp_county (county, zip) values ('King','98065')
insert into ##temp_county (county, zip) values ('Kittitas','98068')
insert into ##temp_county (county, zip) values ('King','98070')
insert into ##temp_county (county, zip) values ('King','98071')
insert into ##temp_county (county, zip) values ('King','98072')
insert into ##temp_county (county, zip) values ('King','98073')
insert into ##temp_county (county, zip) values ('King','98074')
insert into ##temp_county (county, zip) values ('King','98075')
insert into ##temp_county (county, zip) values ('King','98077')
insert into ##temp_county (county, zip) values ('Snohomish','98082')
insert into ##temp_county (county, zip) values ('King','98083')
insert into ##temp_county (county, zip) values ('Snohomish','98087')
insert into ##temp_county (county, zip) values ('King','98089')
insert into ##temp_county (county, zip) values ('King','98092')
insert into ##temp_county (county, zip) values ('King','98093')
insert into ##temp_county (county, zip) values ('King','98101')
insert into ##temp_county (county, zip) values ('King','98102')
insert into ##temp_county (county, zip) values ('King','98103')
insert into ##temp_county (county, zip) values ('King','98104')
insert into ##temp_county (county, zip) values ('King','98105')
insert into ##temp_county (county, zip) values ('King','98106')
insert into ##temp_county (county, zip) values ('King','98107')
insert into ##temp_county (county, zip) values ('King','98108')
insert into ##temp_county (county, zip) values ('King','98109')
insert into ##temp_county (county, zip) values ('Kitsap','98110')
insert into ##temp_county (county, zip) values ('King','98111')
insert into ##temp_county (county, zip) values ('King','98112')
insert into ##temp_county (county, zip) values ('King','98113')
insert into ##temp_county (county, zip) values ('King','98114')
insert into ##temp_county (county, zip) values ('King','98115')
insert into ##temp_county (county, zip) values ('King','98116')
insert into ##temp_county (county, zip) values ('King','98117')
insert into ##temp_county (county, zip) values ('King','98118')
insert into ##temp_county (county, zip) values ('King','98119')
insert into ##temp_county (county, zip) values ('King','98121')
insert into ##temp_county (county, zip) values ('King','98122')
insert into ##temp_county (county, zip) values ('King','98124')
insert into ##temp_county (county, zip) values ('King','98125')
insert into ##temp_county (county, zip) values ('King','98126')
insert into ##temp_county (county, zip) values ('King','98127')
insert into ##temp_county (county, zip) values ('King','98129')
insert into ##temp_county (county, zip) values ('King','98131')
insert into ##temp_county (county, zip) values ('King','98132')
insert into ##temp_county (county, zip) values ('King','98133')
insert into ##temp_county (county, zip) values ('King','98134')
insert into ##temp_county (county, zip) values ('King','98136')
insert into ##temp_county (county, zip) values ('King','98138')
insert into ##temp_county (county, zip) values ('King','98139')
insert into ##temp_county (county, zip) values ('King','98141')
insert into ##temp_county (county, zip) values ('King','98144')
insert into ##temp_county (county, zip) values ('King','98145')
insert into ##temp_county (county, zip) values ('King','98146')
insert into ##temp_county (county, zip) values ('King','98148')
insert into ##temp_county (county, zip) values ('King','98151')
insert into ##temp_county (county, zip) values ('King','98154')
insert into ##temp_county (county, zip) values ('King','98155')
insert into ##temp_county (county, zip) values ('King','98158')
insert into ##temp_county (county, zip) values ('King','98160')
insert into ##temp_county (county, zip) values ('King','98161')
insert into ##temp_county (county, zip) values ('King','98164')
insert into ##temp_county (county, zip) values ('King','98165')
insert into ##temp_county (county, zip) values ('King','98166')
insert into ##temp_county (county, zip) values ('King','98168')
insert into ##temp_county (county, zip) values ('King','98170')
insert into ##temp_county (county, zip) values ('King','98171')
insert into ##temp_county (county, zip) values ('King','98174')
insert into ##temp_county (county, zip) values ('King','98175')
insert into ##temp_county (county, zip) values ('King','98177')
insert into ##temp_county (county, zip) values ('King','98178')
insert into ##temp_county (county, zip) values ('King','98181')
insert into ##temp_county (county, zip) values ('King','98184')
insert into ##temp_county (county, zip) values ('King','98185')
insert into ##temp_county (county, zip) values ('King','98188')
insert into ##temp_county (county, zip) values ('King','98190')
insert into ##temp_county (county, zip) values ('King','98191')
insert into ##temp_county (county, zip) values ('King','98194')
insert into ##temp_county (county, zip) values ('King','98195')
insert into ##temp_county (county, zip) values ('King','98198')
insert into ##temp_county (county, zip) values ('King','98199')
insert into ##temp_county (county, zip) values ('Snohomish','98201')
insert into ##temp_county (county, zip) values ('Snohomish','98203')
insert into ##temp_county (county, zip) values ('Snohomish','98204')
insert into ##temp_county (county, zip) values ('Snohomish','98205')
insert into ##temp_county (county, zip) values ('Snohomish','98206')
insert into ##temp_county (county, zip) values ('Snohomish','98207')
insert into ##temp_county (county, zip) values ('Snohomish','98208')
insert into ##temp_county (county, zip) values ('Snohomish','98213')
insert into ##temp_county (county, zip) values ('Whatcom','98220')
insert into ##temp_county (county, zip) values ('Skagit','98221')
insert into ##temp_county (county, zip) values ('San Juan','98222')
insert into ##temp_county (county, zip) values ('Snohomish','98223')
insert into ##temp_county (county, zip) values ('King','98224')
insert into ##temp_county (county, zip) values ('Whatcom','98225')
insert into ##temp_county (county, zip) values ('Whatcom','98226')
insert into ##temp_county (county, zip) values ('Whatcom','98227')
insert into ##temp_county (county, zip) values ('Whatcom','98228')
insert into ##temp_county (county, zip) values ('Whatcom','98229')
insert into ##temp_county (county, zip) values ('Whatcom','98230')
insert into ##temp_county (county, zip) values ('Whatcom','98231')
insert into ##temp_county (county, zip) values ('Skagit','98232')
insert into ##temp_county (county, zip) values ('Skagit','98233')
insert into ##temp_county (county, zip) values ('Skagit','98235')
insert into ##temp_county (county, zip) values ('Island','98236')
insert into ##temp_county (county, zip) values ('Skagit','98237')
insert into ##temp_county (county, zip) values ('Skagit','98238')
insert into ##temp_county (county, zip) values ('Island','98239')
insert into ##temp_county (county, zip) values ('Whatcom','98240')
insert into ##temp_county (county, zip) values ('Snohomish','98241')
insert into ##temp_county (county, zip) values ('San Juan','98243')
insert into ##temp_county (county, zip) values ('Whatcom','98244')
insert into ##temp_county (county, zip) values ('San Juan','98245')
insert into ##temp_county (county, zip) values ('Whatcom','98247')
insert into ##temp_county (county, zip) values ('Whatcom','98248')
insert into ##temp_county (county, zip) values ('Island','98249')
insert into ##temp_county (county, zip) values ('San Juan','98250')
insert into ##temp_county (county, zip) values ('Snohomish','98251')
insert into ##temp_county (county, zip) values ('Snohomish','98252')
insert into ##temp_county (county, zip) values ('Island','98253')
insert into ##temp_county (county, zip) values ('Skagit','98255')
insert into ##temp_county (county, zip) values ('Snohomish','98256')
insert into ##temp_county (county, zip) values ('Skagit','98257')
insert into ##temp_county (county, zip) values ('Snohomish','98258')
insert into ##temp_county (county, zip) values ('Snohomish','98259')
insert into ##temp_county (county, zip) values ('Island','98260')
insert into ##temp_county (county, zip) values ('San Juan','98261')
insert into ##temp_county (county, zip) values ('Whatcom','98262')
insert into ##temp_county (county, zip) values ('Skagit','98263')
insert into ##temp_county (county, zip) values ('Whatcom','98264')
insert into ##temp_county (county, zip) values ('Whatcom','98266')
insert into ##temp_county (county, zip) values ('Skagit','98267')
insert into ##temp_county (county, zip) values ('Snohomish','98270')
insert into ##temp_county (county, zip) values ('Snohomish','98271')
insert into ##temp_county (county, zip) values ('Snohomish','98272')
insert into ##temp_county (county, zip) values ('Skagit','98273')
insert into ##temp_county (county, zip) values ('Skagit','98274')
insert into ##temp_county (county, zip) values ('Snohomish','98275')
insert into ##temp_county (county, zip) values ('Whatcom','98276')
insert into ##temp_county (county, zip) values ('Island','98277')
insert into ##temp_county (county, zip) values ('Island','98278')
insert into ##temp_county (county, zip) values ('San Juan','98279')
insert into ##temp_county (county, zip) values ('San Juan','98280')
insert into ##temp_county (county, zip) values ('Whatcom','98281')
insert into ##temp_county (county, zip) values ('Island','98282')
insert into ##temp_county (county, zip) values ('Skagit','98283')
insert into ##temp_county (county, zip) values ('Skagit','98284')
insert into ##temp_county (county, zip) values ('San Juan','98286')
insert into ##temp_county (county, zip) values ('Snohomish','98287')
insert into ##temp_county (county, zip) values ('King','98288')
insert into ##temp_county (county, zip) values ('Snohomish','98290')
insert into ##temp_county (county, zip) values ('Snohomish','98291')
insert into ##temp_county (county, zip) values ('Snohomish','98292')
insert into ##temp_county (county, zip) values ('Snohomish','98293')
insert into ##temp_county (county, zip) values ('Snohomish','98294')
insert into ##temp_county (county, zip) values ('Whatcom','98295')
insert into ##temp_county (county, zip) values ('Snohomish','98296')
insert into ##temp_county (county, zip) values ('San Juan','98297')
insert into ##temp_county (county, zip) values ('Pierce','98303')
insert into ##temp_county (county, zip) values ('Pierce','98304')
insert into ##temp_county (county, zip) values ('Clallam','98305')
insert into ##temp_county (county, zip) values ('Kitsap','98310')
insert into ##temp_county (county, zip) values ('Kitsap','98311')
insert into ##temp_county (county, zip) values ('Kitsap','98312')
insert into ##temp_county (county, zip) values ('Kitsap','98314')
insert into ##temp_county (county, zip) values ('Kitsap','98315')
insert into ##temp_county (county, zip) values ('Jefferson','98320')
insert into ##temp_county (county, zip) values ('Pierce','98321')
insert into ##temp_county (county, zip) values ('Kitsap','98322')
insert into ##temp_county (county, zip) values ('Pierce','98323')
insert into ##temp_county (county, zip) values ('Clallam','98324')
insert into ##temp_county (county, zip) values ('Jefferson','98325')
insert into ##temp_county (county, zip) values ('Clallam','98326')
insert into ##temp_county (county, zip) values ('Pierce','98327')
insert into ##temp_county (county, zip) values ('Pierce','98328')
insert into ##temp_county (county, zip) values ('Pierce','98329')
insert into ##temp_county (county, zip) values ('Pierce','98330')
insert into ##temp_county (county, zip) values ('Clallam','98331')
insert into ##temp_county (county, zip) values ('Pierce','98332')
insert into ##temp_county (county, zip) values ('Pierce','98333')
insert into ##temp_county (county, zip) values ('Pierce','98335')
insert into ##temp_county (county, zip) values ('Lewis','98336')
insert into ##temp_county (county, zip) values ('Kitsap','98337')
insert into ##temp_county (county, zip) values ('Pierce','98338')
insert into ##temp_county (county, zip) values ('Jefferson','98339')
insert into ##temp_county (county, zip) values ('Kitsap','98340')
insert into ##temp_county (county, zip) values ('Kitsap','98342')
insert into ##temp_county (county, zip) values ('Clallam','98343')
insert into ##temp_county (county, zip) values ('Pierce','98344')
insert into ##temp_county (county, zip) values ('Kitsap','98345')
insert into ##temp_county (county, zip) values ('Kitsap','98346')
insert into ##temp_county (county, zip) values ('Pierce','98348')
insert into ##temp_county (county, zip) values ('Pierce','98349')
insert into ##temp_county (county, zip) values ('Clallam','98350')
insert into ##temp_county (county, zip) values ('Pierce','98351')
insert into ##temp_county (county, zip) values ('Pierce','98352')
insert into ##temp_county (county, zip) values ('Kitsap','98353')
insert into ##temp_county (county, zip) values ('Pierce','98354')
insert into ##temp_county (county, zip) values ('Lewis','98355')
insert into ##temp_county (county, zip) values ('Lewis','98356')
insert into ##temp_county (county, zip) values ('Clallam','98357')
insert into ##temp_county (county, zip) values ('Jefferson','98358')
insert into ##temp_county (county, zip) values ('Kitsap','98359')
insert into ##temp_county (county, zip) values ('Pierce','98360')
insert into ##temp_county (county, zip) values ('Lewis','98361')
insert into ##temp_county (county, zip) values ('Clallam','98362')
insert into ##temp_county (county, zip) values ('Clallam','98363')
insert into ##temp_county (county, zip) values ('Kitsap','98364')
insert into ##temp_county (county, zip) values ('Jefferson','98365')
insert into ##temp_county (county, zip) values ('Kitsap','98366')
insert into ##temp_county (county, zip) values ('Kitsap','98367')
insert into ##temp_county (county, zip) values ('Jefferson','98368')
insert into ##temp_county (county, zip) values ('Kitsap','98370')
insert into ##temp_county (county, zip) values ('Pierce','98371')
insert into ##temp_county (county, zip) values ('Pierce','98372')
insert into ##temp_county (county, zip) values ('Pierce','98373')
insert into ##temp_county (county, zip) values ('Pierce','98374')
insert into ##temp_county (county, zip) values ('Pierce','98375')
insert into ##temp_county (county, zip) values ('Jefferson','98376')
insert into ##temp_county (county, zip) values ('Lewis','98377')
insert into ##temp_county (county, zip) values ('Kitsap','98378')
insert into ##temp_county (county, zip) values ('Kitsap','98380')
insert into ##temp_county (county, zip) values ('Clallam','98381')
insert into ##temp_county (county, zip) values ('Clallam','98382')
insert into ##temp_county (county, zip) values ('Kitsap','98383')
insert into ##temp_county (county, zip) values ('Kitsap','98384')
insert into ##temp_county (county, zip) values ('Pierce','98385')
insert into ##temp_county (county, zip) values ('Kitsap','98386')
insert into ##temp_county (county, zip) values ('Pierce','98387')
insert into ##temp_county (county, zip) values ('Pierce','98388')
insert into ##temp_county (county, zip) values ('Pierce','98390')
insert into ##temp_county (county, zip) values ('Pierce','98391')
insert into ##temp_county (county, zip) values ('Kitsap','98392')
insert into ##temp_county (county, zip) values ('Kitsap','98393')
insert into ##temp_county (county, zip) values ('Pierce','98394')
insert into ##temp_county (county, zip) values ('Pierce','98395')
insert into ##temp_county (county, zip) values ('Pierce','98396')
insert into ##temp_county (county, zip) values ('Pierce','98397')
insert into ##temp_county (county, zip) values ('Pierce','98398')
insert into ##temp_county (county, zip) values ('Pierce','98401')
insert into ##temp_county (county, zip) values ('Pierce','98402')
insert into ##temp_county (county, zip) values ('Pierce','98403')
insert into ##temp_county (county, zip) values ('Pierce','98404')
insert into ##temp_county (county, zip) values ('Pierce','98405')
insert into ##temp_county (county, zip) values ('Pierce','98406')
insert into ##temp_county (county, zip) values ('Pierce','98407')
insert into ##temp_county (county, zip) values ('Pierce','98408')
insert into ##temp_county (county, zip) values ('Pierce','98409')
insert into ##temp_county (county, zip) values ('Pierce','98411')
insert into ##temp_county (county, zip) values ('Pierce','98412')
insert into ##temp_county (county, zip) values ('Pierce','98413')
insert into ##temp_county (county, zip) values ('Pierce','98415')
insert into ##temp_county (county, zip) values ('Pierce','98416')
insert into ##temp_county (county, zip) values ('Pierce','98417')
insert into ##temp_county (county, zip) values ('Pierce','98418')
insert into ##temp_county (county, zip) values ('Pierce','98419')
insert into ##temp_county (county, zip) values ('Pierce','98421')
insert into ##temp_county (county, zip) values ('Pierce','98422')
insert into ##temp_county (county, zip) values ('Pierce','98424')
insert into ##temp_county (county, zip) values ('Pierce','98430')
insert into ##temp_county (county, zip) values ('Pierce','98431')
insert into ##temp_county (county, zip) values ('Pierce','98433')
insert into ##temp_county (county, zip) values ('Pierce','98438')
insert into ##temp_county (county, zip) values ('Pierce','98439')
insert into ##temp_county (county, zip) values ('Pierce','98442')
insert into ##temp_county (county, zip) values ('Pierce','98443')
insert into ##temp_county (county, zip) values ('Pierce','98444')
insert into ##temp_county (county, zip) values ('Pierce','98445')
insert into ##temp_county (county, zip) values ('Pierce','98446')
insert into ##temp_county (county, zip) values ('Pierce','98447')
insert into ##temp_county (county, zip) values ('Pierce','98448')
insert into ##temp_county (county, zip) values ('Pierce','98450')
insert into ##temp_county (county, zip) values ('Pierce','98455')
insert into ##temp_county (county, zip) values ('Pierce','98460')
insert into ##temp_county (county, zip) values ('Pierce','98464')
insert into ##temp_county (county, zip) values ('Pierce','98465')
insert into ##temp_county (county, zip) values ('Pierce','98466')
insert into ##temp_county (county, zip) values ('Pierce','98467')
insert into ##temp_county (county, zip) values ('Pierce','98471')
insert into ##temp_county (county, zip) values ('Pierce','98477')
insert into ##temp_county (county, zip) values ('Pierce','98481')
insert into ##temp_county (county, zip) values ('Pierce','98490')
insert into ##temp_county (county, zip) values ('Pierce','98492')
insert into ##temp_county (county, zip) values ('Pierce','98493')
insert into ##temp_county (county, zip) values ('Pierce','98496')
insert into ##temp_county (county, zip) values ('Pierce','98497')
insert into ##temp_county (county, zip) values ('Pierce','98498')
insert into ##temp_county (county, zip) values ('Pierce','98499')
insert into ##temp_county (county, zip) values ('Thurston','98501')
insert into ##temp_county (county, zip) values ('Thurston','98502')
insert into ##temp_county (county, zip) values ('Thurston','98503')
insert into ##temp_county (county, zip) values ('Thurston','98504')
insert into ##temp_county (county, zip) values ('Thurston','98505')
insert into ##temp_county (county, zip) values ('Thurston','98506')
insert into ##temp_county (county, zip) values ('Thurston','98507')
insert into ##temp_county (county, zip) values ('Thurston','98508')
insert into ##temp_county (county, zip) values ('Thurston','98509')
insert into ##temp_county (county, zip) values ('Thurston','98511')
insert into ##temp_county (county, zip) values ('Thurston','98512')
insert into ##temp_county (county, zip) values ('Thurston','98513')
insert into ##temp_county (county, zip) values ('Thurston','98516')
insert into ##temp_county (county, zip) values ('Grays Harbor','98520')
insert into ##temp_county (county, zip) values ('Lewis','98522')
insert into ##temp_county (county, zip) values ('Mason','98524')
insert into ##temp_county (county, zip) values ('Grays Harbor','98526')
insert into ##temp_county (county, zip) values ('Pacific','98527')
insert into ##temp_county (county, zip) values ('Mason','98528')
insert into ##temp_county (county, zip) values ('Thurston','98530')
insert into ##temp_county (county, zip) values ('Lewis','98531')
insert into ##temp_county (county, zip) values ('Lewis','98532')
insert into ##temp_county (county, zip) values ('Lewis','98533')
insert into ##temp_county (county, zip) values ('Grays Harbor','98535')
insert into ##temp_county (county, zip) values ('Grays Harbor','98536')
insert into ##temp_county (county, zip) values ('Grays Harbor','98537')
insert into ##temp_county (county, zip) values ('Lewis','98538')
insert into ##temp_county (county, zip) values ('Lewis','98539')
insert into ##temp_county (county, zip) values ('Thurston','98540')
insert into ##temp_county (county, zip) values ('Grays Harbor','98541')
insert into ##temp_county (county, zip) values ('Lewis','98542')
insert into ##temp_county (county, zip) values ('Lewis','98544')
insert into ##temp_county (county, zip) values ('Mason','98546')
insert into ##temp_county (county, zip) values ('Grays Harbor','98547')
insert into ##temp_county (county, zip) values ('Mason','98548')
insert into ##temp_county (county, zip) values ('Grays Harbor','98550')
insert into ##temp_county (county, zip) values ('Grays Harbor','98552')
insert into ##temp_county (county, zip) values ('Pacific','98554')
insert into ##temp_county (county, zip) values ('Mason','98555')
insert into ##temp_county (county, zip) values ('Thurston','98556')
insert into ##temp_county (county, zip) values ('Grays Harbor','98557')
insert into ##temp_county (county, zip) values ('Pierce','98558')
insert into ##temp_county (county, zip) values ('Grays Harbor','98559')
insert into ##temp_county (county, zip) values ('Mason','98560')
insert into ##temp_county (county, zip) values ('Pacific','98561')
insert into ##temp_county (county, zip) values ('Grays Harbor','98562')
insert into ##temp_county (county, zip) values ('Grays Harbor','98563')
insert into ##temp_county (county, zip) values ('Lewis','98564')
insert into ##temp_county (county, zip) values ('Lewis','98565')
insert into ##temp_county (county, zip) values ('Grays Harbor','98566')
insert into ##temp_county (county, zip) values ('Grays Harbor','98568')
insert into ##temp_county (county, zip) values ('Grays Harbor','98569')
insert into ##temp_county (county, zip) values ('Lewis','98570')
insert into ##temp_county (county, zip) values ('Grays Harbor','98571')
insert into ##temp_county (county, zip) values ('Lewis','98572')
insert into ##temp_county (county, zip) values ('Grays Harbor','98575')
insert into ##temp_county (county, zip) values ('Thurston','98576')
insert into ##temp_county (county, zip) values ('Pacific','98577')
insert into ##temp_county (county, zip) values ('Thurston','98579')
insert into ##temp_county (county, zip) values ('Pierce','98580')
insert into ##temp_county (county, zip) values ('Cowlitz','98581')
insert into ##temp_county (county, zip) values ('Lewis','98582')
insert into ##temp_county (county, zip) values ('Grays Harbor','98583')
insert into ##temp_county (county, zip) values ('Mason','98584')
insert into ##temp_county (county, zip) values ('Lewis','98585')
insert into ##temp_county (county, zip) values ('Pacific','98586')
insert into ##temp_county (county, zip) values ('Grays Harbor','98587')
insert into ##temp_county (county, zip) values ('Mason','98588')
insert into ##temp_county (county, zip) values ('Thurston','98589')
insert into ##temp_county (county, zip) values ('Pacific','98590')
insert into ##temp_county (county, zip) values ('Lewis','98591')
insert into ##temp_county (county, zip) values ('Mason','98592')
insert into ##temp_county (county, zip) values ('Lewis','98593')
insert into ##temp_county (county, zip) values ('Grays Harbor','98595')
insert into ##temp_county (county, zip) values ('Lewis','98596')
insert into ##temp_county (county, zip) values ('Thurston','98597')
insert into ##temp_county (county, zip) values ('Thurston','98599')
insert into ##temp_county (county, zip) values ('Clark','98601')
insert into ##temp_county (county, zip) values ('Klickitat','98602')
insert into ##temp_county (county, zip) values ('Cowlitz','98603')
insert into ##temp_county (county, zip) values ('Clark','98604')
insert into ##temp_county (county, zip) values ('Klickitat','98605')
insert into ##temp_county (county, zip) values ('Clark','98606')
insert into ##temp_county (county, zip) values ('Clark','98607')
insert into ##temp_county (county, zip) values ('Cowlitz','98609')
insert into ##temp_county (county, zip) values ('Skamania','98610')
insert into ##temp_county (county, zip) values ('Cowlitz','98611')
insert into ##temp_county (county, zip) values ('Wahkiakum','98612')
insert into ##temp_county (county, zip) values ('Klickitat','98613')
insert into ##temp_county (county, zip) values ('Pacific','98614')
insert into ##temp_county (county, zip) values ('Cowlitz','98616')
insert into ##temp_county (county, zip) values ('Klickitat','98617')
insert into ##temp_county (county, zip) values ('Klickitat','98619')
insert into ##temp_county (county, zip) values ('Klickitat','98620')
insert into ##temp_county (county, zip) values ('Wahkiakum','98621')
insert into ##temp_county (county, zip) values ('Clark','98622')
insert into ##temp_county (county, zip) values ('Klickitat','98623')
insert into ##temp_county (county, zip) values ('Pacific','98624')
insert into ##temp_county (county, zip) values ('Cowlitz','98625')
insert into ##temp_county (county, zip) values ('Cowlitz','98626')
insert into ##temp_county (county, zip) values ('Klickitat','98628')
insert into ##temp_county (county, zip) values ('Clark','98629')
insert into ##temp_county (county, zip) values ('Pacific','98631')
insert into ##temp_county (county, zip) values ('Cowlitz','98632')
insert into ##temp_county (county, zip) values ('Klickitat','98635')
insert into ##temp_county (county, zip) values ('Pacific','98637')
insert into ##temp_county (county, zip) values ('Pacific','98638')
insert into ##temp_county (county, zip) values ('Skamania','98639')
insert into ##temp_county (county, zip) values ('Pacific','98640')
insert into ##temp_county (county, zip) values ('Pacific','98641')
insert into ##temp_county (county, zip) values ('Clark','98642')
insert into ##temp_county (county, zip) values ('Wahkiakum','98643')
insert into ##temp_county (county, zip) values ('Pacific','98644')
insert into ##temp_county (county, zip) values ('Cowlitz','98645')
insert into ##temp_county (county, zip) values ('Wahkiakum','98647')
insert into ##temp_county (county, zip) values ('Skamania','98648')
insert into ##temp_county (county, zip) values ('Cowlitz','98649')
insert into ##temp_county (county, zip) values ('Klickitat','98650')
insert into ##temp_county (county, zip) values ('Skamania','98651')
insert into ##temp_county (county, zip) values ('Clark','98660')
insert into ##temp_county (county, zip) values ('Clark','98661')
insert into ##temp_county (county, zip) values ('Clark','98662')
insert into ##temp_county (county, zip) values ('Clark','98663')
insert into ##temp_county (county, zip) values ('Clark','98664')
insert into ##temp_county (county, zip) values ('Clark','98665')
insert into ##temp_county (county, zip) values ('Clark','98666')
insert into ##temp_county (county, zip) values ('Clark','98667')
insert into ##temp_county (county, zip) values ('Clark','98668')
insert into ##temp_county (county, zip) values ('Klickitat','98670')
insert into ##temp_county (county, zip) values ('Clark','98671')
insert into ##temp_county (county, zip) values ('Klickitat','98672')
insert into ##temp_county (county, zip) values ('Klickitat','98673')
insert into ##temp_county (county, zip) values ('Cowlitz','98674')
insert into ##temp_county (county, zip) values ('Clark','98675')
insert into ##temp_county (county, zip) values ('Clark','98682')
insert into ##temp_county (county, zip) values ('Clark','98683')
insert into ##temp_county (county, zip) values ('Clark','98684')
insert into ##temp_county (county, zip) values ('Clark','98685')
insert into ##temp_county (county, zip) values ('Clark','98686')
insert into ##temp_county (county, zip) values ('Clark','98687')
insert into ##temp_county (county, zip) values ('Chelan','98801')
insert into ##temp_county (county, zip) values ('Douglas','98802')
insert into ##temp_county (county, zip) values ('Chelan','98807')
insert into ##temp_county (county, zip) values ('Chelan','98811')
insert into ##temp_county (county, zip) values ('Okanogan','98812')
insert into ##temp_county (county, zip) values ('Douglas','98813')
insert into ##temp_county (county, zip) values ('Okanogan','98814')
insert into ##temp_county (county, zip) values ('Chelan','98815')
insert into ##temp_county (county, zip) values ('Chelan','98816')
insert into ##temp_county (county, zip) values ('Chelan','98817')
insert into ##temp_county (county, zip) values ('Okanogan','98819')
insert into ##temp_county (county, zip) values ('Chelan','98821')
insert into ##temp_county (county, zip) values ('Chelan','98822')
insert into ##temp_county (county, zip) values ('Grant','98823')
insert into ##temp_county (county, zip) values ('Grant','98824')
insert into ##temp_county (county, zip) values ('Chelan','98826')
insert into ##temp_county (county, zip) values ('Okanogan','98827')
insert into ##temp_county (county, zip) values ('Chelan','98828')
insert into ##temp_county (county, zip) values ('Okanogan','98829')
insert into ##temp_county (county, zip) values ('Douglas','98830')
insert into ##temp_county (county, zip) values ('Chelan','98831')
insert into ##temp_county (county, zip) values ('Grant','98832')
insert into ##temp_county (county, zip) values ('Okanogan','98833')
insert into ##temp_county (county, zip) values ('Okanogan','98834')
insert into ##temp_county (county, zip) values ('Chelan','98836')
insert into ##temp_county (county, zip) values ('Grant','98837')
insert into ##temp_county (county, zip) values ('Okanogan','98840')
insert into ##temp_county (county, zip) values ('Okanogan','98841')
insert into ##temp_county (county, zip) values ('Douglas','98843')
insert into ##temp_county (county, zip) values ('Okanogan','98844')
insert into ##temp_county (county, zip) values ('Douglas','98845')
insert into ##temp_county (county, zip) values ('Okanogan','98846')
insert into ##temp_county (county, zip) values ('Chelan','98847')
insert into ##temp_county (county, zip) values ('Grant','98848')
insert into ##temp_county (county, zip) values ('Okanogan','98849')
insert into ##temp_county (county, zip) values ('Douglas','98850')
insert into ##temp_county (county, zip) values ('Grant','98851')
insert into ##temp_county (county, zip) values ('Chelan','98852')
insert into ##temp_county (county, zip) values ('Grant','98853')
insert into ##temp_county (county, zip) values ('Okanogan','98855')
insert into ##temp_county (county, zip) values ('Okanogan','98856')
insert into ##temp_county (county, zip) values ('Grant','98857')
insert into ##temp_county (county, zip) values ('Douglas','98858')
insert into ##temp_county (county, zip) values ('Okanogan','98859')
insert into ##temp_county (county, zip) values ('Grant','98860')
insert into ##temp_county (county, zip) values ('Okanogan','98862')
insert into ##temp_county (county, zip) values ('Yakima','98901')
insert into ##temp_county (county, zip) values ('Yakima','98902')
insert into ##temp_county (county, zip) values ('Yakima','98903')
insert into ##temp_county (county, zip) values ('Yakima','98904')
insert into ##temp_county (county, zip) values ('Yakima','98907')
insert into ##temp_county (county, zip) values ('Yakima','98908')
insert into ##temp_county (county, zip) values ('Yakima','98909')
insert into ##temp_county (county, zip) values ('Yakima','98920')
insert into ##temp_county (county, zip) values ('Yakima','98921')
insert into ##temp_county (county, zip) values ('Kittitas','98922')
insert into ##temp_county (county, zip) values ('Yakima','98923')
insert into ##temp_county (county, zip) values ('Kittitas','98925')
insert into ##temp_county (county, zip) values ('Kittitas','98926')
insert into ##temp_county (county, zip) values ('Yakima','98929')
insert into ##temp_county (county, zip) values ('Yakima','98930')
insert into ##temp_county (county, zip) values ('Yakima','98932')
insert into ##temp_county (county, zip) values ('Yakima','98933')
insert into ##temp_county (county, zip) values ('Kittitas','98934')
insert into ##temp_county (county, zip) values ('Yakima','98935')
insert into ##temp_county (county, zip) values ('Yakima','98936')
insert into ##temp_county (county, zip) values ('Yakima','98937')
insert into ##temp_county (county, zip) values ('Yakima','98938')
insert into ##temp_county (county, zip) values ('Yakima','98939')
insert into ##temp_county (county, zip) values ('Kittitas','98940')
insert into ##temp_county (county, zip) values ('Kittitas','98941')
insert into ##temp_county (county, zip) values ('Yakima','98942')
insert into ##temp_county (county, zip) values ('Kittitas','98943')
insert into ##temp_county (county, zip) values ('Yakima','98944')
insert into ##temp_county (county, zip) values ('Kittitas','98946')
insert into ##temp_county (county, zip) values ('Yakima','98947')
insert into ##temp_county (county, zip) values ('Yakima','98948')
insert into ##temp_county (county, zip) values ('Kittitas','98950')
insert into ##temp_county (county, zip) values ('Yakima','98951')
insert into ##temp_county (county, zip) values ('Yakima','98952')
insert into ##temp_county (county, zip) values ('Yakima','98953')
insert into ##temp_county (county, zip) values ('Spokane','99001')
insert into ##temp_county (county, zip) values ('Spokane','99003')
insert into ##temp_county (county, zip) values ('Spokane','99004')
insert into ##temp_county (county, zip) values ('Spokane','99005')
insert into ##temp_county (county, zip) values ('Spokane','99006')
insert into ##temp_county (county, zip) values ('Lincoln','99008')
insert into ##temp_county (county, zip) values ('Spokane','99009')
insert into ##temp_county (county, zip) values ('Spokane','99011')
insert into ##temp_county (county, zip) values ('Spokane','99012')
insert into ##temp_county (county, zip) values ('Stevens','99013')
insert into ##temp_county (county, zip) values ('Spokane','99014')
insert into ##temp_county (county, zip) values ('Spokane','99016')
insert into ##temp_county (county, zip) values ('Whitman','99017')
insert into ##temp_county (county, zip) values ('Spokane','99018')
insert into ##temp_county (county, zip) values ('Spokane','99019')
insert into ##temp_county (county, zip) values ('Spokane','99020')
insert into ##temp_county (county, zip) values ('Spokane','99021')
insert into ##temp_county (county, zip) values ('Spokane','99022')
insert into ##temp_county (county, zip) values ('Spokane','99023')
insert into ##temp_county (county, zip) values ('Spokane','99025')
insert into ##temp_county (county, zip) values ('Spokane','99026')
insert into ##temp_county (county, zip) values ('Spokane','99027')
insert into ##temp_county (county, zip) values ('Lincoln','99029')
insert into ##temp_county (county, zip) values ('Spokane','99030')
insert into ##temp_county (county, zip) values ('Spokane','99031')
insert into ##temp_county (county, zip) values ('Lincoln','99032')
insert into ##temp_county (county, zip) values ('Whitman','99033')
insert into ##temp_county (county, zip) values ('Stevens','99034')
insert into ##temp_county (county, zip) values ('Spokane','99036')
insert into ##temp_county (county, zip) values ('Spokane','99037')
insert into ##temp_county (county, zip) values ('Spokane','99039')
insert into ##temp_county (county, zip) values ('Stevens','99040')
insert into ##temp_county (county, zip) values ('Stevens','99101')
insert into ##temp_county (county, zip) values ('Whitman','99102')
insert into ##temp_county (county, zip) values ('Lincoln','99103')
insert into ##temp_county (county, zip) values ('Whitman','99104')
insert into ##temp_county (county, zip) values ('Adams','99105')
insert into ##temp_county (county, zip) values ('Ferry','99107')
insert into ##temp_county (county, zip) values ('Stevens','99109')
insert into ##temp_county (county, zip) values ('Stevens','99110')
insert into ##temp_county (county, zip) values ('Whitman','99111')
insert into ##temp_county (county, zip) values ('Whitman','99113')
insert into ##temp_county (county, zip) values ('Stevens','99114')
insert into ##temp_county (county, zip) values ('Grant','99115')
insert into ##temp_county (county, zip) values ('Okanogan','99116')
insert into ##temp_county (county, zip) values ('Lincoln','99117')
insert into ##temp_county (county, zip) values ('Ferry','99118')
insert into ##temp_county (county, zip) values ('Pend Oreille','99119')
insert into ##temp_county (county, zip) values ('Ferry','99121')
insert into ##temp_county (county, zip) values ('Lincoln','99122')
insert into ##temp_county (county, zip) values ('Grant','99123')
insert into ##temp_county (county, zip) values ('Okanogan','99124')
insert into ##temp_county (county, zip) values ('Whitman','99125')
insert into ##temp_county (county, zip) values ('Stevens','99126')
insert into ##temp_county (county, zip) values ('Whitman','99128')
insert into ##temp_county (county, zip) values ('Stevens','99129')
insert into ##temp_county (county, zip) values ('Whitman','99130')
insert into ##temp_county (county, zip) values ('Stevens','99131')
insert into ##temp_county (county, zip) values ('Grant','99133')
insert into ##temp_county (county, zip) values ('Lincoln','99134')
insert into ##temp_county (county, zip) values ('Grant','99135')
insert into ##temp_county (county, zip) values ('Whitman','99136')
insert into ##temp_county (county, zip) values ('Stevens','99137')
insert into ##temp_county (county, zip) values ('Ferry','99138')
insert into ##temp_county (county, zip) values ('Pend Oreille','99139')
insert into ##temp_county (county, zip) values ('Ferry','99140')
insert into ##temp_county (county, zip) values ('Stevens','99141')
insert into ##temp_county (county, zip) values ('Whitman','99143')
insert into ##temp_county (county, zip) values ('Lincoln','99144')
insert into ##temp_county (county, zip) values ('Ferry','99146')
insert into ##temp_county (county, zip) values ('Lincoln','99147')
insert into ##temp_county (county, zip) values ('Stevens','99148')
insert into ##temp_county (county, zip) values ('Whitman','99149')
insert into ##temp_county (county, zip) values ('Ferry','99150')
insert into ##temp_county (county, zip) values ('Stevens','99151')
insert into ##temp_county (county, zip) values ('Pend Oreille','99152')
insert into ##temp_county (county, zip) values ('Pend Oreille','99153')
insert into ##temp_county (county, zip) values ('Lincoln','99154')
insert into ##temp_county (county, zip) values ('Okanogan','99155')
insert into ##temp_county (county, zip) values ('Pend Oreille','99156')
insert into ##temp_county (county, zip) values ('Stevens','99157')
insert into ##temp_county (county, zip) values ('Whitman','99158')
insert into ##temp_county (county, zip) values ('Lincoln','99159')
insert into ##temp_county (county, zip) values ('Ferry','99160')
insert into ##temp_county (county, zip) values ('Whitman','99161')
insert into ##temp_county (county, zip) values ('Whitman','99163')
insert into ##temp_county (county, zip) values ('Whitman','99164')
insert into ##temp_county (county, zip) values ('Whitman','99165')
insert into ##temp_county (county, zip) values ('Ferry','99166')
insert into ##temp_county (county, zip) values ('Stevens','99167')
insert into ##temp_county (county, zip) values ('Adams','99169')
insert into ##temp_county (county, zip) values ('Whitman','99170')
insert into ##temp_county (county, zip) values ('Whitman','99171')
insert into ##temp_county (county, zip) values ('Stevens','99173')
insert into ##temp_county (county, zip) values ('Whitman','99174')
insert into ##temp_county (county, zip) values ('Whitman','99176')
insert into ##temp_county (county, zip) values ('Whitman','99179')
insert into ##temp_county (county, zip) values ('Pend Oreille','99180')
insert into ##temp_county (county, zip) values ('Stevens','99181')
insert into ##temp_county (county, zip) values ('Lincoln','99185')
insert into ##temp_county (county, zip) values ('Spokane','99201')
insert into ##temp_county (county, zip) values ('Spokane','99202')
insert into ##temp_county (county, zip) values ('Spokane','99203')
insert into ##temp_county (county, zip) values ('Spokane','99204')
insert into ##temp_county (county, zip) values ('Spokane','99205')
insert into ##temp_county (county, zip) values ('Spokane','99206')
insert into ##temp_county (county, zip) values ('Spokane','99207')
insert into ##temp_county (county, zip) values ('Spokane','99208')
insert into ##temp_county (county, zip) values ('Spokane','99209')
insert into ##temp_county (county, zip) values ('Spokane','99210')
insert into ##temp_county (county, zip) values ('Spokane','99211')
insert into ##temp_county (county, zip) values ('Spokane','99212')
insert into ##temp_county (county, zip) values ('Spokane','99213')
insert into ##temp_county (county, zip) values ('Spokane','99214')
insert into ##temp_county (county, zip) values ('Spokane','99215')
insert into ##temp_county (county, zip) values ('Spokane','99216')
insert into ##temp_county (county, zip) values ('Spokane','99217')
insert into ##temp_county (county, zip) values ('Spokane','99218')
insert into ##temp_county (county, zip) values ('Spokane','99219')
insert into ##temp_county (county, zip) values ('Spokane','99220')
insert into ##temp_county (county, zip) values ('Spokane','99223')
insert into ##temp_county (county, zip) values ('Spokane','99224')
insert into ##temp_county (county, zip) values ('Spokane','99228')
insert into ##temp_county (county, zip) values ('Spokane','99251')
insert into ##temp_county (county, zip) values ('Spokane','99252')
insert into ##temp_county (county, zip) values ('Spokane','99256')
insert into ##temp_county (county, zip) values ('Spokane','99258')
insert into ##temp_county (county, zip) values ('Spokane','99260')
insert into ##temp_county (county, zip) values ('Spokane','99299')
insert into ##temp_county (county, zip) values ('Franklin','99301')
insert into ##temp_county (county, zip) values ('Franklin','99302')
insert into ##temp_county (county, zip) values ('Benton','99320')
insert into ##temp_county (county, zip) values ('Grant','99321')
insert into ##temp_county (county, zip) values ('Klickitat','99322')
insert into ##temp_county (county, zip) values ('Walla Walla','99323')
insert into ##temp_county (county, zip) values ('Walla Walla','99324')
insert into ##temp_county (county, zip) values ('Franklin','99326')
insert into ##temp_county (county, zip) values ('Columbia','99328')
insert into ##temp_county (county, zip) values ('Walla Walla','99329')
insert into ##temp_county (county, zip) values ('Franklin','99330')
insert into ##temp_county (county, zip) values ('Whitman','99333')
insert into ##temp_county (county, zip) values ('Franklin','99335')
insert into ##temp_county (county, zip) values ('Benton','99336')
insert into ##temp_county (county, zip) values ('Benton','99337')
insert into ##temp_county (county, zip) values ('Benton','99338')
insert into ##temp_county (county, zip) values ('Adams','99341')
insert into ##temp_county (county, zip) values ('Franklin','99343')
insert into ##temp_county (county, zip) values ('Adams','99344')
insert into ##temp_county (county, zip) values ('Benton','99345')
insert into ##temp_county (county, zip) values ('Benton','99346')
insert into ##temp_county (county, zip) values ('Garfield','99347')
insert into ##temp_county (county, zip) values ('Walla Walla','99348')
insert into ##temp_county (county, zip) values ('Grant','99349')
insert into ##temp_county (county, zip) values ('Benton','99350')
insert into ##temp_county (county, zip) values ('Benton','99352')
insert into ##temp_county (county, zip) values ('Benton','99353')
insert into ##temp_county (county, zip) values ('Benton','99354')
insert into ##temp_county (county, zip) values ('Klickitat','99356')
insert into ##temp_county (county, zip) values ('Grant','99357')
insert into ##temp_county (county, zip) values ('Columbia','99359')
insert into ##temp_county (county, zip) values ('Walla Walla','99360')
insert into ##temp_county (county, zip) values ('Walla Walla','99361')
insert into ##temp_county (county, zip) values ('Walla Walla','99362')
insert into ##temp_county (county, zip) values ('Walla Walla','99363')
insert into ##temp_county (county, zip) values ('Adams','99371')
insert into ##temp_county (county, zip) values ('Asotin','99401')
insert into ##temp_county (county, zip) values ('Asotin','99402')
insert into ##temp_county (county, zip) values ('Asotin','99403')

-- end county table creation
--/*
--test remove before running
--*/
--declare @yr int, @qtr int, @proc_ind int, @fayr int
--declare @biennium date  --used to select the most current FINORG for majors and courses
--/*
--This file is used to create only one quarter of data using the 
--current Registrar's rules for inclusion in 'official' numbers
--*/

--set @yr=2018
--set @qtr=3
--set @biennium='6-30-2019'  --next will be 6-30-2017
--set @proc_ind=1
--set @fayr=2019
/*
Make census population  
This includes all Tacoma majors, regardless of where they are taking classes, and all student taking classes in Tacoma
*/

select distinct
smmv.mm_system_key as system_key
,smmv.mm_year as yr
,smmv.mm_qtr as qtr
,smmv.mm_proc_ind as proc_ind
,deg_level=case smmdp.mm_deg_level when 0 then 1 else smmdp.mm_deg_level end  --THIS CREATES DUPLICATES!
into ##census_population --drop table ##census_population  --select * from ##census_population
from uwsdbdatastore.sec.sr_mini_master smmv
inner join uwsdbdatastore.sec.sr_mini_master_deg_program smmdp
   on smmv.mm_year = smmdp.mm_year and
      smmv.mm_qtr = smmdp.mm_qtr and
      smmv.mm_proc_ind = smmdp.mm_proc_ind
      and smmv.mm_student_no =smmdp.mm_student_no	 
where smmv.mm_year*10+smmv.mm_qtr=@runforyrqtr and --=@yr and smmv.mm_qtr=@qtr and
      smmv.mm_proc_ind=@proc_ind and 
	  smmv.mm_enroll_status=12 and
	  ((smmv.mm_tac_st_funded+smmv.mm_tac_self_sus+smmv.mm_tac_audit>0) or (smmdp.mm_branch=2))
order by smmv.mm_system_key

-- end make census population




--end test population
/*
create a guardian table
primarily for information on first generation and gross_income both are non-maditory fields
*/
select
j.system_key,
guardian_ed_level=(case j.guardian_high_ed_level
                  when 1 then 'SOME SCHOOL'
                  when 2 then 'HS GRADUATE'
                  when 3 then 'SOME COLLEGE'
                  when 4 then '2YR COLLEGE'
                  when 5 then '4YR COLLEGE'
                  when 6 then 'POSTGRADUATE'
                  when 0 then 'NONE '
                  else 'empty'
                  end),
first_generation=case when j.guardian_high_ed_level in (6,5) then 'Not First Generation'--in ('POSTGRADUATE','4YR COLLEGE') then 'Not First Generation'
				   when j.guardian_high_ed_level in (3,4) then 'First to BA Degree' --in('SOME COLLEGE','2YR COLLEGE') then 'First to BA Degree'
				   when j.guardian_high_ed_level in (1,0,2) then 'First to College'--in ('SOME SCHOOL', 'NONE','HS GRADUATE') then 'First to College'
				   else null end,
k.guardian_gross_income
into ##guardian 
from ##census_population ip
left join
         (select distinct
               system_key,
               max(guardian_ed_level) as guardian_high_ed_level
          from uwsdbdatastore.sec.sr_adm_appl_guardian_data 
         group by system_key
         )j
on ip.system_key=j.system_key
left join (select distinct
               system_key,
               max(income_gross) as guardian_gross_income
          from uwsdbdatastore.sec.sr_adm_appl_income_data 
         group by system_key
         )k
on k.system_key=j.system_key  
--end guardian table


/*
create a table of max sat component scores to be flattened
*/
select
   ip.system_key,
   z.test_type,
   maxscore=max(z.test_score)
into ##max_sat_parts
from ##census_population ip
left join (
            select 
                  a.system_key,
                  b.test_dt,
                  b.test_type,
                  b.test_score
             from uwsdbdatastore.sec.sr_adm_appl a
            inner join uwsdbdatastore.sec.sr_test_scores b  --select * from uwsdbdatastore.sec.sr_test_scores
              on b.system_key=a.system_key
			inner join ##census_population ip
			on a.system_key=ip.system_key
            where b.test_type in ('SAT CR', 'SAT M', 'SAT W', 'SATMTH', 'SATR', 'SATRW', 'SATWL')
           )z
on ip.system_key=z.system_key
   group by ip.system_key, z.test_type
   

select distinct
ip.system_key,
za.sat_m,
zb.sat_v,
zc.sat_w,
zd.sat_mth,
ze.sat_r,
zf.sat_rw,
zg.sat_wl
into ##max_sat_grid  --select * from ##max_sat_grid
from ##census_population ip
left join  ##max_sat_parts z
on ip.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as sat_m
      from ##max_sat_parts z
      where z.test_type='SAT M'
      )za
on za.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as sat_v
      from ##max_sat_parts z
      where z.test_type='SAT CR'
      )zb
on zb.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as sat_w
      from ##max_sat_parts z
      where z.test_type='SAT W'
      )zc
on zc.system_key=z.system_key
--adding 'SATMTH', 'SATR', 'SATRW', 'SATWL'
left join (
      select 
      z.system_key,
      z.maxscore as sat_mth
      from ##max_sat_parts z
      where z.test_type='SATMTH'
      )zd
on zd.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as sat_r
      from ##max_sat_parts z
      where z.test_type='SATR'
      )ze
on ze.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as sat_rw
      from ##max_sat_parts z
      where z.test_type='SATRW'
      )zf
on zf.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as sat_wl
      from ##max_sat_parts z
      where z.test_type='SATWL'
      )zg
on zg.system_key=z.system_key
order by ip.system_key



-----------
--
-- create a table of count of SAT attempts
--
------------

select distinct
z.system_key,
za.cnt_SATMTH,
zb.cnt_SATR,
zc.cnt_SATRW,
zd.cnt_SATWL
into ##sat_attempts
from uwsdbdatastore.sec.sr_test_scores z
left join (
      select 
      z.system_key,
      count(z.test_type) as cnt_SATMTH
      from  uwsdbdatastore.sec.sr_test_scores z
      where z.test_type='SATMTH'
      group by z.system_key
      )za
on za.system_key=z.system_key
left join (
      select 
      z.system_key,
      count(z.test_type) as cnt_SATR
      from  uwsdbdatastore.sec.sr_test_scores z
      where z.test_type='SATR'
      group by z.system_key
      )zb
on zb.system_key=z.system_key
left join (
      select 
      z.system_key,
      count(z.test_type) as cnt_SATRW
      from  uwsdbdatastore.sec.sr_test_scores z
      where z.test_type='SATRW'
      group by z.system_key
      )zc
on zc.system_key=z.system_key
left join (
      select 
      z.system_key,
      count(z.test_type) as cnt_SATWL
      from  uwsdbdatastore.sec.sr_test_scores z
      where z.test_type='SATWL'
      group by z.system_key
      )zd
on zd.system_key=z.system_key
where za.cnt_SATMTH >0 or zb.cnt_SATR >0
order by z.system_key
--end SAT score 

-----------
--
-- create a table of max act component scores
--
------------

--begin
select
   z.system_key,
   z.test_type,
   maxscore=max(z.test_score)
into ##max_act_parts
    from (
            select 
                  a.system_key,
                  b.test_dt,
                  b.test_type,
                  b.test_score
             from  uwsdbdatastore.sec.sr_adm_appl a
            inner join  uwsdbdatastore.sec.sr_test_scores b
              on b.system_key=a.system_key
            where b.test_type in ('ACT','ACT E','ACT M','ACT R','ACT WR')
          )z
   group by z.system_key, z.test_type
   

--end
select distinct
z.system_key,
za.act as act_max,
zb.act_e as acte_max,
zc.act_m as actm_max,
zd.act_r as actr_max,
ze.act_wr as actwr_max
into ##max_act_grid
 from ##max_act_parts z
left join (
      select 
      z.system_key,
      z.maxscore as act
      from ##max_act_parts z
      where z.test_type='ACT'
      )za
on za.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as act_e
      from ##max_act_parts z
      where z.test_type='ACT E'
      )zb
on zb.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as act_m
      from ##max_act_parts z
      where z.test_type='ACT M'
      )zc
on zc.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as act_r
      from ##max_act_parts z
      where z.test_type='ACT R'
      )zd
on zd.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as act_wr
      from ##max_act_parts z
      where z.test_type='ACT WR'
      )ze
on ze.system_key=z.system_key

order by z.system_key



-----------
--
-- create a table of max GRE component scores
--
------------

--begin
select
   z.system_key,
   z.test_type,
   maxscore=max(z.test_score)
into ##max_gre_parts  
    from (
            select 
                  a.system_key,
                  b.test_dt,
                  b.test_type,
                  b.test_score
             from  uwsdbdatastore.sec.sr_adm_appl a
            inner join  uwsdbdatastore.sec.sr_test_scores b
              on b.system_key=a.system_key
            where b.test_type like '%GRE%'
            )z
   group by z.system_key, z.test_type
   --end


select distinct
z.system_key,
za.gre_a,
zb.gre_q,
zc.gre_v,
zd.gre_w
into ##max_gre_grid
 from ##max_gre_parts z
left join (
      select 
      z.system_key,
      z.maxscore as gre_a
      from ##max_gre_parts z
      where z.test_type='GREA'
      )za
on za.system_key=z.system_key
left join (
      select 
      z.system_key,
      z.maxscore as gre_q
      from ##max_gre_parts z
      where z.test_type='GRE Q'
      )zb
on zb.system_key=z.system_key
left join (
     select 
      z.system_key,
      z.maxscore as gre_v
      from ##max_gre_parts z
      where z.test_type='GRE  V'
      )zc
on zc.system_key=z.system_key
left join (
     select 
      z.system_key,
      z.maxscore as gre_w
      from ##max_gre_parts z
      where z.test_type='GREW'
      )zd
on zd.system_key=z.system_key
order by z.system_key

--end test score information gathering


/*
Create a table of last  UW degrees awarded
*/

--Undergraduate degrees

select distinct
x.system_key,
x.deg_earned_yr,
x.deg_earned_qtr,
x.deg_level,
x.deg_type,
x.deg_gpa,
x.deg_uw_credits,
x.deg_trans_credits,
x.deg_exten_credits,
x.deg_date
into ##last_degree_ug
from (
      select 
      sdi2.system_key,
	  sdi2.deg_branch,
      sdi2.deg_earned_yr,
      sdi2.deg_earned_qtr,
      sdi2.deg_level,
      sdi2.deg_type,
      sdi2.deg_title,
      sdi2.deg_gpa,
      sdi2.deg_uw_credits,
      sdi2.deg_trans_credits,
      sdi2.deg_exten_credits,
      sdi2.deg_date
      from  uwsdbdatastore.sec.student_2_uw_degree_info sdi2
      inner join (
            select 
                  sdi.system_key,
				  sdi.deg_branch,
                  last_uwt_degree=max(sdi.deg_date)
             from  uwsdbdatastore.sec.student_2_uw_degree_info sdi
            where sdi.deg_status=9 and sdi.deg_branch=2 and sdi.deg_level <2
            group by sdi.system_key, sdi.deg_branch
            )last_deg
      on sdi2.system_key=last_deg.system_key 
      and sdi2.deg_date=last_deg.last_uwt_degree 
	  and sdi2.deg_branch=last_deg.deg_branch
      )x


--Graduate degrees

select distinct
x.system_key,
x.deg_earned_yr,
x.deg_earned_qtr,
x.deg_level,
x.deg_type,
x.deg_gpa,
x.deg_uw_credits,
x.deg_trans_credits,
x.deg_exten_credits,
x.deg_date
into ##last_degree_gr
from (
      select 
      sdi2.system_key,
      sdi2.deg_earned_yr,
      sdi2.deg_earned_qtr,
	  sdi2.deg_branch,
      sdi2.deg_level,
      sdi2.deg_type,
      sdi2.deg_title,
      sdi2.deg_gpa,
      sdi2.deg_uw_credits,
      sdi2.deg_trans_credits,
      sdi2.deg_exten_credits,
      sdi2.deg_date
      from  uwsdbdatastore.sec.student_2_uw_degree_info sdi2
      inner join (
            select 
                  sdi.system_key,
				  sdi.deg_branch,
                  last_uwt_degree=max(sdi.deg_date)
             from  uwsdbdatastore.sec.student_2_uw_degree_info sdi
            where sdi.deg_status=9 and sdi.deg_branch=2 and sdi.deg_level >1
            group by sdi.system_key, sdi.deg_branch
            )last_deg
      on sdi2.system_key=last_deg.system_key 
      and sdi2.deg_date=last_deg.last_uwt_degree
	  and sdi2.deg_branch=last_deg.deg_branch 
      )x

--end of UW degree data



/*
get origin data from EDW.  There are problems with this data (inconsistancies) but since it is used in Profiles it is 
convienient to have it here as well
*/
select 
ip.system_key
,gr.AcademicCareerLevel
,gr.AcademicCareerLevelName
,gr.StudentCohortYear
,gr.StudentCohortQtr
,gr.EntryTransferStudentFlag
,gr.AcademicCareerEntryType as UGEntryType --gr.UGEntryType,
,gr.EntryFullTimeStudentFlag as initial_attendance_ft--gr.UGFT as initial_attendance_ft,
,gr.EntryCensusDayPellEligibleStudentFlag as StartPellElig--,gr.StartPELLElig
,gr.EntryWashingtonCommunityCollegeFlag as WA_CC_Origin--,gr.WA_CC_Origin
,gr.EntryCampus as StartBranchEntry --gr.StartBranchEntry
,gr.EntryTacomaStudentInd
into ##origin  --select * from ##origin
from ##census_population ip
left join AnalyticInteg.sec.IV_UndergraduateGraduationRetention gr --select * from AnalyticInteg.sec.IV_UndergraduateGraduationRetention
on ip.system_key=gr.SDBSrcSystemKey --and ip.yr=so.[Year] and ip.qtr=so.[Quarter]
order by ip.system_key
--end get origin

/*
Create first tacoma mini_master record
*/

select
ip.system_key 
,ip.deg_level
,firstmm.min_mm_yrqtr
,smmv.*
into ##firstmmrecord --select * from ##firstmmrecord where system_key=37507
from ##census_population ip
left join 
(	select
		ip1.system_key
		,lst_mm.mm_deg_level
		--,lst_mm.deg_type
		,min(lst_mm.mm_yrqtr) as min_mm_yrqtr
		from ##census_population ip1  --select * from ##census_population
		left join (
					select distinct
					ip2.system_key
					,smmv.mm_year*10+smmv.mm_qtr as mm_yrqtr
					--,ip2.deg_level
					,smmdp.mm_deg_level
					--,ip2.deg_type
					--into ##last_mm_record -- select * from ##last_mm_record order by system_key  drop table ##last_mm_record  select * from ##initial_population
					from ##census_population ip2
					left join uwsdbdatastore.sec.sr_mini_master smmv
					on ip2.system_key=smmv.mm_system_key and ip2.proc_ind=smmv.mm_proc_ind
					inner join uwsdbdatastore.sec.sr_mini_master_deg_program smmdp
					   on smmv.mm_year = smmdp.mm_year and
						  smmv.mm_qtr = smmdp.mm_qtr and
						  smmv.mm_proc_ind = smmdp.mm_proc_ind
						  and smmv.mm_student_no =smmdp.mm_student_no	
						  and ip2.deg_level=(case smmdp.mm_deg_level when 0 then 1 else smmdp.mm_deg_level end) --and ip2.deg_type=smmdp.mm_deg_type 
					where smmdp.mm_branch=2 --and smmv.mm_year*10+smmv.mm_qtr < ip2.deg_yrqtr
					)lst_mm
		on ip1.system_key=lst_mm.system_key
		group by ip1.system_key, lst_mm.mm_deg_level--, lst_mm.deg_type
		)firstmm
on ip.system_key=firstmm.system_key and ip.deg_level=firstmm.mm_deg_level --and ip.deg_type=lastmm.deg_type 
left join UWSDBDataStore.sec.sr_mini_master smmv
on firstmm.system_key=smmv.mm_system_key and firstmm.min_mm_yrqtr/10=smmv.mm_year and firstmm.min_mm_yrqtr%10=smmv.mm_qtr and ip.proc_ind=smmv.mm_proc_ind
--smc.major_last_yr=last_maj.last_yq/10 and smc.major_last_qtr=last_maj.last_yq%10	
where 1=1
order by ip.system_key, firstmm.min_mm_yrqtr


--end first tacoma record


/*
Create home county

This code is created at the time of application by the admissions office.  It doesn't change or get updated
It is useful for grouping WA STATE students into counties of origin
*/
select 
ip.system_key,
home_addr_county=CASE WHEN RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4) >='3999' THEN 'Out of State'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '01' THEN 'Adams'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '02' THEN 'Asotin'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '03' THEN 'Benton'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '04' THEN 'Chelan'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '05' THEN 'Clallam'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '06' THEN 'Clark'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '07' THEN 'Columbia'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '08' THEN 'Cowlitz'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '09' THEN 'Douglas'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '10' THEN 'Ferry'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '11' THEN 'Franklin'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '12' THEN 'Garfield'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '13' THEN 'Grant'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '14' THEN 'Grays'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '15' THEN 'Island'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '16' THEN 'Jefferson'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '17' THEN 'Kitsap'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '18' THEN 'Kittitas'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '19' THEN 'King'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '20' THEN 'Klickitat'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '21' THEN 'Lewis'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '22' THEN 'Lincoln'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '23' THEN 'Mason'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '24' THEN 'Okanogan'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '25' THEN 'Pacific'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '26' THEN 'Pend Oreille'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '27' THEN 'Pierce'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '28' THEN 'San Juan'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '29' THEN 'Skagit'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '30' THEN 'Skamania'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '31' THEN 'Snohomish'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '32' THEN 'Spokane'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '33' THEN 'Stevens'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '34' THEN 'Thurston'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '35' THEN 'Whitman'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '36' THEN 'Yakima'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '37' THEN 'Wahkiakum'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '38' THEN 'Walla Walla'
        WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) = '39' THEN 'Whatcom'
        ELSE 'Unknown' END,
s1.home_addr_code,
hac.home_addr_descrip,
south_sound=case when s1.home_addr_code=null then null 
WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) in ('27','34','21','23') then 1 else 0 end,
--27 Pierce, 34 Thurston, 21 Lewis, 23 Mason
south_sound_skc=case when s1.home_addr_code=null then null 
WHEN LEFT(RIGHT('0000' + CONVERT(varchar,s1.home_addr_code),4),2) in ('27','34','21','23') then 1 
when cast(s1.home_addr_code as int) in (1933,1948,1903,1918, 1930,1992.1976,1902,1912,1964,1954,1908,1923,1994,1901, 1968, 1973)then 1 else 0 end ,
--1933 Federal Way, 1948 Kent, 1903 Auburn, 1901 Algona, 1968 Pacific
--1918 Covington, 1992Tukwila, 1976 Renton, 1902 SeaTac, 1912 Burien, 1964 Normandy Park
--1930 Enumclaw, 1954 Maple Valley, 1908 Black Diamond, 1923 Des Moines, 1994 Vashon Island
--1973 Ravensdale
-- select * from uwsdbdatastore.sec.sys_tbl_33_home_addr_by_code
--into ##test_home	--drop ##test_home
SouthKingCount=case when s1.home_addr_code=null then null 
when cast(s1.home_addr_code as int) in (1933,1948,1903,1918, 1930,1992.1976,1902,1912,1964,1954,1908,1923,1994,1901, 1968, 1973)then 1 else 0 end 
	--1933 Federal Way, 1948 Kent, 1903 Auburn, 1901 Algona, 1968 Pacific
	--1918 Covington, 1992Tukwila, 1976 Renton, 1902 SeaTac, 1912 Burien, 1964 Normandy Park
	--1930 Enumclaw, 1954 Maple Valley, 1908 Black Diamond, 1923 Des Moines, 1994 Vashon Island
	--1973 Ravensdale
	-- select * from uwsdbdatastore.sec.sys_tbl_33_home_addr_by_code
--into ##test_home	--drop ##test_home
into ##county_origin  --select * from ##county_origin
FROM ##census_population ip
left join UWSDBDataStore.sec.Student_1 s1
on ip.system_key=s1.system_key
left join UWSDBDataStore.sec.sys_tbl_33_home_addr_by_code hac
on s1.home_addr_code=hac.table_key
order by hac.home_addr_descrip asc
--end home county

/*

Create FASORG lookup for reporting names
This is only as good as the underlying FASOrg table in EDW.  However, for Tacoma, the data is clean
Each quarter double check to make sure the FASORG data in uwsdb department, major, curric tables it clean
This also allows us to update CIP and the associated WA State High Demand, Federal STEM and WA State STEM

*/
SELECT DISTINCT 
		smc.major_abbr,
		smc.major_pathway,
		smc.major_ss_inelig as self_sustaining, 
		smc.major_ss_inelig,
		smc.major_fee_mgr,
		/*
		This is the original suggestion to create a time based fix for the change in self-sustaining.
		Case @yrqtr < 20182 And smc.major_ss_inelig = 1 Then 'Y' 
             When @yrqtr>=20182 And smc.major_fee_mgr In('DPT','PCE') Then 'Y' 
             Else 'N' End As FeeBasedMajorInd
		*/
		Case when @yrqtr<20182 and (smc.major_osfa_inelig=1 or smc.major_ss_inelig=1) Then 'Y' 
             when @yrqtr>=20182 and smc.major_fee_mgr in('DPT','PCE') Then 'Y' 
             else 'N' end As FeeBasedMajorInd, 
		sdc.dept_abbr, 
		scc.college_abbrev, 
		sdc.dept_code, 
		sdc.dept_fas_org_code,
       fas.*
  INTO ##major_dept  --drop table ##major_dept  select * from ##major_dept order by FinCampusReportingName desc, dept_abbr
  FROM UWSDBDataStore.sec.sr_major_code smc
  inner join (
			select
			mc.major_branch,
			mc.major_abbr,
			mc.major_pathway,
			max((mc.major_last_yr*10+mc.major_last_qtr))as last_yq
			from UWSDBDataStore.sec.sr_major_code mc
			group by mc.major_branch, mc.major_abbr, mc.major_pathway
			)last_maj
  on smc.major_branch=last_maj.major_branch and smc.major_abbr=last_maj.major_abbr and smc.major_pathway=last_maj.major_pathway
		and smc.major_last_yr=last_maj.last_yq/10 and smc.major_last_qtr=last_maj.last_yq%10
 INNER JOIN UWSDBDataStore.sec.sr_dept_code sdc
    ON smc.major_dept = sdc.dept_code
 INNER JOIN UWSDBDataStore.sec.sr_coll_code scc
    ON scc.college_code = sdc.dept_college
 left join (
 select distinct
		 dfo.FinOrgTypeCode,
		 dfo.FinOrgUnitNbr,
		 dfo.FinCampusReportingName,
		 dfo.FinCollegeReportingName,
		 dfo.FinSubCollegeReportingName,
		 dfo.FinDepartmentReportingName 
		 from EDWPresentation.sec.dimFinancialOrganization dfo
		 where dfo.RecordEffEndDttm='12-31-9999' and dfo.FinOrgActiveInd='Y' --
		 and dfo.FinOrgEffEndDate=@biennium --and dfo.FinOrgEffEndDate='6-30-2015'
		  )fas
 on sdc.dept_fas_org_code=fas.FinOrgUnitNbr
--end FAS association table

-----------------
-- create  major list
-----------------
select distinct
		ip.system_key,
		mmd.mm_year as yr,
		mmd.mm_qtr as qtr,
		--added oct 2016
		rank_order=case when mmd.mm_branch=2 then mmd.index1+1 else mmd.index1+10 end,
		--end add
		mmd.mm_branch as branch,
		mmd.index1,
		mmd.mm_major_abbr as major_abbr,
		mmd.mm_pathway as pathway,
		--added Jan 2017
		major_id=CAST(mmd.mm_branch AS CHAR(1)) 
             + '-' + RTRIM(mmd.mm_major_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),mmd.mm_pathway),2),
        --end add
		mmd.mm_maj_cip_code as maj_cip_code,
		dcc.FederalSTEMInd as FederalStem,
		dcc.WAStateOFMSTEMInd as StateStem,
		dcc.WAStateHighDemandInd as WAHighDemand,
		StemStudent=case when dcc.FederalSTEMInd='Y' or dcc.WAStateOFMSTEMInd='Y' then 1 else 0 end,
		WAHDStudent=case when dcc.WAStateHighDemandInd='Y' then 1 else 0 end,
		--added Oct 2016
		Stem_Major=case when dcc.FederalSTEMInd='Y' or dcc.WAStateOFMSTEMInd='Y' then 1 else 0 end,
		WAHD_Major=case when dcc.WAStateHighDemandInd='Y' then 1 else 0 end,
		--end add
		mmd.mm_deg_level as deg_level,
		mmd.mm_deg_type as deg_type
into ##majors --drop table ##majors  select * from ##majors order by system_key

from ##census_population ip
left join uwsdbdatastore.sec.sr_mini_master mm
  on ip.system_key=mm.mm_system_key and ip.yr=mm.mm_year and ip.qtr=mm.mm_qtr and ip.proc_ind=mm.mm_proc_ind
left join  uwsdbdatastore.sec.sr_mini_master_deg_program mmd
   on mm.mm_student_no=mmd.mm_student_no and mm.mm_year=mmd.mm_year and mm.mm_qtr=mmd.mm_qtr and mm.mm_proc_ind=mmd.mm_proc_ind
left join EDWPresentation.sec.dimCIPCurrent dcc
   on mmd.mm_maj_cip_code=dcc.CIPCode
where 1=1 -- mm.mm_proc_ind=2 --and mm.mm_year=@yr and mm.mm_qtr=@qtr
order by ip.system_key
-- end

/*
Flag for multiple majors as campus-major_abbr-pathway
*/

select distinct
	ip4.system_key
	,cnt=count(m.major_id)
into ##multi_major
from ##census_population ip4
inner join ( select distinct 
			 ip3.system_key
			 ,m2.yr
			 ,m2.qtr
			 ,m2.major_id
			 from ##census_population ip3
			 inner join ##majors m2
			 on ip3.system_key=m2.system_key and ip3.yr=m2.yr and ip3.qtr=m2.qtr
			 )m
on ip4.system_key=m.system_key and ip4.yr=m.yr and ip4.qtr=m.qtr
group by ip4.system_key
							
--end multi-major


--add reporting features to the list
SELECT distinct
	   ip.system_key,
	   ip.yr,
	   ip.qtr,
	   ip.proc_ind,
       dlt.DegreeLevelTypeDesc, 
	   self_sustaining=case when (md.FinCampusReportingName='Tacoma Campus' and md.self_sustaining=1) 
	   or (md2.FinCampusReportingName='Tacoma Campus' and md2.self_sustaining=1) 
	   or (md3.FinCampusReportingName='Tacoma Campus' and md3.self_sustaining=1) then 1 else 0 end,
	   /*
	   added Oct 2016
	   */
	   Stem_Major=case when rpt.Stem_Major=1 then 1 else 0 end,
	   WAHD_Major=case when rpt.WAHD_Major=1 then 1 else 0 end,
	   --create a reporting major that allows Tacoma majors to trump other campus majore when there is a cross campus double major
	   rpt.rank_index,
	   reporting_branch=
	    CAST(rpt.branch AS CHAR(1)) 
             + '-' + RTRIM(rpt.major_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),rpt.pathway),2)
             + '-' + CAST(rpt.deg_level AS CHAR(1)) 
             + '-' + CAST(rpt.deg_type AS CHAR(1)), --AS FirstMajorPath,
      md0.FinCollegeReportingName as RptMajorCollege,
	  md0.FinDepartmentReportingName as RptMajorDepartment,
	   --end trump
	   --end add
       CAST(scm.branch AS CHAR(1)) 
             + '-' + RTRIM(scm.major_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),scm.pathway),2)
             + '-' + CAST(scm.deg_level AS CHAR(1)) 
             + '-' + CAST(scm.deg_type AS CHAR(1)) AS FirstMajorPath,
       md.FinCollegeReportingName as FirstMajorCollege,
	   md.FinDepartmentReportingName as FirstMajorDepartment,
       CAST(scm2.branch AS CHAR(1)) 
             + '-' + RTRIM(scm2.major_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),scm2.pathway),2)
             + '-' + CAST(scm2.deg_level AS CHAR(1)) 
             + '-' + CAST(scm2.deg_type AS CHAR(1)) AS SecondMajorPath,
	   md2.FinCollegeReportingName as SeconMajorCollege,
	   md2.FinDepartmentReportingName as SecondMajorDepartment,
       CAST(scm3.branch AS CHAR(1)) 
             + '-' + RTRIM(scm3.major_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),scm3.pathway),2)
             + '-' + CAST(scm3.deg_level AS CHAR(1)) 
             + '-' + CAST(scm3.deg_type AS CHAR(1)) AS ThirdMajorPath,
       md3.FinCollegeReportingName as ThirdMajorCollege,
	   md3.FinDepartmentReportingName as ThirdMajorDepartment,
       CAST(smg.minor_branch AS CHAR(1)) 
             + '-' + RTRIM(smg.minor_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),smg.minor_pathway),2)
             + '-' + '0-0' AS FirstMinorPath,
       minor.FinCollegeReportingName as FirstMinorCollege,
       CAST(smg2.minor_branch AS CHAR(1)) 
             + '-' + RTRIM(smg2.minor_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),smg2.minor_pathway),2)
             + '-' + '0-0' AS SecondMinorPath,
	   minor2.FinCollegeReportingName as SecondMinorCollege,
       CAST(smg2.minor_branch AS CHAR(1)) 
             + '-' + RTRIM(smg2.minor_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),smg2.minor_pathway),2)
             + '-' + '0-0' AS ThirdMinorPath,
	   minor3.FinCollegeReportingName as ThirdMinorCollege,
       scm.major_abbr AS FirstMajor,
	   scm.FederalStem as FirstMajorFederalStem,
	   scm.StateStem as FirstMajorStateStem,
	   scm.WAHighDemand as FirstMajorHighDemand,
       scm2.major_abbr AS SecondMajor,
	   scm2.FederalStem as SecondMajorFederalStem,
	   scm2.StateStem as SecondMajorStateStem,
	   scm2.WAHighDemand as SecondMajorHighDemand,
       scm3.major_abbr AS ThirdMajor,
	   scm3.FederalStem as ThirdMajorFederalStem,
	   scm3.StateStem as ThirdMajorStateStem,
	   scm3.WAHighDemand as ThirdMajorHighDemand,
       smg.minor_abbr AS FirstMinor,
       smg2.minor_abbr AS SecondMinor,
       smg3.minor_abbr AS ThirdMinor
  INTO ##majors_and_minors  --drop table ##majors_and_minors  --select * from ##majors_and_minors where system_key=66733 and ip.yr=2009 and ip.qtr=2
  --select * from ##majors where system_key=1087867 order by (yr*10+qtr) asc
  from ##census_population ip  --select * from ##census_population where system_key=66733
  --added Oct 2016
    left join( 
			select 
			m.*,
			xy.rank_index
			from (	
				select 
				x.system_key,
				x.branch,
				x.yr,
				x.qtr,
				rank_index=min(x.rank_order)				
			 from ##census_population ip
			 inner join ##majors x
			 on ip.system_key=x.system_key and ip.yr=x.yr and ip.qtr=x.qtr
			 group by x.system_key, x.branch,	x.yr, x.qtr
			
			 )xy
			 inner join ##majors m
			 on xy.system_key=m.system_key and xy.branch=m.branch and xy.yr=m.yr and xy.qtr=m.qtr and xy.rank_index=m.rank_order
		)rpt
     on ip.system_key=rpt.system_key and ip.yr=rpt.yr and ip.qtr=rpt.qtr  
--end add
 left join ##majors scm
     ON ip.system_key = scm.system_key and ip.yr=scm.yr and ip.qtr=scm.qtr
   and scm.index1=1
 left join UWSDBDataStore.sec.SDMODegreeLevelType dlt
    on scm.deg_level=dlt.DegreeLevelCode and scm.deg_type=dlt.DegreeTypeCode

  LEFT JOIN ##majors scm2
    ON ip.system_key = scm2.system_key and ip.yr=scm2.yr and ip.qtr=scm2.qtr
    AND scm2.index1 = 2
  LEFT JOIN ##majors scm3
    ON ip.system_key = scm3.system_key and ip.yr=scm3.yr and ip.qtr=scm3.qtr
   AND scm3.index1 = 3
  LEFT JOIN UWSDBDataStore.sec.student_1_minor_group smg
    ON scm.system_key = smg.system_key
   AND smg.index1 = 1
  LEFT JOIN UWSDBDataStore.sec.student_1_minor_group smg2
    ON scm.system_key = smg2.system_key
   AND smg.index1 = 2
  LEFT JOIN UWSDBDataStore.sec.student_1_minor_group smg3
    ON scm.system_key = smg3.system_key
   AND smg.index1 = 3 
   -- now add college
     LEFT JOIN ##major_dept md0  --select * from ##major_dept where major_abbr='T ACCT'
    ON md0.major_abbr = rpt.major_abbr and md0.major_pathway=rpt.pathway
    LEFT JOIN ##major_dept md  --select * from ##major_dept where major_abbr='T ACCT'
    ON md.major_abbr = scm.major_abbr and md.major_pathway=scm.pathway
  LEFT JOIN ##major_dept md2
    ON md2.major_abbr = scm2.major_abbr and md2.major_pathway=scm2.pathway
  LEFT JOIN ##major_dept md3
    ON md3.major_abbr = scm3.major_abbr and md3.major_pathway=scm3.pathway
  LEFT JOIN ##major_dept minor
    ON minor.major_abbr = smg.minor_abbr and minor.major_pathway=smg.minor_pathway
  LEFT JOIN ##major_dept minor2
    ON minor2.major_abbr = smg2.minor_abbr and minor2.major_pathway=smg2.minor_pathway
  LEFT JOIN ##major_dept minor3
    ON minor3.major_abbr = smg3.minor_abbr and minor3.major_pathway=smg3.minor_pathway
   --end add college
 WHERE 1=1 
 order by ip.system_key
 --end

 -------------
 -- mark as study abroad
 ------------
 
select distinct
rc.system_key,
fstdy=1,
rc.regis_yr,
rc.regis_qtr,
rc.regis_yr*10+rc.regis_qtr as reg_yrqtr,
rc.credits as fs_credits,
rc.course_branch,
rc.crs_curric_abbr,
rc.crs_number
into ##study_abroad
from ##census_population cp
inner join uwsdbdatastore.sec.registration_courses rc
		on cp.system_key=rc.system_key and cp.yr*10+cp.qtr=rc.regis_yr*10+rc.regis_qtr
inner join uwsdbdatastore.sec.sys_tbl_39_calendar stc 
        on cast(rc.regis_yr as varchar) + cast(rc.regis_qtr as varchar) =  
        cast(cast(stc.table_key as int) as varchar) 
where ((( rc.crs_curric_abbr='T INTL' and rc.crs_number=300 ) or ( rc.crs_curric_abbr='T INTL' and rc.crs_number=500 ) ) or (rc.crs_curric_abbr='FSTDY')) --added Summer 2018
      	and((rc.request_status like '%W%'and rc.request_dt > stc.tenth_day ) 
        or (rc.request_status like 'D' and rc.add_dt > stc.tenth_day )
        or(rc.request_status in ('A','C','R'))) 
 ---end



 /*
 types of courses
 */
 select
 c_list.system_key
 ,tot_online_courses=sum(c_list.is_online)
 ,tot_not_online_courses=sum(c_list.not_online)
  into ##course_types  --select * from ##course_types  --drop table ##course_types
 from (
			select distinct
				ip.system_key
				,rc.crs_curric_abbr
				,rc.course_branch
				,rc.crs_number
				,rc.crs_section_id
				,is_online=case when ts.dist_learn_type=3 and ts.online_learn_type=10 then 1 else 0 end
				,not_online=case when ts.dist_learn_type=3 and ts.online_learn_type=10 then 0 else 1 end
			from ##census_population ip
			inner join UWSDBDataStore.sec.registration r
				on ip.system_key=r.system_key and ip.yr=r.regis_yr and ip.qtr=r.regis_qtr
			inner join UWSDBDataStore.sec.registration_courses rc
				on r.system_key=rc.system_key and r.regis_yr=rc.regis_yr and r.regis_qtr=rc.regis_qtr
			inner join UWSDBDataStore.sec.time_schedule ts
				on rc.regis_yr=ts.ts_year and rc.regis_qtr=ts.ts_quarter 
			and rc.course_branch=ts.course_branch and rc.crs_curric_abbr=ts.dept_abbrev and rc.crs_number=ts.course_no and rc.crs_section_id=ts.section_id 
			where ts.delete_flag!='@'
				and rc.request_status in ('A','C','R') --and ip.system_key=444607
		)c_list
group by c_list.system_key
--end list of course types

 ---end

 --------
 --Mark as TCORE this quarter
 --------
 select distinct
rc.system_key,
rc.regis_yr,
rc.regis_qtr,
rc.regis_yr*10+rc.regis_qtr as reg_yrqtr,
sum(rc.credits) as tcore_credits
--rc.course_branch,
--rc.crs_curric_abbr,
--rc.crs_number
into ##tcore
from uwsdbdatastore.sec.registration_courses rc
inner join uwsdbdatastore.sec.sys_tbl_39_calendar stc 
        on cast(rc.regis_yr as varchar) + cast(rc.regis_qtr as varchar) =  
        cast(cast(stc.table_key as int) as varchar) 
where rc.course_branch=2
      	and rc.crs_curric_abbr in ('TCORE', 'T CORE')
      	and((rc.request_status like '%W%'and rc.request_dt > stc.tenth_day ) 
        or (rc.request_status like 'D' and rc.add_dt > stc.tenth_day )
        or(rc.request_status in ('A','C','R'))) 
group by rc.system_key, rc.regis_yr, rc.regis_qtr, rc.regis_yr*10+rc.regis_qtr

 --end

 
/*
Create a table of college prep indicators
*/
select
a.system_key,
RunningStart=case when a.running_start='Y' then 1 else 0 end,
CollegeInHS=case when a.college_in_hs='Y' then 1 else 0 end,
CreditbyExam=case when exists(select x.system_key
                              from uwsdbdatastore.sec.sr_extension x
                              where x.course_type=3
                              and x.system_key=a.system_key)
             then 1 
             else 0
             end,
APcredit=case when exists(select x.system_key
                              from uwsdbdatastore.sec.sr_extension x
                              where x.course_type=4
                              and x.system_key=a.system_key)
             then 1 
             else 0
             end,
IBcredit=case when exists(select x.system_key
                              from uwsdbdatastore.sec.sr_extension x
                              where x.course_type=5
                              and x.system_key=a.system_key)
             then 1 
             else 0
             end,
MathPlacement_old=mp2.placement,
MathPlacement_new=mp3.test_score

into ##college_prep_hs  --drop table ##college_prep_hs select* from ##college_prep_hs where system_key=1031851
from ##census_population cp
inner join UWSDBDataStore.sec.student_1 a
on cp.system_key=a.system_key
inner join UWSDBDataStore.sec.student_2 a2
on a.system_key=a2.system_key
left join (
            select distinct
                  a.system_key,
                  a.test_type,
                  a.test_score,
                  a.test_pctile,
                  a.test_dt,
                  placement=(case 
                               when a.test_score >72 and a.test_score <101  then 'MATH 145'
                               when a.test_score >67 and a.test_score <101  then 'MATH 124/144'
                               when a.test_score >39 and a.test_score <101  then 'MATH 120'
                               when a.test_score >34 and a.test_score <101  then 'MATH 107/111'
                               when a.test_score >0 and a.test_score <34  then 'MATH 98'
                               else ' '
                             end)
            from uwsdbdatastore.sec.sr_test_scores a
			inner join (
				select 
				ts.system_key,
				min(ts.test_dt) as test_date  --get first
				from UWSDBDataStore.sec.sr_test_scores ts
				where ts.test_type like 'MATHPC'
				group by ts.system_key
				)first_score
			on a.system_key=first_score.system_key and a.test_dt=first_score.test_date
            where a.test_type ='MATHPC'
            
            )mp2
on a.system_key=mp2.system_key
 left join (
		select
		ts.*
		from UWSDBDataStore.sec.sr_test_scores ts
		inner join (
				select 
				ts.system_key,
				min(ts.test_dt) as test_date  --get first
				from UWSDBDataStore.sec.sr_test_scores ts
				where ts.test_type like 'ACC-CL'
				group by ts.system_key
				)first_score
		   on ts.system_key=first_score.system_key and ts.test_dt=first_score.test_date
  		where ts.test_type like 'ACC-CL'	
		)mp3
   on a.system_key=mp3.system_key

--end college prep

 ------------------
 -- cumulative gpa
 --------------------
 select 
	t2.system_key,
	t2.report_group,
	cum_gpa=case when t2.sum_gp>0 then cast(t2.sum_gp/t2.sum_attp as decimal(4,2)) else null end
 into ##levelgpa  --drop table ##levelgpa  select * from ##levelgpa
  from (
		 select
			t1.system_key,
			t1.report_group,
			sum(t1.qtr_grade_points) as sum_gp,
			sum(t1.qtr_graded_attmp) as sum_attp
		 from (
				 select distinct
					ip.system_key,
					--c.tran_deg_level,
					--c.tran_deg_type,
					--c.tran_major_abbr,
					t.class,
					report_group=case when t.class in (1,2,3,4) then 'UG'
								  when t.class = 5 then '5yr'
								  when t.class = 6 then --'NM'
								       case when c.tran_deg_level<2 then 'UG' else 'GR' end
								  when t.class >6 then 'Gr'
								  else 'error' end,
					t.qtr_grade_points,
					t.qtr_graded_attmp
				 from ##census_population ip
				 inner join UWSDBDataStore.sec.transcript t
				    on ip.system_key=t.system_key
				 inner join UWSDBDataStore.sec.transcript_tran_col_major c
				    on t.system_key=c.system_key and t.tran_yr=c.tran_yr and t.tran_qtr=c.tran_qtr
				 where  1=1 --and t.system_key=1053921--and (t.system_key=42670  or t.system_key=1632041)t.add_to_cum=1 and
				 )t1
		 group by t1.system_key, t1.report_group
		 )t2

select distinct
	p.system_key,
	ug.cum_gpa as UG_gpa,
	gr.cum_gpa as GR_gpa,
	y.cum_gpa as PB_gpa
into ##cumgpa  --drop table ##cumgpa  select * from ##cumgpa  select * from uwsdbdatastore.sec.student_1 where s
 from ##levelgpa p
 left join (select
				a.system_key,
				a.cum_gpa 
			from ##levelgpa a
			where a.report_group='UG') ug
   on p.system_key=ug.system_key
    left join (select
				a.system_key,
				a.cum_gpa 
			from ##levelgpa a
			where a.report_group='GR') gr
   on p.system_key=gr.system_key
  left join (select
				a.system_key,
				a.cum_gpa 
			from ##levelgpa a
			where a.report_group='5YR') y
   on p.system_key=y.system_key

 --end

/*
New over-reporting ethnic groups (edw) [10/13/2022]
*/
select distinct
cp.*
,AssignedEthnicGroupDescWithHispanic=case when ds.InternationalStudentInd='Y' then 'International' 
								when ds.HispanicInd='Y' then 'Hispanic' 
								when ds.AssignedEthnicGroupDesc='Caucasian' then 'White' else ds.AssignedEthnicGroupDesc end
,AssignedEthnicGroupDescWithHispanic_plus=case when ds.InternationalStudentInd='Y' then 'International' 
								when ds.EthnicGrpMultipleInd='Y' then 'Two or more' when ds.HispanicInd='Y' then 'Hispanic' 
								when ds.AssignedEthnicGroupDesc='Caucasian' then 'White' else ds.AssignedEthnicGroupDesc end
,InternationalStudentInd=case ds.InternationalStudentInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpAfricanAmerInd=case ds.EthnicGrpAfricanAmerInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpAmericanIndianInd=case ds.EthnicGrpAmerIndianInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpAsianInd=case ds.EthnicGrpAsianInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpWhiteInd=case ds.EthnicGrpCaucasianInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpHawaiiPacIslanderInd=case ds.EthnicGrpHawaiiPacIslanderInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpHispanicInd=case ds.HispanicInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpMultipleInd=case ds.EthnicGrpMultipleInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpNotIndicatedInd=case ds.EthnicGrpNotIndicatedInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpHistoricallyUnderServedStudentofColorInd=case 
								when ds.InternationalStudentInd='Y' then 0
								when ds.HispanicInd='Y' then 1
								when ds.EthnicGrpHawaiiPacIslanderInd='Y'then 1
								when ds.EthnicGrpAfricanAmerInd='Y' then 1
								when ds.EthnicGrpAmerIndianInd='Y' then 1
								else 0 end
,EthnicGrpStudentOfColorInd=case 
								when ds.InternationalStudentInd='Y' then 0
								when ds.HispanicInd='Y' then 1
								when ds.EthnicGrpHawaiiPacIslanderInd='Y'then 1
								when ds.EthnicGrpAfricanAmerInd='Y' then 1
								when ds.EthnicGrpAmerIndianInd='Y' then 1
								when ds.EthnicGrpAsianInd='Y' then 1
								when ds.AssignedEthnicGroupDesc='Caucasian' and ds.EthnicGrpMultipleInd='N' then 0
								when ds.EthnicGrpNotIndicatedInd='Y' then 0
								else 1 end
,EthnicGrpAANAPISIStudentInd=case when ds.InternationalStudentInd='Y' then 0
							when ds.EthnicGrpHawaiiPacIslanderInd = 'Y' then 1 
							 when ds.EthnicGrpAsianInd = 'Y' then 1 else 0 end
into ##allethnic_edw
from ##census_population cp
left join EDWPresentation.sec.dimStudent ds  
on cp.system_key=ds.SDBSrcSystemKey 
where ds.RecordEffEndDttm='12-31-9999' 
---------------------------------------------------------------------------------------------------------------------------- 



/*
New over-reporting ethnic groups 
*/
select distinct
cp.*
--,ds.AssignedEthnicGroupDesc
--,AssignedEthnicGroupDesc=case when ds.AssignedEthnicGroupDesc='Caucasian' then 'White' else ds.AssignedEthnicGroupDesc end
--,ds.EthnicGrpMultipleInd
--,AssignedEthnicGroupDesc_2plus=case when ds.EthnicGrpMultipleInd='Y' then 'Two or more'
--								when ds.AssignedEthnicGroupDesc='Caucasian' then 'White' else ds.AssignedEthnicGroupDesc end
--,InternationalStudentInd=case ds.InternationalStudentInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpAfricanAmerInd=case when aam.indicator=1 then 1 else 0 end 
,EthnicGrpAmericanIndianInd=case when ain.indicator=1 then 1 else 0 end 
,EthnicGrpAsianInd=case when a.indicator=1 then 1 else 0 end 
,EthnicGrpWhiteInd=case when c.indicator=1 then 1 else 0 end 
,EthnicGrpHawaiiPacIslanderInd=case when hpi.indicator=1 then 1 else 0 end 
--,EthnicGrpHispanicInd=case ds.HispanicInd when 'Y' then 1 when 'N' then 0 else null end
,EthnicGrpMultipleInd=case when cnt.cntEthnicGroup>1 then 1 else 0 end
--,EthnicGrpNotIndicatedInd=case ds.EthnicGrpNotIndicatedInd when 'Y' then 1 when 'N' then 0 else null end
into ##allethnic_sdb  --select * from ##allethnic_sdb  drop table ##allethnic_sdb
from ##census_population cp
left join (
			select 
				e.system_key
				,count(e.ethnicGroupDesc) as cntEthnicGroup
			from 
					(select distinct
					cp.system_key
					,eg.EthnicGroupDesc
				   from ##census_population cp
				   inner join UWSDBDataStore.sec.student_1_ethnic se
						on cp.system_key=se.system_key
				   inner join UWSDBDataStore.sec.sys_tbl_21_ethnic et
						on se.ethnic=et.table_key
				   inner join UWSDBDataStore.sec.SDMOEthnicGroup eg  --select * from uwsdbdatastore.sec.sdmoethnicgroup
						on et.ethnic_group=eg.EthnicGroupCode
					where 1=1
					group by cp.system_key, eg.EthnicGroupDesc
					)e
			group by e.system_key
			)cnt
	on cp.system_key=cnt.system_key
left join (select distinct
			cp.*
			,indicator=1
		   from ##census_population cp
		   inner join UWSDBDataStore.sec.student_1_ethnic se
				on cp.system_key=se.system_key
		   inner join UWSDBDataStore.sec.sys_tbl_21_ethnic et
				on se.ethnic=et.table_key
		   inner join UWSDBDataStore.sec.SDMOEthnicGroup eg  --select * from uwsdbdatastore.sec.sdmoethnicgroup
				on et.ethnic_group=eg.EthnicGroupCode
			where eg.EthnicGroupDesc='AFRO-AM'
			)aam
on cp.system_key=aam.system_key
left join (select distinct
			cp.*
			,indicator=1
		   from ##census_population cp
		   inner join UWSDBDataStore.sec.student_1_ethnic se
				on cp.system_key=se.system_key
		   inner join UWSDBDataStore.sec.sys_tbl_21_ethnic et
				on se.ethnic=et.table_key
		   inner join UWSDBDataStore.sec.SDMOEthnicGroup eg  --select * from uwsdbdatastore.sec.sdmoethnicgroup
				on et.ethnic_group=eg.EthnicGroupCode
			where eg.EthnicGroupDesc='AMER-IND'
			)ain
on cp.system_key=ain.system_key
left join (select distinct
			cp.*
			,indicator=1
		   from ##census_population cp
		   inner join UWSDBDataStore.sec.student_1_ethnic se
				on cp.system_key=se.system_key
		   inner join UWSDBDataStore.sec.sys_tbl_21_ethnic et
				on se.ethnic=et.table_key
		   inner join UWSDBDataStore.sec.SDMOEthnicGroup eg  --select * from uwsdbdatastore.sec.sdmoethnicgroup
				on et.ethnic_group=eg.EthnicGroupCode
			where eg.EthnicGroupDesc='ASIAN'
			)a
on cp.system_key=a.system_key
left join (select distinct
			cp.*
			,indicator=1
		   from ##census_population cp
		   inner join UWSDBDataStore.sec.student_1_ethnic se
				on cp.system_key=se.system_key
		   inner join UWSDBDataStore.sec.sys_tbl_21_ethnic et
				on se.ethnic=et.table_key
		   inner join UWSDBDataStore.sec.SDMOEthnicGroup eg  --select * from uwsdbdatastore.sec.sdmoethnicgroup
				on et.ethnic_group=eg.EthnicGroupCode
			where eg.EthnicGroupDesc='CAUCASN'
			)c
on cp.system_key=c.system_key
left join (select distinct
			cp.*
			,indicator=1
		   from ##census_population cp
		   inner join UWSDBDataStore.sec.student_1_ethnic se
				on cp.system_key=se.system_key
		   inner join UWSDBDataStore.sec.sys_tbl_21_ethnic et
				on se.ethnic=et.table_key
		   inner join UWSDBDataStore.sec.SDMOEthnicGroup eg  --select * from uwsdbdatastore.sec.sdmoethnicgroup
				on et.ethnic_group=eg.EthnicGroupCode
			where eg.EthnicGroupDesc='HAW/PAC'
			)hpi
on cp.system_key=hpi.system_key
where 1=1  --1=1--ds.RecordEffEndDttm='12-31-9999'
-- 


/*
Create a new AcademicCareerEntryTypeTacoma
Step 0 profile the student_1 'current app'
Step 1 find the first enrolled University application for each level
Step 2 find the first enrolled Tacoma application at each level
Step 3 create a profile of the tacoma application
*/

---------------------------------------------------------------------------------------------------------------------------
----Step one - first University application at level
---------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------
----Step 2 - current app in Tacoma 
---------------------------------------------------------------------------------------------------------------------------

/*
Get closest Tacoma application
*/
drop table ##last_app 

select distinct
cp1.system_key
,a.appl_branch
,a.appl_yr*10+a.appl_qtr as appl_yrqtr
--,last.applyrqtr
--,a.appl_no
,a.appl_type
--,a.appl_status
,cp1.deg_level
--,a.class
into ##last_app  --select * from ##last_app
from ##census_population cp1
inner join UWSDBDataStore.sec.sr_adm_appl a
on cp1.system_key=a.system_key
inner join (
		select 
		i.system_key
		,max(apps.applyrqtr) as applyrqtr
		from ##census_population i
		left join (
				select distinct
				cp.system_key
				,a.appl_yr*10+a.appl_qtr as applyrqtr
				,a.appl_no
				,a.appl_branch
				from ##census_population cp
				inner join UWSDBDataStore.sec.sr_adm_appl a
				on cp.system_key=a.system_key
				inner join UWSDBDataStore.sec.sr_adm_appl_college_major acm
				on a.system_key=acm.system_key and a.appl_yr=acm.appl_yr and a.appl_qtr=acm.appl_qtr and a.appl_no=acm.appl_no
				inner join UWSDBDataStore.sec.sr_mini_master smmv
				on cp.system_key=smmv.mm_system_key and a.appl_yr=smmv.mm_year and a.appl_qtr=smmv.mm_qtr
				where a.appl_branch=2 and a.appl_yr*10+a.appl_qtr <=@runforyrqtr
				and smmv.mm_proc_ind=2 and smmv.mm_enroll_status=12
				
				)apps
		on i.system_key=apps.system_key
		where 1=1
		group by i.system_key
		)last
on a.system_key=last.system_key and a.appl_yr=last.applyrqtr/10 and a.appl_qtr=last.applyrqtr%10
where a.appl_branch=2 
order by cp1.system_key
 ---------------------------------------------------------------------------------------------------------------------------
 -- put it all together
 ---------------------------------------------------------------------------------------------------------------------------
select distinct
      --initial population= all Tacoma majors registered in the system, all UW student registered in a Tacoma course
	  registered_hc=1, --initial population
	  registered_tac=case when (smmv.mm_tac_st_funded+smmv.mm_tac_self_sus+smmv.mm_tac_audit>0) then 1 else 0 end, --
	  UWT_students_served_enrolled=case when (smmv.mm_tac_st_funded+smmv.mm_tac_self_sus+smmv.mm_tac_audit>0) then 1 else 0 end, --
	  UWT_students_served_enrolled_or_majors=case when (smmv.mm_tac_st_funded+smmv.mm_tac_self_sus+smmv.mm_tac_audit>0) then 1 
												  when smmdp.mm_branch=2 then 1 else 0 end, --
	  credit_bearing_hc=case when (smmv.mm_sea_st_funded+smmv.mm_sea_self_sus+
						  smmv.mm_bot_st_funded+smmv.mm_bot_self_sus+
						  smmv.mm_tac_st_funded+smmv.mm_tac_self_sus>0) then 1 else 0 end,
	  credit_bearing_hc_tac=case when (smmv.mm_tac_st_funded+smmv.mm_tac_self_sus>0) then 1 else 0 end,
	  audit_only=case when (smmv.mm_sea_st_funded+smmv.mm_sea_self_sus+smmv.mm_bot_st_funded+smmv.mm_bot_self_sus+
				smmv.mm_tac_st_funded+smmv.mm_tac_self_sus)=0 and ((smmv.mm_sea_audit+smmv.mm_bot_audit+smmv.mm_tac_audit)>0)
				then 1 else 0 end,
	  self_sustaining_tacoma_major=mam.self_sustaining,
	  self_sustaining_only=case when (smmv.mm_sea_st_funded+smmv.mm_bot_st_funded+smmv.mm_tac_st_funded=0) 
							and (smmv.mm_sea_self_sus+smmv.mm_bot_self_sus+smmv.mm_tac_self_sus)>0
							then 1 else 0 end,
	  campus=case when smmdp.mm_branch=0 then 'Seattle' --campus of the major
				  when smmdp.mm_branch=1 then 'Bothell'
				  when smmdp.mm_branch=2 then 'Tacoma' else 'error' end,
	  --study_abroad_student=case when sab.fs_credits >0 and sab.course_branch=2 then 1 else 0 end,
	  --study_abroad_student=case when (smmv.mm_year*10+smmv.mm_qtr)<20182 and sab.fs_credits>0 and sab.crs_curric_abbr in ('TINTL','T INTL') then 1
			--					when (smmv.mm_year*10+smmv.mm_qtr)>=20182 and sab.fs_credits>0 and sab.crs_curric_abbr in ('FSTDY') and sab.crs_number=300  then 1
			--					else 0 end ,
	  study_abroad_student=case when sab.fstdy=1 then 1 else 0 end, 
	  tcore_student=case when tc.tcore_credits>0 then 1 else 0 end,
	  UWT_StudentsServed=1,
	  UWT_UWProfile=case when smmdp.mm_branch=2 then 1 else 0 end,
	  UWT_Official_HC=case when (((smmv.mm_year*10+smmv.mm_qtr)>20083) and smmdp.mm_branch=2 and (smmv.mm_sea_st_funded+smmv.mm_sea_self_sus+
						  smmv.mm_bot_st_funded+smmv.mm_bot_self_sus+
						  smmv.mm_tac_st_funded+smmv.mm_tac_self_sus>0) ) 
						  or (((smmv.mm_year*10+smmv.mm_qtr)<20084)and (smmv.mm_tac_st_funded+smmv.mm_tac_self_sus>0)) --handles the calendar math for you
						  then 1 else 0 end,
	  aca_yr=case smmv.mm_qtr 
                  when 3 then cast(smmv.mm_year as varchar) + '-' + cast((smmv.mm_year + 1) as varchar)
                  when 4 then cast(smmv.mm_year as varchar) + '-' + cast((smmv.mm_year + 1) as varchar)
                  when 1 then cast((smmv.mm_year -1) as varchar) + '-' + cast(smmv.mm_year as varchar)
                  when 2 then cast((smmv.mm_year -1) as varchar) + '-' + cast(smmv.mm_year as varchar)
             end,
	  fiscal_yr=case when smmv.mm_qtr in (3,4) then smmv.mm_year+1 else smmv.mm_year end, 
	  yq=(smmdp.mm_year*10 +smmdp.mm_qtr),--cast(smmdp.mm_year as varchar)+cast(smmdp.mm_qtr as varchar),
	  smmv.mm_year as [year],
	  smmv.mm_qtr,
	  [quarter]=case smmv.mm_qtr
				  when 1 then 'Winter'
				  when 2 then 'Spring'
				  when 3 then 'Summer'
				  when 4 then 'Autumn' else 'error' end,
	  smmv.mm_system_key as system_key,
	  s.uw_netid,
	  --smmv.mm_tuit_dist_tbl,
	  s.student_no,
	  s.student_name_lowc, --proper case
	  smmv.mm_sex,
	  gender=case when smmv.mm_sex='F' then 'Female' else 'Male' end,
	  s.birth_dt,
	  age_truncated = datediff(hh,s.birth_dt, cal.tenth_day)/8766,  --change to truncated
	  age_decimal = datediff(hh,s.birth_dt, cal.tenth_day)/8766.0,  --change to truncated
  	  age_group_under_18=case 
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 0 and 17.999999 then 'under 18'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 18 and 21.999999 then '18 to 21'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 22 and 29.999999 then '22 to 29'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 30 and 39.999999 then '30 to 39'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 40 and 49.999999 then '40 to 49' 
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) >= 50 then '50 or over' else 'error' end,
	  age_group_under_20=case 
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 0 and 20.999999 then '20 and younger'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 21 and 34.999999 then '21 to 34'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 35 and 44.999999 then '35 to 44'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 45 and 54.999999 then '45 to 54'
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 55 and 64.999999 then '55 to 64' 
	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) >= 65 then '65 and over' else 'error' end,
	  eg.EthnicGroupLongDesc as ethnic,
	  f.ethnic_long_desc as ethnic_specific,
      case when eg2.EthnicGroupLongDesc='Hispanic/Latino' then 1 else 0 end as hispanic,
      combined_ethnic_VISAspecific=case when smmv.mm_resident=5 then 'International (w/Visa)'
						   when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
                           else eg.EthnicGroupLongDesc
                           end,
	  combined_ethnic=case when smmv.mm_resident in (5,6) then 'International'
						   when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
                           else eg.EthnicGroupLongDesc
                           end,
      combined_ethnic_two_or_more_VISAspecific=case when smmv.mm_resident=5 then 'International (w/Visa)'
						   when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
						   when met.cnt >1 then 'Two or more'
                           else eg.EthnicGroupLongDesc
                           end,
	  combined_ethnic_two_or_more=case when smmv.mm_resident in (5,6) then 'International'
					when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
					when met.cnt >1 then 'Two or more'
                    else eg.EthnicGroupLongDesc
                    end,
	  two_or_more_ethnic=case when met.cnt>1 then 1 else 0 end,
	  eth.EthnicGrpAfricanAmerInd,
	  eth.EthnicGrpAmericanIndianInd,
	  eth.EthnicGrpAsianInd,
	  eth.EthnicGrpHawaiiPacIslanderInd,
	  eth.EthnicGrpWhiteInd,
	  --eth.EthnicGrpMultipleInd,
	  international=case when smmv.mm_resident in (5,6) then 1 else 0 end,	  
      urminority=case when g.ethnic_desc='hispanic' then 1
                      when f.ethnic_desc in ('AFRO-AM', 'AMER-IND', 'HAW/PAC') then 1
					  when smmv.mm_resident in (5,6) then 0 --all international
                      else 0 end,  
	  --urm_uw_flag=case when g.ethnic_desc='hispanic' then 1
   --                   when f.ethnic_under_rep=9  then 1
   --                   else 0 end,

	  resident_code=s.resident,
	  resident=case  when smmv.mm_resident in (0) then 'not-Classified'
					when smmv.mm_resident in (1,2) then 'Resident'
					else 'Non-Resident' end,
      resident_detailed=res.ResidentDesc,
	  resident_group=res.ResidentGroupDesc,
														
	  k.guardian_ed_level,
	  --k.first_generation,
	first_gen_status=case when k.guardian_ed_level in ('POSTGRADUATE','4YR COLLEGE') then 'Not First Generation'
			when k.guardian_ed_level in('SOME COLLEGE','2YR COLLEGE') then 'First to BA Degree'
			when k.guardian_ed_level in ('SOME SCHOOL', 'NONE','HS GRADUATE') then 'First to College'
			else null end,
      --k.guardian_gross_income,
	  og.initial_attendance_ft,--og.initial_attendance_ft,  
	  PELLElig_start=og.StartPELLElig,
	  WACC_origin=og.WA_CC_Origin,
	  og.UGEntryType,
	  og.EntryTacomaStudentInd,
	  og.WA_CC_Origin,
	  fmmr.min_mm_yrqtr as first_yrqtr_UWT,
	  	  PELL_Eligible_ever=case when exists(
							select distinct
									ev.system_key
								from UWSDBDataStore.sec.sf_evaluation ev
								where ev.pell_elig='Y' and ip.system_key=ev.system_key
							) then 1 else 0 end,
	  SNG_Eligible_ever=case when exists(
							select distinct
									ev.system_key
								from UWSDBDataStore.sec.sf_evaluation ev
								where ev.sng_grant_amt>0 and ip.system_key=ev.system_key
							) then 1 else 0 end,
hp_ever=case when exists (
			select distinct
			e2.system_key 
			from UWSDBDataStore.sec.sf_evaluation e2
			inner join ##census_population ip2
			on e2.system_key=ip2.system_key
			where e2.husky_promise_flg=1 and e2.system_key=ip.system_key) then 1 else 0 end,

      s.home_addr_code,
	  --co.application_home_addr_county as county_of_origin,
	  a.e_mail_ucs,
	  a.e_mail_other,
	  a.local_phone_num,
	  a.local_line_1,
	  a.local_line_2,
	  a.local_city,
	  a.local_state,
	  a.local_zip_5,
	  a.local_zip_4,
	  tc_local.county as local_county,
	  a.perm_phone_num,
	  a.perm_line_1,
	  a.perm_line_2,
	  a.perm_city,
	  a.perm_state,
	  a.perm_zip_5,
	  a.perm_zip_4,
	  tc_perm.county as perm_county,
	  a.parent_line_1,
	  a.parent_line_2,
	  a.parent_city,
	  a.parent_state,
	  a.parent_zip_5,
	  a.parent_zip_4,
	  co.home_addr_county as county_of_origin,
	  co.home_addr_descrip as home_addr_description,
	  co.south_sound,
	  co.south_sound_skc,
	  co.SouthKingCount as south_king_county,
	  ft_pt=case when smmv.mm_curr_credits <12 and smmdp.mm_deg_level <2 then 'PT' --UG
      		when smmv.mm_curr_credits >11.99 and smmdp.mm_deg_level <2 then 'FT' --UG
      		when smmv.mm_curr_credits <10 and smmdp.mm_deg_level >1 then 'PT' --GR
      		when smmv.mm_curr_credits >9.99 and smmdp.mm_deg_level >1 then 'FT' --GR
      		else 'UD'
      		 end,
	  ft_pt_label=case when smmv.mm_curr_credits <12 and smmdp.mm_deg_level <2 then 'Part-time' --UG
      		when smmv.mm_curr_credits >11.99 and smmdp.mm_deg_level <2 then 'Full-time' --UG
      		when smmv.mm_curr_credits <10 and smmdp.mm_deg_level >1 then 'Part-time' --GR
      		when smmv.mm_curr_credits >9.99 and smmdp.mm_deg_level >1 then 'Full-time' --GR
      		else 'UD'
      		 end,
      smmv.mm_curr_credits as current_credits,
      fte_student_class=case when smmv.mm_class<6 then (smmv.mm_curr_credits/15)
						when smmv.mm_class>6 then (smmv.mm_curr_credits/10)
						when smmv.mm_class=6 then --'NM'
							  case when smmdp.mm_deg_level > 1 
								   then (smmv.mm_curr_credits/10)
								   else (smmv.mm_curr_credits/15)
							  end
						else (smmv.mm_curr_credits/15) end,	  	
	   fte_UWT_student_class=case when smmv.mm_class<6 then (smmv.mm_tac_st_funded/15)
						when smmv.mm_class>6 then (smmv.mm_tac_st_funded/10)
						when smmv.mm_class=6 then --'NM'
							  case when smmdp.mm_deg_level > 1 
								   then (smmv.mm_tac_st_funded/10)
								   else (smmv.mm_tac_st_funded/15)
							  end
						else (smmv.mm_tac_st_funded/15) end,	  											
	  ncr_abbr_desc=case smmv.mm_ncr_code
				when 0 then 'CONTINUING'
				when 1 then 'NEW'
				when 2 then 'FORMER'
				when 3 then 'NEW ACCT, CONT'--'NEW ACCT, CONT' --change and changed back per Jim as of AU 09
				when 4 then 'NEW ACCT, FORMER'--'NEW ACCT, FORMER'
				else ' ' end,
	  ncr_compressed=case when smmv.mm_ncr_code in (1,3,4) then 'NEW'  -- per Jim WI 09
                     when smmv.mm_ncr_code=0 then 'CONTINUING'
                     when smmv.mm_ncr_code=2 then 'FORMER'
                     else ' ' end,
	  report_group=case when smmv.mm_class in (1,2,3,4) then 'Undergraduate'
                  when smmv.mm_class = 5 then 'Post-Baccalaurate'
                  when smmv.mm_class = 6 then --'NM'
                  case when smmdp.mm_deg_level > 1 
                       then 'Graduate Non-matriculated'
                       else 'UG Non-matriculated'
                  end
                  when smmv.mm_class >6 then 'Graduate'
                  else '' end,
	  report_order=case when smmv.mm_class in (1,2,3,4) then 1
                  when smmv.mm_class = 5 then 2
                  when smmv.mm_class = 6 then --'NM'
                  case when smmdp.mm_deg_level > 1 
                       then 5
                       else 3
                  end
                  when smmv.mm_class >6 then 4
                  else '' end,
      report_group_UG_GR=case when smmv.mm_class in (1,2,3,4) then 'Undergraduate'
                  when smmv.mm_class = 5 then 'Undergraduate'
                  when smmv.mm_class = 6 then --'NM'
                  case when smmdp.mm_deg_level > 1 
                       then 'Graduate'
                       else 'Undergraduate'
                  end
                  when smmv.mm_class >6 then 'Graduate'
                  else '' end,
      origin_group=case when og.UGEntryType is null then 
						case when smmv.mm_class <5 then 'missing ug'
						     when smmv.mm_class =5 then 'missing 5yr'
							 when smmv.mm_class=6 then 'missing NM'
							 when smmv.mm_class>6 then 'missing GR'
						else 'missing unresoldved' end
					else og.ugentrytype end,
	  class_code=smmv.mm_class,
	  class_abbr =
             case when smmv.mm_class = 1 then 'FR'
                  when smmv.mm_class = 2 then 'SO'
                  when smmv.mm_class = 3 then 'JR'
                  when smmv.mm_class = 4 then 'SR'
                  when smmv.mm_class = 5 then '5YR'
                  when smmv.mm_class = 6 then --'NM'
                  case when smmdp.mm_deg_level > 1 
                       then 'GNM'
                       else 'NM'
                  end
                  when smmv.mm_class = 7 then 'PR'
                  when smmv.mm_class = 8 then 'GR'
                  when smmv.mm_class = 9 then 'PR'
                  when smmv.mm_class = 10 then 'PR'
                  when smmv.mm_class = 11 then 'P1'
                  when smmv.mm_class = 12 then 'P2'
                  when smmv.mm_class = 13 then 'P3'
                  when smmv.mm_class = 14 then 'P4'
                  else ''
             end,
			
	class_abbr_title =
             case when smmv.mm_class = 1 then 'First-year'
                  when smmv.mm_class = 2 then 'Sophomore'
                  when smmv.mm_class = 3 then 'Junior'
                  when smmv.mm_class = 4 then 'Senior'
                  when smmv.mm_class = 5 then 'Post-Baccalaurate'
                  when smmv.mm_class = 6 then --'NM'
                  case when smmdp.mm_deg_level > 1 
                       then 'Graduate Non-matriculated'
                       else 'Non-matriculated'
                  end
                  when smmv.mm_class = 7 then 'Professional'
                  when smmv.mm_class = 8 then 'Graduate'
                  when smmv.mm_class = 9 then 'Professional'
                  when smmv.mm_class = 10 then 'Professional'
                  when smmv.mm_class = 11 then '1st year Professional'
                  when smmv.mm_class = 12 then '2nd year Professional'
                  when smmv.mm_class = 13 then '3rd year Professional'
                  when smmv.mm_class = 14 then '4th year Professional'
                  else ''
             end,
      class_abbr_title_combine_NM =
             case when smmv.mm_class = 1 then 'First-year'
                  when smmv.mm_class = 2 then 'Sophomore'
                  when smmv.mm_class = 3 then 'Junior'
                  when smmv.mm_class = 4 then 'Senior'
                  when smmv.mm_class = 5 then 'Post-Baccalaurate'
                  when smmv.mm_class = 6 then 'Non-matriculated'
                  when smmv.mm_class = 7 then 'Professional'
                  when smmv.mm_class = 8 then 'Graduate'
                  when smmv.mm_class = 9 then 'Professional'
                  when smmv.mm_class = 10 then 'Professional'
                  when smmv.mm_class = 11 then '1st year Professional'
                  when smmv.mm_class = 12 then '2nd year Professional'
                  when smmv.mm_class = 13 then '3rd year Professional'
                  when smmv.mm_class = 14 then '4th year Professional'
                  else ''
             end,
      UG_GR_NM=case when smmv.mm_class in (1,2,3,4,5) then 'Undergraduate'
                    when smmv.mm_class =8 then 'Graduate'
                    when smmv.mm_class =6 then 'Non-matriculated'
                    else 'Professional' end,
	  smmv.mm_last_schl_type,
	  smmv.mm_last_schl_code,
	  ei.institution_name,
	  ei.inst_city,
	  ei.inst_state,
	  hi.high_school_name,
	  hi.hs_city,
	  hi.hs_state,
	  hi.hs_district,
	  smmv.mm_hs_english,
	  smmv.mm_hs_for_lang,
	  smmv.mm_hs_math,
	  smmv.mm_hs_science,
	  smmv.mm_hs_soc_sci,
	  s2.hs_for_lang_yrs,
	   lang_type_long=(case s2.hs_for_lang_type
                        when 1 then 'Spanish'
                        when 2 then 'French'
                        when 3 then 'German'
                        when 4 then 'Chinese'--'CHINESE'
                        when 5 then 'Latin'
                        when 6 then 'Japanese'
                        when 7 then 'Russian'
                        when 8 then 'Native Language'
                        when 9 then 'Other'
                        when 0 then ' '
                        else 'empty'
                      end),
      math_level_long= (case s2.hs_math_level
                        when 1 then '1yr'
                        when 2 then '2'
                        when 3 then 'Meets Req'
                        when 4 then 'Pre-Calc'
                        when 5 then 'Calc'
                        when 6 then 'AP Calc'
                        when 7 then '7'
                        when 8 then '8'
                        when 9 then '9'
                        when 0 then '0'
                        else 'error'
                        end),
      s2.hs_yrs_math,
      s2.hs_yrs_arts,
      s2.hs_yrs_english,
      s2.hs_yrs_science,
      s2.hs_yrs_soc_sci,
	  cphs.CollegeInHS,
	  cphs.RunningStart,
	  cphs.APcredit,
	  cphs.IBcredit,
	  cphs.CreditbyExam,
	  cphs.MathPlacement_new,
	  cphs.MathPlacement_old,
	  smmv.mm_high_sch_gpa,  --can I add cum gpa?
	  s2.high_sch_gpa,
	  s2.hs_grad_dt,
	  s2.jr_col_gpa,
	  s2.sr_col_gpa,
	  cgpa.ug_gpa as ug_cum_gpa,
	  cgpa.gr_gpa as gr_cum_gpa,
	  cgpa.pb_gpa as pb_cum_gpa,
	  --smmv.mm_post_bac_gpa,
	  --major_stuff='on the way',
	  StemStudent=case when exists (
				  select distinct
				  m.system_key
				  from ##majors m
				  where m.StemStudent=1 and m.system_key=ip.system_key )
				  then 1 else 0 end,
	  WAHDStudent=case when exists (
				  select distinct
				  m.system_key
				  from ##majors m
				  where m.WAHDStudent=1 and m.system_key=ip.system_key )
				  then 1 else 0 end,
	  --add high demand
	  mam.DegreeLevelTypeDesc,
	   mam.reporting_branch,
	  mam.rank_index,
	  muma.cnt as major_count,
	  mam.RptMajorCollege,
	  mam.RptMajorDepartment,
	  mam.FirstMajor,
	  mam.FirstMajorCollege,
	  mam.FirstMajorDepartment,
	  mam.FirstMajorPath,
	  mam.FirstMajorFederalStem,
	  mam.FirstMajorStateStem,
	  mam.FirstMajorHighDemand,
	  mam.SecondMajor,
	  mam.SeconMajorCollege,
	  mam.SecondMajorDepartment,
	  mam.SecondMajorPath,
	  mam.SecondMajorFederalStem,
	  mam.SecondMajorStateStem,
	  mam.SecondMajorHighDemand,
	  mam.ThirdMajor,
	  mam.ThirdMajorCollege,
	  mam.ThirdMajorDepartment,
	  mam.ThirdMajorPath,
	  mam.ThirdMajorFederalStem,
	  mam.ThirdMajorStateStem,
	  mam.ThirdMajorHighDemand,
	  mam.FirstMinor,
	  mam.FirstMinorCollege,
	  mam.FirstMinorPath,
	  mam.SecondMinor,
	  mam.SecondMinorCollege,
	  mam.SecondMinorPath,
	  mam.ThirdMinor,
	  mam.ThirdMinorCollege,
	  mam.ThirdMinorPath,
	  smmv.mm_spcl_program,
	  sp.sp_pgm_descrip,
	  smmv.mm_honors_program,
	  smmv.mm_schol_type,
	  smmv.mm_vet_benefit,
	  smmv.mm_veteran,
	  v.veteran_descrip,
	  smmv.mm_exempt_code,
	  exemp.exemption_descrip,
	  smmv.mm_disability_dss,
	  d.disability_desc,
	  ctps.tot_not_online_courses,
	  ctps.tot_online_courses,
	  smmv.mm_curr_credits,
	  smmv.mm_tot_credits,
	  smmv.mm_sea_st_funded, smmv.mm_sea_self_sus, smmv.mm_sea_audit,
	  smmv.mm_bot_st_funded, smmv.mm_bot_self_sus, smmv.mm_bot_audit,
	  smmv.mm_tac_st_funded, smmv.mm_tac_self_sus, smmv.mm_tac_audit,
	  -- campus credits
	  sea_credits=smmv.mm_sea_st_funded +smmv.mm_sea_self_sus + smmv.mm_sea_audit,
	  bot_credits=smmv.mm_bot_st_funded+ smmv.mm_bot_self_sus+smmv.mm_bot_audit,
	  tac_credits=smmv.mm_tac_st_funded+smmv.mm_tac_self_sus+smmv.mm_tac_audit,
	  s.tot_exten_on_rcd,
	  s.tot_lowd_transfer,
	  s.tot_upd_transfer,
	  s.tot_deductible,
	  --s.tot_exten_on_rcd,
	  s.tot_extension,
	  s.tot_grade_points,
	  s.tot_graded_attmp,
	  s.tot_nongrd_earn,

	  smmv.mm_self_sust_std,
	  s.current_appl_yr,
	  s.current_appl_qtr,
	  s.current_appl_no,
	  current_appl_type=saa.appl_type,
	  s1_satv=case s.s1_high_satv
                when 0 then null
                else s.s1_high_satv
                end,
      --b.s1_high_satm,
      s1_satm=case s.s1_high_satm
                        when 0 then null
                        else s.s1_high_satm
                        end,
      --combo_s1_sat=(b.s1_high_satv + b.s1_high_satm),
	  mg.sat_m,
	  mg.sat_v,
	  mg.sat_w,
	  mg.sat_mth,
	  mg.sat_rw,
	  mg.sat_wl,
      --combo_s1_sat=case (s.s1_high_satv + s.s1_high_satm)
      --                  when 0 then null
      --                  else (s.s1_high_satv + s.s1_high_satm)
      --                  end,
	  combo_sat_with_writing_old=case when mg.sat_m is null then null
							 when mg.sat_v is null then null
							 when mg.sat_w is null then null
                        else (mg.sat_m+mg.sat_v+mg.sat_w)
                        end,
	  combo_sat_with_writing_new=case when mg.sat_mth is null then null
							 when mg.sat_rw is null then null
							 when mg.sat_wl is null then null
                        else (mg.sat_mth+mg.sat_wl+mg.sat_rw)
                        end,
      s.s1_high_sat_dt,
      s.s1_high_act,
      act=case s.s1_high_act
                        when 0 then null
                        else s.s1_high_act
                        end,
      s.s1_high_act_dt,
      actg.act_max,
      actg.acte_max,
      actg.actm_max,
      actg.actr_max,
      actg.actwr_max,
	  mgre.gre_a,
	  mgre.gre_q,
	  mgre.gre_v,
	  mgre.gre_w,
	  total_gre=( mgre.gre_a+mgre.gre_q+mgre.gre_v)

 into ##minimastermajors  --drop table ##minimastermajors  select * from ##minimastermajors
 from ##census_population ip
 inner join uwsdbdatastore.sec.sr_mini_master smmv
 on ip.system_key=smmv.mm_system_key and ip.yr=smmv.mm_year and ip.qtr=smmv.mm_qtr and ip.proc_ind=smmv.mm_proc_ind
inner join uwsdbdatastore.sec.sr_mini_master_deg_program smmdp
   on smmv.mm_year = smmdp.mm_year and
      smmv.mm_qtr = smmdp.mm_qtr and
      smmv.mm_proc_ind = smmdp.mm_proc_ind
      and smmv.mm_student_no =smmdp.mm_student_no
inner join UWSDBDataStore.sec.student_1 s
   on smmv.mm_system_key=s.system_key
left join ##allethnic_sdb eth
on ip.system_key=eth.system_key
 left join ( --modified from inner

               select
                     yr = left(cast(cast(stc.table_key as int) as varchar),4),
                     qtr = substring(cast(cast(stc.table_key as int) as varchar),5,1),
                     tenth_day
                 from UWSDBDataStore.sec.sys_tbl_39_calendar stc
                 
       )cal
    on smmv.mm_year = cal.yr and smmv.mm_qtr = cal.qtr 
left join UWSDBDataStore.sec.sys_tbl_34_spcl_pgm sp
  on smmv.mm_spcl_program=sp.table_key
left join UWSDBDataStore.sec.SDMOResident res
    on smmv.mm_resident=res.ResidentCode
left join UWSDBDataStore.sec.sys_tbl_35_exemption exemp
  on smmv.mm_exempt_code=exemp.table_key
left join ##origin og
   on ip.system_key=og.system_key
left join uwsdbdatastore.sec.sys_tbl_21_ethnic f
   on f.table_key=smmv.mm_ethnic_code
left join UWSDBDataStore.sec.SDMOEthnicGroup eg
   on f.ethnic_group=eg.EthnicGroupCode
left join uwsdbdatastore.sec.sys_tbl_21_ethnic g
   on g.table_key=smmv.mm_hispanic_code
left join UWSDBDataStore.sec.SDMOEthnicGroup eg2
   on g.ethnic_group=eg2.EthnicGroupCode
left join (
		select
		ethnic_all.system_key,
		cnt=count(ethnic_all.ethnic_group)
		from (select 
		  se.system_key,
		  te.ethnic_group
		  from UWSDBDataStore.sec.student_1_ethnic se
		  inner join UWSDBDataStore.sec.sys_tbl_21_ethnic te  --select * from UWSDBDataStore.sec.sys_tbl_21_ethnic order by ethnic_group
		  on se.ethnic=te.table_key
		  where te.ethnic_group !=99 
		  group by se.system_key, te.ethnic_group
		  )ethnic_all
		group by ethnic_all.system_key
	   )met
  on smmv.mm_system_key=met.system_key
  left join ##guardian k
   on s.system_key=k.system_key
 left join UWSDBDataStore.sec.addresses a
   on smmv.mm_system_key=a.system_key
 left join ##temp_county tc_local
   on a.local_zip_5=tc_local.zip
 left join ##temp_county tc_perm
   on a.perm_zip_5=tc_perm.zip
 left join UWSDBDataStore.sec.sys_tbl_02_ed_inst_info ei
 on smmv.mm_last_schl_code=ei.table_key --select * from UWSDBDataStore.sec.sys_tbl_02_ed_inst_info
 left join UWSDBDataStore.sec.sys_tbl_30_highschool hi
 on s.high_sch_ceeb_cd=hi.table_key
 left join UWSDBDataStore.sec.student_2 s2
 on s.system_key=s2.system_key
 left join UWSDBDataStore.sec.sys_tbl_44_veteran v
 on smmv.mm_veteran=v.table_key
 left join UWSDBDataStore.sec.sys_tbl_20_disability d
 on smmv.mm_disability_dss=d.table_key
 left join uwsdbdatastore.sec.sr_adm_appl saa  --added 2010 WI to grab matching type code for "current" series
   on s.system_key=saa.system_key and s.current_appl_yr=saa.appl_yr
      and s.current_appl_qtr=saa.appl_qtr and s.current_appl_no=saa.appl_no
 left join ##max_sat_grid mg
   on smmv.mm_system_key=mg.system_key
 left join ##max_act_grid actg
   on smmv.mm_system_key=actg.system_key
 left join ##sat_attempts sa
   on smmv.mm_system_key=sa.system_key
 left join ##max_gre_grid mgre
   on smmv.mm_system_key=mgre.system_key
 left join ##majors_and_minors mam--##majors_and_minors mam
   on ip.system_key=mam.system_key and ip.yr=mam.yr and ip.qtr=mam.qtr
 left join ##county_origin co
   on ip.system_key=co.system_key
 left join ##study_abroad sab
   on ip.system_key=sab.system_key and ip.yr=sab.regis_yr and ip.qtr=sab.regis_qtr
 left join ##tcore tc
   on ip.system_key=tc.system_key and ip.yr=tc.regis_yr and ip.qtr=tc.regis_qtr
 left join ##college_prep_hs cphs
   on ip.system_key=cphs.system_key
 left join ##cumgpa cgpa
   on ip.system_key=cgpa.system_key
 left join ##multi_major muma
   on ip.system_key=muma.system_key
 left join ##course_types ctps
   on ip.system_key=ctps.system_key
 left join ##firstmmrecord fmmr  
   on ip.system_key=fmmr.system_key and ip.deg_level=fmmr.deg_level
 where 1=1
	 
select distinct * from ##minimastermajors order by system_key

select distinct
mm.system_key
,mm.yq
,mm.UWT_Official_HC
,mm.UWT_UWProfile
,mm.UWT_StudentsServed
,mm.rank_index
,mm.campus
,mm.gender
,mm.age_group_under_20
,mm.age_truncated
,mm.combined_ethnic_two_or_more
,mm.EthnicGrpAfricanAmerInd
,mm.EthnicGrpAmericanIndianInd
,mm.EthnicGrpAsianInd
,mm.EthnicGrpHawaiiPacIslanderInd
,mm.EthnicGrpWhiteInd
,mm.two_or_more_ethnic
,mm.international
,mm.urminority
,mm.resident_group
,mm.first_gen_status
,mm.ft_pt_label
,mm.report_group_UG_GR
,mm.class_abbr_title
,mm.UG_GR_NM
,mm.origin_group
,mm.RptMajorCollege
,mm.RptMajorDepartment
,mm.StemStudent
,mm.fte_student_class
,mm.ncr_abbr_desc
,mm.current_appl_type
,mm.tot_online_courses
,mm.south_sound_skc

from ##minimastermajors mm
where 1=1
order by yq asc, system_key asc, UWT_Official_HC desc, rank_index asc


