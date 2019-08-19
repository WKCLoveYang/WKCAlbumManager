//
//  ViewController.m
//  Demo
//
//  Created by wkcloveYang on 2019/8/19.
//  Copyright © 2019 wkcloveYang. All rights reserved.
//

#import "ViewController.h"
#import <WKCAlbumManager.h>
#import "WKCMainListCell.h"
#import "DetailViewController.h"

@interface ViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <WKCAlbum *> * albums;

@end

@implementation ViewController

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WKCAlbumManager.shared premissionHandle:^(WKCAlbumManager *manager, BOOL isPremissioned) {
        if (isPremissioned) {
            [manager requestPhotoData];
            [self reloadData];
        } else {
            [self showNoPremissionAlert];
        }
    }];
    
    [WKCAlbumManager.shared requestPhotoData];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadData) name:WKCAlbumPhotoChangedNotification object:nil];
    
    [self.collectionView registerClass:WKCMainListCell.class forCellWithReuseIdentifier:NSStringFromClass(WKCMainListCell.class)];
}

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)showNoPremissionAlert
{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"没开权限" message:@"请前往设置开权限" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confrim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertVC addAction:confrim];
    alertVC.popoverPresentationController.sourceRect = self.view.bounds;
    alertVC.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return WKCMainListCell.itemSize;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return WKCAlbumManager.shared.albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WKCMainListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(WKCMainListCell.class) forIndexPath:indexPath];
    WKCAlbum * album = WKCAlbumManager.shared.albums[indexPath.row];
    cell.titleLabel.text = album.collection.localizedTitle;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", album.photos.count];
    [album.photos.firstObject ftechPhoto:^(UIImage *photo) {
        cell.iconImageView.image = photo;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   WKCAlbum * album = WKCAlbumManager.shared.albums[indexPath.row];
    
    DetailViewController * detailVC = [[DetailViewController alloc] initWithAlbum:album];
    detailVC.navigationItem.title = album.collection.localizedTitle;
    [self.navigationController pushViewController:detailVC
                                         animated:YES];
}

@end
