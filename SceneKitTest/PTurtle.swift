
import Foundation
import SceneKit
import QuartzCore

protocol PTurtle: class{
	
	func getNode() -> SCNNode;
	func getData() -> TurtleData;

}
