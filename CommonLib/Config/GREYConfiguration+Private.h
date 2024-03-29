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

#import "CommonLib/Config/GREYConfiguration.h"

@interface GREYConfiguration ()
// Access the merged configuration.
@property(readonly, nonatomic) NSMutableDictionary *mergedConfiguration;
// Indicates whether the merged configuration was invalidated due to a change
// in the default or overridden configurations
@property(nonatomic) BOOL needsMerge;

/**
 *  Validates the given @c configKey.
 *
 *  @param configKey The config key to be validated.
 *
 *  @throws NSException If its not a valid key.
 */
- (void)grey_validateConfigKey:(NSString *)configKey;
@end

/** Implemented in the subclass to instantiate the underlying configuration. */
GREY_EXTERN GREYConfiguration *GREYCreateConfiguration(void);
