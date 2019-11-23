Do not program mutiple complex proc report compute blocks                                                      
                                                                                                               
You can very easily be painted into a corner, if you boss asks for a change to the report code.                
You already had to resructure the report code to get the right order.                                          
                                                                                                               
Computations should be pre-computed?                                                                           
                                                                                                               
githib                                                                                                         
https://tinyurl.com/utmflmb                                                                                    
https://github.com/rogerjdeangelis/utl-do-not-program-mutiple-complex-proc-report-compute-blocks               
                                                                                                               
SAS Forum                                                                                                      
https://tinyurl.com/vp8f5t5                                                                                    
https://communities.sas.com/t5/SAS-Programming/PROC-REPORT-obs-number-reported/m-p/606682                      
                                                                                                               
*                _     _                                _                                                      
 _ __  _ __ ___ | |__ | | ___ _ __ ___     ___ ___   __| | ___                                                 
| '_ \| '__/ _ \| '_ \| |/ _ \ '_ ` _ \   / __/ _ \ / _` |/ _ \                                                
| |_) | | | (_) | |_) | |  __/ | | | | | | (_| (_) | (_| |  __/                                                
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|  \___\___/ \__,_|\___|                                                
|_|                                                                                                            
;                                                                                                              
                                                                                                               
proc sort data=sashelp.cars out=cars_make;                                                                     
  by make;                                                                                                     
run;                                                                                                           
                                                                                                               
data finalcars;                                                                                                
   set cars_make;                                                                                              
      ** capture internal obs number into variable for reporting;                                              
      ** after ensuring that data is correctly ordered by Make;                                                
     _obs = _n_;                                                                                               
run;                                                                                                           
                                                                                                               
** using firstobs and obs does not make sense if you are wanting to "group" by make;                           
** but I kept that part in the report definition;                                                              
proc report data=finalcars (firstobs= 1 obs= 50) ;                                                             
   column make _obs DISP_make type weight;                                                                     
   define make /order noprint;                                                                                 
   define _obs /order;                                                                                         
   define DISP_make /computed;                                                                                 
                                                                                                               
   /*          ___                                                                                             
    _ __   ___|__ \                                                                                            
   | '_ \ / _ \ / /                                                                                            
   | | | | (_) |_|                                                                                             
   |_| |_|\___/(_)                                                                                             
   */                                                                                                          
                                                                                                               
   compute before make;                                                                                        
      cnt_make + 1;                                                                                            
      hold_make= make;                                                                                         
   endcomp;                                                                                                    
   compute make;                                                                                               
      length sval $100 bk $20;                                                                                 
      if mod(cnt_make, 2) = 0 then bk= 'cxc4efd3';                                                             
      else bk= 'cxdddddd';                                                                                     
      sval= catt('style={background=', bk, '}');                                                               
      call define (_row_, 'style', sval);                                                                      
   endcomp;                                                                                                    
   compute DISP_make / character length= 20;                                                                   
      DISP_make = hold_make;                                                                                   
   endcomp;                                                                                                    
                                                                                                               
run;quit;                                                                                                      
                                                                                                               
*_           _                 _                                                                               
(_)_ __  ___| |_ ___  __ _  __| |                                                                              
| | '_ \/ __| __/ _ \/ _` |/ _` |                                                                              
| | | | \__ \ ||  __/ (_| | (_| |                                                                              
|_|_| |_|___/\__\___|\__,_|\__,_|                                                                              
                                                                                                               
;                                                                                                              
                                                                                                               
proc sort data=sashelp.cars out=cars_make;                                                                     
  by make;                                                                                                     
run;                                                                                                           
                                                                                                               
data finalcars;                                                                                                
   retain cnt_make 0 hold_make;                                                                                
   length sval $100 bk $20;                                                                                    
   set cars_make(keep=make type origin);                                                                       
   by make;                                                                                                    
   if first.make then do;                                                                                      
      cnt_make=0;                                                                                              
      hold_make=make;                                                                                          
   end;                                                                                                        
   cnt_make=cnt_make+1;                                                                                        
     _obs = _n_;                                                                                               
   if mod(cnt_make, 2) = 0 then bk= 'cxc4efd3';                                                                
   else bk= 'cxdddddd';                                                                                        
   sval= catt('style={background=', bk, '}');                                                                  
   DISP_make = hold_make;                                                                                      
run;                                                                                                           
                                                                                                               
proc report data=finalcars (firstobs= 1 obs= 50) ;                                                             
   column make _obs DISP_make type origin;                                                                     
   define make /order noprint;                                                                                 
   define _obs /order;                                                                                         
run;                                                                                                           
                                                                                                               
