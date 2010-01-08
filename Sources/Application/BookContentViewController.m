//  BookContentViewController.m

#import "BookContentViewController.h"

@implementation BookContentViewController

@synthesize webView = webView_;

- (id) initWithBook: (Book*) book navigationPoint: (NCXNavigationPoint*) navigationPoint
{
	if ((self = [super initWithNibName: @"BookContentViewController" bundle: nil]) != nil) {
		book_ = [book retain];
		navigationPoint_ = [navigationPoint retain];
	}
	return self;
}

- (void) viewDidLoad
{
	// Load the content into the view
	NSString* path = [NSString stringWithFormat: @"%@/%@/OPS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName, navigationPoint_.content];
	[webView_ loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: path]]];
}

- (void) dealloc
{
	[book_ release];
	[navigationPoint_ release];
	[super dealloc];
}

@end
