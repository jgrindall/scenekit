
import Foundation
import SceneKit
import QuartzCore



class Turtle : PTurtle{
	
	var _type:String = "";
	var _node:SCNNode;
	var heading:Float = 0;
	var pos:SCNVector3;
	
	init(type: String){
		self._type = type;
		self._node = TurtleNodeCache.get(type: type);
		self.pos = SCNVector3(0,0,0);
	}
	
	func update(){
		//flush
		self.getNode().position = self.pos;
	}
	
	func getNode() -> SCNNode{
		return self._node;
	}
	
	func getData() -> TurtleData{
		return TurtleData();
	}
	
	func pos(p: SCNVector3){
		self.pos = p;
	}
	
	func getPos() -> SCNVector3{
		return self.pos;
	}
	func fd(n:Float){
		let r0 = cosf(self.heading) * n;
		let r1 = sinf(self.heading) * n;
		self.pos = SCNVector3(pos.x + r0, pos.y, pos.z + r1);
	}
	func rt(n: Float){
		self.heading += n;
	}
}
