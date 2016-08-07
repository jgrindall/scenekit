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

struct VertexNorm {var x, y, z, nx, ny, nz: Float}

class GeomBuilder{
	
	private var _data:				[VertexNorm];
	private var _textureCoords:		[CGPoint];
	private var _indices:			[CInt];
	private var _primitiveCount:	Int;
	private var _vertexCount:		Int;
	private var _centre:			SCNVector3!;
	
	init(){
		self._data =				[];
		self._textureCoords =		[];
		self._indices =				[];
		self._primitiveCount =		0;
		self._vertexCount =			0;
	}
	
	deinit {
		
	}
	
	func addCentre(c:SCNVector3){
		self._centre = c;
	}
	
	func addTri(v0:SCNVector3, v1:SCNVector3, v2:SCNVector3){
		let left = v1 - v0;
		let right = v2 - v0;
		let i0 = CInt(3*self._primitiveCount);
		var normal:SCNVector3 = (left.cross(right));
		normal.normalize();
		if(self._centre != nil){
			if(normal.dot(self._centre - v0) >= 0.0){
				normal = normal * -1;
			}
		}
		self._data.append(VertexNorm(x: v0.x, y: v0.y, z: v0.z, nx: normal.x, ny: normal.y, nz: normal.z));
		self._data.append(VertexNorm(x: v1.x, y: v1.y, z: v1.z, nx: normal.x, ny: normal.y, nz: normal.z));
		self._data.append(VertexNorm(x: v2.x, y: v2.y, z: v2.z, nx: normal.x, ny: normal.y, nz: normal.z));
		self._indices.append(i0 + 2);
		self._indices.append(i0 + 1);
		self._indices.append(i0 + 0);
		self._vertexCount += 3;
		self._primitiveCount += 1;
	}
	
	func getSCNGeometry() -> SCNGeometry{
		let data = NSData(
			bytes: self._data,
			length: self._vertexCount * sizeof(VertexNorm)
		);
		let geomSourceVertices = SCNGeometrySource(
			data: data,
			semantic: SCNGeometrySourceSemanticVertex,
			vectorCount: self._vertexCount,
			floatComponents: true,
			componentsPerVector: 3,
			bytesPerComponent: sizeof(Float),
			dataOffset: 0,
			dataStride: sizeof(VertexNorm)
		);
		let geomSourceNormals = SCNGeometrySource(
			data: data,
			semantic: SCNGeometrySourceSemanticNormal,
			vectorCount: self._vertexCount,
			floatComponents: true,
			componentsPerVector: 3,
			bytesPerComponent: sizeof(Float),
			dataOffset: 3*sizeof(Float),
			dataStride: sizeof(VertexNorm)
		);
		let indexData = NSData(
			bytes: self._indices,
			length: self._indices.count * sizeof(CInt)
		);
		let element = SCNGeometryElement(
			data: indexData,
			primitiveType: SCNGeometryPrimitiveType.Triangles,
			primitiveCount: self._primitiveCount,
			bytesPerIndex: sizeof(CInt)
		);
		return SCNGeometry(
			sources: [geomSourceVertices, geomSourceNormals],
			elements: [element]
		);
	}
	
}

