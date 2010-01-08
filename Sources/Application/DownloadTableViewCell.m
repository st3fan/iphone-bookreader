// DownloadTableViewCell.m

#import "DownloadTableViewCell.h"
#import "DownloadManager.h"

@implementation DownloadTableViewCell

@synthesize download = download_;
@synthesize nameLabel = nameLabel_;
@synthesize progressView = progressView_;

- (id) initWithCoder: (NSCoder*) coder
{
    if ((self = [super initWithCoder: coder]) != nil) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
	[download_ release];
    [super dealloc];
}

#pragma mark -

- (void) setDownload: (Download*) download
{
	if (download_ != download) {
		[download_ release];
		download_ = [download retain];
	}
	
	progressView_.progress = download_.progress;
	nameLabel_.text = download_.title;
}

#pragma mark -

- (void) prepareForReuse
{
	[super prepareForReuse];
	
	[download_ release];
	download_ = nil;

	progressView_.progress = 0.0;
	nameLabel_.text = @"";
}

#pragma mark -

- (IBAction) cancelDownload
{
	[[DownloadManager sharedDownloadManager] stopDownload: download_];
}

@end