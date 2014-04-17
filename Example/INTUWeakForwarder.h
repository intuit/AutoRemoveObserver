//
//  INTUWeakForwarder.h
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
//
//	"weak" references are great to use for delegate properties since they will automatically
//	get nil'ed out when the delegate object goes away. Alas it turns out Apple doesn't use
//	real weak references in its SDK but has all delegate properties as unsafe-unretained.
//
//	This means the app will crash should the programmer forget to nil out all the delegate
//	properties on dealloc and that delegate is called.
//
//	So what this little NSProxy class does is store the delegate as a *real* weak reference
//	and forwards all method invocations to it as long as it exists. When the delegate is
//	dealloc'ed the real weak reference will be nil and nothing will be forwarded along.
//
//	The NSProxy instance is stored using an associated object on the delegatee so when that goes
//	away the proxy instance will too. So generally this should be the object you are setting
//  the delegate property of.
//
//	Instead of writing:
//
//		<someinstance>.delegate = self;
//
//	you write:
//
//		<someinstance>.delegate = [INTUWeakForwarder forwardTo:self associatedWith:<someinstance>];
//
//  E.g.:
//
//  UIScrollView *scrollView = ...;
//  scrollView.delegate = [INTUWeakForwarder forwardTo:self associatedWith:scrollView];

#import <Foundation/Foundation.h>

@interface INTUWeakForwarder : NSProxy

/// Factory for NSProxy forwarding object
///
/// @param theRealDelegate The delegate instance object
/// @param object The object to tie the lifetime of the proxy object to
/// @return The proxy object to assign as the delegate object

+(id)forwardTo:(id)theRealDelegate associatedWith:(id)object;

@end
