//
//  ViewController.swift
//  GradientStudy
//
//  Created by Victory on 2017/11/20.
//  Copyright © 2017年 iKaibei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var label: UILabel!
	
	var story = "  \n 直到现在我才明白\n 我不是北京，你也不是西雅图\n 我等不到你嫁给我的那天\n 我们之间也没有未来\n 但，我爱你\n 就算知道没有结果，我也爱你"
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(false)

		let gradient = CAGradientLayer()
		gradient.frame = view.bounds
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 1)
		gradient.colors = [UIColor(red: 0.0, green: 1.0, blue: 0.752, alpha: 1.0).cgColor,
						   UIColor(red: 0.949, green: 0.03, blue: 0.913, alpha: 1.0).cgColor]
		view.layer.addSublayer(gradient)
		gradient.mask = label.layer
		
		punchText(text: story)
//
		let imageView = UIImageView(image: UIImage(named: "dog3"))
		imageView.center.x = label.bounds.width/2
		label.addSubview(imageView)
		
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

extension ViewController {
	func punchText(text: String) {
		if text.characters.count > 0 {
			label.attributedText = self.getAttributeStringWithString("\(label.text!)\(text.substring(to: text.index(after: text.startIndex)))", lineSpace: 10)
			delay(0.10, task: {
				self.punchText(text: text.substring(from: text.index(after: text.startIndex)))
			})
			
		} else {
			delay(0.1, task: {self.addButtonRing()})
			delay(1.2, task: {self.addButtonRing()})
			delay(2.4, task: {self.addButtonRing()})
		}
	}
}

extension ViewController {
	// 按钮动画
	func addButtonRing() {
		let side: CGFloat = 60.0
		let button = CAShapeLayer()
		button.position = CGPoint(x: label.bounds.width * 0.5 - side/2, y: label.bounds.height * 0.85)
		button.strokeColor = UIColor.black.cgColor
		button.fillColor = UIColor.clear.cgColor
		button.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: side, height: side)).cgPath
		button.lineWidth = 1.0
		button.opacity = 0.5
		label.layer.addSublayer(button)
		
		let scale = CABasicAnimation(keyPath: "transform.scale")
		scale.fromValue = 1.0
		scale.toValue = 0.67
		scale.duration = 2.0
		scale.repeatCount = Float.infinity
		scale.autoreverses = true
		button.add(scale, forKey: nil)
		
	}
}

extension ViewController {
	// 为UILabel添加行间距
	fileprivate func getAttributeStringWithString(_ string: String,lineSpace:CGFloat
		) -> NSAttributedString{
		let attributedString = NSMutableAttributedString(string: string)
		let paragraphStye = NSMutableParagraphStyle()
		
		//调整行间距
		paragraphStye.lineSpacing = lineSpace
		let rang = NSMakeRange(0, CFStringGetLength(string as CFString!))
		attributedString .addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStye, range: rang)
		return attributedString
		
	}
}

extension ViewController {
	typealias Task = (_ cancel : Bool) -> Void
	// 延时器封装 (不要问我为什么，这个是喵神封装的)
	func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
		
		func dispatch_later(block: @escaping ()->()) {
			let t = DispatchTime.now() + time
			DispatchQueue.main.asyncAfter(deadline: t, execute: block)
		}
		var closure: (()->Void)? = task
		var result: Task?
		
		let delayedClosure: Task = {
			cancel in
			if let internalClosure = closure {
				if (cancel == false) {
					DispatchQueue.main.async(execute: internalClosure)
				}
			}
			closure = nil
			result = nil
		}
		
		result = delayedClosure
		
		dispatch_later {
			if let delayedClosure = result {
				delayedClosure(false)
			}
		}
		return result
	}
	
	func cancel(_ task: Task?) {
		task?(true)
	}
}

