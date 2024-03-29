//
// Copyright 2018 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TestLib/XCTestCase/XCUIApplication+GREYEnvironment.h"

@implementation XCUIApplication (GREYEnvironment)

- (void)grey_configureApplicationForLaunch {
  NSMutableDictionary *mutableEnv = [self.launchEnvironment mutableCopy];
  NSString *insertionKey = @"DYLD_INSERT_LIBRARIES";
  NSString *insertionValue = @"@executable_path/Frameworks/AppFramework.framework/AppFramework";
  NSString *alreadyExistingValue = [mutableEnv valueForKey:insertionKey];
  if (alreadyExistingValue) {
    insertionValue = [NSString stringWithFormat:@"%@,%@", alreadyExistingValue, insertionValue];
  }
  [mutableEnv setObject:insertionValue forKey:insertionKey];
  self.launchEnvironment = [mutableEnv copy];
}

@end
