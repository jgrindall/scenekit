'use strict';

var _paused = false;

var console = { log: function(message) { _consoleLog(message) } };

var myFn = function() {
	while(true){
		while(_paused){
			objectwrapper.p();
		}
		objectwrapper.f();
	}
};

var pause = function(){
	_paused = true;
};

var unpause = function(){
	_paused = false;
};
