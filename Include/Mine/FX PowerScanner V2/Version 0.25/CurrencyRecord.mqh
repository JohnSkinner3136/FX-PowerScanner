/*
	CurrencyRecord.mqh

	Copyright 2022, John Skinner & Neil Prior
	https://www.FXCorrelator.com

    Description:
    ============
    A class to hold Currency related methods and data 
    
*/
#include "BaseRecord.mqh"

class CCurrencyRecord : public CBaseRecord
{
private:
    double  m_valueMN1;
    double  m_valueW1;
    double  m_valueD1;
    double  m_valueH4;
    double  m_valueH1;
    double  m_valueM30;
    double  m_valueM15;
    double  m_valueM5;
    double  m_valueM1;
        
public:
     CCurrencyRecord(string name) : CBaseRecord(name){m_name = name;}

     CCurrencyRecord();
    ~CCurrencyRecord();
    
    double GetValueMN1()       const {return m_valueMN1;}
    double GetValueW1()       const {return m_valueW1;}
    double GetValueD1()       const {return m_valueD1;}
    double GetValueH4()       const {return m_valueH4;}
    double GetValueH1()       const {return m_valueH1;}
    double GetValueM30()       const {return m_valueM30;}
    double GetValueM15()       const {return m_valueM15;}
    double GetValueM5()       const {return m_valueM5;}
    double GetValueM1()       const {return m_valueM1;}
    
    void SetValueMN1(double value)     {m_valueMN1 = value;}
    void SetValueW1(double value)     {m_valueW1 = value;}
    void SetValueD1(double value)     {m_valueD1 = value;}
    void SetValueH4(double value)     {m_valueH4 = value;}
    void SetValueH1(double value)     {m_valueH1 = value;}
    void SetValueM30(double value)     {m_valueM30 = value;}
    void SetValueM15(double value)     {m_valueM15 = value;}
    void SetValueM5(double value)     {m_valueM5 = value;}
    void SetValueM1(double value)     {m_valueM1 = value;}
};


CCurrencyRecord::CCurrencyRecord() 
{
}


CCurrencyRecord::~CCurrencyRecord()
{
}
