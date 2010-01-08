//  BookDetailViewController.m

#import "BookDetailViewController.h"
#import "Download.h"
#import "DownloadManager.h"

@implementation BookDetailViewController

@synthesize catalogEntry = catalogEntry_;

- (void) viewWillAppear: (BOOL) animated
{
	bookTitle.text = catalogEntry_.title;
	bookAuthor.text = catalogEntry_.author;
}

- (IBAction) download
{
	Download* download = [Download downloadWithTitle: catalogEntry_.title url: catalogEntry_.url];
	[[DownloadManager sharedDownloadManager] queueDownload: download];
}

@end