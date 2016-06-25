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
	
	static var context:CGContext = ImageUtils.initHeightMap(500, h: 200);
	
	static func editHeightMap(pos:Int, ht:UInt8){
		let pixelBuffer = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(ImageUtils.context));
		var currentPixel = pixelBuffer;
		for _ in 0 ..< pos{
			currentPixel = currentPixel.successor();
		}
		let newColor:UInt32 = (UInt32(ht) << 24) | (UInt32(ht) << 16) | (UInt32(ht) << 8) | (UInt32(ht) << 0);
		currentPixel.memory = newColor;
	}
	
	static func initHeightMap(w:Int, h:Int) -> CGContext{
		let colorSpace       = CGColorSpaceCreateDeviceRGB();
		let bytesPerPixel    = 4;
		let bitsPerComponent = 8;
		let bytesPerRow      = bytesPerPixel * w;
		let bitmapInfo       = CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue;
		return CGBitmapContextCreate(nil, w, h, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!;
	}
	
	static func getHeightMap() -> UIImage{
		let outputCGImage = CGBitmapContextCreateImage(ImageUtils.context);
		return UIImage(CGImage: outputCGImage!);
	}
	
	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(CGRectMake(0, 0, 100, 100))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	

	static func tint(source:UIImage, r:int, g:int, b:int) -> UIImage{

	}
	
	
}