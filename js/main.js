
var myFn, objectwrapper, pause, unpause;


require(['dep'], function(dep){
	'use strict';

	var _paused = false;

	var console = {
		log: function(message) {
			_consoleLog(message);
		}
	};

	myFn = function() {
		while(true){
			while(_paused){
				objectwrapper.p();
			}
			objectwrapper.f();
		}
	};

	pause = function(){
		_paused = true;
	};

	unpause = function(){
		_paused = false;
	};
})


