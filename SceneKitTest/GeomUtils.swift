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
	
	
}