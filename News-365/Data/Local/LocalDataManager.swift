//
//  LocalService.swift
//  News-365
//
//  Created by ahmed on 27/08/2023.
//

import Foundation
import CoreData
class LocalDataManager: IDataManager {
    
    //MARK: Fetch
    func fetch(searchedTitle: String, appDelegate : AppDelegate) -> [Article] {
        var articalArray: [Article] = []
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.shared.ENTITY_NAME)
      //  fetchRequest.predicate = NSPredicate(format: "title == %@", searchedTitle)
        
        do {
            let fetchedNewsArray = try managedContext.fetch(fetchRequest)
            for item in (fetchedNewsArray)
            {
                let title = item.value(forKey:"title") as? String
                let author = item.value(forKey: "author") as? String
                let image = item.value(forKey: "urlToImage") as? String
                let publishedAt = item.value(forKey: "publishedAt") as? String
                let description = item.value(forKey: "articalDescription") as? String
                let state = item.value(forKey: "artical_state") as? Bool
                let articalItem = Article(author: author , title: title , description: description, urlToImage: image , publishedAt: publishedAt, product_state: state)
                
                articalArray.append(articalItem)
            }
            print(articalArray.count)
        } catch let error {
            print("fetch all products error :", error)
        }
        return articalArray
    }
    
    //MARK: Delete
    func delete(appDelegate: AppDelegate, title: String , complition : (Error?) -> Void){
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.shared.ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            
            let product = try managedContext.fetch(fetchRequest)
            
            managedContext.delete((product as! [NSManagedObject]).first!)
            
            try managedContext.save()
            print("\(title) is Removed")
            complition(nil)
            
        } catch let error as NSError{
            complition("Error in deleting" as? Error )
            print("Error in deleting")
            print(error.localizedDescription)
        }
    }
    
    //MARK: Save
    func save(articale : Article, appDelegate : AppDelegate) -> Void
    {
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.shared.ENTITY_NAME, in: managedContext)
        let articalList = NSManagedObject(entity: entity!, insertInto: managedContext)
        articalList.setValue(articale.title ?? 0, forKey: "title")
        articalList.setValue(articale.author , forKey: "author")
        articalList.setValue(articale.urlToImage , forKey: "urlToImage")
        articalList.setValue(articale.description, forKey: "articalDescription")
        articalList.setValue(articale.publishedAt, forKey: "publishedAt")
        articalList.setValue(true , forKey: "artical_state")
        do{
            try managedContext.save()
            print("\(articalList.value(forKey: "title") ?? "xyz") is Added")
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    //MARK: Is Saved
    func isSaved(articalTitle: String, appDelegate : AppDelegate) -> Bool
    {
        var state : Bool = false
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.shared.ENTITY_NAME)

        fetchRequest.predicate = NSPredicate(format: "title == %@", articalTitle)
        
        do{
            let fetchedLeagueArray = try managedContext.fetch(fetchRequest)
            for item in (fetchedLeagueArray)
            {
                state = (item.value(forKey: "artical_state") as? Bool ?? false)
                print("\(state)")
            }
        }catch let error{
            print(error.localizedDescription)
        }
        if state == true
        {
            return true
        }
        else
        {
            return false
        }
    }
}
