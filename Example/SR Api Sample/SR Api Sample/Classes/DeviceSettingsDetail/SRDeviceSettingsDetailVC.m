//
//  SRDeviceSettingsDetailVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRDeviceSettingsDetailVC.h"

@interface SRDeviceSettingsDetailVC ()

@end

@implementation SRDeviceSettingsDetailVC

@synthesize strCurrentValue,intType,delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [delegate saveDeviceDetailData:self.strCurrentValue aIntType:self.intType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate Methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell   = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *aStrVal       = [self.arrData objectAtIndex:indexPath.row];
    cell.textLabel.text     = aStrVal;
    
    if([aStrVal isEqualToString:self.strCurrentValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.strCurrentValue = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

@end
