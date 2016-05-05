//
//  TxPowerSettingsVC.h
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TxPowerDelegate <NSObject>

@optional

-(void)saveTxPowerValue:(int)aIntTxPower;

@end

@interface TxPowerSettingsVC : UITableViewController

@property (nonatomic, strong) NSString *strTxPower;
@property (nonatomic) int aIntPower;
@property (nonatomic,retain)id<TxPowerDelegate> delegate;

@end
