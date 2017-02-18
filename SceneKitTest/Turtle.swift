
import Foundation
import SceneKit
import QuartzCore



class Turtle : PTurtle{
	
	var _type:String = "";
	var _node:SCNNode;
	var heading:Float = 0;
	
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
	
	func getPos() -> SCNVector3{
		return self.getNode().position;
	}
	func fd(n:Float){
		let r0 = cosf(self.heading) * n;
		let r1 = sinf(self.heading) * n;
		var x:Float = self.getNode().position.x;
		var y:Float = self.getNode().position.y;
		var z:Float = self.getNode().position.z;
		self.pos(p: SCNVector3(x + r0, y, z + r1));
	}
	func rt(n:Float){
		self.heading += n;
	}
	func update(){
		
	}
}
