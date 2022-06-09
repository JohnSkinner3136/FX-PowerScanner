/*
	Filters.mqh

	Copyright 2022, John Skinner & Neil Prior
	https://www.FXCorrelator.com

    Description:
    ============
    A class to hold methods for filtering symbol and currency records depending on input criteria 
    
*/
class CFilters
{
private:
    double m_minimumIndex;
    void IndexFilter(CSymbolRecord &symbolRecord);

public:
    void SetMinimumIndex(double value) {m_minimumIndex=value;}

    double  GetMinimumIndex() {return m_minimumIndex;}
    void    ProcessFilters(CSymbolRecord &symbolRecord);
    
    CFilters();
    ~CFilters();
};


CFilters::CFilters()
{
}


CFilters::~CFilters()
{
}


void CFilters::ProcessFilters(CSymbolRecord &symbolRecord)
{
    IndexFilter(symbolRecord);
}


void CFilters::IndexFilter(CSymbolRecord &symbolRecord)
{
    for(int i=0; i<SymbolTable.Total();i++)
    {
        if(UseMN1)
        {
            if(symbolRecord.GetIndexMN1() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutMN1(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutMN1(true);
            }            
        }    
        if(UseW1)
        {
            if(symbolRecord.GetIndexW1() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutW1(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutW1(true);
            }            
        }    
        if(UseD1)
        {
            if(symbolRecord.GetIndexD1() > m_minimumIndex)
            {
                 symbolRecord.SetFilteredOutD1(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutD1(true);
            }
        }    
        if(UseH4)
        {
            if(symbolRecord.GetIndexH4() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutH4(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutH4(true);
            }            
        }    
        if(UseH1)
        {
            if(symbolRecord.GetIndexH1() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutH1(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutH1(true);
            }            
        }    
        if(UseM30)
        {
            if(symbolRecord.GetIndexM30() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutM30(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutM30(true);
            }            
        }    
        if(UseM15)
        {
            if(symbolRecord.GetIndexM15() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutM15(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutM15(true);
            }            
        }    
        if(UseM5)
        {
            if(symbolRecord.GetIndexM5() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutM5(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutM5(true);
            }            
        }    
        if(UseM1)
        {
            if(symbolRecord.GetIndexM1() > m_minimumIndex)
            {
                symbolRecord.SetFilteredOutM1(false);
            }      
            else
            {
                symbolRecord.SetFilteredOutM1(true);
            }            
        }    
    }
}
