//
//  Article.swift
//  tonkotsu_ramen
//
//  Created by 宮本光直 on 2021/06/10.
//

import Foundation

struct Article: Codable {
    let url: String
    let title: String
    let user: User
}

struct User: Codable {
    let name: String
    let profile_image_url: String
}
