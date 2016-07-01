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

	static func makeTopology(maxI:CInt, maxJ:CInt, size:Float) -> SCNGeometry{
		var a:Array<SCNVector3> = [SCNVector3]();
		let eps:Float = 0.01;
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				var h:Float = 0.0;
				a.append(SCNVector3Make(Float(j)*size + eps, h, Float(i)*size + eps));
				a.append(SCNVector3Make(Float(j + 1)*size - eps, h, Float(i)*size + eps));
				a.append(SCNVector3Make(Float(j + 1)*size - eps, h, Float(i + 1)*size - eps));
				a.append(SCNVector3Make(Float(j)*size + eps, h, Float(i + 1)*size - eps));
			}
		}
		var sqrs:Array<Sqr> = [Sqr]();
		func getIndex(i:CInt, j:CInt, k:CInt) -> CInt{
			return 4*(i * maxJ + j) + k;
		}
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				// add the top
				sqrs.append(Sqr(a: getIndex(i, j: j, k: 0),		b: getIndex(i, j: j, k: 1),			c: getIndex(i, j: j, k: 2),		d: getIndex(i, j: j, k: 3)));
			}
		}
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				// add the sides
				if(j>=1){
					//left
					sqrs.append(Sqr(a: getIndex(i, j: j - 1, k: 2),		b: getIndex(i, j: j - 1, k: 1),			c: getIndex(i, j: j, k: 0),			d: getIndex(i, j: j, k: 3)));
				}
				if(i>=1){
					// bottom
					sqrs.append(Sqr(a: getIndex(i, j: j, k: 0),			b: getIndex(i - 1, j: j, k: 3),			c: getIndex(i - 1, j: j, k: 2),		d: getIndex(i, j: j, k: 1)));
				}
				if(j<maxJ - 1){
					//right
					sqrs.append(Sqr(a: getIndex(i, j: j, k: 2),			b: getIndex(i, j: j, k: 1),				c: getIndex(i, j: j + 1, k: 0),		d: getIndex(i, j: j + 1, k: 3)));
				}
				if(i<maxI - 1){
					//top
					sqrs.append(Sqr(a: getIndex(i + 1, j: j, k: 0),		b: getIndex(i, j: j, k: 3),				c: getIndex(i, j: j, k: 2),			d: getIndex(i + 1, j: j, k: 1)));
				}
			}
		}
		print("pts", a);
		print(a.count);
		print("---------");
		print("sqrs", sqrs);
		print(sqrs.count);
		return GeomUtils.makeGeometryWithPointsAndSquares(a, sqrs: sqrs);
	}
	
	static func makeGeometryWithPointsAndSquares(positions:Array<SCNVector3>, sqrs:Array<Sqr>) -> SCNGeometry{
		var tris = [Tri]();
		for s:Sqr in sqrs{
			tris.append(Tri(a: s.a, b: s.b, c: s.c));
			tris.append(Tri(a: s.c, b: s.d, c: s.a));
		}
		return GeomUtils.makeGeometryWithPointsAndTriangles(positions, tris: tris);
	}
	
	static func makeGeometryWithPointsAndTriangles(positions:Array<SCNVector3>, tris:Array<Tri>) -> SCNGeometry{
		var indices:Array<CInt> = [CInt]();
		var primCount = 0;
		for v:Tri in tris{
			indices.append(v.a);
			indices.append(v.b);
			indices.append(v.c);
			primCount += 1;
		}
		let vertexSource = SCNGeometrySource(vertices: positions, count:positions.count);
		let indexData = NSData(bytes: indices, length: indices.count * sizeof(CInt));
		let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.Triangles, primitiveCount: primCount, bytesPerIndex: sizeof(CInt));
		return SCNGeometry(sources: [vertexSource], elements: [element]);
	}
}