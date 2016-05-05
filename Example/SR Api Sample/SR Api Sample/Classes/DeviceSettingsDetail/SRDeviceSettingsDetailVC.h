//
//  SRDeviceSettingsDetailVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRDeviceSettingsDetailDelegate <NSObject>

@optional

-(void)saveDeviceDetailData:(NSString *)aStrData aIntType:(int)aIntType;

@end

@interface SRDeviceSettingsDetailVC : UITableViewController

@property(nonatomic,assign)int intType;
@property (nonatomic,retain)NSArray *arrData;
@property (nonatomic,retain)NSString *strCurrentValue;
@property (nonatomic,retain)id<SRDeviceSettingsDetailDelegate> delegate;
@end
