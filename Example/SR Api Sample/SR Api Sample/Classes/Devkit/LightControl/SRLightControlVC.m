//
//  SRLightControlVC.m
//  SR Api Sample
//
//  Copyright © 2015 SciTER. All rights reserved.
//

#import "SRLightControlVC.h"

@interface SRLightControlVC ()

@end

@implementation SRLightControlVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_btnON setBackgroundImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
    [_btnOFF setBackgroundImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
    [_btnOFF setTitleColor: [UIColor colorWithRed:47.0f/255.0f green:180.0f/255.0f blue:227.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_btnON setTitleColor:[UIColor colorWithRed:47.0f/255.0f green:180.0f/255.0f blue:227.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    
    self.navigationController.navigationBarHidden = NO;
    
    boolEventGenerated = FALSE;
    
    intOldIntensity = self.sliderIntensity.value;
    
    self.lblDeviceStatusMessage.text = @"Connected";
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
    }
    [self.srManagerObj setSrDelegate:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.srManagerObj.srDelegate = self;
    
    [self.srManagerObj operateLight:YES];
}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

- (void)didOperationFailWithError:(NSString *)error
{
    if(boolEventGenerated)
    {
        boolEventGenerated = FALSE;
        [self.sliderIntensity setValue:intOldIntensity];
        self.lblIntensity.text = [NSString stringWithFormat:@"%d %%",(int)intOldIntensity];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Operation failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didLightOperated:(NSData *)data
{
    int onOffValue = [data byteAtIndex:1];
    int intensityValue = [data byteAtIndex:2];
    if(intensityValue>100)
        return;
    
    intOldIntensity = intensityValue;
    self.lblIntensity.text = [NSString stringWithFormat:@"%d %%",intensityValue];
    [self.sliderIntensity setValue:intensityValue animated:YES];
    [self performSelector:@selector(setLightStatusBackground:) withObject:[NSNumber numberWithInt:onOffValue] afterDelay:0.0f];
}

- (void)didChangedLightIntensity:(NSData *)data
{
    int onOffValue = [data byteAtIndex:1];
    int intensityValue = [data byteAtIndex:2];
    if(intensityValue>100)
        return;
    
    intOldIntensity = intensityValue;
    self.lblIntensity.text = [NSString stringWithFormat:@"%d %%",intensityValue];
    [self.sliderIntensity setValue:intensityValue animated:YES];
    [self performSelector:@selector(setLightStatusBackground:) withObject:[NSNumber numberWithInt:onOffValue] afterDelay:0.0f];
}

#pragma mark - Button Events Methods
#pragma mark -

-(IBAction)actionOperateLight:(id)sender
{
    boolEventGenerated = TRUE;
    UIButton *button = (UIButton *)sender;
    if(button.tag == 1003)
    {
        [self setLightStatusBackground:[NSNumber numberWithInteger:1]];
        [self.srManagerObj operateLight:YES];
    }
    else if(button.tag == 1004)
    {
        [self setLightStatusBackground:[NSNumber numberWithInteger:0]];
        [self.srManagerObj operateLight:NO];
    }
}

- (IBAction)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.lblIntensity.text = [NSString stringWithFormat:@"%d %%",(int)slider.value ];
    [self resetTimer];
}

#pragma mark - Custom Methods
#pragma mark -

-(void)sliderValueChangedDone
{
    boolEventGenerated = TRUE;
    [self.srManagerObj setLightIntensity:self.sliderIntensity.value];
}

- (void)resetTimer
{
    if(self.timer)
    {
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(sliderValueChangedDone) userInfo:nil repeats:NO];
}

-(void)setLightStatusBackground:(NSNumber *)value;
{
    if (value.intValue == 1 || value.intValue == 5)
    {
        [_btnON setBackgroundImage:[UIImage imageNamed:@"CircleFilled.png"] forState:UIControlStateNormal];
        [_btnOFF setBackgroundImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
        [_btnOFF setTitleColor: [UIColor colorWithRed:47.0f/255.0f green:180.0f/255.0f blue:227.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_btnON setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if(value.intValue == 0 || value.intValue == 6)
    {
        [_btnON setBackgroundImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
        [_btnOFF setBackgroundImage:[UIImage imageNamed:@"CircleFilled.png"] forState:UIControlStateNormal];
        [_btnON setTitleColor:[UIColor colorWithRed:47.0f/255.0f green:180.0f/255.0f blue:227.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_btnOFF setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        [_btnON setBackgroundImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
        [_btnOFF setBackgroundImage:[UIImage imageNamed:@"Circle.png"] forState:UIControlStateNormal];
        [_btnOFF setTitleColor: [UIColor colorWithRed:47.0f/255.0f green:180.0f/255.0f blue:227.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_btnON setTitleColor:[UIColor colorWithRed:47.0f/255.0f green:180.0f/255.0f blue:227.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    }
}
- (BOOL)color:(UIColor *)color1 isEqualToColor:(UIColor *)color2 withTolerance:(CGFloat)tolerance
{
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return
    fabs(r1 - r2) <= tolerance &&
    fabs(g1 - g2) <= tolerance &&
    fabs(b1 - b2) <= tolerance &&
    fabs(a1 - a2) <= tolerance;
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
