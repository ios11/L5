//
//  PRKFeedViewController.m
//  PhotoPark
//
//  Created by Pavel Osipov on 02.04.15.
//  Copyright (c) 2015 Pavel Osipov. All rights reserved.
//

#import "PRKFeedViewController.h"
#import "PRKFeedCell.h"
#import "PRKAppAssembly.h"
#import "PRKAuthenticator.h"
#import "PRKNodeFecher.h"
#import "PRKThumbnailFetcher.h"
#import "PRKMediaNode.h"
#import "NSString+PRKInfrastructure.h"
#import <RDHCollectionViewGridLayout/RDHCollectionViewGridLayout.h>

@interface PRKFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, readonly, weak) PRKAppAssembly *assembly;
@property (nonatomic, readonly, copy) NSArray *nodes;
@property (nonatomic, weak) UICollectionView *feedView;
@end

@implementation PRKFeedViewController

POSRX_DEADLY_INITIALIZER(init)

- (instancetype)initWithAssembly:(PRKAppAssembly *)assembly {
    POSRX_CHECK(assembly);
    if (self = [super init]) {
        _assembly = assembly;
        _nodes = [NSArray new];
        [self p_setupNavigationBar];
    }
    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    UICollectionView *rootView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                    collectionViewLayout:[self.class newGridLayout]];
    rootView.delegate = self;
    rootView.dataSource = self;
    self.feedView = rootView;
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedView.backgroundColor = [UIColor lightGrayColor];
    [self.feedView registerClass:[PRKFeedCell class] forCellWithReuseIdentifier:[PRKFeedCell reuseIdentifier]];
}

#pragma mark - UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _nodes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[PRKFeedCell reuseIdentifier]
                                                     forIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView
      willDisplayCell:(PRKFeedCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath {
    PRKMediaNode *node = _nodes[indexPath.item];
    id<PRKThumbnailFetcher> thumbnailFecher = self.assembly.BL.thumbnailFetcher;
    [thumbnailFecher schedule:^{
        [[[thumbnailFecher fetchThumbnailForNode:node] deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(UIImage *image) {
             [cell.thumbnailView setImage:image];
         } error:^(NSError *error) {
             NSLog(@"Failed to thumbnail: %@", error);
         }];
    }];
}

#pragma mark - Private

- (void)setNodes:(NSArray *)nodes {
    _nodes = nodes;
    [_feedView reloadData];
}

- (void)p_setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                             target:self
                                             action:@selector(p_updateDataSource)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Sign Out"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(p_signOut)];
    self.title = [@"MainFeedTitle" prk_localized];
}

- (void)p_updateDataSource {
    id<PRKNodeFetcher> nodeFecher = self.assembly.BL.nodeFetcher;
    [nodeFecher schedule:^{
        [[[nodeFecher fetchNodes] deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSArray *nodes) {
             NSLog(@"Number of fetched nodes: %@", @(nodes.count));
             self.nodes = nodes;
         } error:^(NSError *error) {
             NSLog(@"Failed to fetch nodes: %@", error);
         } completed:^{
             NSLog(@"done");
         }];
    }];
}

- (void)p_signOut {
    [self.assembly.UI.authenticator signOut];
}

+ (RDHCollectionViewGridLayout *)newGridLayout {
    RDHCollectionViewGridLayout *layout = [RDHCollectionViewGridLayout new];
    layout.itemSpacing = 1;
    layout.lineSpacing = 1;
    layout.lineSize = 0;
    layout.lineItemCount = 3;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionsStartOnNewLine = YES;
    return layout;
}

@end
