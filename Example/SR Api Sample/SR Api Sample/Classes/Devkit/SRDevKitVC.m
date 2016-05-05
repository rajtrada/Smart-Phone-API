//
//  SRDevKitVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRDevKitVC.h"
#import "SRRelaysVC.h"
#import "SRSolenoidVC.h"
#import "SRMotorVC.h"
#import "SRStatusVC.h"
#import "SRTempSensorVC.h"
#import "SRLightControlVC.h"
#import "SRAccelerometerVC.h"
#import "SRMotionSensorVC.h"
#import "SRWaterSensorVC.h"
#import "SRBatteryVC.h"
#import "SRHumidityVC.h"

#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

@interface SRDevKitVC ()

@end

@implementation SRDevKitVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    scrView.contentSize = CGSizeMake(self.view.frame.size.width,800);

    if (IS_IPHONE6)
    {
        viewMain.frame = CGRectMake(30, viewMain.frame.origin.y, 300, viewMain.frame.size.height);
    }
    else if (IS_IPHONE6PLUS)
    {
        viewMain.frame = CGRectMake(50, viewMain.frame.origin.y, 300, viewMain.frame.size.height);
    }
}

#pragma mark - Button Events
#pragma mark -

- (IBAction)onDevkitButtonTapped:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1001:
        {
            SRRelaysVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRRelaysVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1002:
        {
            SRSolenoidVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRSolenoidVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1003:
        {
            SRMotorVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRMotorVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1004:
        {
            SRStatusVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRStatusVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1005:
        {
            SRTempSensorVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRTempSensorVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1006:
        {
            SRLightControlVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRLightControlVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1007:
        {
            SRAccelerometerVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRAccelerometerVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1009:
        {
            SRMotionSensorVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRMotionSensorVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1010:
        {
            SRWaterSensorVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRWaterSensorVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1011:
        {
            SRBatteryVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRBatteryVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        case 1012:
        {
            SRHumidityVC *aObjVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SRHumidityVC"];
            aObjVC.srManagerObj = self.srManagerObj;
            [self.navigationController pushViewController:aObjVC animated:TRUE];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
