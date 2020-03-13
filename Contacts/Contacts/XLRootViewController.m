//
//  ViewController.m
//  Contacts
//
//  Created by chenxiaolong on 2020/3/12.
//  Copyright © 2020 chenxiaolong. All rights reserved.
//

#import "XLRootViewController.h"
#import "XLContactCell.h"
#import "XLContact.h"
#import "XLCreateContactController.h"

@interface XLRootViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *cardView;

@end

@implementation XLRootViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self.cardView registerNib:[UINib nibWithNibName:@"XLContactCell" bundle:nil] forCellWithReuseIdentifier:@"XLContactCell"];
    self.title = @"电话本";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(addContact)];
}

- (void)addContact {
    XLCreateContactController* createVC = [[XLCreateContactController alloc] initWithNibName:@"XLCreateContactController" bundle:nil];
    [self.navigationController pushViewController:createVC animated:YES];
}


#pragma mark - UICollectionViewDelegate && DataSource
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XLContactCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XLContactCell" forIndexPath:indexPath];
//    STTile* tile = [[self.pageModel boxAtIndex:indexPath.section] tileAtIndex:indexPath.row];
//    [cell configWithData:tile];
    return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
//    return self.pageModel.boxCount;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
//    return  [self.pageModel boxAtIndex:section].tileCount;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - 25*2, 140);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(22, 25, 22, 25);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)dealloc {
    
}
@end
