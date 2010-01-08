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
#import "XMLDigesterRule.h"

/**
 * Rule implementation that calls a method on the (top-1) (parent)
 * object, passing the top object (child) as an argument. It is
 * commonly used to establish parent-child relationships.
 */

@class XMLDigester;

@interface XMLDigesterSetNextRule : XMLDigesterRule {
   @private
      SEL selector_;
}
- (id) initWithDigester: (XMLDigester*) digester selector: (SEL) selector;
+ (id) setNextRuleWithDigester: (XMLDigester*) digester selector: (SEL) selector;
@end
