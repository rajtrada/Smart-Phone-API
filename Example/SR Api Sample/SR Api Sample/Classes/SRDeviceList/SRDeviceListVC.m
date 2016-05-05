//
//  SRDeviceListVC.m
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import "SRDeviceListVC.h"
#import <CommonCrypto/CommonCrypto.h>
#import "SRServiceVC.h"

@interface SRDeviceListVC ()

@end

@implementation SRDeviceListVC

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        
    [searchBarDevice setSearchTextPositionAdjustment:UIOffsetMake(17.0, 0.0)];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    muDictServicesAndCharacteristic = [[NSMutableDictionary  alloc]init];
    
    mutArrFiltered = [[NSMutableArray alloc] init];
        
    selectedIndexes= [[NSMutableArray alloc]init];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    aButton.frame = CGRectMake(0.0, 0.0, 60, 30);
    
    [aButton setTitle:@"Scan" forState:UIControlStateNormal];
    
    [aButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    
    [aButton setBackgroundColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
    
    [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    aButton.layer.cornerRadius = 5.0;
    aButton.layer.borderWidth = 1.0;
    aButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    aButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    [aButton addTarget:self action:@selector(scanDevices)forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = aBarButtonItem;

    srManagerObj = [[SRCentralManager alloc]initWithDelegate:self queue:nil];
    
    
    NSString *strSrNo           = @"DEVKIT-332689223";
    NSString *strSecureToken    = @"N4BWTRG6FZ";
    NSString *strKey1           = @"37EA565EEDAA73CBEDFEAC56936D5C42";
    NSString *strKey2           = @"EA3D6BFD5D3EA6C44353DCD9CB6E8C5A";
    NSString *strKey3           = @"DB7B72AA6C3FC52349BFA92A5297EB6B";
    
    
    [srManagerObj setSecurityParams:strSrNo secureToken:strSecureToken key1:strKey1 key2:strKey2 key3:strKey3];
    
    mutArrPeripherals = [[NSMutableArray alloc]init];
        
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:@"Scanning..."];
    
    refreshControl = [[UIRefreshControl alloc]init];
    refreshControl.attributedTitle = attString;
    [refreshControl addTarget:self action:@selector(scanDevices) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scanDevices];
    });
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    boolIsConnecting = NO;
    
    srManagerObj.srDelegate = self;
    [srManagerObj disconnectSRDevice];
        
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reloadTableData) userInfo:nil repeats:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)reloadTableData
{
    if (![refreshControl isRefreshing])
    {
        [self.tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    srManagerObj.srDelegate = nil;
    
    [btnUpgradeAll removeFromSuperview];
}

-(void)scanDevices
{
    [mutArrFiltered removeAllObjects];
    searchBarDevice.text = @"";
    isSearching = NO;
    [selectedIndexes removeAllObjects];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (!srManagerObj.boolIsBluetoothOn)
    {
        [mutArrPeripherals removeAllObjects];
        [self.tableView reloadData];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Turn on bluetooth from settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [refreshControl endRefreshing];
        return;
    }
    
    [SRDejalBezelActivityView activityViewForView:[[UIApplication sharedApplication]keyWindow] withLabel:@"Loading..."];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scanTimeOut) userInfo:nil repeats:NO];
    
    if (mutArrPeripherals != nil) {
        [mutArrPeripherals removeAllObjects];
        [self.tableView reloadData];
    }
 
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [srManagerObj scanForPeripheralsWithServices:[NSArray arrayWithObjects:[CBUUID UUIDWithString:SR_CUSTOM_SERVICE_UUID], nil] options:options];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scanTimeOut
{
    [SRDejalBezelActivityView removeViewAnimated:NO];
    [actIndView stopAnimating];
    self.view.userInteractionEnabled= YES;
    [refreshControl endRefreshing];
    [timer invalidate];
    timer = nil;
}

- (void)searchTableList {
    NSString *searchString = searchBarDevice.text;
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.Name contains[c] %@",searchString];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.Serialno contains[c] %@",searchString];
    
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate2]];
    
    mutArrFiltered = [NSMutableArray arrayWithArray:[mutArrPeripherals filteredArrayUsingPredicate:predicate]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@""]) {
        isSearching = NO;
    }
    else
        isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Text change - %d",isSearching);
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        isSearching = NO;
        [searchBar resignFirstResponder];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearching = NO;
    [searchBar resignFirstResponder];
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    [self searchTableList];
}

#pragma mark - Segue Method
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SRServiceVC"])
    {
        SRServiceVC *serviceVC = [segue destinationViewController];
        serviceVC.srManagerObj = srManagerObj;
        serviceVC.mutDictData = muDictServicesAndCharacteristic;
    }
}

#pragma mark - TableView Delegate Methods
#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"SR Modules Near By";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithRed:240.f/255.f green:240.f/255.f blue:242.f/255.f alpha:1.0];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF.Name contains[c] %@",@"devkit"];
//    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.Serialno contains[c] %@",@"devkit"];
//    
//    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1,predicate2]];
//    
//    mutArrFiltered = [NSMutableArray arrayWithArray:[mutArrPeripherals filteredArrayUsingPredicate:predicate]];
//    isSearching = YES;
    
    if (isSearching)
    {
        return mutArrFiltered.count;
    }
    return mutArrPeripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *dict ;
    if (isSearching) {
        dict = mutArrFiltered[indexPath.row];
    }
    else
        dict = mutArrPeripherals[indexPath.row];
    
    
    UILabel *aLblRSSI = (UILabel *)[cell viewWithTag:1];
    aLblRSSI.text = [NSString stringWithFormat:@"%2d(db)",[[dict objectForKey:@"rssi"] intValue]];
    
    UILabel *aLblName = (UILabel *)[cell viewWithTag:2];
    aLblName.text = [dict objectForKey:@"Name"];
    
    UILabel *aLblSerialNo = (UILabel *)[cell viewWithTag:3];
    aLblSerialNo.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Serialno"]];
    
    UILabel *aLblSecLevel = (UILabel *)[cell viewWithTag:4];
    aLblSecLevel.text = [NSString stringWithFormat:@"SL:%@",[dict objectForKey:@"SecurityLevel"]];
    
    UILabel *aLblAntNetType = (UILabel *)[cell viewWithTag:5];
    
    if ([[dict objectForKey:@"ANTNetworkStatus"] intValue] == 0) {
        aLblAntNetType.text = @"ANT OFF";
    }
    else if ([[dict objectForKey:@"ANTNetworkStatus"] intValue] == 1) {
        aLblAntNetType.text = @"Scanning For Coordinator";
    }
    else if ([[dict objectForKey:@"ANTNetworkStatus"] intValue] == 2) {
        aLblAntNetType.text = @"Connected to Coordinator";
    }
    else if ([[dict objectForKey:@"ANTNetworkStatus"] intValue] == 3) {
        aLblAntNetType.text = @"Scannig For Router";
    }
    else if ([[dict objectForKey:@"ANTNetworkStatus"] intValue] == 4) {
        aLblAntNetType.text = @"Connected to Router";
    }
    else if ([[dict objectForKey:@"ANTNetworkStatus"] intValue] == 5) {
        aLblAntNetType.text = @"Coordinator";
    }
    
    UILabel *aLblNodeType = (UILabel *)[cell viewWithTag:6];
    
    if ([[dict objectForKey:@"NodeType"] intValue] == 0) {
        aLblNodeType.text = @"Undefined";
    }
    else if ([[dict objectForKey:@"NodeType"] intValue] == 1) {
        aLblNodeType.text = @"Router";
    }
    else if ([[dict objectForKey:@"NodeType"] intValue] == 2) {
        aLblNodeType.text = @"End Device";
    }
    else if ([[dict objectForKey:@"NodeType"] intValue] == 3) {
        aLblNodeType.text = @"Coordinator";
    }
    
    if ([selectedIndexes containsObject:[NSNumber numberWithInt:indexPath.row]])
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBarDevice resignFirstResponder];
    
    boolIsConnecting = YES;
    [actIndView setHidden:NO];
    [actIndView startAnimating];
    
    
    if (isSearching) {
        pheripheral = [[mutArrFiltered objectAtIndex:indexPath.row] objectForKey:@"peripheral"];

        [SRDejalBezelActivityView activityViewForView:[[UIApplication sharedApplication]keyWindow] withLabel:[NSString stringWithFormat:@"Connecting with %@",[[mutArrFiltered objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
    }
    else
    {
        pheripheral = [[mutArrPeripherals objectAtIndex:indexPath.row] objectForKey:@"peripheral"];
        
        
        [SRDejalBezelActivityView activityViewForView:[[UIApplication sharedApplication]keyWindow] withLabel:[NSString stringWithFormat:@"Connecting with %@",[[mutArrPeripherals objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
    }
    [srManagerObj connectPeripheral:pheripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Center Update State");
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown state code %ld",(long)CBCentralManagerStateUnknown);
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting state code %ld",(long)CBCentralManagerStateResetting);
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported state code %ld",(long)CBCentralManagerStateUnsupported);
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized state code %ld",(long)CBCentralManagerStateUnauthorized);
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CBCentralManagerStatePoweredOff state code %ld",(long)CBCentralManagerStatePoweredOff);
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"CBCentralManagerStatePoweredOn state code %ld",(long)CBCentralManagerStatePoweredOn);
            if (mutArrPeripherals.count == 0) {
                [self scanDevices];
            }
        }
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI mutDict:(NSMutableDictionary *)mutDictData
{
    if (!mutDictData)
    {
        return;
    }
    
    if([mutDictData objectForKey:@"Serialno"] != nil)
    {
        if(![[mutDictData valueForKey:@"Serialno"] isEqualToString:@"DEVKIT-332689223"])
        {
            return;
        }
    }
    if(isSearching || boolIsConnecting )return;
    
    [SRDejalBezelActivityView removeViewAnimated:NO];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(peripheral ==  %@)", peripheral];
    NSArray *filteredArray = [mutArrPeripherals filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0)
    {
        NSInteger index = [mutArrPeripherals indexOfObject:[filteredArray objectAtIndex:0]];
      
        [mutArrPeripherals replaceObjectAtIndex:index withObject:mutDictData];
    }
    else
    {
        [mutArrPeripherals addObject:mutDictData];
    }
    if (refreshControl.isRefreshing) {
        [refreshControl endRefreshing];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connected peripheral :- %@",peripheral);
    [srManagerObj createSession];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"services:-%@",peripheral.services);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (![service.UUID.UUIDString isEqualToString:SR_CUSTOM_SERVICE_UUID]) {
        [muDictServicesAndCharacteristic setObject:service.characteristics forKey:[NSString stringWithFormat:@"%@",service.UUID]];
    }
    NSLog(@"Characterstic:-%@",service.characteristics);
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [SRDejalBezelActivityView removeView];
    self.view.userInteractionEnabled = YES;
    
    boolIsConnecting = NO;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"SRDevice is disconncected by %@.",peripheral.name] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    NSLog(@"Peripehrtal Fail %@ with error :- %@",peripheral,error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error value:(NSData *)aDataValue
{
    NSLog(@"Value:-%@ uuid:-%@",characteristic.value,characteristic.UUID.UUIDString);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"write value success : error:%@ Peripheral:-%@ Charctersitc:-%@",error,peripheral,characteristic);
}

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(peripheral ==  %@)", peripheral];
    
    NSArray *filteredArray = [mutArrPeripherals filteredArrayUsingPredicate:predicate];
    NSMutableDictionary *aMutDict = [filteredArray objectAtIndex:0];
    [aMutDict setObject:RSSI forKey:@"rssi"];
    NSInteger index = [mutArrPeripherals indexOfObject:aMutDict];
    [mutArrPeripherals replaceObjectAtIndex:index withObject:aMutDict];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"RSSI:-%@",RSSI);
}

-(void)didSessionCreated
{
    //[srManagerObj connectPeripheral:pheripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES}];
    //[srManagerObj discoverServices:pheripheral.services];
    
    boolIsConnecting = NO;
    [SRDejalBezelActivityView removeView];
    self.view.userInteractionEnabled = YES;
    [self performSegueWithIdentifier:@"SRServiceVC" sender:nil];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [SRDejalBezelActivityView removeView];
    
    boolIsConnecting = NO;
    
    self.view.userInteractionEnabled = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"SRDevice is disconncected by %@.",peripheral.name]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didConnectionTimeout
{
    [SRDejalBezelActivityView removeView];
    
    boolIsConnecting = NO;
    
    self.view.userInteractionEnabled = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"SRDevice is not in range."  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

-(void)didSessionCreationFailed:(NSString *)aStrError
{
    [SRDejalBezelActivityView removeView];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:aStrError delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

@end
