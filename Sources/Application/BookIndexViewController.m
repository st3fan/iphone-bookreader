//  BookIndexViewController.m

#import "BookIndexViewController.h"
#import "Shelf.h"
#import "BookContentViewController.h"

@implementation BookIndexViewController

- (id) initWithBook: (Book*) book
{
    if ((self = [super initWithStyle: UITableViewStylePlain]) != nil) {
		book_ = [book retain];
		navigationDefinition_ = [[Shelf sharedShelf] parseNavigationDefinitionWithBook: book_];
    }
    return self;
}

- (void) dealloc
{
	[book_ release];
	[super dealloc];
}

#pragma mark -

- (void) close
{
	[self dismissModalViewControllerAnimated: YES];
}

- (void) viewDidLoad
{
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.title = book_.title;
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self action: @selector(close)] autorelease];
	
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [navigationDefinition_.navigationPoints count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookIndexViewControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	NCXNavigationPoint* navigationPoint = [navigationDefinition_.navigationPoints objectAtIndex: indexPath.row];
	cell.textLabel.text = navigationPoint.label;
	
    return cell;
}

- (void)tableView: (UITableView*) tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
	NCXNavigationPoint* navigationPoint = [navigationDefinition_.navigationPoints objectAtIndex: indexPath.row];

	BookContentViewController* bookContentViewController = [[BookContentViewController alloc] initWithBook: book_ navigationPoint: navigationPoint];
	if (bookContentViewController != nil) {
		[self.navigationController pushViewController: bookContentViewController animated: YES];
		[bookContentViewController release];
	}
}

@end