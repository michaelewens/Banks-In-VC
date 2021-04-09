*****
* Create the VC revenue files from Call Reports
* From Chen and Ewens (2021) 
* Send comments or corrections to mewens@caltech.edu (or open an issue on Github)
/*

	1.  Load all the raw Call reports 
	Download these manually from: https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx

	2. Loop through the base data and create one file (baseCallData.dta)
	3.  Do the same loop for the income statements
	4.  Merge the two
	5.  Basic cleaning
	6. Export

*/
* Change directories
dropbox 
cd ../Volcker_Rule

****
* CHANGE
* The folder containing the raw files
local dir "C:\Users\Jun Chen\Desktop\Call_reports\data\raw"
******

* POR files: basic identity information of banks
* Get a list of all the sub folders
local folderList: dir "`dir'" dirs "*"

* loop through folders
 	* Save count variable for first vs non-first file
	local c = 0

* Loop through each folder
foreach folder of local folderList {
	* Only care about these files
  local fileList: dir "`dir'/`folder'" files "*POR*.txt"

  * loop through files
   foreach file of local fileList {
  
	di "`dir'/`folder'/`file'" 
	*load data from each file
		import delimited using "`dir'/`folder'/`file'", stringcols(_all) case(preserve) delim("\t") clear
		** Create a file name (so we can source)
		gen file_name = "`file'"
		* Get the report period from data
		gen report_period = regexs(1) if regexm(file_name, "([0-9]*)\.")
		ren file_name base_file_name
		* Create the running temp file.  If the first run, then no need to append
		if(`c' > 0){
			append using `fileData'
		}
		* Update for the next loop
		local c = 1
		tempfile fileData
		save `fileData'

	}
	* END OF THIS FOLDER
	* Note that temp is going to keep going to the next folder
  }

* Save as one big Stata file
save baseCallData.dta, replace


***********************
* INCOME STATEMENT FILES (RI)

*sub folders: get a list in a local variable
local folderList: dir "`dir'" dirs "*"

	* Save count variable for first vs non-first file
	local c = 0
	
* loop through folders
foreach folder of local folderList {
  local fileList: dir "`dir'/`folder'" files "* RI *.txt"

  * loop through files
  foreach file of local fileList {
	* Basic organization and cleaning
	di "`dir'/`folder'/`file'" 
	
	*load data from each file
	import delimited using "`dir'/`folder'/`file'", stringcols(_all) case(preserve) delim("\t") clear
	** label that variables
	foreach var of varlist _all {
	  label variable `var' "`=`var'[1]'"
	}
	*** Drop the first row because it incorrect from raw data (variable names)
	drop in 1
	*keep Venture Capital Revenue
	keep IDRSSD RIADB491 
	
	gen file_name = "`file'"
	* Get the period
	gen report_period = regexs(1) if regexm(file_name, "([0-9]*)\.")
	ren file_name ri_file_name
	if(`c' > 0){
		append using `fileData'
	}
	* Update for the next loop
	local c = 1
	tempfile fileData
	save `fileData'
	}	  
  }
* Income data is in memory here
  
* Merge on the baseline call report data
merge 1:1 IDRSSD report_period using baseCallData.dta, keep(1 2 3) nogen
erase baseCallData.dta

* KEEP VARIABLES THAT WE NEED
label var IDRSSD "Bank ID"
label var RIADB491 "VC Revenue"
label var report_period "Report Quarter"
label var FinancialInstitutionName "Bank Name"
label var FinancialInstitutionCity "City"
label var FinancialInstitutionState "State"
label var base_file_name "Base file name"
label var ri_file_name "VC revenue file name"

keep IDRSSD RIADB491 report_period FinancialInstitutionState FinancialInstitutionCity FinancialInstitutionName base_file_name ri_file_name


* Export as csv (Probably change)
outsheet using "../public_data_code/vcRevenue.csv", comma replace
