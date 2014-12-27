
//Initialize the variables.
bool enabled;

static void loadPreferences() {
    CFPreferencesAppSynchronize(CFSTR("com.greeny.autostatisticsreset"));
    //In this case, you get the value for the key "enabled"
    //you could do the same thing for any other value, just cast it to id and use the conversion methods
    //if the value doesn't exist (i.e. the user hasn't changed their preferences), it is set to the value after the "?:" (in this case, YES and @"default", respectively
    enabled = [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.greeny.autostatisticsreset")) boolValue];
    someString = [(id)CFPreferencesCopyAppValue(CFSTR("someString"), CFSTR("com.greeny.autostatisticsreset")) stringValue];
}
@interface dateGrabber
@end

@implementation dateGrabber
- (void)grabDate{
  NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init]; 
  [DateFormatter setDateFormat:@"dd"];  
  NSLog(@"look here %@",[DateFormatter stringFromDate:[NSDate date]]);
}
@end

//method should reset data usage
%hook SettingsNetworkController
-(void)clearStats:(id)totalDataUsageForSpecifier{
  %orig;
}
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application{
  [dateGrabber grabDate];
  %orig;
}
%end

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                NULL,
                                (CFNotificationCallback)loadPreferences,
                                CFSTR("com.greeny.autostatisticsreset/prefsChanged"),
                                NULL,
                                CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPreferences();
}