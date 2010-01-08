// BookReaderAppDelegate.h

#import <UIKit/UIKit.h>
#import "DownloadManager.h"

@interface BookReaderAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, DownloadManagerDelegate> {
  @private
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end