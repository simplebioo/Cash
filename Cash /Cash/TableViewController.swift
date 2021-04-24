//
//  SecondViewController.swift
//  Cash
//
//  Created by Bioo on 05.11.2020.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var operations: [Operation]!
    var account: Account!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "MMM d, h:mm"
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let operationFetchRequest: NSFetchRequest<Operation> = Operation.fetchRequest()
        let accountFetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

        do {
            operations = try context.fetch(operationFetchRequest)
            
            let results = try context.fetch(accountFetchRequest)
            if results.isEmpty {
                account = Account(context: context)
                account.total
                    = 0
                try context.save()
            } else {
                account = results.first
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return operations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CashCell
          
        let operation = operations[indexPath.row]
        
        cell.commLabel.text = operation.comment
        cell.summLabel.text = String(operation.amount)
        cell.dateLabel.text = dateFormatter.string(from: operation.date!)


        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard editingStyle == .delete else { return }
        let operation = operations.remove(at: indexPath.row)
        
        context.delete(operation)
        
        account.total -= operation.amount
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

