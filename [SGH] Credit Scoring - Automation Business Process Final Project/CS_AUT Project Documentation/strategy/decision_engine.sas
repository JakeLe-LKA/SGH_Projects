/*Decision engine defined by student*/
/*     initial version     */
/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */
/*                         */
%macro scoring_engine(wej,wyj);

data cal;
set &wej;
run;

%let zbior=cal;
%include "&dir.process\calibration\model_ins_risk\scoring_code.sas";

data cal1;
set cal_score;
risk_ins_score=.;
if product='ins' then risk_ins_score=SCORECARD_POINTS;
pd_ins=1/(1+exp(-(-0.026361171*risk_ins_score+87.463033636)));
drop psc: SCORECARD_POINTS;
run;

%let zbior=cal1;
%include "&dir.process\calibration\model_css_risk\scoring_code.sas";


data cal2;
set cal1_score;
risk_css_score=.;
if product='css' then risk_css_score=SCORECARD_POINTS;
pd_css=1/(1+exp(-(-0.030434892*risk_css_score+9.3776548604)));
drop psc: SCORECARD_POINTS;
run;


%let zbior=cal2;
%include "&dir.process\calibration\model_cross_css_risk\scoring_code.sas";


data cal3;
set cal2_score;
risk_cross_css_score=SCORECARD_POINTS;
pd_cross_css=1/(1+exp(-(-0.01058832*risk_cross_css_score-0.34701992)));
drop psc: SCORECARD_POINTS;
run;


%let zbior=cal3;
%include "&dir.process\calibration\model_response\scoring_code.sas";


data cal4;
set cal3_score;
response_score=SCORECARD_POINTS;
pr=1/(1+exp(-(-0.034705855*response_score+12.970046179)));
drop psc: SCORECARD_POINTS;
run;


data &wyj;
length cid $10 aid $16 product $3 period $6 decision $1 decline_reason $20
app_loan_amount app_n_installments pd cross_pd pr 8;

set cal4;
decision='A';
decline_reason='999ok';

cross_pd=pd_cross_css;
pd=.;
if product='ins' then pd=pd_ins;
if product='css' then pd=pd_css;

if (product = "css" and ags6_Max_CMaxA_Due > 4 and act_ccss_n_statB > 0) or
   (product = "ins" and ags6_Max_CMaxA_Due > 0 and act_cins_n_statB > 0) then do;
	decision='D';
	decline_reason='1 bad customer';
end;

if product='css' and pd_css>0.1936 then do;
	decision='D';
	decline_reason="1 PD cut-off on css";
end;

if product='ins' and pd_ins>0.0436 then do;
	decision='D';
	decline_reason="2 PD cut-off on ins";
end;

if product='ins' and 0.0436>=pd_ins>0.0178 
	and pr<0.0123 then do;
	decision='D';
	decline_reason="3 PD and PR cut-offs on ins";
end;

if period<'197501' then do;
	decision='A';
	decline_reason='999ok';
end;

if product='css' and act_cus_active ne 1 then do;
	decision='N';
	decline_reason='998 not active customer';
end;

keep
cid aid product period decision decline_reason app_loan_amount 
app_n_installments pd cross_pd pr;
format pd cross_pd pr nlpct12.2;
run;
%mend;
