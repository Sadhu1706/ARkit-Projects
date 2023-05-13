//
//  ContentView.swift
//  Firestore demo
//
//  Created by Sadhun Arun on 29/11/22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @ObservedObject var model = viewModel()
    
    @State var name = ""
    @State var hobby = ""
    var body: some View {
        VStack{
            List(model.list){item in
                Text(item.name)
            }
            Divider()
            VStack(spacing: 5){
                TextField("Name ", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Hobby ", text: $hobby)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    model.addData(name: name, hobby: hobby)
                    name = ""
                    hobby = ""
                }, label: {
                    Text("Add Todo item")
                })
            }
            .padding()
        }
    }
    init(){
        model.getData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
