/*
 * (C) Copyright 2010, Stefan Arentz, Arentz Consulting.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "BookReaderAppDelegate.h"
#import "Catalog.h"
#import "Shelf.h"

@implementation BookReaderAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void) applicationDidFinishLaunching: (UIApplication*) application
{
    [window addSubview:tabBarController.view];
	
	[[UIApplication sharedApplication] setStatusBarHidden: YES];
	
	[[DownloadManager sharedDownloadManager] addDelegate: self];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

#pragma mark -

- (void) updateDownloadsBadge
{
	NSUInteger downloadCount = [[[DownloadManager sharedDownloadManager] downloads] count];

	// Find the Downloads item
	
	for (UITabBarItem* item in tabBarController.tabBar.items) {
		if (item.tag == 3) {
			if (downloadCount > 0) {
				item.badgeValue = [NSString stringWithFormat: @"%d", downloadCount];
			} else {
				item.badgeValue = nil;
			}
		}
	}
}

- (void) downloadManager: (DownloadManager*) downloadManager didQueueDownload: (Download*) download
{
	[self updateDownloadsBadge];
}

- (void) downloadManager: (DownloadManager*) downloadManager didCancelDownload: (Download*) download
{
	[self updateDownloadsBadge];
}

- (void) downloadManager: (DownloadManager*) downloadManager didFinishDownload: (Download*) download withData: (NSData*) data
{
	[self updateDownloadsBadge];
	
	CatalogEntry* catalogEntry = [[Catalog sharedCatalog] entryWithTitle: download.title];
	if (catalogEntry != nil) {	
		[[Shelf sharedShelf] createBookFromCatalogEntry: catalogEntry data: data];
	}
}

@end