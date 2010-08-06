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

#import "DownloadOperation.h"

@implementation DownloadOperation

@synthesize download = download_;
@synthesize data = data_;

- (id) initWithDownload: (Download*) download delegate: (id<DownloadOperationDelegate>) delegate;
{
	if ((self = [super init]) != nil) {
		data_ = [NSMutableData new];
		download_ = [download retain];
		delegate_ = delegate;
	}
	return self;
}

- (void) dealloc
{
	[connection_ release];
	[data_ release];
	[download_ release];
	[super dealloc];
}

#pragma mark -

- (void) start
{
	if (![self isCancelled])
	{
		connection_ = [[NSURLConnection connectionWithRequest: [NSURLRequest requestWithURL: download_.url] delegate: self] retain];
		if (connection_ != nil) {
			[self willChangeValueForKey:@"isExecuting"];
			executing_ = YES;
			[self didChangeValueForKey:@"isExecuting"];
		} else {
			[self willChangeValueForKey:@"isExecuting"];
			finished_ = YES;
			[self didChangeValueForKey:@"isExecuting"];
		}
	}
	else
	{
		// If it's already been cancelled, mark the operation as finished.
		[self willChangeValueForKey:@"isFinished"];
		{
			finished_ = YES;
		}
		[self didChangeValueForKey:@"isFinished"];
	}
}

- (BOOL) isConcurrent
{
	return YES;
}

- (BOOL) isExecuting
{
	return executing_;
}

- (BOOL) isFinished
{
  return finished_;
}

#pragma mark NSURLConnection Delegate Methods

- (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
{
	[data_ appendData: data]; // TODO Download to disk instead
	download_.progress = ((float) [data_ length] / (float) download_.size);
	[delegate_ downloadOperationDidMakeProgress: self];
}

- (void)connection: (NSURLConnection*) connection didReceiveResponse: (NSHTTPURLResponse*) response
{
	statusCode_ = [response statusCode];
	if (statusCode_ == 200) {
		download_.size = [response expectedContentLength];
	}
}

- (void) connection: (NSURLConnection*) connection didFailWithError: (NSError*) error
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
	{
		finished_ = YES;
		executing_ = NO;
	}
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];	

	[delegate_ downloadOperationDidFail: self];
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
	{
		finished_ = YES;
		executing_ = NO;
	}
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];	

//	download_.progress = 1.0;
//	[delegate_ downloadOperationDidMakeProgress: self];
	
	if (statusCode_ == 200) {
		[delegate_ downloadOperationDidFinish: self];
	} else {
		[delegate_ downloadOperationDidFail: self];
	}
}

@end