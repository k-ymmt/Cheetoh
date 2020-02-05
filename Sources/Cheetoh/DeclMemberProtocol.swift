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

@_functionBuilder
public struct DeclMemberListBuilder {
    public static func buildBlock(_ members: DeclMemberProtocol...) -> DeclMemberList {
        return DeclMemberList(members: members)
    }
    public static func buildExpression(_ member: DeclMemberProtocol) -> DeclMemberList {
        return DeclMemberList(members: [member])
    }
}

public struct DeclMemberList {
    private let members: [DeclMemberProtocol]
    public init(members: [DeclMemberProtocol]) {
        self.members = members
    }
    
    public func build(format: Format) -> [DeclSyntax] {
        return members.map { $0.buildDeclMember(format: format) }
    }
}
