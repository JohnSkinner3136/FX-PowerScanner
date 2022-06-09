/*
	FX PowerScanner.mqh
	Copyright 2022, John Skinner & Neil Prior
	https://FXCorrelator.com
*/

#import "MT4iConnect.dll"
   int DetachChart2(int a0, int a1);
#import

struct STimeframes
{
    string  Name;
    string  DisplayName;
    int     Column;
    int     Minutes;
};

#define APP_COPYRIGHT "https://www.fxcorrelator.com"
#define APP_LINK      "https://www.fxcorrelator.com"
#define APP_VERSION   ""
#define APP_DESCRIPTION "Copyright 2022, John Skinner and Neil Prior (NVP)\n\nThis indicator ranks all 28 pairs by our proprietary algorithmic momentum rating."
#define APP_COMMENT "Symbol Strengh Scanner"

#define DESCENDING_SORT 1000
#define ASCENDING_SORT  2000
#define SORT_DESCENDING 1
#define SORT_ASCENDING 0

#include <Mine\FX PowerScanner V2\Version 0.25\Include.mqh>

// Public Variable
bool MousePressed = false;
int SortOrder       = 1;
int SymbolCount     = 0;

// Public Objects
CCommon     Common;
CDisplay    Display;
CArrayObj   SymbolTable;
CArrayObj   SymbolDisplayTable;
CArrayObj   CurrencyWorkingTable;
CArrayObj   CurrencyDisplayTable;
CSkin       *Skin;

CFactoryRSI *FactoryMN1;
CFactoryRSI *FactoryW1;
CFactoryRSI *FactoryD1;
CFactoryRSI *FactoryH4;
CFactoryRSI *FactoryH1;
CFactoryRSI *FactoryM30;
CFactoryRSI *FactoryM15;
CFactoryRSI *FactoryM5;
CFactoryRSI *FactoryM1;
CFilters    Filters;

//int LinesTF = InpRSIPriTimeframe;
bool HistoricalOK=true;
string MissingHistoricalPair="";
int CurrenciesUsed=0;

// Public Constants
const int Divisor = 5;
const int SHOW_SYMBOL = 0;
const int SHOW_CURRENCY = 1;
const int ASCENDING  = 0;
const int DECENDING  = 1;

const string USD_NAME = "USD";
const string JPY_NAME = "JPY";
const string EUR_NAME = "EUR";
const string GBP_NAME = "GBP";
const string CAD_NAME = "CAD";
const string AUD_NAME = "AUD";
const string NZD_NAME = "NZD";
const string CHF_NAME = "CHF";

string AUDPairs[7];
string CADPairs[7];
string CHFPairs[7];
string EURPairs[7];
string GBPPairs[7];
string NZDPairs[7];
string JPYPairs[7];
string USDPairs[7];

int WhichTab = SHOW_SYMBOL;

bool UseMN1;
bool UseW1;
bool UseD1;
bool UseH4;
bool UseH1;
bool UseM30;
bool UseM15;
bool UseM5;
bool UseM1;

string  TimeframesUsed[];
string  ActiveSymbolSort="Symbols";
string  ActiveCurrencySort="Currency";
int     ActiveSymbolSortedColumn = -1;
int     ActiveCurrencySortedColumn = -1;
bool    Expired;

string SymbolSortColumn = "";

////////////////////////////////////////////////////
datetime ExpireDate = D'2022.07.02';
////////////////////////////////////////////////////


STimeframes Timeframes[];
int TimeframeCount = 0;

int OnInit() 
{
    WhichTab = (int)GlobalVariableGet(Common.GetProgramName()+"_WhichTab");    

    Expired=false;

    TimeframeCount = StringSplit(InpTimeframes, ',', TimeframesUsed);

    ArrayResize(Timeframes, TimeframeCount);
    
    for(int i=0; i<TimeframeCount;i++)
    {
        Timeframes[i].Name = TimeframesUsed[i];
        Timeframes[i].DisplayName = TimeframesUsed[i];
        Timeframes[i].Column = i+1;
        Timeframes[i].Minutes = Common.GetTimeframeMinutes(Timeframes[i].Name);
    }

    UseMN1=false;
    UseW1=false;
    UseD1=false;
    UseH4=false;
    UseH1=false;
    UseM30=false;
    UseM15=false;
    UseM5=false;
    UseM1=false;

    for(int i=0;i<TimeframeCount;i++)
    {
        if(Timeframes[i].Name=="MN1") UseMN1=true;   
        if(Timeframes[i].Name=="W1") UseW1=true;   
        if(Timeframes[i].Name=="D1") UseD1=true;   
        if(Timeframes[i].Name=="H4") UseH4=true;   
        if(Timeframes[i].Name=="H1") UseH1=true;   
        if(Timeframes[i].Name=="M30") UseM30=true;   
        if(Timeframes[i].Name=="M15") UseM15=true;   
        if(Timeframes[i].Name=="M5") UseM5=true;   
        if(Timeframes[i].Name=="M1") UseM1=true;   
    }

    int value = (int)GlobalVariableGet(Common.GetProgramName()+"_SortSymbolColumn");

    if(value == 0)
    {
        ActiveSymbolSort="Symbol";
        ActiveSymbolSortedColumn = 0;
    }
    if(value == 1)
    {
        ActiveSymbolSort="M1";
        ActiveSymbolSortedColumn = 9;
    }
    else if(value==5)
    {
        ActiveSymbolSort="M5";
        ActiveSymbolSortedColumn = 8;
    }
    else if(value==15)
    {
        ActiveSymbolSort="M15";
        ActiveSymbolSortedColumn = 7;
    }
    else if(value==30)
    {
        ActiveSymbolSort="M30";
        ActiveSymbolSortedColumn = 6;
    }
    else if(value==60)
    {
        ActiveSymbolSort="H1";
        ActiveSymbolSortedColumn = 5;
    }
    else if(value==240)
    {
        ActiveSymbolSort="H4";
        ActiveSymbolSortedColumn = 4;
    }
    else if(value==1440)
    {
        ActiveSymbolSort="D1";
        ActiveSymbolSortedColumn = 3;
    }
    else if(value==10080)
    {
        ActiveSymbolSort="w1";
        ActiveSymbolSortedColumn = 2;
    }
    else if(value==43200)
    {
        ActiveSymbolSort="MN1";
        ActiveSymbolSortedColumn = 1;
    }

    value = (int)GlobalVariableGet(Common.GetProgramName()+"_SortCurrencyColumn");

    if(value == 0)
    {
        ActiveCurrencySort="Currency";
        ActiveCurrencySortedColumn = 0;
    }
    if(value == 1)
    {
        ActiveCurrencySort="M1";
        ActiveCurrencySortedColumn = 9;
    }
    else if(value==5)
    {
        ActiveCurrencySort="M5";
        ActiveCurrencySortedColumn = 8;
    }
    else if(value==15)
    {
        ActiveCurrencySort="M15";
        ActiveCurrencySortedColumn = 7;
    }
    else if(value==30)
    {
        ActiveCurrencySort="M30";
        ActiveCurrencySortedColumn = 6;
    }
    else if(value==60)
    {
        ActiveCurrencySort="H1";
        ActiveCurrencySortedColumn = 5;
    }
    else if(value==240)
    {
        ActiveCurrencySort="H4";
        ActiveCurrencySortedColumn = 4;
    }
    else if(value==1440)
    {
        ActiveCurrencySort="D1";
        ActiveCurrencySortedColumn = 3;
    }
    else if(value==10080)
    {
        ActiveCurrencySort="w1";
        ActiveCurrencySortedColumn = 2;
    }
    else if(value==43200)
    {
        ActiveCurrencySort="MN1";
        ActiveCurrencySortedColumn = 1;
    }

 
    
    if(UseMN1)
        FactoryMN1 = new CFactoryRSI(PERIOD_MN1,InpRSIPriPeriodMN1,InpRSISecPeriodMN1,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneMN1,InpRSIPriLowerZoneMN1,InpRSISecUpperZoneMN1,InpRSISecLowerZoneMN1,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseW1)
        FactoryW1 = new CFactoryRSI(PERIOD_W1,InpRSIPriPeriodW1,InpRSISecPeriodW1,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneW1,InpRSIPriLowerZoneW1,InpRSISecUpperZoneW1,InpRSISecLowerZoneW1,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseD1)
        FactoryD1 = new CFactoryRSI(PERIOD_D1,InpRSIPriPeriodD1,InpRSISecPeriodD1,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneD1,InpRSIPriLowerZoneD1,InpRSISecUpperZoneD1,InpRSISecLowerZoneD1,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseH4)
        FactoryH4 = new CFactoryRSI(PERIOD_H4,InpRSIPriPeriodH4,InpRSISecPeriodH4,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneH4,InpRSIPriLowerZoneH4,InpRSISecUpperZoneH4,InpRSISecLowerZoneH4,InpAlignment,InpHideInactive,InpFontColour);

    if(UseH1)
        FactoryH1 = new CFactoryRSI(PERIOD_H1,InpRSIPriPeriodH1,InpRSISecPeriodH1,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneH1,InpRSIPriLowerZoneH1,InpRSISecUpperZoneH1,InpRSISecLowerZoneH1,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseM30)
        FactoryM30 = new CFactoryRSI(PERIOD_M30,InpRSIPriPeriodM30,InpRSISecPeriodM30,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneM30,InpRSIPriLowerZoneM30,InpRSISecUpperZoneM30,InpRSISecLowerZoneM30,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseM15)
        FactoryM15 = new CFactoryRSI(PERIOD_M15,InpRSIPriPeriodM15,InpRSISecPeriodM15,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneM15,InpRSIPriLowerZoneM15,InpRSISecUpperZoneM15,InpRSISecLowerZoneM15,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseM5)
        FactoryM5 = new CFactoryRSI(PERIOD_M5,InpRSIPriPeriodM5,InpRSISecPeriodM5,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneM5,InpRSIPriLowerZoneM5,InpRSISecUpperZoneM5,InpRSISecLowerZoneM5,InpAlignment,InpHideInactive,InpFontColour);
    
    if(UseM1)
        FactoryM1 = new CFactoryRSI(PERIOD_M1,InpRSIPriPeriodM1,InpRSISecPeriodM1,InpAppliedPrice,InpStartBar,Divisor,InpRSIPriUpperZoneM1,InpRSIPriLowerZoneM1,InpRSISecUpperZoneM1,InpRSISecLowerZoneM1,InpAlignment,InpHideInactive,InpFontColour);
    


    // Clear the tables in in case the init is run from a timeframe change
    CurrencyWorkingTable.Clear();
    SymbolTable.Clear();
    
    string skinPath = Common.GetProgramName()+"\\Skins\\";
    Skin = new CSkin(skinPath);
    
    Skin.SetStatusBarAreaColour(InpStatusBarAreaColour);     
    Skin.SetWindowBorderColour(InpWindowBorderColour);      
    Skin.SetWindowBgColour(InpWindowBgColour);         
    Skin.SetCellColourSell(InpCellColourSell);         
    Skin.SetTextColourSell(InpTextColourSell);         
    Skin.SetCellColourBuy(InpCellColourBuy);          
    Skin.SetTextColourBuy(InpTextColourBuy);          
    Skin.SetCellColourDefault(InpCellColourDefault);       
    Skin.SetTextColourDefault(InpTextColourDefault);       
    Skin.SettColHeadersColour(InpColHeadersColour);       
    Skin.SetColHeadersTextColour(InpColHeadersTextColour);    
    Skin.SetGridColour(InpGridColour);             
    Skin.SetGridBorderColour(InpGridBorderColour);       
    Skin.SetStatusBarBorderColour(InpStatusBarBorderColour);  
    Skin.SetSortedColumnHeader(InpSortedColumnHeader);      
    Skin.SetEmptyCellBackground(InpEmptyCellBGColour);      
    Skin.SetEmptyCellText(InpEmptyCellText);      


//    Skin.LoadFileNames();

    //PreChecks();
/*
    if(TimeCurrent() > ExpireDate)
    {
        Alert("This version of "+eaName+ " expired on "+TimeToString(ExpireDate)+". For an update go to www.FXCorrelator.com");  
    }
    else
        Print("This version of "+eaName+ " will expire on "+TimeToString(ExpireDate));    
*/    
    EventSetTimer(1);


  //  Skin.LoadSkinFiles();

    Filters.SetMinimumIndex(InpMinimumIndex);
    
    BuildCurrencyPairs(AUDPairs,"AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,EURAUD,GBPAUD"); 
    BuildCurrencyPairs(CADPairs,"AUDCAD,CADCHF,CADJPY,EURCAD,GBPCAD,NZDCAD,USDCAD"); 
    BuildCurrencyPairs(CHFPairs,"AUDCHF,CADCHF,CHFJPY,EURCHF,GBPCHF,NZDCHF,USDCHF"); 
    BuildCurrencyPairs(EURPairs,"EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD"); 
    BuildCurrencyPairs(GBPPairs,"EURGBP,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD"); 
    BuildCurrencyPairs(NZDPairs,"AUDNZD,EURNZD,GBPNZD,NZDCAD,NZDCHF,NZDJPY,NZDUSD"); 
    BuildCurrencyPairs(JPYPairs,"AUDJPY,CADJPY,CHFJPY,EURJPY,GBPJPY,NZDJPY,USDJPY"); 
    
    BuildCurrencyPairs(USDPairs,"AUDUSD,EURUSD,GBPUSD,NZDUSD,USDCAD,USDCHF,USDJPY"); 

    Display.OnInitEvent();

    //--- Set up the expert panel
    if(!Display.CreateExpertPanel())
    {
        ::Print(__FUNCTION__," > Failed to create graphical interface!");
        return(INIT_FAILED);
    }

    int currencyCount = CurrencyToArray(InpCurrencies);
    CurrenciesUsed = currencyCount;

    SymbolCount = CreateSymbols();

    #ifdef __MQL5__
    for(int i=0;i<SymbolCount;i++)
    {
        CSymbolRecord *symbolRecord = SymbolTable.At(i);

            symbolRecord.SetRSI_PriHandle(iRSI(symbolRecord.GetSymbol(), InpRSIPriTimeframe, PrimaryPeriod, InpRSIPriAppliedPrice));

            if(symbolRecord.GetRSI_PriHandle() == INVALID_HANDLE)
                Alert("Primary indicator failed to be created for "+ symbolRecord.GetSymbol());

            symbolRecord.SetRSI_SecHandle(iRSI(symbolRecord.GetSymbol(), InpRSIPriTimeframe, PrimaryPeriod, InpRSIPriAppliedPrice));

            if(symbolRecord.GetRSI_SecHandle() == INVALID_HANDLE)
                Alert("Secondary indicator failed to be created for "+ symbolRecord.GetSymbol());
    }
    #endif

    //--- Initialization successful
    return(INIT_SUCCEEDED);
}


void OnDeinit(const int reason) 
{
    Display.OnDeinitEvent(reason);
    GlobalVariableSet(Common.GetProgramName()+"_WhichTab", WhichTab);    


    delete Skin;
    delete FactoryMN1;
    delete FactoryW1;
    delete FactoryD1;
    delete FactoryH4;
    delete FactoryH1;
    delete FactoryM30;
    delete FactoryM15;
    delete FactoryM5;
    delete FactoryM1;

    GlobalVariableSet(Common.GetProgramName()+"_SortSymbolColumn", ConvertActiveSort());
    GlobalVariableSet(Common.GetProgramName()+"_SortCurrencyColumn", ConvertActiveSort());

    EventKillTimer();
}


void OnTick() 
{
	
}


void OnChartEvent(const int    id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam)
{
    Display.ChartEvent(id,lparam,dparam,sparam);

    if(id==CHARTEVENT_CUSTOM+ON_CLICK_LIST_ITEM)
    {
        if(MousePressed)
            return;
            
        MousePressed=true;

        string symbol;
        string timeframe;

        string tmp[];
        StringSplit(sparam,'_',tmp);




    symbol = Display.GetCellValue("Symbol",0, StrToInteger(tmp[1]));
    timeframe = Display.GetCellValue("Symbol",StrToInteger(tmp[0]), 0);

    if(timeframe=="MN1")
        timeframe="43200";
    if(timeframe=="W1")
        timeframe="10080";
    if(timeframe=="D1")
        timeframe="1440";
    if(timeframe=="H4")
        timeframe="240";
    if(timeframe=="H1")
        timeframe="60";
    if(timeframe=="M30")
        timeframe="30";
    if(timeframe=="M15")
        timeframe="15";
    if(timeframe=="M5")
        timeframe="5";
    if(timeframe=="M1")
        timeframe="1";

    LoopThroughCharts(symbol, (int)timeframe);


  //      Print(sparam);


        if(StringFind(sparam, ".Currency") > -1)
        {
            ActiveCurrencySort="Currency";
            ActiveCurrencySortedColumn = 0;
        }
        else if(StringFind(sparam, ".MN1") > -1)
        {
            ActiveCurrencySort="MN1";
            ActiveCurrencySortedColumn = GetColumnNumber("MN1");
        }
        else if(StringFind(sparam, ".W1") > -1)
        {
            ActiveCurrencySort="W1";
            ActiveCurrencySortedColumn = GetColumnNumber("W1");
        }
        else if(StringFind(sparam, ".D1") > -1)
        {
            ActiveCurrencySort="D1";
            ActiveCurrencySortedColumn = GetColumnNumber("D1");
        }
        else if(StringFind(sparam, ".H4") > -1)
        {
            ActiveCurrencySort="H4";
            ActiveCurrencySortedColumn = GetColumnNumber("H4");
        }
        else if(StringFind(sparam, ".H1") > -1)
        {
            ActiveCurrencySort="H1";
            ActiveCurrencySortedColumn = GetColumnNumber("H1");
        }
        else if(StringFind(sparam, ".M30") > -1)
        {
            ActiveCurrencySort="M30";
            ActiveCurrencySortedColumn = GetColumnNumber("M30");
        }
        else if(StringFind(sparam, ".M15") > -1)
        {
            ActiveCurrencySort="M15";
            ActiveCurrencySortedColumn = GetColumnNumber("M15");
        }
        else if(StringFind(sparam, ".M5") > -1)
        {
            ActiveCurrencySort="M5";
            ActiveCurrencySortedColumn = GetColumnNumber("M5");
        }
        else if(StringFind(sparam, ".M1") > -1)
        {
            ActiveCurrencySort="M1";
            ActiveCurrencySortedColumn = GetColumnNumber("M1");
        }

        if(StringFind(sparam, "Symbol") > -1)
        {
            ActiveSymbolSort="Symbol";
            ActiveSymbolSortedColumn = 0;
        }
        else if(StringFind(sparam, "MN1.") > -1)
        {
            ActiveSymbolSort="MN1";
            ActiveSymbolSortedColumn = GetColumnNumber("MN1");
        }
        else if(StringFind(sparam, "W1.") > -1)
        {
            ActiveSymbolSort="W1";
            ActiveSymbolSortedColumn = GetColumnNumber("W1");
        }
        else if(StringFind(sparam, "D1.") > -1)
        {
            ActiveSymbolSort="D1";
            ActiveSymbolSortedColumn = GetColumnNumber("D1");
        }
        else if(StringFind(sparam, "H4.") > -1)
        {
            ActiveSymbolSort="H4";
            ActiveSymbolSortedColumn = GetColumnNumber("H4");
        }

        if(StringFind(sparam, "H1.") > -1)
        {
            ActiveSymbolSort="H1";
            ActiveSymbolSortedColumn = GetColumnNumber("H1");
        }
        else if(StringFind(sparam, "M30.") > -1)
        {
            ActiveSymbolSort="M30";
            ActiveSymbolSortedColumn = GetColumnNumber("M30");
        }
        else if(StringFind(sparam, "M15.") > -1)
        {
            ActiveSymbolSort="M15";
            ActiveSymbolSortedColumn = GetColumnNumber("M15");
        }
        else if(StringFind(sparam, "M5.") > -1)
        {
            ActiveSymbolSort="M5";
            ActiveSymbolSortedColumn = GetColumnNumber("M5");
        }
        else if(StringFind(sparam, "M1.") > -1)
        {
            ActiveSymbolSort="M1";
            ActiveSymbolSortedColumn = GetColumnNumber("M1");
        }

        SortCurrencies(ActiveCurrencySort);        
        SortSymbols(ActiveSymbolSort);        

/*
        if(StringFind(sparam, "Index") > -1)
        {
            if(SortOrder == ASCENDING_SORT)
                SortOrder = DESCENDING_SORT;
            else        
                SortOrder = ASCENDING_SORT;
        }   
*/
    }    

}


void OnTimer()
{
    MousePressed = false;
    Main();
}


void OnTrade(void)
{
}


void Main()
{
    if(TimeCurrent() > ExpireDate)
    {
        Print("This version of "+MQLInfoString(MQL_PROGRAM_NAME)+ " expired on "+TimeToString(ExpireDate)+". For an update go to www.FXCorrelator.com");  
        Expired=true;
        return;
    }

    ProcessFactory();
    BuildRSIRanking();
    
    RankSymbols();

    for(int i=0; i<SymbolTable.Total(); i++)
    {
        CSymbolRecord *symbolRecord = SymbolTable.At(i);
        Filters.ProcessFilters(symbolRecord);
    }

    SortSymbols(ActiveSymbolSort);    
    Display.UpdateSymbolGrid();

    BuildCSIRanking();
    
    CurrencyDisplayTable.Clear();
    for(int i=0; i<CurrencyWorkingTable.Total(); i++)
    {
        CCurrencyRecord *currencyRecord = CurrencyWorkingTable.At(i);
        CCurrencyRecord *ToRecord = new CCurrencyRecord(currencyRecord.GetName());
        CopyObj2(currencyRecord, ToRecord);

        CurrencyDisplayTable.Add(ToRecord);
    }
    
    SortCurrencies(ActiveCurrencySort);
    Display.UpdateCurrencyGrid();
}


//+-------------------------------------------------------------------------------------------------------------------------+
//| Description : Split the comma delimeted country currencies into an array                                                |
//|                                                                                                                         |
//| Parameters  : currencies - A structure array to store the country currencies in                                         |
//|                                                                                                                         |
//| Returns     : The number of array elements created                                                                      |
//+-------------------------------------------------------------------------------------------------------------------------+
int CurrencyToArray(string currencyList)
{
    string tmp;
    string tmpArray[];

    if(currencyList == "")
        tmp = StringSubstr(Symbol(),0,3) + "," + StringSubstr(Symbol(),3,3);
    else
        tmp = currencyList;

    StringToUpper(tmp);

    int count = StringSplit(tmp,',',tmpArray);

    for(int i=0; i<count; i++)
    {
        CurrencyWorkingTable.Add(new CCurrencyRecord(tmpArray[i]));
    }

    return count;
}


//+-------------------------------------------------------------------------------------------------------------------------+
//| Description : loop through the entered country currencies and combine them to make valid symbols                        |
//|                                                                                                                         |
//| Parameters  : currencies - An array thatcontains the country currencies                                                 |
//|             : symbols    - An array of symbol structures to store information on a symbol                               |
//|                                                                                                                         |
//| Returns     : The number of symols created                                                                              |
//+-------------------------------------------------------------------------------------------------------------------------+
int CreateSymbols()
{
    int currencyCount = CurrencyWorkingTable.Total();
    int symbolCount = 0;

    for(int i=0; i<currencyCount; i++)
    {
        CCurrencyRecord *currencyRecord1 = CurrencyWorkingTable.At(i);

        for(int j=0; j<currencyCount; j++)
        {
            CCurrencyRecord *currencyRecord2 = CurrencyWorkingTable.At(j);
       
            string symbol = "";
            if(i==j)
                continue;

            symbol = InpSymbolPrefix+currencyRecord1.GetName()+currencyRecord2.GetName()+InpSymbolSuffix;

            if(iClose(symbol, PERIOD_D1, 0) ==0)
                continue;

            CSymbolRecord *record = new CSymbolRecord(symbol);
            record.SetBaseName(StringSubstr(symbol,0,3));
            record.SetQuoteName(StringSubstr(symbol,3));
            record.SetDisplayeName(currencyRecord1.GetName()+currencyRecord2.GetName());
//            record.SetCellColourDefault(InpCellColour);
            SymbolTable.Add(record);

            symbolCount++;
        }
    }

    return symbolCount;
}


void ProcessFactory()
{
    for(int i=0; i<SymbolCount; i++)
    {
        CSymbolRecord *symbolRecord = SymbolTable.At(i);

        if(UseMN1)  
        {
            FactoryMN1.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryMN1(FactoryMN1.GetPrimary());
            symbolRecord.SetSecondaryMN1(FactoryMN1.GetSecondary());
            symbolRecord.SetCellColourMN1(FactoryMN1.GetCellColour());
            symbolRecord.SetTextColourMN1(FactoryMN1.GetTextColour());
        }
        
        if(UseW1)   
        {
            FactoryW1.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryW1(FactoryW1.GetPrimary());
            symbolRecord.SetSecondaryW1(FactoryW1.GetSecondary());
            symbolRecord.SetCellColourW1(FactoryW1.GetCellColour());
            symbolRecord.SetTextColourW1(FactoryW1.GetTextColour());
        }
        
        if(UseD1)   
        {
            FactoryD1.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryD1(FactoryD1.GetPrimary());
            symbolRecord.SetSecondaryD1(FactoryD1.GetSecondary());
            symbolRecord.SetCellColourD1(FactoryD1.GetCellColour());
            symbolRecord.SetTextColourD1(FactoryD1.GetTextColour());
        }
        if(UseH4)   
        {
            FactoryH4.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryH4(FactoryH4.GetPrimary());
            symbolRecord.SetSecondaryH4(FactoryH4.GetSecondary());
            symbolRecord.SetCellColourH4(FactoryH4.GetCellColour());
            symbolRecord.SetTextColourH4(FactoryH4.GetTextColour());
        }
        if(UseH1)   
        {
            FactoryH1.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryH1(FactoryH1.GetPrimary());
            symbolRecord.SetSecondaryH1(FactoryH1.GetSecondary());
            symbolRecord.SetCellColourH1(FactoryH1.GetCellColour());
            symbolRecord.SetTextColourH1(FactoryH1.GetTextColour());
        }
        
        if(UseM30)  
        {
            FactoryM30.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryM30(FactoryM30.GetPrimary());
            symbolRecord.SetSecondaryM30(FactoryM30.GetSecondary());
            symbolRecord.SetCellColourM30(FactoryM30.GetCellColour());
            symbolRecord.SetTextColourM30(FactoryM30.GetTextColour());
        }

        if(UseM15)
        {
            FactoryM15.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryM15(FactoryM15.GetPrimary());
            symbolRecord.SetSecondaryM15(FactoryM15.GetSecondary());
            symbolRecord.SetCellColourM15(FactoryM15.GetCellColour());
            symbolRecord.SetTextColourM15(FactoryM15.GetTextColour());
        }
        if(UseM5)   
        {
            FactoryM5.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryM5(FactoryM5.GetPrimary());
            symbolRecord.SetSecondaryM5(FactoryM5.GetSecondary());
            symbolRecord.SetCellColourM5(FactoryM5.GetCellColour());
            symbolRecord.SetTextColourM5(FactoryM5.GetTextColour());
       }
        if(UseM1)   
        {
            FactoryM1.ProcessRules(symbolRecord);
            symbolRecord.SetPrimaryM1(FactoryM1.GetPrimary());
            symbolRecord.SetSecondaryM1(FactoryM1.GetSecondary());
            symbolRecord.SetCellColourM1(FactoryM1.GetCellColour());
            symbolRecord.SetTextColourM1(FactoryM1.GetTextColour());
        }
    }
}


void BuildRSIRanking()
{
    int count = SymbolTable.Total();
    
    for(int i=0; i<count; i++)
    {
        CSymbolRecord *record = SymbolTable.At(i);

        if(record.GetBaseName() == USD_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(USD_NAME, USDPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(USD_NAME, USDPairs));
        }
                
        if(record.GetQuoteName() == USD_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(USD_NAME, USDPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(USD_NAME, USDPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(USD_NAME, USDPairs));
        }

        if(record.GetBaseName() == JPY_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(JPY_NAME, JPYPairs));
        }

        if(record.GetQuoteName() == JPY_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(JPY_NAME, JPYPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(JPY_NAME, JPYPairs));
        }

        if(record.GetBaseName() == EUR_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(EUR_NAME, EURPairs));
        }

        if(record.GetQuoteName() == EUR_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(EUR_NAME, EURPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(EUR_NAME, EURPairs));
        }
        
        if(record.GetBaseName() == GBP_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(GBP_NAME, GBPPairs));
        }

        if(record.GetQuoteName() == GBP_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(GBP_NAME, GBPPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(GBP_NAME, GBPPairs));
        }

        if(record.GetBaseName() == CAD_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(CAD_NAME, CADPairs));
        }

        if(record.GetQuoteName() == CAD_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(CAD_NAME, CADPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(CAD_NAME, CADPairs));
        }

        if(record.GetBaseName() == AUD_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(AUD_NAME, AUDPairs));
        }

        if(record.GetQuoteName() == AUD_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(AUD_NAME, AUDPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(AUD_NAME, AUDPairs));
        }

        if(record.GetBaseName() == NZD_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(NZD_NAME, NZDPairs));
        }

        if(record.GetQuoteName() == NZD_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(NZD_NAME, NZDPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(NZD_NAME, NZDPairs));
        }

        if(record.GetBaseName() == CHF_NAME)
        {
            if(UseMN1)  record.SetBaseValueMN1(FactoryMN1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseW1)   record.SetBaseValueW1(FactoryW1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseD1)   record.SetBaseValueD1(FactoryD1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseH4)   record.SetBaseValueH4(FactoryH4.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseH1)   record.SetBaseValueH1(FactoryH1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM30)  record.SetBaseValueM30(FactoryM30.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM15)  record.SetBaseValueM15(FactoryM15.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM5)   record.SetBaseValueM5(FactoryM5.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM1)   record.SetBaseValueM1(FactoryM1.GetTotalRSI(CHF_NAME, CHFPairs));
        }

        if(record.GetQuoteName() == CHF_NAME)
        {
            if(UseMN1)  record.SetQuoteValueMN1(FactoryMN1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseW1)   record.SetQuoteValueW1(FactoryW1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseD1)   record.SetQuoteValueD1(FactoryD1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseH4)   record.SetQuoteValueH4(FactoryH4.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseH1)   record.SetQuoteValueH1(FactoryH1.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM30)  record.SetQuoteValueM30(FactoryM30.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM15)  record.SetQuoteValueM15(FactoryM15.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM5)   record.SetQuoteValueM5(FactoryM5.GetTotalRSI(CHF_NAME, CHFPairs));
            if(UseM1)   record.SetQuoteValueM1(FactoryM1.GetTotalRSI(CHF_NAME, CHFPairs));
        }
    }

    for(int i=0; i<count; i++)
    {
        CSymbolRecord *record = SymbolTable.At(i);
     
        if(UseMN1)  
        {            
            record.SetIndexMN1(NormalizeDouble(MathAbs(record.GetBaseValueMN1() - record.GetQuoteValueMN1()), 2));
            record.SetColumnMN1(GetColumnNumber("MN1"));
        }

        if(UseW1)   
        {
            record.SetIndexW1(NormalizeDouble(MathAbs(record.GetBaseValueW1() - record.GetQuoteValueW1()), 2));
            record.SetColumnW1(GetColumnNumber("W1"));
        }
        
        if(UseD1)   
        {
            record.SetIndexD1(NormalizeDouble(MathAbs(record.GetBaseValueD1() - record.GetQuoteValueD1()), 2));
            record.SetColumnD1(GetColumnNumber("D1"));
        }
        
        if(UseH4)   
        {
            record.SetIndexH4(NormalizeDouble(MathAbs(record.GetBaseValueH4() - record.GetQuoteValueH4()), 2));
            record.SetColumnH4(GetColumnNumber("H4"));
        }
        
        if(UseH1)   
        {
            record.SetIndexH1(NormalizeDouble(MathAbs(record.GetBaseValueH1() - record.GetQuoteValueH1()), 2));
            record.SetColumnH1(GetColumnNumber("H1"));
        }
                
        if(UseM30)  
        {
            record.SetIndexM30(NormalizeDouble(MathAbs(record.GetBaseValueM30() - record.GetQuoteValueM30()), 2));
            record.SetColumnM30(GetColumnNumber("M30"));
        }
                
        if(UseM15)  
        {
            record.SetIndexM15(NormalizeDouble(MathAbs(record.GetBaseValueM15() - record.GetQuoteValueM15()), 2));
            record.SetColumnM15(GetColumnNumber("M15"));
        }        
        
        if(UseM5)   
        {
            record.SetIndexM5(NormalizeDouble(MathAbs(record.GetBaseValueM5() - record.GetQuoteValueM5()), 2));
            record.SetColumnM5(GetColumnNumber("M5"));
        }
                
        if(UseM1)   
        {
            record.SetIndexM1(NormalizeDouble(MathAbs(record.GetBaseValueM1() - record.GetQuoteValueM1()), 2));
            record.SetColumnM1(GetColumnNumber("M1"));
        }
    }
}


int GetColumnNumber(const string tf)
{
    for(int i=0; i<TimeframeCount;i++)
    {
//    Alert(tf);
        if(tf==Timeframes[i].Name)
            return Timeframes[i].Column;               
    }

    return -1;
}


void BuildCSIRanking()
{
    int count = CurrencyWorkingTable.Total();
    
    for(int i=0; i<count; i++)
    {
        CCurrencyRecord *currencyRecord = CurrencyWorkingTable.At(i);

        if(currencyRecord.GetName() == USD_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(USD_NAME, USDPairs));  
        }
        
        if(currencyRecord.GetName() == JPY_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(JPY_NAME, JPYPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(JPY_NAME, JPYPairs));  
        }
        
        if(currencyRecord.GetName() == EUR_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(EUR_NAME, EURPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(EUR_NAME, EURPairs));  
        }
        
        if(currencyRecord.GetName() == GBP_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(GBP_NAME, GBPPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(GBP_NAME, GBPPairs));  
        }
        
        if(currencyRecord.GetName() == CAD_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(CAD_NAME, CADPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(CAD_NAME, CADPairs));  
        }
        
        if(currencyRecord.GetName() == AUD_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(AUD_NAME, AUDPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(AUD_NAME, AUDPairs));  
        }
        
        if(currencyRecord.GetName() == NZD_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(NZD_NAME, NZDPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(NZD_NAME, NZDPairs));  
        }
        
        if(currencyRecord.GetName() == USD_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(USD_NAME, USDPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(USD_NAME, USDPairs));  
        }
        
        if(currencyRecord.GetName() == CHF_NAME)
        {
            if(UseMN1)  currencyRecord.SetValueMN1(FactoryMN1.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseW1)   currencyRecord.SetValueW1(FactoryW1.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseD1)   currencyRecord.SetValueD1(FactoryD1.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseH4)   currencyRecord.SetValueH4(FactoryH4.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseH1)   currencyRecord.SetValueH1(FactoryH1.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseM30)  currencyRecord.SetValueM30(FactoryM30.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseM15)  currencyRecord.SetValueM15(FactoryM15.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseM5)   currencyRecord.SetValueM5(FactoryM5.RSICurrencyTot(CHF_NAME, CHFPairs));  
            if(UseM1)   currencyRecord.SetValueM1(FactoryM1.RSICurrencyTot(CHF_NAME, CHFPairs));  
        }
    }
    
    for(int i=0; i<8;i++)
    {
        CCurrencyRecord *currencyRecord = CurrencyWorkingTable.At(i);
        
        if(UseM1)
        {
            currencyRecord.SetCellColourM1(Skin.GetCellColourDefault());
            currencyRecord.SetTextColourM1(Skin.GetTextColourDefault());

            if(currencyRecord.GetValueM1() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourM1(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourM1(Skin.GetTextColourBuy());
            }    
            
            if(currencyRecord.GetValueM1() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourM1(Skin.GetCellColourSell());
                currencyRecord.SetTextColourM1(Skin.GetTextColourSell());
            }
                            
            currencyRecord.SetIndexM1(MathAbs(currencyRecord.GetValueM1()));
            currencyRecord.SetColumnM1(GetColumnNumber("M1"));

        }

        if(UseM5)
        {
            if(currencyRecord.GetValueM5() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourM5(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourM5(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueM5() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourM5(Skin.GetCellColourSell());
                currencyRecord.SetTextColourM5(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexM5(MathAbs(currencyRecord.GetValueM5()));
            currencyRecord.SetColumnM5(GetColumnNumber("M5"));
        }

        if(UseM15)
        {
            if(currencyRecord.GetValueM15() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourM15(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourM15(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueM15() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourM15(Skin.GetCellColourSell());
                currencyRecord.SetTextColourM15(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexM15(MathAbs(currencyRecord.GetValueM15()));
            currencyRecord.SetColumnM15(GetColumnNumber("M15"));
        }

        if(UseM30)
        {
            if(currencyRecord.GetValueM30() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourM30(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourM30(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueM30() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourM30(Skin.GetCellColourSell());
                currencyRecord.SetTextColourM30(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexM30(MathAbs(currencyRecord.GetValueM30()));
            currencyRecord.SetColumnM30(GetColumnNumber("M30"));
        }

        if(UseH1)
        {
            if(currencyRecord.GetValueH1() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourH1(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourH1(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueH1() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourH1(Skin.GetCellColourSell());
                currencyRecord.SetTextColourH1(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexH1(MathAbs(currencyRecord.GetValueH1()));
            currencyRecord.SetColumnH1(GetColumnNumber("H1"));
        }

        if(UseH4)
        {
            if(currencyRecord.GetValueH4() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourH4(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourH4(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueH4() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourH4(Skin.GetCellColourSell());
                currencyRecord.SetTextColourH4(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexH4(MathAbs(currencyRecord.GetValueH4()));
            currencyRecord.SetColumnH4(GetColumnNumber("H4"));
        }

        if(UseD1)
        {
            if(currencyRecord.GetValueD1() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourD1(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourD1(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueD1() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourD1(Skin.GetCellColourSell());
                currencyRecord.SetTextColourD1(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexD1(MathAbs(currencyRecord.GetValueD1()));
            currencyRecord.SetColumnD1(GetColumnNumber("D1"));
        }

        if(UseW1)
        {
            if(currencyRecord.GetValueW1() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourW1(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourW1(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueW1() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourW1(Skin.GetCellColourSell());
                currencyRecord.SetTextColourW1(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexW1(MathAbs(currencyRecord.GetValueW1()));
            currencyRecord.SetColumnW1(GetColumnNumber("W1"));
        }

        if(UseMN1)
        {
            if(currencyRecord.GetValueMN1() > InpCSIUppeZone)
            {
                currencyRecord.SetCellColourMN1(Skin.GetCellColourBuy());
                currencyRecord.SetTextColourMN1(Skin.GetTextColourBuy());
            }    
    
            if(currencyRecord.GetValueMN1() < InpCSILowerZone)
            {
                currencyRecord.SetCellColourMN1(Skin.GetCellColourSell());
                currencyRecord.SetTextColourMN1(Skin.GetTextColourSell());
            }    
                
            currencyRecord.SetIndexMN1(MathAbs(currencyRecord.GetValueMN1()));
            currencyRecord.SetColumnMN1(GetColumnNumber("MN1"));
        }
    }

}


void BuildCurrencyPairs(string &currency[], string pairs)
{
    int count = ArraySize(currency);

    string tmp[];
    int aa=StringSplit(pairs, ',', tmp);

    for(int i=0; i<count;i++)
        currency[i]=tmp[i]+InpSymbolSuffix;
}


void CopyObj(CSymbolRecord &copyFrom, CSymbolRecord &copyTo)
{
    copyTo.SetCellColourDefault(copyFrom.GetCellColourDefault());   
    copyTo.SetTextColourDefault(copyFrom.GetTextColourDefault());   

    copyTo.SetOrderIndexMN1(copyFrom.GetOrderIndexMN1());   
    copyTo.SetIndexMN1(copyFrom.GetIndexMN1());   
    copyTo.SetCellColourMN1(copyFrom.GetCellColourMN1());   
    copyTo.SetTextColourMN1(copyFrom.GetTextColourMN1());   

    copyTo.SetOrderIndexW1(copyFrom.GetOrderIndexW1());   
    copyTo.SetIndexW1(copyFrom.GetIndexW1());   
    copyTo.SetCellColourW1(copyFrom.GetCellColourW1());   
    copyTo.SetTextColourW1(copyFrom.GetTextColourW1());   

    copyTo.SetOrderIndexD1(copyFrom.GetOrderIndexD1());   
    copyTo.SetIndexD1(copyFrom.GetIndexD1());   
    copyTo.SetCellColourD1(copyFrom.GetCellColourD1());   
    copyTo.SetTextColourD1(copyFrom.GetTextColourD1());   

    copyTo.SetOrderIndexH4(copyFrom.GetOrderIndexH4());   
    copyTo.SetIndexH4(copyFrom.GetIndexH4());   
    copyTo.SetCellColourH4(copyFrom.GetCellColourH4());   
    copyTo.SetTextColourH4(copyFrom.GetTextColourH4());   

    copyTo.SetOrderIndexH1(copyFrom.GetOrderIndexH1());   
    copyTo.SetIndexH1(copyFrom.GetIndexH1());   
    copyTo.SetCellColourH1(copyFrom.GetCellColourH1());   
    copyTo.SetTextColourH1(copyFrom.GetTextColourH1());   

    copyTo.SetOrderIndexM30(copyFrom.GetOrderIndexM30());   
    copyTo.SetIndexM30(copyFrom.GetIndexM30());   
    copyTo.SetCellColourM30(copyFrom.GetCellColourM30());   
    copyTo.SetTextColourM30(copyFrom.GetTextColourM30());   

    copyTo.SetOrderIndexM15(copyFrom.GetOrderIndexM15());   
    copyTo.SetIndexM15(copyFrom.GetIndexM15());   
    copyTo.SetCellColourM15(copyFrom.GetCellColourM15());   
    copyTo.SetTextColourM15(copyFrom.GetTextColourM15());   

    copyTo.SetOrderIndexM5(copyFrom.GetOrderIndexM5());   
    copyTo.SetIndexM5(copyFrom.GetIndexM5());   
    copyTo.SetCellColourM5(copyFrom.GetCellColourM5());   
    copyTo.SetTextColourM5(copyFrom.GetTextColourM5());   

    copyTo.SetOrderIndexM1(copyFrom.GetOrderIndexM1());   
    copyTo.SetIndexM1(copyFrom.GetIndexM1());   
    copyTo.SetCellColourM1(copyFrom.GetCellColourM1());   
    copyTo.SetTextColourM1(copyFrom.GetTextColourM1());   
}

void CopyObj2(CCurrencyRecord &copyFrom, CCurrencyRecord &copyTo)
{
    copyTo.SetIndexMN1(copyFrom.GetIndexMN1());   
    copyTo.SetCellColourMN1(copyFrom.GetCellColourMN1());
    copyTo.SetTextColourMN1(copyFrom.GetTextColourMN1());
    copyTo.SetColumnMN1(copyFrom.GetColumnMN1());

    copyTo.SetIndexW1(copyFrom.GetIndexW1());   
    copyTo.SetCellColourW1(copyFrom.GetCellColourW1());
    copyTo.SetTextColourW1(copyFrom.GetTextColourW1());
    copyTo.SetColumnW1(copyFrom.GetColumnW1());

    copyTo.SetIndexD1(copyFrom.GetIndexD1());   
    copyTo.SetCellColourD1(copyFrom.GetCellColourD1());
    copyTo.SetTextColourD1(copyFrom.GetTextColourD1());
    copyTo.SetColumnD1(copyFrom.GetColumnD1());

    copyTo.SetIndexH4(copyFrom.GetIndexH4());   
    copyTo.SetCellColourH4(copyFrom.GetCellColourH4());
    copyTo.SetTextColourH4(copyFrom.GetTextColourH4());
    copyTo.SetColumnH4(copyFrom.GetColumnH4());

    copyTo.SetIndexH1(copyFrom.GetIndexH1());   
    copyTo.SetCellColourH1(copyFrom.GetCellColourH1());
    copyTo.SetTextColourH1(copyFrom.GetTextColourH1());
    copyTo.SetColumnH1(copyFrom.GetColumnH1());

    copyTo.SetIndexM30(copyFrom.GetIndexM30());   
    copyTo.SetCellColourM30(copyFrom.GetCellColourM30());
    copyTo.SetTextColourM30(copyFrom.GetTextColourM30());
    copyTo.SetColumnM30(copyFrom.GetColumnM30());

    copyTo.SetIndexM15(copyFrom.GetIndexM15());   
    copyTo.SetCellColourM15(copyFrom.GetCellColourM15());
    copyTo.SetTextColourM15(copyFrom.GetTextColourM15());
    copyTo.SetColumnM15(copyFrom.GetColumnM15());

    copyTo.SetIndexM5(copyFrom.GetIndexM5());   
    copyTo.SetCellColourM5(copyFrom.GetCellColourM5());
    copyTo.SetTextColourM5(copyFrom.GetTextColourM5());
    copyTo.SetColumnM5(copyFrom.GetColumnM5());

    copyTo.SetIndexM1(copyFrom.GetIndexM1());   
    copyTo.SetCellColourM1(copyFrom.GetCellColourM1());
    copyTo.SetTextColourM1(copyFrom.GetTextColourM1());
    copyTo.SetColumnM1(copyFrom.GetColumnM1());
}


void RankSymbols()
{
    if(UseM1)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM1);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexM1(i+1);
        }
    }

    if(UseM5)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM5);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexM5(i+1);
        }
    }

    if(UseM15)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM15);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexM15(i+1);
        }
    }

    if(UseM30)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM30);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexM30(i+1);
        }
    }

    if(UseH1)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXH1);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexH1(i+1);
        }
    }

    if(UseH4)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXH4);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexH4(i+1);
        }
    }

    if(UseD1)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXD1);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexD1(i+1);
        }
    }

    if(UseW1)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXW1);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexW1(i+1);
        }
    }

    if(UseMN1)
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXMN1);

        for(int i=SymbolTable.Total()-1;i>=0;i--)
        {
            CSymbolRecord *record = SymbolTable.At(i);
            record.SetOrderIndexMN1(i+1);
        }
    }
}

void SortCurrencies(string column)
{
    if(column=="Currency")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_NAME);
    }

    if(column=="M1")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM1);
    }

    if(column == "M5")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM5);
    }

    if(column == "M15")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM15);
    }

    if(column == "M30")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM30);
    }

    if(column == "H1")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXH1);
    }

    if(column == "H4")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXH4);
    }

    if(column == "D1")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXD1);
    }

    if(column == "W1")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXW1);
    }

    if(column == "MN1")
    {
        CurrencyDisplayTable.Sort(DESCENDING_SORT+SORT_BY_INDEXMN1);
    }

    Display.UpdateCurrencyGrid();
}


void SortSymbols(string column)
{
    if(column=="Symbol")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_NAME);
    }

    if(column=="M1")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM1);
    }

    if(column == "M5")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM5);
    }

    if(column == "M15")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM15);
    }

    if(column == "M30")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXM30);
    }

    if(column == "H1")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXH1);
    }

    if(column == "H4")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXH4);
    }

    if(column == "D1")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXD1);
    }

    if(column == "W1")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXW1);
    }

    if(column == "MN1")
    {
        SymbolTable.Sort(DESCENDING_SORT+SORT_BY_INDEXMN1);
    }

    Display.UpdateSymbolGrid();
}


int ConvertActiveSort()
{
    if(ActiveSymbolSort=="MN1")
        return 43200;
    else if(ActiveSymbolSort=="W1")
        return 10080;
    else if(ActiveSymbolSort=="D1")
        return 1440;
    else if(ActiveSymbolSort=="H4")
        return 240;
    else if(ActiveSymbolSort=="H1")
        return 60;
    else if(ActiveSymbolSort=="M30")
        return 30;
    else if(ActiveSymbolSort=="M15")
        return 15;
    else if(ActiveSymbolSort=="M5")
        return 5;
    else if(ActiveSymbolSort=="M1")
        return 1;
    else if(ActiveSymbolSort=="Symbol")
        return 0;


    return -1;
}

void LoopThroughCharts(string symbol, int timeframe)
{
    long currChart=-1;
    long prevChart=ChartFirst();
    int i=0;
    int limit=100;

    while(i<limit)// We have certainly not more than 100 open charts
    {
        if(ChartPeriod(currChart) == timeframe && ChartSymbol(currChart)==symbol)
        {
            ResetLastError();
            //--- show the chart on top of all others
    
            if(!ChartSetInteger(currChart,CHART_BRING_TO_TOP,0,true))
            {
                //--- display the error message in Experts journal
                Print(__FUNCTION__+", Error Code = ",GetLastError());
            }
        
            break;
        }
    
        currChart=ChartNext(prevChart); // Get the new chart ID by using the previous chart ID
        if(currChart<0) 
        {
            // open a new chart
            long id = ChartOpen(symbol, timeframe);
    
            if(InpTemplate!="")
            {
                //--- apply template
                if(ChartApplyTemplate(id,InpTemplate+".tpl"))
                {
                    Print("The template "+InpTemplate+" applied successfully");
                }
                else
                    Print("Failed to apply "+InpTemplate+", error code ",GetLastError());
            }
    
            break;          // Have reached the end of the chart list
        }
     
        prevChart=currChart;// let's save the current chart ID for the ChartNext()
        i++;// Do not forget to increase the counter
    }
}
