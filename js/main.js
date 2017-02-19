
var run, consumer, getConsumer, clean, console;

console = {
	log: function(message) {
		consoleLog(message);
	}
};

clean = function(logo){
	logo = logo.replace(/;[^\n\r]+\n/g, "");
	logo = logo.replace(/#[^\n\r]+\n/g, "");
	logo = logo.replace(/\/\/[^\n\r]+\n/g, "");
	return logo;
};

getConsumer = function(){
	return function(type, data){
		if(typeof data === "undefined"){
			consumer(type, "");
		}
		else if(typeof data === "object"){
			data = JSON.stringify(data);
		}
		consumer(type, data);
	};
};

require(['converted/parser', 'visit'], function(Parser, visitor){

	'use strict';

	run = function(logo) {
		var tree, _consumer = getConsumer();
		tree = Parser.parse(clean(logo));
		_consumer("message", "start");
		if(tree){
			visitor.visit(tree, _consumer);
		}
		_consumer("message", "end");
	};

})

