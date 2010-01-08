// NCXNavigationDefinition.m

#import "NCXNavigationDefinition.h"

@implementation NCXNavigationDefinition

@synthesize navigationPoints = navigationPoints_;

- (id) init
{
	if ((self = [super init]) != nil) {
		navigationPoints_ = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc
{
	[navigationPoints_ release];
	[super dealloc];
}

- (void) addNavigationPoint: (NCXNavigationPoint*) navigationPoint
{
	[navigationPoints_ addObject: navigationPoint];
}

@end
