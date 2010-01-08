// Shelf.m

#import "Shelf.h"
#import "ZipArchive.h"

#import "XMLDigester.h"
#import "XMLDigesterObjectCreateRule.h"
#import "XMLDigesterSetNextRule.h"
#import "XMLDigesterCallMethodWithAttributeRule.h"
#import "OCFContainer.h"
#import "OCFRootFile.h"
#import "NCXNavigationDefinition.h"
#import "NCXNavigationPoint.h"

static Shelf* sSharedShelf = nil;

@interface Shelf (Private)
- (void) readBooksDatabase;
- (void) writeBooksDatabase;
@end


@implementation Shelf

@synthesize books = books_;
@synthesize delegate = delegate_;

+ (id) sharedShelf
{
	@synchronized (self) {
		if (sSharedShelf == nil) {
			sSharedShelf = [self new];
		}
	}
	return sSharedShelf;
}

- (id) init
{
	if ((self = [super init]) != nil) {
		books_ = [NSMutableArray new];
		[self readBooksDatabase];
	}
	return self;
}

- (void) dealloc
{
	[books_ release];
	[super dealloc];
}

- (Book*) createBookFromCatalogEntry: (CatalogEntry*) catalogEntry data: (NSData*) data
{
	// Store the EPUB data to disk

	NSString* identifier = [NSString stringWithFormat: @"%d-%d", time(NULL), random()]; // For the sake of this demo we use some random number. Better would be a UUID.
	NSString* filePath = [NSString stringWithFormat: @"%@/%@.epub", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], identifier];
	[data writeToFile: filePath atomically: YES];
	
	// Create a directory and then unzip it

	NSString* directoryPath = [NSString stringWithFormat: @"%@/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], identifier];
	[[NSFileManager defaultManager] createDirectoryAtPath: @"" attributes: nil];
	
	ZipArchive* za = [ZipArchive new];
	[za UnzipOpenFile: filePath];
	[za UnzipFileTo: directoryPath overWrite: YES];
	[za release];
	
	// Add the book to the shelf and then archive it

	Book* book = [[Book new] autorelease];
	book.title = catalogEntry.title;
	book.author = catalogEntry.author;
	book.fileName = identifier;
	
	[books_ addObject: book];
	
	[self writeBooksDatabase];

	if (delegate_ != nil) {
		[delegate_ shelfDidChange: self];
	}
	
	return book;
}

- (void) removeBookAtIndex: (NSUInteger) index
{
	Book* book = [books_ objectAtIndex: index];
	if (book != nil)
	{
		NSString* path = [NSString stringWithFormat: @"%@/%@.epub", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
		[[NSFileManager defaultManager] removeItemAtPath: path error: NULL];
		
		[books_ removeObjectAtIndex: index];
		[self writeBooksDatabase];
		
		if (delegate_ != nil) {
			[delegate_ shelfDidChange: self];
		}
	}
}

- (NCXNavigationDefinition*) parseNavigationDefinitionWithBook: (Book*) book
{
//	// Parse the container
//
//	NSString* containerPath = [NSString stringWithFormat: @"%@/%@/META-INF/container.xml", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
//	NSData* containerData = [NSData dataWithContentsOfFile: containerPath];
//	
//	XMLDigester* digester = [XMLDigester digesterWithData: containerData];
//	
//	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [OCFContainer class]] forPattern: @"container"];
//	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [OCFRootFile class]] forPattern: @"container/rootfiles/rootfile"];
//	[digester addRule: [XMLDigesterSetNextRule setNextRuleWithDigester: digester selector: @selector(addRootFile:)] forPattern: @"container/rootfiles/rootfile"];
//	
//	OCFContainer* container = [digester digest];
//	
//	// Dump the container
//	
//	NSLog(@"Container = %@", container);
//	for (OCFRootFile* rootFile in container.rootFiles) {
//		NSLog(@" RootFile = %@", rootFile);
//	}
	
	// Parse the navigation definition

	// TODO: We should really take the location of the toc from the OEPBSPackage - For a demo this works
	NSString* ncxPath = [NSString stringWithFormat: @"%@/%@/OPS/toc.ncx", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book.fileName];
	NSData* ncxData = [NSData dataWithContentsOfFile: ncxPath];
	
	XMLDigester* digester = [XMLDigester digesterWithData: ncxData];
	
	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationDefinition class]] forPattern: @"ncx"];
	[digester addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: digester class: [NCXNavigationPoint class]] forPattern: @"ncx/navMap/navPoint"];
	[digester addCallMethodWithElementBodyRuleWithSelector: @selector(setLabel:) forPattern: @"ncx/navMap/navPoint/navLabel/text"];
	[digester addRule: [XMLDigesterCallMethodWithAttributeRule callMethodWithAttributeRuleWithDigester: digester selector: @selector(setContent:) attribute: @"src"] forPattern: @"ncx/navMap/navPoint/content"];
	[digester addRule: [XMLDigesterSetNextRule setNextRuleWithDigester: digester selector: @selector(addNavigationPoint:)] forPattern: @"ncx/navMap/navPoint"];
	
	NCXNavigationDefinition* navigationDefinition = [digester digest];
		
	return navigationDefinition;
}

@end

@implementation Shelf (Private)

- (NSString*) booksDatabasePath
{
	return [NSString stringWithFormat: @"%@/Books.archive", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0]];
}

- (void) readBooksDatabase
{
	[books_ setArray: [NSKeyedUnarchiver unarchiveObjectWithFile: [self booksDatabasePath]]];
}

- (void) writeBooksDatabase
{
	[NSKeyedArchiver archiveRootObject: books_ toFile: [self booksDatabasePath]];
}

@end