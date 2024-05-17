//
//  ContentView.swift
//  iOS_Example
//
//  Created by Kalpesh on 17/05/24.
//

import SwiftUI
import SSLazyList

struct ContentView: View {
    
    @State private var users : [UserModel]?;
    var config : SSConfigLazyList {
        let configuration = SSConfigLazyList(animator: .fromRight(.bouncy))
        configuration.setLoadingView(viewType: .system)
        configuration.setNoDataView(viewType: .system)
        return configuration
    }
    
    var body: some View {
        NavigationView {
            SSLazyList(data: users, rowContent: { UserModel in
                UserDetailCell(UserModel: UserModel)
            },configuration: config)
            .listStyle(.plain)
            .navigationTitle("UserModel List")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear(){
            Task {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: DispatchWorkItem(block: {
                    users = UserDataService.users()
                }))
            }
        }
    }
}

struct UserDetailCell : View{
    let UserModel : UserModel
    
    init(UserModel: UserModel) {
        self.UserModel = UserModel
    }
    var body: some View{
        VStack(alignment: .leading, content: {
            HStack{
                Text(UserModel.name).font(.title2).bold()
                Spacer()
                Text(UserModel.address).foregroundColor(.blue)
            }.padding(1)
            Text("Phone : \(UserModel.phone)").padding(1)
            Text("Email : \(UserModel.email)").padding(1)
        })
    }
}


#Preview {
    ContentView()
}
