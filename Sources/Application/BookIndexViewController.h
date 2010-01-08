// BookIndexViewController.h

#import <UIKit/UIKit.h>
#import "Book.h"
#import "NCXNavigationDefinition.h"

@interface BookIndexViewController : UITableViewController {
	Book* book_;
	NCXNavigationDefinition* navigationDefinition_;
}

- (id) initWithBook: (Book*) book;

@end