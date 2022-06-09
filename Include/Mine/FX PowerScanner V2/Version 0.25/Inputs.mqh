/*
	Inputs.mqh
	Copyright 2022, John Skinner & Neil Prior
	https://FXCorrelator.com

    Description
    User Inputs
*/

input string   h59                                  = "------------- MN1 SETTINGS -------------"; //.
input string   h60                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodMN1          = 70;                       // Calculation Points
ENUM_APPLIED_PRICE      InpRSIPriAppliedPriceMN1    = PRICE_CLOSE;              // Calculation Price
input double            InpRSIPriUpperZoneMN1       = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneMN1       = 49.99;                    // Primary Lower Zone

input string   h70                              = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodMN1          = 70;                       // Calculation Points
input double            InpRSISecUpperZoneMN1       = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneMN1       = 49.99;                    // Secondary Lower Zone

input string   h71                                  = "------------- W1 SETTINGS -------------"; //.
input string   h72                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodW1           = 70;                       // Calculation Points
ENUM_APPLIED_PRICE      InpRSIPriAppliedPriceW1      = PRICE_CLOSE;             // Calculation Price
input double            InpRSIPriUpperZoneW1        = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneW1        = 49.99;                    // Primary Lower Zone

input string   h73                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodW1           = 70;                       // Calculation Points
input double            InpRSISecUpperZoneW1        = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneW1        = 49.99;                    // Secondary Lower Zone

input string   h74                                  = "------------- D1 SETTINGS -------------"; //.
input string   h75                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodD1           = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneD1        = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneD1        = 49.99;                    // Primary Lower Zone

input string   h76                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodD1           = 70;                       // Calculation Points
input double            InpRSISecUpperZoneD1        = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneD1        = 49.99;                    // Secondary Lower Zone

input string   h77                                  = "------------- H4 SETTINGS -------------"; //.
input string   h78                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodH4           = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneH4        = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneH4        = 49.99;                    // Primary Lower Zone

input string   h79                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodH4           = 70;                       // Calculation Points
input double            InpRSISecUpperZoneH4        = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneH4        = 49.99;                    // Secondary Lower Zone

input string   h80                                  = "------------- H1 SETTINGS -------------"; //.
input string   h81                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodH1           = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneH1        = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneH1        = 49.99;                    // Primary Lower Zone

input string   h82                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodH1           = 70;                       // Calculation Points
input double            InpRSISecUpperZoneH1        = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneH1        = 49.99;                    // Secondary Lower Zone

input string   h83                                  = "------------- M30 SETTINGS -------------"; //.
input string   h84                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodM30          = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneM30       = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneM30       = 49.99;                    // Primary Lower Zone

input string   h85                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodM30          = 70;                       // Calculation Points
input double            InpRSISecUpperZoneM30       = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneM30       = 49.99;                    // Secondary Lower Zone

input string   h86                                  = "------------- M15 SETTINGS -------------"; //.
input string   h87                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodM15          = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneM15       = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneM15       = 49.99;                    // Primary Lower Zone

input string   h88                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodM15          = 70;                       // Calculation Points
input double            InpRSISecUpperZoneM15       = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneM15       = 49.99;                    // Secondary Lower Zone

input string   h89                                  = "------------- M5 SETTINGS -------------"; //.
input string   h90                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodM5           = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneM5        = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneM5        = 49.99;                    // Primary Lower Zone

input string   h91                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodM5           = 70;                       // Calculation Points
input double            InpRSISecUpperZoneM5        = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneM5        = 49.99;                    // Secondary Lower Zone

input string   h92                                  = "------------- M1 SETTINGS -------------"; //.
input string   h93                                  = "------------- PRIMARY  -------------"; //.
input int               InpRSIPriPeriodM1           = 70;                       // Calculation Points
input double            InpRSIPriUpperZoneM1        = 50.01;                    // Primary Upper Zone
input double            InpRSIPriLowerZoneM1        = 49.99;                    // Primary Lower Zone

input string   h94                                  = "------------- SECONDARY  -------------"; //.
input int               InpRSISecPeriodM1           = 70;                       // Calculation Points
input double            InpRSISecUpperZoneM1        = 50.01;                    // Secondary Upper Zone
input double            InpRSISecLowerZoneM1        = 49.99;                    // Secondary Lower Zone

input string   h100                                 = "------------- FILTERS  -------------"; //.
input double            InpMinimumIndex             = 0.00;                     // Minimum Index Value

input string   h50                                        = "------------- GENERAL SETTINGS -------------"; //.
input string            InpTemplate                 = "";                       // Chart Template
string                  InpSymbolPrefix             = "";                       // Symbol Prefix
input string            InpSymbolSuffix             = "";                       // Symbol Suffix
string                  InpCurrencies               = "AUD,CAD,CHF,EUR,GBP,JPY,NZD,USD";    // Currencies to Use
input double            InpCSIUppeZone              = 0.00;                     // Currency Upper Zone
input double            InpCSILowerZone             = 0.00;                     // Currency Lower Zone
input int               InpStartBar                 = 0;                        // Bar to Start Calculations From 
input ENUM_APPLIED_PRICE      InpAppliedPrice       = PRICE_CLOSE;              // Calculation Price
input string            InpTimeframes               = "MN1,W1,D1,H4,H1,M30,M15,M5,M1";       // Timeframes Used


input string   h55                                  = "------------- DISPLAY SETTINGS -------------"; //.
input bool              InpDisplayRanking           = false;                    // Display Index Ranking
bool                    InpFixFirstRow              = false;                    // Fix The Grid First Row;
bool                    InpFixFirstCol              = false;                    // Fix The Grid First Col;

color                   InpFontColour               = clrSnow;                  // Font Colour
int                     InpFontSize                 = 11;                       // Font Size
input ENUM_ALIGN        InpAlignment                = ALIGNED;                  // Zone Alignment
bool                    InpHideInactive             = false;                    // Hide Symbols With no Setup

input string   h110                                 = "------------- DISPLAY COLOURS -------------"; //.
input color             InpCellColourBuy            = clrDarkGreen;             // Buy Cell Background 
input color             InpTextColourBuy            = clrWhite;                 // Buy Cell Text 
input color             InpCellColourSell           = clrRed;                   // Sell Cell Background 
input color             InpTextColourSell           = clrWhite;                 // Sell Cell Text    
input color             InpCellColourDefault        = clrOldLace;               // Cell Default Background
input color             InpTextColourDefault        = clrBlack;                 // Cell Default Text
input color             InpColHeadersColour         = clrOldLace;               // Column Header Background
input color             InpColHeadersTextColour     = clrBlack;                 // Column Header Text
input color             InpWindowBgColour           = clrWhiteSmoke;            // Window Background 
input color             InpWindowBorderColour       = clrLightSteelBlue;        // Window Border
input color             InpGridColour               = clrLightGray;             // Grid Colour
input color             InpGridBorderColour         = clrLightGray;             // Grid Border Colour
input color             InpStatusBarAreaColour      = clrLightGray;             // Status Bar Area
input color             InpStatusBarBorderColour    = clrLightGray;             // Status Bar Border
input color             InpSortedColumnHeader       = clrLightGray;             // Sorted column Header
input color             InpEmptyCellBGColour        = clrOldLace;               // Filtered Cell Background
input color             InpEmptyCellText            = clrDarkGray;              // Filtered Cell Text

