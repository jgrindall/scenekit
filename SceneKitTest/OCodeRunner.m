//
//  OCodeRunner.m
//  SceneKitTest
//
//  Created by John on 20/02/2017.
//
//

#import "OCodeRunner.h"
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface OCodeRunner ()

@property JSContext* context;
@property BOOL enabled;
@end


@implementation OCodeRunner

dispatch_queue_t myQueue;

- (id) init{
	self = [super init];
	self.context = [[JSContext alloc] init];
	self.enabled = YES;
	myQueue = dispatch_queue_create("My Queue",NULL);
	
	@try {
		[self.context evaluateScript: @"function greet(name){ while(1){test('hi');} return 'Hello, ' + name; }"];
		void (^lockedConsumerBlock)(NSString*) = ^void(NSString* s) {
			NSLog(@" s = %@", s);
			NSLog(@" en = %i", self.enabled);
		};
		[self.context.globalObject setObject:lockedConsumerBlock forKeyedSubscript:@"test"];
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception.reason);
	}
	@finally {
		// clean up memory
	}
	return self;
}

- (void) runIt{
	@try {
		dispatch_async(myQueue, ^{
			JSValue* function = self.context[@"greet"];
			JSValue* result = [function callWithArguments:@[@"World"]];
			NSLog(@"result = %@", result);
		});
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception.reason);
	}
	@finally {
		// clean up memory
	}
}

- (void) stop{
	NSLog(@"STOP ");
	NSLog(@"STOP  1  ---------------------------------------");
	NSLog(@"STOP 11 ---------------------------------------");
	@try {
		void (^b)(NSString*) = ^void(NSString* s) {
			NSLog(@" s = %@", s);
			NSLog(@" en = %i", self.enabled);
			@throw [NSException exceptionWithName:@"StoppedException" reason:@"Stopped" userInfo:nil];
		};
		[self.context.globalObject setObject:nil forKeyedSubscript:@"test"];
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception.reason);
	}
	@finally {
		// clean up memory
	}
	
	
	dispatch_async(myQueue, ^{
		NSLog(@"STOP ");
		NSLog(@"STOP---------------------------------------");
		NSLog(@"STOP---------------------------------------");
		NSLog(@"STOP---------------------------------------");
		NSLog(@"STOP---------------------------------------");
		NSLog(@"STOP---------------------------------------");
		self.enabled = NO;
	});
	
}


@end
