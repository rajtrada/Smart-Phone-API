//
//  AboutDeviceVC.m
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import "AboutDeviceVC.h"

NSInteger aIntSWVersion;

@implementation AboutDeviceVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    mutArrDeviceInfo = [[NSMutableArray alloc]init];

    mutArrKeys = [[NSMutableArray alloc]initWithObjects:@"Build ID",@"Model #",@"Firmware Version",@"Stack Version",@"Bootloader Version", nil];
    
    for (int aIntCount = 0 ; aIntCount < mutArrKeys.count; aIntCount++)
    {
        NSMutableDictionary *aMutDict = [[NSMutableDictionary alloc]init];
        [aMutDict setObject:@"N.A" forKey:@"Value"];
        [aMutDict setObject:[mutArrKeys objectAtIndex:aIntCount] forKey:@"Key"];
        [mutArrDeviceInfo addObject:aMutDict];
    }
    
    for (CBCharacteristic *charC in _mutArrInfo)
    {
        if ([charC.UUID.UUIDString isEqualToString:@"2A24"])
        {
            NSMutableDictionary *aMutDict = [mutArrDeviceInfo objectAtIndex:1];
            [aMutDict setObject:[[NSString alloc]initWithData:charC.value encoding:NSUTF8StringEncoding] forKey:@"Value"];
        }
        else if ([charC.UUID.UUIDString isEqualToString:@"2A28"])
        {
            NSMutableDictionary *aMutDict = [mutArrDeviceInfo objectAtIndex:2];
            
            NSString *aStrSWVersion = [[NSString alloc]initWithData:[charC.value subdataWithRange:NSMakeRange(0, 8)] encoding:NSUTF8StringEncoding];
            NSString *aStrBlVersion = [[NSString alloc]initWithData:[charC.value subdataWithRange:NSMakeRange(8, 8)] encoding:NSUTF8StringEncoding];

            if ([aStrBlVersion intValue] == 0) {
                aStrBlVersion = @"N.A";
            }
            [aMutDict setObject:aStrSWVersion forKey:@"Value"];
            
            aMutDict = [mutArrDeviceInfo objectAtIndex:4];
            [aMutDict setObject:aStrBlVersion forKey:@"Value"];

            if(charC.value.length >= 18)
            {
                NSData *aDataSoftVersion = [charC.value subdataWithRange:(NSRange){16,2}];
                NSString *aStrSoftVersion = [NSString stringWithFormat:@"%@", aDataSoftVersion];
                aStrSoftVersion = [aStrSoftVersion stringByReplacingOccurrencesOfString:@"<" withString:@""];
                aStrSoftVersion = [aStrSoftVersion stringByReplacingOccurrencesOfString:@">" withString:@""];
                
                if([aStrSoftVersion isEqualToString:@"0000"] ||
                   [aStrSoftVersion isEqualToString:@"FFFF"])
                {
                    aStrSoftVersion = @"N.A";
                }
                
                aMutDict = [mutArrDeviceInfo objectAtIndex:3];
                
                [aMutDict setObject:[NSString stringWithFormat:@"0x%@",aStrSoftVersion] forKey:@"Value"];
            }

            if(aStrSWVersion.length < 1 ||
               [aStrSWVersion isEqualToString:@"(null)"])
            {
                aStrSWVersion = @"0";
            }
            
            aStrSWVersion = [aStrSWVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            aIntSWVersion = [aStrSWVersion integerValue];
        }
    }
    
    [self.srManagerObj getSRDeviceConfiguration];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.srManagerObj.srDelegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.srManagerObj.srDelegate = nil;
}

#pragma mark - TableView Delegate Methods
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"SR Device Information";
    }
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [mutArrDeviceInfo count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSMutableDictionary *aMutDict = [mutArrDeviceInfo objectAtIndex:indexPath.row];
        
        UILabel *aLblName = (UILabel *) [cell viewWithTag:1];
        aLblName.text = [aMutDict objectForKey:@"Key"];
        
        UILabel *aLblValue = (UILabel *)[cell viewWithTag:2];
        
        aLblValue.text = [aMutDict objectForKey:@"Value"];
        
        return cell;
    }
    else
    {
        UITableViewCell *cellFirmware = [tableView dequeueReusableCellWithIdentifier:@"FirmwareCell" forIndexPath:indexPath];
        return cellFirmware;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [self.srManagerObj stopScan];
        boolIsDFU = YES;
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:242.f/255.f alpha:1.0];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

-(void)didReadConfiguration:(NSData *)data
{
    if(aIntSWVersion > 5000)
    {
        NSData *aDataBuilVersion    = [data subdataWithRange:(NSRange){9,2}];
        NSString *aStrBuilVersion   = [NSString stringWithFormat:@"%@", aDataBuilVersion];
        aStrBuilVersion             = [aStrBuilVersion stringByReplacingOccurrencesOfString:@"<" withString:@""];
        aStrBuilVersion             = [aStrBuilVersion stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        if([aStrBuilVersion isEqualToString:@"0000"] ||
           [aStrBuilVersion isEqualToString:@"FFFF"] || [aStrBuilVersion isEqualToString:@""])
        {
            aStrBuilVersion = @"N.A";
        }
        
        NSMutableDictionary *aMutDict = [mutArrDeviceInfo objectAtIndex:0];
        [aMutDict setObject:[NSString stringWithFormat:@"0x%@",aStrBuilVersion] forKey:@"Value"];
        [tblInfo reloadData];
    }
}

-(void)didOperationFailWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"fail");
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
