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
	
	var _maxI:CInt;
	var _maxJ:CInt;
	var _data : Array<Int>;
	var _cache: CachedImage;
	
	init(maxI:CInt, maxJ:CInt){
		self._maxI = maxI;
		self._maxJ = maxJ;
		self._data = [Int](count: Int(maxI) * Int(maxJ), repeatedValue: 0);
		self._cache = CachedImage(w: Int(maxJ), h: Int(maxI));
	}
	
	func setHeightAt(i:Int, j:Int, h:Int){
		let offset:Int = i * Int(self._maxJ) + j;
		self._data[offset] = h;
		self._cache.setPixelColorAtPoint(i, y: j, r: 255, g: 255, b: 0, a: 255);
	}
	
	func get() -> UIImage{
		return self._cache.get();
	}
	
}
