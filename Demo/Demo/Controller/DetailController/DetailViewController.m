//
//  DetailViewController.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "DetailViewController.h"
#import <Masonry.h>
#import "WKCDetailCell.h"
#import "UIImageView+CommonAlphaLoad.h"
#import "WKCPhotoAlertView.h"

@interface DetailViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSourcePrefetching>

@property (nonatomic, strong) WKCAlbum * album;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation DetailViewController

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)initWithAlbum:(WKCAlbum *)album
{
    if (self = [super init]) {
        _album = album;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.itemSize = WKCDetailCell.itemSize;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.prefetchDataSource = self;
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = nil;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        [_collectionView registerClass:WKCDetailCell.class forCellWithReuseIdentifier:NSStringFromClass(WKCDetailCell.class)];
    }
    
    return _collectionView;
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _album.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WKCDetailCell.class) forIndexPath:indexPath];
    WKCAlbumItem * item = _album.items[indexPath.row];
    [item fetchImageThumbAtSize:WKCDetailCell.itemSize handle:^(UIImage *image, NSDictionary *info) {
        cell.iconImageView.image = image;
        [item fetchImageWithiCloudAnalyseHandle:^(BOOL isIniCloud) {
            cell.iCloudImageView.hidden = !isIniCloud;
        }];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCAlbumItem * item = _album.items[indexPath.row];
    [item fetchImageOrGifDataHandle:^(NSData *data, NSDictionary *info) {
        [WKCPhotoAlertView showWithImage:[YYImage imageWithData:data]];
    }];
}

#pragma mark -UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    NSMutableArray * array = [NSMutableArray array];
    // 预加载
    for (NSIndexPath * indexPath in indexPaths) {
        WKCAlbumItem * item = _album.items[indexPath.row];
        [array addObject:item.asset];
    }
    
    [WKCCacheManager.shared startCacheAssets:array targetSize:WKCDetailCell.itemSize options:WKCAlbumParams.shared.imageOptions];
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [WKCCacheManager.shared stopCacheAssets];
}

@end
