//
//  modelView.swift
//  Firestore demo
//
//  Created by Sadhun Arun on 29/11/22.
//

import Foundation
import Firebase

class viewModel: ObservableObject{
    @Published var list = [dataModel]()
    
    func deleteData(todoDelete: dataModel){
        //create database reference
        let db = Firestore.firestore()
        //spcify the document to delete
        db.collection("todos").document(todoDelete.id).delete { error in
            if error == nil{
                DispatchQueue.main.async {
                    self.list.removeAll { todo in
                        return todo.id == todoDelete.id
                    }
                }
            }
        }
    }
    
    func addData(name: String, hobby: String){
        //get reference to the database
        let db = Firestore.firestore()
        //add document to a collection
        db.collection("todos").addDocument(data: ["name": name, "hobby": hobby]) { error in
            if error == nil{
                self.getData()
            }
            else{
                //handle the error
            }
        }
    }
    
    func getData(){
        //reference to the database
        let db = Firestore.firestore()
        //read the documents at the specific path
        db.collection("todos").getDocuments { snapshot, error in
            // check for the erros
            if error == nil {
                //no erros
                if let snapshot = snapshot{
                    //get all the documents
                    DispatchQueue.main.async {
                        self.list = snapshot.documents.map { d in
                            return dataModel(id: d.documentID,
                                             name: d["name"] as? String ?? "", hobby: d["hobby"] as? String ?? "")
                        }
                    }
                }
            }
            else{
                
            }
        }
        
    }
}
