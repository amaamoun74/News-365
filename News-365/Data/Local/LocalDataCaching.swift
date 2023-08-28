//
//  LocalDataManager.swift
//  News-365
//
//  Created by ahmed on 27/08/2023.
//

import Foundation
class DataManager: IDataManager {
    let dbManger = DataCaching.sharedInstance
    
    func fetchSavedProducts(userId: Int, appDelegate: AppDelegate, completion: @escaping (([Products]?, Error?) -> Void)) {
        completion(dbManger.fetchSavedProducts(userId: userId, appDelegate: appDelegate), "Fetching Saved Leagues Error" as? Error)
    }
    func deleteProductFromFavourites(userId: Int, appDelegate: AppDelegate, ProductID: Int, completion: (Error?) -> Void) {
        dbManger.deleteProductFromFavourites(userId: userId, appDelegate: appDelegate, product_id: ProductID ) { _ in
              
          }

    }
    
    func saveProductToFavourites(userId: Int, appDelegate: AppDelegate, product: Products) {
        dbManger.saveProductToFavourites(userId: userId, product: product, appDelegate: appDelegate)
    }
    
    func isFavourite(userId: Int, appDelegate: AppDelegate, productID: Int) -> Bool {
        dbManger.isFavouriteProduct(userId: userId, productID: productID,  appDelegate: appDelegate)

    }
    
}

