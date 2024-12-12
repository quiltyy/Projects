IF OBJECT_ID('tempdb..#Details') IS NOT NULL  
DROP TABLE #Details  
IF OBJECT_ID('tempdb..#Results') IS NOT NULL  
DROP TABLE #Results    
SELECT dFP.FiscalYearCode , 
   dFP.FiscalPeriodCode , 
   dFP.PeriodCalendarMonthYear , 
   DFP.FiscalYearPeriod , 
   DFP.FiscalPeriodName , 
   dC.CompanyName --LedgerAccount  
   , 
   dLA.AllLedgerAccountsLevel1Code , 
   dLA.AllLedgerAccountsLevel1Name , 
   dLA.AllLedgerAccountsLevel2Code , 
   dLA.AllLedgerAccountsLevel2Name , 
   dLA.AllLedgerAccountsLevel3Code , 
   dLA.AllLedgerAccountsLevel3Name , 
   dLA.AllLedgerAccountsLevel4Code , 
   dLA.AllLedgerAccountsLevel4Name , 
   dLA.AllLedgerAccountsLevel5Code , 
   dLA.AllLedgerAccountsLevel5Name ---  ,DLA.LedgerAccountType  
   , 
   CASE  
      WHEN LedgerAccountType = 'Expense'  
     AND AllLedgerAccountsLevel4Code IN ('LAS10018','LAS10514') THEN 'Revenue'  
      WHEN LedgerAccountType ='Revenue'  
     AND AllLedgerAccountsLevel4Code = 'LAS10019' THEN 'Expense'  
      ELSE LedgerAccountType  
   END AS 'LedgerAccountType' , 
   dLT.LedgerTypeName , 
   dLA.LedgerAccountID , 
   dLA.LedgerAccountName --Spend Category  
   , 
   dSC.AllSpendCategoriesLevel1Code , 
   dSC.AllSpendCategoriesLevel1Name , 
   dSC.AllSpendCategoriesLevel2Code , 
   dSC.AllSpendCategoriesLevel2Name , 
   dSC.AllSpendCategoriesLevel3Code , 
   dSC.AllSpendCategoriesLevel3Name , 
   dSC.SpendCategoryRefID , 
   dSC.SpendCategoryName --Revenue Category  
   , 
   dRC.AllRevenueCategoriesLevel1Code , 
   dRC.AllRevenueCategoriesLevel1Name , 
   dRC.AllRevenueCategoriesLevel2Code , 
   dRC.AllRevenueCategoriesLevel2Name , 
   dRC.AllRevenueCategoriesLevel3Code , 
   dRC.AllRevenueCategoriesLevel3Name , 
   dRC.RevenueCategoryRefID , 
   dRC.RevenueCategoryName --Resource  
   , 
   dR.AllResourcesLevel1Code , 
   dR.AllResourcesLevel1Name , 
   dR.AllResourcesLevel2Code , 
   dR.AllResourcesLevel2Name , 
   dR.AllResourcesLevel3Code , 
   dR.AllResourcesLevel3Name , 
   dR.AllResourcesLevel4Code , 
   dR.AllResourcesLevel4Name , 
   dR.ResourceCode , 
   dR.ResourceCodeName --Balancing Unit  
   , 
   dBU.AllBalancingUnitsLevel2Code , 
   dBU.AllBalancingUnitsLevel2Name , 
   dBU.BalancingUnitCode , 
   dBU.BalancingUnitName --Cost Center  
   , 
   dCC.AllCostCentersLevel1Code , 
   dCC.AllCostCentersLevel1Name , 
   dCC.AllCostCentersLevel2Code , 
   dCC.AllCostCentersLevel2Name , 
   dCC.AllCostCentersLevel3Code , 
   dCC.AllCostCentersLevel3Name , 
   dCC.AllCostCentersLevel4Code , 
   dCC.AllCostCentersLevel4Name , 
   dCC.AllCostCentersLevel5Code , 
   dCC.AllCostCentersLevel5Name , 
   dCC.AllCostCentersLevel6Code , 
   dCC.AllCostCentersLevel6Name , 
   dCC.AllCostCentersLevel7Code , 
   dCC.AllCostCentersLevel7Name , 
   dCC.AllCostCentersLevel8Code , 
   dCC.AllCostCentersLevel8Name , 
   dCC.AllCostCentersLevel9Code , 
   dCC.AllCostCentersLevel9Name , 
   dCC.CostCenterCode , 
   dCC.CostCenterName --Program  
   , 
   dP.AllProgramsLevel1Code , 
   dP.AllProgramsLevel1Name , 
   dP.AllProgramsLevel2Code , 
   dP.AllProgramsLevel2Name , 
   dP.AllProgramsLevel3Code , 
   dP.AllProgramsLevel3Name , 
   dP.AllProgramsLevel4Code , 
   dP.AllProgramsLevel4Name , 
   dP.AllProgramsLevel5Code , 
   dP.AllProgramsLevel5Name , 
   dP.ProgramRefID , 
   dP.ProgramName --Fund  
   , 
   dF.AllFundsLevel2Code , 
   dF.AllFundsLevel2Name , 
   dF.AllFundsLevel3Code , 
   dF.AllFundsLevel3Name , 
   dF.AllFundsLevel4Code , 
   dF.AllFundsLevel4Name , 
   dF.FundRefID , 
   dF.FundName --Grant  
   , 
   dG.AllGrantsLevel2Code , 
   dG.AllGrantsLevel2Name , 
   dG.AllGrantsLevel3Code , 
   dG.AllGrantsLevel3Name , 
   dG.AllGrantsLevel4Code , 
   dG.AllGrantsLevel4Name , 
   dG.AllGrantsLevel5Code , 
   dG.AllGrantsLevel5Name , 
   dG.AllGrantsLevel6Code , 
   dG.AllGrantsLevel6Name , 
   dG.GrantRefID , 
   dG.GrantName --Gift  
   , 
   dGift.GiftRefID , 
   dGift.GiftName -- Appropriation  
   ,  
   DA.AllAppropriationsLevel1Code , 
   DA.AllAppropriationsLevel1name , 
   DA.AllAppropriationsLevel2code , 
   DA.AllAppropriationsLevel2name , 
   DA.AllAppropriationsLevel3code , 
   DA.AllAppropriationsLevel3name , 
   DA.AppropriationName -- object class  
   , 
   Do.[ObjectClassRefID] , 
   Do.[ObjectClassName] , 
   DO.[ObjectClassCodeName] -- Sponsor  
   , 
   DS.[SponsorCodeName] ,  
   DS.[SponsorType] -- Jornal Source  
   , 
   DJS.[JournalSourceName] -- Function    
   , 
   DFU.[FunctionCode] , 
   DFU.[FunctionName] , 
   DFU.[FunctionCodeName] , 
   CONCAT(DFU.[AllFunctionsLevel1Code], ': ',DFU.[AllFunctionsLevel1Name]) AS 'Function Level 1' , 
   CONCAT(DFU.[AllFunctionsLevel2Code], ': ',DFU.[AllFunctionsLevel2Name]) AS 'Function Level 2' , 
   CONCAT(DFU.[AllFunctionsLevel3Code], ': ',DFU.[AllFunctionsLevel3Name]) AS 'Function Level 3' , 
   CONCAT(DFU.[AllFunctionsLevel4Code], ': ',DFU.[AllFunctionsLevel4Name]) AS 'Function Level 4' , 
   CONCAT(DFU.[AllFunctionsLevel5Code], ': ',DFU.[AllFunctionsLevel5Name]) AS 'Function Level 5' , 
   CONCAT(DFU.[AllFunctionsLevel6Code], ': ',DFU.[AllFunctionsLevel6Name]) AS 'Function Level 6' -- 
   -- Flags and Measures  
   , 
   fJL.IsCommonBook , 
   fJL.IsFinancialReportingBook , 
   CASE  
      WHEN LedgerAccountType ='Revenue'  
     AND AllLedgerAccountsLevel4Code = 'LAS10019' THEN 0  
      WHEN LedgerAccountType = 'Expense'  
     AND FJL.LedgerTypeSID = 725496  
     AND AllLedgerAccountsLevel4Code IN ('LAS10018','LAS10514')THEN  
         [LedgerBudgetDebitMinusCreditAmt]  
      WHEN LedgerAccountTypeCode = 'Revenue'  
     AND FJL.LedgerTypeSID = 725496  
     AND fJL.LedgerAccountSID <> 527 THEN [LedgerBudgetDebitMinusCreditAmt]  
   END as ActualRevenue , 
   CASE  
      WHEN LedgerAccountType = 'Expense'  
     AND FJL.LedgerTypeSID = 725496  
     AND AllLedgerAccountsLevel4Code IN ('LAS10018','LAS10514') THEN 0  
      WHEN LedgerAccountType ='Revenue'  
     AND AllLedgerAccountsLevel4Code = 'LAS10019' THEN [LedgerBudgetDebitMinusCreditAmt]  
      WHEN LedgerAccountTypeCode = 'Expense'  
     AND FJL.LedgerTypeSID = 725496 THEN[LedgerBudgetDebitMinusCreditAmt]  
   END as ActualExpense , 
   CASE  
      WHEN [IsBeginningBalanceJournal]like'true'  
     AND DLA.[LedgerAccountSID]=285 THEN [LedgerBudgetDebitMinusCreditAmt]  
   END as Begning_balance1 , 
   CASE  
      WHEN dLA.LedgerAccountTypeCode = 'Net_Position'  
     AND FJL.LedgerTypeSID = 725496 THEN [LedgerBudgetDebitMinusCreditAmt]  
   END As 'Net_Position' , 
   CASE  
      WHEN [IsBeginningBalanceJournal]='true'  
     AND FJL.[LedgerAccountSID]=285 THEN [LedgerBudgetDebitMinusCreditAmt]  
   END as Begning_balance , 
   CASE  
      WHEN (dLA.LedgerAccountTypeCode = 'Grant_Income'  
      OR fJL.LedgerAccountSID = 285)  
     AND FJL.LedgerTypeSID = 725496 THEN [LedgerBudgetDebitMinusCreditAmt]  
   END As 'Grant Income' , [LedgerBudgetDebitMinusCreditAmt]  
   ,[IsBeginningBalanceJournal]  
   ,  
   FJL.[LedgerAccountSID]  
INTO #Details   
FROM [WDFinDataMart].[sec].[factJournalLine] fJL  
INNER JOIN WDFinDataMart.sec.dimLedgerAccount dLA  
ON fJL.LedgerAccountSID = dLA.LedgerAccountSID  
AND JournalSourceSID <> 39  
INNER JOIN WDFinDataMart.sec.dimLedgerType dLT  
ON dLT.LedgerTypeSID = fJL.LedgerTypeSID  
INNER JOIN WDFinDataMart.sec.dimFiscalPeriod dFP  
ON fJL.FiscalPeriodSID = dFP.fiscalPeriodSid  
INNER JOIN WDFinDataMart.sec.dimResource dR  
ON fJL.ResourceSID=dR.ResourceSID  
INNER JOIN WDFinDataMart.sec.dimCostCenter dCC  
ON fJL.CostCenterSID=dCC.CostCenterSID  
INNER JOIN WDFinDataMart.sec.dimCompany dC  
ON fJL.CompanySID = dC.CompanySID  
INNER JOIN WDFinDataMart.sec.dimProgram dP  
ON fJL.ProgramSID=dP.ProgramSID  
INNER JOIN WDFinDataMart.sec.dimBalancingUnit dBU  
ON fJL.BalancingUnitSID=dBU.BalancingUnitSID  
INNER JOIN WDFinDataMart.sec.dimSpendCategory dSC  
ON fJL.SpendCategorySID=dSC.SpendCategorySID  
INNER JOIN WDFinDataMart.sec.dimRevenueCategory dRC  
ON fJL.RevenueCategorySID=dRC.RevenueCategorySID  
INNER JOIN WDFinDataMart.sec.dimFund dF  
ON fJL.FundSID=dF.FundSID  
INNER JOIN WDFinDataMart.sec.dimGrant dG  
ON fJL.GrantSID=dG.GrantSID  
INNER JOIN WDFinDataMart.sec.dimGift dGift  
ON fJL.GiftSID=dGift.GiftSID  
INNER JOIN [WDFinDataMart].[sec].[dimAppropriation] DA  
ON Fjl.AppropriationSID=DA.AppropriationSID  
INNER JOIN [WDFinDataMart].[sec].[dimObjectClass] DO  
ON FJL.ObjectClassSID=Do.ObjectClassSID  
INNER JOIN [WDFinDataMart].sec.[dimSponsor] DS  
ON FJL.SponsorSID=DS.SponsorSID  
INNER JOIN [WDFinDataMart].[sec].[dimJournalSource] DJS  
ON FJL.JournalSourceSID=DJS.JournalSourceSID  
INNER JOIN [WDFinDataMart].[sec].[dimFunction] DFU  
ON FJL.FunctionSID=DFU.FunctionSID   
WHERE 1=1  
AND DLA.LedgerAccountID NOT IN ('89991','89992','89993','89999','89995','89996')  
AND LEFT(dla.ledgeraccountid,1) <> '9'  
AND FJL.JournalSourceSID <> 39  
AND fJL.FiscalYearName ='FY2024' 
/* BEGIN ACTIVE SECTION (comment inserted by DPA) */  
SELECT FiscalYearCode AS [Fiscal Year] , 
   PeriodCalendarMonthYear [ Fiscal Month] , 
   FiscalYearPeriod , 
   FiscalPeriodCode , 
   FiscalPeriodName , 
   CompanyName --LedgerAccount  
   , 
   AllLedgerAccountsLevel1Code , 
   AllLedgerAccountsLevel1Name , 
   AllLedgerAccountsLevel2Code , 
   AllLedgerAccountsLevel2Name , 
   AllLedgerAccountsLevel3Code , 
   AllLedgerAccountsLevel3Name , 
   AllLedgerAccountsLevel4Code , 
   AllLedgerAccountsLevel4Name , 
   AllLedgerAccountsLevel5Code , 
   AllLedgerAccountsLevel5Name  , 
   LedgerAccountType , 
   LedgerTypeName , 
   LedgerAccountID , 
   LedgerAccountName --Spend Category  
   , 
   AllSpendCategoriesLevel1Code , 
   AllSpendCategoriesLevel1Name , 
   AllSpendCategoriesLevel2Code , 
   AllSpendCategoriesLevel2Name , 
   AllSpendCategoriesLevel3Code , 
   AllSpendCategoriesLevel3Name , 
   SpendCategoryRefID , 
   SpendCategoryName --Revenue Category  
   , 
   AllRevenueCategoriesLevel1Code , 
   AllRevenueCategoriesLevel1Name , 
   AllRevenueCategoriesLevel2Code , 
   AllRevenueCategoriesLevel2Name , 
   AllRevenueCategoriesLevel3Code , 
   AllRevenueCategoriesLevel3Name , 
   RevenueCategoryRefID , 
   RevenueCategoryName --Resource  
   , 
   AllResourcesLevel1Code , 
   AllResourcesLevel1Name , 
   AllResourcesLevel2Code , 
   AllResourcesLevel2Name , 
   AllResourcesLevel3Code , 
   AllResourcesLevel3Name , 
   AllResourcesLevel4Code , 
   AllResourcesLevel4Name , 
   ResourceCode , 
   ResourceCodeName --Balancing Unit  
   , 
   AllBalancingUnitsLevel2Code , 
   AllBalancingUnitsLevel2Name , 
   BalancingUnitCode , 
   BalancingUnitName --Cost Center  
   , 
   AllCostCentersLevel1Code , 
   AllCostCentersLevel1Name , 
   AllCostCentersLevel2Code , 
   AllCostCentersLevel2Name , 
   AllCostCentersLevel3Code , 
   AllCostCentersLevel3Name , 
   AllCostCentersLevel4Code , 
   AllCostCentersLevel4Name , 
   AllCostCentersLevel5Code , 
   AllCostCentersLevel5Name , 
   AllCostCentersLevel6Code , 
   AllCostCentersLevel6Name , 
   AllCostCentersLevel7Code , 
   AllCostCentersLevel7Name , 
   AllCostCentersLevel8Code , 
   AllCostCentersLevel8Name , 
   AllCostCentersLevel9Code , 
   AllCostCentersLevel9Name , 
   CostCenterCode , 
   CostCenterName --Program  
   , 
   AllProgramsLevel1Code , 
   AllProgramsLevel1Name , 
   AllProgramsLevel2Code , 
   AllProgramsLevel2Name , 
   AllProgramsLevel3Code , 
   AllProgramsLevel3Name , 
   AllProgramsLevel4Code , 
   AllProgramsLevel4Name , 
   AllProgramsLevel5Code , 
   AllProgramsLevel5Name , 
   ProgramRefID , 
   ProgramName --Fund  
   , 
   AllFundsLevel2Code , 
   AllFundsLevel2Name , 
   AllFundsLevel3Code , 
   AllFundsLevel3Name , 
   AllFundsLevel4Code , 
   AllFundsLevel4Name , 
   FundRefID , 
   FundName --Grant  
   , 
   AllGrantsLevel2Code , 
   AllGrantsLevel2Name , 
   AllGrantsLevel3Code , 
   AllGrantsLevel3Name , 
   AllGrantsLevel4Code , 
   AllGrantsLevel4Name , 
   AllGrantsLevel5Code , 
   AllGrantsLevel5Name , 
   AllGrantsLevel6Code , 
   AllGrantsLevel6Name , 
   GrantRefID , 
   GrantName --Gift  
   , 
   GiftRefID , 
   GiftName -- Appropriation  
   ,  
   AllAppropriationsLevel1Code , 
   AllAppropriationsLevel1name , 
   AllAppropriationsLevel2code , 
   AllAppropriationsLevel2name , 
   AllAppropriationsLevel3code , 
   AllAppropriationsLevel3name , 
   AppropriationName -- object class  
   ,[ObjectClassRefID]  
   ,[ObjectClassName]  
   ,[ObjectClassCodeName]  
   -- Sponsor  
   ,[SponsorCodeName]  
   , [SponsorType]  
   -- Jornal Source  
   ,[JournalSourceName]  
   -- Function    
   ,[FunctionCode]  
   ,[FunctionName]  
   ,[FunctionCodeName]  
   ,[Function Level 1]  
   ,[Function Level 2]  
   ,[Function Level 3]  
   ,[Function Level 4]  
   ,[Function Level 5]  
   ,[Function Level 6]  
   --Flags and Measures  
   , 
   IsCommonBook , 
   IsFinancialReportingBook ,  
   Sum(ActualExpense) AS [Actual Expense]  ,  
   Sum( ActualRevenue) [Actual Revenue] --   ,Sum( Net_Position) Net_Position  
   , 
   Sum(Begning_balance)Begning_balance ,  
   Sum(ISNULL([Grant Income],0)) [Actual Program Income],  
   Sum(ISNULL(ActualExpense,0)) + Sum(Isnull(ActualRevenue,0)) + Sum(ISNULL([Grant Income],0))+ Sum 
   (ISnull(Begning_balance,0)) AS EndingBalance , 
   Sum(ISNULL(ActualExpense,0)) + Sum(Isnull(ActualRevenue,0)) + Sum(ISNULL([Grant Income],0)) AS  
   [Net change]  
INTO #Results  
FROM #Details  
WHERE ActualRevenue is not null  
OR Begning_balance is not null  
OR ActualExpense is not null  
OR [Grant Income] is not null  
GROUP BY FiscalYearCode , 
   FiscalPeriodCode , 
   PeriodCalendarMonthYear , 
   FiscalYearPeriod , 
   FiscalPeriodName , 
   CompanyName --LedgerAccount  
   , 
   AllLedgerAccountsLevel1Code , 
   AllLedgerAccountsLevel1Name , 
   AllLedgerAccountsLevel2Code , 
   AllLedgerAccountsLevel2Name , 
   AllLedgerAccountsLevel3Code , 
   AllLedgerAccountsLevel3Name , 
   AllLedgerAccountsLevel4Code , 
   AllLedgerAccountsLevel4Name , 
   AllLedgerAccountsLevel5Code , 
   AllLedgerAccountsLevel5Name  , 
   LedgerAccountType , 
   LedgerTypeName , 
   LedgerAccountID , 
   LedgerAccountName --Spend Category  
   , 
   AllSpendCategoriesLevel1Code , 
   AllSpendCategoriesLevel1Name , 
   AllSpendCategoriesLevel2Code , 
   AllSpendCategoriesLevel2Name , 
   AllSpendCategoriesLevel3Code , 
   AllSpendCategoriesLevel3Name , 
   SpendCategoryRefID , 
   SpendCategoryName --Revenue Category  
   , 
   AllRevenueCategoriesLevel1Code , 
   AllRevenueCategoriesLevel1Name , 
   AllRevenueCategoriesLevel2Code , 
   AllRevenueCategoriesLevel2Name , 
   AllRevenueCategoriesLevel3Code , 
   AllRevenueCategoriesLevel3Name , 
   RevenueCategoryRefID , 
   RevenueCategoryName --Resource  
   , 
   AllResourcesLevel1Code , 
   AllResourcesLevel1Name , 
   AllResourcesLevel2Code , 
   AllResourcesLevel2Name , 
   AllResourcesLevel3Code , 
   AllResourcesLevel3Name , 
   AllResourcesLevel4Code , 
   AllResourcesLevel4Name , 
   ResourceCode , 
   ResourceCodeName --Balancing Unit  
   , 
   AllBalancingUnitsLevel2Code , 
   AllBalancingUnitsLevel2Name , 
   BalancingUnitCode , 
   BalancingUnitName --Cost Center  
   , 
   AllCostCentersLevel1Code , 
   AllCostCentersLevel1Name , 
   AllCostCentersLevel2Code , 
   AllCostCentersLevel2Name , 
   AllCostCentersLevel3Code , 
   AllCostCentersLevel3Name , 
   AllCostCentersLevel4Code , 
   AllCostCentersLevel4Name , 
   AllCostCentersLevel5Code , 
   AllCostCentersLevel5Name , 
   AllCostCentersLevel6Code , 
   AllCostCentersLevel6Name , 
   AllCostCentersLevel7Code , 
   AllCostCentersLevel7Name , 
   AllCostCentersLevel8Code , 
   AllCostCentersLevel8Name , 
   AllCostCentersLevel9Code , 
   AllCostCentersLevel9Name , 
   CostCenterCode , 
   CostCenterName --Program  
   , 
   AllProgramsLevel1Code , 
   AllProgramsLevel1Name , 
   AllProgramsLevel2Code , 
   AllProgramsLevel2Name , 
   AllProgramsLevel3Code , 
   AllProgramsLevel3Name , 
   AllProgramsLevel4Code , 
   AllProgramsLevel4Name , 
   AllProgramsLevel5Code , 
   AllProgramsLevel5Name , 
   ProgramRefID , 
   ProgramName --Fund  
   , 
   AllFundsLevel2Code , 
   AllFundsLevel2Name , 
   AllFundsLevel3Code , 
   AllFundsLevel3Name , 
   AllFundsLevel4Code , 
   AllFundsLevel4Name , 
   FundRefID , 
   FundName --Grant  
   , 
   AllGrantsLevel2Code , 
   AllGrantsLevel2Name , 
   AllGrantsLevel3Code , 
   AllGrantsLevel3Name , 
   AllGrantsLevel4Code , 
   AllGrantsLevel4Name , 
   AllGrantsLevel5Code , 
   AllGrantsLevel5Name , 
   AllGrantsLevel6Code , 
   AllGrantsLevel6Name , 
   GrantRefID , 
   GrantName --Gift  
   , 
   GiftRefID , 
   GiftName -- Appropriation  
   ,  
   AllAppropriationsLevel1Code , 
   AllAppropriationsLevel1name , 
   AllAppropriationsLevel2code , 
   AllAppropriationsLevel2name , 
   AllAppropriationsLevel3code , 
   AllAppropriationsLevel3name , 
   AppropriationName -- object class  
   ,[ObjectClassRefID]  
   ,[ObjectClassName]  
   ,[ObjectClassCodeName]  
   -- Sponsor  
   ,[SponsorCodeName]  
   , [SponsorType]  
   -- Jornal Source  
   ,[JournalSourceName]  
   -- Function    
   ,[FunctionCode]  
   ,[FunctionName]  
   ,[FunctionCodeName]  
   ,[Function Level 1]  
   ,[Function Level 2]  
   ,[Function Level 3]  
   ,[Function Level 4]  
   ,[Function Level 5]  
   ,[Function Level 6]  
   --Flags and Measures  
   , 
   IsCommonBook , 
   IsFinancialReportingBook 
/* END ACTIVE SECTION (comment inserted by DPA) */  
SELECT *  
FROM #Results  
ORDER BY FiscalPeriodCode