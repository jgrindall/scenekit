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
		static let EPSILON:Float = 1.0;
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

