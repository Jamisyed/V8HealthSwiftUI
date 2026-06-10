#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NewBle.h"

NS_ASSUME_NONNULL_BEGIN

@interface BleDelegateProxy : NSObject <MyBleDelegate>

+ (instancetype)shared;

@property (nonatomic, copy, nullable) void (^onConnectSuccessfully)(void);
@property (nonatomic, copy, nullable) void (^onDisconnect)(NSError * _Nullable error);
@property (nonatomic, copy, nullable) void (^onScan)(CBPeripheral *peripheral, NSDictionary<NSString *, id> *advertisementData, NSNumber *RSSI);
@property (nonatomic, copy, nullable) void (^onConnectFailed)(NSError * _Nullable error);
@property (nonatomic, copy, nullable) void (^onEnableCommunicate)(void);
@property (nonatomic, copy, nullable) void (^onData)(CBPeripheral *peripheral, NSData *data);

@end

NS_ASSUME_NONNULL_END
