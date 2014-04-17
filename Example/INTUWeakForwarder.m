//
//  INTUWeakForwarder.m
//
//  Created by Jeff Shulman and Dan Rowley on 3/14/14.
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

#import "INTUWeakForwarder.h"
#import <objc/runtime.h>

@interface INTUWeakForwarder ()

/// Save the "real" delegates Class to return the proper signature for it when the reference is nil.
@property (nonatomic, strong) Class realDelegateClass;

/// Contains the weak reference to the delegate which is what will nil out when the delegate is dealloc'ed
@property (nonatomic, weak) id	realDelegate;

@end

@implementation INTUWeakForwarder

+(id)forwardTo:(id)theRealDelegate associatedWith:(id)object
{
	NSAssert(theRealDelegate, @"Trying to forward to a nil object");
	NSAssert(object, @"Trying associate forwarder to a nil object");
	
	// Create the NSProxy subclass to do the forwarding
	INTUWeakForwarder* forwarder = [INTUWeakForwarder alloc];
	forwarder.realDelegate = theRealDelegate;
	forwarder.realDelegateClass = [theRealDelegate class];
	
	// We need to keep this proxy object around for the lifetime of the associated object.
	// To do this we associate the proxy with the object using the address of the created proxy
	// object as the unique key here. When object goes away so will the forwarder.
	objc_setAssociatedObject(object, (__bridge const void *)(forwarder), forwarder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	return forwarder;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	// If we still have the real delegate around then forward it on, otherwise drop it.
	if ( self.realDelegate ) {
		[anInvocation setTarget:self.realDelegate];
		[anInvocation invoke];
	}
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)sel
{
	if ( self.realDelegate ) {
		// We still have the delegate so have it return the selector signature
		return [self.realDelegate methodSignatureForSelector:sel];
	}
	else {
		// Delegate has been dealloc'ed. Return the signature using the class so we don't throw an exception
		return [self.realDelegateClass instanceMethodSignatureForSelector:sel];
	}
}

@end
