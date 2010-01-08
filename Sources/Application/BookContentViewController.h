// BookContentViewController.h

#import <UIKit/UIKit.h>
#import "Book.h"
#import "NCXNavigationPoint.h"

@interface BookContentViewController : UIViewController {
  @private
	Book* book_;
	NCXNavigationPoint* navigationPoint_;
  @private
    UIWebView* webView_;
}

@property (nonatomic,assign) IBOutlet UIWebView* webView;

- (id) initWithBook: (Book*) book navigationPoint: (NCXNavigationPoint*) navigationPoint;

@end
