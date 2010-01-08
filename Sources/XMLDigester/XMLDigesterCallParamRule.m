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

#import "XMLDigesterCallParamRule.h"
#import "XMLDigester.h"

@implementation XMLDigesterCallParamRule

- (id) initWithDigester: (XMLDigester*) digester parameterIndex: (NSUInteger) index
{
   if ((self = [super initWithDigester: digester]) != nil) {
      index_ = index;
   }
   return self;
}

+ (id) callParamRuleWithDigester: (XMLDigester*) digester parameterIndex: (NSUInteger) index
{
   return [[[self alloc] initWithDigester: digester parameterIndex: index] autorelease];
}

- (void) didStartElement: (NSString*) elementName attributes: (NSDictionary*) attributeDict
{
}

- (void) didEndElement: (NSString*) elementName
{
}

- (void) didBody: (NSString*) body
{
   // The top object should be a mutable array big enough to hold at least index_+1 items
   id object = [[self digester] peekObjectAtIndex: 0];
   if ([object isKindOfClass: [NSMutableArray class]]) {
      NSMutableArray* array = object;
      if ([array count] >= (index_ +1)) {
         [array replaceObjectAtIndex: index_ withObject: [NSString stringWithString: body]];
      } else {
         [[NSException exceptionWithName: @"XMLDigesterInvalidStateException"
            reason: @"The top object contains an array for parameters but it is not big enough." userInfo: nil] raise];
      }
   } else {
      [[NSException exceptionWithName: @"XMLDigesterInvalidStateException"
         reason: @"The top object is not a mutable array to hold parameters." userInfo: nil] raise];
   }
}

@end
