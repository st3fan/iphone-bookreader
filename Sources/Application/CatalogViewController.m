//  CatalogViewController.m

#import "CatalogViewController.h"
#import "Catalog.h"
#import "CatalogEntry.h"
#import "BookDetailViewController.h"

@implementation CatalogViewController

#pragma mark -

- (void) reload
{
	[[Catalog sharedCatalog] reload];
}

- (void) catalogReloaded: (NSNotification*) notification
{
	[self.tableView reloadData];
}

#pragma mark UIViewController Methods

- (void) viewDidLoad
{
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(catalogReloaded:) name: @"CatalogReloaded" object: nil];

	UIBarButtonItem* reloadButtonItem = [[[UIBarButtonItem alloc]
		initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(reload)] autorelease];
	self.navigationItem.leftBarButtonItem = reloadButtonItem;	

	if ([[Catalog sharedCatalog] loaded] == NO) {
		[[Catalog sharedCatalog] reload];
	}
}

- (void) viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Catalog sharedCatalog] entries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	CatalogEntry* entry = [[[Catalog sharedCatalog] entries] objectAtIndex: indexPath.row];
	cell.textLabel.text = entry.title;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CatalogEntry* catalogEntry = [[[Catalog sharedCatalog] entries] objectAtIndex: indexPath.row];
	if (catalogEntry != nil)
	{
		BookDetailViewController* vc = [[BookDetailViewController alloc] initWithNibName: @"BookDetailViewController" bundle: nil];
		if (vc != nil) {
			vc.catalogEntry = catalogEntry;
			[self.navigationController pushViewController: vc animated: YES];
			[vc release];
		}
	}
}

- (void)dealloc {
    [super dealloc];
}

@end