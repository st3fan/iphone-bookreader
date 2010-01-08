// DownloadsViewController.m

#import "DownloadsViewController.h"
#import "DownloadTableViewCell.h"

@implementation DownloadsViewController

#pragma mark UIViewController

- (void) viewDidLoad
{
	[[DownloadManager sharedDownloadManager] addDelegate: self];
}

- (void) viewDidUnload
{
	[[DownloadManager sharedDownloadManager] removeDelegate: self];
}

#pragma mark UITableViewController Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DownloadManager sharedDownloadManager] downloads] count];
}

- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"DownloadTableViewCell"];
	if (cell == nil) {
		NSArray* objects = [[NSBundle mainBundle] loadNibNamed: @"DownloadTableViewCell" owner: nil options: nil];
		if (objects != nil) {
			cell = [objects objectAtIndex: 0];
		}
	}

	if (cell != nil) {
		Download* download = [[[DownloadManager sharedDownloadManager] downloads] objectAtIndex: indexPath.row];
		if (download != nil) {
			DownloadTableViewCell* downloadTableViewCell = (DownloadTableViewCell*) cell;
			downloadTableViewCell.download = download;
		}
	}
	
	return cell;
}

#pragma mark DownloadManager Notifications

- (void) downloadManager: (DownloadManager*) downloadManager didQueueDownload: (Download*) download
{
	[self.tableView reloadData];
}

- (void) downloadManager: (DownloadManager*) downloadManager didCancelDownload: (Download*) download
{
	[self.tableView reloadData];
}

- (void) downloadManager: (DownloadManager*) downloadManager didFinishDownload: (Download*) download withData: (NSData*) data
{
	[self.tableView reloadData];
}

- (void) downloadManager: (DownloadManager*) downloadManager didUpdateDownload: (Download*) download
{
	[self.tableView reloadData];
}

@end