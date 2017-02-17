define([], function(){

	var SymTable = function(){
		this.blocks = [ ];
		this.functions = {};
	};

	SymTable.prototype.getCurrentBlock = function(){
		return this.blocks[this.blocks.length - 1];
	}

	SymTable.prototype.enterBlock = function(){
		var block = { };
		this.blocks.push(block);
	};

	SymTable.prototype.exitBlock = function(){
		this.blocks.pop();
	};

	SymTable.prototype.get = function(name){
		var block;
		for(var i = this.blocks.length - 1; i>=0; i--){
			block = this.blocks[i];
			if(block[name] !== null && block[name] !== undefined){
				return block[name];
				break;
			}
		}
		return null;
	};

	SymTable.prototype.add = function(name, val){
		this.getCurrentBlock()[name] = val;
	};

	SymTable.prototype.addFunction = function(name, argsNode, statementsNode){
		this.functions[name] = {"argsNode":argsNode, "statementsNode":statementsNode};
	};

	SymTable.prototype.getFunction = function(name){
		return this.functions[name];
	};

	SymTable.prototype.clear = function(){
		var i;
		this.functions = null;
		for(i = 0; i < this.blocks.length; i++){
			this.blocks[i] = null;
		}
		this.blocks = [];
	};

	return SymTable;
});


