//
//  UserEndpoint.swift
//  BakeRoad
//
//  Created by 이현호 on 7/13/25.
//

import Foundation

enum UserEndpoint {
    static let onboarding = "/users/me/onboarding"
    static let userInfo = "/users/info"
    static let getMyReviews = "/users/me/reviews"
    static let userPreference = "/users/preferences"
    static let userProfile = "/users/me"
    static let breadReportList = "/users/me/bread-report/monthly"
    static let breadReport = "/users/me/bread-report"
    
    static func badgeRepresent(_ id: Int) -> String {
        return "/users/me/badges/\(id)/represent"
    }
    static func badgeDerepresent(_ id: Int) -> String {
        return "/users/me/badges/\(id)/derepresent"
    }
}
