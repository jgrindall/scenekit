
import Foundation
import SceneKit
import QuartzCore


class PatchNodeCache {

	static private var _dict:[String:SCNNode] = [:];
	
	static func get(type:String) -> SCNNode{
		if(_dict[type] == nil){
			print("make a new one");
			_dict[type] = _make(type: type);
		}
		return (_dict[type]?.clone())!;
	}
	static private func _make(type:String) -> SCNNode{
		let planeGeom:SCNPlane = SCNPlane(width: 21.0, height: 21.0);
		planeGeom.widthSegmentCount = 1;
		planeGeom.heightSegmentCount = 1;
		let material = SCNMaterial();
		material.diffuse.minificationFilter = SCNFilterMode.nearest;
		material.diffuse.magnificationFilter = SCNFilterMode.nearest;
		if(type == "grass"){
			material.diffuse.contents = UIColor.red;
			material.ambient.contents = UIColor.red;
		}
		else{
			material.diffuse.contents = UIColor.green;
			material.ambient.contents = UIColor.green;
		}
		planeGeom.firstMaterial = material;
		let cNode = SCNNode(geometry: planeGeom);
		cNode.rotation = SCNVector4Make(1, 0, 0, -1.57);
		return cNode;
	}
}
