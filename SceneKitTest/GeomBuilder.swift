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

class GeomBuilder{
	
	private var _vertices:Array<SCNVector3>;
	private var _normals:Array<SCNVector3>;
	private var _textureCoords:Array<CGPoint>;
	private var _indices:Array<CInt> = [CInt]();
	private var _primitiveCount:Int;
	private var _centre:SCNVector3!;
	
	init(){
		self._vertices =			[SCNVector3]();
		self._normals =				[SCNVector3]();
		self._textureCoords =		[CGPoint]();
		self._indices =				[CInt]();
		self._primitiveCount =		0;
	}
	
	deinit {
		self._vertices =			[SCNVector3]();
		self._normals =				[SCNVector3]();
		self._textureCoords =		[CGPoint]();
		self._indices =				[CInt]();
		self._primitiveCount =		0;
	}
	
	func addCentre(c:SCNVector3){
		self._centre = c;
	}
	
	func addTri(v0:SCNVector3, v1:SCNVector3, v2:SCNVector3){
		self._vertices.append(v0);
		self._vertices.append(v1);
		self._vertices.append(v2);
		var normal:SCNVector3 = (v1 - v0).cross(v2 - v0);
		normal.normalize();
		if(self._centre != nil){
			let dot:Float = normal.dot(self._centre - v0);
			if(dot >= 0.0){
				normal.negate();
			}
		}
		//normal = SCNVector3(1,0,0);
		self._normals.append(normal);
		self._normals.append(normal);
		self._normals.append(normal);
		
		print(normal);
		self._textureCoords.append(CGPoint(x: 0.0, y: 0.0));
		self._textureCoords.append(CGPoint(x: 1.0, y: 0.0));
		self._textureCoords.append(CGPoint(x: 1.0, y: 1.0));
		let i0 = CInt(3*self._primitiveCount);
		self._indices.append(i0);
		self._indices.append(i0 + 1);
		self._indices.append(i0 + 2);
		self._primitiveCount += 1;
	}
	
	func getSCNGeometry() -> SCNGeometry{
		
		print(self._vertices);
		print(self._normals);
		print(self._indices);
		print(self._primitiveCount);
		
		
		let geomSourceVertices = SCNGeometrySource(vertices: self._vertices,				count: self._vertices.count);
		let geomSourceNormals = SCNGeometrySource(normals: self._normals,					count: self._vertices.count);
		//let textureCoords = SCNGeometrySource(textureCoordinates: self._textureCoords,		count: self._vertices.count);
		
		var sources:Array<SCNGeometrySource> = [SCNGeometrySource]();
		sources.append(geomSourceVertices);
		sources.append(geomSourceNormals);
		//sources.append(textureCoords);
		
		let indexData = NSData(bytes: self._indices, length: self._indices.count * sizeof(CInt));
		let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.Triangles, primitiveCount: self._primitiveCount, bytesPerIndex: sizeof(CInt));
		
		var elements:Array<SCNGeometryElement> = [SCNGeometryElement]();
		elements.append(element);
		
		return SCNGeometry(sources: sources, elements: elements);
	}
	
}
