AutoRemoveObserver
==================

The problem with NotificationCenter and KVO observers is that you have to remember to remove
the observing object when it gets dealloc'ed or your app will crash on the next notification.

The methods below create a small "remover" object that is associated with the observer object
such that when the observer object gets dealloc'ed this object will also get dealloc'ed *and*
remove the observations.

N.B.: This class is designed to remove the observer when the observer is dealloc'ed. If you
need to remove the observer before that then you should use the standard methods and be sure
to handle the dealloc case yourself.

Instead of writing:

		// Selector based
		[[NSNotificationCenter defaultCenter] addObserver:notificationObserver
												 selector:notificationSelector
													 name:notificationName
												   object:notificationSender];

		// Block based
		[[NSNotificationCenter defaultCenter] addObserverForName:name
														  object:obj
														   queue:queue
													  usingBlock:block];

		// KVO
		[self addObserver:anObserver forKeyPath:keyPath options:options context:context];

you write:

		// Selector based
		[INTUAutoRemoveObserver addObserver:notificationObserver
								   selector:notificationSelector
									   name:notificationName
									 object:notificationSender];

		// Block based
		[INTUAutoRemoveObserver addObserver:self
									forName:name
									 object:obj
									  queue:queue
								 usingBlock:block];

		// KVO
		[INTUAutoRemoveObserver addObserver:anObserver
								 forKeyPath:keyPath
									options:options
									context:context
						   onReceiverObject:self];

E.g.:

		// Selector based
		[INTUAutoRemoveObserver addObserver:self
								   selector:@selector(myMethod)
									   name:@"BroadcastNotification"
									 object:nil];

		// Block based
		MyObject* __weak weakSelf = self;		// So the block doesn't retain us
		[INTUAutoRemoveObserver addObserver:self
									forName:@"BroadcastNotification"
									 object:nil
									  queue:[NSOperationQueue mainQueue]
								 usingBlock:^(NSNotification *note) {
											 [weakSelf observeMe];
									 }];

		// KVO
		[INTUAutoRemoveObserver addObserver:self		// self or some observer object. When this is dealloc'ed then observer is removed.
								 forKeyPath:NSStringFromSelector(@selector(myProperty))
									options:NSKeyValueObservingOptionNew
									context:nil
						   onReceiverObject:self];

		N.B.: If the observer is self you will see an error in the log file about the instance being deallocated while key
		observers were still registered to it (even though they are removed as a side effect of self getting dealloc'ed)
		when self is dealloc'ed.
