//
//  HeightMap.swift
//  SceneKitTest
//
//  Created by John on 26/06/2016.
//
//

import Foundation
import UIKit

class ColorMap{
	
	private var _cache: CachedImage;
	
	init(maxI:CInt, maxJ:CInt){
		self._cache = CachedImage(w: Int(maxJ), h: Int(maxI));
	}
	
	func setColorAt(i:Int, j:Int, colorIndex:UInt8){
		self._cache.setPixelColorAtPoint(i, y: j, r: colorIndex, g: colorIndex, b: colorIndex, a: colorIndex);
	}
	
	func get() -> UIImage{
		return self._cache.get();
	}
	
}
