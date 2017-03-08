import ReSwift
import RxSwift

class RxObserver<T>: StoreSubscriber {
	typealias StoreSubscriberStateType = State;
	var observedState: Variable<T?> = Variable(nil);
	private var store: Store<State>;
	
	init(store: Store<State>) {
		self.store = store;
		self.store.subscribe(self);
	}
	
	deinit {
		self.store.unsubscribe(self);
	}
	
	func newState(state: State) {
		self.observedState.value = state as? T;
	}
}
