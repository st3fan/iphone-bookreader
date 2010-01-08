// Download.h

#import <Foundation/Foundation.h>

@interface Download : NSObject {
  @private
	NSString* title_;
	NSURL* url_;
	NSUInteger size_;
	float progress_;
}

@property (nonatomic,readonly) NSString* title;
@property (nonatomic,readonly) NSURL* url;

@property (nonatomic,assign) float progress;
@property (nonatomic,assign) NSUInteger size;

+ downloadWithTitle: (NSString*) title url: (NSURL*) url;

- (id) initWithTitle: (NSString*) title url: (NSURL*) url;

@end