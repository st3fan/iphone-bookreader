// OCFContainer.h

#import <Foundation/Foundation.h>
#import "OCFRootFile.h"

@interface OCFContainer : NSObject {
	NSMutableArray* rootFiles_;
}

@property (nonatomic,retain) NSMutableArray* rootFiles;

- (void) addRootFile: (OCFRootFile*) rootFile;

@end