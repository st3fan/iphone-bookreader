// Catalog.h

#import <Foundation/Foundation.h>
#import "CatalogEntry.h"

@interface Catalog : NSObject {
  @private
	NSMutableArray* entries_;
	NSMutableData* json_;
	NSURLConnection* connection_;
	BOOL loaded_;
}

@property (nonatomic,readonly) NSArray* entries;
@property (nonatomic,readonly) BOOL loaded;

+ (id) sharedCatalog;

- (void) reload;
- (NSArray*) searchWithQuery: (NSString*) query;
- (CatalogEntry*) entryWithTitle: (NSString*) title;

@end