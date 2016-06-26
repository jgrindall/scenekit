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
	
	static var _img:UIImage = ImageUtils.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(1, 1));
	static var _context: CGContext = ImageUtils.createARGBBitmapContext(nil);
	static var _data:UnsafeMutablePointer<Void> = nil;
	static var _w:Int = 1;
	static var _h:Int = 1;
	
	static func get() -> UIImage{
		return ImageUtils._img;
	}
	
	static func createARGBBitmapContext(inImage: CGImageRef?) -> CGContext {
		var pixelsWide:Int = 1;
		var pixelsHigh:Int = 1;
		if((inImage) != nil){
			pixelsWide = CGImageGetWidth(inImage);
			pixelsHigh = CGImageGetHeight(inImage);
		}
		let bitmapBytesPerRow = Int(pixelsWide) * 4;
		let colorSpace = CGColorSpaceCreateDeviceRGB();
		let bitmapData:UnsafeMutablePointer<Void> = nil;
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue);
		let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue);
		return context!;
	}
	
	static func cache(){
		let inImage:CGImageRef = ImageUtils._img.CGImage!;
		let context = self.createARGBBitmapContext(inImage);
		ImageUtils._w = CGImageGetWidth(inImage);
		ImageUtils._h = CGImageGetHeight(inImage);
		let rect = CGRect(x:0, y:0, width:Int(ImageUtils._w), height:Int(ImageUtils._h));
		CGContextClearRect(context, rect);
		CGContextDrawImage(context, rect, inImage);
		let data:UnsafeMutablePointer<Void> = CGBitmapContextGetData(context);
		self._context = context;
		self._data = data;
	}
	
	static func initImg(w:Int, h:Int){
		ImageUtils._img = ImageUtils.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(CGFloat(w), CGFloat(h)));
		ImageUtils.cache();
	}
	
	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0);
		color.setFill();
		UIRectFill(CGRectMake(0, 0, size.width, size.height));
		let image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return image;
	}
	
	static func setPixelColorAtPoint2(point:CGPoint, r: UInt8, g:UInt8, b:UInt8, a:UInt8){
		let dataArray = UnsafeMutablePointer<UInt8>(ImageUtils._data);
		let offset = 4*((Int(ImageUtils._w) * Int(point.y)) + Int(point.x));
		dataArray[offset]   = r;
		dataArray[offset+1] = g;
		dataArray[offset+2] = b;
		dataArray[offset+3] = a;
		let colorSpace = CGColorSpaceCreateDeviceRGB();
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue);
		let bitmapBytesPerRow = ImageUtils._w * 4;
		let context = CGBitmapContextCreate(ImageUtils._data, ImageUtils._w, ImageUtils._h, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue);
		let imageRef = CGBitmapContextCreateImage(context);
		ImageUtils._img = UIImage(CGImage: imageRef!, scale: ImageUtils._img.scale,orientation: ImageUtils._img.imageOrientation);
	}
	
	static func setPixelColorAtPoint(img:UIImage, point:CGPoint, r: UInt8, g:UInt8, b:UInt8, a:UInt8) -> UIImage? {
		let inImage:CGImageRef = img.CGImage!;
		let context = self.createARGBBitmapContext(inImage);
		let pixelsWide = CGImageGetWidth(inImage);
		let pixelsHigh = CGImageGetHeight(inImage);
		let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh));
		CGContextClearRect(context, rect);
		CGContextDrawImage(context, rect, inImage);
		let data = CGBitmapContextGetData(context);
		let dataArray = UnsafeMutablePointer<UInt8>(data);
		let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x));
		dataArray[offset]   = r;
		dataArray[offset+1] = g;
		dataArray[offset+2] = b;
		dataArray[offset+3] = a;
		let colorSpace = CGColorSpaceCreateDeviceRGB();
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue);
		let bitmapBytesPerRow = Int(pixelsWide) * 4;
		let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue);
		let imageRef = CGBitmapContextCreateImage(finalcontext);
		return UIImage(CGImage: imageRef!, scale: img.scale,orientation: img.imageOrientation);
	}
	
}