//
//  CategoryTableViewController.swift
//  ToDoL
//
//  Created by mac on 1/9/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    var CategArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCateg()

    }
    
    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = CategArray[indexPath.row]
        
        cell.textLabel?.text = category.name
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategArray.count
    }
    

    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.CategArray.append(newCat)
            self.saveCategories()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new category ..."
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Data Manipulation Methods
    
    func saveCategories(){
        do {
            try context.save()
        }catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCateg(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            CategArray = try context.fetch(request)
        }catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = CategArray[indexPath.row]
        }
    }
    
}
    
    
    

    
  


