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

#import <Foundation/Foundation.h>
#import "DownloadOperation.h"

@class DownloadManager, Download;

@protocol DownloadManagerDelegate <NSObject>
@optional
- (void) downloadManager: (DownloadManager*) downloadManager didQueueDownload: (Download*) download;
- (void) downloadManager: (DownloadManager*) downloadManager didCancelDownload: (Download*) download;
- (void) downloadManager: (DownloadManager*) downloadManager didFinishDownload: (Download*) download withData: (NSData*) data;
- (void) downloadManager: (DownloadManager*) downloadManager didUpdateDownload: (Download*) download;
@end

@interface DownloadManager : NSObject <DownloadOperationDelegate> {
  @private
	NSMutableArray* downloads_;
	NSMutableArray* delegates_;
	NSOperationQueue* operationQueue_;
}

+ (id) sharedDownloadManager;

@property (nonatomic,readonly) NSArray* downloads;

- (void) addDelegate: (id<DownloadManagerDelegate>) delegate;
- (void) removeDelegate: (id<DownloadManagerDelegate>) delegate;

- (void) queueDownload: (Download*) download;
- (void) stopDownload: (Download*) download;

@end