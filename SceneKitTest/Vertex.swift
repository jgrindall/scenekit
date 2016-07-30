//
//  Vertex.swift
//  DelaunayTriangulationSwift
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

public struct Vertex {
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
	
	public func findIn(a:Array<Vertex>) -> Int{
		for i in 0 ..< a.count{
			if(a[i] == self){
				return i;
			}
		}
		return -1;
	}
	
    public let x: Double
    public let y: Double
}

extension Vertex: Equatable { }

public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}