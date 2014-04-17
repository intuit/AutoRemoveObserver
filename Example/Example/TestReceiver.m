//
//  TestReceiver.m
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

#import "TestReceiver.h"
#import "INTUAutoRemoveObserver.h"

@implementation TestReceiver

-(void)observeMe
{
	NSLog(@"Hello from TestReceiver");
}

-(void)addBlockObserver
{
	NSLog(@"TestReceiver addBlockObserver");
	
	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
	__typeof(self) __weak weakSelf = self;
	
	[INTUAutoRemoveObserver addObserver:self
							   forName:@"Broadcast"
								object:nil
								 queue:mainQueue
							usingBlock:^(NSNotification * note) {
								NSLog(@"Hello from TestReceiver block");
								[weakSelf observeMe];
							}];
}

-(void)dealloc
{
	NSLog(@"TestReceiver dealloc");
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSLog(@"TestReceiver observing keyPath %@", keyPath);
}

@end
