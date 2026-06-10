#import "BleDelegateProxy.h"

@implementation BleDelegateProxy

+ (instancetype)shared {
    static BleDelegateProxy *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BleDelegateProxy alloc] init];
    });
    return instance;
}

- (void)ConnectSuccessfully {
    if (self.onConnectSuccessfully) self.onConnectSuccessfully();
}

- (void)Disconnect:(NSError *)error {
    if (self.onDisconnect) self.onDisconnect(error);
}

- (void)scanWithPeripheral:(CBPeripheral *)peripheral
         advertisementData:(NSDictionary<NSString *, id> *)advertisementData
                      RSSI:(NSNumber *)RSSI {
    if (self.onScan) self.onScan(peripheral, advertisementData, RSSI);
}

- (void)ConnectFailedWithError:(NSError *)error {
    if (self.onConnectFailed) self.onConnectFailed(error);
}

- (void)EnableCommunicate {
    if (self.onEnableCommunicate) self.onEnableCommunicate();
}

- (void)BleCommunicateWithPeripheral:(CBPeripheral *)peripheral data:(NSData *)data {
    if (self.onData) self.onData(peripheral, data);
}

@end
