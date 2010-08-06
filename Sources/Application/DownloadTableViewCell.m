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

#import "DownloadTableViewCell.h"
#import "DownloadManager.h"

@implementation DownloadTableViewCell

@synthesize download = download_;
@synthesize nameLabel = nameLabel_;
@synthesize progressView = progressView_;

- (id) initWithCoder: (NSCoder*) coder
{
    if ((self = [super initWithCoder: coder]) != nil) {
        // Initialization code
    }
    return self;
}

- (void) dealloc
{
	[download_ release];
    [super dealloc];
}

#pragma mark -

- (void) setDownload: (Download*) download
{
	if (download_ != download) {
		[download_ release];
		download_ = [download retain];
	}
	
	progressView_.progress = download_.progress;
	nameLabel_.text = download_.title;
}

#pragma mark -

- (void) prepareForReuse
{
	[super prepareForReuse];
	
	[download_ release];
	download_ = nil;

	progressView_.progress = 0.0;
	nameLabel_.text = @"";
}

#pragma mark -

- (IBAction) cancelDownload
{
	[[DownloadManager sharedDownloadManager] stopDownload: download_];
}

@end