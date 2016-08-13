//
//  PractiseViewController.m
//  CoreDataLearn
//
//  Created by 高继鹏 on 16/6/24.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "PractiseViewController.h"
#import "PractiseCell.h"

#define kBannerSize CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kMaxSections 2

@interface PractiseViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

/** 题目数组 */
@property (nonatomic, strong) NSArray *subjects;

/** CollectionView */
@property (nonatomic, strong) UICollectionView * collectionView;

/** 计时器 */
@property (nonatomic, strong) NSTimer * timer;

@end

@implementation PractiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
}

- (NSArray *)subjects
{
    if (_subjects == nil) {
        _subjects = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    }
    return _subjects;
}

#pragma mark - UICollectionView
- (void)setupCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = kBannerSize;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kBannerSize.width, kBannerSize.height) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.contentSize = CGSizeMake(self.subjects.count * kBannerSize.width, 0);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PractiseCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PractiseCell class])];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)nextpage
{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    // 重置indexpath
    NSInteger nextItem = currentIndexPath.item + 1;
    NSInteger nextSection = currentIndexPath.section;
    
    if (nextItem == self.subjects.count-1) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kMaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.subjects.count-1;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PractiseCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PractiseCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[PractiseCell alloc] init];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"第%ld题",(long)indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index.row:%ld",(long)indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
