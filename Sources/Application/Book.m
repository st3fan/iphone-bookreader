//  Book.m

#import "Book.h"

@implementation Book

@synthesize title = title_;
@synthesize author = author_;
@synthesize fileName = fileName_;

- (id) initWithCoder: (NSCoder*) coder
{
	if ((self = [super init]) != nil) {
		title_ = [[coder decodeObjectForKey: @"title"] retain];
		author_ = [[coder decodeObjectForKey: @"author"] retain];
		fileName_ = [[coder decodeObjectForKey: @"fileName"] retain];
	}
	return self;
}

- (void) dealloc
{
	[title_ release];
	[author_ release];
	[fileName_ release];
	[super dealloc];
}

- (void) encodeWithCoder: (NSCoder*) coder
{
	[coder encodeObject: title_ forKey: @"title"];
	[coder encodeObject: author_ forKey:@"author"];
	[coder encodeObject: fileName_ forKey:@"fileName"];
}

@end