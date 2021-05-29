//
//  DeclMemberProtocol.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/05.
//

import Foundation
import SwiftSyntax

public protocol DeclMemberProtocol {
    func buildDeclMember(format: Format) -> DeclSyntax
}

@resultBuilder
public struct DeclMemberListBuilder {
    public static func buildBlock(_ members: DeclMemberProtocol...) -> [DeclMemberProtocol] {
        return members
    }

    public static func buildOptional(_ members: [DeclMemberProtocol]?) -> [DeclMemberProtocol] {
        return members ?? []
    }

    public static func buildEither(first members: [DeclMemberProtocol]) -> [DeclMemberProtocol] {
        return members
    }

    public static func buildEither(second members: [DeclMemberProtocol]) -> [DeclMemberProtocol] {
        return members
    }

    public static func buildArray(_ members: [[DeclMemberProtocol]]) -> [DeclMemberProtocol] {
        return Array(members.joined())
    }
}
