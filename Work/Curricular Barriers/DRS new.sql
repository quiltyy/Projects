--declare @yrqtr varchar


--set @yrqtr='(20173, 20174, 20181, 20182)'


DECLARE @start_quarter INT, @end_quarter INT, @campus INT
DECLARE @biennium date


--This sets the range of students by enrollment
SET @start_quarter = 20161
SET @end_quarter = 20194
SET @biennium='6-30-2021'
SET @campus=2

/*

Create FASORG lookup for reporting names
This is only as good as the underlying FASOrg table in EDW.  However, for Tacoma, the data is clean
Each quarter double check to make sure the FASORG data in uwsdb department, major, curric tables it clean
This also allows us to update CIP and the associated WA State High Demand, Federal STEM and WA State STEM

*/

drop table ##curric_dept
drop table ##registration1

SELECT DISTINCT 
		smc.curric_abbr,
		scc.college_abbrev, 
		sdc.dept_code, 
		sdc.dept_fas_org_code,
       fas.*
  INTO ##curric_dept  --drop table ##curric_dept  select * from ##curric_dept order by FinCampusReportingName desc, curric_abbr
  FROM UWSDBDataStore.sec.sr_curric_code smc
  inner join (
			select
			mc.curric_branch
			,mc.curric_abbr
			,max((mc.curric_last_yr*10+mc.curric_last_qtr))as last_yq
			from UWSDBDataStore.sec.sr_curric_code mc
			group by mc.curric_branch, mc.curric_abbr
			)last_curric
  on smc.curric_branch=last_curric.curric_branch and smc.curric_abbr=last_curric.curric_abbr 
		and smc.curric_last_yr=last_curric.last_yq/10 and smc.curric_last_qtr=last_curric.last_yq%10
 INNER JOIN UWSDBDataStore.sec.sr_dept_code sdc
    ON smc.curric_dept = sdc.dept_code
 -- AND smc.major_last_yr * 10 + smc.major_last_qtr = 99994
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
		 and dfo.FinOrgEffEndDate=@biennium --'6-30-2019'
		  )fas
 on sdc.dept_fas_org_code=fas.FinOrgUnitNbr
 where 1=1

 --end 

drop table ##new_course_titles
select distinct
ct.course_branch
,ct.department_abbrev
,ct.course_number
,ct.long_course_title
--,ct.last_eff_yr
--,ct.last_eff_qtr
,cd.FinCampusReportingName
,cd.FinCollegeReportingName
,cd.FinDepartmentReportingName
,research=case when ts.ts_research=1 then 1 else 0 end
,service=case when ts.ts_service=1 then 1 else 0 end
,diversity=case when ct.diversity_crs=1 then 1 else 0 end
,writing=case when ts.writing_crs=1 then 1 else 0 end
into ##new_course_titles  --drop table ##new_course_titles  select * from ##new_course_titles where course_branch=2 order by department_abbrev, course_number 
from UWSDBDataStore.sec.sr_course_titles ct
left join UWSDBDataStore.sec.time_schedule ts
on ct.course_branch=ts.course_branch and ct.department_abbrev=ts.dept_abbrev and ct.course_number=ts.course_no
left join ##curric_dept cd
on ct.department_abbrev=cd.curric_abbr
where 1=1 --ct.course_branch=2 --and ct.last_eff_yr=9999
order by ct.department_abbrev, ct.course_number



/*

Create FASORG lookup for reporting names
This is only as good as the underlying FASOrg table in EDW.  However, for Tacoma, the data is clean
Each quarter double check to make sure the FASORG data in uwsdb department, major, curric tables it clean
This also allows us to update CIP and the associated WA State High Demand, Federal STEM and WA State STEM

*/

drop table ##major_dept
SELECT DISTINCT 
		smc.major_abbr,
		smc.major_pathway,
		--smc.major_ss_inelig as self_sustaining, 
		--smc.major_ss_inelig,
		--smc.major_fee_mgr,
		--/*
		--This is the original suggestion to create a time based fix for the change in self-sustaining.
		--Case When AcademicQtrKeyId < 20182 And AnalyticInteg.sec.sr_major_code_SNAP11.major_ss_inelig = 1 Then 'Y' 
  --           When AcademicQtrKeyId >=20182 And AnalyticInteg.sec.sr_major_code_SNAP11.major_fee_mgr In('DPT','PCE') Then 'Y'
  --           Else 'N' End As FeeBasedMajorInd
		--or 

		--Case @yrqtr < 20182 And smc.major_ss_inelig = 1 Then 'Y' 
  --           When @yrqtr>=20182 And smc.major_fee_mgr In('DPT','PCE') Then 'Y' 
  --           Else 'N' End As FeeBasedMajorInd
		--*/
		--Case when @yrqtr<20182 and (smc.major_osfa_inelig=1 or smc.major_ss_inelig=1) Then 'Y' 
  --           when @yrqtr>=20182 and smc.major_fee_mgr in('DPT','PCE') Then 'Y' 
  --           else 'N' end As FeeBasedMajorInd, 
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
 -- AND smc.major_last_yr * 10 + smc.major_last_qtr = 99994
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
		 and dfo.FinOrgEffEndDate=@biennium --and dfo.FinOrgEffEndDate='6-30-2017'
		  )fas
 on sdc.dept_fas_org_code=fas.FinOrgUnitNbr
--end FAS association table



drop table ##courses
drop table ##faculty

/*
Create list of courses
*/

select distinct  --joint courses
cs.AcademicQtrKeyId
,cs.ScheduleLineNbr
,cs.CourseCampus
,cs.CourseSectionCode
,cs.CurriculumAbbrCode
,cs.CourseNbr
,cs.CourseSectionId
,cs.SectionTypeDesc
,cs.DistanceLearningTypeDesc
--,cs.OnlineLearningTypeDesc
--,Online_learning_desc= case cs.OnlineLearningTypeCode
--						when 0 then 'no online'
--						when 10 then '100% online'
--						when 20 then 'hybrid'
--						when 30 then 'enhanced'
--						else 'error' end
,cs.CourseLevelNbr
,cs.CourseLevelCode
,cs.CourseLevelGroupCode
,case when cs.CourseNbr between 100 and 499 then '100-499' 
	  when cs.CourseNbr >499 then '500 and above' else ' ' end as CourseUGGR
,cs.CourseSectionStudentCount
,cs.CourseSectionSeatsOffered
,cs.JointCourseGroupKeyId
,joint.primary_course_code
,joint.TotalCourseSectionStudentCount
,joint.TotalCourseSCH
--,cs.SectionTypeDesc
,cfo.CurriculumFullName
,cfo.PrimaryOrgUnitInd
,cfo.FinCollegeReportingName
,cfo.FinDepartmentReportingName
into ##courses  --select * from ##courses
from AnalyticInteg.sec.IV_CourseSections cs
inner join (select
				a.AcademicQtrKeyId
				,a.JointCourseGroupKeyId
				,sum(a.CourseSectionStudentCount) as TotalCourseSectionStudentCount
				,sum(a.CourseSectionSCH) as TotalCourseSCH
				,min(a.CourseSectionCode) as primary_course_code
			from AnalyticInteg.sec.IV_CourseSections a
			where a.CourseCampus=2 --and a.sectiontypecode='LC' --removed for room study
			and a.JointCourseGroupKeyId>0  --added June 2017
			group by a.AcademicQtrKeyId, a.JointCourseGroupKeyId
		)joint
on cs.AcademicQtrKeyId=joint.AcademicQtrKeyId and cs.JointCourseGroupKeyId=joint.JointCourseGroupKeyId and cs.CourseSectionCode=joint.primary_course_code
left join AnalyticInteg.sec.IV_CurriculumFinancialOrganizations cfo
on  cs.CourseCampus=cfo.CurriculumCampus and cs.CurriculumAbbrCode=cfo.CurriculumAbbrCode
where cs.AcademicQtrKeyId between @start_quarter and @end_quarter and cs.CourseCampus=@campus --2--in (20173, 20174, 20181, 20182) and cs.CourseCampus=2 --and cs.SectionTypeCode='LC'
	and cs.JointCourseGroupKeyId>0

UNION

select distinct  --not joint courses
cs.AcademicQtrKeyId
,cs.ScheduleLineNbr
,cs.CourseCampus
,cs.CourseSectionCode
,cs.CurriculumAbbrCode
,cs.CourseNbr
,cs.CourseSectionId
,cs.SectionTypeDesc
,cs.DistanceLearningTypeDesc
--,cs.OnlineLearningTypeDesc
--,Online_learning_desc= case cs.OnlineLearningTypeCode
--						when 0 then 'no online'
--						when 10 then '100% online'
--						when 20 then 'hybrid'
--						when 30 then 'enhanced'
--						else 'error' end
,cs.CourseLevelNbr
,cs.CourseLevelCode
,cs.CourseLevelGroupCode
,case when cs.CourseNbr between 100 and 499 then '100-499' 
	  when cs.CourseNbr >499 then '500 and above' else ' ' end as CourseUGGR
,cs.CourseSectionStudentCount
,cs.CourseSectionSeatsOffered
,cs.JointCourseGroupKeyId
,cs.CourseSectionCode as primary_course_code
,cs.CourseSectionStudentCount as TotalCourseSectionStudentCount
,cs.CourseSectionSCH as TotalCourseSCH
--,cs.SectionTypeDesc
,cfo.CurriculumFullName
,cfo.PrimaryOrgUnitInd
,cfo.FinCollegeReportingName
,cfo.FinDepartmentReportingName
from AnalyticInteg.sec.IV_CourseSections cs
left join AnalyticInteg.sec.IV_CurriculumFinancialOrganizations cfo
on  cs.CourseCampus=cfo.CurriculumCampus and cs.CurriculumAbbrCode=cfo.CurriculumAbbrCode
where cs.AcademicQtrKeyId  between @start_quarter and @end_quarter and cs.CourseCampus=@campus--between 20103 and 20184 and cs.CourseCampus=2 --in (20173, 20174, 20181, 20182) and cs.CourseCampus=2 --and cs.SectionTypeCode='LC' --removed for room study
	and cs.JointCourseGroupKeyId is null
order by cs.coursesectioncode





select distinct
cs.AcademicQtrKeyId
,cs.CourseCampus
,cs.CourseSectionCode
,min(cs.CourseSectionCode) as primary_section_code
,cs.JointCourseGroupKeyId
,sum(x.sum_faculty) as total_faculty
into ##faculty
from AnalyticInteg.sec.IV_CourseSections cs
inner join (
		select
			fac.AcademicQtrKeyId
			,fac.CourseCampus
			,fac.CourseSectionCode
			,count(fac.FacultyEmployeeId) as sum_faculty
		from (
				select 
				cf.AcademicQtrKeyId
				,cf.CourseCampus
				,c.CourseSectionCode
				,c.JointCourseGroupKeyId
				,cf.FacultyEmployeeId
				from AnalyticInteg.sec.IV_CourseSectionFaculty cf
				inner join AnalyticInteg.sec.IV_CourseSections c
				on cf.AcademicQtrKeyId=c.AcademicQtrKeyId and cf.CourseCampus=c.CourseCampus and cf.CourseSectionCode=c.CourseSectionCode
				where c.JointCourseGroupKeyId is null  and cf.FacultyPercentageOfInvolvement>.10
					and cf.AcademicQtrKeyId between @start_quarter and @end_quarter and cf.CourseCampus=@campus --between 20103 and 20184 and cf.CourseCampus=2
				group by cf.AcademicQtrKeyId,cf.CourseCampus,c.CourseSectionCode,c.JointCourseGroupKeyId,cf.FacultyEmployeeId
				--order by cf.AcademicQtrKeyId,cf.CourseCampus,c.CourseSectionCode,c.JointCourseGroupKeyId
				)fac
		group by fac.AcademicQtrKeyId,fac.CourseCampus,fac.CourseSectionCode,fac.JointCourseGroupKeyId
		--order by fac.AcademicQtrKeyId, fac.CourseCampus, fac.CourseSectionCode, fac.JointCourseGroupKeyId
		)x
on cs.AcademicQtrKeyId=x.AcademicQtrKeyId and cs.CourseCampus=x.CourseCampus and cs.CourseSectionCode=x.CourseSectionCode
group by cs.AcademicQtrKeyId,cs.CourseCampus,cs.CourseSectionCode, cs.JointCourseGroupKeyId
--order by cs.AcademicQtrKeyId, cs.CourseCampus, cs.CourseSectionCode


UNION 


/*
get faculty - joint
*/
--declare @yrqtr int

--set @yrqtr=20122

select distinct
cs.AcademicQtrKeyId
,cs.CourseCampus
,cs.primary_section_code as CourseSectionCode
,cs.primary_section_code
,x.JointCourseGroupKeyId
,x.sum_faculty as total_faculty
--,cs.JointCourseGroupKeyId
--,min(cs.CourseSectionCode) as primary_section_code
--,sum(x.sum_faculty) as total_faculty
from (select
		c.AcademicQtrKeyId
		,c.CourseCampus
		,c.JointCourseGroupKeyId
		,min(c.CourseSectionCode) as primary_section_code
		from AnalyticInteg.sec.IV_CourseSections c
		where c.JointCourseGroupKeyId>0 
					and c.AcademicQtrKeyId between @start_quarter and @end_quarter and c.CourseCampus=@campus --between 20103 and 20184 and c.CourseCampus=2
		group by c.AcademicQtrKeyId,c.CourseCampus,c.JointCourseGroupKeyId
		)cs
inner join (
		select
			fac.AcademicQtrKeyId
			,fac.CourseCampus
			,fac.JointCourseGroupKeyId
			,count(fac.FacultyEmployeeId) as sum_faculty
		from (
				select 
				cf.AcademicQtrKeyId
				,cf.CourseCampus
				,c.JointCourseGroupKeyId
				,cf.FacultyEmployeeId
				from AnalyticInteg.sec.IV_CourseSectionFaculty cf
				inner join AnalyticInteg.sec.IV_CourseSections c
				on cf.AcademicQtrKeyId=c.AcademicQtrKeyId and cf.CourseCampus=c.CourseCampus and cf.CourseSectionCode=c.CourseSectionCode
				where c.JointCourseGroupKeyId>0 and cf.FacultyPercentageOfInvolvement>.10
					and cf.AcademicQtrKeyId between @start_quarter and @end_quarter and cf.CourseCampus=@campus --between 20103 and 20184 and cf.CourseCampus=2
				group by cf.AcademicQtrKeyId,cf.CourseCampus,c.JointCourseGroupKeyId,cf.FacultyEmployeeId
				--order by cf.AcademicQtrKeyId,cf.CourseCampus,c.JointCourseGroupKeyId
				)fac
		group by 	fac.AcademicQtrKeyId,fac.CourseCampus,fac.JointCourseGroupKeyId
		--order by fac.AcademicQtrKeyId, fac.CourseCampus, fac.JointCourseGroupKeyId
		)x
on cs.AcademicQtrKeyId=x.AcademicQtrKeyId and cs.CourseCampus=x.CourseCampus and cs.JointCourseGroupKeyId=x.JointCourseGroupKeyId
where 1=1

drop table ##course_faculty

select distinct
cc.AcademicQtrKeyId
,dd.AcademicYrName
,cc.CourseCampus
,cc.FinCollegeReportingName
,cc.FinDepartmentReportingName
,cc.CourseLevelNbr
,cc.CourseSectionCode
,cc.CurriculumAbbrCode
,cc.CourseNbr
,cc.CourseSectionId
,cc.SectionTypeDesc
,nct.research
,nct.service
,nct.diversity
,nct.writing
,cc.DistanceLearningTypeDesc
--,cc.Online_learning_desc
--,cc.CurriculumAbbrCode
,cc.JointCourseGroupKeyId
,cc.primary_course_code
,cc.CourseLevelCode
,cc.CourseLevelGroupCode
,cc.CourseUGGR
,cc.CourseSectionStudentCount
,cc.CourseSectionSeatsOffered
,cc.TotalCourseSCH
,cc.TotalCourseSectionStudentCount
--,cc.CourseSectionSeatsOffered
,mt.days_of_week
,mt.start_time
,mt.end_time
,mt.building
,mt.room_number
,mt.r25_seq_num
,count_of_faculty=case when ff.total_faculty is null then 1 else ff.total_faculty end
,simple_ratio_hc=cc.TotalCourseSectionStudentCount/ff.total_faculty
,simple_faculty_load_SCH=cc.TotalCourseSCH/ff.total_faculty
,si.instr_name
,si.instr_netid
,sci.fac_pct_involve
into ##course_faculty  --select * from ##course_faculty
from ##courses cc  --select * from ##courses
left join ##faculty ff
on cc.AcademicQtrKeyId=ff.AcademicQtrKeyId and cc.CourseCampus=ff.CourseCampus and cc.primary_course_code=ff.primary_section_code
left join EDWPresentation.sec.dimDate dd
on cc.AcademicQtrKeyId=dd.AcademicContigYrQtrCode
--add
left join UWSDBDataStore.sec.time_sched_meeting_times mt
on cc.AcademicQtrKeyId=mt.ts_year*10+mt.ts_quarter and cc.CurriculumAbbrCode=mt.dept_abbrev and cc.CourseNbr=mt.course_no and cc. CourseSectionId=mt.section_id
left join uwsdbdatastore.sec.sr_course_instr sci
   on cc.AcademicQtrKeyId=sci.fac_yr*10+sci.fac_qtr and cc.CourseCampus=sci.fac_branch
      and cc.CurriculumAbbrCode=sci.fac_curric_abbr and cc.CourseNbr=sci.fac_course_no
      and cc.CourseSectionId=sci.fac_sect_id
left join uwsdbdatastore.sec.sr_instructor si
   on sci.fac_yr=si.instr_yr and sci.fac_qtr=si.instr_qtr and sci.fac_ssn=si.instr_ssn
left join ##new_course_titles nct
on cc.CourseCampus=nct.course_branch and cc.CurriculumAbbrCode=nct.department_abbrev and cc.CourseNbr=nct.course_number

--end
where dd.AcademicQtrCensusDayInd='Y'
order by cc.AcademicQtrKeyId, cc.CourseCampus, cc.primary_course_code


/*
create a guardian table
primarily for information on first generation and gross_income both are non-maditory fields
*/

drop table ##guardian
select distinct
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
from
         (select distinct
               system_key,
               max(guardian_ed_level) as guardian_high_ed_level
          from uwsdbdatastore.sec.sr_adm_appl_guardian_data 
         group by system_key
         )j
left join (select distinct
               system_key,
               max(income_gross) as guardian_gross_income
          from uwsdbdatastore.sec.sr_adm_appl_income_data 
         group by system_key
         )k
on k.system_key=j.system_key  
--end guardian table




/*
adding student information
*/
drop table ##population
select distinct
s.AcademicQtrKeyId
,s.SDBSrcSystemKey
,s.AcademicYrName
,s.TacomaStudentInd
,s.Age
,age_group_under_18=case 
	  when s.Age between 0 and 17.999999 then 'under 18'
	  when s.Age between 18 and 21.999999 then '18 to 21'
	  when s.Age between 22 and 29.999999 then '22 to 29'
	  when s.Age between 30 and 39.999999 then '30 to 39'
	  when s.Age between 40 and 49.999999 then '40 to 49' 
	  when s.Age >= 50 then '50 or over' else 'error' end
,s.GenderCode
,s.AcademicCareerEntryType
,s.StudentClass
,s.StudentLevel
,gg.first_generation
--,s.FirstGeneration4YrDegree
--,s.FirstGenerationMatriculated
,s1.running_start
,s1.college_in_hs
,s.InternationalStudentInd
,s.MultipleRaceGrpInd
,s.IPEDSRaceEthnicityCategory
,s.UnderrepresentedMinorityInd
,s.RaceGrpAfricanAmerInd
,s.RaceGrpAmerIndianInd
,s.RaceGrpAsianInd
,s.RaceGrpCaucasianInd
,s.RaceGrpHawaiiPacIslanderInd
,s.RaceGrpNotIndicatedInd
,s.VeteranDesc
,Disability_reported=case when s1.disability_dss=0 then 0 else 1 end
,s.QuarterlyTotalSCH
,s.FullTimeStudentInd
,FA_aid_need_eligible=case when s.AcademicQtrCensusDayHuskyPromiseEligibleStudentInd='Y' then 1
					  when s.AcademicQtrCensusDayPellEligibleStudentInd='Y' then 1
					  when s.AcademicQtrCensusDayStateNeedGrantRecipientInd='Y' then 1 else 0 end
,r.studentcohortqtrkeyid
,r.SDBSrcDegreeGrantedDate
,r.TimeToDegreeInTerms
,r.RetainedTerm01
,r.Retained01YearLater
,r.DeceasedFlag
into ##population  --select * from ##population
from AnalyticInteg.sec.IV_StudentFactSheet s
left join uwsdbdatastore.sec.student_1 s1
on s.sdbsrcsystemKey=s1.system_key
left join AnalyticInteg.sec.IV_UndergraduateGraduationRetentionTerms r
on s.sdbsrcsystemkey=r.sdbsrcsystemkey
left join ##guardian gg
on s1.system_key=gg.system_key
where s.AcademicQtrKeyId between @start_quarter and @end_quarter --and cs.CourseCampus=@campus
and s.TacomaStudentInd='Y' and r.DeceasedFlag!=1
and s.StudentLevel='Undergraduate'



 
/*
Create a table of college prep indicators
*/

drop table ##college_prep_hs
select distinct
a.system_key
,RunningStart=case when a.running_start='Y' then 1 else 0 end
,CollegeInHS=case when a.college_in_hs='Y' then 1 else 0 end
,CreditbyExam=case when exists(select x.system_key
                              from uwsdbdatastore.sec.sr_extension x
                              where x.course_type=3
                              and x.system_key=a.system_key)
             then 1 
             else 0
             end
,APcredit=case when exists(select x.system_key
                              from uwsdbdatastore.sec.sr_extension x
                              where x.course_type=4
                              and x.system_key=a.system_key)
             then 1 
             else 0
             end
,IBcredit=case when exists(select x.system_key
                              from uwsdbdatastore.sec.sr_extension x
                              where x.course_type=5
                              and x.system_key=a.system_key)
             then 1 
             else 0
             end
--MathPlacement_old=mp2.placement,
--MathPlacement_new=mp3.test_score

into ##college_prep_hs  --drop table ##college_prep_hs select* from ##college_prep_hs where system_key=1031851
from ##population cp
inner join UWSDBDataStore.sec.student_1 a
on cp.SDBSrcSystemKey=a.system_key
inner join UWSDBDataStore.sec.student_2 a2
on a.system_key=a2.system_key
where 1=1




/*
add student course and quarter info
*/


select distinct
p.*
--p.SDBSrcSystemKey as system_key
--,p.AcademicQtrKeyId
,rr.enroll_status
,rc.regis_yr*10+rc.regis_qtr as reg_yrqtr
,rr.regis_class
,course_id=cast(rc.course_branch as char(1))+'-'+cast(ltrim(rtrim(rc.crs_curric_abbr)) as varchar) +' '+convert(varchar(3),rc.crs_number)
,CourseSectionCode=cast(rc.course_branch as char(1))+'_'+cast(ltrim(rtrim(rc.crs_curric_abbr)) as varchar) +'_'+convert(varchar(3),rc.crs_number)+'_'+cast (ltrim(rtrim(rc.crs_section_id)) as varchar)
,rc.credits
,rc.grade
,rc.request_status
,ts.section_type_code
,ts.ts_research as current_timeschedule_research
,ts.ts_service as current_timeschedule_service
,ts.diversity_crs as current_timeschedule_diversity
,ts.writing_crs as current_timeschedule_writing
,current_timeschedule_research_or_service_or_diversity=case when ts.ts_research=1 or ts.ts_service=1 or ts.diversity_crs=1 or ts.writing_crs=1then 1 else 0 end
,ct.research as UWT_proposed_research
,ct.service as UWT_proposed_service
,UWT_proposed_timeschedule_research_or_service=case when ct.research=1 or ct.service=1 then 1 else 0 end
,ct.FinCollegeReportingName as CourseCollege
,ct.FinDepartmentReportingName as CourseDepartment
,major_id=CAST(rcm.regis_branch AS CHAR(1)) 
             + '-' + RTRIM(rcm.regis_major_abbr) 
             + '-' + RIGHT('00' + CONVERT(varchar(2),rcm.regis_pathway),2)
,md.FinCollegeReportingName as MajorCollege
,md.FinDepartmentReportingName as MajorDepartment
,class_abbr =
             case when rr.regis_class = 1 then 'FR'
                  when rr.regis_class = 2 then 'SO'
                  when rr.regis_class = 3 then 'JR'
                  when rr.regis_class = 4 then 'SR'
                  when rr.regis_class = 5 then '5YR'
                  when rr.regis_class = 6 then 'NM'
                  --case when smmdp.mm_deg_level > 1 
                  --     then 'GNM'
                  --     else 'NM'
                  --end
                  when rr.regis_class = 7 then 'PR'
                  when rr.regis_class = 8 then 'GR'
                  when rr.regis_class = 9 then 'PR'
                  when rr.regis_class = 10 then 'PR'
                  when rr.regis_class = 11 then 'P1'
                  when rr.regis_class = 12 then 'P2'
                  when rr.regis_class = 13 then 'P3'
                  when rr.regis_class = 14 then 'P4'
                  else ''
             end
,rcm.regis_deg_level as deg_level	
,rr.tenth_day_credits		 		
,ft_pt_label=case when rr.tenth_day_credits <12 and rcm.regis_deg_level <2  then 'Part-time' --UG
      		when rr.tenth_day_credits>11.99 and rcm.regis_deg_level <2 then 'Full-time' --UG
      		when rr.tenth_day_credits <10 and rcm.regis_deg_level >1 then 'Part-time' --GR
      		when rr.tenth_day_credits >9.99 and rcm.regis_deg_level >1 then 'Full-time' --GR
      		else 'UD'
    		 end

,rr.current_credits as current_credits
,ncr_abbr_desc=case rr.regis_ncr
				when 0 then 'CONTINUING'
				when 1 then 'NEW'
				when 2 then 'FORMER'
				when 3 then 'NEW ACCT, CONT'--'NEW ACCT, CONT' --change and changed back per Jim as of AU 09
				when 4 then 'NEW ACCT, FORMER'--'NEW ACCT, FORMER'
				else ' ' end
,hs.APcredit
,hs.IBcredit
,hs.CreditbyExam
,hs.RunningStart
,hs.CollegeInHS
--,gender=case when s.s1_gender='F' then 'Female' else 'Male' end
--,age_truncated = datediff(hh,s.birth_dt, cal.tenth_day)/8766  --change to truncated
-- ,age_decimal = datediff(hh,s.birth_dt, cal.tenth_day)/8766.0  --change to truncated
--,age_group_under_18=case 
--	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 0 and 17.999999 then 'under 18'
--	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 18 and 21.999999 then '18 to 21'
--	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 22 and 29.999999 then '22 to 29'
--	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 30 and 39.999999 then '30 to 39'
--	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) between 40 and 49.999999 then '40 to 49' 
--	  when (datediff(hh,s.birth_dt, cal.tenth_day)/8766.0) >= 50 then '50 or over' else 'error' end
--,eg.EthnicGroupLongDesc as ethnic
--,f.ethnic_long_desc as ethnic_specific
--,case when eg2.EthnicGroupLongDesc='Hispanic/Latino' then 1 else 0 end as hispanic
--,      combined_ethnic_VISAspecific=case when s.resident=5 then 'International (w/Visa)'
--						   when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
--                           else eg.EthnicGroupLongDesc
--                           end
--,	  combined_ethnic=case when s.resident in (5,6) then 'International'
--						   when g.ethnic_desc='hispanic' then 'Hispanic/Latino' 
--                           else eg.EthnicGroupLongDesc
--                           end
--,vet_status=vet.veteran_descrip
--,disability_on_record=case when dis.disability_desc='None' then 0 else 1 end
into ##registration1  --select * from ##population order by system_key  select * from uwsdbdatastore.sec.student_1 where system_key=710912  drop table ##registration
from ##population p  --select * from ##population  select * from ##registration
--UWSDBDataStore.sec.student_1 s
--inner join UWSDBDataStore.sec.sr_mini_master smmv
--on s.system_key=smmv.mm_system_key
--inner join uwsdbdatastore.sec.sr_mini_master_deg_program smmdp
--   on smmv.mm_year = smmdp.mm_year and
--      smmv.mm_qtr = smmdp.mm_qtr and
--      smmv.mm_proc_ind = smmdp.mm_proc_ind
--      and smmv.mm_student_no =smmdp.mm_student_no	
inner join uwsdbdatastore.sec.registration rr
	on p.SDBSrcSystemKey=rr.system_key --and smmv.mm_year=rr.regis_yr and smmv.mm_qtr=rr.regis_qtr	   
inner join uwsdbdatastore.sec.registration_courses rc
	on rr.system_key=rc.system_key and rr.regis_yr=rc.regis_yr and rr.regis_qtr=rc.regis_qtr
left join UWSDBDataStore.sec.time_schedule ts
on rc.regis_yr=ts.ts_year and rc.regis_qtr=ts.ts_quarter and rc.sln=ts.sln
left join ##new_course_titles ct
on rc.course_branch=ct.course_branch and rc.crs_curric_abbr=ct.department_abbrev and rc.crs_number=ct.course_number
inner join UWSDBDataStore.sec.registration_regis_col_major rcm
on rr.system_key=rcm.system_key and rr.regis_yr=rcm.regis_yr and rr.regis_qtr=rcm.regis_qtr 
inner join uwsdbdatastore.sec.sys_tbl_39_calendar stc 
        on cast(rc.regis_yr as varchar) + cast(rc.regis_qtr as varchar) =  
        cast(cast(stc.table_key as int) as varchar) 
left join ##college_prep_hs hs
on p.SDBSrcSystemKey=hs.system_key
left join ##major_dept md
on rcm.regis_major_abbr=md.major_abbr and rcm.regis_pathway=md.major_pathway
--left join uwsdbdatastore.sec.sys_tbl_21_ethnic f
--   on f.table_key=s.ethnic_code
--left join UWSDBDataStore.sec.SDMOEthnicGroup eg
--   on f.ethnic_group=eg.EthnicGroupCode
--left join uwsdbdatastore.sec.sys_tbl_21_ethnic g
--   on g.table_key=s.hispanic_code
--left join UWSDBDataStore.sec.SDMOEthnicGroup eg2
--   on g.ethnic_group=eg2.EthnicGroupCode
-- left join UWSDBDataStore.sec.sys_tbl_44_veteran vet
--  on s.veteran=vet.table_key
--left join UWSDBDataStore.sec.sys_tbl_20_disability dis
--on s.disability_dss=dis.table_key
-- left join ( --modified from inner

--               select
--                     yr = left(cast(cast(stc.table_key as int) as varchar),4),
--                     qtr = substring(cast(cast(stc.table_key as int) as varchar),5,1),
--                     tenth_day
--                 from UWSDBDataStore.sec.sys_tbl_39_calendar stc
                 
--       )cal
--on rr.regis_yr = cal.yr and rr.regis_qtr = cal.qtr 
where rr.regis_yr*10+rr.regis_qtr=p.AcademicQtrKeyId
		--and rc.course_branch=2
		and rcm.regis_branch=2 --and smmv.mm_proc_ind=2 --and smmv.mm_enroll_status=12
		--and rc.course_branch=2
      	and(((rc.request_status like '%W%'and rc.request_dt > stc.tenth_day ) or (rc.request_status like 'D' and rc.add_dt > stc.tenth_day )
        or(rc.request_status in ('A','C','R')))) 
		--and cast(rc.course_branch as char(1))+'-'+cast(rc.crs_curric_abbr as varchar) +' '+convert(varchar(3),rc.crs_number)='2-T NURS 414'
		and ts.section_type_code not in ('LB','PR', 'QZ')
order by p.SDBSrcSystemKey, cast(rc.course_branch as char(1))+'-'+cast(ltrim(rtrim(rc.crs_curric_abbr)) as varchar) +' '+convert(varchar(3),rc.crs_number)


select * from ##course_faculty
order by CourseSectionCode asc
/*combine registration and faculty info
*/
select distinct
r.*
,cf.*
from ##registration1 r
left join ##course_faculty cf
on r.AcademicQtrKeyId=cf.AcademicQtrKeyId and r.CourseSectionCode=cf.CourseSectionCode
order by r.SDBSrcSystemKey asc, r.reg_yrqtr asc