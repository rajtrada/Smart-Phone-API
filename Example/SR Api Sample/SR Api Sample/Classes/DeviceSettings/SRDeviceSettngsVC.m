//
//  SRDeviceSettngsVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRDeviceSettngsVC.h"
#import "TxPowerSettingsVC.h"

@interface SRDeviceSettngsVC ()

@end

@implementation SRDeviceSettngsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.srManagerObj.srDelegate = self;

    [self.srManagerObj getSRDeviceConfiguration];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.srManagerObj.srDelegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate Methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        [self performSegueWithIdentifier:@"TXPowerSegue" sender:nil];
    }
    else if (indexPath.section == 3 || indexPath.section == 4)
    {
        if (indexPath.section == 3)
        {
            [self performSegueWithIdentifier:@"SRDetailSettings" sender:indexPath];
        }
        else if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"SRDetailSettings" sender:indexPath];
        }
    }
}

#pragma mark - Segue Method
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TXPowerSegue"])
    {
        TxPowerSettingsVC *txObjVC = [segue destinationViewController];
        txObjVC.delegate = self;
        txObjVC.aIntPower = [aNumTxPower intValue];
    }
    else if ([segue.identifier isEqualToString:@"SRDetailSettings"])
    {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        SRDeviceSettingsDetailVC *deviceDetailVC = [segue destinationViewController];
        deviceDetailVC.delegate = self;
        if (indexPath.section == 3)
        {
            deviceDetailVC.strCurrentValue = lblAntenna.text;
            deviceDetailVC.arrData = @[@"Chip", @"UFL"];
            deviceDetailVC.intType = 1;
            deviceDetailVC.title = @"Antenna Selection";
        }
        else
        {
            deviceDetailVC.strCurrentValue = lblNWConfiguration.text;
            deviceDetailVC.arrData = @[@"Join All", @"Connect With Co-ordinator", @"Connect With Router"];
            deviceDetailVC.intType = 2;
            deviceDetailVC.title = @"SR Network Configuration";
        }
    }
}

#pragma mark - TxPowerDelegate Method
#pragma mark -

-(void)saveTxPowerValue:(int)aIntTxPower
{
    aNumTxPower = [NSNumber numberWithInt:aIntTxPower];
    
    if([aNumTxPower intValue] == 1)
        lblTXPower.text = @"Proximity";
    else if([aNumTxPower intValue] == 2)
        lblTXPower.text = @"Low";
    else if([aNumTxPower intValue] == 3)
        lblTXPower.text = @"Medium";
    else if([aNumTxPower intValue] == 4)
        lblTXPower.text = @"High";
    else
    {
        lblTXPower.text = @"High";
    }
}

#pragma mark - DeviceDetailDelegate Method
#pragma mark -

-(void)saveDeviceDetailData:(NSString *)aStrData aIntType:(int)aIntType
{
    if (aIntType == 1)
    {
        lblAntenna.text = aStrData;
    }
    else
    {
        lblNWConfiguration.text = aStrData;
    }
}

#pragma mark - Button Events
#pragma mark -

-(IBAction)btnSaveClicked:(UIBarButtonItem *)sender
{

    if ([self.srManagerObj isSRDeviceConnected])
    {
        [SRDejalBezelActivityView activityViewForView:[[self view]window] withLabel:@"Saving Data..."];
        
        int nAntenaType = 0;
        
        if([lblAntenna.text isEqualToString:@"UFL"])
        {
            nAntenaType = 1;
        }
        else
        {
            nAntenaType = 0;
        }
        
        if([lblTXPower.text isEqualToString:@"Proximity"])
        {
            intNWConfiguration = 1;
        }
        else if([lblTXPower.text isEqualToString:@"Low"])
        {
            intNWConfiguration = 2;
        }
        else if([lblTXPower.text isEqualToString:@"Medium"])
        {
            intNWConfiguration = 3;
        }
        else if([lblTXPower.text isEqualToString:@"High"])
        {
            intNWConfiguration = 4;
        }
        else
        {
            lblTXPower.text = @"High";
            intNWConfiguration = 4;
        }

        [self.srManagerObj setSRDeviceConfiguration:switchMotion.on aBoolHumidity:switchHumidity.on aIntTxPower:[aNumTxPower intValue] aIntAntenna:nAntenaType aIntNWConfiguration:intNWConfiguration aIntBoardType:00];
    }
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

-(void)didReadConfiguration:(NSData *)data
{
    @try
    {
        if(data.length > 10)
        {
            intNWConfiguration = [data byteAtIndex:11];
            
            if(intNWConfiguration == 0)
            {
                lblNWConfiguration.text = @"Join All";
            }
            else if(intNWConfiguration == 1)
            {
                lblNWConfiguration.text = @"Connect With Co-ordinator";
            }
            else if(intNWConfiguration == 2)
            {
                lblNWConfiguration.text = @"Connect With Router";
            }
            else
            {
                lblNWConfiguration.text = @"Join All";
            }
        }
        
        switchMotion.on = [[NSNumber numberWithBool:[data byteAtIndex:6]] boolValue];
        switchHumidity.on = [[NSNumber numberWithBool:[data byteAtIndex:4]] boolValue];
        
        NSNumber *aNumAntenna = [NSNumber numberWithBool:[data byteAtIndex:7]];
        
        if([aNumAntenna intValue] == 1)
        {
            lblAntenna.text = @"UFL";
        }
        else
        {
            lblAntenna.text = @"Chip";
        }
        
        aNumTxPower = [NSNumber numberWithInteger:[data byteAtIndex:5]];
        
        if([aNumTxPower intValue] == 1)
            lblTXPower.text = @"Proximity";
        else if([aNumTxPower intValue] == 2)
            lblTXPower.text = @"Low";
        else if([aNumTxPower intValue] == 3)
            lblTXPower.text = @"Medium";
        else if([aNumTxPower intValue] == 4)
            lblTXPower.text = @"High";
        else
        {
            lblTXPower.text = @"High";
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Excepetion:-%@",exception);
    }
    @finally {
        
    }
}

-(void)didWriteConfiguration
{
    [SRDejalBezelActivityView removeView];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Devkit settings are changed successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"success");
}

-(void)didOperationFailWithError:(NSString *)error
{
    [SRDejalBezelActivityView removeView];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"fail");
}

@end
