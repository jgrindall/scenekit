//
//  Assets.swift
//  SceneKitTest
//
//  Created by John on 25/06/2016.
//
//

import Foundation
import UIKit
import SceneKit

class Assets{
	
	static func getShared() -> String{
		let path:String = Bundle.main.path(forResource: "shared", ofType: "txt")!;
		return try! String(contentsOfFile: path);
	}
	
	static func getGeomModifier2() -> String{
		let path:String = Bundle.main.path(forResource: "geom2", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.replacingOccurrences(of: "%shared%", with: Assets.getShared());
		return newS;
	}
	
	static func getGeomModifier3() -> String{
		let path:String = Bundle.main.path(forResource: "geom3", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.replacingOccurrences(of: "%shared%", with: Assets.getShared());
		return newS;
	}
	
	static func getGeomModifier() -> String{
		let path:String = Bundle.main.path(forResource: "geom", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.replacingOccurrences(of: "%shared%", with: Assets.getShared());
		return newS;
	}
	
	static func getSurfModifier() -> String{
		let path:String = Bundle.main.path(forResource: "surf", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.replacingOccurrences(of: "%shared%", with: Assets.getShared());
		return newS;
	}
	
	static func getSurfModifier2() -> String{
		let path:String = Bundle.main.path(forResource: "surf2", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.replacingOccurrences(of: "%shared%", with: Assets.getShared());
		return newS;
	}
	
	static func getFragModifier() -> String{
		let path:String = Bundle.main.path(forResource: "frag", ofType: "shader")!;
		let s:String = try! String(contentsOfFile: path);
		let newS = s.replacingOccurrences(of: "%shared%", with: Assets.getShared());
		return newS;
	}
	
	static func getSoil() -> SCNMaterialProperty{
		let imgPath = Bundle.main.path(forResource: "soil", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getStone() -> SCNMaterialProperty{
		let imgPath = Bundle.main.path(forResource: "stone", ofType: "png");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getGrass() -> SCNMaterialProperty{
		let imgPath = Bundle.main.path(forResource: "grass", ofType: "png");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getValueForImage(_ img: UIImage) -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: img);
	}
	
	static func getRock2() -> SCNMaterialProperty{
		let imgPath = Bundle.main.path(forResource: "rock2", ofType: "jpg");
		return SCNMaterialProperty(contents: UIImage(contentsOfFile: imgPath!)!);
	}
	
	static func getWhite() -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: Assets.getWhiteImg());
	}
	
	static func getGrey() -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: Assets.getGreyImg());
	}
	
	static func getBlack() -> SCNMaterialProperty{
		return SCNMaterialProperty(contents: Assets.getBlackImg());
	}
	
	static func getWhiteImg() -> UIImage{
		return ImageUtils.getImageWithColor(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 255), size: CGSize(width: 50, height: 50));
	}
	
	static func getGreyImg() -> UIImage{
		return ImageUtils.getImageWithColor(UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 255), size: CGSize(width: 50, height: 50));
	}
	
	static func getBlackImg() -> UIImage{
		return ImageUtils.getImageWithColor(UIColor(red: 0, green: 0, blue: 0, alpha: 255), size: CGSize(width: 50, height: 50));
	}
	
	static func getSoilImage() -> UIImage{
		let imgPath = Bundle.main.path(forResource: "soil", ofType: "jpg");
		return UIImage(contentsOfFile: imgPath!)!;
	}
	
	static func getSkyImage() -> UIImage{
		let imgPath = Bundle.main.path(forResource: "left", ofType: "png");
		return UIImage(contentsOfFile: imgPath!)!;
	}

}

