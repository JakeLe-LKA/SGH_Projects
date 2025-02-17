proc sql; 
create table  &zbior._score as 
select indataset.*  
, case 
when app_number_of_children < 0.5 then 18.0 
when 0.5 <= app_number_of_children  and  app_number_of_children < 1.5 then 23.0 
when 1.5 <= app_number_of_children  and  app_number_of_children < 2.5 then 38.0 
when 2.5 <= app_number_of_children then 79.0 
else 18.0 end as PSC_app_number_of_children 
 
, case 
when 1.583 <= act_call_cc then 18.0 
when 1.254 <= act_call_cc  and  act_call_cc < 1.365 then 29.0 
when 1.449 <= act_call_cc  and  act_call_cc < 1.583 then 33.0 
when 1.365 <= act_call_cc  and  act_call_cc < 1.449 then 44.0 
when 0.346 <= act_call_cc  and  act_call_cc < 1.254 then 50.0 
when act_call_cc < 0.346 then 60.0 
else 18.0 end as PSC_act_call_cc 
 
, case 
when 4.5 <= act_ccss_min_seniority  and  act_ccss_min_seniority < 5.5 then 18.0 
when 5.5 <= act_ccss_min_seniority  and  act_ccss_min_seniority < 8.5 then 30.0 
when act_ccss_min_seniority < 4.5 then 34.0 
when 8.5 <= act_ccss_min_seniority  and  act_ccss_min_seniority < 24.5 then 39.0 
when act_ccss_min_seniority is null then 54.0 
when 24.5 <= act_ccss_min_seniority  and  act_ccss_min_seniority < 43.5 then 57.0 
when 43.5 <= act_ccss_min_seniority then 70.0 
else 18.0 end as PSC_act_ccss_min_seniority 
 
, case 
when 2.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 3.5 then 18.0 
when 0.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 2.5 then 27.0 
when act_ccss_n_statC < 0.5 then 30.0 
when 3.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 7.5 then 37.0 
when act_ccss_n_statC is null then 56.0 
when 7.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 17.5 then 79.0 
when 17.5 <= act_ccss_n_statC then 123.0 
else 18.0 end as PSC_act_ccss_n_statC 
 
, case 
when 1.5 <= ags3_Mean_CMaxA_Due then 18.0 
when 1.167 <= ags3_Mean_CMaxA_Due  and  ags3_Mean_CMaxA_Due < 1.5 then 35.0 
when 0.833 <= ags3_Mean_CMaxA_Due  and  ags3_Mean_CMaxA_Due < 1.167 then 57.0 
when 0.583 <= ags3_Mean_CMaxA_Due  and  ags3_Mean_CMaxA_Due < 0.833 then 67.0 
when 0.167 <= ags3_Mean_CMaxA_Due  and  ags3_Mean_CMaxA_Due < 0.583 then 84.0 
when ags3_Mean_CMaxA_Due < 0.167 then 90.0 
else 18.0 end as PSC_ags3_Mean_CMaxA_Due 
 
, case 
when app_char_job_code in ('Contract') then 18.0 
when app_char_job_code in ('Owner company') then 76.0 
when app_char_job_code in ('Permanent') then 110.0 
when app_char_job_code in ('Retired') then 113.0 
else 18.0 end as PSC_app_char_job_code 
 
/* , 1/(1+exp(-(-0.03447114916896603*(0.0+ calculated PSC_app_number_of_children+ calculated PSC_act_call_cc+ calculated PSC_act_ccss_min_seniority+ calculated PSC_act_ccss_n_statC+ calculated PSC_ags3_Mean_CMaxA_Due+ calculated PSC_app_char_job_code)+(11.281861112359268)))) as PD */ 
 
, 0.0 
+ calculated PSC_app_number_of_children + calculated PSC_act_call_cc + calculated PSC_act_ccss_min_seniority + calculated PSC_act_ccss_n_statC + calculated PSC_ags3_Mean_CMaxA_Due + calculated PSC_app_char_job_code  as SCORECARD_POINTS 
 
from &zbior as indataset; 
quit; 
