#import <Preferences/Preferences.h>
#import <Flipswitch/Flipswitch.h>

@interface RCSPrefsListController: PSListController {
}
@end

@implementation RCSPrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"RCSPrefs" target:self] retain];
	}
	return _specifiers;
}
-(void)respring{
	[[FSSwitchPanel sharedPanel] applyActionForSwitchIdentifier:@"com.a3tweaks.switch.respring"];
}
@end

// vim:ft=objc
