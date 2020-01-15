//
//  CategoryTableViewController.swift
//  ToDoL
//
//  Created by mac on 1/9/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCateg()
        tableView.separatorStyle = .none

    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    

    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textField.text!
            newCat.colour = UIColor.randomFlat.hexValue()
          
            self.save(category: newCat)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category ..."
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Data Manipulation Methods
    
    func save(category : Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCateg(){

     categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categDeleted = self.categories?[indexPath.row] {
            do{
              try self.realm.write {
                self.realm.delete(categDeleted)
                }
                }catch {
                print("error deleting category \(error)")
                }
                }
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories?[indexPath.row]
        }
    }
}



    
    

    
  


