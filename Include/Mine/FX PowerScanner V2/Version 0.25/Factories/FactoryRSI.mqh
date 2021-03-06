/*
	FactoryRSI.mqh

	Copyright 2022, John Skinner & Neil Prior
	https://www.FXCorrelator.com

    Description:
    ============
    A class to hold the RSI functions used by FXPowerScanner
    
    Using factories allows to swap different calculation methods easier 

*/
#include "..\SymbolRecord.mqh"


class CFactoryRSI 
{
private:
    CSymbolRecord m_symbolRecord;
    double m_primary;
    double m_secondary;
    int m_timeframe;
    int m_primaryPeriod;
    int m_secondaryPeriod;
    ENUM_APPLIED_PRICE m_appliedPrice;
    int m_startBar;
    
    double m_primaryUpperZone;
    double m_primaryLowerZone;
    double m_secondaryUpperZone;
    double m_secondaryLowerZone;
    int m_alignment;
    bool m_hideInactive;
    color m_textColour;
    color m_cellColour;

    void CalculateSymbolRSI();
    void SetCellColours(CSymbolRecord &symbolRecord);    
    double  CalculatePrimary(CSymbolRecord &symbolRecord); 
    double  CalculateSecondary(CSymbolRecord &symbolRecord);

protected:
       
public:
    CFactoryRSI(int timeframe, 
    int primaryPeriod, 
    int secondaryPeriod, 
    ENUM_APPLIED_PRICE appliedPrice, 
    int startBar, 
    int divisor, 
    double primaryUpperZone,
    double primaryLowerZone,
    double secondaryUpperZone,
    double secondaryLowerZone,
    int alignment,
    bool hideInactive,
    color textColour);
    
    ~CFactoryRSI(void);
    double  GetTotalRSI(string currency, string& currencyPairs[]);
    void    ProcessRules(CSymbolRecord &symbolRecord);
    double  GetRanking(CSymbolRecord &symbolRecord);
    double  RSICurrencyTot(string Curr, string& pairs[]);
    color   GetCellColour() {return m_cellColour;}
    color   GetTextColour() {return m_textColour;}
    double  GetPrimary()    {return m_primary;}
    double  GetSecondary()    {return m_secondary;}
};


CFactoryRSI::CFactoryRSI(   int timeframe, 
                            int primaryPeriod, 
                            int secondaryPeriod, 
                            ENUM_APPLIED_PRICE appliedPrice, 
                            int startBar, 
                            int divisor, 
                            double primaryUpperZone,
                            double primaryLowerZone,
                            double secondaryUpperZone,
                            double secondaryLowerZone,
                            int alignment,
                            bool hideInactive,
                            color fontColour)

{
    m_timeframe          = timeframe;
    m_primaryPeriod      = MathRound(primaryPeriod / divisor);  
    m_secondaryPeriod    = MathRound(secondaryPeriod / divisor);  

//if(m_timeframe==H1)
//  Alert("aa "+appliedPrice);

    m_appliedPrice       = appliedPrice;
    m_startBar           = startBar;
    m_primaryUpperZone   = primaryUpperZone;
    m_primaryLowerZone   = primaryLowerZone;
    m_secondaryUpperZone = secondaryUpperZone;
    m_secondaryLowerZone = secondaryLowerZone;
    m_alignment          = alignment;    
    m_hideInactive       = hideInactive;
    m_textColour         = fontColour;
}


CFactoryRSI::~CFactoryRSI(void)
{
}


double CFactoryRSI::CalculatePrimary(CSymbolRecord &symbolRecord)
{                              
    #ifdef __MQL4__
        return NormalizeDouble(iRSI(symbolRecord.GetName(), m_timeframe, m_primaryPeriod, m_appliedPrice, m_startBar), 5);
    #endif 

    #ifdef __MQL5__
        int count = 0;
        double priBuffer[];

        ArraySetAsSeries(priBuffer, true);
        count = CopyBuffer(symbolRecord.GetRSI_PriHandle(), 0, m_startBar, 1, priBuffer);
        
        if(count >0)
            symbolRecord.SetPrimary(priBuffer[0]);
    #endif

    return 0;
}


double CFactoryRSI::CalculateSecondary(CSymbolRecord &symbolRecord)
{
    #ifdef __MQL4__
        return NormalizeDouble(iRSI(symbolRecord.GetName(), m_timeframe, m_secondaryPeriod, m_appliedPrice, m_startBar), 5);
    #endif 


    #ifdef __MQL5__
        int count = 0;
        double secBuffer[];

        ArraySetAsSeries(secBuffer, true);
        count = CopyBuffer(symbolRecord.GetRSI_SecHandle(), 0, m_startBar, 1, secBuffer);
        
        if(count >0)
            symbolRecord.SetSecondary(secBuffer[0]);
    #endif

    return 0;
}


double CFactoryRSI::GetTotalRSI(string currency, string& currencyPairs[])
{
    double total=0;

    for(int i=0;i<ArraySize(currencyPairs);i++)
    {
        if(currencyPairs[i]!=NULL)
        {
            int k=m_startBar;

            double value=iRSI(currencyPairs[i], m_timeframe, m_primaryPeriod, m_appliedPrice, k);

            if(value==0)
            {
                HistoricalOK=false;
                MissingHistoricalPair=currencyPairs[i];
                return 0;
            }
         
            if(StringFind(currencyPairs[i],currency,0)<3)
                total+=value/CurrenciesUsed;
            else
                total+=(100-value)/CurrenciesUsed;
        }
    }
   
    return NormalizeDouble(total, 5);
}


void CFactoryRSI::ProcessRules(CSymbolRecord &symbolRecord)
{
    m_primary = CalculatePrimary(symbolRecord);     
    m_secondary = CalculateSecondary(symbolRecord);
    SetCellColours(symbolRecord);
}


double CFactoryRSI::GetRanking(CSymbolRecord &symbolRecord)
{
    double value = 0;
    if(m_timeframe==PERIOD_MN1)    return MathAbs(symbolRecord.GetPrimaryMN1() - 50);
    if(m_timeframe==PERIOD_W1)     return MathAbs(symbolRecord.GetPrimaryW1() - 50);
    if(m_timeframe==PERIOD_D1)     return MathAbs(symbolRecord.GetPrimaryD1() - 50);
    if(m_timeframe==PERIOD_H4)     return MathAbs(symbolRecord.GetPrimaryH4() - 50);
    if(m_timeframe==PERIOD_H1)     return MathAbs(symbolRecord.GetPrimaryH1() - 50);
    if(m_timeframe==PERIOD_M30)    return MathAbs(symbolRecord.GetPrimaryM30() - 50);
    if(m_timeframe==PERIOD_M15)    return MathAbs(symbolRecord.GetPrimaryM15() - 50);
    if(m_timeframe==PERIOD_M5)     return MathAbs(symbolRecord.GetPrimaryM5() - 50);
    if(m_timeframe==PERIOD_M1)     return MathAbs(symbolRecord.GetPrimaryM1() - 50);

    return 0;
}


double CFactoryRSI::RSICurrencyTot(string Curr, string& pairs[])
{
   double tot=0;
   int arraySize = ArraySize(pairs);
   
   for(int i=0;i<arraySize;i++)
   {
      if(pairs[i]!=NULL)
      {
         int k=m_startBar;
         double value=iRSI(pairs[i], m_timeframe, m_primaryPeriod, m_appliedPrice, k);

         if(StringFind(pairs[i], Curr, 0)<3)
         {
            tot+=(value-50)/CurrenciesUsed;
         } 
         else
         {
            tot+=((100-value)-50)/CurrenciesUsed;
         }
      }
   }

   return tot;
}


void CFactoryRSI::SetCellColours(CSymbolRecord &symbolRecord)
{
    symbolRecord.SetCellColourDefault(Skin.GetCellColourDefault());
    symbolRecord.SetTextColourDefault(Skin.GetTextColourDefault());

    if(InpAlignment == REVERSED)
    {
        if(m_primary > m_primaryUpperZone && m_secondary < m_secondaryUpperZone)
        {
            m_cellColour = Skin.GetCellColourBuy();
            m_textColour = Skin.GetTextColourBuy();
        }
        else
        {
            if(m_primary < m_primaryLowerZone && m_secondary > m_secondaryLowerZone)
            {
                m_cellColour = Skin.GetCellColourSell();
                m_textColour = Skin.GetTextColourSell();
            }
            else
            {
                if(m_hideInactive)
                {
                    m_cellColour = Skin.GetColourNone();
                    m_textColour = Skin.GetColourNone();
                }
                else
                {
                    m_textColour = Skin.GetTextColourDefault();
                    m_cellColour = Skin.GetCellColourDefault();
                }
            }
        }
    }
    else
    {     
        if(m_primary > m_primaryUpperZone && m_secondary > m_secondaryUpperZone)
        {
                m_textColour = Skin.GetTextColourBuy();
                m_cellColour = Skin.GetCellColourBuy();
        }
        else
        {
            if(m_primary < m_primaryLowerZone && m_secondary < m_secondaryLowerZone)
            {
                m_textColour = Skin.GetTextColourSell();
                m_cellColour = Skin.GetCellColourSell();
            }
            else
            {
                if(InpHideInactive)
                {
                    m_cellColour = Skin.GetColourNone();
                    m_textColour = Skin.GetColourNone();
                }
                else
                {
                    m_textColour = Skin.GetTextColourDefault();
                    m_cellColour = Skin.GetCellColourDefault();
                }
            }
        }
    }
}

