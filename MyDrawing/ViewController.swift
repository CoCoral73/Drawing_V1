//
//  ViewController.swift
//  MyDrawing
//
//  Created by 김정원 on 2023/11/05.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var Undo: UIBarButtonItem!
    @IBOutlet var Redo: UIBarButtonItem!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var Pen: UIButton!
    @IBOutlet var Eraser: UIButton!
    @IBOutlet var ColorWell: UIColorWell!
    
    var lineWidth: CGFloat = 3.0
    var lineWidthSelected = [false, false, true, false, false]
    var lastLineWidth: CGFloat = 3.0
    var lineColor = UIColor.black.cgColor
    var history = [UIImage]()
    var now = -1
    var firstPoint: CGPoint!
    var lastPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ColorWell.selectedColor = UIColor.black
        ColorWell.addTarget(self, action: #selector(ViewController.colorWellDidChange(_:)), for: .valueChanged)
        
        Undo.isEnabled = false
        Redo.isEnabled = false
        Pen.isSelected = true
    }

    @objc func colorWellDidChange(_ sender: UIColorWell) {
        lineColor = ColorWell.selectedColor!.cgColor
    }

    @IBAction func btnUndo(_ sender: UIBarButtonItem) {
        now -= 1
        Redo.isEnabled = true
        if now >= 0 { imgView.image = history[now] }
        else {
            imgView.image = nil
            Undo.isEnabled = false
        }
    }
    @IBAction func btnRedo(_ sender: UIBarButtonItem) {
        now += 1
        Undo.isEnabled = true
        imgView.image = history[now]
        if now + 1 == history.count { Redo.isEnabled = false }
    }
    @IBAction func btnPen(_ sender: UIButton) {
        if Pen.isSelected {
            let PVC = PenPopoverViewController()
            PVC.lineWidthSelected = lineWidthSelected
            PVC.act1 = { [weak self] in self?.lineWidth = 1.0; (0...4).forEach { self!.lineWidthSelected[$0] = false; self!.lineWidthSelected[0] = true }; self!.lastLineWidth = 1.0 }
            PVC.act2 = { [weak self] in self?.lineWidth = 2.0; (0...4).forEach { self!.lineWidthSelected[$0] = false; self!.lineWidthSelected[1] = true }; self!.lastLineWidth = 2.0 }
            PVC.act3 = { [weak self] in self?.lineWidth = 3.0; (0...4).forEach { self!.lineWidthSelected[$0] = false; self!.lineWidthSelected[2] = true }; self!.lastLineWidth = 3.0 }
            PVC.act4 = { [weak self] in self?.lineWidth = 4.0; (0...4).forEach { self!.lineWidthSelected[$0] = false; self!.lineWidthSelected[3] = true }; self!.lastLineWidth = 4.0 }
            PVC.act5 = { [weak self] in self?.lineWidth = 5.0; (0...4).forEach { self!.lineWidthSelected[$0] = false; self!.lineWidthSelected[4] = true }; self!.lastLineWidth = 5.0 }
            
            PVC.view.backgroundColor = UIColor.white
            PVC.preferredContentSize = CGSize(width: 300, height: 60)
            PVC.modalPresentationStyle = .popover
            if let pres = PVC.presentationController {
                pres.delegate = self
            }
            
            self.present(PVC, animated: true)
            if let popover = PVC.popoverPresentationController {
                popover.sourceView = sender
                popover.sourceRect = sender.bounds
                popover.permittedArrowDirections = .down
            }
        }
        else {
            Pen.isSelected = true
            Eraser.isSelected = false
            
            lineColor = ColorWell.selectedColor!.cgColor
            lineWidth = lastLineWidth
        }
        
    }
    @IBAction func btnEraser(_ sender: UIButton) {
        Pen.isSelected = false
        Eraser.isSelected = true
        
        lineColor = UIColor.systemBackground.cgColor
        lineWidth = 10.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        firstPoint = touch.location(in: imgView)
        lastPoint = touch.location(in: imgView)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if firstPoint.y <= 0 || firstPoint.y >= imgView.frame.height { return }
        UIGraphicsBeginImageContext(imgView.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(lineColor)
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(lineWidth)
        
        let touch = touches.first! as UITouch
        let currPoint = touch.location(in: imgView)
        
        imgView.image?.draw(in: CGRect(x: 0, y: 0, width: imgView.frame.size.width, height: imgView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currPoint.x, y: currPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currPoint
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if firstPoint.y <= 0 || firstPoint.y >= imgView.frame.height { return }
        UIGraphicsBeginImageContext(imgView.frame.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(lineColor)
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(lineWidth)
        
        imgView.image?.draw(in: CGRect(x: 0, y: 0, width: imgView.frame.size.width, height: imgView.frame.size.height))
        
        UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        UIGraphicsGetCurrentContext()?.strokePath()
        
        imgView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if now + 1 == history.count {
            history.append(imgView.image!)
        }
        else {
            history[now + 1] = imgView.image!
            history.removeSubrange((now + 2)...)
            Redo.isEnabled = false
        }
        now += 1
        Undo.isEnabled = true
    }
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
