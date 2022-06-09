
enum ENUM_SYMBOL_SORT_TYPE
{
   SORT_BY_NAME,
   SORT_BY_INDEXMN1,
   SORT_BY_INDEXW1,
   SORT_BY_INDEXD1,
   SORT_BY_INDEXH4,
   SORT_BY_INDEXH1,
   SORT_BY_INDEXM30,
   SORT_BY_INDEXM15,
   SORT_BY_INDEXM5,
   SORT_BY_INDEXM1
};

#define EQUAL 0
#define LESS -1
#define MORE 1
  
class CBaseRecord : public CObject
{
private:
    bool        m_filteredOutMN1;
    int         m_orderIndexMN1;
    int         m_columnMN1;
 //   double      m_price;
    double      m_primaryMN1;
    double      m_secondaryMN1;
    double      m_rankingMN1;
    double      m_indexMN1;
    color       m_cellColourMN1;
    color       m_textColourMN1;

    bool        m_filteredOutW1;
    int         m_orderIndexW1;
    int         m_columnW1;
    double      m_primaryW1;
    double      m_secondaryW1;
    double      m_rankingW1;
    double      m_indexW1;
    color       m_cellColourW1;
    color       m_textColourW1;
    

    bool        m_filteredOutD1;
    int         m_orderIndexD1;
    int         m_columnD1;
    double      m_primaryD1;
    double      m_secondaryD1;
    double      m_rankingD1;
    double      m_indexD1;
    color       m_cellColourD1;
    color       m_textColourD1;

    bool        m_filteredOutH4;
//    bool        m_usedH4;
    int         m_orderIndexH4;
    int         m_columnH4;
    double      m_primaryH4;
    double      m_secondaryH4;
    double      m_rankingH4;
    double      m_indexH4;
    color       m_cellColourH4;
    color       m_textColourH4;

    bool        m_filteredOutH1;
    int         m_orderIndexH1;
    int         m_columnH1;
    double      m_primaryH1;
    double      m_secondaryH1;
    double      m_rankingH1;
    double      m_indexH1;
    color       m_cellColourH1;
    color       m_textColourH1;
    
    bool        m_filteredOutM30;
    int         m_orderIndexM30;
    int         m_columnM30;
    double      m_primaryM30;
    double      m_secondaryM30;
    double      m_rankingM30;
    double      m_indexM30;
    color       m_cellColourM30;
    color       m_textColourM30;
    
    bool        m_filteredOutM15;
    int         m_orderIndexM15;
    int         m_columnM15;
    double      m_primaryM15;
    double      m_secondaryM15;
    double      m_rankingM15;
    double      m_indexM15;
    color       m_cellColourM15;
    color       m_textColourM15;
    
    bool        m_filteredOutM5;
    int         m_orderIndexM5;
    int         m_columnM5;
    double      m_primaryM5;
    double      m_secondaryM5;
    double      m_rankingM5;
    double      m_indexM5;
    color       m_cellColourM5;
    color       m_textColourM5;
    
    bool        m_filteredOutM1;
    int         m_orderIndexM1;
    int         m_columnM1;
    double      m_primaryM1;
    double      m_secondaryM1;
    double      m_rankingM1;
    double      m_indexM1;
    color       m_cellColourM1;
    color       m_textColourM1;

    int         m_RSIPriHandle; 
    int         m_RSISecHandle; 
    string      m_displayName;
    double      m_RSIPriValue;
    double      m_RSISecValue;
    color       m_cellColourDefault;
    color       m_textColourDefault;
    
protected:
    string      m_name;

    
public:
     CBaseRecord(string value) {m_name = value;}
     CBaseRecord();
    ~CBaseRecord();
    
    int         GetRSI_PriHandle()      const {return m_RSIPriHandle;}
    int         GetRSI_SecHandle()      const {return m_RSISecHandle;}
    double      GeRSI_PriValue()        const {return m_RSIPriValue;}
    double      GeRSI_SecValue()        const {return m_RSISecValue;}

    bool        GetFilteredOutMN1()            const {return m_filteredOutMN1;}
    int         GetOrderIndexMN1()           const {return m_orderIndexMN1;}
    int         GetColumnMN1()           const {return m_columnMN1;}
    double      GetPrimaryMN1()         const {return m_primaryMN1;}
    double      GetSecondaryMN1()       const {return m_secondaryMN1;}
    double      GetRankingMN1()         const {return m_rankingMN1;}
    double      GetIndexMN1()           const {return m_indexMN1;}
    color       GetCellColourMN1()      const {return m_cellColourMN1;}
    color       GetTextColourMN1()      const {return m_textColourMN1;}

    bool        GetFilteredOutW1()             const {return m_filteredOutW1;}
    int         GetOrderIndexW1()            const {return m_orderIndexW1;}
    int         GetColumnW1()           const {return m_columnW1;}
    double      GetPrimaryW1()          const {return m_primaryW1;}
    double      GetSecondaryW1()        const {return m_secondaryW1;}
    double      GetRankingW1()          const {return m_rankingW1;}
    double      GetIndexW1()            const {return m_indexW1;}
    color       GetCellColourW1()       const {return m_cellColourW1;}
    color       GetTextColourW1()       const {return m_textColourW1;}

    bool        GetFilteredOutD1()             const {return m_filteredOutD1;}
    int         GetOrderIndexD1()            const {return m_orderIndexD1;}
    int         GetColumnD1()           const {return m_columnD1;}
    double      GetPrimaryD1()          const {return m_primaryD1;}
    double      GetSecondaryD1()        const {return m_secondaryD1;}
    double      GetRankingD1()          const {return m_rankingD1;}
    double      GetIndexD1()            const {return m_indexD1;}
    color       GetCellColourD1()       const {return m_cellColourD1;}
    color       GetTextColourD1()       const {return m_textColourD1;}

    bool        GetFilteredOutH4()             const {return m_filteredOutH4;}
    int         GetOrderIndexH4()            const {return m_orderIndexH4;}
    int         GetColumnH4()           const {return m_columnH4;}
    double      GetPrimaryH4()          const {return m_primaryH4;}
    double      GetSecondaryH4()        const {return m_secondaryH4;}
    double      GetRankingH4()          const {return m_rankingH4;}
    double      GetIndexH4()            const {return m_indexH4;}
    color       GetCellColourH4()       const {return m_cellColourH4;}
    color       GetTextColourH4()       const {return m_textColourH4;}

    bool        GetFilteredOutH1()             const {return m_filteredOutH1;}
    int         GetOrderIndexH1()            const {return m_orderIndexH1;}
    int         GetColumnH1()           const {return m_columnH1;}
    double      GetPrimaryH1()          const {return m_primaryH1;}
    double      GetSecondaryH1()        const {return m_secondaryH1;}
    double      GetRankingH1()          const {return m_rankingH1;}
    double      GetIndexH1()            const {return m_indexH1;}
    color       GetCellColourH1()       const {return m_cellColourH1;}
    color       GetTextColourH1()       const {return m_textColourH1;}

    bool        GetFilteredOutM30()            const {return m_filteredOutM30;}
    int         GetOrderIndexM30()           const {return m_orderIndexM30;}
    int         GetColumnM30()           const {return m_columnM30;}
    double      GetPrimaryM30()         const {return m_primaryM30;}
    double      GetSecondaryM30()       const {return m_secondaryM30;}
    double      GetRankingM30()         const {return m_rankingM30;}
    double      GetIndexM30()           const {return m_indexM30;}
    color       GetCellColourM30()      const {return m_cellColourM30;}
    color       GetTextColourM30()      const {return m_textColourM30;}

    bool        GetFilteredOutM15()            const {return m_filteredOutM15;}
    int         GetOrderIndexM15()           const {return m_orderIndexM15;}
    int         GetColumnM15()           const {return m_columnM15;}
    double      GetPrimaryM15()         const {return m_primaryM15;}
    double      GetSecondaryM15()       const {return m_secondaryM15;}
    double      GetRankingM15()         const {return m_rankingM15;}
    double      GetIndexM15()           const {return m_indexM15;}
    color       GetCellColourM15()      const {return m_cellColourM15;}
    color       GetTextColourM15()      const {return m_textColourM15;}

    bool        GetFilteredOutM5()             const {return m_filteredOutM5;}
    int         GetOrderIndexM5()            const {return m_orderIndexM5;}
    int         GetColumnM5()           const {return m_columnM5;}
    double      GetPrimaryM5()          const {return m_primaryM5;}
    double      GetSecondaryM5()        const {return m_secondaryM5;}
    double      GetRankingM5()          const {return m_rankingM5;}
    double      GetIndexM5()            const {return m_indexM5;}
    color       GetCellColourM5()       const {return m_cellColourM5;}
    color       GetTextColourM5()       const {return m_textColourM5;}

    bool        GetFilteredOutM1()             const {return m_filteredOutM1;}
    int         GetOrderIndexM1()            const {return m_orderIndexM1;}
    int         GetColumnM1()           const {return m_columnM1;}
    double      GetPrimaryM1()          const {return m_primaryM1;}
    double      GetSecondaryM1()        const {return m_secondaryM1;}
    double      GetRankingM1()          const {return m_rankingM1;}
    double      GetIndexM1()            const {return m_indexM1;}
    color       GetCellColourM1()       const {return m_cellColourM1;}
    color       GetTextColourM1()       const {return m_textColourM1;}
    
    string      GetDisplayName()        const {return m_displayName;}
    string      GetName()               const {return m_name;}
    color       GetCellColourDefault()  const {return m_cellColourDefault;}
    color       GetTextColourDefault()  const {return m_textColourDefault;}

    void        SetRSI_PriValue(double value)       {m_RSIPriValue  = value;}
    void        SetRSI_SecValue(double value)       {m_RSISecValue  = value;}
    void        SetRSI_PriHandle(int value)         {m_RSIPriHandle = value;}
    void        SetRSI_SecHandle(int value)         {m_RSISecHandle = value;}

    void        SetColumnMN1(double value)         {m_columnMN1   = value;}
    void        SetPrimaryMN1(double value)         {m_primaryMN1   = value;}
    void        SetSecondaryMN1(double value)       {m_secondaryMN1 = value;}
    void        SetRankingMN1(double value)         {m_rankingMN1   = value;}
    void        SetCellColourMN1(color value)       {m_cellColourMN1 = value;}
    void        SetTextColourMN1(color value)       {m_textColourMN1 = value;}
    void        SetIndexMN1(double value)           {m_indexMN1 = value;}
    void        SetOrderIndexMN1(int value)              {m_orderIndexMN1 = value;}
    void        SetFilteredOutMN1(bool value)              {m_filteredOutMN1 = value;}
    
    void        SetColumnW1(double value)         {m_columnW1   = value;}
    void        SetPrimaryW1(double value)          {m_primaryW1 = value;}
    void        SetSecondaryW1(double value)        {m_secondaryW1 = value;}
    void        SetRankingW1(double value)          {m_rankingW1 = value;}
    void        SetCellColourW1(color value)        {m_cellColourW1 = value;}
    void        SetTextColourW1(color value)        {m_textColourW1 = value;}
    void        SetIndexW1(double value)            {m_indexW1 = value;}
    void        SetOrderIndexW1(int value)               {m_orderIndexW1 = value;}
    void        SetFilteredOutW1(bool value)               {m_filteredOutW1 = value;}

    void        SetColumnD1(double value)         {m_columnD1   = value;}
    void        SetPrimaryD1(double value)          {m_primaryD1 = value;}
    void        SetSecondaryD1(double value)        {m_secondaryD1 = value;}
    void        SetRankingD1(double value)          {m_rankingD1 = value;}
    void        SetCellColourD1(color value)        {m_cellColourD1 = value;}
    void        SetTextColourD1(color value)        {m_textColourD1 = value;}
    void        SetIndexD1(double value)            {m_indexD1 = value;}
    void        SetOrderIndexD1(int value)               {m_orderIndexD1 = value;}
    void        SetFilteredOutD1(bool value)               {m_filteredOutD1 = value;}

    void        SetColumnH4(double value)         {m_columnH4   = value;}
    void        SetPrimaryH4(double value)          {m_primaryH4 = value;}
    void        SetSecondaryH4(double value)        {m_secondaryH4 = value;}
    void        SetRankingH4(double value)          {m_rankingH4 = value;}
    void        SetCellColourH4(color value)        {m_cellColourH4 = value;}
    void        SetTextColourH4(color value)        {m_textColourH4 = value;}
    void        SetIndexH4(double value)            {m_indexH4 = value;}
    void        SetOrderIndexH4(int value)               {m_orderIndexH4 = value;}
    void        SetFilteredOutH4(bool value)               {m_filteredOutH4 = value;}

    void        SetColumnH1(double value)         {m_columnH1   = value;}
    void        SetPrimaryH1(double value)          {m_primaryH1 = value;}
    void        SetSecondaryH1(double value)        {m_secondaryH1 = value;}
    void        SetRankingH1(double value)          {m_rankingH1 = value;}
    void        SetCellColourH1(color value)        {m_cellColourH1 = value;}
    void        SetTextColourH1(color value)        {m_textColourH1 = value;}
    void        SetIndexH1(double value)            {m_indexH1 = value;}
    void        SetOrderIndexH1(int value)               {m_orderIndexH1 = value;}
    void        SetFilteredOutH1(bool value)               {m_filteredOutH1 = value;}

    void        SetColumnM30(double value)         {m_columnM30   = value;}
    void        SetPrimaryM30(double value)         {m_primaryM30 = value;}
    void        SetSecondaryM30(double value)       {m_secondaryM30 = value;}
    void        SetRankingM30(double value)         {m_rankingM30 = value;}
    void        SetCellColourM30(color value)       {m_cellColourM30 = value;}
    void        SetTextColourM30(color value)       {m_textColourM30 = value;}
    void        SetIndexM30(double value)           {m_indexM30 = value;}
    void        SetOrderIndexM30(int value)              {m_orderIndexM30 = value;}
    void        SetFilteredOutM30(bool value)              {m_filteredOutM30 = value;}

    void        SetColumnM15(double value)         {m_columnM15   = value;}
    void        SetPrimaryM15(double value)         {m_primaryM15 = value;}
    void        SetSecondaryM15(double value)       {m_secondaryM15 = value;}
    void        SetRankingM15(double value)         {m_rankingM15 = value;}
    void        SetCellColourM15(color value)       {m_cellColourM15 = value;}
    void        SetTextColourM15(color value)       {m_textColourM15 = value;}
    void        SetIndexM15(double value)           {m_indexM15 = value;}
    void        SetOrderIndexM15(int value)              {m_orderIndexM15 = value;}
    void        SetFilteredOutM15(bool value)              {m_filteredOutM15 = value;}

    void        SetColumnM5(double value)         {m_columnM5   = value;}
    void        SetPrimaryM5(double value)          {m_primaryM5 = value;}
    void        SetSecondaryM5(double value)        {m_secondaryM5 = value;}
    void        SetRankingM5(double value)          {m_rankingM5 = value;}
    void        SetCellColourM5(color value)        {m_cellColourM5 = value;}
    void        SetTextColourM5(color value)        {m_textColourM5 = value;}
    void        SetIndexM5(double value)            {m_indexM5 = value;}
    void        SetOrderIndexM5(int value)               {m_orderIndexM5 = value;}
    void        SetFilteredOutM5(bool value)               {m_filteredOutM5 = value;}

    void        SetColumnM1(double value)         {m_columnM1   = value;}
    void        SetPrimaryM1(double value)          {m_primaryM1 = value;}
    void        SetSecondaryM1(double value)        {m_secondaryM1 = value;}
    void        SetRankingM1(double value)          {m_rankingM1 = value;}
    void        SetCellColourM1(color value)        {m_cellColourM1 = value;}
    void        SetTextColourM1(color value)        {m_textColourM1 = value;}
    void        SetIndexM1(double value)            {m_indexM1 = value;}
    void        SetOrderIndexM1(int value)               {m_orderIndexM1 = value;}
    void        SetFilteredOutM1(bool value)               {m_filteredOutM1 = value;}

    void        SetDisplayeName(string value)       {m_displayName = value;}
    void        SetCellColourDefault(color value)  {m_cellColourDefault = value;}
    void        SetTextColourDefault(color value)  {m_textColourDefault = value;}


    virtual int Compare(const CObject *node,const int mode=0) const
    {
        int sort=-1; // -1 = no sort, 0 = ascending,  1 = descending
        int column = StringToInteger(StringSubstr(IntegerToString(mode),1));

        if(mode >=2000)
            sort = SORT_ASCENDING;
        else
            sort = SORT_DESCENDING;
                
        const CBaseRecord *record=node;
        switch(column)
        {
            case SORT_BY_NAME:
                if(record.GetName()==this.GetName())
                    return EQUAL;
                else
                {
                    if(record.GetName()<this.GetName())
                        return MORE;
                    else
                        return LESS;
                }

            case SORT_BY_INDEXMN1:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexMN1(), _Digits)==NormalizeDouble(this.GetIndexMN1(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexMN1(), _Digits)<NormalizeDouble(this.GetIndexMN1(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexMN1(), _Digits)==NormalizeDouble(this.GetIndexMN1(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexMN1(), _Digits) < NormalizeDouble(this.GetIndexMN1(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;

                        }
                    }
                }

            case SORT_BY_INDEXW1:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexW1(), _Digits)==NormalizeDouble(this.GetIndexW1(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexW1(), _Digits)<NormalizeDouble(this.GetIndexW1(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexW1(), _Digits)==NormalizeDouble(this.GetIndexW1(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexW1(), _Digits) < NormalizeDouble(this.GetIndexW1(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;
                        }
                    }
                }

            case SORT_BY_INDEXD1:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexD1(), _Digits)==NormalizeDouble(this.GetIndexD1(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexD1(), _Digits)<NormalizeDouble(this.GetIndexD1(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexD1(), _Digits)==NormalizeDouble(this.GetIndexD1(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexD1(), _Digits) < NormalizeDouble(this.GetIndexD1(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;
                        }
                    }
                }

            case SORT_BY_INDEXH4:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexH4(), _Digits)==NormalizeDouble(this.GetIndexH4(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexH4(), _Digits)<NormalizeDouble(this.GetIndexH4(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexH4(), _Digits)==NormalizeDouble(this.GetIndexH4(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexH4(), _Digits) < NormalizeDouble(this.GetIndexH4(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;

                        }
                    }
                }

            case SORT_BY_INDEXH1:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexH1(), _Digits)==NormalizeDouble(this.GetIndexH1(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexH1(), _Digits)<NormalizeDouble(this.GetIndexH1(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexH1(), _Digits)==NormalizeDouble(this.GetIndexH1(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexH1(), _Digits) < NormalizeDouble(this.GetIndexH1(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;
                        }
                    }
                }

            case SORT_BY_INDEXM30:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM30(), _Digits)==NormalizeDouble(this.GetIndexM30(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM30(), _Digits)<NormalizeDouble(this.GetIndexM30(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM30(), _Digits)==NormalizeDouble(this.GetIndexM30(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM30(), _Digits) < NormalizeDouble(this.GetIndexM30(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;
                        }
                    }
                }

            case SORT_BY_INDEXM15:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM15(), _Digits)==NormalizeDouble(this.GetIndexM15(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM15(), _Digits)<NormalizeDouble(this.GetIndexM15(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
      //          Alert(record.GetIndexM15());
                
                    if(NormalizeDouble(record.GetIndexM15(), _Digits)==NormalizeDouble(this.GetIndexM15(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM15(), _Digits) < NormalizeDouble(this.GetIndexM15(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;
                        }
                    }
                }

            case SORT_BY_INDEXM5:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM5(), _Digits)==NormalizeDouble(this.GetIndexM5(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM5(), _Digits)<NormalizeDouble(this.GetIndexM5(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM5(), _Digits)==NormalizeDouble(this.GetIndexM5(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM5(), _Digits) < NormalizeDouble(this.GetIndexM5(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;

                        }
                    }
                }

            case SORT_BY_INDEXM1:
                if(sort==SORT_ASCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM1(), _Digits)==NormalizeDouble(this.GetIndexM1(), _Digits))
                        return EQUAL;
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM1(), _Digits)<NormalizeDouble(this.GetIndexM1(), _Digits))
                            return MORE;
                        else
                            return LESS;
                    }
                }
                else if(sort==SORT_DESCENDING)
                {
                    if(NormalizeDouble(record.GetIndexM1(), _Digits)==NormalizeDouble(this.GetIndexM1(), _Digits))
                    {
                        return EQUAL;
                    }
                    else
                    {
                        if(NormalizeDouble(record.GetIndexM1(), _Digits) < NormalizeDouble(this.GetIndexM1(), _Digits))
                        {
                            return LESS;
                        }
                        else
                        {
                            return MORE;

                        }
                    }
                }
        }

        return EQUAL;
    }
};


CBaseRecord::CBaseRecord() 
{
}


CBaseRecord::~CBaseRecord()
{
}


