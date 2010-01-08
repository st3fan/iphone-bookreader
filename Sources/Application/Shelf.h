// Shelf.h

#import <Foundation/Foundation.h>
#import "CatalogEntry.h"
#import "Book.h"

@class Shelf;
@class NCXNavigationDefinition;

@protocol ShelfDelegate
- (void) shelfDidChange: (Shelf*) shelf;
@end

@interface Shelf : NSObject {
  @private
	NSMutableArray* books_;
	id<ShelfDelegate> delegate_;
}

+ (id) sharedShelf;

@property (nonatomic,readonly) NSArray* books;
@property (nonatomic,assign) id<ShelfDelegate> delegate;

- (Book*) createBookFromCatalogEntry: (CatalogEntry*) catalogEntry data: (NSData*) data;

- (void) removeBookAtIndex: (NSUInteger) index;

- (NCXNavigationDefinition*) parseNavigationDefinitionWithBook: (Book*) book;

@end