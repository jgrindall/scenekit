
var myFn, _consumer, pause, unpause;

var console = {
	log: function(message) {
		_consoleLog(message);
	}
};

require(['converted/parser', 'lock', 'visit'], function(Parser, Lock, visitor){

	'use strict';

	var _paused = false;

	var _clean = function(logo){
		logo = logo.replace(/;[^\n\r]+\n/g, "");
		logo = logo.replace(/#[^\n\r]+\n/g, "");
		logo = logo.replace(/\/\/[^\n\r]+\n/g, "");
		return logo;
	};

	myFn = function(logo) {
		var tree;
		console.log(JSON.stringify(_consumer));
		_consumer.consume("abc");
		logo = "fd 100";
		console.log("DONE1");
		_consumer.consume("pqr");
		logo = _clean(logo);
		tree = Parser.parse(logo);
		console.log("tree " + JSON.stringify(tree));
		if(tree){
			visitor.visit(tree, _consumer);
		}
		console.log("DONE2");
	};

	pause = function(){
		Lock.lock();
	};

	unpause = function(){
		Lock.unlock();
	};
})

