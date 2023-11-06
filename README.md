# U.S. banks venture capital activity

This repository contains [data](https://github.com/michaelewens/Banks-In-VC/blob/main/vcRevenue.csv.zip) (and [code](https://github.com/michaelewens/Banks-In-VC/blob/main/publicVCrevenue.do) to create it) on U.S. bank "venture capital (VC) revenue."  The [data](https://github.com/michaelewens/Banks-In-VC/blob/main/vcRevenue.csv.zip) plays an important role in the paper "Venture capitalists' access to capital" (Chen and Ewens 2021).  That paper uses this data to assess the importance of banking institutions as limited partners in venture capital.   The [zip file](https://github.com/michaelewens/Banks-In-VC/blob/main/vcRevenue.csv.zip) contains the csv file and the [Stata do file](https://github.com/michaelewens/Banks-In-VC/blob/main/publicVCrevenue.do) allows you to recreate it.  You will need to download the [raw Call Reports data from the FDIC](https://cdr.ffiec.gov/public/PWS/DownloadBulkData.aspx). 

## Cite

[Chen, Jun](http://en.rmbs.ruc.edu.cn/show-77-987-1.html) and [Michael Ewens](https://michaelewens.com).  "Venture Capital and Startup Agglomeration", Working Paper, 2023.

## Data description

We use data collected from banks’ Consolidated Reports of Condition and Income (i.e.,Call  Reports)  to  identify  banks’  engagement  in  VC  investments.   In  2001, venture  capitalrevenue(or VC revenue) was added as a new category of non-interest income on the Schedule RI-Income statement of banks’ Call Reports following the change of information collection made by the Federal Financial Institutions Examination Council (FFIEC). Since then, all U.S. banks have reported VC revenue on their Call Reports in each quarter. According to the FFIEC, the reported VC revenue mainly includes market value adjustments, interest,dividends, gains, and losses on banks' VC investments, any fee income from VC activities, and the proportionate share of the income or loss from their investments in equity method investees such as VC funds.   The next section provides more details, but first here are the variables:

### Variables
- `IDRSSD`: "Bank ID"
- `RIADB491` "VC Revenue"
- `report_period` "Report Quarter"
- `FinancialInstitutionName` "Bank Name"
- `FinancialInstitutionCity` "City"
- `FinancialInstitutionState` "State"
- `base_file_name` "Base file name"
- `ri_file_name` "VC revenue file name"

## More details on the data construction and setting

 To better understand the sources of this VC revenue or income, consider an example in which a bank invests as an LP into VC fund X. They invest $I and receives 20% of the fund (i.e.  they are 20% of total committed capital), and the bank’s equity position in the fund is 20% of all proceeds up to $I/0.2, and .80*.20 of all distributions after $I is paid back (i.e., 20% carry).  The fund has a 2% annual fee on committed capital, i.e.,<img src="https://render.githubusercontent.com/render/math?math=\$I*0.02"> is paid by the bank every year.  For the bank's VC investments in fund X, we can then analyze whether there will be venturecapital revenue booked for different types of events.
 
 1. Capital committment
 2. Management fee
 3. Capital calls (Drawdown)
 4. VC marks up or down the investment
 5. Capital  distribution
 6. The bank (either partially or fully) sells it position in the fund

See Appendix A of Chen and Ewens (2021) for more details.
