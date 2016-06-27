//
//  CachedImage.swift
//  SceneKitTest
//
//  Created by John on 26/06/2016.
//
//

import Foundation
import SceneKit
import QuartzCore

class CachedImage{
	
	var _img:UIImage;
	var _context: CGContext;
	var _data:UnsafeMutablePointer<Void>;
	var _dataArray:UnsafeMutablePointer<UInt8>;
	var _w:Int;
	var _w4:Int;
	var _h:Int;
	
	init(w:Int, h:Int){
		let clr:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0);
		self._img = ImageUtils.getImageWithColor(clr, size: CGSizeMake(CGFloat(w), CGFloat(h)));
		let inImage:CGImageRef = self._img.CGImage!;
		self._context = ImageUtils.createBitmapContext(inImage);
		self._w = w;
		self._h = h;
		self._w4 = 4 * self._w;
		let rect = CGRect(x:0, y:0, width:Int(self._w), height:Int(self._h));
		CGContextClearRect(self._context, rect);
		CGContextDrawImage(self._context, rect, inImage);
		self._data = CGBitmapContextGetData(self._context);
		self._dataArray = UnsafeMutablePointer<UInt8>(self._data);
	}
	
	deinit {
		self._img = ImageUtils.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(1, 1));
		self._context = ImageUtils.createBitmapContext(nil);
		self._data = nil;
		self._dataArray = nil;
	}
	
	func get() -> UIImage{
		return self._img;
	}
	
	func setPixelColorAtPoint(x:Int, y:Int, r: UInt8, g:UInt8, b:UInt8, a:UInt8){
		let offset = 4 * (Int(self._w) * y) + x;
		self._dataArray[offset]   = r;
		self._dataArray[offset + 1] = g;
		self._dataArray[offset + 2] = b;
		self._dataArray[offset + 3] = a;
		let colorSpace = CGColorSpaceCreateDeviceRGB();
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue);
		let bitmapBytesPerRow = self._w4;
		let context = CGBitmapContextCreate(self._data, self._w, self._h, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue);
		let imageRef = CGBitmapContextCreateImage(context);
		self._img = UIImage(CGImage: imageRef!, scale: self._img.scale,orientation: self._img.imageOrientation);
	}

}
