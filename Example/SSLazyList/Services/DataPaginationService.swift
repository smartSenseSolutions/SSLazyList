//
//  UserDataService.swift
//  LazyList-SwiftUI
//
//  Created by SmartSense Consulting Solutions Pvt. Ltd. on 17/05/24.
//

import Foundation

public class DataPaginationService {
    
    public struct PaginatedData<T> {
        var totalCount: Int
        var data: [T]
    }

    public static func paginateData<T>(dataList: [T], start: Int, length: Int) -> PaginatedData<T> {
        let totalCount = dataList.count
        guard start >= 0, length > 0, start < totalCount else {
            return PaginatedData(totalCount: totalCount, data: [])
        }
        
        let end = min(start + length, totalCount)
        let paginatedData = Array(dataList[start..<end])
        
        return PaginatedData(totalCount: totalCount, data: paginatedData)
    }
}
