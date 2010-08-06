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

#import "BookContentViewController.h"

@implementation BookContentViewController

@synthesize webView = webView_;

- (id) initWithBook: (Book*) book navigationPoint: (NCXNavigationPoint*) navigationPoint
{
	if ((self = [super initWithNibName: @"BookContentViewController" bundle: nil]) != nil) {
		book_ = [book retain];
		navigationPoint_ = [navigationPoint retain];
	}
	return self;
}

- (void) viewDidLoad
{
	// Load the content into the view
	NSString* path = [NSString stringWithFormat: @"%@/%@/OPS/%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0], book_.fileName, navigationPoint_.content];
	[webView_ loadRequest: [NSURLRequest requestWithURL: [NSURL fileURLWithPath: path]]];
}

- (void) dealloc
{
	[book_ release];
	[navigationPoint_ release];
	[super dealloc];
}

@end
