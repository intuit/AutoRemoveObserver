//
//  ViewController.m
//  Example
//
//  Created by Jeff Shulman on 3/26/14.
//	Copyright (c) 2014 Intuit Inc
//
//	Permission is hereby granted, free of charge, to any person obtaining
//	a copy of this software and associated documentation files (the
//	"Software"), to deal in the Software without restriction, including
//	without limitation the rights to use, copy, modify, merge, publish,
//	distribute, sublicense, and/or sell copies of the Software, and to
//	permit persons to whom the Software is furnished to do so, subject to
//	the following conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "ViewController.h"
#import "INTUAutoRemoveObserver.h"
#import "TestReceiver.h"

@interface ViewController ()

@property (nonatomic, strong) TestReceiver* aTestReceiver;

@property (nonatomic, copy) NSString* testString;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.aTestReceiver = [TestReceiver new];
	
	[INTUAutoRemoveObserver addObserver:self.aTestReceiver selector:@selector(observeMe) name:@"Broadcast" object:nil];
}

- (IBAction)postNotification:(id)sender
{
	NSLog(@"Sending broadcast");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Broadcast" object:self];
	
	NSLog(@"Changing testString");
	self.testString = @"Foo";
}

- (IBAction)deleteReceiver:(id)sender
{
	NSLog(@"deleting aTestReceiver");
	self.aTestReceiver = nil;
}

- (IBAction)addBlockObserver:(id)sender
{
	NSLog(@"addBlockObserver");
	if (!self.aTestReceiver) {
		NSLog(@"Creating new TestReceiver");
		self.aTestReceiver = [TestReceiver new];
	}
	
	[self.aTestReceiver addBlockObserver];
}

- (IBAction)addKVOObserver:(id)sender
{
	NSLog(@"addKVOObserver");
	if (!self.aTestReceiver) {
		NSLog(@"Creating new TestReceiver");
		self.aTestReceiver = [TestReceiver new];
	}
	
	[INTUAutoRemoveObserver addObserver:self.aTestReceiver
							forKeyPath:NSStringFromSelector(@selector(testString))
							   options:NSKeyValueObservingOptionNew
							   context:nil
					  onReceiverObject:self];
}

- (IBAction)addSelfKVO:(id)sender
{
	NSLog(@"addSelfKVO");
	if (!self.aTestReceiver) {
		NSLog(@"Creating new TestReceiver");
		self.aTestReceiver = [TestReceiver new];
	}
	
	[self.aTestReceiver addKVOObserver];
}

- (IBAction)changeKVO:(id)sender
{
	NSLog(@"changeKVO");
	self.aTestReceiver.myString = @"Baz";
}


@end
