//
//  NoticeRepository.swift
//  BakeRoad
//
//  Created by 이현호 on 9/3/25.
//

import Foundation

protocol NoticeRepository {
    func getNotice() async throws -> [Notice]
}
