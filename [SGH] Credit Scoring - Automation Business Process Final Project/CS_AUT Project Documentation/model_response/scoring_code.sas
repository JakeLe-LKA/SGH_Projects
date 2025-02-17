proc sql; 
create table  &zbior._score as 
select indataset.*  
, case 
when app_number_of_children < 0.5 then 87.0 
when 0.5 <= app_number_of_children  and  app_number_of_children < 1.5 then 82.0 
when 1.5 <= app_number_of_children then 72.0 
else 87.0 end as PSC_app_number_of_children 
 
, case 
when act_cins_n_statC is null then 87.0 
when act_cins_n_statC < 0.5 then 51.0 
when 0.5 <= act_cins_n_statC  and  act_cins_n_statC < 1.5 then 42.0 
when 1.5 <= act_cins_n_statC  and  act_cins_n_statC < 3.5 then 33.0 
when 3.5 <= act_cins_n_statC then 26.0 
else 87.0 end as PSC_act_cins_n_statC 
 
, case 
when act_ccss_n_statC is null then 87.0 
when act_ccss_n_statC < 0.5 then 40.0 
when 0.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 1.5 then 35.0 
when 1.5 <= act_ccss_n_statC  and  act_ccss_n_statC < 6.5 then 32.0 
when 6.5 <= act_ccss_n_statC then 3.0 
else 87.0 end as PSC_act_ccss_n_statC 
 
, case 
when agr3_Min_CMaxC_Days is null then 87.0 
when agr3_Min_CMaxC_Days < 10.5 then 84.0 
when 10.5 <= agr3_Min_CMaxC_Days  and  agr3_Min_CMaxC_Days < 12.5 then 83.0 
when 12.5 <= agr3_Min_CMaxC_Days  and  agr3_Min_CMaxC_Days < 13.5 then 82.0 
when 13.5 <= agr3_Min_CMaxC_Days then 81.0 
else 87.0 end as PSC_agr3_Min_CMaxC_Days 
 
, case 
when 3.5 <= agr3_Max_CMaxC_Due then 87.0 
when agr3_Max_CMaxC_Due is null then 80.0 
when 2.5 <= agr3_Max_CMaxC_Due  and  agr3_Max_CMaxC_Due < 3.5 then 61.0 
when agr3_Max_CMaxC_Due < 0.5 then 53.0 
when 0.5 <= agr3_Max_CMaxC_Due  and  agr3_Max_CMaxC_Due < 2.5 then 46.0 
else 87.0 end as PSC_agr3_Max_CMaxC_Due 
 
, case 
when app_char_gender in ('Male') then 87.0 
when app_char_gender in ('Female') then 73.0 
else 87.0 end as PSC_app_char_gender 
 
/* , 1/(1+exp(-(-0.03470615984684748*(0.0+ calculated PSC_app_number_of_children+ calculated PSC_act_cins_n_statC+ calculated PSC_act_ccss_n_statC+ calculated PSC_agr3_Min_CMaxC_Days+ calculated PSC_agr3_Max_CMaxC_Due+ calculated PSC_app_char_gender)+(12.97015984312209)))) as PD */ 
 
, 0.0 
+ calculated PSC_app_number_of_children + calculated PSC_act_cins_n_statC + calculated PSC_act_ccss_n_statC + calculated PSC_agr3_Min_CMaxC_Days + calculated PSC_agr3_Max_CMaxC_Due + calculated PSC_app_char_gender  as SCORECARD_POINTS 
 
from &zbior as indataset; 
quit; 
