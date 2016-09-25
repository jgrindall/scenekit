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


class Topology {
	
	static func makeTopology(maxI:CInt, maxJ:CInt, size:Float) -> SCNGeometry{
		var vertices:Array<SCNVector3> = [SCNVector3]();
		var sqrs:Array<Sqr> = [Sqr]();
		let eps:Float = GeomUtils.Constants.EPSILON;
		for i in 0 ... maxI{
			for j in 0 ... maxJ{
				var h:Float = 0.0;
				vertices.append(SCNVector3Make(Float(j)*size, h, Float(i)*size));
			}
		}
		var h:Float = 0;
		var dh:Float = 0.0;
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				vertices.append(SCNVector3Make(Float(j)*size + eps, h + dh, Float(i)*size + eps));
				vertices.append(SCNVector3Make(Float(j + 1)*size - eps, h + dh, Float(i)*size + eps));
				vertices.append(SCNVector3Make(Float(j + 1)*size - eps, h + dh, Float(i + 1)*size - eps));
				vertices.append(SCNVector3Make(Float(j)*size + eps, h + dh, Float(i + 1)*size - eps));
			}
		}
		func getIndex(i:CInt, j:CInt) -> CInt{
			return (i * (maxJ + 1) + j);
		}
		func getInnerIndex(i:CInt, j:CInt, k:CInt) -> CInt{
			return (maxI + 1) * (maxJ + 1) + 4*(i * maxJ + j) + k;
		}
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				// add the tops
				sqrs.append(Sqr(a: getInnerIndex(i, j: j, k: 3),		b: getInnerIndex(i, j: j, k: 2),			c: getInnerIndex(i, j: j, k: 1),		d: getInnerIndex(i, j: j, k: 0)));
			}
		}
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				// and the sides
				sqrs.append(Sqr(a: getIndex(i + 1, j: j),				b: getInnerIndex(i, j: j, k: 3),			c: getInnerIndex(i, j: j, k: 0),			d: getIndex(i, j: j)));
				sqrs.append(Sqr(a: getIndex(i + 1, j: j + 1),			b: getInnerIndex(i, j: j, k: 2),			c: getInnerIndex(i, j: j, k: 3),			d: getIndex(i + 1, j: j)));
				sqrs.append(Sqr(a: getIndex(i, j: j + 1),				b: getInnerIndex(i, j: j, k: 1),			c: getInnerIndex(i, j: j, k: 2),			d: getIndex(i + 1, j: j + 1)));
				sqrs.append(Sqr(a: getIndex(i, j: j),					b: getInnerIndex(i, j: j, k: 0),			c: getInnerIndex(i, j: j, k: 1),			d: getIndex(i, j: j + 1)));
			}
		}
		//print(vertices);
		//print(sqrs);
		return GeomUtils.makeGeometryWithPointsAndSquares(vertices, sqrs: sqrs);
	}
	
}

