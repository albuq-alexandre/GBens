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

    
    weak var dep : Dependencia?
    weak var usuario : Usuario?
    
    var from_user : String?
    
   
    var prefixo_fetchedResultsController : NSFetchedResultsController<Dependencia>?
    
    
    
    func pfx_fetchedResultsController() -> NSFetchedResultsController<Dependencia> {
        if let controller_pfx = prefixo_fetchedResultsController {
            return controller_pfx
        }
        
        let fetchRequest : NSFetchRequest<Dependencia> = Dependencia.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "prefixo", ascending: true)]
        fetchRequest.fetchBatchSize = 20
        fetchRequest.predicate = NSPredicate(format: "ANY inventariante.email == %@", (from_user)!)
        
        let controller_pfx = NSFetchedResultsController<Dependencia>(
            fetchRequest: fetchRequest,
            managedObjectContext: (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        
        controller_pfx.delegate = self
        
        try! controller_pfx.performFetch()
        
        prefixo_fetchedResultsController = controller_pfx
        
        return controller_pfx
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 163
        
        _ = pfx_fetchedResultsController()
        
        
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
        return pfx_fetchedResultsController().sections!.count
//    return 0
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [UITableViewRowAction(style: .default, title: "Delete", handler: { (action, ip) in
            print("asdads");    // FIXME: - Consertar a ação de deletar o inventário
        })]
    }

    
   
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return pfx_fetchedResultsController().sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let managedContext = (UIApplication.shared.delegate as! GBensAppDelegate).persistentContainer.viewContext
        
                    let fetchRequest : NSFetchRequest<Usuario> = Usuario.fetchRequest()
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
                    fetchRequest.fetchBatchSize = 10
        
                    fetchRequest.predicate = NSPredicate(format: "email == %@", self.from_user!) // FIXME: - Tratar se vazio.
                    var fetchedUser : [Usuario]
                    do {
        
                        fetchedUser = try managedContext.fetch(fetchRequest)
        
                    } catch {
                        fatalError("Falha ao encontrar usuário: \(error)")
        
                    }
        
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AccountSwitcherTableViewCell") as! AccountSwitcherTableViewCell
                    
                    cell.setupCell(theuser: fetchedUser[0])
                    
                    return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
        
            return 163
        } else {
            
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InventariosTableViewCell", for: indexPath) as! InventariosTableViewCell
            cell.setupCell(inventariada: pfx_fetchedResultsController().object(at: indexPath))
        
        
            return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dep = pfx_fetchedResultsController().object(at: indexPath)
//        self.performSegue(withIdentifier: "toInventarioDetalhe", sender: nil)
        
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
            case "toInventarioDetalhe":
                (segue.destination as! InventarioViewController).dep = self.pfx_fetchedResultsController().object(at: self.tableView.indexPathForSelectedRow!)
                
        
            default:
                break;
            }
   }

}
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
            (tableView.cellForRow(at: indexPath!) as! InventariosTableViewCell).setupCell(inventariada: anObject as! Dependencia)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

