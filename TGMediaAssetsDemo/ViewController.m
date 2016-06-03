//
//  ViewController.m
//  TGMediaAssetsDemo
//
//  Created by Herui on 2/6/2016.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "ViewController.h"
#import "TGMediaAssets.h"
#import <SSignalKit/SSignalKit.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) TGMediaAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) SMetaDisposable *assetsDisposable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak ViewController *weakSelf = self;
    
    _assetsLibrary = [TGMediaAssetsLibrary libraryForAssetType:TGMediaAssetPhotoType];
    _assetsDisposable = [[SMetaDisposable alloc] init];
    
    
    [[[[[[TGMediaAssetsLibrary authorizationStatusSignal] mapToSignal:^SSignal *(NSNumber *statusValue) {
        
        __strong ViewController *strongSelf = weakSelf;
        if (strongSelf == nil)
            return [SSignal complete];
        
        TGMediaLibraryAuthorizationStatus status = (int32_t)statusValue.intValue;
        if (status == TGMediaLibraryAuthorizationStatusAuthorized) {
            return [[strongSelf->_assetsLibrary cameraRollGroup] mapToSignal:^SSignal *(TGMediaAssetGroup *cameraRollGroup)
                    {
                        return [strongSelf->_assetsLibrary assetsOfAssetGroup:cameraRollGroup reversed:true];
                    }];
        } else {
            return [SSignal fail:nil];
        }
        
    }] mapToSignal:^SSignal *(id value) {
        
        __strong ViewController *strongSelf = weakSelf;
        if (strongSelf == nil)
            return [SSignal complete];
        
        return [SSignal single:value];
        
        
    }] deliverOn:[SQueue mainQueue]] mapToSignal:^SSignal *(id next) {
        if ([next isKindOfClass:[TGMediaAssetFetchResult class]]) {
            TGMediaAssetFetchResult *fetchResult = (TGMediaAssetFetchResult *)next;
            TGMediaAsset *asset = [fetchResult assetAtIndex:0];
            return  [TGMediaAssetImageSignals imageForAsset:asset imageType:TGMediaAssetImageTypeFastLargeThumbnail size:CGSizeMake(floor(250 * 2), floor(250 * 2))];
        }
        if ([next isKindOfClass:[TGMediaAssetFetchResultChange class]]) {
            // TGMediaAssetFetchResultChange *change = (TGMediaAssetFetchResultChange *)next;
            
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            return nil;
        }
        return nil;

    }] startWithNext:^(id next) {
        
        if ([next isKindOfClass:[UIImage class]]) {
            self.imageView.image = next;
        }
        
    } error:^(id error) {
        
        NSLog(@"error");
        
    } completed:^{
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
