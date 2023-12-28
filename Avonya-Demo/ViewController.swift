//
//  ViewController.swift
//  Avonya-Demo
//
//  Created by charanjit singh on 27/12/23.
//

import UIKit

class ViewController: UIViewController {
    let starting_x_point = 0
    let starting_y_point = 0
    let width = 300
    let height = 300
    let maxIterations = 100
    var scale: CGFloat = 1.0
    var offsetX: CGFloat = 0.0
    var offsetY: CGFloat = 0.0

    @IBOutlet var mandleBrotImageContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isMultipleTouchEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)

        let image = createMandelbrotImage()
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: starting_x_point, y: starting_y_point, width: Int(mandleBrotImageContainer.frame.size.width), height: Int(mandleBrotImageContainer.frame.size.height))
        mandleBrotImageContainer.addSubview(imageView)
    }
    // Panning left right top and bottom to mandelbrot
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        offsetX += translation.x
        offsetY += translation.y
        gesture.setTranslation(CGPoint.zero, in: view)

        updateMandlbrotImage()
    }

    // Zoom in and zoom out gesture handling
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        scale *= gesture.scale
        gesture.scale = 1.0
        updateMandlbrotImage()
    }

    @IBAction func zoomINAction(_ sender: Any) {
        scale *= 2.0
        updateMandlbrotImage()
    }

    @IBAction func zoomOutAction(_ sender: Any) {
        if scale >= 1.0 {
            scale -= 2.0
            if scale <= 0.0 {
                scale = 1.0
            }
            updateMandlbrotImage()
        }
    }

    //@comment  create Mandelbrot

    /// Checking the escape time with the method
    /// - Parameters:
    ///   - x: Double value of the x
    ///   - y: Double value of the y
    /// - Returns: returns an Integer to get the iteration
    public func mandelbrotEscapeTime(_ x: Double, _ y: Double) -> Int {
        var zx = 0.0
        var zy = 0.0
        var iteration = 0

        while zx * zx + zy * zy < 4 && iteration < maxIterations {
            let xtemp = zx * zx - zy * zy + x
            zy = 2 * zx * zy + y
            zx = xtemp
            iteration += 1
        }

        return iteration
    }


    /// This method creates the mandelbrot image with the specified width heigh and scale
    /// - Returns: returns an UIImage to show the render. It could be null as well.
    func createMandelbrotImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Int(mandleBrotImageContainer.frame.size.width), height: Int(mandleBrotImageContainer.frame.size.height)))

        let image = renderer.image { context in
            for x in 0..<width {
                for y in 0..<height {
                    let xPos = (Double(x) - Double(width) / 2 + Double(offsetX)) * 4 / Double(width) / Double(scale)
                    let yPos = (Double(y) - Double(height) / 2 + Double(offsetY)) * 4 / Double(height) / Double(scale)

                    let escapeTime = mandelbrotEscapeTime(xPos, yPos)
                    let color = UIColor(hue: CGFloat(escapeTime) / CGFloat(maxIterations), saturation: 1, brightness: 1, alpha: 1)

                    let pixelRect = CGRect(x: x, y: y, width: 1, height: 1)
                    context.cgContext.setFillColor(color.cgColor)
                    context.fill(pixelRect)
                }
            }
        }

        return image
    }


    /// Updating the mandelbrot image
    func updateMandlbrotImage() {
        print(scale)
        for subview in view.subviews {
            if let imageView = subview as? UIImageView {
                imageView.removeFromSuperview()
            }
        }

        let image = createMandelbrotImage()
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: starting_x_point, y: starting_y_point, width: Int(mandleBrotImageContainer.frame.size.width), height: Int(mandleBrotImageContainer.frame.size.height))
        mandleBrotImageContainer.addSubview(imageView)
    }
}
