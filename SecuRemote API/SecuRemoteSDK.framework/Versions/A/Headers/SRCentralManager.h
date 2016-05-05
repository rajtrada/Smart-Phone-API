//
//  SRBleCentralManager.h
//
//  Copyright (c) 2015 SciTER. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@class SRCentralManager;

@protocol SRCentralManagerDelegate <NSObject>;

@optional

/*!
 *  @method centralManagerDidUpdateState:
 *
 *  @param central  The central manager whose state has changed.
 *
 *  @discussion     Invoked whenever the central manager's state has been updated. Commands should only be issued when the state is
 *                  <code>CBCentralManagerStatePoweredOn</code>. A state below <code>CBCentralManagerStatePoweredOn</code>
 *                  implies that scanning has stopped and any connected peripherals have been disconnected. If the state moves below
 *                  <code>CBCentralManagerStatePoweredOff</code>, all <code>CBPeripheral</code> objects obtained from this central
 *                  manager become invalid and must be retrieved or discovered again.
 *
 *  @see            state
 *
 */

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

/*!
 *  @method centralManager:didDiscoverPeripheral:advertisementData:RSSI:mutDict:
 *
 *  @param central              The central manager providing this update.
 *  @param peripheral           A <code>CBPeripheral</code> object.
 *  @param advertisementData    A dictionary containing any advertisement and scan response data.
 *  @param RSSI                 The current RSSI of <i>peripheral</i>, in dBm. A value of <code>127</code> is reserved and indicates the RSSI
 *								was not available.
 *  @param mutDict              A dictionary containing peripheral,name,serialno,securitylevel.
 *
 *  @discussion                 This method is invoked while scanning, upon the discovery of <i>peripheral</i> by <i>central</i>. A discovered peripheral must
 *                              be retained in order to use it; otherwise, it is assumed to not be of interest and will be cleaned up by the central manager. For
 *                              a list of <i>advertisementData</i> keys, see {@link CBAdvertisementDataLocalNameKey} and other similar constants.
 *
 *  @seealso                    CBAdvertisementData.h
 *
 */

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI mutDict:(NSMutableDictionary *)mutDictData;

/*!
 *  @method centralManager:didConnectPeripheral:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has connected.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has succeeded.
 *
 */

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;

/*!
 *  @method peripheral:didDiscoverServices:
 *
 *  @param peripheral	The peripheral providing this information.
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverServices: @/link call. If the service(s) were read successfully, they can be retrieved via
 *						<i>peripheral</i>'s @link services @/link property.
 *
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;

/*!
 *  @method peripheral:didDiscoverCharacteristicsForService:error:
 *
 *  @param peripheral	The peripheral providing this information.
 *  @param service		The <code>CBService</code> object containing the characteristic(s).
 *	@param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link discoverCharacteristics:forService: @/link call. If the characteristic(s) were read successfully,
 *						they can be retrieved via <i>service</i>'s <code>characteristics</code> property.
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;

/*!
 *  @method centralManager:didFailToConnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has failed to connect.
 *  @param error        The cause of the failure.
 *
 *  @discussion         This method is invoked when a connection initiated by {@link connectPeripheral:options:} has failed to complete. As connection attempts do not
 *                      timeout, the failure of a connection is atypical and usually indicative of a transient issue.
 *
 */

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

/*!
 *  @method peripheral:didUpdateValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *  @param aDataValue        
 *
 *  @discussion				This method is invoked after a @link readValueForCharacteristic: @/link call, or upon receipt of a notification/indication.
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error value:(NSData *)aDataValue;

/*!
 *  @method peripheral:didWriteValueForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a {@link writeValue:forCharacteristic:type:} call, when the <code>CBCharacteristicWriteWithResponse</code> type is used.
 */

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

/*!
 *  @method peripheral:didReadRSSI:error:
 *
 *  @param peripheral	The peripheral providing this update.
 *  @param RSSI			The current RSSI of the link.
 *  @param error		If an error occurred, the cause of the failure.
 *
 *  @discussion			This method returns the result of a @link readRSSI: @/link call.
 */

-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error;

/*!
 *  @method peripheral:didUpdateNotificationStateForCharacteristic:error:
 *
 *  @param peripheral		The peripheral providing this information.
 *  @param characteristic	A <code>CBCharacteristic</code> object.
 *	@param error			If an error occurred, the cause of the failure.
 *
 *  @discussion				This method returns the result of a @link setNotifyValue:forCharacteristic: @/link call.
 */

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

/*!
 *  @method centralManager:didDisconnectPeripheral:error:
 *
 *  @param central      The central manager providing this information.
 *  @param peripheral   The <code>CBPeripheral</code> that has disconnected.
 *  @param error        If an error occurred, the cause of the failure.
 *
 *  @discussion         This method is invoked upon the disconnection of a peripheral that was connected by {@link connectPeripheral:options:}. If the disconnection
 *                      was not initiated by {@link cancelPeripheralConnection}, the cause will be detailed in the <i>error</i> parameter. Once this method has been
 *                      called, no more methods will be invoked on <i>peripheral</i>'s <code>CBPeripheralDelegate</code>.
 *
 */

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

/*!
 *  @method connectionDidTimeout:
 *  
 *  @discussion   This method will invoke if peripheral connection timeout.
 *
 */

-(void)didConnectionTimeout;

/*!
 *  @method didSessionCreated:
 *
 *  @discussion    This method will invoke if session created successfully.
 *
 */

-(void)didSessionCreated;

/*!
 *  @method didSessionCreationFailed:
 *
 *  @discussion  This method will invoke if session creation faild due to some error.
 *
 */

-(void)didSessionCreationFailed:(NSString *)aStrError;

/*!
 *  @method didReadConfiguration:
 *
 *  @discussion This method will invoke when configuration read successfully.
 *
 *  @param  data  Configuration data which is set on device.
 */

-(void)didReadConfiguration:(NSData *)data;

/*!
 *  @method didWriteConfiguration:
 *
 *  @discussion  This method will invoke after successfull configuration set in device.
 *
 */

-(void)didWriteConfiguration;

/*!
 *  @method didRelayOperated:
 *
 *  @discussion This method will invoke when relay operated successfully.
 *
 *  @param  data return relay data.
 */

-(void)didRelayOperated:(NSData *)data;

/*!
 *  @method didSolenoidOperated:
 *
 *  @discussion This method will invoke when Solenoid operated.
 *
 *  @param  data return Solenoid data.
 */

-(void)didSolenoidOperated:(NSData *)data;

/*!
 *  @method didMotorOperated:
 *
 *  @discussion This method will invoke when motor operated.
 *
 *  @param  data return motor data.
 */

-(void)didMotorOperated:(NSData *)data;

/*!
 *  @method didGetSwitchStatus:
 *
 *  @discussion This method will invoke when switch status received.
 *
 *  @param  data return switch data.
 */

-(void)didGetSwitchStatus:(NSData *)data;

/*!
 *  @method didGetTemperatureSensor:
 *
 *  @discussion This method will invoke when temperature sensor received.
 *
 *  @param  data return temperature data.
 */

-(void)didGetTemperatureSensor:(NSData *)data;

/*!
 *  @method didLightOperated:
 *
 *  @discussion This method will invoke when light operation successful.
 *
 *  @param  data return light data.
 */

-(void)didLightOperated:(NSData *)data;

/*!
 *  @method didChangedLightIntensity:
 *
 *  @discussion This method will invoke when light intensity changed successful.
 *
 *  @param  data return light data.
 */

-(void)didChangedLightIntensity:(NSData *)data;

/*!
 *  @method didGetAccelerometer:
 *
 *  @discussion This method will invoke when accelerometer data received.
 *
 *  @param  data return accelerometer data.
 */

-(void)didGetAccelerometer:(NSData *)data;

/*!
 *  @method didGetMotionSensor:
 *
 *  @discussion This method will invoke when motion sensor data received.
 *
 *  @param  data return motion sensor data.
 */

-(void)didGetMotionSensor:(NSData *)data;

/*!
 *  @method didGetWaterSensor:
 *
 *  @discussion This method will invoke when water sensor data received.
 *
 *  @param  data return water sensor data.
 */

-(void)didGetWaterSensor:(NSData *)data;

/*!
 *  @method didGetBatteryLevel:
 *
 *  @discussion This method will invoke when battery level received.
 *
 *  @param  data return battery level data.
 */

-(void)didGetBatteryLevel:(NSData *)data;


/*!
 *  @method didGetHumidity:
 *
 *  @discussion This method will invoke when humidity data received.
 *
 *  @param  data return humidity data.
 */

-(void)didGetHumidity:(NSData *)data;

/*!
 *  @method didOperationFailWithError:
 *
 *  @discussion This method will invoke if any operation fail.
 *
 *  @param  error return string which describes error code and error description.
 */

-(void)didOperationFailWithError:(NSString *)error;

@end

@interface SRCentralManager : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate>

/*!
 *  @property boolIsBluetoothOn
 *
 *  @discussion Whether bluetooth is on or off.
 *
 */

@property (nonatomic,assign)BOOL boolIsBluetoothOn;

/**
 *  Delegate object receiving callbacks.
 */

@property (nonatomic,retain)id<SRCentralManagerDelegate> srDelegate;


/*!
 *  @method initWithDelegate:queue:
 *
 *  @param delegate The delegate that will receive central role events.
 *  @param queue    The dispatch queue on which the events will be dispatched.
 *
 *  @discussion     The initialization call. The events of the central role will be dispatched on the provided queue.
 *                  If <i>nil</i>, the main queue will be used.
 *
 */

-(id)initWithDelegate:(id)delegate queue:(dispatch_queue_t)queue;

/*!
 *  @method scanForPeripheralsWithServices:options:
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service(s) to scan for.
 *  @param options      An optional dictionary specifying options for the scan.
 *
 *  @discussion         Starts scanning for peripherals that are advertising any of the services listed in <i>serviceUUIDs</i>. Although strongly discouraged,
 *                      if <i>serviceUUIDs</i> is <i>nil</i> all discovered peripherals will be returned. If the central is already scanning with different
 *                      <i>serviceUUIDs</i> or <i>options</i>, the provided parameters will replace them.
 *                      Applications that have specified the <code>bluetooth-central</code> background mode are allowed to scan while backgrounded, with two
 *                      caveats: the scan must specify one or more service types in <i>serviceUUIDs</i>, and the <code>CBCentralManagerScanOptionAllowDuplicatesKey</code>
 *                      scan option will be ignored.
 *
 *  @see                centralManager:didDiscoverPeripheral:advertisementData:RSSI:
 *  @seealso            CBCentralManagerScanOptionAllowDuplicatesKey
 *	@seealso			CBCentralManagerScanOptionSolicitedServiceUUIDsKey
 *
 */

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options;

/*!
 *  @method connectPeripheral:options:
 *
 *  @param peripheral   The <code>CBPeripheral</code> to be connected.
 *  @param options      An optional dictionary specifying connection behavior options.
 *
 *  @discussion         Initiates a connection to <i>peripheral</i>. Connection attempts never time out and, depending on the outcome, will result
 *                      in a call to either {@link centralManager:didConnectPeripheral:} or {@link centralManager:didFailToConnectPeripheral:error:}.
 *                      Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link cancelPeripheralConnection}.
 *
 *  @see                centralManager:didConnectPeripheral:
 *  @see                centralManager:didFailToConnectPeripheral:error:
 *  @seealso            CBConnectPeripheralOptionNotifyOnConnectionKey
 *  @seealso            CBConnectPeripheralOptionNotifyOnDisconnectionKey
 *  @seealso            CBConnectPeripheralOptionNotifyOnNotificationKey
 *
 */

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary *)options;

/*!
 *  @method discoverServices:
 *
 *  @param serviceUUIDs A list of <code>CBUUID</code> objects representing the service types to be discovered. If <i>nil</i>,
 *						all services will be discovered, which is considerably slower and not recommended.
 *
 *  @discussion			Discovers available service(s) on the peripheral.
 *
 *  @see				peripheral:didDiscoverServices:
 */

- (void)discoverServices:(NSArray *)serviceUUIDs;

/*!
 *  @method discoverCharacteristics:forService:
 *
 *  @param characteristicUUIDs	A list of <code>CBUUID</code> objects representing the characteristic types to be discovered. If <i>nil</i>,
 *								all characteristics of <i>service</i> will be discovered, which is considerably slower and not recommended.
 *  @param service				A GATT service.
 *
 *  @discussion					Discovers the specified characteristic(s) of <i>service</i>.
 *
 *  @see						peripheral:didDiscoverCharacteristicsForService:error:
 */

- (void)discoverCharacteristics :(NSArray *)characteristicUUIDs forService:(CBService *)service;

/*!
 *  @method readValueForCharacteristic:
 *
 *  @param characteristic	A GATT characteristic.
 *
 *  @discussion				Reads the characteristic value for <i>characteristic</i>.
 *
 *  @see					peripheral:didUpdateValueForCharacteristic:error:Value:
 */

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic;

/*!
 *  @method writeValue:forCharacteristic:type:
 *
 *  @param data				The value to write.
 *  @param characteristic	The characteristic whose characteristic value will be written.
 *  @param type				The type of write to be executed.
 *
 *  @discussion				Writes <i>value</i> to <i>characteristic</i>'s characteristic value.
 *							If the <code>CBCharacteristicWriteWithResponse</code> type is specified, {@link peripheral:didWriteValueForCharacteristic:error:}
 *							is called with the result of the write request.
 *							If the <code>CBCharacteristicWriteWithoutResponse</code> type is specified, the delivery of the data is best-effort and not
 *							guaranteed.
 *
 *  @see					peripheral:didWriteValueForCharacteristic:error:
 *	@see					CBCharacteristicWriteType
 */

- (void)writeValueforCharacteristic:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;

/*!
 *  @method setNotifyValue:forCharacteristic:
 *
 *  @param enabled			Whether or not notifications/indications should be enabled.
 *  @param characteristic	The characteristic containing the client characteristic configuration descriptor.
 *
 *  @discussion				Enables or disables notifications/indications for the characteristic value of <i>characteristic</i>. If <i>characteristic</i>
 *							allows both, notifications will be used.
 *                          When notifications/indications are enabled, updates to the characteristic value will be received via delegate method
 *                          @link peripheral:didUpdateValueForCharacteristic:error: @/link. Since it is the peripheral that chooses when to send an update,
 *                          the application should be prepared to handle them as long as notifications/indications remain enabled.
 *
 *  @see					peripheral:didUpdateNotificationStateForCharacteristic:error:
 *  @seealso                CBConnectPeripheralOptionNotifyOnNotificationKey
 */

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic;

/*!
 *  @method disconnectSRDevice:
 *
 *  @param peripheral   A <code>CBPeripheral</code>.
 *
 *  @discussion         Cancels an active or pending connection to <i>peripheral</i>. Note that this is non-blocking, and any <code>CBPeripheral</code>
 *                      commands that are still pending to <i>peripheral</i> may or may not complete.
 *
 *  @see                centralManager:didDisconnectPeripheral:error:
 *
 */

-(void)disconnectSRDevice;

/*!
 *  @method readRSSIValue
 *
 *  @discussion While connected, retrieves the current RSSI of the link.
 *
 *  @see        peripheral:didReadRSSI:error:
 */

-(void)readRSSIValue;

/*!
 *  @method stopScan:
 *
 *  @discussion Stops scanning for SR Devices.
 *
 */

-(void)stopScan;

/*!
 *  @method createSession:
 *
 *  @discussion Creates session based on security level..
 *
 */

-(void)createSession;

/*!
 *  @method isSRDeviceConnected:
 *
 *  @discussion return if device is connected or not.
 *
 */

-(BOOL)isSRDeviceConnected;

/*!
 *  @method getSRDeviceInfo:
 *
 *  @discussion return dictionary with keys peripheral,name,seriano,security level and other information.
 *
 */

-(NSDictionary *)getSRDeviceInfo;

/*!
 *  @method getCharacteristicProperty:
 *
 *  @discussion return dictionary whether characteristic isRead,isNotify or isWrite.
 *
 */

-(NSMutableDictionary *)getCharacteristicProperty:(CBCharacteristic *)characteristic;

/*!
 *  @method getSRDeviceConfiguration:
 *
 *  @discussion get device configuration like motion sensor,humidity and other information.
 *
 *  @see  didReadConfiguration:
 */

-(void)getSRDeviceConfiguration;

/*!
 *  @method setSRDeviceConfiguration:
 *
 *  @discussion set device configuration.
 *
 *  @param aBoolMotion             Whether or not Motion should be enabled.
 *  @param aBoolHumidity           Whether or not Humidity should be enabled.
 *  @param aIntTxPower             Tx power should be Proximity-1, Low-2, Medium-3, High-4
 *  @param aIntAntenna             Antenna type should be chip=0, ufl-1,
 *  @param aIntNWConfiguration     Network Configuration should be Join All-0, Connect With Co-ordinator-1, Connect With Router-2
 *  @param aIntBoardType
 *
 *  @see  didWriteConfiguration:
 */

-(void)setSRDeviceConfiguration:(BOOL)aBoolMotion aBoolHumidity:(BOOL)aBoolHumidity aIntTxPower:(int)aIntTxPower aIntAntenna:(int)aIntAntenna aIntNWConfiguration:(int)aIntNWConfiguration aIntBoardType:(int)aIntBoardType;

/*!
 *  @method setSecurityParams:
 *
 *  @discussion set setSecurityParams.
 *
 *  @param aStrSerialNo         pass valid serial no of device.
 *  @param secureToken          pass secure token of device length must be 10.
 *  @param key1                 valid key for data encrpytion/decryption length must be 32
 *  @param key2                 valid key for data encrpytion/decryption length must be 32
 *  @param key3                 valid key for data encrpytion/decryption length must be 32
 *
 *  @see didOperationFailWithError  If valid parameter not passed will call this method.
 */

-(void)setSecurityParams:(NSString *)aStrSerialNo secureToken:(NSString *)aStrSecurityToken key1:(NSString *)aStrKey1 key2:(NSString *)aStrKey2 key3:(NSString *)aStrKey3;

/*!
 *  @method operateRelay:
 *
 *  @discussion operate relay.
 *
 *  @param aBoolIsMomentry   Pass true for RelayMomentary and false for RelayMaintain
 *
 *  @see  didRelayOperated:
 */

-(void)operateRelay:(BOOL)aBoolIsMomentry;

/*!
 *  @method operateSolenoid:
 *
 *  @discussion operate solenoid.
 *
 *  @see  didSolenoidOperated:
 */

-(void)operateSolenoid;

/*!
 *  @method operateMotor:
 *
 *  @discussion operate motor.
 *
 *  @param aBoolIsMomentry   Pass true for motor forward and false for reverse
 *
 *  @see  didMotorOperated:
 */

-(void)operateMotor:(BOOL)aBoolIsForward;

/*!
 *  @method operateLight:
 *
 *  @discussion operate light.
 *
 *  @param aBoolIsOn   Pass true for switch on light and false to swithc off.
 *
 *  @see  didLightOperated:
 */

-(void)operateLight:(BOOL)aBoolIsOn;

/*!
 *  @method setLightIntensity:
 *
 *  @discussion set light intensity.
 *
 *  @param aIntIntensity   pass integer value between 0 to 100 to set intensity.
 *
 *  @see  didChangedLightIntensity:
 */

-(void)setLightIntensity:(int)aIntIntensity;

/*!
 *  @method getSwitchStatus:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetSwitchStatus:
 */

-(void)getSwitchStatus;

/*!
 *  @method getTemperatureSensor:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetTemperatureSensor:
 */

-(void)getTemperatureSensor;

/*!
 *  @method getAccelerometer:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetAccelerometer:
 */

-(void)getAccelerometer;

/*!
 *  @method getMotionSensor:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetMotionSensor:
 */

-(void)getMotionSensor;

/*!
 *  @method getWaterSensor:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetWaterSensor:
 */

-(void)getWaterSensor;

/*!
 *  @method getBatteryLevel:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetBatteryLevel:
 */

-(void)getBatteryLevel;

/*!
 *  @method getHumidity:
 *
 *  @discussion get switch status.
 *
 *  @see  didGetHumidity:
 */

-(void)getHumidity;


@end

