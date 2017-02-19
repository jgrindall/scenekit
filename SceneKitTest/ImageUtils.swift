//
//  ImageUtils
//  SceneKitTest
//
//  Created by John on 25/06/2016.
//
//

import Foundation
import SceneKit
import QuartzCore

class ImageUtils {
	
	static func createBitmapContext(_ inImage: CGImage?) -> CGContext {
		var pixelsWide:Int = 1;
		var pixelsHigh:Int = 1;
		if((inImage) != nil){
			pixelsWide = inImage!.width;
			pixelsHigh = inImage!.height;
		}
		let bitmapBytesPerRow = Int(pixelsWide) * 4;
		let colorSpace = CGColorSpaceCreateDeviceRGB();
		let bitmapData:UnsafeMutableRawPointer? = nil;
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue);
		let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue);
		return context!;
	}
	
	static func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0);
		color.setFill();
		UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height));
		let image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image!;
	}
	
	static func collada2SCNNode(_ filepath:String) -> SCNNode {
		let node = SCNNode()
		let scene = SCNScene(named: filepath)
		let nodeArray = scene!.rootNode.childNodes
		
		for childNode in nodeArray {
			node.addChildNode(childNode as SCNNode)
		}
		return node
	}
	
	static func convertToDictionary(text: String) -> [String: Any]? {
		if let data = text.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			}
			catch {
				print(error.localizedDescription)
			}
		}
		return nil
	};
	
}
