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
	
	static func makeHeightMap(inputImage:UIImage) -> UIImage{
		let inputCGImage     = inputImage.CGImage;
		let colorSpace       = CGColorSpaceCreateDeviceRGB();
		let width            = CGImageGetWidth(inputCGImage);
		let height           = CGImageGetHeight(inputCGImage);
		let bytesPerPixel    = 4;
		let bitsPerComponent = 8;
		let bytesPerRow      = bytesPerPixel * width;
		let bitmapInfo       = CGImageAlphaInfo.PremultipliedFirst.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue;
		let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo)!;
		CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), inputCGImage);
		let pixelBuffer = UnsafeMutablePointer<UInt32>(CGBitmapContextGetData(context));
		var currentPixel = pixelBuffer;
		for i in 0 ..< Int(height){
			for j in 0 ..< Int(width) {
				let pixel = currentPixel.memory;
				currentPixel = currentPixel.successor();
			}
		}
		let outputCGImage = CGBitmapContextCreateImage(context)
		let outputImage = UIImage(CGImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
		return outputImage
	}
	
	/*
	func alpha(color: UInt32) -> UInt8 {
	return UInt8((color >> 24) & 255)
	}
	
	func red(color: UInt32) -> UInt8 {
	return UInt8((color >> 16) & 255)
	}
	
	func green(color: UInt32) -> UInt8 {
	return UInt8((color >> 8) & 255)
	}
	
	func blue(color: UInt32) -> UInt8 {
	return UInt8((color >> 0) & 255)
	}
	
	func rgba(red red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
	return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
	}
	*/
	
	static func makeEmptyImage(w:Int, h:Int) -> UIImage{
		return ImageUtils.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(CGFloat(w), CGFloat(h)));
	}
	
	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(CGRectMake(0, 0, 100, 100))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}