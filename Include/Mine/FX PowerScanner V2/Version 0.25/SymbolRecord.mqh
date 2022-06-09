/*
	SymbolRecord.mqh

	Copyright 2022, John Skinner & Neil Prior
	https://www.FXCorrelator.com

    Description:
    ============
    A class to hold Symbol related methods and data 
    
*/
#include "BaseRecord.mqh"

class CSymbolRecord : public CBaseRecord
{
private:
    double      m_baseValueMN1;
    double      m_quoteValueMN1;
    double      m_baseValueW1;
    double      m_quoteValueW1;
    double      m_baseValueD1;
    double      m_quoteValueD1;
    double      m_baseValueH4;
    double      m_quoteValueH4;
    double      m_baseValueH1;
    double      m_quoteValueH1;
    double      m_baseValueM30;
    double      m_quoteValueM30;
    double      m_baseValueM15;
    double      m_quoteValueM15;
    double      m_baseValueM5;
    double      m_quoteValueM5;
    double      m_baseValueM1;
    double      m_quoteValueM1;

    string      m_baseName;
    string      m_quoteName;
    
public:
     CSymbolRecord(string name) : CBaseRecord(name){m_name = name;}
     CSymbolRecord();
    ~CSymbolRecord();
    
    double      GetBaseValueMN1()       const {return m_baseValueMN1;}
    double      GetQuoteValueMN1()      const {return m_quoteValueMN1;}
    double      GetBaseValueW1()       const {return m_baseValueW1;}
    double      GetQuoteValueW1()      const {return m_quoteValueW1;}
    double      GetBaseValueD1()       const {return m_baseValueD1;}
    double      GetQuoteValueD1()      const {return m_quoteValueD1;}
    double      GetBaseValueH4()       const {return m_baseValueH4;}
    double      GetQuoteValueH4()      const {return m_quoteValueH4;}
    double      GetBaseValueH1()       const {return m_baseValueH1;}
    double      GetQuoteValueH1()      const {return m_quoteValueH1;}
    double      GetBaseValueM30()       const {return m_baseValueM30;}
    double      GetQuoteValueM30()      const {return m_quoteValueM30;}
    double      GetBaseValueM15()       const {return m_baseValueM15;}
    double      GetQuoteValueM15()      const {return m_quoteValueM15;}
    double      GetBaseValueM5()       const {return m_baseValueM5;}
    double      GetQuoteValueM5()      const {return m_quoteValueM5;}
    double      GetBaseValueM1()       const {return m_baseValueM1;}
    double      GetQuoteValueM1()      const {return m_quoteValueM1;}

    string      GetBaseName()           const {return m_baseName;}
    string      GetQuoteName()          const {return m_quoteName;}

    void        SetBaseValueMN1(double value)       {m_baseValueMN1 = value;}
    void        SetQuoteValueMN1(double value)      {m_quoteValueMN1 = value;}
    void        SetBaseValueW1(double value)       {m_baseValueW1 = value;}
    void        SetQuoteValueW1(double value)      {m_quoteValueW1 = value;}
    void        SetBaseValueD1(double value)       {m_baseValueD1 = value;}
    void        SetQuoteValueD1(double value)      {m_quoteValueD1 = value;}
    void        SetBaseValueH4(double value)       {m_baseValueH4 = value;}
    void        SetQuoteValueH4(double value)      {m_quoteValueH4 = value;}
    void        SetBaseValueH1(double value)       {m_baseValueH1 = value;}
    void        SetQuoteValueH1(double value)      {m_quoteValueH1 = value;}
    void        SetBaseValueM30(double value)       {m_baseValueM30 = value;}
    void        SetQuoteValueM30(double value)      {m_quoteValueM30 = value;}
    void        SetBaseValueM15(double value)       {m_baseValueM15 = value;}
    void        SetQuoteValueM15(double value)      {m_quoteValueM15 = value;}
    void        SetBaseValueM5(double value)       {m_baseValueM5 = value;}
    void        SetQuoteValueM5(double value)      {m_quoteValueM5 = value;}
    void        SetBaseValueM1(double value)       {m_baseValueM1 = value;}
    void        SetQuoteValueM1(double value)      {m_quoteValueM1 = value;}

    void        SetBaseName(string value)           {m_baseName = value;}
    void        SetQuoteName(string value)          {m_quoteName = value;}
};


CSymbolRecord::CSymbolRecord() 
{
}


CSymbolRecord::~CSymbolRecord()
{
}


