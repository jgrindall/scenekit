import ReSwift
import RxSwift

class RxObserver<T>: StoreSubscriber {
	typealias StoreSubscriberStateType = State;
	var observedState: Variable<T?> = Variable(nil);
	private var store: Store<State>;
	
	init(store: Store<State>) {
		print("init");
		self.store = store;
		self.store.subscribe(self);
	}
	
	deinit {
		print("de init!!");
		self.store.unsubscribe(self);
	}
	
	func newState(state: State) {
		print("new state1!", state);
		self.observedState.value = state as? T;
		print("new state2!", state);
	}
}
