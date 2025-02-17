proc sql; 
create table  &zbior._score as 
select indataset.*  
, case 
when act_age < 36.5 then 294.0 
when 39.5 <= act_age  and  act_age < 43.5 then 336.0 
when 36.5 <= act_age  and  act_age < 39.5 then 349.0 
when 43.5 <= act_age  and  act_age < 55.5 then 360.0 
when 55.5 <= act_age  and  act_age < 68.5 then 375.0 
when 68.5 <= act_age then 388.0 
else 294.0 end as PSC_act_age 
 
, case 
when 1.476 <= act_cc then 294.0 
when 1.187 <= act_cc  and  act_cc < 1.476 then 335.0 
when 1.054 <= act_cc  and  act_cc < 1.187 then 361.0 
when 0.829 <= act_cc  and  act_cc < 1.054 then 383.0 
when 0.225 <= act_cc  and  act_cc < 0.829 then 401.0 
when act_cc < 0.225 then 431.0 
else 294.0 end as PSC_act_cc 
 
, case 
when 30.0 <= app_n_installments then 294.0 
when 18.0 <= app_n_installments  and  app_n_installments < 30.0 then 320.0 
when app_n_installments < 18.0 then 330.0 
else 294.0 end as PSC_app_n_installments 
 
, case 
when app_number_of_children < 0.5 then 294.0 
when 0.5 <= app_number_of_children  and  app_number_of_children < 1.5 then 330.0 
when 1.5 <= app_number_of_children  and  app_number_of_children < 2.5 then 380.0 
when 2.5 <= app_number_of_children then 468.0 
else 294.0 end as PSC_app_number_of_children 
 
, case 
when 1.5 <= act_cins_n_loan then 294.0 
when act_cins_n_loan < 1.5 then 378.0 
else 294.0 end as PSC_act_cins_n_loan 
 
, case 
when act_cins_min_seniority < 10.5 then 294.0 
when 10.5 <= act_cins_min_seniority  and  act_cins_min_seniority < 16.5 then 324.0 
when 16.5 <= act_cins_min_seniority  and  act_cins_min_seniority < 23.5 then 332.0 
when 23.5 <= act_cins_min_seniority  and  act_cins_min_seniority < 29.5 then 344.0 
when act_cins_min_seniority is null then 354.0 
when 29.5 <= act_cins_min_seniority  and  act_cins_min_seniority < 54.5 then 370.0 
when 54.5 <= act_cins_min_seniority then 384.0 
else 294.0 end as PSC_act_cins_min_seniority 
 
, case 
when act_cins_n_statC < 0.5 then 294.0 
when act_cins_n_statC is null then 323.0 
when 0.5 <= act_cins_n_statC  and  act_cins_n_statC < 1.5 then 331.0 
when 1.5 <= act_cins_n_statC  and  act_cins_n_statC < 2.5 then 334.0 
when 2.5 <= act_cins_n_statC  and  act_cins_n_statC < 3.5 then 346.0 
when 3.5 <= act_cins_n_statC  and  act_cins_n_statC < 4.5 then 360.0 
when 4.5 <= act_cins_n_statC then 404.0 
else 294.0 end as PSC_act_cins_n_statC 
 
, case 
when 2.5 <= act_cins_n_statB then 294.0 
when 1.5 <= act_cins_n_statB  and  act_cins_n_statB < 2.5 then 350.0 
when 0.5 <= act_cins_n_statB  and  act_cins_n_statB < 1.5 then 364.0 
when act_cins_n_statB is null then 370.0 
when act_cins_n_statB < 0.5 then 389.0 
else 294.0 end as PSC_act_cins_n_statB 
 
, case 
when app_char_gender in ('Male') then 294.0 
when app_char_gender in ('Female') then 313.0 
else 294.0 end as PSC_app_char_gender 
 
, case 
when app_char_job_code in ('Contract') then 294.0 
when app_char_job_code in ('Owner company') then 346.0 
when app_char_job_code in ('Retired') then 364.0 
when app_char_job_code in ('Permanent') then 370.0 
else 294.0 end as PSC_app_char_job_code 
 
/* , 1/(1+exp(-(-0.03469501176694363*(0.0+ calculated PSC_act_age+ calculated PSC_act_cc+ calculated PSC_app_n_installments+ calculated PSC_app_number_of_children+ calculated PSC_act_cins_n_loan+ calculated PSC_act_cins_min_seniority+ calculated PSC_act_cins_n_statC+ calculated PSC_act_cins_n_statB+ calculated PSC_app_char_gender+ calculated PSC_app_char_job_code)+(118.3807324056196)))) as PD */ 
 
, 0.0 
+ calculated PSC_act_age + calculated PSC_act_cc + calculated PSC_app_n_installments + calculated PSC_app_number_of_children + calculated PSC_act_cins_n_loan + calculated PSC_act_cins_min_seniority + calculated PSC_act_cins_n_statC + calculated PSC_act_cins_n_statB + calculated PSC_app_char_gender + calculated PSC_app_char_job_code  as SCORECARD_POINTS 
 
from &zbior as indataset; 
quit; 
