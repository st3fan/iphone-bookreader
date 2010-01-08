// Download.m

#import "Download.h"

@implementation Download

@synthesize title = title_;
@synthesize url = url_;
@synthesize progress = progress_;
@synthesize size = size_;

#pragma mark -

+ downloadWithTitle: (NSString*) title url: (NSURL*) url
{
	return [[[self alloc] initWithTitle: title url: url] autorelease];
}

#pragma mark -

- (id) initWithTitle: (NSString*) title url: (NSURL*) url
{
	if ((self = [super init]) != nil) {
		title_ = [title copy];
		url_ = [url copy];
	}
	return self;
}

- (void) dealloc
{
	[title_ release];
	[url_ release];
	[super dealloc];
}

@end