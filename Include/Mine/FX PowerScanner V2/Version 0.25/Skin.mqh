/*
	SkinRecord.mqh

	Copyright 2022, John Skinner & Neil Prior
	https://www.FXCorrelator.com

    Description:
    ============
    A class to information relating to default FXPS colours 
    
*/

class CSkin
{
private:
    int     m_cellBorderType;
    string  m_skinPath;    
    color   m_cellColourBuy;
    color   m_textColourBuy;
    color   m_cellColourSell;
    color   m_textColourSell;
    color   m_textColourDefault;
    color   m_cellColourDefault;
    color   m_emptyCellBacground;
    color   m_emptyCellText;
    color   m_colourNone;
    color   m_colHeadersColour;
    color   m_colHeadersTextColour;
    color   m_rowColour;
    color   m_textColoue;
    color   m_caption_bg_color;
    color   m_caption_bg_color_off;
    color   m_caption_bg_color_hover;
    color   m_bg_color;
    color   m_border_color;
    color   m_windowBgColour;
    color   m_windowBorderColour;
    color   m_gridColour;    
    color   m_statusBarAreaColour;
    color   m_statusBarBorderColour;    
    color   m_gridBorderColour;
    color   m_sortedColumnHeader;
    
    void ApplySkin();
    bool LoadData();
       
protected:

public:
    void LoadFileNames();
    bool OpenSkinFile();
    bool CreateDefaultSkin(int fileHandle);

    void  SetStatusBarAreaColour(color value)     {m_statusBarAreaColour = value;}
    void  SetWindowBorderColour(color value)      {m_windowBorderColour = value;}
    void  SetWindowBgColour(color value)          {m_windowBgColour = value;}
    void  SetCellColourSell(color value)          {m_cellColourSell = value;}
    void  SetTextColourSell(color value)          {m_textColourSell = value;}
    void  SetCellColourBuy(color value)           {m_cellColourBuy = value;}
    void  SetTextColourBuy(color value)           {m_textColourBuy = value;}
    void  SetEmptyCellBackground(color value)     {m_emptyCellBacground = value;}
    void  SetEmptyCellText(color value)           {m_emptyCellText = value;}
    void  SetCellColourDefault(color value)       {m_cellColourDefault = value;}
    void  SetTextColourDefault(color value)       {m_textColourDefault = value;}
    void  SetColourNone(color value)              {m_colourNone = value;}
    void  SettColHeadersColour(color value)       {m_colHeadersColour = value;}
    void  SetColHeadersTextColour(color value)    {m_colHeadersTextColour = value;}
    void  SetGridColour(color value)              {m_gridColour = value;}
    void  SetGridBorderColour(color value)        {m_gridBorderColour = value;}
    void  SetStatusBarBorderColour(color value)   {m_statusBarBorderColour = value;}
    void  SetSortedColumnHeader(color value)      {m_sortedColumnHeader = value;}
    

    color GetStatusBarAreaColour()      {return m_statusBarAreaColour;}    
    color GetWindowBorderColour()       {return m_windowBorderColour;}
    color GetWindowBgColour()           {return m_windowBgColour;}
    color GetCellColourSell()           {return m_cellColourSell;}
    color GetTextColourSell()           {return m_textColourSell;}
    color GetCellColourBuy()            {return m_cellColourBuy;}
    color GetTextColourBuy()            {return m_textColourBuy;}
    color GetCellColourDefault()        {return m_cellColourDefault;}
    color GetTextColourDefault()        {return m_textColourDefault;}
    color GetEmptyCellBackground()      {return m_emptyCellBacground;}
    color GetEmptyCellText()            {return m_emptyCellText;}
    color GetColourNone()               {return m_colourNone;}
    color GetColHeadersColour()         {return m_colHeadersColour;}
    color GetColHeadersTextColour()     {return m_colHeadersTextColour;}
    color GetGridColour()               {return m_gridColour;}
    color GetGridBorderColour()         {return m_gridBorderColour;};
    color GetStatusBarBorderColour()    {return m_statusBarBorderColour;}   
    color GetSortedColumnHeader()       {return m_sortedColumnHeader;}   

    CSkin(string skinPath);
    CSkin(void);
    ~CSkin(void);
};


CSkin::CSkin(string skinPath)
{
    m_skinPath = skinPath;
    OpenSkinFile();
}


CSkin::CSkin(void)
{
}


CSkin::~CSkin()
{
}


bool CSkin::OpenSkinFile()
{
    ResetLastError();

    int fileHandle;   
    if(FileIsExist(m_skinPath+"Default.skn"))
        LoadData();            

    else
    {
        fileHandle=FileOpen(m_skinPath+"Default.skn", FILE_WRITE);
        int err = GetLastError();

        if(err == INVALID_HANDLE)
        {
            Print("Error opening "+m_skinPath+"Default.skn ");
            return false;
        }
        else
            CreateDefaultSkin(fileHandle);    
    }

    return true;
}


bool CSkin::CreateDefaultSkin(int fileHandle)
{
    FileWriteString(fileHandle, "NoColour="+ ColorToString(clrNONE)+ " = " + (string)clrNONE+"\r\n");
    FileWriteString(fileHandle, "CellColourBuy="+ColorToString(clrDarkGreen)+ " = " + (string)clrDarkGreen+"\r\n");
    FileWriteString(fileHandle, "TextColourBuy="+ColorToString(clrWhite)+ " = " + (string)clrWhite+"\r\n");
    FileWriteString(fileHandle, "CellColourSell="+ColorToString(clrRed)+ " = " + (string)clrRed+"\r\n");
    FileWriteString(fileHandle, "TextColourSell="+ColorToString(clrWhite)+ " = " + (string)clrWhite+"\r\n");
    FileWriteString(fileHandle, "CellColourDefault="+ColorToString(C'255,244,213')+"\r\n");
    FileWriteString(fileHandle, "TextColourDefault="+ColorToString(clrBlack)+ " = " + (string)clrBlack+"\r\n");
    FileWriteString(fileHandle, "ColHeadersColour="+ColorToString(C'255,244,213')+"\r\n");
    FileWriteString(fileHandle, "ColHeadersTextColour="+ColorToString(clrBlack)+ " = " + (string)clrBlack+"\r\n");
    FileWriteString(fileHandle, "RowColour="+ColorToString(clrWhite)+ " = " + (string)clrWhite+"\r\n");
    FileWriteString(fileHandle, "TextColour="+ColorToString(clrBlack)+ " = " + (string)clrBlack+"\r\n");
    FileWriteString(fileHandle, "WindowBackgroundColour="+ColorToString(clrWhiteSmoke)+ " = " + (string)clrWhiteSmoke+"\r\n");
    FileWriteString(fileHandle, "WindowBorderColour="+ColorToString(clrLightSteelBlue)+ " = " + (string)clrLightSteelBlue+"\r\n");
    FileWriteString(fileHandle, "GridColour="+ColorToString(clrLightGray)+ " = " + (string)clrLightGray+"\r\n");
    FileWriteString(fileHandle, "GridBorderColour="+ColorToString(C'240,240,240')+ "\r\n");
    FileWriteString(fileHandle, "StatusBarAreaColour="+ColorToString(clrLightGray)+ " = " + (string)clrLightGray+"\r\n");
    FileWriteString(fileHandle, "StatusBarBorderColour="+ColorToString(clrLightGray)+ " = " + (string)clrLightGray+"\r\n");
    FileWriteString(fileHandle, "SortedColumnHeader="+ColorToString(clrLightGray)+ " = " + (string)clrLightGray+"\r\n");
    FileWriteString(fileHandle, "EmptyCellBackground="+ColorToString(clrOldLace)+ " = " + (string)clrOldLace+"\r\n");
    FileWriteString(fileHandle, "EmptyCellText="+ColorToString(clrOldLace)+ " = " + (string)clrOldLace+"\r\n");

    m_cellColourSell = clrRed; 
    m_textColourSell = clrWhite; 
    m_cellColourBuy = clrDarkGreen;
    m_textColourBuy = clrWhite;
    m_cellColourDefault = clrWhite;
    m_textColourDefault = clrBlack;
    m_colourNone = clrNONE;
    m_colHeadersColour = C'255,244,213';
    m_colHeadersTextColour = clrBlack;
    m_rowColour = clrWhite;
    m_textColoue = clrBlack;
    m_windowBgColour = clrWhiteSmoke;
    m_windowBorderColour = clrLightSteelBlue;
    m_gridColour = clrLightGray;
    m_gridBorderColour = clrLightGray;
    m_statusBarAreaColour = clrLightGray;
    m_statusBarBorderColour = clrLightGray;
    m_sortedColumnHeader = clrLightGray;
    m_emptyCellBacground = clrOldLace;
    m_emptyCellText = clrOldLace;
    
    FileClose(fileHandle);
    
    return true;
}


void CSkin::LoadFileNames()
{
    string InpFilter=m_skinPath+"\\*.skn";
    string file_name;
    string int_dir="";

    //--- get the search handle in the root of the local folder
    long search_handle=FileFindFirst(InpFilter,file_name);

    //--- check if the FileFindFirst() is executed successfully
    if(search_handle!=INVALID_HANDLE)
    {
        //--- in a loop, check if the passed strings are the names of files or directories
        do
        {
            ResetLastError();
            
            //--- if it's a file, the function returns true, and if it's a directory, it returns error ERR_FILE_IS_DIRECTORY
            FileIsExist(int_dir+file_name);
        }
        while(FileFindNext(search_handle,file_name));
      
        //--- close the search handle
        FileFindClose(search_handle);
    }
    else
        Print("Files not found!");
}


bool CSkin::LoadData()
{
    int fileHandle=FileOpen(m_skinPath+"Default.skn", FILE_READ);
    int err = GetLastError();

    if(err == INVALID_HANDLE)
    {
        Print("Error opening "+m_skinPath+"Default.skn ");
        return false;
    }
    else
    {
        string record = "";

        while(!FileIsEnding(fileHandle))
        {
            //--- read the string
            record=FileReadString(fileHandle);
            
            string tmp[];
            
            StringSplit(record,'=',tmp);
            if(tmp[0] == "NoColour")                m_colourNone = StringToColor(tmp[1]);
            if(tmp[0] == "CellColourBuy")           m_cellColourBuy = StringToColor(tmp[1]);
            if(tmp[0] == "TextColourBuy")           m_textColourBuy = StringToColor(tmp[1]);
            if(tmp[0] == "CellColourSell")          m_cellColourSell = StringToColor(tmp[1]);
            if(tmp[0] == "TextColourSell")          m_textColourSell = StringToColor(tmp[1]);
            if(tmp[0] == "TextColourDefault")       m_textColourDefault = StringToColor(tmp[1]);
            if(tmp[0] == "CellColourDefault")       m_cellColourDefault = StringToColor(tmp[1]);
            if(tmp[0] == "ColHeadersColour")        m_colHeadersColour = StringToColor(tmp[1]);
            if(tmp[0] == "ColHeadersTextColor")     m_colHeadersTextColour = StringToColor(tmp[1]);
            if(tmp[0] == "RowColour")               m_rowColour = StringToColor(tmp[1]);
            if(tmp[0] == "WindowBackgroundColour")  m_windowBgColour = StringToColor(tmp[1]);
            if(tmp[0] == "WindowBorderColour")      m_windowBorderColour = StringToColor(tmp[1]);
            if(tmp[0] == "GridColour")              m_gridColour = StringToColor(tmp[1]);
            if(tmp[0] == "GridBorderColour")        m_gridBorderColour = StringToColor(tmp[1]);
            if(tmp[0] == "StatusBarAreaColour")     m_statusBarAreaColour = StringToColor(tmp[1]);
            if(tmp[0] == "StatusBarBorderColour")   m_statusBarBorderColour = StringToColor(tmp[1]);
            if(tmp[0] == "SortedColumnHeader")      m_sortedColumnHeader = StringToColor(tmp[1]);
            if(tmp[0] == "EmptyCellBackground")     m_emptyCellBacground = StringToColor(tmp[1]);
            if(tmp[0] == "EmptyCellText")           m_emptyCellText = StringToColor(tmp[1]);            
        }

        //--- close the file
        FileClose(fileHandle);
    }

    return true;
}



