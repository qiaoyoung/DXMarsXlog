#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXMarsXLogger: NSObject

+ (instancetype)shared;

+ (void)logDebug:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function;

+ (void)logInfo:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function;

+ (void)logWarning:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function;

+ (void)logError:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function;

+ (NSString *)getLogPath;

- (void)initWithNamePrefix:(const char *)namePrefix;

- (void)flush;

- (void)close;

@end

NS_ASSUME_NONNULL_END
