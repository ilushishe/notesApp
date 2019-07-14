//
//  ColorPickerView.swift
//  notesApp
//
//  Created by Ilya Kozlov on 14/07/2019.
//  Copyright © 2019 Ilya Kozlov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ColorPickerView: UIView {
    
    
    @IBOutlet weak var paletteImageView: UIImageView!
    @IBOutlet weak var chosenColorView: UIView!
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        sender.minimumNumberOfTouches = 1

        let translation = sender.translation(in: paletteImageView)

        if sender.state == .began {
            print("BEGAN")
        } else if sender.state == .recognized {
            print("kek")
        } else if sender.state == .ended {
            print("ended")
        }

        let point = CGPoint(x: translation.x, y: translation.y)
        let color = getPixelColor(atPosition: point)
        print(point)
        print(color)
        chosenColorView.backgroundColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:"ColorPickerView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    func getPixelColor(atPosition:CGPoint) -> UIColor{
        
        var pixel:[CUnsignedChar] = [0, 0, 0, 0];
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let bitmapInfo = CGBitmapInfo(rawValue:    CGImageAlphaInfo.premultipliedLast.rawValue);
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue);
        
        context!.translateBy(x: -atPosition.x, y: -atPosition.y);
        layer.render(in: context!);
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0);
        
        return color;
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("asd")
        let touch = touches.first
        if let point = touch?.location(in: paletteImageView) {
            let color = getPixelColor(atPosition: point)
            print(color)
            chosenColorView.backgroundColor = color
        }
    }
}
