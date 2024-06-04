//
//  ViewController.swift
//  Challenge2
//
//  Created by Olha Pylypiv on 22.01.2024.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
 
        title = "My shopping list"

        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let shareList = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(askClearList))
        navigationItem.rightBarButtonItems = [shareList, addItem]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = shoppingList[indexPath.row]
        
        let ac = UIAlertController(title: "Delete item?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.shoppingList.remove(at: indexPath.row)
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add to shopping list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add item", style: .default) {
            [weak self, weak ac] action in
            guard let shoppingItem = ac?.textFields?[0].text else {return}
            self?.submit(shoppingItem)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        guard !shoppingList.isEmpty else {return}
        let list = "My shopping list:\n - " + shoppingList.joined(separator: "\n - ")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func submit(_ shoppingItem: String) {
        shoppingList.insert(shoppingItem, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func clearList(action: UIAlertAction!) {
        shoppingList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func askClearList() {
        let ac = UIAlertController(title: "Delete this shopping list?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: clearList))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

