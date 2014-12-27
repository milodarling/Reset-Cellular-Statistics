#import <Preferences/Preferences.h>

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
@end
