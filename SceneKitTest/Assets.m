
#import "Assets.h"

@implementation Assets

- (void) someMethod {
	NSLog(@"SomeMethod Ran");
}

- (NSArray*) getArray{
	NSArray* f = @[ @0.4, @0.6];
	return f;
}

- (float*) getArray2{
	static float r[2] = {0.4, 0.6};
	return r;
}

@end