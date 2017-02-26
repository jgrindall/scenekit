
import Foundation
import SceneKit
import QuartzCore

protocol PTurtle: class{
	
	func getNode() -> SCNNode;
	func getData() -> TurtleData;
	func getPos() -> SCNVector3;
	func pos(p:SCNVector3);
	func fd(n:Float);
	func rt(n:Float);
	func update();
}
