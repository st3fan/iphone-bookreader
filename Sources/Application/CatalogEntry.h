// CatalogEntry.h

#import <Foundation/Foundation.h>

@interface CatalogEntry : NSObject {
  @private
	NSString* title_;
	NSString* author_;
	NSURL* url_;
}

@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* author;
@property (nonatomic,retain) NSURL* url;

@end