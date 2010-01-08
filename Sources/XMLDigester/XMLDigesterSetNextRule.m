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

#import "XMLDigesterSetNextRule.h"
#import "XMLDigester.h"

@implementation XMLDigesterSetNextRule

- (id) initWithDigester: (XMLDigester*) digester selector: (SEL) selector
{
   if ((self = [super initWithDigester: digester]) != nil) {
      selector_ = selector;
   }
   return self;
}

+ (id) setNextRuleWithDigester: (XMLDigester*) digester selector: (SEL) selector
{
   return [[[self alloc] initWithDigester: digester selector: selector] autorelease];
}

- (void) didEndElement: (NSString*) element
{
   id child = [[self digester] peekObjectAtIndex: 0];
   id parent = [[self digester] peekObjectAtIndex: 1];

   if (child != nil && parent != nil) {
      [parent performSelector: selector_ withObject: child];
   }
}

@end
