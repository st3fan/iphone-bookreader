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

#import "Download.h"

@implementation Download

@synthesize title = title_;
@synthesize url = url_;
@synthesize progress = progress_;
@synthesize size = size_;

#pragma mark -

+ downloadWithTitle: (NSString*) title url: (NSURL*) url
{
	return [[[self alloc] initWithTitle: title url: url] autorelease];
}

#pragma mark -

- (id) initWithTitle: (NSString*) title url: (NSURL*) url
{
	if ((self = [super init]) != nil) {
		title_ = [title copy];
		url_ = [url copy];
	}
	return self;
}

- (void) dealloc
{
	[title_ release];
	[url_ release];
	[super dealloc];
}

@end