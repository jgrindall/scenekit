//
//  HeightMap.swift
//  SceneKitTest
//
//  Created by John on 26/06/2016.
//
//

import Foundation
import UIKit

class HeightMap{
	
	private var _cache: CachedImage;
	
	init(maxI:CInt, maxJ:CInt){
		self._cache = CachedImage(w: Int(maxJ), h: Int(maxI));
	}
	
	func setHeightAt(i:Int, j:Int, h:UInt8){
		// h from 0 to 255
		self._cache.setPixelColorAtPoint(i, y: j, r: h, g: h, b: h, a: h);
	}
	
	func get() -> UIImage{
		return self._cache.get();
	}
	
}
