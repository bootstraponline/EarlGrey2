//
// Copyright 2017 Google Inc.
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

#import "TestLib/Assertion/GREYAssertionDefines.h"
#import "TestLib/EarlGreyImpl/EarlGrey.h"
#import "GREYHostApplicationDistantObject+RemoteTest.h"

/**
 * Base class for adding any methods to be needed in the tests.
 */
@interface FTRBaseIntegrationTest : XCTestCase

/**
 *  The XCUIApplication being tested.
 */
@property(nonatomic) XCUIApplication *application;

/**
 *  Select the UITableViewCell with its text as specified by @c name from the app's main tableview.
 *
 *  @param name The text of the UITableViewCell being selected to open the test's view controller.
 */
- (void)openTestViewNamed:(NSString *)name;
@end
