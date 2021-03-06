//+------------------------------------------------------------------+
//|                                                  gauge_graph.mqh |
//|                                         Copyright 2014, Decanium |
//|                                          http://www.decanium.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Decanium"
#property link      "http://www.decanium.com"

#include <Canvas/Canvas2.mqh>

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#define SCALE_RANGE_ANG_MIN   30  //minimum scale range in degrees
#define SCALE_RANGE_ANG_MAX   320 //maximum scale range in degrees
//---
#define DIAM_TO_NDCSL_RATIO   5   //needle center diameter (small) as percentage of the body diameter
#define DIAM_TO_NDCSB_RATIO   7.5 //needle center diameter (large) as percentage of the body diameter
//---
#define DIAM_TO_BD_SIZE_S     2 //border width (small) as percentage of the body diameter
#define DIAM_TO_BD_SIZE_B     5 //border width (large) as percentage of the body diameter
//---
#define DIAM_TO_BD_GAP_S      2.0 //space from the body border to inner elements of the gauge (small) as percentage of the body diameter
#define DIAM_TO_BD_GAP_M      3.0 //space from the body border to inner elements of the gauge (middle) as percentage of the body diameter
#define DIAM_TO_BD_GAP_L      7.0 //space from the body border to inner elements of the gauge (large) as percentage of the body diameter
//---
#define DIAM_TO_MSZ_MJ_S      3.3 //size of major scale (small) graduation as percentage of the body diameter
#define DIAM_TO_MSZ_MD_S      2.3 //size of middle scale (small) graduation as percentage of the body diameter
#define DIAM_TO_MSZ_MN_S      1.3 //size of minor scale (small) graduation as percentage of the body diameter
//---
#define DIAM_TO_MSZ_MJ_M      6.5 //size of major scale (middle) graduation as percentage of the body diameter
#define DIAM_TO_MSZ_MD_M      4.8 //size of middle scale (middle) graduation as percentage of the body diameter
#define DIAM_TO_MSZ_MN_M      3.0 //size of minor scale (middle) graduation as percentage of the body diameter
//---
#define DIAM_TO_MSZ_MJ_L      10.0 //size of major scale (large) graduation as percentage of the body diameter
#define DIAM_TO_MSZ_MD_L      7.5  //size of middle scale (large) graduation as percentage of the body diameter
#define DIAM_TO_MSZ_MN_L      5.0  //size of minor scale (large) graduation as percentage of the body diameter
//---
#define DIAM_TO_MFONT_SZ_S    4   //font size of scale (small) graduation labels as percentage of the body diameter
#define DIAM_TO_MFONT_SZ_M    6.5 //font size of scale (middle) graduation labels as percentage of the body diameter
#define DIAM_TO_MFONT_SZ_L    10  //font size of scale (large) graduation labels as percentage of the body diameter

//--- size of the buffer for scale marks
#define  MARK_BUF_SIZE  361
//--- default colors
#define DEF_COL_SCALE      clrBlack
#define DEF_COL_MARK_FONT  clrBlack
#define DEF_COL_CASE       clrMintCream
#define DEF_COL_BORDER     clrLightSteelBlue
#define DEF_COL_LAB        clrDarkGray
#define DEF_COL_NCENTER    clrLightSteelBlue
#define DEF_COL_NEEDLE     clrDimGray
//---
#define _PI     3.14159
#define _2PI    6.28318
//+------------------------------------------------------------------+
//| Size                                                             |
//+------------------------------------------------------------------+
enum ENUM_SIZE
  {
   SIZE_SMALL=0,  //small
   SIZE_MIDDLE=1, //middle
   SIZE_LARGE=2   //large
  };
//+------------------------------------------------------------------+
//| Type of anchoring to another object                              |
//+------------------------------------------------------------------+
enum ENUM_REL_MODE
  {
   RELATIVE_MODE_NONE=0, //none
   RELATIVE_MODE_HOR,    //horizontal
   RELATIVE_MODE_VERT,   //vertical
   RELATIVE_MODE_DIAG    //diagonal
  };
//+------------------------------------------------------------------+
//| Multiplier of scale labels                                       |
//+------------------------------------------------------------------+
enum ENUM_MUL_SCALE
  {
   MUL_10000=0, //x10000
   MUL_1000=1,  //x1000
   MUL_100=2,   //x100
   MUL_10=3,    //x10
   MUL_1=4,     //x1
   MUL_01=5,    //x0.1
   MUL_001=6,   //x0.01
   MUL_0001=7,  //x0.001
   MUL_00001=8  //x0.0001
  };
//+------------------------------------------------------------------+
//| Scale style                                                      |
//+------------------------------------------------------------------+
enum ENUM_SCALE_STYLE
  {
   SCALE_INNER=0, //inner
   SCALE_OUTER    //outer
  };
//+------------------------------------------------------------------+
//| Style of scale graduation                                        |
//+------------------------------------------------------------------+
enum ENUM_MARK_STYLE
  {
   MARKS_INNER=0, //inner
   MARKS_MIDDLE,  //middle
   MARKS_OUTER    //outer
  };
//+------------------------------------------------------------------+
//| Gauge body style                                                 |
//+------------------------------------------------------------------+
enum ENUM_CASE_STYLE
  {
   CASE_ROUND=1, //round
   CASE_SECTOR   //sector   
  };
//+------------------------------------------------------------------+
//| Border style                                                     |
//+------------------------------------------------------------------+
enum ENUM_CASE_BORDER_STYLE
  {
   CASE_BORDER_NONE=0, //none
   CASE_BORDER_THIN,   //thin
   CASE_BORDER_THICK   //thick
  };
//+------------------------------------------------------------------+
//| Style of the needle center                                       |
//+------------------------------------------------------------------+
enum ENUM_NCENTER_STYLE
  {//style of the needle center
   NDCS_NONE=0, //none
   NDCS_SMALL,  //small
   NDCS_LARGE   //large
  };
//+------------------------------------------------------------------+
//| Scale zero mark position                                         |
//+------------------------------------------------------------------+
enum ENUM_NULLMARK_POS
  {
   NULLMARK_NONE=0, //none
   NULLMARK_LEFT,   //left
   NULLMARK_MIDDLE, //middle
   NULLMARK_RIGHT   //right
  };
//+------------------------------------------------------------------+
//| Types of gauge labels                                            |
//+------------------------------------------------------------------+
enum ENUM_GAUGE_LEGEND
  {
   LEGEND_DESCRIPTION=0, //description
   LEGEND_UNITS,         //units
   LEGEND_MUL,           //multiplier
   LEGEND_VALUE          //value
  };
//+------------------------------------------------------------------+
//| Method of needle area fill                                       |
//+------------------------------------------------------------------+
enum ENUM_NEEDLE_FILL
  {
   NEEDLE_FILL=0,    //fill
   NEEDLE_FILL_AA,   //fill with AA
   NEEDLE_NOFILL_AA, //no fill
  };
//+------------------------------------------------------------------+
//| Structure of a circle                                            |
//+------------------------------------------------------------------+
struct CIRC_STR
  {
   int               x;     //center X coordinate 
   int               y;     //center Y coordinate 
   int               r;     //radius 
   color             c;     //color
   bool              disp;  //flag - whether to display
  };
//+------------------------------------------------------------------+
//| Structure of an arc                                              |
//+------------------------------------------------------------------+
struct ARC_STR
  {
   int               x;     //X coordinate of the arc center
   int               y;     //Y coordinate of the arc center
   int               r;     //arc radius
   double            fi0;   //angular coordinates of the arc beginning (radians)
   double            fi1;   //angular coordinates of the arc end (radians)   
   color             c;     //color
   bool              disp;  //flag - whether to display
  };
//+------------------------------------------------------------------+
//| Structure of a straight line                                     |
//+------------------------------------------------------------------+
struct LINE_STR
  {
   int               x1; //X1 coordinate
   int               y1; //Y1 coordinate
   int               x2; //X2 coordinate 
   int               y2; //Y2 coordinate 
   color             c;  //color
  };
//+------------------------------------------------------------------+
//| Structure of a dot                                               |
//+------------------------------------------------------------------+
struct DOT_STR
  {
   int               x;  //X1 coordinate
   int               y;  //Y1 coordinate
   color             c;  //color
  };
//+------------------------------------------------------------------+
//| Structure of a sector                                            |
//+------------------------------------------------------------------+
struct PIE_STR
  {
   int               x;    //center coordinates
   int               y;    //center coordinates
   int               r;    //radius
   int               re;   //radius for erasing
   double            fi0;  //angular coordinates of the arc beginning (radians)
   double            fi1;  //angular coordinates of the arc end (radians)   
   double            fi0e; //angular coordinates of the arc beginning (radians) - for erasing
   double            fi1e; //angular coordinates of the arc end (radians) - for erasing
   color             c;    //color   
   color             ce;   //color for erasing
  };
//+------------------------------------------------------------------+
//| Structure of a highlighted range                                 |
//+------------------------------------------------------------------+
struct RANGE_STR
  {
   bool              active;  //whether to draw
   double            st_val;  //range beginning
   double            end_val; //range end
   color             c;       //color
   PIE_STR           p;       //sector
  };
//+------------------------------------------------------------------+
//| Structure of the gauge body                                      |
//+------------------------------------------------------------------+
struct CASE_STR
  {
   bool              disp;  //flag - whether to display  
   //--- for circular-shaped bodies:
   CIRC_STR          circ;  //
   //--- for bodies of a sector type:
   int               mode;  //body type (0 - for angles <=180, 1 - for angles >180)
   ARC_STR           arc11; //arc around the scale (main)
   ARC_STR           arc12; //arc around the scale (supplementary)
   ARC_STR           arc2;  //arc around the needle center (not available for scale angles >180)
   ARC_STR           arc3;  //rounding off on the left
   ARC_STR           arc4;  //rounding off on the right   
   LINE_STR          line1; //connective section on the left (connective section for scale angles >180)
   LINE_STR          line2; //connective section on the right (not used for connective section for scale angles >180)
   DOT_STR           fdot;  //filling dot coordinates
  };
//+------------------------------------------------------------------+
//| Structure of scale graduation                                    |
//+------------------------------------------------------------------+
struct SCALE_MARKS_STR
  {
   double            left_value;   //minimum value of the displayed variable
   double            right_value;  //maximum value of the displayed variable
   double            range_value;  //value range of the displayed variable
   bool              dir_forward;  //true - values grow from left to right, false - values lower
   ENUM_NULLMARK_POS nullmark;     //zero mark position
   double            nullmark_ang; //zero mark coordinates
   int               digits;       //number of decimal places in graduation marks
   //---
   int               major_len;    //length of large graduation
   int               middle_len;   //length of middle graduation
   int               minor_len;    //length of small graduation
   //---
   double            min_fi;       //angle corresponding to left_value
   double            max_fi;       //angle corresponding to right_value
   double            range_fi;     //angle of the scale range
   //---
   double            mul;          //multiplier of scale values
   string            name;         //gauge name (description of a displayed variable)
   string            value;        //current value
   string            units;        //units of measure
   //---
   int               mfont_size;   //font size of graduation labels
   string            mfont_font;   //font of graduation labels
   uint              mfont_flags;  //graduation label font flag
   int               mfont_gap;    //space from graduation to a mark
  };
//+------------------------------------------------------------------+
//| Structure of text label size                                     |
//+------------------------------------------------------------------+
struct LAB_AREA_SIZE_STR
  {
   int               h;   //height
   int               l;   //width
   int               d;   //diagonal
  };
//+------------------------------------------------------------------+
//| Structure of legend parameters                                   |
//+------------------------------------------------------------------+
struct GAUGE_LEGEND_PAR_STR
  {
   bool              enable;    //show the legend
   string            str;       //displayed string or a complementary parameter
   uint              radius;    //radius expressed in terms of the number of the position between the needle and the scale
   double            angle;     //angular coordinates of the legend
   uint              font_size; //font size in conditional units
   string            font_font; //font
   bool              italic;    //italic
   bool              bold;      //bold
   color             col;       //color
  };
//+------------------------------------------------------------------+
//| Structure of the legend                                          |
//+------------------------------------------------------------------+
struct GAUGE_LEGEND_STRING_STR
  {
   string            str;        //string (only for description and units)
   int               r;          //radius (distance from the gauge center to the end point of the legend)
   double            a;          //angle (shift of the legend in relation to the scale center)
   int               font_size;  //font size 
   string            font_font;  //legend font (if absent, the legend is not drawn)
   uint              font_flags; //font flags    
   color             col;        //color
   color             bgcol;      //background color (for values being updating)
   uint              digits;     //number of decimal places (for value)
   //--- coordinates; calculated basing of "r" and "a":
   uint              x;
   uint              y;
   bool              draw; //whether to draw
  };
//+------------------------------------------------------------------+
//| Structure of gauge labels                                        |
//+------------------------------------------------------------------+
struct GAUGE_LABEL_STR
  {
   GAUGE_LEGEND_STRING_STR descr; //description
   GAUGE_LEGEND_STRING_STR unit;  //units of measure
   GAUGE_LEGEND_STRING_STR mul;   //multiplier (not drawn if the multiplier is 1)
   GAUGE_LEGEND_STRING_STR val;   //current value
  };
//+------------------------------------------------------------------+
//| Structure of the scale layer                                     |
//+------------------------------------------------------------------+
struct SCALE_LAYER_STR
  {
   string            ObjName;
   CCanvas           canvas;
   uchar             transparency;
   color             c;
   CASE_STR          c_ext;        //external line of the gauge body
   int               border_size;  //space between internal and external lines of the gauge body
   CASE_STR          c_int;        //internal line of the gauge body
   int               border_gap;   //space between the edge of the body and the gauge elements
   int               outlab_area;  //area to place text notes to labels outside the scale
   int               ol_scale_gap; //space between the outlab area and the scale line
   ARC_STR           scale;        //scale line (all the rest is created relatively to its center)
   int               il_scale_gap; //space between the inlab area and the scale line
   int               inlab_area;   //area to place text notes to labels inside the scale
   SCALE_MARKS_STR   sm;           //scale marks
   GAUGE_LABEL_STR   gl;           //gauge label (purpose, dimension, multiplier, current value)
   //--- ranges:
   RANGE_STR         rng[4];
  };
//+------------------------------------------------------------------+
//| Structure of the needle                                          |
//+------------------------------------------------------------------+
struct NEEDLE_STR
  {
   int               r;   //radius (from center to edge)
   int               r2;  //inverse radius (from center to tail)
   //--- coordinates
   int               x[4];
   int               y[4];
   ENUM_NEEDLE_FILL  fill;
   //--- color
   color             c;
  };
//+------------------------------------------------------------------+
//| Structure of the needle layer                                    |
//+------------------------------------------------------------------+
struct NEEDLE_LAYER_STR
  {
   string            ObjName;
   CCanvas           canvas;
   uchar             transparency;
   //
   ARC_STR           ncenter; //needle center
   NEEDLE_STR        needle;  //needle
  };
//+------------------------------------------------------------------+
//| Structure of highlighted range parameters                        |
//+------------------------------------------------------------------+
struct RANGE_PAR_STR
  {
   bool              enable;
   double            start;
   double            end;
   color             c;
  };
//+------------------------------------------------------------------+
//| Structure of gauge parameters                                    |
//+------------------------------------------------------------------+
struct GAUGE_INP_PAR_STR
  {
   //--- main
   int               x;        //horizontal indent from the anchor point
   int               y;        //vertical indent from the anchor point
   ENUM_BASE_CORNER  corner;   //chart corner where the object is anchored
   ENUM_REL_MODE     rel_mode; //mode of positioning relatively to another object
   string            ObjRel;   //name of the object relatively to which position is determined
   //--- scale
   int               scale_range_angle; //range of scale angles
   int               rotation;          //angle of rotation
   color             scale_col;         //scale color
   ENUM_SCALE_STYLE  scale_style;       //scale style (inside and outside scale)
   bool              scale_disp_arc;    //display the line (arc) of the scale
   double            min_value;         //minimum scale value
   double            max_value;         //maximum scale value
   ENUM_MUL_SCALE    mul_scale;         //multiplier of scale labels
   //--- marks on the scale
   ENUM_MARK_STYLE   mark_style;    //style (position) of scale marks
   ENUM_SIZE         mark_size;     //size of scale marks
   double            major_tmi;     //major tick mark interval
   int               middle_tmarks; //middle tick marks - per one major interval
   int               minor_tmarks;  //minor tick marks - per one interval of middle or major marks (if there are no middle ones)
   ENUM_SIZE         mfont_size;    //font size of graduation labels
   string            mfont_font;    //font of graduation labels
   color             mfont_color;   //font color 
   bool              mfont_italic;  //italic
   bool              mfont_bold;    //bold
   //--- highlighted ranges
   RANGE_PAR_STR     rng[4];
   //--- gauge body
   ENUM_CASE_STYLE   case_style;        //body style (circle or sector)
   color             case_color;        //body color
   ENUM_CASE_BORDER_STYLE border_style; //border style
   color             border_color;      //body color
   ENUM_SIZE         border_gap_size;   //space from the border
   //--- legends   
   GAUGE_LEGEND_PAR_STR descr;    //gauge description
   GAUGE_LEGEND_PAR_STR unit;     //units of measure
   GAUGE_LEGEND_PAR_STR mul;      //scale multiplier
   GAUGE_LEGEND_PAR_STR val;      //current value
   //--- needle
   ENUM_NCENTER_STYLE ncenter_style; //needle center style
   color             ncenter_col;    //needle center color   
   color             needle_col;     //needle color
   ENUM_NEEDLE_FILL  needle_fill;    //filled needle
  };
//+------------------------------------------------------------------+
//| Structure of the gauge                                           |
//+------------------------------------------------------------------+
struct GAUGE_STR
  {
   //--- input parameters:
   GAUGE_INP_PAR_STR par;
   //--- designed parameters:
   int               rel_x;   //edge of another object relatively to which the position is set
   int               rel_y;   //edge of another object relatively to which the position is set
   int               Cx;      //center coordinates (horizontal indent)
   int               Cy;      //center coordinated (vertical indent)
   int               R;       //radius
   SCALE_LAYER_STR   s_layer; //scale layer
   NEEDLE_LAYER_STR  n_layer; //needle layer
   double            value;   //displayed value
   bool              init_ok; //initialization complete
  };
//+------------------------------------------------------------------+
//| Gets the specified percentages of the v variable                 |
//+------------------------------------------------------------------+
double GetPercent(double v,double p)
  {
   return((v*p)/100);
  }
//+------------------------------------------------------------------+
//| Converts degrees to radians                                      |
//+------------------------------------------------------------------+
double DegToRad(double deg)
  {
   return((_PI*deg)/180);
  }
//+------------------------------------------------------------------+
//| Converts fi to the range 0<=fi<=_2PI                             |
//+------------------------------------------------------------------+
double NormRad(double fi)
  {
   if(fi>_2PI)
      fi=fi-int(fi/_2PI)*_2PI;
   if(fi<0)
      fi=_2PI+(fi-int(fi/_2PI)*_2PI);
   return(fi);
  }
//+------------------------------------------------------------------+
//| Creates the gauge                                                |
//+------------------------------------------------------------------+
bool GaugeCreate(string name,GAUGE_STR &g,int x,int y,int size,
                 string ObjRel,ENUM_REL_MODE rel_mode,ENUM_BASE_CORNER corner,bool back,
                 uchar scale_transparency,uchar needle_transparency)
  {
   g.init_ok=false;
   g.R=size/2;
   g.par.x = x;
   g.par.y = y;
   g.par.corner=corner;
   g.par.rel_mode=rel_mode;
   g.par.ObjRel=ObjRel;
   GaugeCalcLocation(g);//
   int wh=(g.R+5)*2;
//--- scale layer
   g.s_layer.ObjName=name+"_s";
   ObjectDelete(0,g.s_layer.ObjName);//scale
   if(g.s_layer.canvas.CreateBitmapLabel(g.s_layer.ObjName,g.Cx,g.Cy,wh,wh,COLOR_FORMAT_ARGB_NORMALIZE)==false)
      return(false);
   ObjectSetInteger(0,g.s_layer.ObjName,OBJPROP_CORNER,g.par.corner);
   ObjectSetInteger(0,g.s_layer.ObjName,OBJPROP_ANCHOR,ANCHOR_CENTER);
   ObjectSetInteger(0,g.s_layer.ObjName,OBJPROP_BACK, back);
//--- needle layer
   g.n_layer.ObjName=name+"_n";
   ObjectDelete(0,g.n_layer.ObjName);//needle
   if(g.n_layer.canvas.CreateBitmapLabel(g.n_layer.ObjName,g.Cx,g.Cy,wh,wh,COLOR_FORMAT_ARGB_NORMALIZE)==false)
      return(false);
   ObjectSetInteger(0,g.n_layer.ObjName,OBJPROP_CORNER,g.par.corner);
   ObjectSetInteger(0,g.n_layer.ObjName,OBJPROP_ANCHOR,ANCHOR_CENTER);
   ObjectSetInteger(0,g.n_layer.ObjName,OBJPROP_BACK, back);
//--- setting default parameters
   GaugeSetDefaults(g);
   g.s_layer.transparency = 255 - scale_transparency;
   g.n_layer.transparency = 255 - needle_transparency;
//---    
   return(true);
  }
//+------------------------------------------------------------------+
//| Sets default parameters                                          |
//+------------------------------------------------------------------+
void GaugeSetDefaults(GAUGE_STR &g)
  {
//--- body, scale, marks  
   GaugeSetScaleParameters(g,300,0,-100,100,MUL_1,SCALE_INNER,DEF_COL_SCALE);
   GaugeSetMarkParameters(g,MARKS_INNER,SIZE_MIDDLE,20,1,9);
   GaugeSetMarkLabelFont(g,SIZE_MIDDLE,"Arial",false,false);
   GaugeSetCaseParameters(g,CASE_ROUND,DEF_COL_CASE,CASE_BORDER_THIN,DEF_COL_BORDER,SIZE_MIDDLE);
//--- legends
   GaugeSetLegendParameters(g,LEGEND_DESCRIPTION,true,"Gauge",3,180,16,"Arial",false,false);
   GaugeSetLegendParameters(g,LEGEND_UNITS,false,"",0,0,0,"",false,false);
   GaugeSetLegendParameters(g,LEGEND_MUL,false,"",0,0,0,"",false,false);
   GaugeSetLegendParameters(g,LEGEND_VALUE,false,"",0,0,0,"",false,false);
//--- ranges of highlighted values                                                                         
   GaugeSetRangeParameters(g,0,false,0,0,DEF_COL_CASE);
   GaugeSetRangeParameters(g,1,false,0,0,DEF_COL_CASE);
   GaugeSetRangeParameters(g,2,false,0,0,DEF_COL_CASE);
   GaugeSetRangeParameters(g,3,false,0,0,DEF_COL_CASE);
//--- needle
   GaugeSetNeedleParameters(g,NDCS_SMALL,DEF_COL_NCENTER,DEF_COL_NEEDLE,NEEDLE_FILL_AA);
  }
//+------------------------------------------------------------------+
//| Gets coordinates of an object relatively to which                |
//| the position is set                                              |
//+------------------------------------------------------------------+ 
bool GaugeGetRelXY(string ObjRel,ENUM_BASE_CORNER corner,int &cx,int &cy,int &x,int &y,int &r)
  {
   if(ObjRel=="")
      return(false);
   ObjRel+="_s";//scale layer
   if(ObjectFind(0,ObjRel)!=0)
      return(false);
   long result;
   if(ObjectGetInteger(0,ObjRel,OBJPROP_CORNER,0,result)==false)
      return(false);
   if(corner!=ENUM_BASE_CORNER(result))
      return(false);
   int rel_x=0,rel_y=0;
   if(ObjectGetInteger(0,ObjRel,OBJPROP_XDISTANCE,0,result)==false)
      return(false);
   cx=int(result);//X coordinate of the object center
   if(ObjectGetInteger(0,ObjRel,OBJPROP_XSIZE,0,result)==false)
      return(false);
   r=int(result/2);
   rel_x=cx+int(result/2);
   if(ObjectGetInteger(0,ObjRel,OBJPROP_YDISTANCE,0,result)==false)
      return(false);
   cy=int(result);//Y coordinate of the object center
   if(ObjectGetInteger(0,ObjRel,OBJPROP_YSIZE,0,result)==false)
      return(false);
   rel_y=cy+int(result/2);
//---
   x = rel_x;
   y = rel_y;
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting scale parameters                                         |
//+------------------------------------------------------------------+
void GaugeSetScaleParameters(GAUGE_STR &g,int range,int rotation,double min,double max,
                             ENUM_MUL_SCALE mul,ENUM_SCALE_STYLE style,color col,bool display_arc=false)
  {
   g.par.scale_range_angle=range;
   g.par.rotation=rotation;
   g.par.min_value = min;
   g.par.max_value = max;
   g.par.mul_scale = mul;
   g.par.scale_style=style;
   g.par.scale_col=col;
   g.par.scale_disp_arc=display_arc;
  }
//+------------------------------------------------------------------+
//| Setting scale graduation parameters                              |
//+------------------------------------------------------------------+
void GaugeSetMarkParameters(GAUGE_STR &g,ENUM_MARK_STYLE style,ENUM_SIZE size,
                            double major_tmi,int middle_tmarks,int minor_tmarks)
  {
   g.par.mark_style= style;
   g.par.mark_size = size;
   g.par.major_tmi = major_tmi;
   g.par.middle_tmarks= middle_tmarks;
   g.par.minor_tmarks = minor_tmarks;
  }
//+------------------------------------------------------------------+
//| Setting font of graduation labels                                |
//+------------------------------------------------------------------+
void GaugeSetMarkLabelFont(GAUGE_STR &g,ENUM_SIZE font_size,string font,
                           bool italic,bool bold,color col=DEF_COL_MARK_FONT)
  {
   g.par.mfont_size = font_size;
   g.par.mfont_font = font;
   g.par.mfont_italic=italic;
   g.par.mfont_bold=bold;
   g.par.mfont_color=col;
  }
//+------------------------------------------------------------------+
//| Setting gauge body parameters                                    |
//+------------------------------------------------------------------+
void GaugeSetCaseParameters(GAUGE_STR &g,ENUM_CASE_STYLE style,color ccol,
                            ENUM_CASE_BORDER_STYLE bstyle,color bcol,ENUM_SIZE border_gap_size)
  {
   g.par.case_style = style;
   g.par.case_color = ccol;
   g.par.border_style = bstyle;
   g.par.border_color = bcol;
   g.par.border_gap_size=border_gap_size;
  }
//+------------------------------------------------------------------+
//| Setting legend parameters                                        |
//+------------------------------------------------------------------+
void GaugeSetLegendParameters(GAUGE_STR &g,ENUM_GAUGE_LEGEND gl,bool enable,
                             string str,int radius,double angle,
                             uint font_size,string font,bool italic,bool bold,color col=DEF_COL_LAB)
  {
   switch(gl)
     {
      case LEGEND_DESCRIPTION:
         GaugeSetLegendPar(g.par.descr,enable,str,radius,angle,font_size,font,italic,bold,col);
         break;
      case LEGEND_UNITS:
         GaugeSetLegendPar(g.par.unit,enable,str,radius,angle,font_size,font,italic,bold,col);
         break;
      case LEGEND_MUL:
         GaugeSetLegendPar(g.par.mul,enable,str,radius,angle,font_size,font,italic,bold,col);
         break;
      case LEGEND_VALUE:
         GaugeSetLegendPar(g.par.val,enable,str,radius,angle,font_size,font,italic,bold,col);
         break;
     }
  }
//+------------------------------------------------------------------+
//| Setting legend parameters                                        |
//+------------------------------------------------------------------+
void GaugeSetLegendPar(GAUGE_LEGEND_PAR_STR &gl,bool enable,
                       string str,int radius,double angle,
                       uint font_size,string font,bool italic,bool bold,color col=DEF_COL_LAB)
  {
   gl.enable=enable;
   gl.str=str;
   gl.radius= radius;
   gl.angle = angle;
   gl.font_size = font_size;
   gl.font_font = font;
   gl.italic=italic;
   gl.bold= bold;
   gl.col = col;
  }
//+------------------------------------------------------------------+
//| Setting highlighted range parameters                             |
//+------------------------------------------------------------------+
void GaugeSetRangeParameters(GAUGE_STR &g,int index,bool enable,
                             double start,double end,color col)
  {
   if(index>=0 && index<4)
     {
      g.par.rng[index].enable= enable;
      g.par.rng[index].start = start;
      g.par.rng[index].end=end;
      g.par.rng[index].c=col;
     }
  }
//+------------------------------------------------------------------+
//| Setting needle parameters                                        |
//+------------------------------------------------------------------+
void GaugeSetNeedleParameters(GAUGE_STR &g,ENUM_NCENTER_STYLE ncenter_style,
                              color ncenter_col,color needle_col,ENUM_NEEDLE_FILL needle_fill)
  {
   g.par.ncenter_style=ncenter_style;
   g.par.ncenter_col= ncenter_col;
   g.par.needle_col = needle_col;
   g.par.needle_fill= needle_fill;
  }
//+------------------------------------------------------------------+
//| Relocation of objects (scale layer and needle layer)             |
//+------------------------------------------------------------------+
void GaugeRelocation(GAUGE_STR &g)
  {
   ObjectSetInteger(0,g.s_layer.ObjName,OBJPROP_XDISTANCE,long(g.Cx));
   ObjectSetInteger(0,g.s_layer.ObjName,OBJPROP_YDISTANCE,long(g.Cy));
   ObjectSetInteger(0,g.n_layer.ObjName,OBJPROP_XDISTANCE,long(g.Cx));
   ObjectSetInteger(0,g.n_layer.ObjName,OBJPROP_YDISTANCE,long(g.Cy));
  }
//+------------------------------------------------------------------+
//| Redrawing the gauge                                              |
//+------------------------------------------------------------------+
void GaugeRedraw(GAUGE_STR &g)
  {
   GaugeDraw(g.s_layer,g.n_layer,g.par,g.R);
   g.init_ok=true;
  }
//+------------------------------------------------------------------+
//| Redraws the scale and the needle                                 |
//+------------------------------------------------------------------+  
void GaugeDraw(SCALE_LAYER_STR &s,NEEDLE_LAYER_STR &n,GAUGE_INP_PAR_STR &p,int R)
  {
   double d=R*2;
//--- size of graduation marks
   switch(p.mark_size)
     {
      case SIZE_SMALL:
         s.sm.major_len  = (int)GetPercent(d, DIAM_TO_MSZ_MJ_S);
         s.sm.middle_len = (int)GetPercent(d, DIAM_TO_MSZ_MD_S);
         s.sm.minor_len  = (int)GetPercent(d, DIAM_TO_MSZ_MN_S);
         break;
      case SIZE_LARGE:
         s.sm.major_len  = (int)GetPercent(d, DIAM_TO_MSZ_MJ_L);
         s.sm.middle_len = (int)GetPercent(d, DIAM_TO_MSZ_MD_L);
         s.sm.minor_len  = (int)GetPercent(d, DIAM_TO_MSZ_MN_L);
         break;
      default:
         s.sm.major_len  = (int)GetPercent(d, DIAM_TO_MSZ_MJ_M);
         s.sm.middle_len = (int)GetPercent(d, DIAM_TO_MSZ_MD_M);
         s.sm.minor_len  = (int)GetPercent(d, DIAM_TO_MSZ_MN_M);
     }
//--- font of graduation marks
   s.sm.mfont_font=p.mfont_font;
   if(p.mfont_italic==true)
      s.sm.mfont_flags=FONT_ITALIC;
   else
      s.sm.mfont_flags=0;
   if(p.mfont_bold==true)
      s.sm.mfont_flags|=FW_BOLD;
//--- font size   
   if(p.mfont_size==SIZE_SMALL)
      s.sm.mfont_size=(int)GetPercent(d,DIAM_TO_MFONT_SZ_S);
   else if(p.mfont_size==SIZE_LARGE)
      s.sm.mfont_size=(int)GetPercent(d,DIAM_TO_MFONT_SZ_L);
   else
      s.sm.mfont_size=(int)GetPercent(d,DIAM_TO_MFONT_SZ_M);
//--- calculation of space for the stated font of graduation labels
   int max_len_str= get_max_len_str(p.min_value,p.max_value,p.major_tmi,p.mul_scale);
   s.sm.mfont_gap = get_mfont_gap(s.sm,max_len_str);
//--- now we can calculate width of the area for graduation labels
   s.outlab_area= 0;
   s.inlab_area = 0;
   if(p.scale_style==SCALE_INNER)
      get_marklabarea_size(s.inlab_area,s.sm,max_len_str);  //labels outside the scale
   else
      get_marklabarea_size(s.outlab_area,s.sm,max_len_str); //labels inside the scale
//--- border size
   if(p.border_style==CASE_BORDER_THIN)
      s.border_size = (int)GetPercent(d, DIAM_TO_BD_SIZE_S);
   else if(p.border_style==CASE_BORDER_THICK)
      s.border_size=(int)GetPercent(d,DIAM_TO_BD_SIZE_B);
   else
      s.border_size=0;
//--- space between the border and inner elements
   if(p.border_gap_size==SIZE_SMALL)
      s.border_gap=(int)GetPercent(d,DIAM_TO_BD_GAP_S);
   else if(p.border_gap_size==SIZE_LARGE)
      s.border_gap=(int)GetPercent(d,DIAM_TO_BD_GAP_L);
   else
      s.border_gap=(int)GetPercent(d,DIAM_TO_BD_GAP_M);
//--- space between the outlab area and the scale line
   if(p.mark_style==MARKS_INNER)
      s.ol_scale_gap=0;//scale aligns with the outlab area edge
   else if(p.mark_style==MARKS_OUTER)
      s.ol_scale_gap=s.sm.major_len;//indent equal to the major tick mark width
   else
      s.ol_scale_gap=s.sm.major_len/2;//indent equal to the half of the major tick mark width   
//--- space between the inlab area and the scale line
   if(p.mark_style==MARKS_INNER)
      s.il_scale_gap=s.sm.major_len;//indent equal to the major tick mark width
   else if(p.mark_style==MARKS_OUTER)
      s.il_scale_gap=0;//scale aligns with the outlab area edge
   else
      s.il_scale_gap=s.sm.major_len/2;//indent equal to the half of the major tick mark width
//--- checking scale edges
   if(p.scale_range_angle<SCALE_RANGE_ANG_MIN)
      p.scale_range_angle=SCALE_RANGE_ANG_MIN;
   if(p.scale_range_angle>SCALE_RANGE_ANG_MAX)
      p.scale_range_angle=SCALE_RANGE_ANG_MAX;
//--- angular coordinates of scale elements
   int ang=p.scale_range_angle/2;//getting the half of the scale range
   int start_ang=90+ang+p.rotation;
   int end_ang=90-ang+p.rotation;
   s.scale.x = R+5;
   s.scale.y = R+5;
   s.scale.r = R-(s.border_size+s.border_gap+s.outlab_area+s.ol_scale_gap);
   s.scale.fi0=NormRad(DegToRad(end_ang));//left
   s.scale.fi1=NormRad(DegToRad(start_ang)-0.0001);//right
   s.scale.c=p.scale_col;
//--- drawing the needle
   if(p.ncenter_style==NDCS_NONE)
     {
      n.ncenter.r=(int)GetPercent(d,DIAM_TO_NDCSL_RATIO);
      n.ncenter.disp=false;
     }
   else if(p.ncenter_style==NDCS_SMALL)
     {
      n.ncenter.r=(int)GetPercent(d,DIAM_TO_NDCSL_RATIO);
      n.ncenter.disp=true;
     }
   else if(p.ncenter_style==NDCS_LARGE)
     {
      n.ncenter.r=(int)GetPercent(d,DIAM_TO_NDCSB_RATIO);
      n.ncenter.disp=true;
     }
   n.ncenter.x = s.scale.x;
   n.ncenter.y = s.scale.y;
   n.ncenter.c = p.ncenter_col;
//--- calculation of legend location
   int gl_r1=R -(s.border_size+s.border_gap);//maximum radius
   int gl_r0=n.ncenter.r;//minimum radius
   int gl_dr= gl_r1 - gl_r0;
   GaugeSetGLPars(s.gl.descr,p.descr,gl_r0, gl_dr);//description
   GaugeSetGLPars(s.gl.unit, p.unit, gl_r0, gl_dr);//units of measure
   GaugeSetGLPars(s.gl.mul, p.mul, gl_r0, gl_dr);//multiplier
   GaugeSetGLPars(s.gl.val, p.val, gl_r0, gl_dr);//current value
//--- calculation of body elements 
   if(p.case_style==CASE_ROUND)
     {//in case of a circle body
      if(s.border_size>0)
        {//if there is a border
         s.c_ext.circ.x = s.scale.x;
         s.c_ext.circ.y = s.scale.y;
         s.c_ext.circ.r = R;
         s.c_ext.circ.c = p.border_color;
         s.c_ext.disp=true;
        }
      else
         s.c_ext.disp=false;
      s.c_int.circ.x = s.scale.x;
      s.c_int.circ.y = s.scale.y;
      s.c_int.circ.r = R-s.border_size;
      s.c_int.circ.c = p.case_color;
      s.c_int.disp=true;
     }
   else if(p.case_style==CASE_SECTOR)
     {
      int b=s.ol_scale_gap+s.outlab_area+s.border_gap;
      if(s.border_size>0)
        {
         case_sector_calc(s.c_ext,s.scale,n.ncenter,s.scale.x,s.scale.y,
                          b+s.border_size,p.border_color,p.border_color);
         s.c_ext.disp=true;
        }
      else
         s.c_ext.disp=false;
      case_sector_calc(s.c_int,s.scale,n.ncenter,s.scale.x,s.scale.y,
                       b,p.case_color,p.case_color);
      s.c_int.disp=true;
     }
   else
      return;
//--- drawing the body
   s.c=p.case_color;
   if(p.case_style==CASE_ROUND)
     {
      if(s.c_ext.disp==true)
         s.canvas.FillCircle(  s.c_ext.circ.x, s.c_ext.circ.y, s.c_ext.circ.r,
                             ColorToARGB(s.c_ext.circ.c,s.transparency));
      if(s.c_int.disp==true)
         s.canvas.FillCircle(  s.c_int.circ.x, s.c_int.circ.y, s.c_int.circ.r,
                             ColorToARGB(s.c_int.circ.c,s.transparency));
     }
   else
     {
      if(s.c_ext.disp==true)
         redraw_sector_case(s,s.c_ext);
      if(s.c_int.disp==true)
         redraw_sector_case(s,s.c_int);
     }
//--- drawing the scale
   if(p.scale_disp_arc==true)
      s.canvas.Arc(s.scale.x, s.scale.y, s.scale.r, s.scale.r,
                   s.scale.fi0,s.scale.fi1,ColorToARGB(s.scale.c,s.transparency));
//--- drawing scale marks
   redraw_marks(s,s.c_int,s.scale,s.sm,p,s.border_gap);
//--- drawing legends
   gl_calc_and_draw(s,p);
//--- calculation of needle elements
   needle_calc(n,s,p);
//---
   s.canvas.Update(true);
   n.canvas.Update(true);
  }
//+------------------------------------------------------------------+
//| Calculation of needle elements                                   |
//+------------------------------------------------------------------+
void needle_calc(NEEDLE_LAYER_STR &n,SCALE_LAYER_STR &s,GAUGE_INP_PAR_STR &p)
  {
//--- getting the needle length
   int r0=0,r1=0;
   if(p.minor_tmarks>0)
      calc_r0r1(r0,r1,s.scale.r,s.sm.minor_len,p.mark_style);
   else if(p.middle_tmarks>0)
      calc_r0r1(r0,r1,s.scale.r,s.sm.middle_len,p.mark_style);
   else if(p.major_tmi>0)
      calc_r0r1(r0,r1,s.scale.r,s.sm.major_len,p.mark_style);
   n.needle.r=r1;
//--- color and method of filling
   n.needle.c=p.needle_col;
   n.needle.fill=p.needle_fill;
//--- tail length is equal to the needle center radius
   n.needle.r2=n.ncenter.r*2;
  }
//+------------------------------------------------------------------+
//| Redrawing the needle                                             |
//+------------------------------------------------------------------+
void redraw_needle(SCALE_LAYER_STR &s,NEEDLE_LAYER_STR  &n,SCALE_MARKS_STR &sm,double value)
  {
   int x,y,r;
   n.canvas.Erase();
   double val=0;
//--- calculating location
   if(sm.left_value<sm.right_value)
     {//direct order of scale marks
      if(value<sm.left_value)
         value=sm.left_value;
      if(value>sm.right_value)
         value=sm.right_value;
      val=value-sm.left_value;
     }
   else
     {//inverse order of scale marks
      if(value>sm.left_value)
         value=sm.left_value;
      if(value<sm.right_value)
         value=sm.right_value;
      val=sm.left_value-value;
     }
   if(sm.range_value==0)
      return;
   double a=NormRad(sm.min_fi-((val*sm.range_fi)/sm.range_value));//angle of the current needle position
   n.needle.x[0] = (int)(s.scale.x-n.needle.r*MathCos(_PI-a));
   n.needle.y[0] = (int)(s.scale.y-n.needle.r*MathSin(_PI-a));
//--- drawing
   if(n.needle.fill==NEEDLE_FILL)
     {
      x = (int)(s.scale.x-n.needle.r2*MathCos(2*_PI-a));
      y = (int)(s.scale.y-n.needle.r2*MathSin(2*_PI-a));
      r=n.needle.r2/4;
      n.needle.x[1] = (int)(x-r*MathCos(0.5*_PI-a));
      n.needle.y[1] = (int)(y-r*MathSin(0.5*_PI-a));
      n.needle.x[2] = (int)(x-r*MathCos(1.5*_PI-a));
      n.needle.y[2] = (int)(y-r*MathSin(1.5*_PI-a));
      n.canvas.FillTriangle(n.needle.x[0],n.needle.y[0],n.needle.x[1],n.needle.y[1],n.needle.x[2],n.needle.y[2],ColorToARGB(n.needle.c, n.transparency));
      n.canvas.LineAA2(x, y, n.needle.x[0], n.needle.y[0], ColorToARGB(n.needle.c, n.transparency));
     }
   else if(n.needle.fill==NEEDLE_FILL_AA || n.needle.fill==NEEDLE_NOFILL_AA)
     {
      double db_x,db_y;
      double db_xbuf[3];
      double db_ybuf[3];
      db_xbuf[0] = s.scale.x-n.needle.r*MathCos(_PI-a);
      db_ybuf[0] = s.scale.y-n.needle.r*MathSin(_PI-a);
      db_x = s.scale.x-n.needle.r2*MathCos(2*_PI-a);
      db_y = s.scale.y-n.needle.r2*MathSin(2*_PI-a);
      r=n.needle.r2/4;
      db_xbuf[1] = db_x-r*MathCos(0.5*_PI-a);
      db_ybuf[1] = db_y-r*MathSin(0.5*_PI-a);
      db_xbuf[2] = db_x-r*MathCos(1.5*_PI-a);
      db_ybuf[2] = db_y-r*MathSin(1.5*_PI-a);
      if(n.needle.fill==NEEDLE_NOFILL_AA)
        {
         n.canvas.LineAA2(db_xbuf[0], db_ybuf[0], db_xbuf[1], db_ybuf[1], ColorToARGB(n.needle.c, n.transparency));
         n.canvas.LineAA2(db_xbuf[1], db_ybuf[1], db_xbuf[2], db_ybuf[2], ColorToARGB(n.needle.c, n.transparency));
         n.canvas.LineAA2(db_xbuf[2], db_ybuf[2], db_xbuf[0], db_ybuf[0], ColorToARGB(n.needle.c, n.transparency));
        }
      else
        {
         n.canvas.Fill(10, 10, ColorToARGB(n.needle.c, n.transparency));
         n.canvas.LineAA2(db_xbuf[0], db_ybuf[0], db_xbuf[1], db_ybuf[1], 0);
         n.canvas.LineAA2(db_xbuf[1], db_ybuf[1], db_xbuf[2], db_ybuf[2], 0);
         n.canvas.LineAA2(db_xbuf[2], db_ybuf[2], db_xbuf[0], db_ybuf[0], 0);
         n.canvas.Fill2(10, 10, 0);
         n.canvas.LineAA2(s.scale.x, s.scale.y, db_xbuf[0], db_ybuf[0], ColorToARGB(n.needle.c, n.transparency));
        }
     }
//--- drawing the needle center
   if(n.ncenter.disp==true)
      n.canvas.FillCircle(n.ncenter.x, n.ncenter.y, n.ncenter.r, ColorToARGB(n.ncenter.c, n.transparency));
  }
//+------------------------------------------------------------------+
//| Calculating and drawing legends                                  |
//+------------------------------------------------------------------+
void gl_calc_and_draw(SCALE_LAYER_STR &s,GAUGE_INP_PAR_STR &p)
  {
//--- description
   if(p.descr.enable==true)
      gl_string_calc_drow(s.gl.descr,s,s.scale.x,s.scale.y);
//--- units of measure
   if(p.unit.enable==true)
      gl_string_calc_drow(s.gl.unit,s,s.scale.x,s.scale.y);
//--- multiplier
   if(p.mul.enable==true)
     {
      s.gl.mul.str=mul_scale_str[p.mul_scale];
      gl_string_calc_drow(s.gl.mul,s,s.scale.x,s.scale.y);
     }
//--- current value
   if(p.val.enable==true)
     {
      s.gl.val.digits=0;
      if(p.val.str!="" && p.val.str!=NULL)
        {
         int d= int(StringToInteger(p.val.str));
         if(d>=1 && d<=8)
            s.gl.val.digits=d;
        }
      s.gl.val.str=" ";
      gl_string_calc_drow(s.gl.val,s,s.scale.x,s.scale.y);
     }
  }
//+------------------------------------------------------------------+
//| Calculating and drawing a specified label                        |
//+------------------------------------------------------------------+
void gl_string_calc_drow(GAUGE_LEGEND_STRING_STR &gls,SCALE_LAYER_STR &s,uint Cx,uint Cy)
  {
   if(gls.str!="" && gls.str!=NULL)
     {//display
      gls.draw=true;
      s.canvas.FontSet(gls.font_font,gls.font_size,gls.font_flags,0);
      double a=NormRad(DegToRad(gls.a+90));
      gls.x = (int)(Cx-gls.r*MathCos(_PI-a));
      gls.y = (int)(Cy-gls.r*MathSin(_PI-a));
      gls.bgcol=s.c;
      s.canvas.TextOut(gls.x,gls.y,gls.str,ColorToARGB(gls.col,s.transparency),TA_CENTER|TA_VCENTER);
     }
  }
//+------------------------------------------------------------------+
//| Drawing marks and labels on the scale                            |
//+------------------------------------------------------------------+
void redraw_marks(SCALE_LAYER_STR &s,CASE_STR &cs,ARC_STR &scale,SCALE_MARKS_STR &sm,GAUGE_INP_PAR_STR &p,int gap)
  {
   int i,j,k;//for cycles
   double a=0,a2=0,a3=0;//for intermediate value of angles
   sm.mul=mul_scale_tab[int(p.mul_scale)];
   if(sm.mul<=0)
      sm.mul=1;
   sm.left_value =  p.min_value;
   sm.right_value = p.max_value;
   sm.digits=0;//maximum number of decimal places in graduation marks
   if(sm.right_value>sm.left_value)
     {//direct order of numerals
      sm.dir_forward = true;
      sm.range_value = sm.right_value - sm.left_value;
     }
   else
     {//inverse order of numerals
      sm.dir_forward = false;
      sm.range_value = sm.left_value - sm.right_value;
     }
//--- determining zero mark position
   if(sm.left_value==0)
      sm.nullmark=NULLMARK_LEFT;
   else if(sm.right_value==0)
      sm.nullmark=NULLMARK_RIGHT;
   else if((sm.right_value<0 && sm.left_value>0) || (sm.right_value>0 && sm.left_value<0))
      sm.nullmark=NULLMARK_MIDDLE;
   else
      sm.nullmark=NULLMARK_NONE;
//---
   sm.min_fi = scale.fi1;//
   sm.max_fi = scale.fi0;//
   if(scale.fi1>scale.fi0)
      sm.range_fi=NormRad(scale.fi1-scale.fi0);
   else
      sm.range_fi=NormRad(scale.fi1+(_2PI-scale.fi0));
//--- number of main marks
   int nl=0;//values on the left side of zero
   int nr=0;//values on the right side of zero
//----- shifts, multiplier, digits, initial value
   double mbuf[MARK_BUF_SIZE][2];//buffer of mark values
   mbuf[0][0]=0;
   mbuf[0][1]=0;
   int    mbuf_mid=int(MARK_BUF_SIZE/2);//zero index in the buffer of marks
   int    mn=0;//number of actual data in the buffer of mark values
   double dtmp=0;
   int sign=0;
   double mul=mul_scale_tab[int(p.mul_scale)];
//--- there are 4 situations: no zero, zero is on the extreme left, zero is on the extreme right, zero is somewhere in the middle 
   if(sm.nullmark==NULLMARK_LEFT)
     {//zero is on the extreme left
      mbuf[mbuf_mid][0] = 0;        
      mbuf[mbuf_mid][1] = sm.min_fi;
      dtmp=0;
      if(sm.dir_forward==true)
         sign=1;
      else
         sign=-1;
      for(i=1;i<int(MARK_BUF_SIZE/2);i++)
        {
         dtmp=i*p.major_tmi;
         if(dtmp<=sm.range_value)
           {
            mbuf[mbuf_mid+i][0]=(i*p.major_tmi*sign)/mul;//buffer of mark values
            mbuf[mbuf_mid+i][1]=NormRad(sm.min_fi-((i*p.major_tmi*sm.range_fi)/sm.range_value));
            nr++;
           }
         else
            break;
        }
     }
   else if(sm.nullmark==NULLMARK_RIGHT)
     {//zero is on the extreme right
      mbuf[mbuf_mid][0] = 0;
      mbuf[mbuf_mid][1] = sm.max_fi;
      dtmp=0;
      if(sm.dir_forward==true)
         sign=-1;
      else
         sign=1;
      for(i=1;i<int(MARK_BUF_SIZE/2);i++)
        {
         dtmp=i*p.major_tmi;
         if(dtmp<=sm.range_value)
           {
            mbuf[mbuf_mid-i][0]=(i*p.major_tmi*sign)/mul;//buffer of mark values
            mbuf[mbuf_mid-i][1]=NormRad(sm.max_fi+((i*p.major_tmi*sm.range_fi)/sm.range_value));
            nl++;
           }
         else
            break;
        }
     }
   else if(sm.nullmark==NULLMARK_MIDDLE)
     {//zero is somewhere in the middle
      mbuf[mbuf_mid][0]=0;
      if(sm.dir_forward==true)
         mbuf[mbuf_mid][1]=NormRad(sm.min_fi-(((-sm.left_value)*sm.range_fi)/sm.range_value));
      else
         mbuf[mbuf_mid][1]=NormRad(sm.min_fi-(((sm.left_value)*sm.range_fi)/sm.range_value));
      dtmp=0;//first from zero to the right
      if(sm.dir_forward==true)
         sign=1;
      else
         sign=-1;
      for(i=1;i<int(MARK_BUF_SIZE/2);i++)
        {
         dtmp=i*p.major_tmi;
         if(dtmp<=MathAbs(sm.right_value))
           {
            mbuf[mbuf_mid+i][0]=(i*p.major_tmi*sign)/mul;//buffer of mark values
            mbuf[mbuf_mid+i][1]=NormRad(mbuf[mbuf_mid][1]-((i*p.major_tmi*sm.range_fi)/sm.range_value));
            nr++;
           }
         else
            break;
        }
      dtmp=0;//then from zero to the left
      if(sm.dir_forward==true)
         sign=-1;
      else
         sign=1;
      for(i=1;i<int(MARK_BUF_SIZE/2);i++)
        {
         dtmp=i*p.major_tmi;
         if(dtmp<=MathAbs(sm.left_value))
           {
            mbuf[mbuf_mid-i][0]=(i*p.major_tmi*sign)/mul;//buffer of mark values
            mbuf[mbuf_mid-i][1]=NormRad(mbuf[mbuf_mid][1]+((i*p.major_tmi*sm.range_fi)/sm.range_value));
            nl++;
           }
         else
            break;
        }
     }
   else if(sm.nullmark==NULLMARK_NONE)
     {//no zero on the scale
      dtmp=0;
      if(sm.dir_forward==true)
         sign=1;
      else
         sign=-1;
      for(i=0;i<int(MARK_BUF_SIZE/2);i++)
        {
         dtmp=i*p.major_tmi;
         if(dtmp<=(sm.range_value*1.0027))
           {
            mbuf[mbuf_mid+i][0]=(sm.left_value+i*p.major_tmi*sign)/mul;//buffer of mark values
            mbuf[mbuf_mid+i][1]=NormRad(sm.min_fi-((i*p.major_tmi*sm.range_fi)/sm.range_value));
            nr++;
           }
         else
            break;
        }
     }
//--- search for a minimum mark value (in modulus) to calculate digits
   int tmpbuf[3];
   tmpbuf[0]=calc_digits(MathAbs(sm.left_value/sm.mul));
   tmpbuf[1]=calc_digits(MathAbs(sm.right_value/sm.mul));
   tmpbuf[2]=calc_digits(MathAbs(p.major_tmi/sm.mul));
   sm.digits= tmpbuf[0];
   if(sm.digits<tmpbuf[1])
      sm.digits=tmpbuf[1];
   if(sm.digits<tmpbuf[2])
      sm.digits=tmpbuf[2];
//--- step in degrees
   double fi_major,fi_middle,fi_minor;
//--- main marks
   fi_major=(p.major_tmi*sm.range_fi)/sm.range_value;
//--- middle marks
   if(p.middle_tmarks!=0)
      fi_middle=((p.major_tmi/(p.middle_tmarks+1))*sm.range_fi)/sm.range_value;
   else
      fi_middle=0;
//--- minor marks
   if(p.minor_tmarks!=0)
     {
      if(fi_middle!=0)
         fi_minor=(((p.major_tmi/(p.middle_tmarks+1))/(p.minor_tmarks+1))*sm.range_fi)/sm.range_value;
      else
         fi_minor=((p.major_tmi/(p.minor_tmarks+1))*sm.range_fi)/sm.range_value;
     }
   else
      fi_minor=0;
//--- calculating highlighted ranges
   ranges_calc(s,scale,sm,p,gap);
//--- drawing highlighted ranges
   ranges_draw(s);
//--- drawing marks
   int r0,r1;          //current radii (inner and outer)
   double x1,x2,y1,y2; //mark coordinates
   int xt,yt;          //text coordinates
   string mtext;       //text (value) of the mark 
   int digits;
//--- setting mark font
   s.canvas.FontSet(sm.mfont_font,sm.mfont_size,sm.mfont_flags,0);
//--- drawing marks to the right
   if(sm.nullmark!=NULLMARK_NONE)
      nr++;
   for(i=0;i<nr;i++)
     {
      a=mbuf[mbuf_mid+i][1];//угол
      calc_r0r1(r0,r1,scale.r,sm.major_len,p.mark_style);
      x1 = scale.x-r0*MathCos(_PI-a);
      y1 = scale.y-r0*MathSin(_PI-a);
      x2 = scale.x-r1*MathCos(_PI-a);
      y2 = scale.y-r1*MathSin(_PI-a);
      if(p.scale_style==SCALE_INNER)
        {//text inside
         xt = (int)(scale.x-(r1-sm.mfont_gap)*MathCos(_PI-a));
         yt = (int)(scale.y-(r1-sm.mfont_gap)*MathSin(_PI-a));
        }
      else
        {//text outside
         xt = (int)(scale.x-(r0+sm.mfont_gap)*MathCos(_PI-a));
         yt = (int)(scale.y-(r0+sm.mfont_gap)*MathSin(_PI-a));
        }
      s.canvas.LineAA2(x1,y1,x2,y2,ColorToARGB(scale.c,s.transparency));
      if(mbuf[mbuf_mid+i][0]==0)
         digits=0;
      else
         digits=sm.digits;
      mtext=DoubleToString(mbuf[mbuf_mid+i][0],digits);
      s.canvas.TextOut(xt,yt,mtext,ColorToARGB(p.mfont_color,s.transparency),TA_CENTER|TA_VCENTER);
      if(fi_middle!=0)
        {
         a2=a;
         for(k=1;k<=p.minor_tmarks;k++)
           {
            a3=NormRad(a2-fi_minor*k);
            if(draw_mark(s,a3,sm.minor_len,scale,p.mark_style)==false)
               break;
           }
         for(j=1;j<=p.middle_tmarks;j++)
           {
            a2=NormRad(a-fi_middle*j);
            if(draw_mark(s,a2,sm.middle_len,scale,p.mark_style)==false)
               break;
            for(k=1;k<=p.minor_tmarks;k++)
              {
               a3=NormRad(a2-fi_minor*k);
               if(draw_mark(s,a3,sm.minor_len,scale,p.mark_style)==false)
                  break;
              }
           }
        }
      else
        {
         for(k=1;k<=p.minor_tmarks;k++)
           {
            a3=NormRad(a2-fi_minor*k);
            if(draw_mark(s,a3,sm.minor_len,scale,p.mark_style)==false)
               break;
           }
        }
     }
//--- drawing marks to the left
   if(sm.nullmark==NULLMARK_NONE)
      return;
   for(i=0;i<(nl+1);i++)
     {
      a=mbuf[mbuf_mid-i][1];//angle
      calc_r0r1(r0,r1,scale.r,sm.major_len,p.mark_style);
      x1 = scale.x-r0*MathCos(_PI-a);
      y1 = scale.y-r0*MathSin(_PI-a);
      x2 = scale.x-r1*MathCos(_PI-a);
      y2 = scale.y-r1*MathSin(_PI-a);
      if(p.scale_style==SCALE_INNER)
        {//text inside
         xt = (int)(scale.x-(r1-sm.mfont_gap)*MathCos(_PI-a));
         yt = (int)(scale.y-(r1-sm.mfont_gap)*MathSin(_PI-a));
        }
      else
        {//text outside
         xt = (int)(scale.x-(r0+sm.mfont_gap)*MathCos(_PI-a));
         yt = (int)(scale.y-(r0+sm.mfont_gap)*MathSin(_PI-a));
        }
      if(mbuf[mbuf_mid-i][0]==0)
         digits=0;
      else
         digits=sm.digits;
      mtext=DoubleToString(mbuf[mbuf_mid-i][0],digits);
      if(i>0 || (i==0 && sm.nullmark==NULLMARK_RIGHT))
        {
         s.canvas.LineAA2(x1, y1, x2, y2, ColorToARGB(scale.c,s.transparency));
         s.canvas.TextOut(xt,yt,mtext,ColorToARGB(p.mfont_color,s.transparency),TA_CENTER|TA_VCENTER);
        }
      if(fi_middle!=0)
        {
         a2=a;
         for(k=1;k<=p.minor_tmarks;k++)
           {
            a3=NormRad(a2+fi_minor*k);
            if(draw_mark(s,a3,sm.minor_len,scale,p.mark_style)==false)
               break;
           }
         for(j=1;j<=p.middle_tmarks;j++)
           {
            a2=NormRad(a+fi_middle*j);
            if(draw_mark(s,a2,sm.middle_len,scale,p.mark_style)==false)
               break;
            for(k=1;k<=p.minor_tmarks;k++)
              {
               a3=NormRad(a2+fi_minor*k);
               if(draw_mark(s,a3,sm.minor_len,scale,p.mark_style)==false)
                  break;
              }
           }
        }
      else
        {
         for(k=1;k<=p.minor_tmarks;k++)
           {
            a3=NormRad(a2+fi_minor*k);
            if(draw_mark(s,a3,sm.minor_len,scale,p.mark_style)==false)
               break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Calculating range coordinates                                    |
//+------------------------------------------------------------------+
void ranges_calc(SCALE_LAYER_STR &s,ARC_STR &scale,SCALE_MARKS_STR &sm,GAUGE_INP_PAR_STR &p,int gap)
  {
   int r0,r1;
   calc_r0r1(r0,r1,scale.r,sm.major_len,p.mark_style);
   for(int i=0; i<4; i++)
     {
      if(range_correct(i,p)==true)
         range_pie_calc(s.rng[i],scale,sm,r0,gap,r1,p.rng[i].start,p.rng[i].end,p.rng[i].c,p.case_color);
     }
  }
//+------------------------------------------------------------------+
//| Checking and correcting range parameters                         |
//+------------------------------------------------------------------+
bool range_correct(int i,GAUGE_INP_PAR_STR &p)
  {
   if(p.rng[i].enable==false)
      return(false);
   if(p.rng[i].start==p.rng[i].end)
      return(false);
   double p0,p1,r0,r1;
   range_norm(p0,p1,p.min_value,p.max_value);
   range_norm(r0,r1,p.rng[i].start,p.rng[i].end);
   if(r0<p0 && r1<p0)
      return(false);
   if(r0>p1 && r1>p1)
      return(false);
   if(r0<p0)
      r0=p0;
   if(r1>p1)
      r1=p1;
   p.rng[i].start=r0;
   p.rng[i].end=r1;
   return(true);
  }
//+------------------------------------------------------------------+
//| Correcting range end values                                      |
//+------------------------------------------------------------------+
void range_norm(double &min,double &max,double val0,double val1)
  {
   if(val0<val1)
     {
      min = val0;
      max = val1;
     }
   else
     {
      min = val1;
      max = val0;
     }
  }
//+------------------------------------------------------------------+
//| Calculating values of the highlighted range sector structure     |
//+------------------------------------------------------------------+
void range_pie_calc(RANGE_STR &rng,ARC_STR &scale,SCALE_MARKS_STR &sm,int r,int rf,int re,double rng_start,double rng_end,color col,color cs_col)
  {
   rng.st_val=rng_start;
   rng.end_val=rng_end;
   double range0,range1;
   if(rng.st_val>rng.end_val)
     {range0=rng.st_val; range1=rng.end_val;}
   else if(rng.st_val<rng.end_val)
     {range1=rng.st_val; range0=rng.end_val;}
   else
      return;
   if(sm.left_value>sm.right_value)
     {//inverse order of scale marks  
      double rtmp=range0;
      range0 = -range1;
      range1 = -rtmp;
     }
   rng.active=true;
   rng.c=col;
//--- center coordinates:
   rng.p.x = scale.x;
   rng.p.y = scale.y;
//--- radius:
   rng.p.r=r;
   rng.p.re=re;
//--- calculating dfi (how far to step out the sector edges)
   double dfi=MathArcsin(((double)rf)/((double)rng.p.r))/2;
   if(sm.left_value<sm.right_value)
     {//direct order of scale marks   
      rng.p.fi0 = NormRad(sm.min_fi-(((range0-sm.left_value)*sm.range_fi)/sm.range_value));
      rng.p.fi1 = NormRad(sm.min_fi-(((range1-sm.left_value)*sm.range_fi)/sm.range_value));
      //
      rng.p.fi0e = NormRad(sm.min_fi-(((range0-sm.left_value)*sm.range_fi)/sm.range_value)-dfi);
      rng.p.fi1e = NormRad(sm.min_fi-(((range1-sm.left_value)*sm.range_fi)/sm.range_value)+dfi);
     }
   else
     {//inverse order of scale marks   
      rng.p.fi0 = NormRad(sm.min_fi-(((sm.left_value+range0)*sm.range_fi)/sm.range_value));
      rng.p.fi1 = NormRad(sm.min_fi-(((sm.left_value+range1)*sm.range_fi)/sm.range_value));
      //
      rng.p.fi0e = NormRad(sm.min_fi-(((range0+sm.left_value)*sm.range_fi)/sm.range_value)-dfi);
      rng.p.fi1e = NormRad(sm.min_fi-(((range1+sm.left_value)*sm.range_fi)/sm.range_value)+dfi);
     }
   rng.p.c=col;
   rng.p.ce=cs_col;
  }
//+------------------------------------------------------------------+
//| Drawing highlighted ranges                                       |
//+------------------------------------------------------------------+
void ranges_draw(SCALE_LAYER_STR &s)
  {
   for(int i=0; i<4; i++)
      range_draw(s.rng[i],s);
  }
//+------------------------------------------------------------------+
//| Drawing a highlighted range                                      |
//+------------------------------------------------------------------+
void range_draw(RANGE_STR &rng,SCALE_LAYER_STR &s)
  {
   if(rng.active==false)
      return;
   s.canvas.Pie(rng.p.x, rng.p.y, rng.p.r, rng.p.r, rng.p.fi0, rng.p.fi1, ColorToARGB(rng.p.c, s.transparency), ColorToARGB(rng.p.c, s.transparency));
   s.canvas.Pie(rng.p.x, rng.p.y, rng.p.re, rng.p.re, rng.p.fi0e, rng.p.fi1e, ColorToARGB(rng.p.ce, s.transparency), ColorToARGB(rng.p.ce, s.transparency));
  }
//+------------------------------------------------------------------+
//| Getting radii for different mark styles                          |
//+------------------------------------------------------------------+
void calc_r0r1(int &r0,int &r1,int r,int len,ENUM_MARK_STYLE mark_style)
  {
   if(mark_style==MARKS_INNER)
     {
      r0 = r;
      r1 = r-len;
     }
   else
   if(mark_style==MARKS_MIDDLE)
     {
      r0 = r+len/2;
      r1 = r-len/2;
     }
   else
   if(mark_style==MARKS_OUTER)
     {
      r0 = r+len;
      r1 = r;
     }
  }
//+------------------------------------------------------------------+
//| Drawing a mark on the scale                                      |
//+------------------------------------------------------------------+
bool draw_mark(SCALE_LAYER_STR &s,double fi,int len,ARC_STR &scale,ENUM_MARK_STYLE mark_style)
  {//
   int r0,r1;
   double x1,x2,y1,y2; 
   double a0 = scale.fi0;
   double a1 = scale.fi1;
   double b1 = calc_dA(a0, fi, -1);
   double b2 = calc_dA(a1, fi, 1);
   double b3 = calc_dA(a0, a1, -1);
   if(MathAbs(b3-(b2+b1))<(_PI/180))
      return(false);
   calc_r0r1(r0,r1,scale.r,len,mark_style);
   x1 = scale.x-r0*MathCos(_PI-fi);
   y1 = scale.y-r0*MathSin(_PI-fi);
   x2 = scale.x-r1*MathCos(_PI-fi);
   y2 = scale.y-r1*MathSin(_PI-fi);
   s.canvas.LineAA2(x1,y1,x2,y2,ColorToARGB(scale.c,s.transparency));
   return(true);
  }
//+------------------------------------------------------------------+
//| Difference between angles                                        |
//+------------------------------------------------------------------+
double calc_dA(double fi1,double fi2,int dir)
  {
   double a1 = NormRad(fi1);
   double a2 = NormRad(fi2);
   double d1,d2;
   if(a1==a2)
      return(0);
   if(a1>a2)
     {
      d1=a1-a2;
      d2=a2+(2*_PI-a1);
     }
   else
     {
      d1= a1+(2*_PI-a2);
      d2 = a2-a1;
     }
   if(dir<0)
      return(d1);
   else
      return(d2);
  }
//+------------------------------------------------------------------+
//| Redraws a contour line of the body of the sector type            |
//+------------------------------------------------------------------+
void redraw_sector_case(SCALE_LAYER_STR &s,CASE_STR &cs)
  {
   int x[5];
   int y[5];
//--- main arc
   s.canvas.Pie(cs.arc11.x,cs.arc11.y,cs.arc11.r,cs.arc11.r,cs.arc11.fi0,cs.arc11.fi1,ColorToARGB(cs.arc11.c,s.transparency),ColorToARGB(cs.arc11.c,s.transparency));
   if(cs.arc12.disp==true)
      s.canvas.Pie(cs.arc12.x,cs.arc12.y,cs.arc12.r,cs.arc12.r,cs.arc12.fi0,cs.arc12.fi1,ColorToARGB(cs.arc12.c,s.transparency),ColorToARGB(cs.arc12.c,s.transparency));
//--- rounding off on the left and on the right
   s.canvas.FillCircle(cs.arc3.x, cs.arc3.y, cs.arc3.r, ColorToARGB(cs.arc3.c,s.transparency));
   s.canvas.FillCircle(cs.arc4.x, cs.arc4.y, cs.arc4.r, ColorToARGB(cs.arc4.c,s.transparency));
//--- lower arc
   if(cs.mode==0)
      s.canvas.FillCircle(cs.arc2.x,cs.arc2.y,cs.arc2.r,ColorToARGB(cs.arc2.c,s.transparency));
//--- connective sections      
   if(cs.mode==0)
     {//mode with angle <=180
      cs.arc12.disp=false;
      //left section
      x[1]=cs.line1.x1; x[0]=cs.line1.x2; x[2]=cs.arc3.x; x[4]=cs.arc11.x; x[3]=cs.fdot.x;
      y[1]=cs.line1.y1; y[0]=cs.line1.y2; y[2]=cs.arc3.y; y[4]=cs.arc11.y; y[3]=cs.fdot.y;
      s.canvas.FillPolygon(x,y,ColorToARGB(cs.line1.c,s.transparency));
      //right section
      x[3]=cs.line2.x1; x[4]=cs.line2.x2; x[2]=cs.arc4.x; x[0]=cs.arc11.x; x[1]=cs.fdot.x;
      y[3]=cs.line2.y1; y[4]=cs.line2.y2; y[2]=cs.arc4.y; y[0]=cs.arc11.y; y[1]=cs.fdot.y;
      s.canvas.FillPolygon(x,y,ColorToARGB(cs.line2.c,s.transparency));
     }
   else
     {//mode with angle >180
      x[0]=cs.line1.x2; x[1]=cs.line1.x1; x[2]=cs.arc3.x; x[3]=cs.fdot.x; x[4]=cs.arc4.x;
      y[0]=cs.line1.y2; y[1]=cs.line1.y1; y[2]=cs.arc3.y; y[3]=cs.fdot.y; y[4]=cs.arc4.y;
      s.canvas.FillPolygon(x,y,ColorToARGB(cs.line1.c,s.transparency));
     }
  }
//+------------------------------------------------------------------+
//| Calculation of elements of the body contour line                 |
//+------------------------------------------------------------------+
void case_sector_calc(CASE_STR &cs,ARC_STR &arc_ref,ARC_STR &arc2_ref,int x,int y,int gap,color c,color c_fill)
  {
   double fi0,fi1,fi2;
   double sa;//scale range
   if(arc_ref.fi1>arc_ref.fi0)
      sa=NormRad(arc_ref.fi1-arc_ref.fi0);
   else
      sa=NormRad(_2PI-arc_ref.fi0+arc_ref.fi1);
   if(sa>_PI)
      cs.mode=1;
   else
      cs.mode=0;
//--- main arc
   if(sa>_PI)
     {//угол больше 180
      cs.arc11.x = x;
      cs.arc11.y = y;
      cs.arc11.r = arc_ref.r+gap;
      cs.arc11.fi0 = NormRad(arc_ref.fi0);
      cs.arc11.fi1 = NormRad(arc_ref.fi0+sa*0.55);
      cs.arc11.c=c;
      cs.arc12.disp=true;
      cs.arc12.x = x;
      cs.arc12.y = y;
      cs.arc12.r = arc_ref.r+gap;
      cs.arc12.fi0 = NormRad(arc_ref.fi1-sa*0.55);
      cs.arc12.fi1 = NormRad(arc_ref.fi1);
      cs.arc12.c=c;
     }
   else
     {
      cs.arc11.x = x;
      cs.arc11.y = y;
      cs.arc11.r = arc_ref.r+gap;
      cs.arc11.fi0 = NormRad(arc_ref.fi0);
      cs.arc11.fi1 = NormRad(arc_ref.fi1);
      cs.arc11.c=c;
     }
//--- rounding off on the left
   cs.arc3.r = gap;
   cs.arc3.x = (int)(x-arc_ref.r*MathCos(_PI-arc_ref.fi1));
   cs.arc3.y = (int)(y-arc_ref.r*MathSin(_PI-arc_ref.fi1));
   if(cs.mode==1)
      fi1=arc_ref.fi1+(_2PI-sa)/2;
   else
      fi1=arc_ref.fi1+_PI*0.5;
   cs.arc3.fi0 = arc_ref.fi1;
   cs.arc3.fi1 = NormRad(fi1);
   cs.arc3.c=c;
//--- rounding off on the right
   cs.arc4.r = gap;
   cs.arc4.x = (int)(x-arc_ref.r*MathCos(_PI-arc_ref.fi0));
   cs.arc4.y = (int)(y-arc_ref.r*MathSin(_PI-arc_ref.fi0));
   if(cs.mode==1)
      fi0=arc_ref.fi0-(_2PI-sa)/2;
   else
      fi0=arc_ref.fi0-_PI*0.5;
   cs.arc4.fi0 = NormRad(fi0);
   cs.arc4.fi1 = arc_ref.fi0;
   cs.arc4.c=c;
//--- arc around the needle center
   cs.arc2.x = x;
   cs.arc2.y = y;
   cs.arc2.r = arc2_ref.r+gap;
   fi2 = MathArcsin(((double)cs.arc3.r)/((double)cs.arc2.r));
   fi1 = NormRad(arc_ref.fi1+fi2);
   cs.arc2.fi0=fi1;
   fi1=NormRad(arc_ref.fi0-fi2);
   cs.arc2.fi1=fi1;
   cs.arc2.c = c;
   if(cs.mode==1)
     {//right section (right one is not used)
      double ff=_PI-(sa/2);
      cs.line1.x1 = (int)(cs.arc3.x+cs.arc3.r*MathSin((cs.arc12.fi1+ff)-_PI*1.5));
      cs.line1.y1 = (int)(cs.arc3.y+cs.arc3.r*MathCos((cs.arc12.fi1+ff)-_PI*1.5));
      cs.line1.x2 = (int)(cs.arc4.x+cs.arc4.r*MathSin((cs.arc11.fi0-ff)-_PI*1.5));
      cs.line1.y2 = (int)(cs.arc4.y+cs.arc4.r*MathCos((cs.arc11.fi0-ff)-_PI*1.5));
      cs.line1.c=c;
     }
   else
     {//both sections are used
      //left section
      cs.line1.x1 = (int)(cs.arc3.x+cs.arc3.r*MathSin(cs.arc3.fi0-_PI));
      cs.line1.y1 = (int)(cs.arc3.y+cs.arc3.r*MathCos(cs.arc3.fi0-_PI));
      fi2 = MathArcsin(((double)cs.arc3.r)/((double)cs.arc2.r));
      fi1 = NormRad(cs.arc11.fi1+fi2);
      cs.line1.x2 = (int)(x-cs.arc2.r*MathCos(_PI-fi1));
      cs.line1.y2 = (int)(y-cs.arc2.r*MathSin(_PI-fi1));
      cs.line1.c=c;
      //right section
      cs.line2.x1 = (int)(cs.arc4.x+cs.arc4.r*MathSin(cs.arc4.fi1));
      cs.line2.y1 = (int)(cs.arc4.y+cs.arc4.r*MathCos(cs.arc4.fi1));
      fi1=NormRad(cs.arc11.fi0-fi2);
      cs.line2.x2 = (int)(x-cs.arc2.r*MathCos(_PI-fi1));
      cs.line2.y2 = (int)(y-cs.arc2.r*MathSin(_PI-fi1));
      cs.line2.c=c;
     }
//--- filling dot
   fi1=_PI-NormRad(arc_ref.fi1-(sa/2));
   cs.fdot.x = (int)(x-cs.arc2.r*MathCos(fi1));
   cs.fdot.y = (int)(y-cs.arc2.r*MathSin(fi1));
   cs.fdot.c = c_fill;
  }
//+------------------------------------------------------------------+
//| Setting legend parameters                                        |
//+------------------------------------------------------------------+
void GaugeSetGLPars(GAUGE_LEGEND_STRING_STR &gl,GAUGE_LEGEND_PAR_STR &par,int r0,int dr)
  {
   if(par.enable==true && par.font_font!="")
     {
      gl.str=par.str;
      gl.a = par.angle;
      gl.r = r0 + int(GetPercent(dr, par.radius*10));
      gl.font_font = par.font_font;
      if(par.italic==true)
         gl.font_flags=FONT_ITALIC;
      else
         gl.font_flags=0;
      if(par.bold==true)
         gl.font_flags|=FW_BOLD;
      gl.font_size=int(((par.font_size+2)*dr)/64);
      gl.col=par.col;
     }
  }
//+------------------------------------------------------------------+
//| Calculates center coordinates                                    |
//+------------------------------------------------------------------+
bool GaugeCalcLocation(GAUGE_STR &g)
  {
   bool newloc=false;
   bool relative=false;
   int Cx=0,Cy=0;
   int rCx=0,rCy=0;
   if(g.par.rel_mode!=RELATIVE_MODE_NONE && g.par.ObjRel!="")
     {
      int r=0;
      if(GaugeGetRelXY(g.par.ObjRel,g.par.corner,rCx,rCy,g.rel_x,g.rel_y,r)==true)
        {
         relative=true;
         if(g.par.rel_mode==RELATIVE_MODE_HOR)
           {
            Cx=g.rel_x+g.R;
            Cy=rCy;
           }
         else if(g.par.rel_mode==RELATIVE_MODE_VERT)
           {
            Cx=rCx;
            Cy= g.rel_y+g.R;
           }
         else if(g.par.rel_mode==RELATIVE_MODE_DIAG)
           {
            int rr=int((g.R+r)*0.7071);
            Cx = g.rel_x-r+rr;
            Cy = g.rel_y-r+rr;
           }
        }
     }
   if(relative==false)
     {
      Cx = g.R;
      Cy = g.R;
     } 
   Cx+= g.par.x;
   Cy+= g.par.y;
   if(g.Cx!=Cx || g.Cy!=Cy)
     {
      g.Cx=Cx;
      g.Cy=Cy;
      //returns true, if coordinates change
      newloc=true;
     }
   return(newloc);
  }
//+------------------------------------------------------------------+
//| Deletes objects                                                  |
//+------------------------------------------------------------------+
void GaugeDelete(GAUGE_STR &g)
  {
   ObjectDelete(0,g.s_layer.ObjName);//scale
   ObjectDelete(0,g.n_layer.ObjName);//needle
  }
//+------------------------------------------------------------------+
//| Updates position of the needle and displayed value               |
//+------------------------------------------------------------------+
void GaugeNewValue(GAUGE_STR &g,double v)
  {
   if(g.init_ok==false)
      return;
   g.value=v;
   if(g.s_layer.gl.val.draw==true)
      redraw_value(g.s_layer,g.value);
   redraw_needle(g.s_layer,g.n_layer,g.s_layer.sm,g.value);
   Alert(v);
   g.n_layer.canvas.Update(true);
  }
//+------------------------------------------------------------------+
//| Returns area size taken by the string                            |
//+------------------------------------------------------------------+
bool get_gglabarea_size(LAB_AREA_SIZE_STR &sz,GAUGE_LEGEND_STRING_STR &gls,CCanvas &c)
  {
   if(c.FontSet(gls.font_font,gls.font_size,gls.font_flags,0)==false)
      return(false);
   c.TextSize(gls.str,sz.l,sz.h);
   if(sz.l==0 || sz.h==0)
      return(false);
   sz.d=int(MathCeil(MathSqrt((sz.l*sz.l+sz.h*sz.h))));
   return(true);
  }
//+------------------------------------------------------------------+
//| Erasing text of a specified string                               |
//+------------------------------------------------------------------+
bool gl_erase_str(SCALE_LAYER_STR &s,GAUGE_LEGEND_STRING_STR &gls,color col)
  {
   LAB_AREA_SIZE_STR sz;
   if(get_gglabarea_size(sz,gls,s.canvas)==false)
      return(false);
   s.canvas.FillRectangle(gls.x-(sz.l/2)-4,gls.y-(sz.h/2),gls.x+(sz.l/2)+4,gls.y+(sz.h/2),ColorToARGB(col,s.transparency));
   return(true);
  }
//+------------------------------------------------------------------+
//| Updating a displayed value                                       |
//+------------------------------------------------------------------+
bool redraw_value(SCALE_LAYER_STR &s,double val)
  {
//--- erase previous value  
   if(StringLen(s.gl.val.str)>0)
     {
      if(gl_erase_str(s,s.gl.val,s.gl.val.bgcol)==false)
         return(false);
     }
//--- displays new value
   s.gl.val.str=DoubleToString(val,s.gl.val.digits);
   if(s.canvas.FontSet(s.gl.val.font_font,s.gl.val.font_size,s.gl.val.font_flags,0)==false)
      return(false);
   s.canvas.TextOut(s.gl.val.x, s.gl.val.y, s.gl.val.str, ColorToARGB(s.gl.val.col, s.transparency), TA_CENTER|TA_VCENTER);
   s.canvas.Update(true);
   return(true);
  }

double mul_scale_tab[9]={10000,1000,100,10,1,0.1,0.01,0.001,0.0001};
string mul_scale_str[9]={"x10k","x1k","x100","x10"," ","/10","/100","/1k","/10k"};
//+------------------------------------------------------------------+
//| Returns maximum length of a string                               |
//+------------------------------------------------------------------+
int get_max_len_str(double v0,double v1,double step,ENUM_MUL_SCALE k)
  {//returns maximum length of a string (number of characters) basing on extreme values and a step
//--- multiplier of scale marks
   double mul=mul_scale_tab[int(k)];
   double val1=0,val2=0;
//--- extreme values inclusive of the multiplier   
   val1 = v0/mul;
   val2 = v1/mul;
//--- maximum length of integer part including a sign
   int l1 = StringLen(DoubleToString(val1,0));
   int l2 = StringLen(DoubleToString(val2,0));
   if(l1<l2)
      l1=l2;
//--- maximum length of the fractional part
   double st=step/mul;
   int d=calc_digits(st);
   string s= DoubleToString(st,d);
   int pos = StringFind(s,".",0);
   if(pos!=-1)
     {//if there is the fractional part
      l2=StringLen(StringSubstr(s,pos,8));//maximum length is 8 characters 
      l1+=(l2-1);//dot is not counted      
     }
   return(l1);
  }
//+------------------------------------------------------------------+
//| Calculating space necessary for graduation marks                 |
//+------------------------------------------------------------------+
int get_mfont_gap(SCALE_MARKS_STR &sm,int len)
  {
   int gap=0;
   LAB_AREA_SIZE_STR sz;
   CCanvas canvas;
   if(canvas.FontSet(sm.mfont_font,sm.mfont_size,sm.mfont_flags,0)==false)
      return(gap);
   string str="";
   for(int i=0; i<len; i++)
      str+="0";
   canvas.TextSize(str,sz.l,sz.h);
   if(sz.l==0 || sz.h==0)
      return(gap);
   sz.d= int(MathCeil(MathSqrt((sz.l*sz.l+sz.h*sz.h))));
   gap = int(sz.d*0.5);
   return(gap);
  }
//+------------------------------------------------------------------+
//| Calculates number of decimal places                              |
//+------------------------------------------------------------------+
int calc_digits(double value)
  {
   int i,j,max_nulls=0,nulls=0;
   if(value==0)
      return(0);
   ulong v=ulong(value*100000000);
   ulong vtmp;
   for(j=-5;j<=5;j++)
     {
      nulls= 0;
      vtmp = v+j;
      for(i=0;i<8;i++)
        {
         if((vtmp%10)==0)
           {//even divisible by 10
            vtmp=vtmp/10;
            nulls++;
           }
         else
            break;
        }
      if(max_nulls<nulls)
         max_nulls=nulls;
     }
   return(8-max_nulls);
  }
//+------------------------------------------------------------------+
//| Width of the area for graduation marks                           |
//+------------------------------------------------------------------+
bool get_marklabarea_size(int &d,SCALE_MARKS_STR &sm,int len)
  {
   CCanvas canvas;
   int dx=0,dy=0;
   if(canvas.FontSet(sm.mfont_font,sm.mfont_size,sm.mfont_flags,0)==false)
      return(false);
   string str="";
   for(int i=0; i<len; i++)
      str+="0";
   canvas.TextSize(str,dx,dy);
   if(dx==0 || dy==0)
      return(false);
   d=int(MathCeil(MathSqrt((dx*dx+dy*dy))));
   return(true);
  }
//+------------------------------------------------------------------+
