/*
 * (C) Copyright 2008, Stefan Arentz, Arentz Consulting.
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

#import "XMLDigesterObjectCreateRule.h"
#import "XMLDigester.h"

@implementation XMLDigesterObjectCreateRule

- (id) initWithDigester: (XMLDigester*) digester class: (Class) class
{
   if ((self = [super initWithDigester: digester]) != nil) {
      class_ = class;
   }
   return self;
}

+ (id) objectCreateRuleWithDigester: (XMLDigester*) digester class: (Class) class
{
   return [[[self alloc] initWithDigester: digester class: class] autorelease];
}

- (void) didStartElement: (NSString*) elementName attributes: (NSDictionary*) attributeDict
{
   [[self digester] pushObject: [[class_ new] autorelease]];
}

- (void) didEndElement: (NSString*) elementName
{
   /* id object = */ [[self digester] popObject];
}

@end

