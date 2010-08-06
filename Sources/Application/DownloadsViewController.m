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

#import "DownloadsViewController.h"
#import "DownloadTableViewCell.h"

@implementation DownloadsViewController

#pragma mark UIViewController

- (void) viewDidLoad
{
	[[DownloadManager sharedDownloadManager] addDelegate: self];
}

- (void) viewDidUnload
{
	[[DownloadManager sharedDownloadManager] removeDelegate: self];
}

#pragma mark UITableViewController Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DownloadManager sharedDownloadManager] downloads] count];
}

- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"DownloadTableViewCell"];
	if (cell == nil) {
		NSArray* objects = [[NSBundle mainBundle] loadNibNamed: @"DownloadTableViewCell" owner: nil options: nil];
		if (objects != nil) {
			cell = [objects objectAtIndex: 0];
		}
	}

	if (cell != nil) {
		Download* download = [[[DownloadManager sharedDownloadManager] downloads] objectAtIndex: indexPath.row];
		if (download != nil) {
			DownloadTableViewCell* downloadTableViewCell = (DownloadTableViewCell*) cell;
			downloadTableViewCell.download = download;
		}
	}
	
	return cell;
}

#pragma mark DownloadManager Notifications

- (void) downloadManager: (DownloadManager*) downloadManager didQueueDownload: (Download*) download
{
	[self.tableView reloadData];
}

- (void) downloadManager: (DownloadManager*) downloadManager didCancelDownload: (Download*) download
{
	[self.tableView reloadData];
}

- (void) downloadManager: (DownloadManager*) downloadManager didFinishDownload: (Download*) download withData: (NSData*) data
{
	[self.tableView reloadData];
}

- (void) downloadManager: (DownloadManager*) downloadManager didUpdateDownload: (Download*) download
{
	[self.tableView reloadData];
}

@end