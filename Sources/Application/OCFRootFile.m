// OCFRootFile.m

#import "OCFRootFile.h"

@implementation OCFRootFile

@synthesize fullPath = fullPath_;
@synthesize mediaType = mediaType_;

- (id) init
{
	if ((self = [super init]) != nil) {
	}
	return self;
}

- (void) deallloc
{
	[fullPath_ release];
	[mediaType_ release];
	[super dealloc];
}

@end