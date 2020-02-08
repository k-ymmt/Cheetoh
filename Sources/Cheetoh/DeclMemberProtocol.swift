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
    public static func buildBlock() -> [DeclMemberProtocol] {
        return []
    }

    public static func buildBlock<Member: DeclMemberProtocol>(_ member: Member) -> DeclMemberProtocol {
        return member
    }
    
    public static func buildBlock(_ members: DeclMemberProtocol...) -> [DeclMemberProtocol] {
        return members
    }
}
