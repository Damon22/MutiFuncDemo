//
//  SubjectHtmlParser.m
//  WinLesson
//
//  Created by 高继鹏 on 16/7/18.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "SubjectHtmlParser.h"
#import "GetImageApi.h"
#import "YTKBatchRequest.h"
#import "HTMLHelper.h"

static NSMutableArray *paperImages;

@implementation SubjectHtmlParser
{
    BOOL isItem;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subjectsArr = [NSMutableArray arrayWithCapacity:10];
        self.imageArr = [NSMutableArray arrayWithCapacity:10];
        paperImages = [NSMutableArray arrayWithCapacity:20];
        isItem = NO;
    }
    return self;
}

+ (instancetype)shareHtmlParser
{
    static SubjectHtmlParser *shareInstance;
    @synchronized (self) {
        if (shareInstance == nil) {
            shareInstance = [[SubjectHtmlParser alloc] init];
        }
    }
    return shareInstance;
}

/** 解析返回的题目信息 */
/**
 格式信息：
    @[ // 多道题
        @{ // 单道题
            subject:@[题目]
            item:@[@选项1,@选项2,@选项3]
            analysis:@[解析]
            material:@[材料]
        }
    ]
 
 */
- (NSArray *)parserHTMLWith:(NSArray *)subjectInfoList
{
    NSMutableArray *subjectInfoArr = [NSMutableArray arrayWithCapacity:10];
    
    if (subjectInfoList && [subjectInfoList count]>0) {
        [[TMCache sharedCache] setObject:[NSString stringWithFormat:@"%ld",(unsigned long)[subjectInfoList count]] forKey:@"Subject_Count"];
    }
    
    for (int i = 0; i<subjectInfoList.count; i++) {
        NSDictionary *subjectDic = subjectInfoList[i];
        
        // 单个题
        NSMutableDictionary *subjectParserDic = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 题目
        NSArray *subjectArr = [self parserWithSubjectDes:[subjectDic[@"subjectDes"] copy]];
        [subjectParserDic setObject:subjectArr forKey:@"subject"];
        
        // 选项
        NSArray *listArr = [self parserWithItemList:[subjectDic[@"itemList"] copy]];
        [subjectParserDic setObject:listArr forKey:@"item"];
        
        // 解析
        NSArray *analysisArr = [self parserWithAnalysis:[subjectDic[@"analysis"] copy]];
        [subjectParserDic setObject:analysisArr forKey:@"analysis"];
        
        // 材料
        NSArray *materialArr = [self parserWithMaterial:[subjectDic[@"materialDecript"] copy]];
        [subjectParserDic setObject:materialArr forKey:@"material"];
        
        [subjectInfoArr addObject:subjectParserDic];
    }
    NSLog(@"subjectInfoArr:%@",subjectInfoArr);
    
    // 下载图片
    [self downloadSubjectImages];
    
    return [subjectInfoArr copy];
}

/** 解析题目 Arr */
- (NSArray *)parserWithSubjectDes:(NSString *)subjectDes
{
    isItem = NO;
    NSString *bodyStr = [self getBodyStr:subjectDes];
    NSArray *bodyImgArr = [self handleTextAndImage:bodyStr];
    return [bodyImgArr copy];
}

/** 解析选项 Arr */
- (NSArray *)parserWithItemList:(NSArray *)itemList
{
    isItem = YES;
    NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i<itemList.count; i++) {
        NSString *itemDecript = [itemList[i] objectForKey:@"itemDecript"];
        NSString *bodyStr = [self getBodyStr:itemDecript];
        NSArray *bodyImgArr = [self handleTextAndImage:bodyStr];
        [itemArr addObject:bodyImgArr];
    }
    
    return [itemArr copy];
}

/** 解析 Arr */
- (NSArray *)parserWithAnalysis:(NSString *)analysis
{
    isItem = NO;
    if (analysis.length > 0) {
        NSString *bodyStr = [self getBodyStr:analysis];
        NSArray *bodyImgArr = [self handleTextAndImage:bodyStr];
        return [bodyImgArr copy];
    }
    return @[];
}

/** 解析材料 Arr */
- (NSArray *)parserWithMaterial:(NSString *)material
{
    isItem = NO;
    if (material.length > 0) {
        NSString *bodyStr = [self getBodyStr:material];
        NSArray *bodyImgArr = [self handleTextAndImage:bodyStr];
        return [bodyImgArr copy];
    }
    return @[];
}

// 处理：去掉 body\span
- (NSString *)getBodyStr:(NSString *)subjectHtml
{
    // 去富文本编辑器产生的空格 和分段
    subjectHtml = [subjectHtml stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    subjectHtml = [subjectHtml stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    
    NSRange bodyRangeF = [subjectHtml rangeOfString:@"<body>"];
    NSRange bodyRangeB = [subjectHtml rangeOfString:@"</body>"];
    
    // 处理是否包含 <body>
    NSString *subStrBodyF = nil;
    if (bodyRangeB.location == NSNotFound &&
        bodyRangeF.location == NSNotFound) {
        // 不包含 <body>
        subStrBodyF = subjectHtml;
    } else {
        NSString *subStrBodyB = [subjectHtml substringToIndex:bodyRangeB.location];
        subStrBodyF = [subStrBodyB substringFromIndex:(bodyRangeF.location+bodyRangeF.length)];
    }
    
    NSString *finalSubStr = nil;
    
    // 处理 <span 包含 ’underline‘ 的情况>
    // <span style="text-decoration: underline;">
    if ([subStrBodyF containsString:@"span"] && [subStrBodyF containsString:@"underline"]) {
        NSArray *subSentences = [subStrBodyF componentsSeparatedByString:@"</span>"];
        NSMutableString *subStrFinal = [NSMutableString string];
        for (int i = 0; i<[subSentences count]; i++) {
            NSString *eachSentence = subSentences[i];
            if ([eachSentence containsString:@"span"] && [eachSentence containsString:@"underline"]) {
                eachSentence = [eachSentence stringByReplacingOccurrencesOfString:@"<span style=\"text-decoration: underline;\">" withString:@"<underline>"];
                eachSentence = [eachSentence stringByReplacingOccurrencesOfString:@" " withString:@""];
                eachSentence = [eachSentence stringByAppendingString:@"</underline>"];
            }
            [subStrFinal appendString:eachSentence];
        }
        subStrBodyF = subStrFinal;
    }
    
    // subStrBodyF 为最后待处理的内容
    // subStrBodyF 只包含: @"<span class='desClass' > 以下图 </span>"
    // subStrBodyF 还可能包含不同的 <span> 故，需要多次处理
    if ([subStrBodyF containsString:@"span"]) {
        subStrBodyF = [subStrBodyF stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        // 存储 剔除span后的字符串 数组
        NSMutableString *resualtSpanStr = [NSMutableString stringWithString:subStrBodyF];
        if ([subStrBodyF containsString:@"<span"]) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<span[^>]*>"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            
            [regex replaceMatchesInString:resualtSpanStr
                                  options:0
                                    range:NSMakeRange(0, resualtSpanStr.length)
                             withTemplate:@""];
            subStrBodyF = resualtSpanStr;
        }
        finalSubStr = subStrBodyF;
    }else{
        finalSubStr = [subStrBodyF copy];
    }
    
    // 处理<font>标签
    if ([finalSubStr containsString:@"<font"] || [finalSubStr containsString:@"</font>"]) {
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
        // 存储 剔除font后的字符串 数组
        NSMutableString *resualtSpanStr = [NSMutableString stringWithString:finalSubStr];
        if ([finalSubStr containsString:@"<font"]) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<font[^>]*>"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            
            [regex replaceMatchesInString:resualtSpanStr
                                  options:0
                                    range:NSMakeRange(0, resualtSpanStr.length)
                             withTemplate:@""];
            finalSubStr = resualtSpanStr;
        }
    }
    
    // 处理注释
    if ([finalSubStr containsString:@"<!--"] && [finalSubStr containsString:@"-->"]) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<!--(.*?)-->"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSMutableString *resualtSpanStr = [NSMutableString stringWithString:finalSubStr];
        [regex replaceMatchesInString:resualtSpanStr
                              options:0
                                range:NSMakeRange(0, resualtSpanStr.length)
                         withTemplate:@""];
        finalSubStr = resualtSpanStr;
    }
    
    // 处理<P>标签
    if ([finalSubStr containsString:@"<p"]) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<p[^>]*>"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSMutableString *resualtSpanStr = [NSMutableString stringWithString:finalSubStr];
        [regex replaceMatchesInString:resualtSpanStr
                              options:0
                                range:NSMakeRange(0, resualtSpanStr.length)
                         withTemplate:@""];
        finalSubStr = resualtSpanStr;
    }
    
    // 处理开头处的空格
    if ([finalSubStr hasPrefix:@" "]) {
        do {
            finalSubStr = [finalSubStr substringFromIndex:1];
        } while ([finalSubStr hasPrefix:@" "]);
    }
    
    // 处理结尾处的空格 和换行
    // 处理结尾处的换行 \n是一个字符
    if ([finalSubStr hasSuffix:@" "] || [finalSubStr hasSuffix:@"\n"]) {
        do {
            finalSubStr = [finalSubStr substringToIndex:(finalSubStr.length-1)];
        } while ([finalSubStr hasSuffix:@" "] || [finalSubStr hasSuffix:@"\n"]);
    }
    
    if ([finalSubStr containsString:@"<em>"]) {
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    }
    
    if ([finalSubStr containsString:@"<strong"]) {
        // 去 加粗
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    }
    
    if ([finalSubStr containsString:@"<b>"]) {
        // 去 加粗
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
        finalSubStr = [finalSubStr stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    }
    
    if ([finalSubStr hasSuffix:@"<br/>"]) {
        do {
            finalSubStr = [finalSubStr substringToIndex:(finalSubStr.length-5)];
        } while ([finalSubStr hasSuffix:@"<br/>"]);
    }
    
    // 处理<br style=@"xxxx">标签
    if ([finalSubStr containsString:@"<br "]) {
        // 存储 剔除font后的字符串 数组
        NSMutableString *resualtSpanStr = [NSMutableString stringWithString:finalSubStr];
        if ([finalSubStr containsString:@"<br "]) {
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<br[^>]*>"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            
            [regex replaceMatchesInString:resualtSpanStr
                                  options:0
                                    range:NSMakeRange(0, resualtSpanStr.length)
                             withTemplate:@"\n"];
            finalSubStr = resualtSpanStr;
        }
    }
    
    // 处理HTML特殊字符
    if ([finalSubStr containsString:@"&"]) {
        finalSubStr = [HTMLHelper handleHTMLWithNormalEscapeChart:finalSubStr];
        if ([finalSubStr containsString:@"&"]) {
            finalSubStr = [HTMLHelper handleHTMLWithRareEscapeChart:finalSubStr];
        }
    }
    
    return [finalSubStr copy];
}

// 处理：分离 文字\图片
- (NSArray *)handleTextAndImage:(NSString *)subjectStr
{
    NSString *resultStr = [subjectStr copy];
    NSMutableArray *finalArr = [NSMutableArray arrayWithCapacity:3];
    if ([subjectStr containsString:@"<img"]) {
        NSMutableArray *imageRangeArr = [NSMutableArray array];
        NSError *error = NULL;
        // 分割图片--找到图片位置
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        [regex enumerateMatchesInString:subjectStr options:0 range:NSMakeRange(0, [subjectStr length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSLog(@"result:%@",result);
            // 判断是不是 img 开头
            NSString *tempStr = [subjectStr substringFromIndex:result.range.location];
            if ([tempStr hasPrefix:@"<img"]) {
                [imageRangeArr addObject:NSStringFromRange(result.range)];
            }
        }];
        
        // 最终的 图片 文字数组
        NSMutableArray *infoArr = [NSMutableArray array];
        for (NSInteger i = imageRangeArr.count-1; i>=0; i--) {
            // 图片的位置
            NSRange imageRange = NSRangeFromString(imageRangeArr[i]);
            if (imageRange.location+imageRange.length < resultStr.length) {
                NSString *subStr = [resultStr substringFromIndex:(imageRange.location+imageRange.length)];
                resultStr = [resultStr substringToIndex:(imageRange.location+imageRange.length)];
                NSArray *subStrArr = [subStr componentsSeparatedByString:@" "];
                if (!([subStrArr count]==1 &&
                      [[subStrArr lastObject] isEqualToString:@""])) {
                    [infoArr insertObject:subStr atIndex:0];
                }
            }
            NSString *imageStr = [resultStr substringFromIndex:imageRange.location];
            [infoArr insertObject:imageStr atIndex:0];
            resultStr = [resultStr substringToIndex:(imageRange.location)];
        }
        // 处理开头是 (xx题)的情况
        if ([resultStr hasPrefix:@"(单选题)"] ||
            [resultStr hasPrefix:@"(多选题)"] ||
            [resultStr hasPrefix:@"(判断题)"] ||
            [resultStr hasPrefix:@"(不定项)"]) {
            NSString *lastStr = [resultStr substringFromIndex:5];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:5] atIndex:0];
        } else if ([resultStr hasPrefix:@"(材料)"]) {
            NSString *lastStr = [resultStr substringFromIndex:4];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:4] atIndex:0];
        } else if ([resultStr hasPrefix:@"(不定项选择)"]) {
            NSString *lastStr = [resultStr substringFromIndex:7];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:7] atIndex:0];
        } else if ([resultStr hasPrefix:@"(不定项选择题)"]) {
            NSString *lastStr = [resultStr substringFromIndex:8];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:8] atIndex:0];
        } else {
            [infoArr insertObject:resultStr atIndex:0];
        }
        
        // 处理文字换行
        for (int i = 0; i<infoArr.count; i++) {
            NSString *eachLineStr = infoArr[i];
            if (![eachLineStr hasPrefix:@"<img"]) {
                eachLineStr = [eachLineStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            }
            
            [finalArr addObject:eachLineStr];
        }
        
    } else {
        // 最终的 图片 文字数组
        NSMutableArray *infoArr = [NSMutableArray array];
        // 处理开头是 (xx题)的情况
        if ([resultStr hasPrefix:@"(单选题)"] ||
            [resultStr hasPrefix:@"(多选题)"] ||
            [resultStr hasPrefix:@"(判断题)"] ||
            [resultStr hasPrefix:@"(不定项)"]) {
            NSString *lastStr = [resultStr substringFromIndex:5];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:5] atIndex:0];
        } else if ([resultStr hasPrefix:@"(材料)"]) {
            NSString *lastStr = [resultStr substringFromIndex:4];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:4] atIndex:0];
        } else if ([resultStr hasPrefix:@"(不定项选择)"]) {
            NSString *lastStr = [resultStr substringFromIndex:7];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:7] atIndex:0];
        } else if ([resultStr hasPrefix:@"(不定项选择题)"]) {
            NSString *lastStr = [resultStr substringFromIndex:8];
            [infoArr insertObject:lastStr atIndex:0];
            [infoArr insertObject:[resultStr substringToIndex:8] atIndex:0];
        } else {
            [infoArr insertObject:resultStr atIndex:0];
        }
        
        // 处理文字换行
        for (int i = 0; i<infoArr.count; i++) {
            NSString *eachLineStr = infoArr[i];
            eachLineStr = [eachLineStr stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            [finalArr addObject:eachLineStr];
        }
    }
    
    if ([subjectStr containsString:@"<sub>"]) {
        NSArray *tempArr = [self handleSubTagWithArr:finalArr];
        [finalArr removeAllObjects];
        [finalArr addObjectsFromArray:tempArr];
    }
    
    if ([subjectStr containsString:@"<underline>"]) {
        NSArray *tempArr = [self handleUnderlineTagWithArr:finalArr];
        [finalArr removeAllObjects];
        [finalArr addObjectsFromArray:tempArr];
    }
    
    NSArray *returnArr = [self translateOriginArrToStandard:finalArr];
    return [returnArr copy];
}

// 将<sub>标签分离出来
- (NSArray *)handleSubTagWithArr:(NSArray *)originArr
{
    NSMutableArray *finalArr = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i<[originArr count]; i++) {
        NSString *tempStr = originArr[i];
        @autoreleasepool {
            if ([tempStr containsString:@"<sub>"]) {
                [finalArr addObjectsFromArray:[tempStr componentsSeparatedByString:@"<sub>"]];
            } else {
                [finalArr addObject:originArr[i]];
            }
        }
    }
    return finalArr;
}

// 将<underline>标签分离出来
- (NSArray *)handleUnderlineTagWithArr:(NSArray *)originArr
{
    NSMutableArray *finalArr = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i<[originArr count]; i++) {
        NSString *tempStr = originArr[i];
        @autoreleasepool {
            if ([tempStr containsString:@"<underline>"]) {
                [finalArr addObjectsFromArray:[tempStr componentsSeparatedByString:@"<underline>"]];
            } else {
                [finalArr addObject:originArr[i]];
            }
        }
    }
    return finalArr;
}

    /** 将原始数组转成标准数组 */
    /**
        {
            "color" : "0x9C9C9C",
            "content" : "阅读量:232 作者：boy \n",
            "size" : 12,
            "type" : "txt"
         },
         {
             "type" : "img",
             "width" : 300,
             "height" : 160,
             "name" : "coretext-image-1.jpg"
         }
     */
- (NSArray *)translateOriginArrToStandard:(NSArray *)originArr
{
    NSMutableArray *mutiArr = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i<originArr.count; i++) {
        NSString *originStr = originArr[i];
        
        if ([originStr hasPrefix:@"<img"]) {
            NSInteger width = [self getLenghtWith:@"width" andOriginImg:[originStr copy]];
            NSInteger height = [self getLenghtWith:@"height" andOriginImg:[originStr copy]];
            NSString *src = [self getImageURL:[originStr copy]];
            [self.imageArr addObject:[src copy]];
            
            NSInteger originWidth = 0;
            // 处理图片宽度问题
            if (isItem) {
                if (width >= SCREEN_WIDTH-64) {
                    originWidth = width;
                    width = SCREEN_WIDTH-64;
                    height = (1.0*height*width)/originWidth;
                }
            }else{
                if (width >= SCREEN_WIDTH-20) {
                    originWidth = width;
                    if (SCREEN_WIDTH >= 375) {
                        width = SCREEN_WIDTH-25;
                    }else{
                        width = 375-25;
                    }
                    height = (1.0*height*width)/originWidth;
                }
            }
            
            // 处理下载图片路径
            NSArray *imgPathArr = [src componentsSeparatedByString:@"/"];
            src = [imgPathArr lastObject];
            
            NSDictionary *dic = @{@"type"   :   @"img", //COLOR_YellowBlack
                                  @"width"  :   @(width),
                                  @"height" :   @(height),
                                  @"name"   :   src};
            [mutiArr addObject:dic];
        } else {
            
            NSDictionary *dic = [NSDictionary dictionary];
            // 处理开头是 (xx题)的情况
            if ([originStr hasPrefix:@"(单选题)"] ||
                [originStr hasPrefix:@"(多选题)"] ||
                [originStr hasPrefix:@"(判断题)"] ||
                [originStr hasPrefix:@"(不定项)"] ||
                [originStr hasPrefix:@"(材料)"] ||
                [originStr hasPrefix:@"(不定项选择)"] ||
                [originStr hasPrefix:@"(不定项选择题)"]) {
                dic = @{@"color"  :   @"0xF8B62D", //NavDefaultColor
                        @"content":   originStr,
                        @"size"   :   @(15),
                        @"type"   :   @"txt"};
                [mutiArr addObject:dic];
            } else {
                if ([originStr containsString:@"</sub>"]) {
                    NSArray *subarr = [originStr componentsSeparatedByString:@"</sub>"];
                    NSDictionary *subDic = @{@"color"  :   @"0x505050",//COLOR_YellowBlack
                                             @"content":   subarr[0],
                                             @"size"   :   @(10),
                                             @"type"   :   @"txt"};
                    dic = @{@"color"  :   @"0x505050",//COLOR_YellowBlack
                            @"content":   subarr[1],
                            @"size"   :   @(15),
                            @"type"   :   @"txt"};
                    [mutiArr addObject:subDic];
                    [mutiArr addObject:dic];
                } else if ([originStr containsString:@"</underline>"]) {
                    NSArray *subarr = [originStr componentsSeparatedByString:@"</underline>"];
                    NSDictionary *subDic = @{@"color"  :   @"0x505050",//COLOR_YellowBlack
                                             @"content":   subarr[0],
                                             @"size"   :   @(15),
                                             @"type"   :   @"underline"};
                    dic = @{@"color"  :   @"0x505050",//COLOR_YellowBlack
                            @"content":   subarr[1],
                            @"size"   :   @(15),
                            @"type"   :   @"txt"};
                    [mutiArr addObject:subDic];
                    [mutiArr addObject:dic];
                } else {
                    dic = @{@"color"  :   @"0x505050",//COLOR_YellowBlack
                            @"content":   originStr,
                            @"size"   :   @(15),
                            @"type"   :   @"txt"};
                    [mutiArr addObject:dic];
                }
            }
        }
    }
    return [mutiArr copy];
}

// 获取 宽度 或 高度
- (NSInteger)getLenghtWith:(NSString *)lengthStr andOriginImg:(NSString *)imageStr
{
    NSArray *subArr = [imageStr componentsSeparatedByString:@" "];
    for (int i=0; i<subArr.count; i++) {
        if ([subArr[i] containsString:lengthStr]) {
            NSRange titleRange = [subArr[i] rangeOfString:lengthStr];
            NSString *tempStr = [subArr[i] substringFromIndex:(titleRange.location+titleRange.length+1)];
            if ([tempStr containsString:@"'"]) {
                tempStr = [tempStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
            } else {
                tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            
            return [tempStr integerValue];
        }
    }
    return 0;
}

// 获取照片路径
- (NSString *)getImageURL:(NSString *)imageStr
{
    NSArray *subArr = [imageStr componentsSeparatedByString:@" "];
    for (int i=0; i<subArr.count; i++) {
        NSString *tempImageStr = subArr[i];
        if ([tempImageStr containsString:@"src"]) {
            NSRange titleRange = [tempImageStr rangeOfString:@"src"];
            NSString *tempStr = [tempImageStr substringFromIndex:(titleRange.location+titleRange.length+1)];
            if ([tempStr containsString:@"'"]) {
                tempStr = [tempStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
                if ([tempStr hasSuffix:@"/>"]) {
                    tempStr = [tempStr substringToIndex:(tempStr.length-2)];
                }
            } else {
                tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                if ([tempStr hasSuffix:@"/>"]) {
                    tempStr = [tempStr substringToIndex:(tempStr.length-2)];
                }
            }
            if ([tempStr isEqualToString:@""]) {
                continue;
            }else{
                return [tempStr copy];
            }
        }else{
            if ([tempImageStr containsString:@".jpg"] ||
                [tempImageStr containsString:@".png"] ||
                [tempImageStr containsString:@".gif"] ||
                [tempImageStr containsString:@".jpeg"] ||
                [tempImageStr containsString:@".bmp"]) {
                // 出现空格不能分离的情况
                NSString *tempStr = tempImageStr;
                if ([tempStr containsString:@"title"] || [tempStr containsString:@"alt"]) {
                    continue;
                }
                if ([tempStr containsString:@"'"]) {
                    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"'" withString:@""];
                    if ([tempStr hasSuffix:@"/>"]) {
                        tempStr = [tempStr substringToIndex:(tempStr.length-2)];
                    }
                } else {
                    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    if ([tempStr hasSuffix:@"/>"]) {
                        tempStr = [tempStr substringToIndex:(tempStr.length-2)];
                    }
                }
                return [tempStr copy];
            }
        }
    }
    return nil;
}

/** 下载试卷里的图片 */
- (void)downloadSubjectImages
{
    if (self.imageArr.count == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSMutableArray *imagesArr = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i<weakSelf.imageArr.count; i++) {
            GetImageApi *tempImg = [[GetImageApi alloc] initWithImageId:self.imageArr[i]];
            [imagesArr addObject:tempImg];
        }
        paperImages = [NSMutableArray arrayWithArray:imagesArr];

        dispatch_async(dispatch_get_main_queue(), ^{
            YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:imagesArr];
            [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
                NSLog(@"Images Succeed");
                NSArray *requests = batchRequest.requestArray;
                for (int i = 0; i<requests.count; i++) {
                    GetImageApi *tempApi = (GetImageApi *)requests[i];
                    NSLog(@"tempApi:%@",tempApi);
                }
                
                NSString *tempPath = [SubjectHtmlParser getImageFilePath];
                NSArray *tempArr = [weakSelf insideFileNumOfPath:tempPath];
                NSLog(@"tempArr:%@",tempArr);
                
                // [[NSNotificationCenter defaultCenter] postNotificationName:kGetSubjectImageNotice object:PublicURL];
            } failure:^(YTKBatchRequest *batchRequest) {
                NSLog(@"Images Failed");
            }];
        });
    });
}

+ (NSString *)getImageFilePath
{
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches/Images"];
    return [cachePath copy];
}

/** 获取存储的照片文件 */
+ (UIImage *)getInputImage:(NSString *)imageName
{
    NSString *filePath = [SubjectHtmlParser getImageFilePath];
    // SubjectHtmlParser *htmlParser = [[SubjectHtmlParser alloc] init];
    // NSArray *tempArr = [htmlParser insideFileNumOfPath:filePath];
    NSString *imagePath = [filePath stringByAppendingPathComponent:imageName];
    // BOOL imageExist = [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
    
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    if (!image) {
        // 下载该图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            // 对应图片的路径
            GetImageApi *tempImg = nil;
            NSMutableArray *imagesArr = [NSMutableArray arrayWithCapacity:2];
            for (GetImageApi *imageApi in paperImages) {
                if ([imageApi.imgId containsString:imageName]) {
                    tempImg = imageApi;
                    break;
                }
            }
            if (tempImg) {
                [imagesArr addObject:tempImg];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:imagesArr];
                    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
                        NSLog(@"Images Succeed");
                        NSArray *requests = batchRequest.requestArray;
                        for (int i = 0; i<requests.count; i++) {
                            GetImageApi *tempApi = (GetImageApi *)requests[i];
                            NSLog(@"tempApi:%@",tempApi);
                        }
                        
                        NSString *filePath = [SubjectHtmlParser getImageFilePath];
                        NSString *imagePath = [filePath stringByAppendingPathComponent:imageName];
                        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
                        NSLog(@"newImage:%@",image);
                        if ([[[TMCache sharedCache] objectForKey:@"Subject_Count"] intValue] < 3) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kGetSubjectImageNotice object:PublicURL];
                        }
                    } failure:^(YTKBatchRequest *batchRequest) {
                        NSLog(@"Images Failed");
                    }];
                });
            }
        });
    }
    NSLog(@"\nfilePath:%@\nimagePath:%@\nimage:%@",filePath,imagePath,image);
    return image;
}

/** 获取图片文件夹中的文件个数 */
- (NSArray *)insideFileNumOfPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([self hasFilePath:filePath]) {
        NSArray *subFiles = [manager subpathsAtPath:filePath];
        return subFiles;
    }else{
        return nil;
    }
}

#pragma mark 文件路径
/** 是否有存储图片的路径 */
- (BOOL)hasFilePath:(NSString *)filePath
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return exists;
}

@end
