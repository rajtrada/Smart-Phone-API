//
//  SRCharacteristicDetailVC.m
//  SR Api Sample
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import "SRCharacteristicDetailVC.h"

@implementation SRCharacteristicDetailVC

@synthesize srManagerObj;
@synthesize selectedCharacteristic;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title =[NSString stringWithFormat:@"%@",self.selectedCharacteristic.UUID];
    
    btnNotify.layer.cornerRadius = 5.0;
    btnNotify.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnNotify.layer.borderWidth = 1.0;
    
    [btnNotify setBackgroundColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
    
    [btnNotify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.selectedCharacteristic.isNotifying)
    {
        [btnNotify setTitle:@"Notify Off" forState:UIControlStateNormal];
    }
    else
        [btnNotify setTitle:@"Notify On" forState:UIControlStateNormal];

    btnRead.layer.cornerRadius = 5.0;
    btnRead.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnRead.layer.borderWidth = 1.0;

    [btnRead setBackgroundColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
    
    [btnRead setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    btnWrite.layer.cornerRadius = 5.0;
    btnWrite.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnWrite.layer.borderWidth = 1.0;
    
    [btnWrite setBackgroundColor:[UIColor colorWithRed:92.f/255.f green:107.f/255.f blue:192.f/255.f alpha:1.0]];
    
    [btnWrite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    mutDictCharProp = [self.srManagerObj getCharacteristicProperty:self.selectedCharacteristic];
    
    txtFieldValue.layer.cornerRadius = 5.0;
    txtFieldValue.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtFieldValue.layer.borderWidth = 1.0;
    txtFieldValue.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    if ([[mutDictCharProp objectForKey:@"isNotify"] isEqualToString:@"1"]) {
        txtFieldValue.userInteractionEnabled = NO;
        btnNotify.enabled = YES;
    }
    else
    {
        btnNotify.alpha = 0.8;
        btnNotify.enabled = NO;
        txtFieldValue.userInteractionEnabled = NO;
    }
    
    if ([[mutDictCharProp objectForKey:@"isRead"] isEqualToString:@"1"]) {
        txtFieldValue.userInteractionEnabled = NO;
        btnRead.enabled = YES;
    }
    else
    {
        btnRead.alpha = 0.8;
        btnRead.enabled = NO;
        txtFieldValue.userInteractionEnabled = NO;
    }
    
    if ([[mutDictCharProp objectForKey:@"isWrite"] isEqualToString:@"1"]) {
        txtFieldValue.userInteractionEnabled = YES;
        btnWrite.enabled = YES;
    }
    else
    {
        btnWrite.alpha = 0.8;
        btnWrite.enabled = NO;
        txtFieldValue.userInteractionEnabled = NO;
    }
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

#pragma mark - Textfield Delegate Methods
#pragma mark -

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtFieldValue) {
        if (segmentControl.selectedSegmentIndex == 1) {
            NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"]invertedSet];
            NSRange rangeHex = [string rangeOfCharacterFromSet:characterSet];
            if (rangeHex.location == NSNotFound) {
                return YES;
            }
            else
                return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Button Events
#pragma mark -

-(IBAction)btnReadClick:(id)sender
{
    [self.srManagerObj readValueForCharacteristic:self.selectedCharacteristic];
}
- (IBAction)btnSegmentClick:(UISegmentedControl *)sender{

    if (sender.selectedSegmentIndex == 0) {

        strHex = txtFieldValue.text;

        if (strASCII.length > 0) {
            txtFieldValue.text = strASCII;
        }
        else
            txtFieldValue.text = [self convertDataToAscii:aDataValueChar];
    }
    else
    {
        strASCII = txtFieldValue.text;
        txtFieldValue.text = strHex;
    }
}

-(IBAction)btnWriteClick:(id)sender
{
    if (txtFieldValue.text.length !=0)
    {
        if (segmentControl.selectedSegmentIndex == 0)
        {
            NSData *data =[txtFieldValue.text dataUsingEncoding:NSASCIIStringEncoding];
            [self.srManagerObj writeValueforCharacteristic:data forCharacteristic:self.selectedCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        else
        {
            NSString *aStrValue = txtFieldValue.text;
            NSData *data =[aStrValue dataUsingStringAsHex];
            [self.srManagerObj writeValueforCharacteristic:data forCharacteristic:self.selectedCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

-(IBAction)btnNotifyClick:(id)sender
{
    if ([self.selectedCharacteristic isNotifying]) {
        [self.srManagerObj setNotifyValue:NO forCharacteristic:self.selectedCharacteristic];
    }
    else
        [self.srManagerObj setNotifyValue:YES forCharacteristic:self.selectedCharacteristic];

}

#pragma mark - SRCentralManagerDelegate Methods
#pragma mark -

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error value:(NSData *)aDataValue
{
    aDataValueChar = aDataValue;
    
    if ([[mutDictCharProp objectForKey:@"isNotify"] isEqualToString:@"1"])
    {
        if ([characteristic.UUID.UUIDString isEqualToString:self.selectedCharacteristic.UUID.UUIDString])
        {
            if([characteristic.UUID.UUIDString isEqualToString:@"2A19"])
            {
               strASCII = [NSString stringWithFormat:@"%d",(int)[aDataValue byteAtIndex:0]];
            }
            else
            {
                strASCII = [self convertDataToAscii:aDataValue];
            }
            
            strHex = [aDataValue hexadecimalString];
            
            strHex = [self removeTrailingZeros:strHex];
            
            if (segmentControl.selectedSegmentIndex == 0)
            {
                if([characteristic.UUID.UUIDString isEqualToString:@"2A19"])
                {
                    txtFieldValue.text = [NSString stringWithFormat:@"%d",(int)[aDataValue byteAtIndex:0]];
                }
                else
                {
                    txtFieldValue.text = [self convertDataToAscii:aDataValue];
                }
            }
            else
                txtFieldValue.text = [aDataValue hexadecimalString];
        }
    }
    else
    {
        if([characteristic.UUID.UUIDString isEqualToString:@"2A19"])
        {
            strASCII = [NSString stringWithFormat:@"%d",(int)[aDataValue byteAtIndex:0]];
        }
        else
        {
            strASCII = [self convertDataToAscii:aDataValue];
        }

        strHex = [aDataValue hexadecimalString];
        
        strHex = [self removeTrailingZeros:strHex];

        if (segmentControl.selectedSegmentIndex == 0)
        {
            if([characteristic.UUID.UUIDString isEqualToString:@"2A19"])
            {
                txtFieldValue.text = [NSString stringWithFormat:@"%d",(int)[aDataValue byteAtIndex:0]];
            }
            else
            {
                txtFieldValue.text = [self convertDataToAscii:aDataValue];
            }
        }
        else
        {
            txtFieldValue.text = strHex;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    self.selectedCharacteristic = characteristic;
    
    if (self.selectedCharacteristic.isNotifying) {
        [btnNotify setTitle:@"Notify Off" forState:UIControlStateNormal];
    }
    else
        [btnNotify setTitle:@"Notify On" forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Notification changed successfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"error:-%@",error);
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Custom Methods
#pragma mark -

- (NSString *) removeTrailingZeros:(NSString *)Instring
{
    NSString *str2 =Instring ;
    int size = sizeof(str2);
    for (NSInteger index =[str2 length]-1; index>0; index--)
    {
        unichar c = [str2 characterAtIndex:index];
        
        if(c == '0')
            str2  =[str2 substringToIndex:str2.length-1];
        else
            break;
    }
    size = sizeof(str2);
    return str2;
    
}

-(NSString *)convertDataToAscii:(NSData *)aData
{
    NSMutableString *_string = [NSMutableString stringWithString:@""];
    for (int i = 0; i < aData.length; i++) {
        unsigned char _byte;
            [aData getBytes:&_byte range:NSMakeRange(i, 1)];
            if (_byte >= 32 && _byte < 127) {
                [_string appendFormat:@"%c", _byte];
            } 
    }
    return _string;
}


@end
