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

class Terrain{
	
	private var node:SCNNode!;
	private var heightMap:HeightMap!;
	private var maxI:CInt!;
	private var maxJ:CInt!;
	private var size:Float!;
	private var geom:SCNGeometry!;
	
	init(maxI:CInt, maxJ:CInt, size:Float){
		self.maxI = maxI;
		self.maxJ = maxJ;
		self.size = size;
		self.initHeightMap();
		self.initGeom();
	}
	
	private func initGeom(){
		self.geom = GeomUtils.makeTopology(self.maxI, maxJ: self.maxJ, size:self.size);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.blueColor();
		blueMaterial.doubleSided = true;
		self.geom.materials = [blueMaterial];
		self.node = SCNNode(geometry: self.geom);
		self.node.castsShadow = true;
		self.geom.setValue(Assets.getValueForImage(self.heightMap.get()), forKey: "heightMapTexture");
		self.geom.setValue(Float(self.maxI), forKey: "maxI");
		self.geom.setValue(Float(self.maxJ), forKey: "maxJ");
		self.geom.setValue(Float(self.size), forKey: "size");
		self.geom.setValue(Float(GeomUtils.Constants.EPSILON), forKey: "eps");
		self.geom.shaderModifiers = [
			SCNShaderModifierEntryPointGeometry: Assets.getGeomModifier(),
			SCNShaderModifierEntryPointSurface: Assets.getSurfModifier()
		];
	}
	
	private func initHeightMap(){
		self.heightMap = HeightMap(maxI: self.maxI, maxJ: self.maxJ);
	}
	
	func edit(){
		self.heightMap.setHeightAt(0, j: 0, h: 1);
		self.heightMap.setHeightAt(0, j: 1, h: 1);
		self.heightMap.setHeightAt(1, j: 0, h: 1);
		self.heightMap.setHeightAt(1, j: 1, h: 1);
		SCNTransaction.begin();
		self.geom.setValue(Assets.getValueForImage(self.heightMap.get()), forKey: "heightMapTexture");
		SCNTransaction.commit();
	}
	
	func getNode() -> SCNNode{
		return self.node;
	}
	
	func getHeightMap() -> SCNNode{
		return self.node;
	}
}

