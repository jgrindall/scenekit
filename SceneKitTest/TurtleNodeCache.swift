
import Foundation
import SceneKit
import QuartzCore


class TurtleNodeCache {

	static private var _dict:[String:SCNNode] = [:];
	
	static func get(type:String) -> SCNNode{
		if(_dict[type] == nil){
			_dict[type] = _make(type: type);
		}
		return (_dict[type]?.clone())!;
	}
	static private func _make(type:String) -> SCNNode{
		if(type == "turtle"){
			//
		}
		let b0 = SCNNode(geometry:SCNBox(width: 8, height: 8, length: 5, chamferRadius: 0));
		let b1 = SCNNode(geometry:SCNBox(width: 3, height: 3, length: 5, chamferRadius: 0));
		b1.position.setX(5);
		let n:SCNNode = SCNNode();
		n.addChildNode(b0);
		n.addChildNode(b1);
		return n;
	}
}
