import UIKit
import ReSwift
import RxSwift

class Singleton {
	
	static let sharedInstance : Singleton = {
		let instance = Singleton();
		return instance;
	}()
	
	var store:Store<State>;
	var rx:RxObserver<State>;
	
	init() {
		store = Store<State>(reducer: AppReducer(), state: State());
		rx = RxObserver<State>(store: store);
	}
}
