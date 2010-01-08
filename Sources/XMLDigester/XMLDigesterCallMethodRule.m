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

#import "XMLDigesterCallMethodRule.h"
#import "XMLDigester.h"

@implementation XMLDigesterCallMethodRule

- (id) initWithDigester: (XMLDigester*) digester selector: (SEL) selector
{
   if ((self = [super initWithDigester: digester]) != nil) {
      selector_ = selector;
   }
   return self;
}

+ (id) callMethodRuleWithDigester: (XMLDigester*) digester selector: (SEL) selector
{
   return [[[self alloc] initWithDigester: digester selector: selector] autorelease];
}

- (void) didStartElement: (NSString*) elementName attributes: (NSDictionary*) attributeDict
{
   NSMutableArray* array = [NSMutableArray array];
   for (int i = 0; i < 2; i++) {
      [array addObject: [NSNull null]];
   }
   [[self digester] pushObject: array];
}

- (void) didEndElement: (NSString*) elementName
{
   NSMutableArray* array = [[self digester] popObject];
   id object = [[self digester] peekObjectAtIndex: 0];

   NSMethodSignature* methodSignature = [object methodSignatureForSelector: selector_];
   if (methodSignature)
   {
      NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: methodSignature];
      [invocation setTarget: object];
      [invocation setSelector: selector_];

      NSInteger i = 2;
      for (id parameter in array) {
         [invocation setArgument: &parameter atIndex: i++];
      }
      
      [invocation invoke];
   }
}

- (void) didBody: (NSString*) body
{
}

@end
