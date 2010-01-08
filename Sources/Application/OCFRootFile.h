// OCFRootFile.h

#import <Foundation/Foundation.h>

@interface OCFRootFile : NSObject {
	NSString* fullPath_;
	NSString* mediaType_;
}

@property (nonatomic,retain) NSString* fullPath;
@property (nonatomic,retain) NSString* mediaType;

@end