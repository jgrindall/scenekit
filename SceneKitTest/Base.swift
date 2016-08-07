
import Foundation
import SceneKit
import QuartzCore

class Base {
	
	static func getSquareRing(size:Float, defaultY:Float, numPerSide:Int, edgeOffsets:Array<Float>, inout vertices:Array<SCNVector3>, inout tris:Array<Tri>){
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
			return edgeOffsets[index];
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
		let defaultY:Float =					-8.0;
		var edgeOffsets:Array<Float> =			[Float]();
		GeomUtils.randomTris(size, numPerSide: numPerSide, vertices: &vertices2d, tris: &tris);
		for _ in 0 ..< numPerSide{
			for _ in 0 ..< numPerSide{
				edgeOffsets.append(Float(arc4random() % 8));
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
		Base.getSquareRing(size, defaultY:defaultY, numPerSide:numPerSide, edgeOffsets:edgeOffsets, vertices: &vertices3d, tris: &tris);
		return GeomUtils.makeGeometryWithPointsAndTriangles(vertices3d, tris: tris, centre: SCNVector3(size/2.0, 0.1, size/2.0));
	}
}

