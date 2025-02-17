proc sql; 
create table  &zbior._score as 
select indataset.*  
, case 
when 0.801 <= act_cc then -8.0 
when 0.545 <= act_cc  and  act_cc < 0.801 then 32.0 
when act_cc < 0.545 then 58.0 
else -8.0 end as PSC_act_cc 
 
, case 
when app_number_of_children < 0.5 then -8.0 
when 0.5 <= app_number_of_children  and  app_number_of_children < 2.5 then 16.0 
when 2.5 <= app_number_of_children then 60.0 
else -8.0 end as PSC_app_number_of_children 
 
, case 
when act_ccss_n_statC < 3.5 then -8.0 
when 3.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 6.5 then 30.0 
when 6.5 <= act_ccss_n_statC then 94.0 
else -8.0 end as PSC_act_ccss_n_statC 
 
, case 
when 0.5 <= agr9_Min_CMaxA_Due then -8.0 
when agr9_Min_CMaxA_Due is null then 13.0 
when agr9_Min_CMaxA_Due < 0.5 then 22.0 
else -8.0 end as PSC_agr9_Min_CMaxA_Due 
 
, case 
when 0.625 <= agr12_Mean_CMaxA_Due then -8.0 
when agr12_Mean_CMaxA_Due is null then 3.0 
when 0.458 <= agr12_Mean_CMaxA_Due  and  agr12_Mean_CMaxA_Due < 0.625 then 17.0 
when agr12_Mean_CMaxA_Due < 0.458 then 37.0 
else -8.0 end as PSC_agr12_Mean_CMaxA_Due 
 
, case 
when app_char_job_code in ('Owner company') then -8.0 
when app_char_job_code in ('Permanent') then 14.0 
when app_char_job_code in ('Retired') then 40.0 
else -8.0 end as PSC_app_char_job_code 
 
/* , 1/(1+exp(-(-0.0343027158597849*(0.0+ calculated PSC_act_cc+ calculated PSC_app_number_of_children+ calculated PSC_act_ccss_n_statC+ calculated PSC_agr9_Min_CMaxA_Due+ calculated PSC_agr12_Mean_CMaxA_Due+ calculated PSC_app_char_job_code)+(5.552585230880766)))) as PD */ 
 
, 0.0 
+ calculated PSC_act_cc + calculated PSC_app_number_of_children + calculated PSC_act_ccss_n_statC + calculated PSC_agr9_Min_CMaxA_Due + calculated PSC_agr12_Mean_CMaxA_Due + calculated PSC_app_char_job_code  as SCORECARD_POINTS 
 
from &zbior as indataset; 
quit; 
