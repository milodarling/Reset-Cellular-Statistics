static BOOL enabled;
static NSInteger *resetDate;

@interface timerClass : NSObject
- (void)timer;
@end

@implementation timerClass
- (void)timer{
  NSTimer *timer;

  timer = [NSTimer scheduledTimerWithTimeInterval: 86400
    target: self
    selector: @selector(handleTimer:)
    userInfo: nil
    repeats: YES];
}
@end


static void loadPreferences() {
  CFPreferencesAppSynchronize(CFSTR("com.greeny.autostatisticsreset"));
      //In this case, you get the value for the key "enabled"
      //you could do the same thing for any other value, just cast it to id and use the conversion methods
      //if the value doesn't exist (i.e. the user hasn't changed their preferences), it is set to the value after the "?:" (in this case, YES and @"default", respectively
  enabled = [(id)CFPreferencesCopyAppValue(CFSTR("enabled"), CFSTR("com.greeny.autostatisticsreset")) boolValue];
  resetDate = [[NSNumber numberWithString:(NSString*)CFPreferencesCopyAppValue(CFSTR("resetDate"), CFSTR("com.greeny.autostatisticsreset"))] integerValue];
}

static BOOL shouldResetData() {
  NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar]; //current user calendar
  NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay) fromDate:[NSDate date]]; //separates NSDate into components
  if (resetDate == dateComponents.day) { //compare date from prefs to current date
    return TRUE; //dates match
  } else {
    return FALSE; //dates do not match
  }
}

static void resetData() { //call your method to reset data (there should be an instance of SettingsNetworkController that you can hook into here)
[[%c(SettingsNetworkController) sharedInstance] SettingsNetworkController clearStats];
}

//method should reset data usage
%hook SettingsNetworkController
static SettingsNetworkController *__weak sharedInstance;
-(id)init {
  id original = %orig;
  sharedInstance = original;
return original;
}

%new
+(id)sharedInstance{
  return sharedInstance;
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

  [timerClass timer];
}

/*
You need to put this somewhere where it runs every day. This will check if the current date is the reset date and then run your reset logic if it is.

if (shouldResetData()) { 
  resetData();
}
*/

/*
NSTimer *timer;

    timer = [NSTimer scheduledTimerWithTimeInterval: 86400
                     target: self
                     selector: @selector(handleTimer:)
                     userInfo: nil
                     repeats: YES];

  Would something like this work?
*/

