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

#import "JSON.h"
#import "CatalogEntry.h"
#import "Catalog.h"

#pragma mark -

static NSInteger SortCatalogEntriesByTitle(CatalogEntry* a, CatalogEntry* b, void* context)
{
	return [a.title compare: b.title];
}

@implementation Catalog

#pragma mark -

@synthesize entries = entries_;
@synthesize loaded = loaded_;

#pragma mark -

static Catalog* sSharedCatalog = nil;

+ (id) sharedCatalog
{
	@synchronized (self) {
		if (sSharedCatalog == nil) {
			sSharedCatalog = [Catalog new];
		}
	}
	return sSharedCatalog;
}

#pragma mark -

- (id) init
{
	if ((self = [super init]) != nil) {
		entries_ = [NSMutableArray new];
		json_ = [NSMutableData new];
	}
	return self;
}

- (void) dealloc
{
	[connection_ release];
	[entries_ release];
	[json_ release];
	[super dealloc];
}

#pragma mark -

- (void) reload
{
	if (connection_ == nil)
	{
		NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://stefan.arentz.ca/stuff/books.json"]
			cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 30.0];
		connection_ = [[NSURLConnection connectionWithRequest: request delegate: self] retain];
	}
}

- (NSArray*) searchWithQuery: (NSString*) query
{
	return [NSArray array];
}

- (CatalogEntry*) entryWithTitle: (NSString*) title
{
	for (CatalogEntry* entry in entries_) {
		if ([entry.title isEqualToString: title] == YES) {
			return entry;
		}
	}
	return nil;
}

#pragma mark -

- (void) connection: (NSURLConnection*) connection didFailWithError: (NSError*) error
{
	[connection_ release];
	connection_ = nil;
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection
{
	// Parse the JSON and store it into the Catalog
	
	NSString* json = [[[NSString alloc] initWithData: json_ encoding: NSUTF8StringEncoding] autorelease];
	NSArray* entries = [json JSONValue];

	[entries_ removeAllObjects];

	for (NSDictionary* dictionary in entries)
	{
		CatalogEntry* entry = [[CatalogEntry new] autorelease];
		if (entry != nil)
		{
			entry.title = [dictionary objectForKey: @"title"];
			entry.author = [dictionary objectForKey: @"author"];
			entry.url = [NSURL URLWithString: [dictionary objectForKey: @"url"]];
			
			[entries_ addObject: entry];
		}
	}
	
	// Sort the books by title
	
	[entries_ sortUsingFunction: SortCatalogEntriesByTitle context: nil];
	
	// Let others know that the catalog reloaded
	
	loaded_ = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"CatalogReloaded" object: nil];
	
	// Release everything

	[connection_ release];
	connection_ = nil;
}

- (void) connection: (NSURLConnection*) connection didReceiveResponse: (NSURLResponse*) response
{
	[json_ setLength: 0];
}

- (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
{
    [json_ appendData: data];
}

@end