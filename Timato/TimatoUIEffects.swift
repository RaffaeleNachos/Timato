//
//  TimatoUIEffects.swift
//  Timato
//
//  Created by Raffaele Apetino on 12/03/22.
//  Copyright © 2022 Raffaele Apetino. All rights reserved.
//

import Foundation
import Cocoa

class TimatoUIEffects: NSObject {
    
}

extension NSView {
    func shake(duration: CFTimeInterval) {
        let shakeValues = [-5, 5, -5, 5, -3, 3, -2, 2, 0]

        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: .linear)
        translation.values = shakeValues
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = shakeValues.map { (Int(Double.pi) * $0) / 180 }
        
        let shakeGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = duration
        if let layer = self.layer{
            layer.add(shakeGroup, forKey: "shake")
        }
    }
}
