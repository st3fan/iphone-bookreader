// NCXNavigationPoint.h

#import <Foundation/Foundation.h>

@interface NCXNavigationPoint : NSObject {
	NSString* identifier_;
	NSString* playOrder_;
	NSString* label_;
	NSString* content_;
}

@property (nonatomic,retain) NSString* identifier;
@property (nonatomic,retain) NSString* playOrder;
@property (nonatomic,retain) NSString* label;
@property (nonatomic,retain) NSString* content;

@end