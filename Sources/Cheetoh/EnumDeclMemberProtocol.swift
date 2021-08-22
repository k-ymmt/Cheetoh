//
//  EnumDeclMemberProtocol.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/22.
//

import Foundation
import SwiftSyntax

public protocol EnumDeclMemberProtocol {
    func buildDeclMember(format: Format) -> DeclSyntax
}

@resultBuilder
public struct EnumDeclMemberListBuilder {
    public static func buildBlock(_ members: [EnumDeclMemberProtocol]...) -> [EnumDeclMemberProtocol] {
        return Array(members.joined())
    }

    public static func buildOptional(_ members: [EnumDeclMemberProtocol]?) -> [EnumDeclMemberProtocol] {
        return members ?? []
    }

    public static func buildEither(first members: [EnumDeclMemberProtocol]) -> [EnumDeclMemberProtocol] {
        return members
    }

    public static func buildEither(second members: [EnumDeclMemberProtocol]) -> [EnumDeclMemberProtocol] {
        return members
    }

    public static func buildExpression(_ member: EnumDeclMemberProtocol) -> [EnumDeclMemberProtocol] {
        return [member]
    }

    public static func buildArray(_ members: [[EnumDeclMemberProtocol]]) -> [EnumDeclMemberProtocol] {
        return Array(members.joined())
    }
}
