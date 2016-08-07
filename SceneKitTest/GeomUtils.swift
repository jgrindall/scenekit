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
	init(a:CInt, b:CInt, c:CInt){
		self.a = a;
		self.b = b;
		self.c = c;
	}
	init(a:Int, b:Int, c:Int){
		self.a = CInt(a);
		self.b = CInt(b);
		self.c = CInt(c);
	}

	var a: CInt;
	var b: CInt;
	var c: CInt;
}

struct Sqr {
	init(a:CInt, b:CInt, c:CInt, d:CInt){
		self.a = a;
		self.b = b;
		self.c = c;
		self.d = d;
	}
	init(a:Int, b:Int, c:Int, d:Int){
		self.a = CInt(a);
		self.b = CInt(b);
		self.c = CInt(c);
		self.d = CInt(d);
	}
	var a: CInt;
	var b: CInt;
	var c: CInt;
	var d: CInt;
}

class GeomUtils {
	
	struct Constants {
		static let EPSILON:Float = 0.02;
	}
	
	static func randomTris(size:Float, numPerSide:Int, inout vertices:Array<Vertex>, inout tris:Array<Tri>){
		let d:Double = Double(size) / Double(numPerSide - 1);
		for i in 0 ..< numPerSide{
			for j in 0 ..< numPerSide{
				vertices.append(Vertex(x: Double(i) * d, y: Double(j) * d));
			}
		}
		let delTris:Array<Triangle> = Delaunay().triangulate(vertices);
		for t:Triangle in delTris{
			tris.append(Tri(a: t.vertex1.findIn(vertices), b: t.vertex2.findIn(vertices), c: t.vertex3.findIn(vertices)));
		}
	}
	
	static func getSquareRing(size:Float, defaultY:Float, numPerSide:Int, offsets:Array<Float>, inout vertices:Array<SCNVector3>, inout tris:Array<Tri>){
		let dx:Float =				size / Float(numPerSide - 1);
		var numVertices:Int =		vertices.count;
		let startPosns:Array<SCNVector3> = [
			SCNVector3Make(0.0,		0.0,		0.0),
			SCNVector3Make(size,	0.0,		0.0),
			SCNVector3Make(size,	0.0,		size),
			SCNVector3Make(0.0,		0.0,		size)
		];
		let directions:Array<SCNVector3> = [
			SCNVector3Make(dx,		0.0,		0.0),
			SCNVector3Make(0.0,		0.0,		dx),
			SCNVector3Make(-dx,		0.0,		0.0),
			SCNVector3Make(0.0,		0.0,		-dx)
		];
		func getOffset(v:SCNVector3)->Float{
			let indexI = Int(round(v.x / dx));
			let indexJ = Int(round(v.z / dx));
			let index = indexI * numPerSide + indexJ;
			return offsets[index];
		}
		for k in 0...3{
			let startPos:SCNVector3 =		startPosns[k];
			let direction:SCNVector3 =		directions[k];
			for i in 0 ... (numPerSide - 2){
				let v0 = startPos + (direction * i);
				let v1 = startPos + (direction * (i + 1));
				vertices.append(v0);
				vertices.append(v0.withY(defaultY - getOffset(v0)));
				vertices.append(v1);
				vertices.append(v1.withY(defaultY - getOffset(v1)));
				tris.append(Tri(a: numVertices + 3, b: numVertices + 0, c: numVertices + 1));
				tris.append(Tri(a: numVertices + 2, b: numVertices + 0, c: numVertices + 3));
				numVertices += 4;
			}
		}
	}
	
	static func getBase(size:Float, numPerSide:Int) -> SCNGeometry{
		var tris:Array<Tri> =					[Tri]();
		var vertices2d:Array<Vertex> =			[Vertex]();
		let defaultY:Float =					-12.0;
		var edgeOffsets:Array<Float> =			[Float]();
		GeomUtils.randomTris(size, numPerSide: 3, vertices: &vertices2d, tris: &tris);
		for _ in 0 ..< numPerSide{
			for _ in 0 ..< numPerSide{
				edgeOffsets.append(Float(arc4random() % 20));
			}
		}
		var vertices3d:Array<SCNVector3> = vertices2d.map({
			(v: Vertex) -> SCNVector3 in
			var newY:Float = defaultY;
			let fx:Float = Float(v.x);
			let fy:Float = Float(v.y);
			var indexI:Int;
			var indexJ:Int;
			var index:Int;
			let dx:Float = size / Float(numPerSide - 1);
			if(fx == 0 || fx == size || fy == 0 || fy == size){
				indexI = Int(round(fx / dx));
				indexJ = Int(round(fy / dx));
				index = (indexI * numPerSide) + indexJ;
				newY = defaultY - edgeOffsets[index];
			}
			else{
				let dx:Float = fx - size/2;
				let dy:Float = fy - size/2;
				let rSqr:Float = dx*dx + dy*dy;
				let maxRSqr:Float = size*size/4;
				newY = newY - 50.0*(1.0 - (rSqr/maxRSqr));
				let rnd = Float(arc4random() % 20);
				newY = newY + rnd;
				newY = min(newY, defaultY);
			}
			return SCNVector3Make(Float(v.x), newY, Float(v.y));
		});
		GeomUtils.getSquareRing(size, defaultY:defaultY, numPerSide:numPerSide, offsets:edgeOffsets, vertices: &vertices3d, tris: &tris);
		return GeomUtils.makeGeometryWithPointsAndTriangles(vertices3d, tris: tris, centre: SCNVector3(size/2.0, 0.1, size/2.0));
	}
	
	static func makeTopology(maxI:CInt, maxJ:CInt, size:Float) -> SCNGeometry{
		var vertices:Array<SCNVector3> = [SCNVector3]();
		var sqrs:Array<Sqr> = [Sqr]();
		let eps:Float = size * GeomUtils.Constants.EPSILON;
		for i in 0 ... maxI{
			for j in 0 ... maxJ{
				var h:Float = 0.0;
				vertices.append(SCNVector3Make(Float(j)*size, h, Float(i)*size));
			}
		}
		var h:Float = 0.0;
		for i in 0 ..< maxI{
			for j in 0 ..< maxJ{
				vertices.append(SCNVector3Make(Float(j)*size + eps, h, Float(i)*size + eps));
				vertices.append(SCNVector3Make(Float(j + 1)*size - eps, h, Float(i)*size + eps));
				vertices.append(SCNVector3Make(Float(j + 1)*size - eps, h, Float(i + 1)*size - eps));
				vertices.append(SCNVector3Make(Float(j)*size + eps, h, Float(i + 1)*size - eps));
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
		return GeomUtils.makeGeometryWithPointsAndSquares(vertices, sqrs: sqrs);
	}
	
	static func makeGeometryWithPointsAndSquares(positions:Array<SCNVector3>, sqrs:Array<Sqr>, centre: SCNVector3? = nil) -> SCNGeometry{
		var tris = [Tri]();
		for s:Sqr in sqrs{
			tris.append(Tri(a: s.c, b: s.b, c: s.a));
			tris.append(Tri(a: s.a, b: s.d, c: s.c));
		}
		return GeomUtils.makeGeometryWithPointsAndTriangles(positions, tris: tris, centre: centre);
	}
	
	static func makeGeometryWithPointsAndTriangles(positions:Array<SCNVector3>, tris:Array<Tri>, centre: SCNVector3? = nil) -> SCNGeometry{
		let geomBuilder:GeomBuilder = GeomBuilder();
		if(centre != nil){
			geomBuilder.addCentre(centre!);
		}
		for v:Tri in tris{
			geomBuilder.addTri(positions[Int(v.a)], v1:positions[Int(v.b)], v2:positions[Int(v.c)]);
		}
		return geomBuilder.getSCNGeometry();
	}
}

