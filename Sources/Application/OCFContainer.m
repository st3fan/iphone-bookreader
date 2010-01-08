// OCFContainer.m

#import "OCFContainer.h"

@implementation OCFContainer

@synthesize rootFiles = rootFiles_;

- (id) init
{
	if ((self = [super init]) != nil) {
		rootFiles_ = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc
{
	[rootFiles_ release];
	[super dealloc];
}

- (void) addRootFile: (OCFRootFile*) rootFile
{
	[rootFiles_ addObject: rootFile];
}

@end