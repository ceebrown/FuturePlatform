//
//  Gan_TestTests.swift
//  Gan_TestTests
//
//  Created by Clive Brown on 09/09/2020.
//  Copyright © 2020 Clive Brown. All rights reserved.
//

import XCTest
@testable import Gan_Test

class Gan_TestTests: XCTestCase {

    func testApiCallCharacters() {
        let networkService = NetworkManager()

        networkService.getCharacters() { result in

                 switch result {
                 case .success(let characters):
                    XCTAssertEqual(characters.count, 63, "Expected 63 characters. Got wrong amount of characters instead.")
                    
                    XCTAssertEqual(characters.first?.name, "Walter White", "First character name in result array does not match expected first name")
                    
                    XCTAssertEqual(characters.last?.name, "Stacy Ehrmantraut", "Last character name in result array does not match expected last name")
                     
                 case .failure(let error):
                     print(error.localizedDescription)
                 }
             }
 
    }
}
