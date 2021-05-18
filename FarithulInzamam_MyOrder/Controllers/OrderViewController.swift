//
//  OrderViewController.swift
//  FarithulInzamam_MyOrder
//
//  Created by Inzi Hussain on 2021-05-17.
//

import UIKit

class OrderViewController: UIViewController {

    var order : Order!
    
    
    @IBOutlet private weak var quantittyTextField: UITextField!
    
    @IBOutlet private weak var coffeeTypeLabel: UILabel!
    
    @IBOutlet private weak var cupSizeLabel: UILabel!
    
    
    @IBOutlet private weak var coffeeSelectionView: UIView!
    
    @IBOutlet private weak var cupSelectionView: UIView!
    
    
    @IBOutlet private weak var orderButton: UIButton!
    
    var isEditingOrder = false
    
    var isInitialLoad = true
    
    
    private let DEFAULT_ORDER = Order(id: nil, quantity: -1, type: .original, size: .small, date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
        loadInitialData()
    }

    private func initialSetup()
    {
        let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(selectCoffeePressed))
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectCupPressed))
        
        coffeeSelectionView.addGestureRecognizer(gestureRecognizer1)
        cupSelectionView.addGestureRecognizer(gestureRecognizer2)
        
        
        quantittyTextField.keyboardType = .numberPad
        
        if order != nil
        {
            isEditingOrder = true
            self.navigationItem.title = "Edit"
            self.orderButton.setTitle("Edit Order", for: .normal)
        }
        else
        {
            //Setting Default Values
            order = Order(id: nil, quantity: -1, type: .original, size: .small, date: Date())
            self.navigationItem.title = "Order"
            self.orderButton.setTitle("Place Order", for: .normal)

        }
        
        if isInitialLoad
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Orders", style: .plain, target: self, action: #selector(showOrdersListVC))
        }

        
    }
    
    private func loadInitialData()
    {
        
        //Set Field Values
        quantittyTextField.text = order.quantity != -1 ? "\(order.quantity)" : nil
        coffeeTypeLabel.text = order.type.rawValue
        cupSizeLabel.text = order.size.rawValue.capitalized
        
    }
    
    @objc private func selectCoffeePressed()
    {
        
        self.quantittyTextField.resignFirstResponder()
        
        let message = (isEditingOrder ? "Change" : "Order") + "Your Coffee"
        
        let title = "Coffee"
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let coffees = CoffeeType.allCases.map ({ $0.rawValue })
        
        for element in coffees
        {
            actionSheet.addAction(UIAlertAction(title: element, style: .default, handler: { action in
                
                let coffeeType = CoffeeType(rawValue: element)
                
                self.order.type = coffeeType!
                
                self.coffeeTypeLabel.text = element.capitalized
                
            }))
            
            
        }
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @objc private func selectCupPressed()
    {
        
        self.quantittyTextField.resignFirstResponder()

        
        let message = (isEditingOrder ? "Change" : "Order") + "Your Cup"
        
        let title = "Cup Size"
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cups = CupSize.allCases.map ({ $0.rawValue })
        
        for element in cups
        {
            actionSheet.addAction(UIAlertAction(title: element, style: .default, handler: { action in
                
                let cup = CupSize(rawValue: element)
                
                self.order.size = cup!
                
                self.cupSizeLabel.text = element.capitalized
                
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction private func orderButtonClicked(_ sender: Any) {
        
        
        let str = quantittyTextField.text ?? ""
        
        let quantity = str != "" ? Int(str)! : -1
        
        
        
        guard quantity > 0 else {
            
            let alert = UIAlertController(title: "Invalid Value", message: "Quantity should be 1 or greater", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        order.quantity = quantity

        var isSuccess = false
        
        var alert : UIAlertController
        
        if isEditingOrder
        {
            isSuccess = FirebaseHelper.getInstance().editOrder(order: self.order)
            
            if isSuccess
            {
                alert = UIAlertController(title: "Success", message: "Order Edited Successfully", preferredStyle: .alert)
            }
            else
            {
                alert = UIAlertController(title: "Failure", message: "Error Processing Your Request", preferredStyle: .alert)
            }
            
        }
        else
        {
            order.date = Date() //To set th Time at the point of Ordering
            
            isSuccess = FirebaseHelper.getInstance().addOrder(order: self.order)
            
            if isSuccess
            {
                alert = UIAlertController(title: "Success", message: "Order Placed Successfully", preferredStyle: .alert)
                
                
                self.order = DEFAULT_ORDER
                self.loadInitialData()
            }
            else
            {
                alert = UIAlertController(title: "Failure", message: "Error Processing Your Request", preferredStyle: .alert)
            }
            
        }
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc private func showOrdersListVC()
    {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OrdersTableViewController") as! OrdersTableViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

