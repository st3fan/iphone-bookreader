//  NCXNavigationPoint.m

#import "NCXNavigationPoint.h"

@implementation NCXNavigationPoint

@synthesize identifier = identifier_;
@synthesize playOrder = playOrder_;
@synthesize label = label_;
@synthesize content = content_;

- (void) dealloc
{
	[identifier_ release];
	[playOrder_ release];
	[label_ release];
	[content_ release];
	[super dealloc];
}

@end