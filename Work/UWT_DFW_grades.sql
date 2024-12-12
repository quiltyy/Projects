/*
Creating al list of student grades in classes with instructor informaiton 
Create a flag for DFW 
Create a flag for SVG
*/

IF OBJECT_ID('tempdb..##major_dept') IS NOT NULL
	DROP TABLE ##major_dept

IF OBJECT_ID('tempdb..##population') IS NOT NULL
	DROP TABLE ##population

IF OBJECT_ID('tempdb..##finorg') IS NOT NULL
	DROP TABLE ##finorg

IF OBJECT_ID('tempdb..##curric') IS NOT NULL
	DROP TABLE ##curric

IF OBJECT_ID('tempdb..##allethnic_sdb') IS NOT NULL
	drop table ##allethnic_sdb

USE UWSDBDataStore
GO

DECLARE @YrQtr bigint, @biennium date
Declare @College varchar(20)

SET @YrQtr = 20193
set @biennium='6-30-2023'

/*
 
Create Lookup for Academic Hierarchy from IOS table
Updated 1/28/2024 when the FASOrg key was removed from sr_dept in SDB.
 
*/
select distinct 
		ios.MajorCampus as major_branch
		,ios.MajorAbbrCode as major_abbr
		,ios.MajorPathwayNum as major_pathway
		,sdc.dept_abbr
		,mc.major_ss_inelig as self_sustaining
		,ios.FeeBasedMajorInd
		,ios.MajorCampus 
		,ios.IOSLevel2Name
		,ios.IOSLevel3Name
		,ios.IOSLevel4Name
		,case when ios.ioslevel2Name like 'UW Tacoma' then 'Tacoma Campus' else ios.ioslevel2Name end as FinCampusReportingName
		,ios.IOSLevel3Name as FinCollegeReportingName
		,ios.IOSLevel4Name as FinDepartmentReportingName
		,major_path=cast(ios.MajorCampus as varchar)+'-'+cast(ltrim(rtrim(ios.MajorAbbrCode)) as varchar)+'-'+cast(ios.MajorPathwayNum as varchar)
into ##major_dept
from AnalyticInteg.sec.IV_MajorIOS ios
left join
	(select
	mc1.*
	from UWSDBDataStore.sec.sr_major_code mc1
	inner join 
			(select 
				mc1.major_branch
				,mc1.major_abbr
				,mc1.major_pathway
				,max(mc1.major_last_yr*10+mc1.major_last_qtr) as LastMajorYrQtr
			from UWSDBDataStore.sec.sr_major_code mc1
			where 1=1
			group by mc1.major_branch,mc1.major_abbr,mc1.major_pathway
			)mc2
	on mc1.major_branch=mc2.major_branch and mc1.major_abbr=mc2.major_abbr and mc1.major_pathway=mc2.major_pathway
	and mc1.major_last_yr*10+mc1.major_last_qtr=mc2.LastMajorYrQtr
	)mc
on ios.MajorCampus=mc.major_branch and ios.MajorAbbrCode=mc.major_abbr and ios.MajorPathwayNum=mc.major_pathway
inner join UWSDBDataStore.sec.sr_dept_code sdc
    ON mc.major_dept = sdc.dept_code
inner join UWSDBDataStore.sec.sr_coll_code scc
    ON scc.college_code = sdc.dept_college
where 1=1 


/*
Create Study Abroad Flag
*/
drop table ##fstdy

select distinct
rc.SDBSrcSystemKey as system_key
,rc.AcademicQtrKeyId as regis_yrqtr
,rc.CurriculumAbbrCode
,studyabroad=1
into ##fstdy
from AnalyticInteg.sec.IV_StudentCourseSectionRegistrations rc
where (( rc.CurriculumAbbrCode='T INTL' and rc.CourseNbr=300 ) 
or ( rc.CurriculumAbbrCode='T INTL' and rc.CourseNbr=500 ) 
or (rc.CurriculumAbbrCode='FSTDY')) --added Summer 2018

-- end study abroad

/*
Create student population
*/
select distinct
t.system_key
,AcademicYear=case when t.tran_qtr in (3,4) then cast(t.tran_yr as varchar)+'-'+ cast(t.tran_yr+1 as varchar)
				else cast(t.tran_yr-1 as varchar)+'-'+ cast(t.tran_yr as varchar) end
,AcademicQuarter=case t.tran_qtr when 3 then 'Summer'
				when 4 then 'Autumn' when 1 then 'Winter' when 2 then 'Spring' else 'error' end
,t.tran_yr*10+t.tran_qtr as tran_yrqtr
,sfs.ResidentGroup
,s2.hs_def_for_lang
,sfs.StudentClass
,sfs.AcademicCareerEntryType
,sfs.HighSchoolName
,sfs.OutcomeCumGPA
,sfs.DegreeSeekingStudentInd
,sfs.DegreePursued
,sfs.FullTimeStudentInd
,sfs.VeteranDesc
,sfs.FirstGeneration4YrDegree
,sfs.FirstGenerationMatriculated
,sfs.VeteranCode
,VeteranGroup =case when sfs.VeteranCode in (44,45,46) then 'Military Dependants'
 when sfs.VeteranCode in (1,2,3,4,7,8,9,10,25,40, 41, 42, 43) then 'Veteran or Active Military' --and ROTC
 --when s.veteran in (25) then 'ROTC'
 when sfs.VeteranCode in (0) then 'Not a Veteran' else 'error' end
,sfs.IPEDSRaceEthnicityCategory
,combined_ethnic=case when s.resident in (5,6) then 'International'
						   when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
                           else eg.EthnicGroupLongDesc
                           end
,sfs.InternationalStudentInd
,sfs.HispanicInd
,sfs.RaceGrpAfricanAmerInd
,sfs.RaceGrpAmerIndianInd
,sfs.RaceGrpAsianInd
,sfs.RaceGrpCaucasianInd as RaceGrpWhiteInd
,sfs.RaceGrpHawaiiPacIslanderInd
,sfs.RaceGrpNotIndicatedInd
,sfs.UnderrepresentedMinorityInd as HistoricallyUnderservedStudentofColorInd
,StudentofColorInd=case when sfs.InternationalStudentInd='Y'  then 'N'
					when sfs.HispanicInd='Y' then 'Y'
					when sfs.RaceGrpAfricanAmerInd='Y' or sfs.RaceGrpAmerIndianInd='Y' or sfs.RaceGrpAsianInd='Y' or sfs.RaceGrpHawaiiPacIslanderInd='Y'
					then 'Y' else 'N' end 
,s.test_student
,gr.GraduatedFlag
,sa.studyabroad
,sa.CurriculumAbbrCode
into ##population
from UWSDBDataStore.sec.student_1 s
inner join UWSDBDataStore.sec.student_2 s2
on s.system_key=s2.system_key
inner join UWSDBDataStore.sec.transcript t
on s.system_key=t.system_key
inner join UWSDBDataStore.sec.transcript_tran_col_major tcm
on t.system_key=tcm.system_key and t.tran_yr=tcm.tran_yr and t.tran_qtr=tcm.tran_qtr
left join ##major_dept md
on tcm.tran_branch=md.major_branch  and  tcm.tran_major_abbr=md.major_abbr and tcm.tran_pathway=md.major_pathway
left join AnalyticInteg.sec.IV_StudentFactSheet sfs
on t.system_key=sfs.sdbsrcsystemkey and t.tran_yr*10+t.tran_qtr=sfs.AcademicQtrKeyId
left join AnalyticInteg.sec.IV_StudentGraduationRetentionTerms gr
on t.system_key=gr.SDBSrcSystemKey and t.tran_yr*10+t.tran_qtr=gr.LastCareerLevelAcademicQtrKeyId
left join uwsdbdatastore.sec.sys_tbl_21_ethnic f
   on f.table_key=s.ethnic_code
left join UWSDBDataStore.sec.SDMOEthnicGroup eg
   on f.ethnic_group=eg.EthnicGroupCode
left join uwsdbdatastore.sec.sys_tbl_21_ethnic g
   on g.table_key=s.hispanic_code
left join UWSDBDataStore.sec.SDMOEthnicGroup eg2
   on g.ethnic_group=eg2.EthnicGroupCode
left join ##fstdy sa
	on sa.system_key = sfs.SDBSrcSystemKey and sfs.AcademicQtrKeyId = sa.regis_yrqtr
where t.tran_yr*10+t.tran_qtr>=@YrQtr
and s.test_student=0 and sfs.TacomaStudentInd = 'Y'
--end population


/*
Create transcript list of Tacoma students by major
*/

select distinct
t.system_key
,p.AcademicYear
,p.AcademicQuarter
,p.tran_yrqtr
,md.major_abbr
,md.FinCampusReportingName as Major_Campus
,md.FinCollegeReportingName as Major_College
,md.FinDepartmentReportingName as Major_Department
,QtrGradedAttempted = t.qtr_graded_attmp
,QtrGradePoints = t.qtr_grade_points
,TenthDayCredits = t.tenth_day_credits
,QtrCredits = t.qtr_graded_attmp + t.qtr_nongrd_earned - t.qtr_deductible
,tct.duplicate_indic
,tct.repeat_course
,CourseLevel=case when tct.course_number< 100 then '99'
			 else cast(left(tct.course_number, 1)*100 as varchar) end
					

,CourseDivisionGroup=case when tct.course_number< 100 then 'Remedial'
						when tct.course_number between 100 and 299 then 'LowerDivision'
						when tct.course_number between 300 and 499 then 'UpperDivision'
						when tct.course_number>499 then 'Graduate' else 'error' end
,CourseSection=cast(tct.course_branch as varchar)+'-'+ltrim(rtrim(tct.dept_abbrev))+'-'+cast(tct.course_number as varchar)+'-'+ltrim(rtrim(tct.section_id))
,CourseSectionYear=cast(tct.course_branch as varchar)+'-'+ltrim(rtrim(tct.dept_abbrev))+'-'+cast(tct.course_number as varchar)+'-'+ltrim(rtrim(tct.section_id)+'-'+cast(p.tran_yrqtr as varchar))
,tct.course_branch
,tct.dept_abbrev
,tct.course_number
,tct.section_id
,tc.ts_research as Research
,tc.ts_service as Service
,tc.writing_crs as Writing
,tc.diversity_crs as Diversity
,StudyAbroad=case when p.studyabroad=1 then 1 else 0 end
,tct.course_credits
,tct.grade
,SPG_UG_Grade_Grp=CASE WHEN tct.grade LIKE 'W%' THEN 'W'
				WHEN tct.grade = '*W' THEN 'W'
				WHEN tct.grade = 'HW' THEN 'W'
				WHEN tct.grade = 'RD' THEN 'W'
				WHEN tct.grade = 'I' THEN 'I'
				WHEN tct.grade in ('','  ','X') THEN 'No Grade'
				WHEN tct.grade in ('CR', 'S', 'N') then 'P'
				WHEN tct.grade in ('NC', 'NS') then 'F'
				WHEN ISNUMERIC(tct.grade) = 1 then 
						case when tct.grade <07 then 'F'
							 when tct.grade between 07 and 20 and tct.course_number<500 then 'D'
							 else 'P' end
				else 'error' end
,UG_SPG_IND=CASE WHEN tct.grade LIKE 'W%' THEN 1
				WHEN tct.grade = '*W' THEN 1
				WHEN tct.grade = 'HW' THEN 1
				WHEN tct.grade = 'RD' THEN 1
				WHEN tct.grade = 'I' THEN null
				WHEN tct.grade in ('','  ','X') THEN null
				WHEN tct.grade in ('CR', 'S', 'N') then 0
				WHEN tct.grade in ('NC', 'NS') then 1
				WHEN ISNUMERIC(tct.grade) = 1 then 
						case when tct.grade <07 then 1
							 when tct.grade between 07 and 20 and tct.course_number<500 then 1
							 else 0 end
				else 999 end
,DFW_UG_Grade_Grp=CASE WHEN tct.grade LIKE 'W%' THEN 'W'
				WHEN tct.grade = '*W' THEN 'W'
				WHEN tct.grade = 'HW' THEN 'W'
				WHEN tct.grade = 'RD' THEN 'W'
				WHEN tct.grade = 'I' THEN 'I'
				WHEN tct.grade in ('','  ','X') THEN 'No Grade'
				WHEN tct.grade in ('CR', 'S', 'N') then 'P'
				WHEN tct.grade in ('NC', 'NS') then 'F'
				WHEN ISNUMERIC(tct.grade) = 1 then 
						case when tct.grade <07 then 'F'
							 when tct.grade between 07 and 14 and tct.course_number<500 then 'D'
							 else 'P' end
				else 'error' end
,UG_DFW_IND=CASE WHEN tct.grade LIKE 'W%' THEN 1
				WHEN tct.grade = '*W' THEN 1
				WHEN tct.grade = 'HW' THEN 1
				WHEN tct.grade = 'RD' THEN 1
				WHEN tct.grade = 'I' THEN null
				WHEN tct.grade in ('','  ','X') THEN null
				WHEN tct.grade in ('CR', 'S', 'N') then 0
				WHEN tct.grade in ('NC', 'NS') then 1
				WHEN ISNUMERIC(tct.grade) = 1 then 
						case when tct.grade <07 then 1
							 when tct.grade between 07 and 14 and tct.course_number<500 then 1
							 else 0 end
				else 999 end
,ts.stud_cred_hrs_10
,p.combined_ethnic as RaceCombinedEthnic
,p.IPEDSRaceEthnicityCategory as RaceIPEDSCategory
,p.HistoricallyUnderservedStudentofColorInd
,p.StudentofColorInd
,p.InternationalStudentInd
,p.HispanicInd
,p.RaceGrpAfricanAmerInd
,p.RaceGrpAmerIndianInd
,p.RaceGrpAsianInd
,p.RaceGrpHawaiiPacIslanderInd
,p.RaceGrpWhiteInd
,p.RaceGrpNotIndicatedInd
,p.AcademicCareerEntryType
,p.HighSchoolName
,p.hs_def_for_lang
,p.OutcomeCumGPA
,p.FullTimeStudentInd
,p.VeteranDesc
,p.DegreePursued
,p.DegreeSeekingStudentInd
,p.ResidentGroup
,p.StudentClass
,p.FirstGeneration4YrDegree
,p.FirstGenerationMatriculated
,p.GraduatedFlag
,cs.CourseSectionStudentCount
,cs.CourseSectionSeatsOffered
from ##population p
inner join UWSDBDataStore.sec.transcript t
on p.system_key=t.system_key and p.tran_yrqtr=t.tran_yr*10+t.tran_qtr
inner join UWSDBDataStore.sec.transcript_tran_col_major tcm
on t.system_key=tcm.system_key and t.tran_yr=tcm.tran_yr and t.tran_qtr=tcm.tran_qtr
inner join UWSDBDataStore.sec.transcript_courses_taken tct
on t.system_key=tct.system_key and t.tran_yr=tct.tran_yr and t.tran_qtr=tct.tran_qtr
left join UWSDBDataStore.sec.time_schedule tc
on tct.tran_yr=tc.ts_year and tct.tran_qtr=tc.ts_quarter and tct.course_branch=tc.course_branch and tct.dept_abbrev=tc.dept_abbrev
and tct.course_number=tc.course_no and tct.section_id=tc.section_id
left join ##major_dept md
on tcm.tran_major_abbr=md.major_abbr and tcm.tran_pathway=md.major_pathway
left join UWSDBDataStore.sec.time_schedule ts
on tct.tran_yr=ts.ts_year and tct.tran_qtr=ts.ts_quarter 
and tct.course_branch=ts.course_branch and tct.dept_abbrev=ts.dept_abbrev and tct.course_number=ts.course_no and tct.section_id=ts.section_id
left join UWSDBDataStore.sec.sr_course_instr ci
on ts.ts_year=ci.fac_yr and ts.ts_quarter=ci.fac_qtr
and ts.course_branch=ci.fac_branch and ts.dept_abbrev=ci.fac_curric_abbr and ts.course_no=ci.fac_course_no and ts.section_id=ci.fac_sect_id 
inner join AnalyticInteg.sec.IV_CourseSections cs
on cs.AcademicQtrKeyId=t.tran_yr*10+t.tran_qtr and cs.CourseCampus=tct.course_branch and cs.CourseNbr=ts.course_no and cs.CourseSectionId=ts.section_id and cs.CurriculumAbbrCode=ts.dept_abbrev
where 1=1
order by t.system_key asc, md.FinCampusReportingName asc