// ShelfViewController.m

#import "ShelfViewController.h"
#import "Book.h"
#import "Shelf.h"
#import "BookIndexViewController.h"

@implementation ShelfViewController

#pragma mark UIViewController Methods

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	[[Shelf sharedShelf] setDelegate: self];
}

- (void) viewDidUnload
{
	[[Shelf sharedShelf] setDelegate: nil];
	[super viewDidUnload];
}

#pragma mark UITableViewDataSource Methods

- (NSInteger) numberOfSectionsInTableView: (UITableView*) tableView
{
    return 1;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
    return [[[Shelf sharedShelf] books] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShelfViewController";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	Book* book = [[[Shelf sharedShelf] books] objectAtIndex: indexPath.row];
	cell.textLabel.text = book.title;
    				
    return cell;
}

- (void) tableView: (UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Book* book = [[[Shelf sharedShelf] books] objectAtIndex: indexPath.row];

	BookIndexViewController* bookIndexViewController = [[[BookIndexViewController alloc] initWithBook: book] autorelease];
	
	UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController: bookIndexViewController] autorelease];
	if (navigationController != nil) {
		[self presentModalViewController: navigationController animated: YES];
	}
}

- (void) tableView: (UITableView*) tableView commitEditingStyle: (UITableViewCellEditingStyle) editingStyle forRowAtIndexPath: (NSIndexPath*) indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[tableView beginUpdates];
		{
			[[Shelf sharedShelf] removeBookAtIndex: indexPath.row];
			[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation:YES];
		}
		[tableView endUpdates];
	}   
}

- (BOOL) tableView: (UITableView*) tableView canMoveRowAtIndexPath: (NSIndexPath*) indexPath
{
    return NO;
}

#pragma mark -

- (void) shelfDidChange: (Shelf*) shelf
{
	[self.tableView reloadData];
}

@end