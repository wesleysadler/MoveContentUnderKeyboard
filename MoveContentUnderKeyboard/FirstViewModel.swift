//
//  FirstViewModel.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//
//  The MIT License
//
//  Copyright © 2016 - 2019 Digital Sadler.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  opies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

struct FirstViewModel: FirstViewPresentable {
    var birdName: String
    var scientificName: String
    var birdImageFileName: String
    
    // if bird has not been seen disable text fields
    var hasSeenBird: Bool = false
    
    var numberOfBirds: Int?
    var locationOfBirds: String?
    var descriptionOfBirds: String?
    
    init(birdName: String, scientificName: String, birdImageFileName: String) {
        self.birdName = birdName
        self.scientificName = scientificName
        self.birdImageFileName = birdImageFileName
    }
}

// MARK: BirdNameLabelPresentable Conformance
extension FirstViewModel {
    var birdNameLabelText: String { return birdName }
}

// MARK: BirdNameLabelPresentable Conformance
extension FirstViewModel {
    var scientificNameLabelText: String { return scientificName }
}


// MARK: SwitchPresentable Conformance
extension FirstViewModel {
    var switchOn: Bool { return hasSeenBird }
    
    mutating func switchToggleOn(on: Bool) {
        hasSeenBird = on
    }
}

// MARK: ImagePresentable Conformance
extension FirstViewModel {
    var birdImageName: String { return birdImageFileName }
}

// MARK: NumberBirdsTextFieldPresentable Conformance
extension FirstViewModel {
    var numberBirdsText: Int { return numberOfBirds! }
        
    mutating func onNumberBirdsTextFieldDidEndEditing(textField: Int) {
        numberOfBirds = textField
    }
}

// MARK: LocationBirdsTextFieldPresentable Conformance
extension FirstViewModel {
    var locationBirdsText: String { return locationOfBirds! }
    
    mutating func onLocationBirdsTextFieldDidEndEditing(textField: String) {
        locationOfBirds = textField
    }
}

// MARK: DescriptionBirdsTextFieldPresentable Conformance
extension FirstViewModel {
    var descriptionBirdsText: String { return descriptionOfBirds! }
    
    mutating func onDescriptionBirdsTextFieldDidEndEditing(textField: String) {
        descriptionOfBirds = textField
    }
}

