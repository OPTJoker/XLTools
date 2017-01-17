//
//  Color.h
//  iUnis
//
//  Created by 张雷 on 16/9/6.
//  Copyright © 2016年 ImanZhang. All rights reserved.
//

#ifndef Color_h
#define Color_h


#endif /* Color_h */

/* ****  Colors  *****/
#define KRGBCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB_A(rgbValue, alpha) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]

#define KTOPICCOLOR UIColorFromRGB(0x323232)

#define KTOPINFOCOLOR KRGBCOLOR(82,83,84,1)
#define KBLUEMILKCOLOR KRGBCOLOR(23,189,250,1)
#define KBGGRAYCOLOR KRGBCOLOR(241, 241, 241, 1)
#define KGRAY215COLOR KRGBCOLOR(213, 214, 215, 1)
#define KTEXTGRAYCOLOR KRGBCOLOR(131, 132, 133, 1)

#define KWHITECOLOR [UIColor whiteColor]
#define KBLACKCOLOR [UIColor blackColor]
#define KDARKGRAY [UIColor darkGrayColor]
#define KBROWNCOLOR [UIColor brownColor]
#define KLIGHTGRAYCOLOR [UIColor lightGrayColor]
#define KGRAYCOLOR [UIColor grayColor]
#define KCLEARCOLOR [UIColor clearColor]
#define KTOPICYELLOW UIColorFromRGB(0xffcc00)

#define KTINTGREENCOLOR KRGBCOLOR(134,194,74,1)


#define KSTATUS_READYCOLOR KRGBCOLOR(223,129,123,1)
#define KSTATUS_PRODUCINGCOLOR KRGBCOLOR(218,161,59,1)

#define KSTATUS_DAIBAOZHUANG UIColorFromRGB(0xffaf00)
#define KSTATUS_BAOZHUANGZHONG UIColorFromRGB(0x289bd0)
#define KSTATUS_BAOZHUANGWAN UIColorFromRGB(0x61c86c)
#define KSTATUS_CHUKU UIColorFromRGB(0xb09992)
#define KSTATUS_YUNSHU KRGBCOLOR(58,108,193,1)

#define KSTATUS_DAISHANGJIAN UIColorFromRGB(0xffaf00)
#define KSTATUS_SHANGJIAN UIColorFromRGB(0xb379d2)
#define KSTATUS_SHANGJIANWAN UIColorFromRGB(0x61c86c)


///////////////////////////////////////////
///////////////     Font    ///////////////
///////////////////////////////////////////
#define KFONT_DIN1451EF @"DIN1451EF"
