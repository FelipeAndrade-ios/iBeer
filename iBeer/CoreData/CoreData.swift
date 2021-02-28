//
//  CoreData.swift
//  iBeer
//
//  Created by Felipe Andrade on 26/02/21.
//

import UIKit
import CoreData

class CoreData {
    static let shared = CoreData()
    weak var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let entityName = "BeerModelCoreData"
    
    func saveData(model: RepositoryModel) {
        guard let context = context else { return }
        deleteAllData()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(encodeData(data: model), forKey: "beerData")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getData() -> RepositoryModel? {
        guard let context = context else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        let results = try? context.fetch(request) as? [NSManagedObject]
        
        if results!.count > 0 {
            for result in results! {
                let data = result.value(forKey: "beerData") as? Data
                return decodeData(data: data, model: RepositoryModel.self)
            }
            return nil
        } else {
            return nil
        }
    }
    
    func decodeData<T: Decodable>(data: Data?, model: T.Type) -> T? {
        if let data = data {
            let model = try? JSONDecoder().decode(T.self, from: data)
            return model
        } else {
            return nil
        }
    }
    
    func encodeData<T: Encodable>(data: T) -> Data? {
        let data = try? JSONEncoder().encode(data)
        return data
    }
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        guard let results = try? context?.fetch(fetchRequest) else { return }
        for object in results {
            guard let objectData = object as? NSManagedObject else { continue }
            context?.delete(objectData)
        }
    }
}
