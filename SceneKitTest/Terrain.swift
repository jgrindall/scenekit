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
	private var colorMap:ColorMap!;
	private var maxI:CInt!;
	private var maxJ:CInt!;
	private var size:Float!;
	private var geom:SCNGeometry!;
	
	init(maxI:CInt, maxJ:CInt, size:Float){
		self.maxI = maxI;
		self.maxJ = maxJ;
		self.size = size;
		self.initHeightMap();
		self.initColorMap();
		self.initGeom();
	}
	
	private func initGeom(){
		self.geom = GeomUtils.makeTopology(self.maxI, maxJ: self.maxJ, size:self.size);
		let blueMaterial = SCNMaterial();
		blueMaterial.diffuse.contents = UIColor.blueColor();
		self.geom.materials = [blueMaterial];
		self.node = SCNNode(geometry: self.geom);
		self.node.castsShadow = true;
		self.updateColor();
		self.updateHeight();
		self.geom.setValue(Assets.getGrass(), forKey: "texture0");
		self.geom.setValue(Assets.getStone(), forKey: "texture1");
		self.geom.setValue(Float(self.maxI), forKey: "maxI");
		self.geom.setValue(Float(self.maxJ), forKey: "maxJ");
		self.geom.setValue(Float(self.size), forKey: "size");
		self.geom.setValue(Float(GeomUtils.Constants.EPSILON), forKey: "eps");
		self.geom.shaderModifiers = [
			SCNShaderModifierEntryPointGeometry: Assets.getGeomModifier(),
			SCNShaderModifierEntryPointSurface: Assets.getSurfModifier()
		];
	}
	
	private func updateHeight(){
		self.geom.setValue(Assets.getValueForImage(self.heightMap.get()), forKey: "heightMapTexture");
	}
	
	private func updateColor(){
		self.geom.setValue(Assets.getValueForImage(self.colorMap.get()), forKey: "colorMapTexture");
	}
	
	private func initHeightMap(){
		self.heightMap = HeightMap(maxI: self.maxI, maxJ: self.maxJ);
	}
	
	private func initColorMap(){
		self.colorMap = ColorMap(maxI: self.maxI, maxJ: self.maxJ);
	}
	
	func edit(){
		let i:Int = Int(arc4random_uniform(10));
		let j:Int = Int(arc4random_uniform(10));
		let h:UInt8 = UInt8(arc4random_uniform(255));
		self.heightMap.setHeightAt(i, j: j, h: h);
		self.colorMap.setColorAt(i, j: j, colorIndex: h);
		SCNTransaction.begin();
		self.updateColor();
		self.updateHeight();
		SCNTransaction.commit();
	}
	
	func getNode() -> SCNNode{
		return self.node;
	}
	
	func getHeightMap() -> SCNNode{
		return self.node;
	}
}

