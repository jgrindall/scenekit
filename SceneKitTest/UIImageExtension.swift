//
//  UIImageExtension.swift
//  ImageFun
//
//  Created by Neeraj Kumar on 11/11/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

import Foundation
import UIKit

private extension UIImage {
	private func createARGBBitmapContext(inImage: CGImageRef) -> CGContext {
		let pixelsWide = CGImageGetWidth(inImage)
		let pixelsHigh = CGImageGetHeight(inImage)
		let bitmapBytesPerRow = Int(pixelsWide) * 4
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapData = UnsafeMutablePointer<UInt8>()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
		let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
		return context!
	}
	
	func sanitizePoint(point:CGPoint) {
		let inImage:CGImageRef = self.CGImage!
		let pixelsWide = CGImageGetWidth(inImage)
		let pixelsHigh = CGImageGetHeight(inImage)
		let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
		precondition(CGRectContainsPoint(rect, point), "CGPoint passed is not inside the rect of image.It will give wrong pixel and may crash.")
	}
}

extension  UIImage {
	
	func setPixelColorAtPoint(point:CGPoint, r: UInt8, g:UInt8, b:UInt8, a:UInt8) -> UIImage? {
		self.sanitizePoint(point)
		let inImage:CGImageRef = self.CGImage!
		let context = self.createARGBBitmapContext(inImage)
		let pixelsWide = CGImageGetWidth(inImage)
		let pixelsHigh = CGImageGetHeight(inImage)
		let rect = CGRect(x:0, y:0, width:Int(pixelsWide), height:Int(pixelsHigh))
		CGContextClearRect(context, rect)
		CGContextDrawImage(context, rect, inImage)
		let data = CGBitmapContextGetData(context)
		let dataType = UnsafeMutablePointer<UInt8>(data)
		let offset = 4*((Int(pixelsWide) * Int(point.y)) + Int(point.x))
		dataType[offset]   = r;
		dataType[offset+1] = g;
		dataType[offset+2] = b;
		dataType[offset+3] = a;
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
		let bitmapBytesPerRow = Int(pixelsWide) * 4
		let finalcontext = CGBitmapContextCreate(data, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo.rawValue)
		let imageRef = CGBitmapContextCreateImage(finalcontext)
		return UIImage(CGImage: imageRef!, scale: self.scale,orientation: self.imageOrientation);
	}
}