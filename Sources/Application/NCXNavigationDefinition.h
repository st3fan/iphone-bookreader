// NCXNavigationDefinition.h

#import <Foundation/Foundation.h>
#import "NCXNavigationPoint.h"

@interface NCXNavigationDefinition : NSObject {
	NSMutableArray* navigationPoints_;
}

@property (nonatomic,retain) NSMutableArray* navigationPoints;

- (void) addNavigationPoint: (NCXNavigationPoint*) navigationPoint;

@end