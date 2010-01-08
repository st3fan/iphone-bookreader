// BookReaderAppDelegate.m

#import "BookReaderAppDelegate.h"
#import "Catalog.h"
#import "Shelf.h"

@implementation BookReaderAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    [window addSubview:tabBarController.view];
	
	[[UIApplication sharedApplication] setStatusBarHidden: YES];
	
	[[DownloadManager sharedDownloadManager] addDelegate: self];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

#pragma mark -

- (void) updateDownloadsBadge
{
	NSUInteger downloadCount = [[[DownloadManager sharedDownloadManager] downloads] count];

	// Find the Downloads item
	
	for (UITabBarItem* item in tabBarController.tabBar.items) {
		if (item.tag == 3) {
			if (downloadCount > 0) {
				item.badgeValue = [NSString stringWithFormat: @"%d", downloadCount];
			} else {
				item.badgeValue = nil;
			}
		}
	}
}

- (void) downloadManager: (DownloadManager*) downloadManager didQueueDownload: (Download*) download
{
	[self updateDownloadsBadge];
}

- (void) downloadManager: (DownloadManager*) downloadManager didCancelDownload: (Download*) download
{
	[self updateDownloadsBadge];
}

- (void) downloadManager: (DownloadManager*) downloadManager didFinishDownload: (Download*) download withData: (NSData*) data
{
	[self updateDownloadsBadge];
	
	CatalogEntry* catalogEntry = [[Catalog sharedCatalog] entryWithTitle: download.title];
	if (catalogEntry != nil) {	
		[[Shelf sharedShelf] createBookFromCatalogEntry: catalogEntry data: data];
	}
}

@end