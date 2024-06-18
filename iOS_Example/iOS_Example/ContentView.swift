//
//  ContentView.swift
//  iOS_Example
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import SwiftUI
import SSLazyList

struct ContentView: View {
    
    let localDb =  (1...100).map { Record(id: $0, value: "Record \($0)") }
    
    @State var start : Int = 0
    @State var length : Int = 20
    
    @State private var records : [Record]? = nil{
        didSet{
            start = records?.count ?? 0
        }
    }
    
    
    struct DisaplyDraggingView : View {
        var title : String
        
        var body: some View{
            VStack(alignment: .center) {
                //Image("header", bundle: .main).resizable().scaledToFit()
                Text(title)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
        }
    }
    
    var progressView  : some View {
        ProgressView().scaleEffect(CGSize(width: 1.5, height: 1.5)).foregroundColor(.white).frame(height: 50).animation(nil, value: UUID())
    }

    var config : SSConfigLazyList {
        
        let configuration = SSConfigLazyList(animator: .auto(.bouncy, .always))
        
        /*
        configuration.setReloadType(viewType: SSPullToRefresh(displayView: {
            AnyView(DisaplyDraggingView(title: "Pull-Down to Refresh"))
        }, loadingView: {
            AnyView(ZStack{
                progressView
            })
        }, onTrigger: { allowAgain in
            print("refresh action")

            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                self.start = 0
                self.records = DataPaginationService.paginateData(dataList: localDb, start: start, length: length).data
                allowAgain(true)
            })
        }))
        
        configuration.setLoadMoreType(viewType: SSLoadMore(type: .onPullUp, displayView: {
            AnyView(DisaplyDraggingView(title: "Pull-Up to Load More"))
        }, loadingView: {
            AnyView(ZStack{
                progressView
            })
        }, onTrigger: { hasMoreRecords in
            print("page loading action")
            if self.records != nil{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.records!.append(contentsOf: DataPaginationService.paginateData(dataList: localDb, start: start, length: length).data)

                    hasMoreRecords(self.records!.count < localDb.count)
                })
            }else{
                hasMoreRecords(false)
            }
        }))
        */
        configuration.setLoadingView(viewType: .system)
        configuration.setNoDataView(viewType: .system)
        
        return configuration
    }
    
    var body: some View {
        
        NavigationView {
            SSLazyList(data: records, rowContent: { record in
                VStack{
                    Spacer(minLength: 10)
                    Text(record.value).font(.title)
                }
                
            }, configuration: config)
            .listStyle(.plain)
            .navigationTitle("SSLazyList")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(){
            Task {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: DispatchWorkItem(block: {
                    self.records = DataPaginationService.paginateData(dataList: localDb, start: start, length: length).data
                }))
            }
        }
    }
}

// Struct to represent a single record
struct Record: Identifiable {
    let id: Int
    let value: String
}

#Preview {
    ContentView()
}
