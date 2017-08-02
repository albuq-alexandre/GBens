//
//  ListaBensTableViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 10/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import CoreData

class ListaBensTableViewController: UITableViewController {

    @IBAction func unwindToLista(segue: UIStoryboardSegue) {}
    
    weak var _bem : Bem?
    
    var _fetchedResultsControler : NSFetchedResultsController<Bem>?
    
    func fetchedResultsController() -> NSFetchedResultsController<Bem> {
        if let controller = _fetchedResultsControler {
            return controller
        }
        
        let fetchRequest : NSFetchRequest<Bem> = Bem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "codBem", ascending: true)]
        fetchRequest.fetchBatchSize = 20
        
        
        let controller = NSFetchedResultsController<Bem>(
            fetchRequest: fetchRequest,
            managedObjectContext: (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext,
            sectionNameKeyPath: "dep_owner.prefixo",
            cacheName: "tabelaBens")
        
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        _fetchedResultsControler = controller
        
        return controller
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var _ = fetchedResultsController()
        tableView.reloadData()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        (UIApplication.shared.delegate as! GBensAppDelegate).saveContext()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController().sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController().sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bemTableViewCell", for: indexPath) as! bemTableViewCell
        cell.setupCell(_bem: fetchedResultsController().object(at: indexPath))
        
        return cell
    }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self._bem = fetchedResultsController().object(at: indexPath)
            
        }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if let identifier = segue.identifier{
            switch identifier {
            case "DetalhesBemSegue":
                (segue.destination as! BemViewController)._bem = self.fetchedResultsController().object(at: self.tableView.indexPathForSelectedRow!)
            default:
                break;
            }
        }
    }
}
extension ListaBensTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let fetchRequest = fetchedResultsController().fetchRequest
        if (searchText == "") {
            fetchRequest.predicate = nil
        } else {
            fetchRequest.predicate = NSPredicate(format: "codBem contains %@", searchText, ["","",""])
            
        }
        try! fetchedResultsController().performFetch()
        tableView.reloadData()
    }
}

extension ListaBensTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
        
    }
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            if let cell = (tableView.cellForRow(at: indexPath!) as? bemTableViewCell) {
                cell.setupCell(_bem: anObject as! Bem)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

