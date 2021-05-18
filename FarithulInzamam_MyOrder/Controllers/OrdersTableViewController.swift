//
//  OrdersTableViewController.swift
//  FarithulInzamam_MyOrder
//
//  Created by Inzi Hussain on 2021-05-17.
//

import UIKit

class OrdersTableViewController: UITableViewController {

    
    private var orders : [Order] = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "My Orders"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddPage))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders()

    }

    private func fetchOrders()
    {
        FirebaseHelper.getInstance().getOrders { orders in
            self.orders = orders
            
            self.tableView.reloadData()
            
        }
    }
    
    
    @objc private func showAddPage()
    {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        
        vc.isInitialLoad = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Table view data source





}

extension OrdersTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let order = self.orders[indexPath.row]
        cell.textLabel?.text = order.type.rawValue
        cell.detailTextLabel?.text = order.size.rawValue + " - \(order.quantity)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = self.orders[indexPath.row].id!
            FirebaseHelper.getInstance().deleteOrder(id: id) { isDeleted in
                
                if isDeleted
                {
                    self.orders.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: "Order Could not be deleted", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }
            
           
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row clicked")
        
        
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
        
        vc.isInitialLoad = false
        
        vc.order = self.orders[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}

