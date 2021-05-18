//
//  Order.swift
//  FarithulInzamam_MyOrder
//
//  Created by Inzi Hussain on 2021-05-17.
//

import Foundation
import FirebaseFirestoreSwift

struct Order: Codable {
    @DocumentID var id : String?
    
    var quantity : Int
    
    var type : CoffeeType
    
    var size : CupSize
    
    var date : Date
}
