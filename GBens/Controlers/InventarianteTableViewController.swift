//
//  InventarianteTableViewController.swift
//  GBens
//
//  Created by Alexandre de Sousa Albuquerque on 10/05/17.
//  Copyright © 2017 Alexandre de Sousa Albuquerque. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData


class InventarianteTableViewController: UITableViewController {

    
    weak var theuser : Usuario?
    var from_user : User?
    weak var thePrefixo : Dependencia?
    
    var usuario_fetchedResultsController : NSFetchedResultsController<Usuario>?
    
    
    
    func fetchedResultsController() -> NSFetchedResultsController<Usuario> {
        if let controller = usuario_fetchedResultsController {
            return controller
        }
        
        let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        fetchRequest.fetchBatchSize = 10
//        fetchRequest.predicate = NSPredicate(format: "email == %@", from_user!.email!) // FIXME: - Tratar se vazio.
        

        let controller = NSFetchedResultsController<Usuario>(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext(),
            sectionNameKeyPath: "nome",
            cacheName: "TabelaInventariadas")
        
        
        controller.delegate = self
        
        try! controller.performFetch()
        
        usuario_fetchedResultsController = controller
        
        return controller
    }

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 163
        
        var _ = fetchedResultsController()
        
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController().sections!.count
//    return 0
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .default, title: "Delete", handler: { (action, ip) in
            print("asdads");    // FIXME: - Consertar a ação de deletar o inventário
        })]
    }

    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
        
        return fetchedResultsController().sections![section].numberOfObjects
        //    return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
//            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "AccountSwitcherTableViewCell")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSwitcherTableViewCell", for: indexPath) as! AccountSwitcherTableViewCell
            cell.setupCell(theuser: fetchedResultsController().object(at: indexPath))
            
            return cell
        }
         else {
//            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "InventariosTableViewCell")
            //set the data here
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventariosTableViewCell", for: indexPath) as! InventariosTableViewCell
            cell.setupCell(theuser: fetchedResultsController().object(at: indexPath))
            
            return cell
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InventarianteTableViewController : NSFetchedResultsControllerDelegate {
    
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
            (tableView.cellForRow(at: indexPath!) as! InventariosTableViewCell).setupCell(theuser: anObject as! Usuario)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

