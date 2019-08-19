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
    
    // 进入前台刷新数据
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refeshData) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)refeshData
{
    [WKCAlbumManager.shared requestPhotoData];
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
        _collectionView.contentInset = UIEdgeInsetsMake(20, 8, 40, 8);
        [_collectionView registerClass:WKCDetailCell.class forCellWithReuseIdentifier:NSStringFromClass(WKCDetailCell.class)];
    }
    
    return _collectionView;
}

#pragma mark -UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WKCDetailCell.class) forIndexPath:indexPath];
    WKCPhoto * photo = _album.photos[indexPath.row];
    [photo fetchThumbAtSize:WKCDetailCell.itemSize handle:^(UIImage *photo) {
        [cell.iconImageView alphaLoadImage:photo];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCPhoto * photo = _album.photos[indexPath.row];
    [photo fetchPhoto:^(UIImage *photo) {
        [WKCPhotoAlertView showWithImage:photo];
    }];
}

#pragma mark -UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    // 预加载
    for (NSIndexPath * indexPath in indexPaths) {
        WKCPhoto * photo = _album.photos[indexPath.row];
        [photo fetchThumbAtSize:WKCDetailCell.itemSize handle:nil];
    }
}


@end
