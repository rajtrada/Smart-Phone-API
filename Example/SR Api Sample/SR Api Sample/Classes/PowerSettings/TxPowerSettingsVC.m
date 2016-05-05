//
//  TxPowerSettingsVC.m
//  SR Api Sample
//
//  Created by SciTER on 12/26/15.
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "TxPowerSettingsVC.h"

@interface TxPowerSettingsVC ()
{
    long longPowerType;
}

@end

@implementation TxPowerSettingsVC

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    longPowerType = _aIntPower;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate Methods
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if((longPowerType-1) == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    longPowerType = indexPath.row+1;
    [self.tableView reloadData];
}

#pragma mark - Button Events
#pragma mark -

-(IBAction)actionSave:(id)sender
{
    NSString *strType = [NSString stringWithFormat:@"%ld",longPowerType];
    [delegate saveTxPowerValue:[strType intValue]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
