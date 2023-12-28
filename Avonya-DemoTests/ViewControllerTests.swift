//
//  ViewControllerTests.swift
//  Avonya-DemoTests
//
//  Created by charanjit singh on 28/12/23.
//
import XCTest
@testable import Avonya_Demo

class ViewControllerTests: XCTestCase {

    // Mock class for testing
    class MockViewController: ViewController {
        var createMandelbrotImageCalled = false
        override func createMandelbrotImage() -> UIImage? {
            createMandelbrotImageCalled = true
            return super.createMandelbrotImage()
        }
    }

    var viewController: MockViewController!

    override func setUp() {
        super.setUp()
        viewController = MockViewController()
        viewController.loadViewIfNeeded()
    }

    func testInitialSetup() {
        // Test if the initial setup creates a Mandelbrot image
        XCTAssertTrue(viewController.createMandelbrotImageCalled, "createMandelbrotImage should be called on initial setup")
        XCTAssertEqual(viewController.mandleBrotImageContainer.subviews.count, 1, "One UIImageView should be added initially")
    }

    func testHandlePan() {
        // Test panning gesture handling
        let panGesture = UIPanGestureRecognizer()
        viewController.handlePan(panGesture)

        XCTAssertTrue(viewController.createMandelbrotImageCalled, "createMandelbrotImage should be called after panning")
    }

    func testHandlePinch() {
        // Test pinch gesture handling
        let pinchGesture = UIPinchGestureRecognizer()
        viewController.handlePinch(pinchGesture)

        XCTAssertTrue(viewController.createMandelbrotImageCalled, "createMandelbrotImage should be called after pinching")
    }

    func testZoomINAction() {
        // Test zoom in action
        viewController.zoomINAction(self)

        XCTAssertTrue(viewController.createMandelbrotImageCalled, "createMandelbrotImage should be called after zoom in action")
    }

    func testUpdateMandlbrotImage() {
        // Test updating Mandelbrot image
        viewController.updateMandlbrotImage()

        XCTAssertTrue(viewController.createMandelbrotImageCalled, "createMandelbrotImage should be called after updating Mandelbrot image")
        XCTAssertEqual(viewController.mandleBrotImageContainer.subviews.count, 1, "One UIImageView should be added after updating Mandelbrot image")
    }
}
