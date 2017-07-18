//
//  Complete_ItUITests.swift
//  Complete ItUITests
//
//  Created by Quintin Gunter on 7/8/17.
//  Copyright © 2017 Quintin Gunter. All rights reserved.
//

import XCTest

class Complete_ItUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testToTaskForm() {
        
        let app = XCUIApplication()
        app.buttons["+"].tap()
        app.buttons["X"].tap()
        
    }
    
    func testAddTask(){
        
        let app = XCUIApplication()
        app.buttons["+"].tap()
        
        let addTaskTextField = app.textFields["Add Task"]
        addTaskTextField.tap()
        
        let shiftButton = app.buttons["shift"]
        shiftButton.tap()
        addTaskTextField.typeText("Test ")
        shiftButton.tap()
        addTaskTextField.typeText("Task")
        app.buttons["Save"].tap()
        
    }
    
    func testDeleteTask(){
        
        let app = XCUIApplication()
        app.buttons["+"].tap()
        
        let addTaskTextField = app.textFields["Add Task"]
        addTaskTextField.tap()
        addTaskTextField.typeText("delete")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["Save"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.staticTexts["delete"].tap()
        tablesQuery.buttons["Delete"].tap()
        
    }
    
    func testCompleteTask(){
        //Add complete handler
    }
}

