
import Foundation
import SceneKit
import QuartzCore



class Patch : PPatch{
	
	var _type:String = "";
	var _node:SCNNode;
	
	init(type:String){
		self._type = type;
		self._node = PatchNodeCache.get(type: type);
	}
	
	func getNode() -> SCNNode{
		return self._node;
	}
	
	func getData() -> PatchData{
		return PatchData();
	}
	
	func pos(p:SCNVector3){
		self.getNode().position = p;
	}
	
	func update(){
	
	}
}
