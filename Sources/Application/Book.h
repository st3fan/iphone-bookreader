// Book.h

#import <Foundation/Foundation.h>

@interface Book : NSObject <NSCoding> {
  @private
	NSString* title_;
	NSString* author_;
	NSString* fileName_;
}

@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* author;
@property (nonatomic,retain) NSString* fileName;

@end