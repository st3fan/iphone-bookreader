// DownloadTableViewCell.h

#import <UIKit/UIKit.h>
#import "Download.h"

@interface DownloadTableViewCell : UITableViewCell {
  @private
	Download* download_;
  @private
    UILabel* nameLabel_;
	UIProgressView* progressView_;
}

@property (nonatomic,retain) Download* download;

@property (nonatomic,assign) IBOutlet UILabel* nameLabel;
@property (nonatomic,assign) IBOutlet UIProgressView* progressView;

- (IBAction) cancelDownload;

@end