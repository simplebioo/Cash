//
//  Account+EntityNameProviding.swift
//  Cash
//
//  Created by Dmitriy Golubovskiy on 16.04.2021.
//

import Foundation

extension Account: EntityNameProviding {
    public static func entityName() -> String {
        entity().name ?? ""
    }
}
