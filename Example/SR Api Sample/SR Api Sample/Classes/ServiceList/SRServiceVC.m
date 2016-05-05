//
//  SRServiceVC.m
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import "SRServiceVC.h"
#import "SRCharacteristicDetailVC.h"
#import <QuartzCore/QuartzCore.h>
#import <SecuRemoteSDK/SecuRemoteSDK.h>
#import "AboutDeviceVC.h"
#import "ConfigureListVC.h"

@implementation SRServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mutDictTableData = [[NSMutableDictionary alloc]initWithDictionary:self.mutDictData];
    
    aButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    
    aButtonLeft.frame = CGRectMake(self.view.frame.size.width - 50, 7,50, 31);
    
    aButtonLeft.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    [aButtonLeft setImage:[UIImage imageNamed:@"Menu_Icon.gif"] forState:UIControlStateNormal];
    
    [aButtonLeft setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [aButtonLeft.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    [aButtonLeft addTarget:self action:@selector(btnConfigureClick) forControlEvents:UIControlEventTouchUpInside];
    
    [aButtonLeft setShowsTouchWhenHighlighted:YES];

    
    btnUpgrade.layer.cornerRadius = 5.0;
    btnUpgrade.layer.borderWidth = 1.0;
    btnUpgrade.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [btnUpgrade setBackgroundColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
    
    [btnUpgrade setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    for (NSString *aStrKey in [mutDictTableData allKeys]) {
        NSArray *aArrChar = [mutDictTableData objectForKey:aStrKey];
        for (CBCharacteristic *charC in aArrChar) {
            if ([[[self.srManagerObj getCharacteristicProperty:charC] objectForKey:@"isRead"] isEqualToString:@"1"])
            {
                [self.srManagerObj readValueForCharacteristic:charC];
            }
        }
    }
    
    NSDictionary *aDict = [self.srManagerObj getSRDeviceInfo];
    lblDeviceName.text = aDict[@"Name"];
//    lblUUID.text = [NSString stringWithFormat:@"UUID : %@",self.srManagerObj.connectedPeripheral.identifier.UUIDString];
    
    if ([self.srManagerObj isSRDeviceConnected]) {
        [lblConnected setTextColor:[UIColor colorWithRed:11.f/255.f green:97.f/255.f blue:11.f/255.f alpha:1.0]];
        lblConnected.text = @"Connected";
    }
    else
    {
        [lblConnected setTextColor:[UIColor colorWithRed:235.f/255.f green:51.f/255.f blue:52.f/255.f alpha:1.0]];
        lblConnected.text = @"Disconnected";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *aDict = [self.srManagerObj getSRDeviceInfo];
    lblSecLevel.text = [NSString stringWithFormat:@"Security Level : %@",[aDict objectForKey:@"SecurityLevel"]];
    self.srManagerObj.srDelegate = self;
    [self.navigationController.navigationBar addSubview:aButtonLeft];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.srManagerObj.srDelegate = nil;
    [aButtonLeft removeFromSuperview];
}

#pragma mark - Button Events
#pragma mark -

-(void)btnConfigureClick
{
    [self performSegueWithIdentifier:@"ConfigureVC" sender:nil];
}

#pragma mark - Table View
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[mutDictTableData allKeys]objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[mutDictTableData allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    NSString *key =[[mutDictTableData allKeys]objectAtIndex:section];

    return [[mutDictTableData objectForKey:key] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *aLblName = (UILabel *) [cell viewWithTag:1];
    
    NSString *key =[[mutDictTableData allKeys]objectAtIndex:indexPath.section];
    
    NSMutableArray *aMutArr = [mutDictTableData objectForKey:key];
    
    CBCharacteristic *characteristic = [aMutArr objectAtIndex:indexPath.row];
    
    aLblName.text = [NSString stringWithFormat:@"%@",characteristic.UUID];
    
    UILabel *aLblValue = (UILabel *)[cell viewWithTag:2];

    NSDictionary *aDictProp = [self.srManagerObj getCharacteristicProperty:characteristic];

    NSString *aStrProp = @"";
    
    if ([[aDictProp objectForKey:@"isRead"] isEqualToString:@"1"]) {
        aStrProp =  [NSString stringWithFormat:@"Read"];
    }
    if ([[aDictProp objectForKey:@"isWrite"] isEqualToString:@"1"]) {
        aStrProp = [NSString stringWithFormat:@"%@ Write",aStrProp];
    }
    if ([[aDictProp objectForKey:@"isNotify"] isEqualToString:@"1"]) {
        aStrProp = [NSString stringWithFormat:@"%@ Notify",aStrProp];
    }
    
    NSLog(@"Str Value :- %@ %lu",characteristic.value.string,(unsigned long)[characteristic.value.string length]);
    
    if ([characteristic.value.string length] > 0)
    {
        if ([characteristic.UUID.UUIDString isEqualToString:@"2A19"])
        {
            aLblValue.text = [NSString stringWithFormat:@"%d%% , Properties : %@",(int)[characteristic.value byteAtIndex:0],aStrProp];
        }
        else
        {
            NSString *aStrText = [NSString stringWithFormat:@"%@ , Properties : %@",[characteristic.value string],aStrProp];
            
            aLblValue.text = aStrText;
        }
    }
    else
        aLblValue.text = [NSString stringWithFormat:@"Properties : %@",aStrProp];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CharacteristicDetailVC" sender:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:242.f/255.f alpha:1.0];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
}


#pragma mark - Segue Method
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"ConfigureVC"]) {
        ConfigureListVC *configuVC = [segue destinationViewController];
        configuVC.mutArrDeviceInfo = [mutDictTableData objectForKey:@"Device Information"];
        configuVC.srManagerObj = self.srManagerObj;
    }
    else if ([[segue identifier]isEqualToString:@"CharacteristicDetailVC"]) {
        SRCharacteristicDetailVC *charDetailVC = [segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSString *key =[[mutDictTableData allKeys]objectAtIndex:indexPath.section];
        NSMutableArray *aMutArr = [mutDictTableData objectForKey:key];
        CBCharacteristic *characteristic = [aMutArr objectAtIndex:indexPath.row];
        charDetailVC.selectedCharacteristic = characteristic;
        charDetailVC.srManagerObj = self.srManagerObj;
    }
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error value:(NSData *)aDataValue
{
    if (characteristic.value.length > 1) {
        [tblServices reloadData];
    }
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
