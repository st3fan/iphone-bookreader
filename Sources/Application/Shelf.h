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
#import "CatalogEntry.h"
#import "Book.h"

@class Shelf;
@class NCXNavigationDefinition;

@protocol ShelfDelegate
- (void) shelfDidChange: (Shelf*) shelf;
@end

@interface Shelf : NSObject {
  @private
	NSMutableArray* books_;
	id<ShelfDelegate> delegate_;
}

+ (id) sharedShelf;

@property (nonatomic,readonly) NSArray* books;
@property (nonatomic,assign) id<ShelfDelegate> delegate;

- (Book*) createBookFromCatalogEntry: (CatalogEntry*) catalogEntry data: (NSData*) data;

- (void) removeBookAtIndex: (NSUInteger) index;

- (NCXNavigationDefinition*) parseNavigationDefinitionWithBook: (Book*) book;

@end