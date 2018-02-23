//
//  ViewController.m
//  wakywaky
//
//  Created by Yas Abdolmaleki on 2018-02-05.
//  Copyright © 2018 Yas Marcu. All rights reserved.
//

#import "ViewController.h"
#import "AlertCollectionViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *AlertsCollectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.AlertsCollectionView.delegate = self;
    [self.AlertsCollectionView registerNib:[UINib nibWithNibName:@"AlertCollectionViewCell" bundle:nil]
                forCellWithReuseIdentifier:@"AlertCollectionViewCell"];
    [self.AlertsCollectionView reloadData];
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlertCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //TBD
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(collectionView.frame.size.width,60);
}

@end
