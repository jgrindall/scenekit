
import Foundation
import SceneKit
import QuartzCore



class Turtle : PTurtle{
	
	var _type:String = "";
	var _node:SCNNode;
	
	init(type:String){
		self._type = type;
		self._node = TurtleNodeCache.get(type: type);
	}
	
	func getNode() -> SCNNode{
		return self._node;
	}
	
	func getData() -> TurtleData{
		return TurtleData();
	}
	
	func pos(p:SCNVector3){
		self.getNode().position = p;
	}
	
	func update(){
		
	}
}
