//
//  SRRelaysVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRRelaysVC.h"

@interface SRRelaysVC ()

@end

@implementation SRRelaysVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _intBtnUpdate = 1;
    
    self.navigationController.navigationBarHidden = NO;
  
    self.btnPushButton.selected = FALSE;
    
    boolPushButtonPressed       = FALSE;
    
    self.lblDeviceStatusMessage.text = @"Connected";
    
    _btnPressButton.frame = CGRectMake((self.view.frame.size.width-(_btnPressButton.frame.size.width*2)-7)/2, _btnPressButton.frame.origin.y, _btnPressButton.frame.size.width, _btnPressButton.frame.size.height);
    _btnPushButton.frame = CGRectMake(_btnPressButton.frame.origin.x+_btnPressButton.frame.size.width+7, _btnPushButton.frame.origin.y, _btnPushButton.frame.size.width, _btnPushButton.frame.size.height);
    
    _lblMomentry.frame = CGRectMake((self.view.frame.size.width-(_lblMomentry.frame.size.width)-(_lblMaintain.frame.size.width)-49)/2, _lblMomentry.frame.origin.y, _lblMomentry.frame.size.width, _lblMomentry.frame.size.height);
    _lblMaintain.frame = CGRectMake(_lblMomentry.frame.origin.x+_lblMomentry.frame.size.width+35, _lblMaintain.frame.origin.y, _lblMaintain.frame.size.width, _lblMaintain.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.srManagerObj.srDelegate = self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.srManagerObj.srDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Events
#pragma mark -

- (IBAction)actionPress:(id)sender
{
    _intBtnUpdate = 0;
    
    [self.srManagerObj operateRelay:YES];
}

- (IBAction)actionPush:(id)sender
{
    boolPushButtonPressed       = TRUE;
    _intBtnUpdate = 1;
    
    UIButton *btn = (UIButton *)sender;
    if(btn.isSelected)
    {
        btn.selected = FALSE;
        self.btnPushButton.selected = FALSE;
    }
    else
    {
        btn.selected = TRUE;
        self.btnPushButton.selected = TRUE;
    }
    
    [self.srManagerObj operateRelay:NO];
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)didOperationFailWithError:(NSString *)error
{
    if(boolPushButtonPressed)
    {
        boolPushButtonPressed = FALSE;
        if(_btnPushButton.selected)
        {
            _btnPushButton.selected = FALSE;
        }
        else
        {
            _btnPushButton.selected = TRUE;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.lblDeviceStatusMessage.text = @"Disconnected - Tap to Search Again";
    self.imgViewBattery.hidden = TRUE;
    self.btnPushButton.selected = FALSE;
}

- (void)didRelayOperated:(NSData *)data
{
    if (_intBtnUpdate == 1)
    {
        _intBtnUpdate = 0;
        
        int isRelayPressed = [data byteAtIndex:1];
        
        if(isRelayPressed == 0)
        {
            self.btnPushButton.selected = FALSE;
        }
        else
        {
            self.btnPushButton.selected = TRUE;
        }
    }
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
