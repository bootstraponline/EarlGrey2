//
// Copyright 2016 Google Inc.
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

#import "NetworkTestViewController.h"
#import "NetworkProxy.h"

/**
 *  Data used as response for proxied requests.
 */
static NSString *const kTestProxyData = @"kTestProxyData";

/**
 *  Regex matching all YouTube urls.
 */
static NSString *const kProxyRegex = @"^http://www.youtube.com";

@interface NetworkTestViewController () <NSURLSessionDataDelegate>
@property(weak, nonatomic) IBOutlet UILabel *retryIndicator;
@property(weak, nonatomic) IBOutlet UILabel *responseVerifiedLabel;
@property(weak, nonatomic) IBOutlet UILabel *requestCompletedLabel;
@end

@implementation NetworkTestViewController

- (void)viewWillAppear:(BOOL)animated {
  [NetworkProxy setProxyEnabled:YES];
  [NetworkProxy addProxyRuleForUrlsMatchingRegexString:kProxyRegex responseString:kTestProxyData];
  [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [NetworkProxy removeMostRecentProxyRuleMatchingUrlRegexString:kProxyRegex];
  [NetworkProxy setProxyEnabled:NO];
}

/**
 *  Verifies the received @c data by matching it with what is expected via proxy, in case of match
 *  UI is updated by setting @c responseVerifiedLabel to be visible.
 *
 *  @param data The data that was received.
 */
- (void)verifyReceivedData:(NSData *)data {
  // Note: although functionally similar, [NSString stringWithUTF8String:] has been flaky
  // here returning nil for the NSData being passed in from the proxy, using initWithData:encoding:
  // instead.
  NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  if ([kTestProxyData isEqualToString:dataStr]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.responseVerifiedLabel.hidden = NO;
    });
  }
}

- (IBAction)userDidTapNSURLSessionDelegateTest:(id)sender {
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  config.protocolClasses =
      [@ [[NetworkProxy class]] arrayByAddingObjectsFromArray:config.protocolClasses];
  NSURLSession *session =
      [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
  NSURLSessionTask *task =
      [session dataTaskWithURL:[NSURL URLWithString:@"http://www.youtube.com/"]];
  // Begin the fetch.
  [task resume];
}

- (IBAction)userDidTapNSURLSessionNoCallbackTest:(id)sender {
  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  config.protocolClasses =
      [@ [[NetworkProxy class]] arrayByAddingObjectsFromArray:config.protocolClasses];
  NSURLSession *session =
      [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
  NSURLSessionTask *task =
      [session dataTaskWithURL:[NSURL URLWithString:@"http://www.youtube.com/"]];
  // Begin the fetch.
  [task resume];
}

- (IBAction)userDidTapNSURLSessionTest:(id)sender {
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *task =
      [session dataTaskWithURL:[NSURL URLWithString:@"http://www.youtube.com/"]
             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               [NSThread sleepForTimeInterval:1.0];
               [self verifyReceivedData:data];
               dispatch_async(dispatch_get_main_queue(), ^{
                 self->_requestCompletedLabel.hidden = NO;
               });
             }];
  // Begin the fetch.
  [task resume];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
  // Simulate some processing time to reliably test network synchronization. Without this network
  // synchronization tests will be flaky.
  [NSThread sleepForTimeInterval:1.0];
  dispatch_async(dispatch_get_main_queue(), ^{
    self->_requestCompletedLabel.hidden = NO;
  });
  [self verifyReceivedData:data];
}

@end
