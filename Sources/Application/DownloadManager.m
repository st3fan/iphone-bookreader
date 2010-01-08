// DownloadManager.m

#import "BookReaderCommon.h"
#import "DownloadManager.h"
#import "DownloadOperation.h"
#import "Shelf.h"

static DownloadManager* sSharedDownloadManager = nil;

@implementation DownloadManager

@synthesize downloads = downloads_;

+ (id) sharedDownloadManager
{
	@synchronized (self) {
		if (sSharedDownloadManager == nil) {
			sSharedDownloadManager = [DownloadManager new];
		}
	}
	return sSharedDownloadManager;
}

#pragma mark -

- (id) init
{
	if ((self = [super init]) != nil) {
		downloads_ = [NSMutableArray new];
		delegates_ = [NSMutableArray new];
		operationQueue_ = [NSOperationQueue new];
		[operationQueue_ setMaxConcurrentOperationCount: BOOKREADER_CONCURRENT_DOWNLOADS_COUNT];
	}
	return self;
}

- (void) dealloc
{
	[operationQueue_ release];
	[downloads_ release];
	[delegates_ release];
	[super dealloc];
}

#pragma mark -

- (void) addDelegate: (id<DownloadManagerDelegate>) delegate
{
	NSValue* delegateValue = [NSValue valueWithPointer: delegate];
	[delegates_ addObject: delegateValue];
}

- (void) removeDelegate: (id<DownloadManagerDelegate>) delegate
{
	NSValue* delegateValue = [NSValue valueWithPointer: delegate];
	[delegates_ removeObjectIdenticalTo: delegateValue];
}

#pragma mark -

- (void) queueDownload: (Download*) download
{
	[downloads_ addObject: download];

	for (NSValue* delegateValue in delegates_) {
		id<DownloadManagerDelegate> delegate = [delegateValue pointerValue];
		if([delegate respondsToSelector: @selector(downloadManager:didQueueDownload:)] == YES) {
			[delegate downloadManager: self didQueueDownload: download];
		}
	}

	DownloadOperation* downloadOperation = [[[DownloadOperation alloc] initWithDownload: download delegate: self] autorelease];
	[operationQueue_ addOperation: downloadOperation];
}

- (void) stopDownload: (Download*) download
{
	if ([downloads_ containsObject: download])
	{
		[download retain];
		
		[downloads_ removeObject: download];

		for (NSValue* delegateValue in delegates_) {
			id<DownloadManagerDelegate> delegate = [delegateValue pointerValue];
			if([delegate respondsToSelector: @selector(downloadManager:didCancelDownload:)] == YES) {
				[delegate downloadManager: self didCancelDownload: download];
			}
		}
		
		[download release];
	}
}

#pragma mark DownloadManagerDelegate Methods

- (void) downloadOperationDidFinish: (DownloadOperation*) operation
{
	if ([downloads_ containsObject: operation.download])
	{		
		[downloads_ removeObject: operation.download];

		for (NSValue* delegateValue in delegates_) {
			id<DownloadManagerDelegate> delegate = [delegateValue pointerValue];
			if([delegate respondsToSelector: @selector(downloadManager:didFinishDownload:withData:)] == YES) {
				[delegate downloadManager: self didFinishDownload: operation.download withData: operation.data];
			}
		}
	}
}

- (void) downloadOperationDidFail: (DownloadOperation*) operation
{
	if ([downloads_ containsObject: operation.download])
	{		
		[downloads_ removeObject: operation.download];

		for (NSValue* delegateValue in delegates_) {
			id<DownloadManagerDelegate> delegate = [delegateValue pointerValue];
			if([delegate respondsToSelector: @selector(downloadManager:didCancelDownload:)] == YES) {
				[delegate downloadManager: self didCancelDownload: operation.download];
			}
		}
	}
}

- (void) downloadOperationDidMakeProgress: (DownloadOperation*) operation
{
	for (NSValue* delegateValue in delegates_) {
		id<DownloadManagerDelegate> delegate = [delegateValue pointerValue];
		if([delegate respondsToSelector: @selector(downloadManager:didUpdateDownload:)] == YES) {
			[delegate downloadManager: self didUpdateDownload: operation.download];
		}
	}
}

@end