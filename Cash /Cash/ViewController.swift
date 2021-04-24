//
//  ViewController.swift
//  Cash
//
//  Created by Bioo on 03.11.2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var totalLabel: UILabel!

    var account: Account!
    var context: NSManagedObjectContext!
    
    lazy var frc: SingleFetchedResultController<Account>? = SingleFetchedResultController(
        predicate: NSPredicate(format: "total != NULL"),
        managedObjectContext: context,
        onChange: { (account, changeType) in
            switch changeType {
            case .update:
                self.totalLabel.text = String(account.total)
            default:
                break
            }
        })

    private lazy var alertView: AlertView = {
        let alertView: AlertView = AlertView.loadFromNib()
        alertView.delegate = self
        return alertView
    }()

    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
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
        
        totalLabel.text = String(account?.total ?? 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVisualEffectView()
        try? frc?.performFetch()
    }

    private func saveSumm(description: String, summ: Double) {

        let operation = Operation(context: context)
            operation.date = Date()
            operation.amount = Int16(summ)
            operation.comment = description
            account.total += Int16(summ)
        

        let operations = account.operations?.mutableCopy() as? NSMutableOrderedSet
        operations?.add(operation)
        account.operations = NSSet(array: operations?.array ?? [])

        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func setupVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }

    func animateIn() {
        alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        alertView.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }
    }

    func animateOut() {
        UIView.animate(withDuration: 0.4,
            animations: {
                self.visualEffectView.alpha = 0
                self.alertView.alpha = 0
                self.alertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            }) { (_) in
            self.alertView.removeFromSuperview()
        }
    }

    func setAlert() {
        view.addSubview(alertView)
        alertView.center = view.center
    }

    @IBAction func pigAction(_ sender: Any) {
        setAlert()
        animateIn()
    }

}

extension ViewController: AlertDelegate {

    func leftButtonTapped() {
        animateOut()
        
        guard let sumText = alertView.summTextField.text, let comText = alertView.comTextField.text, let amount = Double(sumText) else { return }
        saveSumm(description: comText, summ: amount)
    }

    func rightButtonTapped() {
        animateOut()
        
        guard let sumText = alertView.summTextField.text, let comText = alertView.comTextField.text, let amount = Double(sumText) else { return }
        saveSumm(description: comText, summ: -amount)
    }
}

