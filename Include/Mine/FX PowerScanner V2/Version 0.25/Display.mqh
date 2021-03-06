/*
	Display.mqh

	Copyright 2022, John Skinner & Neil Prior
	https://www.FXCorrelator.com

    Description:
    ============
    A class to hold all screen display methods
    
*/
#include "GUI\Controls\WndEvents.mqh"

  
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CDisplay : public CWndEvents
{
private:
    CWindow         m_window1;
    CMenuBar        m_menubar;
    CContextMenu    m_mb_contextmenu1;
    CContextMenu    m_mb_contextmenu2;
    CContextMenu    m_mb_contextmenu3;
    CContextMenu    m_mb_contextmenu4;
    CTable          m_symbolGrid;
    CTable          m_currencyGrid;
    CStatusBar      m_status_bar;
    CLabel          m_label1;
    int             m_columnCount;
    int             m_zonePosition;
    int             m_window1Width;       
    int             m_window1Height;       
    
    bool            m_fixFirstRow;
    bool            m_fixFirstCol;
    color           m_gridColour;

    bool            CreateWindow1(const string text);
    void            WriteSymbolData(bool filtered, double indexVal, int col, int row, int ranking, color cellColour, color textColour);
    void            WriteCurrencyData(bool filtered, double indexVal, int col, int row, int ranking, color cellColour, color textColour);

public:
                    CDisplay(void);
                    ~CDisplay(void);

    string          GetCellValue(string table, int col, int row);
    void            OnInitEvent(void);
    void            OnDeinitEvent(const int reason);
    void            OnTimerEvent(void);
    void            UpdateSymbolGrid();
    void            UpdateCurrencyGrid();
    void            SetFixFirstRow(const bool value) {m_fixFirstRow = value;}
    void            SetFixFirstCol(const bool value) {m_fixFirstCol = value;}
    void            SetGridColour(const color value) {m_gridColour = value;}
    void            SetColumnCount(const int value) {m_columnCount = value;}

protected:
   CTabs             m_tabs;

   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   bool              CreateTabs(const int x_gap,const int y_gap);

public:
   //--- Create an expert panel
   bool              CreateExpertPanel(void);
   //---
private:

   //--- Main menu and its context menus
//#define MENUBAR_GAP_X         (1)
//#define MENUBAR_GAP_Y         (20)
//   bool              CreateMenuBar(void);
//   bool              CreateMBContextMenu1(void);
//   bool              CreateMBContextMenu2(void);
//   bool              CreateMBContextMenu3(void);
   //--- Status Bar
#define STATUSBAR1_GAP_X      (1)
#define STATUSBAR1_GAP_Y      (485)
   bool              CreateStatusBar(void);
   //--- Edit box table
#define TABLE1_GAP_X          (4)
#define TABLE1_GAP_Y          (43)
#define TABLE2_GAP_X          (4)
#define TABLE2_GAP_Y          (43)
   bool              CreateSymbolGrid(void);
   bool              CreateCurrencyGrid(void);
};


CDisplay::CDisplay(void)
{

}


CDisplay::~CDisplay(void)
{
}


void CDisplay::OnInitEvent(void)
{
}


void CDisplay::OnDeinitEvent(const int reason)
{
    WhichTab = m_tabs.SelectedTab();
    CWndEvents::Destroy();
}


void CDisplay::OnTimerEvent(void)
{
    CWndEvents::OnTimerEvent();

    //--- Updating the second item of the status bar every 500 milliseconds
    static int count=0;
    if(count<500)
    {
        count+=TIMER_STEP_MSC;
        return;
    }

    count=0;
    
    //--- Change the value in the second item of the status bar
    m_status_bar.ValueToItem(1,TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS));

    //--- Redraw the chart
    m_chart.Redraw();
}


void CDisplay::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {

    //--- Clicking on the menu item event
    if(id==CHARTEVENT_CUSTOM+ON_CLOSE_DIALOG_BOX)
    {
//        ::Print(__FUNCTION__," wwwww > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
    }

    if(id==CHARTEVENT_CUSTOM+ON_CLICK_CONTEXTMENU_ITEM)
    {
        if(sparam=="Exit")
            m_window1.CloseWindow();        

//        ::Print(__FUNCTION__,"aa > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);

        if(sparam=="Symbols")
        {
            m_currencyGrid.Hide();
            m_symbolGrid.Show();
            WhichTab = SHOW_SYMBOL;
        }

        if(sparam=="Currencies")
        {
            m_symbolGrid.Hide();
            m_currencyGrid.Show();
            WhichTab = SHOW_CURRENCY;
        }

        if(sparam=="Undock")
        {
            DetachChart2(WindowHandle(Symbol(), Period()), 3);
        }
    }

    //--- Event of pressing on the list view item or table
    if(id==CHARTEVENT_CUSTOM+ON_CLICK_LIST_ITEM)
    {
//        ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
    }

    //--- Event of entering new value in the edit box
    if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
    {
//        ::Print(__FUNCTION__," > id: ",id,"; lparam: ",lparam,"; dparam: ",dparam,"; sparam: ",sparam);
    }
}
 

bool CDisplay::CreateExpertPanel(void)
{
    string programName = "FXPS "+StringSubstr(MQLInfoString(MQL_PROGRAM_NAME),14);
    
    //--- Creating form 1 for controls
    if(!CreateWindow1(programName + " -- Expires on "+ TimeToString(ExpireDate,TIME_DATE)))
        return(false);

    if(!CreateTabs(0,22))
        return(false);

    if(!CreateStatusBar())
        return(false);
    
    //--- Edit box table
    if(!CreateSymbolGrid())
        return(false);
        
    if(!CreateCurrencyGrid())
        return(false);

    //--- Redrawing the chart
    m_chart.Redraw();
    
    if(WhichTab == SHOW_CURRENCY)
    {
        m_currencyGrid.Show();
        m_symbolGrid.Hide();
    }

    if(WhichTab == SHOW_SYMBOL)
    {
        m_symbolGrid.Show();
        m_currencyGrid.Hide();
    }
    
    return(true);
}
  
  
bool CDisplay::CreateWindow1(const string caption_text)
{
    //--- Add the window pointer to the window array
    CWndContainer::AddWindow(m_window1);

    m_window1Width = ((TimeframeCount+1)*70)+10;

    //--- Coordinates
    int x=(m_window1.X()>0) ? m_window1.X() : 1;
    int y=(m_window1.Y()>0) ? m_window1.Y() : 20;

    //--- Properties
//    m_window1.XSize(710);
    m_window1.XSize(m_window1Width);
    m_window1.YSize(509);
    m_window1.Movable(true);
    m_window1.UseRollButton();
    m_window1.WindowBorderColor(Skin.GetWindowBorderColour());
    m_window1.WindowBgColor(Skin.GetWindowBgColour());

    //--- Creating the form
    if(!m_window1.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
        return(false);

    return(true);
}


bool CDisplay::CreateStatusBar(void)
{
    #define STATUS_LABELS_TOTAL 1

    //--- Store the window pointer
    m_status_bar.WindowPointer(m_window1);

    //--- Coordinates
    int x=m_window1.X()+STATUSBAR1_GAP_X;
    int y=m_window1.Y()+STATUSBAR1_GAP_Y;

    //--- Width
    int width[]={0,110};

    //--- Set properties before creation
    m_status_bar.YSize(24);
    m_status_bar.AutoXResizeMode(true);
    m_status_bar.AutoXResizeRightOffset(1);
    m_status_bar.AreaColor(Skin.GetStatusBarAreaColour());
    m_status_bar.AreaBorderColor(Skin.GetStatusBarBorderColour());
    m_status_bar.XSize(m_window1Width-1);
    //--- Specify the number of parts and set their properties
    for(int i=0; i<STATUS_LABELS_TOTAL; i++)
        m_status_bar.AddItem(width[i]);
    
    //--- Create control
    if(!m_status_bar.CreateStatusBar(m_chart_id,m_subwin,x,y))
        return(false);
    
    //--- Set text in the first item of the status bar
    m_status_bar.ValueToItem(0,"www.FXCorrelator.com");
    
    //--- Add the element pointer to the base
    CWndContainer::AddToElementsArray(0,m_status_bar);
    
    return(true);
}


bool CDisplay::CreateSymbolGrid(void)
{
   // Alert(m_fixFirstCol+"   "+m_fixFirstRow);

    int timeframeCount = ArraySize(TimeframesUsed)+1;
    int COLUMNS1_TOTAL = timeframeCount;

    #define ROWS1_TOTAL    (29)

    //--- Store pointer to the form
    m_symbolGrid.WindowPointer(m_window1);

    //--- Attach to the first tab
    m_tabs.AddToElementsArray(0,m_symbolGrid);

    //--- Coordinates
    int x=m_window1.X()+TABLE1_GAP_X;
    int y=m_window1.Y()+TABLE1_GAP_Y;

    //--- The number of visible rows and columns
    int visible_rows_total    =29;

//int visible_rows_total=29;
  //  if(InpDisplayMonthlyTops)
    //    visible_rows_total =30;

    //--- Set properties before creation
    m_symbolGrid.XSize(m_window1Width-10);
    m_symbolGrid.RowYSize(16);
    m_symbolGrid.FixFirstRow(m_fixFirstRow);
    m_symbolGrid.FixFirstColumn(m_fixFirstCol);
    m_symbolGrid.LightsHover(false);
    m_symbolGrid.SelectableRow(false);
    m_symbolGrid.TextAlign(ALIGN_CENTER);
    m_symbolGrid.HeadersColor(Skin.GetColHeadersColour());
    m_symbolGrid.HeadersTextColor(Skin.GetColHeadersTextColour());
    m_symbolGrid.TableSize(TimeframeCount+1,ROWS1_TOTAL);
    m_symbolGrid.VisibleTableSize(TimeframeCount+1,visible_rows_total);
    m_symbolGrid.GridColor(Skin.GetGridColour());
    m_symbolGrid.BorderColor(Skin.GetGridBorderColour());

    // Add the names to the column headers
    for(int i=1;i<=ArraySize(TimeframesUsed);i++)
    {
        m_symbolGrid.SetValue(i,0,Timeframes[i-1].DisplayName+".");
        m_symbolGrid.CellColor(i,0, Skin.GetColHeadersColour());
        m_symbolGrid.TextColor(i,0, Skin.GetColHeadersTextColour());
    }

    //--- Create control
    if(!m_symbolGrid.CreateTable(m_chart_id,m_subwin,x,y))
        return(false);
    
    //--- Add the object to the common array of object groups
    CWndContainer::AddToElementsArray(0,m_symbolGrid);
   
   return(true);
}


bool CDisplay::CreateCurrencyGrid(void)
{
    int timeframeCount = ArraySize(TimeframesUsed)+1;
    int COLUMNS2_TOTAL = timeframeCount;

    #define ROWS2_TOTAL    (9)

    //--- Store pointer to the form
    m_currencyGrid.WindowPointer(m_window1);

    //--- Attach to the second tab
    m_tabs.AddToElementsArray(1,m_currencyGrid);

    //--- Coordinates
    int x=m_window1.X()+TABLE2_GAP_X;
    int y=m_window1.Y()+TABLE2_GAP_Y;

    //--- The number of visible rows and columns
 //   int visible_columns_total =10;
    int visible_rows_total    =9;

    //--- Set properties before creation
    m_currencyGrid.XSize(m_window1Width-10);
    m_currencyGrid.RowYSize(16);
    m_currencyGrid.FixFirstRow(m_fixFirstRow);
    m_currencyGrid.FixFirstColumn(m_fixFirstCol);
    m_currencyGrid.LightsHover(false);
    m_currencyGrid.SelectableRow(false);
    m_currencyGrid.TextAlign(ALIGN_CENTER);
    m_currencyGrid.HeadersColor(Skin.GetColHeadersColour());
    m_currencyGrid.HeadersTextColor(Skin.GetColHeadersTextColour());
    m_currencyGrid.TableSize(TimeframeCount+1,ROWS2_TOTAL);
    m_currencyGrid.VisibleTableSize(TimeframeCount+1,visible_rows_total);
    m_currencyGrid.GridColor(Skin.GetGridColour());
    m_currencyGrid.BorderColor(Skin.GetGridBorderColour());  

    // Add the names to the column headers
    for(int i=1;i<=ArraySize(TimeframesUsed);i++)
    {
        m_currencyGrid.SetValue(i,0,"."+Timeframes[i-1].DisplayName);
        m_currencyGrid.CellColor(i,0, Skin.GetColHeadersColour());
        m_currencyGrid.TextColor(i,0, Skin.GetColHeadersTextColour());
    }
    
    //--- Create control
    if(!m_currencyGrid.CreateTable(m_chart_id,m_subwin,x,y))
        return(false);
    
    //--- Add the object to the common array of object groups
    CWndContainer::AddToElementsArray(0,m_currencyGrid);
   
   return(true);
}


void  CDisplay::UpdateSymbolGrid()
{
    //--- Populate the table:
    m_symbolGrid.SetValue(0,0,"Symbols");
    m_symbolGrid.CellColor(0,0, Skin.GetColHeadersColour());
    m_symbolGrid.TextColor(0,0, Skin.GetColHeadersTextColour());


    for(int i=1;i<=ArraySize(TimeframesUsed);i++)
    {
        m_symbolGrid.SetValue(i,0,TimeframesUsed[i-1]+".");
        m_symbolGrid.CellColor(i,0, Skin.GetColHeadersColour());
        m_symbolGrid.TextColor(i,0, Skin.GetColHeadersTextColour());
    }

    m_symbolGrid.CellColor(ActiveSymbolSortedColumn,0, Skin.GetSortedColumnHeader());
    m_symbolGrid.TextAlign(0,0, ALIGN_LEFT);

    //--- Row header text alignment mode and cell colour
//    for(int c=0; c<1; c++)
//    {
        for(int r=1; r<=SymbolTable.Total(); r++)
        {
            CSymbolRecord *record = SymbolTable.At(r-1);

            m_symbolGrid.SetValue(0,r, record.GetName());
            m_symbolGrid.TextAlign(0,r,ALIGN_LEFT);
            m_symbolGrid.CellColor(0,r, record.GetCellColourDefault());
            m_symbolGrid.TextColor(0,r, record.GetTextColourDefault());
        }
//    }
    
    bool printedMN1=false;
    bool printedW1=false;
    bool printedD1=false;
    bool printedH4=false;
    bool printedH1=false;
    bool printedM30=false;
    bool printedM15=false;
    bool printedM5=false;
    bool printedM1=false;

    //--- Data and formatting of the table (background color and cell color)
    for(int c=1; c< TimeframeCount+1; c++)
    {
        for(int r=1; r<=SymbolTable.Total(); r++)
        {
            CSymbolRecord *record = SymbolTable.At(r-1);
   
            m_symbolGrid.TextAlign(c,r,ALIGN_RIGHT);

            if(record.GetColumnMN1() == c)
                WriteSymbolData(record.GetFilteredOutMN1(), record.GetIndexMN1(), c, r, record.GetRankingMN1(),  record.GetCellColourMN1(), record.GetTextColourMN1());

            if(record.GetColumnW1() == c)
                WriteSymbolData(record.GetFilteredOutW1(), record.GetIndexW1(), c, r, record.GetRankingW1(),  record.GetCellColourW1(), record.GetTextColourW1());

            if(record.GetColumnD1() == c)
                WriteSymbolData(record.GetFilteredOutD1(), record.GetIndexD1(), c, r, record.GetRankingD1(),  record.GetCellColourD1(), record.GetTextColourD1());

            if(record.GetColumnH4() == c)
                WriteSymbolData(record.GetFilteredOutH4(), record.GetIndexH4(), c, r, record.GetRankingH4(),  record.GetCellColourH4(), record.GetTextColourH4());

            if(record.GetColumnH1() == c)
                WriteSymbolData(record.GetFilteredOutH1(), record.GetIndexH1(), c, r, record.GetRankingH1(),  record.GetCellColourH1(), record.GetTextColourH1());

            if(record.GetColumnM30() == c)
                WriteSymbolData(record.GetFilteredOutM30(), record.GetIndexM30(), c, r, record.GetRankingM30(),  record.GetCellColourM30(), record.GetTextColourM30());

            if(record.GetColumnM15() == c)
                WriteSymbolData(record.GetFilteredOutM15(), record.GetIndexM15(), c, r, record.GetRankingM15(),  record.GetCellColourM15(), record.GetTextColourM15());

            if(record.GetColumnM5() == c)
                WriteSymbolData(record.GetFilteredOutM5(), record.GetIndexM5(), c, r, record.GetRankingM5(),  record.GetCellColourM5(), record.GetTextColourM5());

            if(record.GetColumnM1() == c)
                WriteSymbolData(record.GetFilteredOutM1(), record.GetIndexM1(), c, r, record.GetRankingM1(),  record.GetCellColourM1(), record.GetTextColourM1());
        }
    }

    //--- Update the table to display changes
    m_symbolGrid.UpdateTable();
}


void  CDisplay::UpdateCurrencyGrid()
{
    //--- Populate the table:
    //    The first cell is empty
    m_currencyGrid.SetValue(0,0,".Currency");
    m_currencyGrid.CellColor(0,0, Skin.GetColHeadersColour());
    m_currencyGrid.TextColor(0,0, Skin.GetColHeadersTextColour());
    m_currencyGrid.TextAlign(0,0, ALIGN_LEFT);


    for(int i=1;i<=ArraySize(TimeframesUsed);i++)
    {
        m_currencyGrid.SetValue(i,0,"."+TimeframesUsed[i-1]);
        m_currencyGrid.CellColor(i,0, Skin.GetColHeadersColour());
        m_currencyGrid.TextColor(i,0, Skin.GetColHeadersTextColour());
    }

    m_currencyGrid.CellColor(ActiveCurrencySortedColumn,0, Skin.GetSortedColumnHeader());

    //--- Row header text alignment mode and cell colour
//    for(int col=0; col<1; col++)
  //  {
        for(int row=1; row<ROWS2_TOTAL; row++)
        {
            CCurrencyRecord *currencyRecord = CurrencyDisplayTable.At(row-1);
            m_currencyGrid.SetValue(0,row,currencyRecord.GetName());
            m_currencyGrid.TextAlign(0,row,ALIGN_LEFT);
            m_currencyGrid.CellColor(0,row, Skin.GetCellColourDefault());
            
            m_currencyGrid.TextColor(0,row,Skin.GetColHeadersTextColour());
        }
 //   }
    
    for(int row=1; row<ROWS2_TOTAL; row++)
    {
        CCurrencyRecord *currencyRecord = CurrencyDisplayTable.At(row-1);

        for(int col=1; col<ArraySize(TimeframesUsed)+1; col++)
        {
            if(currencyRecord.GetColumnMN1() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexMN1(), col, row, 0,  currencyRecord.GetCellColourMN1(), currencyRecord.GetTextColourMN1());

            if(currencyRecord.GetColumnW1() == col)
            {
                WriteCurrencyData(false, currencyRecord.GetIndexW1(), col, row, 0,  currencyRecord.GetCellColourW1(), currencyRecord.GetTextColourW1());

            }
            if(currencyRecord.GetColumnD1() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexD1(), col, row, 0,  currencyRecord.GetCellColourD1(), currencyRecord.GetTextColourD1());

            if(currencyRecord.GetColumnH4() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexH4(), col, row, 0,  currencyRecord.GetCellColourH4(), currencyRecord.GetTextColourH4());

            if(currencyRecord.GetColumnH1() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexH1(), col, row, 0,  currencyRecord.GetCellColourH1(), currencyRecord.GetTextColourH1());

            if(currencyRecord.GetColumnM30() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexM30(), col, row, 0,  currencyRecord.GetCellColourM30(), currencyRecord.GetTextColourM30());

            if(currencyRecord.GetColumnM15() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexM15(), col, row, 0,  currencyRecord.GetCellColourM15(), currencyRecord.GetTextColourM15());

            if(currencyRecord.GetColumnM5() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexM5(), col, row, 0,  currencyRecord.GetCellColourM5(), currencyRecord.GetTextColourM5());

            if(currencyRecord.GetColumnM1() == col)
                WriteCurrencyData(false, currencyRecord.GetIndexM1(), col, row, 0,  currencyRecord.GetCellColourM1(), currencyRecord.GetTextColourM1());

/*
            if(col==1)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexMN1(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourMN1());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourH1());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }

            if(col==2)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexW1(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourW1());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourW1());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }

            if(col==3)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexD1(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourD1());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourD1());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }


            if(col==4)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexH4(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourH4());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourH4());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }
 
            if(col==5)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexH1(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourH1());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourH1());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }

            if(col==6)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexM30(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourM30());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourM30());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }
            
            if(col==7)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexM15(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourM15());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourM15());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }

            if(col==8)
            {
                if(!currencyRecord.GetFilteredOutH1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexM5(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourM5());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourM5());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }

            if(col==9)
            {
                if(!currencyRecord.GetFilteredOutM1())
                {
                    m_currencyGrid.SetValue(col,row, DoubleToString(currencyRecord.GetIndexM1(), 2));
                    m_currencyGrid.CellColor(col,row, currencyRecord.GetCellColourM1());
                    m_currencyGrid.TextColor(col,row, currencyRecord.GetTextColourM1());
                }
                else
                {
                    m_currencyGrid.SetValue(col,row,"");
                }        
            }
            */
        }
    }    

    //--- Update the table to display changes
    m_currencyGrid.UpdateTable();
}


string CDisplay::GetCellValue(string table, int col, int row)
{
    if(table=="Currency")
        return  m_currencyGrid.GetValue(col, row);

    if(table=="Symbol")
        return  m_symbolGrid.GetValue(col, row);

    return "";
}  


//+------------------------------------------------------------------+
//| Create area with tabs                                            |
//+------------------------------------------------------------------+
bool CDisplay::CreateTabs(const int x_gap,const int y_gap)
{
    #define TABS1_TOTAL 3
    //--- Store the window pointer
    m_tabs.WindowPointer(m_window1);

    //--- Coordinates
    int x=m_window1.X()+x_gap;
    int y=m_window1.Y()+y_gap;

    //--- Arrays with text and width for tabs
    string tabs_text[TABS1_TOTAL];
    for(int i=0; i<TABS1_TOTAL; i++)
    {
        if(i==0) tabs_text[i]="Symbol IDX";
        if(i==1) tabs_text[i]="Currency IDX";
        if(i==2) tabs_text[i]="About";
    }

    int tabs_width[TABS1_TOTAL];
    ArrayInitialize(tabs_width,80);

    //--- Set properties before creation
    m_tabs.YSize(464);
    m_tabs.XSize(m_window1Width-2);
    m_tabs.TabYSize(20);
    m_tabs.PositionMode(TABS_TOP);
    m_tabs.AutoXResizeMode(false);
    m_tabs.AutoXResizeRightOffset(0);
    m_tabs.TabBorderColor(clrDodgerBlue);
    m_tabs.AreaColor(clrOldLace);
    m_tabs.SelectedTab(WhichTab);

    //--- Add tabs with the specified properties
    for(int i=0; i<TABS1_TOTAL; i++)
        m_tabs.AddTab(tabs_text[i],tabs_width[i]);

    //--- Create control
    if(!m_tabs.CreateTabs(m_chart_id,m_subwin,x,y))
        return(false);

    //--- Add the object to the common array of object groups
    CWndContainer::AddToElementsArray(0,m_tabs);
    
    return(true);
}


void CDisplay::WriteSymbolData(bool filtered, double indexVal, int col, int row, int ranking, color cellColour, color textColour)
{
    if(InpDisplayRanking)
        m_symbolGrid.SetValue(col,row, IntegerToString(ranking)+"     "+DoubleToString(indexVal, 2));
    else
        m_symbolGrid.SetValue(col,row, DoubleToString(indexVal, 2));

    if(filtered)
    {
        m_symbolGrid.CellColor(col,row, Skin.GetEmptyCellBackground());
        m_symbolGrid.TextColor(col,row, Skin.GetEmptyCellText());
    }
    else
    {
        m_symbolGrid.CellColor(col,row, cellColour);
        m_symbolGrid.TextColor(col,row, textColour);
    }
}


void CDisplay::WriteCurrencyData(bool filtered, double indexVal, int col, int row, int ranking, color cellColour, color textColour)
{
    if(InpDisplayRanking)
        m_currencyGrid.SetValue(col,row, IntegerToString(ranking)+"     "+DoubleToString(indexVal, 2));
    else
        m_currencyGrid.SetValue(col,row, DoubleToString(indexVal, 2));
    
    if(filtered)
    {
        m_currencyGrid.CellColor(col,row, Skin.GetEmptyCellBackground());
        m_currencyGrid.TextColor(col,row, Skin.GetEmptyCellText());
    }
    else
    {
        m_currencyGrid.CellColor(col,row, cellColour);
        m_currencyGrid.TextColor(col,row, textColour);
    }
}





