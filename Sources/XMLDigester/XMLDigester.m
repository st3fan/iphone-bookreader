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

#import <Foundation/Foundation.h>

#import "XMLDigester.h"
#import "XMLDigesterObjectCreateRule.h"
#import "XMLDigesterCallMethodWithElementBodyRule.h"
#import "XMLDigesterCallMethodRule.h"
#import "XMLDigesterCallParamRule.h"

@implementation XMLDigester

- (id) initWithData: (NSData*) data
{
   if ((self = [super init]) != nil)
   {
      parser_ = [[NSXMLParser alloc] initWithData: data];
	  [parser_ setDelegate: self];
	  
      rulesByPath_ = [[NSMutableDictionary dictionary] retain];
      stack_ = [[NSMutableArray array] retain];
      path_ = [[NSMutableArray array] retain];
      body_ = [[NSMutableString string] retain];
   }
   return self;
}

+ (id) digesterWithData: (NSData*) data
{
	return [[[self alloc] initWithData: data] autorelease];
}

- (void) dealloc
{
   [path_ release];
   [stack_ release];
   [rulesByPath_ release];
   [object_ release];
   [parser_ release];
   [super dealloc];
}

- (NSArray*) stack
{
   return stack_;
}

- (void) pushObject: (id) object
{
   if (object_ == nil) {
      object_ = [object retain];
   }
   [stack_ addObject: object];
}

- (id) popObject
{
   id object = nil;
   if ([stack_ count] > 0) {
      object = [stack_ lastObject];
      [stack_ removeLastObject];
   }
   return object;
}

- (id) peekObject
{
   id object = nil;
   if ([stack_ count] > 0) {
      object = [stack_ lastObject];
   }
   return object;
}

- (id) peekObjectAtIndex: (NSUInteger) index
{
   id object = nil;
   if ([stack_ count] > 0) { // TODO Do a better check
      object = [stack_ objectAtIndex: [stack_ count] - 1 - index];
   }
   return object;
}

- (void) addRule: (XMLDigesterRule*) rule forPattern: (NSString*) pattern;
{
   NSArray* path = [pattern componentsSeparatedByString: @"/"];
   
   NSMutableArray* rules = [rulesByPath_ objectForKey: path];
   if (rules == nil) {
      rules = [NSMutableArray array];
      [rulesByPath_ setObject: rules forKey: path];
   }
   
   [rules addObject: rule];
}

- (id) digest
{
	[parser_ parse];
	return object_;
}

#pragma mark -

- (void) parser: (NSXMLParser*) parser didStartElement: (NSString*) element namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qualifiedName attributes: (NSDictionary*) attributes
{
   [path_ addObject: element];

   // Reset the body when a new element starts
   [body_ setString: @""];

   NSArray* rules = [rulesByPath_ objectForKey: path_];
   if (rules != nil) {
      for (XMLDigesterRule* rule in rules) {
         [rule didStartElement: element attributes: attributes];
      }
   }
}

- (void) parser: (NSXMLParser*) parser didEndElement: (NSString*) element namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName
{
   NSArray* rules = [rulesByPath_ objectForKey: path_];
   if (rules != nil) {
      // If this is a 'quick close' of an element then run the registered Rules' didBody: methods
      if ([element isEqualToString: [path_ lastObject]]) {
         for (XMLDigesterRule* rule in rules) {
            [rule didBody: [NSString stringWithString: body_]];
         }
      }
      for (XMLDigesterRule* rule in [rules reverseObjectEnumerator]) {
         [rule didEndElement: element];
      }
   }

   [path_ removeLastObject];
}

- (void) parser: (NSXMLParser*) parser foundCharacters: (NSString*) characters
{
   [body_ appendString: characters];
}

#pragma mark -

- (void) addObjectCreateRuleWithClass: (id) class forPattern: (NSString*) pattern
{
   [self addRule: [XMLDigesterObjectCreateRule objectCreateRuleWithDigester: self class: class] forPattern: pattern];   
}

- (void) addCallMethodWithElementBodyRuleWithSelector: (SEL) selector forPattern: (NSString*) pattern
{
   [self addRule: [XMLDigesterCallMethodWithElementBodyRule callMethodWithElementBodyRuleWithDigester: self selector: selector] forPattern: pattern];
}

- (void) addCallMethodRuleWithSelector: (SEL) selector forPattern: (NSString*) pattern
{
   [self addRule: [XMLDigesterCallMethodRule callMethodRuleWithDigester: self selector: selector] forPattern: pattern];
}

- (void) addCallParamRuleWithParameterIndex: (NSUInteger) index forPattern: (NSString*) pattern
{
   [self addRule: [XMLDigesterCallParamRule callParamRuleWithDigester: self parameterIndex: index] forPattern: pattern];
}

@end
