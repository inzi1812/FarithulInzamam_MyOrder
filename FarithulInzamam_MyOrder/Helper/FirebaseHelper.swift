//
//  FirebaseHelper.swift
//  FarithulInzamam_MyOrder
//
//  Created by Inzi Hussain on 2021-05-17.
//

import Foundation
import Firebase

class FirebaseHelper
{
    private static var shared : FirebaseHelper?
    
    var firestore : Firestore
    
    static func getInstance() -> FirebaseHelper
    {
        if shared == nil
        {
            shared = FirebaseHelper()
        }
        
        return shared!
    }
    
    init() {
        firestore = Firestore.firestore()
    }
    
    
    func addOrder(order : Order) -> Bool {
        
        do
        {
            let _ = try firestore.collection("Orders").addDocument(from: order)
            print("Ordered Succesfully")
            return true
        }
        catch let err
        {
            print("Error while Accessing Database \(err)")
            return false
        }
        
    }
    
    func editOrder(order : Order) -> Bool
    {
        
        do {
            try firestore.collection("Orders").document(order.id!).setData(from: order)
            print("Order updated")
            return true
        } catch let err {
            print("Error while Accessing Database \(err)")
            return false
        }
        
    }
    
    
    func getOrders(completion: @escaping (([Order]) -> () ))
    {
        
        //Return Users Array if perform Succesfully or return nil
        firestore.collection("Orders").order(by: "date", descending: true) .getDocuments { results, err in
            
            guard err == nil else
            {
                print(err.debugDescription)
                
                completion([])
                return
            }
            
            var orders = [Order]()
            
            results?.documents.forEach({ result in
                
                do
                {
                    let order = try result.data(as: Order.self)
                    orders.append(order!)
                }
                catch let err
                {
                    print(err)
                }
                
            })
         
            completion(orders)
        }
    }
    
    func deleteOrder(id : String, completion: @escaping ((Bool) -> ()) )
    {
        firestore.collection("Orders").document(id).delete { error in
            
            if let err = error {
                print("Error occured when deleting document")
                print(err)
                completion(false)
            }
            else
            {
                completion(true)
            }

            
        }
    }
    
}
