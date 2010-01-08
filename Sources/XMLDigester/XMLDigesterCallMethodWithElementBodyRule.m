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

#import "XMLDigesterCallMethodWithElementBodyRule.h"
#import "XMLDigester.h"

@implementation XMLDigesterCallMethodWithElementBodyRule

- (id) initWithDigester: (XMLDigester*) digester selector: (SEL) selector
{
   if ((self = [super initWithDigester: digester]) != nil) {
      selector_ = selector;
   }
   return self;
}

+ (id) callMethodWithElementBodyRuleWithDigester: (XMLDigester*) digester selector: (SEL) selector
{
   return [[[self alloc] initWithDigester: digester selector: selector] autorelease];
}

- (void) didBody: (NSString*) body
{
   [[[self digester] peekObjectAtIndex: 0] performSelector: selector_ withObject: body];
}

@end
