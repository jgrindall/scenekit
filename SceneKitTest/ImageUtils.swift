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
	
	static func createBitmapContext(inImage: CGImageRef?) -> CGContext {
		var pixelsWide:Int = 1;
		var pixelsHigh:Int = 1;
		if((inImage) != nil){
			pixelsWide = CGImageGetWidth(inImage);
			pixelsHigh = CGImageGetHeight(inImage);
		}
		let bitmapBytesPerRow = Int(pixelsWide) * 4;
		let colorSpace = CGColorSpaceCreateDeviceRGB();
		let bitmapData:UnsafeMutablePointer<Void> = nil;
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue);
		let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue);
		return context!;
	}
	
	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		print("init clr", color);
		UIGraphicsBeginImageContextWithOptions(size, false, 0);
		color.setFill();
		UIRectFill(CGRectMake(0, 0, size.width, size.height));
		let image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image;
	}
	
}