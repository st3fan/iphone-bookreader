// DownloadOperation.h

#import <Foundation/Foundation.h>
#import "Download.h"

@class DownloadOperation;

@protocol DownloadOperationDelegate<NSObject>
- (void) downloadOperationDidFinish: (DownloadOperation*) operation;
- (void) downloadOperationDidFail: (DownloadOperation*) operation;
- (void) downloadOperationDidMakeProgress: (DownloadOperation*) operation;
@end

@interface DownloadOperation : NSOperation {
  @private
    NSMutableData* data_;
	Download* download_;
	id<DownloadOperationDelegate> delegate_;
	NSURLConnection* connection_;
	NSInteger statusCode_;
	BOOL executing_;
	BOOL finished_;
}

- (id) initWithDownload: (Download*) download delegate: (id<DownloadOperationDelegate>) delegate;

@property (nonatomic,readonly) Download* download;
@property (nonatomic,readonly) NSData* data;

@end