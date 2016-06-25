//
//  GeomUtils.swift
//  SceneKitTest
//
//  Created by John on 25/06/2016.
//
//

import Foundation
import SceneKit
import QuartzCore

struct Tri {
	var a: CInt;
	var b: CInt;
	var c: CInt;
}

struct Sqr {
	var a: CInt;
	var b: CInt;
	var c: CInt;
	var d: CInt;
}

class GeomUtils {

	static func makeTopology(m:CInt, n:CInt) -> SCNGeometry{
		var size:Float = 1.0;
		var height:Float = 1.0;
		var a:Array<SCNVector3> = [SCNVector3]();
		for i in 0...n{
			for j in 0...m{
				a.append(SCNVector3Make(Float(j)*size, 0, Float(i)*size));
			}
		}
		for i in 0...n{
			for j in 0...m{
				a.append(SCNVector3Make(Float(j)*size, height, Float(i)*size));
			}
		}
		var sqrs:Array<Sqr> = [Sqr]();
		//add sqr
		func getIndexA(i:CInt, j:CInt) -> CInt{
			return i * (m + 1) + j;
		}
		func getIndexB(i:CInt, j:CInt) -> CInt{
			return getIndexA(i, j: j) + (m + 1) * (n + 1);
		}
		for i in 0...n - 1{
			for j in 0...m - 1{
				sqrs.append(Sqr(a: getIndexA(i, j: j),			b: getIndexA(i + 1, j: j),		c: getIndexA(i + 1, j: j + 1),	d: getIndexA(i, j: j + 1)));
				sqrs.append(Sqr(a: getIndexB(i + 1, j: j),		b: getIndexB(i, j: j),			c: getIndexB(i, j: j + 1),		d: getIndexB(i + 1, j: j + 1)));
			}
		}
		for i in 0...n - 1{
			for j in 0...m - 1{
				sqrs.append(Sqr(a: getIndexA(i + 1, j: j),		b: getIndexA(i, j: j),			c: getIndexB(i, j: j),			d: getIndexB(i + 1, j: j)));
				sqrs.append(Sqr(a: getIndexA(i + 1, j: j + 1),	b: getIndexA(i + 1, j: j),		c: getIndexB(i + 1, j: j),		d: getIndexB(i + 1, j: j + 1)));
				sqrs.append(Sqr(a: getIndexA(i, j: j + 1),		b: getIndexA(i + 1, j: j + 1),	c: getIndexB(i + 1, j: j + 1),	d: getIndexB(i, j: j + 1)));
				sqrs.append(Sqr(a: getIndexA(i, j: j),			b: getIndexA(i, j: j + 1),		c: getIndexB(i, j: j + 1),		d: getIndexB(i, j: j)));
			}
		}
		return GeomUtils.makeGeometryWithPointsAndSquares(a, sqrs: sqrs, m: m, n: n);
	}
	
	static func makeGeometryWithPointsAndSquares(positions:Array<SCNVector3>, sqrs:Array<Sqr>, m:CInt, n:CInt) -> SCNGeometry{
		var tris = [Tri]();
		for s:Sqr in sqrs{
			tris.append(Tri(a: s.a, b: s.b, c: s.c));
			tris.append(Tri(a: s.c, b: s.d, c: s.a));
		}
		return GeomUtils.makeGeometryWithPointsAndTriangles(positions, tris: tris, m: m, n: n);
	}
	
	static func makeGeometryWithPointsAndTriangles(positions:Array<SCNVector3>, tris:Array<Tri>, m:CInt, n:CInt) -> SCNGeometry{
		var indices:Array<CInt> = [CInt]();
		var primCount = 0;
		for v:Tri in tris{
			indices.append(v.a);
			indices.append(v.b);
			indices.append(v.c);
			primCount += 1;
		}
		let vertexCount:Int = Int(2 * (m + 1) * (n + 1));
		let vertexSource = SCNGeometrySource(vertices: positions, count:vertexCount);
		print("count ");
		print(vertexCount);
		let indexData = NSData(bytes: indices, length: indices.count * sizeof(CInt));
		let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.Triangles, primitiveCount: primCount, bytesPerIndex: sizeof(CInt));
		return SCNGeometry(sources: [vertexSource], elements: [element]);
	}
	
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
		for (var i = 0; i < Int(height); i++){
			for (var j = 0; j < Int(width); j++) {
				let pixel = currentPixel.memory;
				if (red(pixel) == 0 && green(pixel) == 0 && blue(pixel) == 0) {
					currentPixel.memory = rgba(red: 255, green: 0, blue: 0, alpha: 255);
				}
				currentPixel++;
			}
		}
		let outputCGImage = CGBitmapContextCreateImage(context)
		let outputImage = UIImage(CGImage: outputCGImage!, scale: inputImage.scale, orientation: inputImage.imageOrientation)
		return outputImage
	}
	
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
	
	static func makeEmptyImage(w:Int, h:Int){
		return GeomUtils.getImageWithColor(UIColor.clearColor(), size: CGSizeMake(CGFloat(w), CGFloat(h)));
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