//
//  ConfigureListVC.m
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import "ConfigureListVC.h"
#import "AboutDeviceVC.h"
#import "SRDeviceSettngsVC.h"
#import "SRDevKitVC.h"

@implementation UIImageView (Border)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}
@end

@implementation ConfigureListVC

@synthesize srManagerObj;

-(void)viewDidLoad
{
    [super viewDidLoad];

    mutArrConfiguration = [[NSMutableArray alloc]initWithObjects:@"Devkit Operation",@"SR Device Settings",@"About SR Device", nil];
    
    mutArrImages = [[NSMutableArray alloc]initWithObjects:@"remoteOperation_icon_test.png",@"appsetting.png",@"about.png", nil];
}

#pragma mark - TableView Delegate Methods
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mutArrConfiguration.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *aLbl = (UILabel *)[cell viewWithTag:1];
    aLbl.text = mutArrConfiguration[indexPath.row];
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:2];
    imgView.image = [UIImage imageNamed:[mutArrImages objectAtIndex:indexPath.row]];
    
    UIImageView *imgViewBg = (UIImageView *)[cell viewWithTag:3];
    [imgViewBg addTopBorderWithColor:[UIColor colorWithRed:230.0/255.f green:233.0/255.f blue:238.0/255.f alpha:1.0] andWidth:1.0];
    [imgViewBg addBottomBorderWithColor:[UIColor colorWithRed:230.0/255.f green:233.0/255.f blue:238.0/255.f alpha:1.0] andWidth:1.0];
    
    UIButton *btnInfo = (UIButton *)[cell viewWithTag:4];
    [btnInfo setTitle:[NSString stringWithFormat:@"%d",indexPath.row] forState:UIControlStateNormal];
    [btnInfo setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"DevkitOperation" sender:nil];
    }
    else if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"SRDeviceSettings" sender:nil];
    }
    
    else if (indexPath.row == 2)
    {
        [self performSegueWithIdentifier:@"AboutSRDevice" sender:nil];
    }
}

#pragma mark - Segue Method
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AboutSRDevice"])
    {
        AboutDeviceVC *aboutDeviceVC = [segue destinationViewController];
        aboutDeviceVC.mutArrInfo = self.mutArrDeviceInfo;
        aboutDeviceVC.srManagerObj = self.srManagerObj;
    }
    else if ([[segue identifier] isEqualToString:@"DevkitOperation"])
    {
        SRDevKitVC *srDevKitVC = [segue destinationViewController];
        srDevKitVC.srManagerObj = self.srManagerObj;
    }
    else if ([[segue identifier] isEqualToString:@"SRDeviceSettings"])
    {
        SRDeviceSettngsVC *sRDeviceSettngsVC = [segue destinationViewController];
        sRDeviceSettngsVC.srManagerObj = self.srManagerObj;
    }
}

#pragma mark - SRCentralManagerDelegate Method
#pragma mark -

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
