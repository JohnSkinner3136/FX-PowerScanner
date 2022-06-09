/*
	Tools.mqh

	Copyright 2022, John Skinner

    Description:
    ============
    A common utility class
*/

class CCommon
{
private:
    bool    m_canTrade;
    bool    m_dllsAllowed;
    string  m_programName;

    
    void Init();
    void CanTrade(); 
    
public:
    CCommon();
    ~CCommon();

    bool    GetCanTrade()       {return m_canTrade;} 
    bool    GetNewBar(string symbol, ENUM_TIMEFRAMES period); 
    bool    GetDLLsAllowed()    {return m_dllsAllowed;}
    int     GetTimeframeMinutes(const string name);
    string  GetProgramName()    {return m_programName;}
    double  GetPointValue(const string symbol); 
    bool    HasExpired(const datetime expireDate);
    bool    ValidPair(const string pair);
};


CCommon::CCommon()
{
    Init();
}


CCommon::~CCommon()
{
}


void CCommon::Init()
{
    m_programName = MQLInfoString(MQL_PROGRAM_NAME);
    
    #ifdef __MQL5__
        m_dllsAllowed = (bool)MQL5InfoInteger(MQL5_DLLS_ALLOWED);
    #endif 

    #ifdef __MQL4__
        m_dllsAllowed = IsDllsAllowed();
    #endif

    CanTrade(); 
}   

int CCommon::GetTimeframeMinutes(const string name)
{
    if(name=="M1")  return 1;
    if(name=="M5")  return 5;
    if(name=="M15") return 15;
    if(name=="M30") return 30;
    if(name=="H1")  return 60;
    if(name=="H4")  return 240;
    if(name=="D1")  return 1440;
    if(name=="W1")  return 10080;
    if(name=="MN1") return 43200;
    
    return -1;
} 

// Calculate the point value for a symbol
double CCommon::GetPointValue(string symbol) 
{
    double tickSize         = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
    double tickValue        = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
    double point            = SymbolInfoDouble(symbol, SYMBOL_POINT);
    double ticksPerPoint    = tickSize/point;
    double pointValue       = tickValue/ticksPerPoint;
    
    return(pointValue);
}


// Check for a new bar
bool CCommon::GetNewBar(string symbol, ENUM_TIMEFRAMES period) 
{
    datetime currentBarTime = iTime(symbol, period, 0);
    static datetime	prevBarTime = currentBarTime;
	
    if(currentBarTime!=prevBarTime) 
    {
        prevBarTime = currentBarTime;
        return(true);
    }

	return(false);
}


// Is trading allowed by the terminal
void CCommon::CanTrade() 
{
    m_canTrade = (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && MQLInfoInteger(MQL_TRADE_ALLOWED) 
          && AccountInfoInteger(ACCOUNT_TRADE_EXPERT) && AccountInfoInteger(ACCOUNT_TRADE_ALLOWED));
}


bool CCommon::HasExpired(datetime expireDate)
{
    if(TimeCurrent() > expireDate)
    {
		Print(m_programName + " expired on "+TimeToString(expireDate));
        return true;
    }
    
    return(false);
}


bool CCommon::ValidPair(string pair)
{
/*
    if(iClose(pair, PERIOD_M1, 0) ==0) return true;
    if(iClose(pair, PERIOD_M5, 0) ==0) return true;
    if(iClose(pair, PERIOD_M15, 0) ==0) return true;
    if(iClose(pair, PERIOD_M30, 0) ==0) return true;
    if(iClose(pair, PERIOD_H1, 0) ==0) return true;
    if(iClose(pair, PERIOD_H4, 0) ==0) return true;
    if(iClose(pair, PERIOD_D1, 0) ==0) return true;
*/
    return false;
}


/*
void DetectPrefixSuffix(){
   for(int i=0;i<ArraySize(AllPairs);i++){
      if(StringFind(Symbol(),AllPairs[i],0)>=0){
         string SymbTemp=Symbol();
         int res=StringReplace(SymbTemp,AllPairs[i]," ");
         string PrSuTemp[];
         res=StringSplit(SymbTemp,StringGetCharacter(" ",0),PrSuTemp);
         CurrPrefix=PrSuTemp[0];
         CurrSuffix=PrSuTemp[1];
      }
   }
}


void AddSuffixPrefix(string prefix, string suffix, string &pairs[])
{
    for(int i=0; i<ArraySize(pairs); i++)
    {
        pairs[i] = prefix+pairs[i]+suffix;    
    }
}


void AddSuffixPrefix(string prefix, string suffix, string pairs)
{
    for(int i=0; i<ArraySize(pairs); i++)
    {
        pairs[i] = prefix+pairs[i]+suffix;    
    }
}
*/