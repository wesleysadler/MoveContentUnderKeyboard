//
//  FirstViewModel.swift
//  MoveContentUnderKeyboard
//
//  Created by Wesley Sadler on 2/25/16.
//  Copyright © 2016 Digital Sadler. All rights reserved.
//

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

