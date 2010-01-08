//  BookDetailViewController.h

#import <UIKit/UIKit.h>
#import "CatalogEntry.h"

@interface BookDetailViewController : UIViewController {
	IBOutlet UILabel* bookTitle;
	IBOutlet UILabel* bookAuthor;
	CatalogEntry* catalogEntry_;
}

@property (nonatomic,retain) CatalogEntry* catalogEntry;

- (IBAction) download;

@end
