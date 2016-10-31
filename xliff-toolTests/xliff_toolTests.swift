//
//  xliff_toolTests.swift
//  xliff-toolTests
//
//  Created by Remus Lazar on 13.01.16.
//  Copyright © 2016 Remus Lazar. All rights reserved.
//

import XCTest
@testable import XLIFFTool

extension String {
    var lines:[String] {
        var result:[String] = []
        enumerateLines{ (line, _) in result.append(line) }
        return result
    }
}

class xliff_toolTests: XCTestCase {
    
    var testBundle: Bundle!
    var xliffFile: XliffFile!
    var xliffDocument: XMLDocument!
    var xliffData: Data!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: "de", withExtension: "xliff")!
        xliffData = try! Data(contentsOf: url)
        
        xliffDocument = try! Document.getXMLDocument(from: xliffData)
        xliffFile = XliffFile(xliffDocument: xliffDocument)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testXliffParsing() {
        // get the URL of the XML test file
        
        XCTAssertEqual(xliffFile.files.count, 4)
        XCTAssertEqual(xliffFile.totalCount, 70)
        
        XCTAssertEqual(xliffFile.files[0].sourceLanguage!, "en")
        XCTAssertEqual(xliffFile.files[0].targetLanguage!, "de")

        XCTAssertEqual(xliffFile.files[0].items.first!.elements(forName: "source").first!.stringValue, "Text Cell")
    }
    
    // check if the saved XML XLIFF file is valid XML
    func testXliffValidAfterSave() {
        let data = xliffDocument.xmlData
        do {
            let _ = try Document.getXMLDocument(from: data)
        } catch {
            print (error.localizedDescription)
            XCTFail()
        }
    }
    
    // check of the xml file is saved while preserving all whitespace/line breaks from the original
    func testSaveFormatting() {
        let data = xliffDocument.xmlData
        if let content = String(data: data, encoding: .utf8),
            let originalContent = String(data: xliffData, encoding: .utf8) {
            // check if the 3. last line is equal
            XCTAssertEqual(
                content.lines[content.lines.count - 3],
                originalContent.lines[originalContent.lines.count - 3] )
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
