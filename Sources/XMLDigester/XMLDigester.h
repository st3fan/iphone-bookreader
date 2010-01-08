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

@class XMLDigesterRule;

@interface XMLDigester : NSObject {
   @private
      NSXMLParser* parser_;
      NSMutableDictionary* rulesByPath_;
      NSMutableArray* stack_;
      NSMutableArray* path_;
      id object_;
      NSMutableString* body_;
}

- (id) initWithData: (NSData*) data;
+ (id) digesterWithData: (NSData*) data;

- (NSArray*) stack;

- (void) pushObject: (id) object;
- (id) popObject;
- (id) peekObject;
- (id) peekObjectAtIndex: (NSUInteger) index;

- (void) addRule: (XMLDigesterRule*) rule forPattern: (NSString*) pattern;

- (id) digest;

- (void) addObjectCreateRuleWithClass: (id) class forPattern: (NSString*) pattern;
- (void) addCallMethodWithElementBodyRuleWithSelector: (SEL) selector forPattern: (NSString*) pattern;
- (void) addCallMethodRuleWithSelector: (SEL) selector forPattern: (NSString*) pattern;
- (void) addCallParamRuleWithParameterIndex: (NSUInteger) index forPattern: (NSString*) pattern;

@end
