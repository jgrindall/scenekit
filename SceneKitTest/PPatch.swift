
import Foundation
import SceneKit
import QuartzCore

protocol PPatch: class
{
	func getNode() -> SCNNode;
	func getData() -> PatchData;
}
