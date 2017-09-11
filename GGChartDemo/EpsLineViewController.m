//
//  EpsLineViewController.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "EpsLineViewController.h"
#import "BaseModel.h"
#import "LineCanvas.h"
#import "LineDataSet.h"
#import "GGLineData.h"
#import "GridBackCanvas.h"
#import "GGChartDefine.h"
#import "GGLineChart.h"
#import "NSArray+Stock.h"

@interface Eps : BaseModel

@property (nonatomic) CGFloat eps_y1;

@property (nonatomic) CGFloat eps_y2;

@property (nonatomic) CGFloat close_price;

@property (nonatomic) NSInteger equity_change;

@end

@implementation Eps


@end

#pragma mark - EpsLineViewController

@interface EpsLineViewController ()

@end

@implementation EpsLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"EPS";
    
    NSData * dataTimeStock = [NSData dataWithContentsOfFile:[self epsStockDataJsonPath]];
    NSArray * stockEpsJson = [NSJSONSerialization JSONObjectWithData:dataTimeStock options:0 error:nil];
    NSArray * epsData = [BaseModel arrayForArray:stockEpsJson class:[Eps class]];
    
    NSArray * stockPrice = [epsData numbarArrayForKey:@"close_price"];
    NSArray * epsY1 = [epsData numbarArrayForKey:@"eps_y1"];
    NSArray * epsY2 = [epsData numbarArrayForKey:@"eps_y2"];
    
    GGLineData * liney1 = [[GGLineData alloc] init];
    liney1.lineWidth = .5f;
    liney1.lineColor = RGB(234, 120, 86);
    liney1.dataAry = epsY1;
    
    GGLineData * liney2 = [[GGLineData alloc] init];
    liney2.lineWidth = .5f;
    liney2.lineColor = RGB(181, 220, 249);
    liney2.dataAry = epsY2;
    
    GGLineData * line = [[GGLineData alloc] init];
    line.lineWidth = 1.2;
    line.lineColor = RGB(202, 71, 33);
    line.dataAry = stockPrice;
    line.scalerMode = ScalerAxisRight;
//    line.shapeRadius = 3.0f;
//    line.shapeFillColor = [UIColor whiteColor];
    
    NSArray * bottomLables = @[@"02", @"03", @"03", @"04", @"04", @"05", @"05", @"06", @"06", @"07", @"07"];
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.insets = UIEdgeInsetsMake(30, 50, 30, 50);
    lineSet.lineAry = @[liney1, liney2, line];
    lineSet.idRatio = .2f;
    
    /** 查价 */
    lineSet.queryConfig.lineWidth = .5f;
    lineSet.queryConfig.lineColor = RGB(186, 167, 169);
    lineSet.queryConfig.dashPattern = @[@2, @4, @2];
    lineSet.queryConfig.lableInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    
    /** 网格 */
    lineSet.gridConfig.lineColor = RGB(186, 167, 169);
    lineSet.gridConfig.lineWidth = .7f;
    lineSet.gridConfig.axisLineColor = [UIColor blackColor];
    lineSet.gridConfig.axisLableFont = [UIFont systemFontOfSize:8.5];
    lineSet.gridConfig.axisLableColor = RGB(186, 167, 169);
    //lineSet.gridConfig.dashPattern = @[@2, @4, @2];
    
    /** 底轴 */
    lineSet.gridConfig.bottomLableAxis.lables = bottomLables;
    lineSet.gridConfig.bottomLableAxis.over = 2;
    lineSet.gridConfig.bottomLableAxis.hiddenPattern = @[@2];
    lineSet.gridConfig.bottomLableAxis.showSplitLine = YES;
    lineSet.gridConfig.bottomLableAxis.showQueryLable = YES;
    
    /** 左轴 */
    lineSet.gridConfig.leftNumberAxis.splitCount = 5;
    lineSet.gridConfig.leftNumberAxis.dataFormatter = @"%.2f";
    lineSet.gridConfig.leftNumberAxis.over = 3;
    lineSet.gridConfig.leftNumberAxis.showSplitLine = YES;
    lineSet.gridConfig.leftNumberAxis.showQueryLable = YES;
    lineSet.gridConfig.leftNumberAxis.name.string = @"EPS";
    lineSet.gridConfig.leftNumberAxis.name.offSetSize = CGSizeMake(0, -15);
    lineSet.gridConfig.leftNumberAxis.name.offSetRatio = CGPointMake(-1, -0.5);
    lineSet.gridConfig.leftNumberAxis.name.font = [UIFont boldSystemFontOfSize:10];
    lineSet.gridConfig.leftNumberAxis.name.color = RGB(181, 220, 249);
    
    /** 右轴 */
    lineSet.gridConfig.rightNumberAxis.splitCount = 5;
    lineSet.gridConfig.rightNumberAxis.over = -3;
    lineSet.gridConfig.rightNumberAxis.showQueryLable = YES;
    lineSet.gridConfig.rightNumberAxis.name.string = @"股票价格";
    lineSet.gridConfig.rightNumberAxis.name.font = [UIFont boldSystemFontOfSize:10];
    lineSet.gridConfig.leftNumberAxis.name.offSetRatio = CGPointMake(-1, -0.5);
    lineSet.gridConfig.rightNumberAxis.name.offSetSize = CGSizeMake(0, -15);
    lineSet.gridConfig.rightNumberAxis.name.color = RGB(181, 220, 249);
    
    CGRect rect = CGRectMake(0, 190, [UIScreen mainScreen].bounds.size.width, 250);
    GGLineChart * lineChart = [[GGLineChart alloc] initWithFrame:rect];
    lineChart.lineDataSet = lineSet;
    [lineChart drawLineChart];
    [self.view addSubview:lineChart];
}

- (NSString *)epsStockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"eps_line_data" ofType:@"json"];
}

@end