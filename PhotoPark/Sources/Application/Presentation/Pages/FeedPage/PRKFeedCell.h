//
//  PRKFeedCell.h
//  PhotoPark
//
//  Created by Pavel Osipov on 02.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRKFeedCell : UICollectionViewCell

@property (nonatomic) UIImageView *thumbnailView;

+ (NSString *)reuseIdentifier;

@end
