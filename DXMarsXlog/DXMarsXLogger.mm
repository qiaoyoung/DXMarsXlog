#import "DXMarsXLogger.h"
#import <mars/xlog/xlogger.h>
#import <mars/xlog/xloggerbase.h>
#import <mars/xlog/appender.h>
#import <sys/xattr.h>

static NSUInteger g_processID = 0;

@implementation DXMarsXLogger

+ (instancetype)shared {
    static DXMarsXLogger *logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [self new];
    });
    return logger;
}
 
+ (void)logDebug:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function {
    [self logWithLevel:kLevelDebug
            moduleName:[tag UTF8String]
              fileName:file
            lineNumber:(int)line
              funcName:function
               message:message];
}

+ (void)logInfo:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function {
    [self logWithLevel:kLevelInfo
            moduleName:[tag UTF8String]
              fileName:file
            lineNumber:(int)line
              funcName:function
               message:message];
}

+ (void)logWarning:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function {
    [self logWithLevel:kLevelWarn
            moduleName:[tag UTF8String]
              fileName:file
            lineNumber:(int)line
              funcName:function
               message:message];
}

+ (void)logError:(NSString *)tag message:(NSString *)message file:(const char *)file line:(NSInteger)line function:(const char *)function {
    [self logWithLevel:kLevelError
            moduleName:[tag UTF8String]
              fileName:file
            lineNumber:(int)line
              funcName:function
               message:message];
}

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char *)moduleName fileName:(const char *)fileName lineNumber:(int)lineNumber funcName:(const char *)funcName message:(NSString *)message {
    XLoggerInfo info;
    info.level = logLevel;
    info.tag = moduleName;
    info.filename = fileName;
    info.func_name = funcName;
    info.line = lineNumber;
    gettimeofday(&info.timeval, NULL);
    info.tid = (uintptr_t)[NSThread currentThread];
    info.maintid = (uintptr_t)[NSThread mainThread];
    info.pid = g_processID;
    xlogger_Write(&info, message.UTF8String);
}

+ (NSString *)getLogPath {
    NSString *logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/DXMarsXLogger"];
    return logPath;
}

- (void)initWithNamePrefix:(const char *)namePrefix {
    [self close];
    NSString *logPath = [DXMarsXLogger getLogPath];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    setxattr([logPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
#ifdef DEBUG
    xlogger_SetLevel(kLevelDebug);
    mars::xlog::appender_set_console_log(true);
#else
    xlogger_SetLevel(kLevelInfo);
    mars::xlog::appender_set_console_log(false);
#endif
    mars::xlog::XLogConfig config;
    config.mode_ = mars::xlog::kAppenderAsync;
    config.logdir_ = [logPath UTF8String];
    config.nameprefix_ = namePrefix;
    config.pub_key_ = "";
    config.compress_mode_ = mars::xlog::kZlib;
    config.compress_level_ = 0;
    config.cachedir_ = "";
    config.cache_days_ = 7;
    appender_open(config);
}

- (void)flush {
    mars::xlog::appender_flush();
}

- (void)close {
    mars::xlog::appender_close();
}

@end
