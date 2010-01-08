// DownloadManager.h

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"

@class DownloadManager, Download;

@protocol DownloadManagerDelegate <NSObject>
@optional
- (void) downloadManager: (DownloadManager*) downloadManager didQueueDownload: (Download*) download;
- (void) downloadManager: (DownloadManager*) downloadManager didCancelDownload: (Download*) download;
- (void) downloadManager: (DownloadManager*) downloadManager didFinishDownload: (Download*) download withData: (NSData*) data;
- (void) downloadManager: (DownloadManager*) downloadManager didUpdateDownload: (Download*) download;
@end

@interface DownloadManager : NSObject <DownloadOperationDelegate> {
  @private
	NSMutableArray* downloads_;
	NSMutableArray* delegates_;
	NSOperationQueue* operationQueue_;
}

+ (id) sharedDownloadManager;

@property (nonatomic,readonly) NSArray* downloads;

- (void) addDelegate: (id<DownloadManagerDelegate>) delegate;
- (void) removeDelegate: (id<DownloadManagerDelegate>) delegate;

- (void) queueDownload: (Download*) download;
- (void) stopDownload: (Download*) download;

@end