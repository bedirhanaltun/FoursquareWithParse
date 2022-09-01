
import Foundation
import UIKit

class Places{
    static let instance = Places()
    
    var placeName = ""
    var placeType = ""
    var placeDescription = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){
        
    }
}


//    private init(){
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

