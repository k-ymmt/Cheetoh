//
//  AvailableAttribute.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/27.
//

import Foundation
import SwiftSyntax

public struct AvailableAttribute: Attribute {
    public enum Platform: String {
        case iOS
        case iOSApplicationExtension
        case macOS
        case macOSApplicationExtension
        case macCatalyst
        case macCatalystApplicationExtension
        case watchOS
        case watchOSApplicatonExtension
        case tvOS
        case tvOSApplicationExtension
        case swift
        case asterisk = "*"
    }

    public struct Version {
        public let major: Int
        public let minor: Int
        public let patch: Int?

        public init(major: Int, minor: Int, patch: Int? = nil) {
            self.major = major
            self.minor = minor
            self.patch = patch
        }
    }

    public let platform: Platform
    public let version: Version?
    public let unavailable: Bool
    public let introduced: Version?
    public let deprecated: Version?
    public let obsoleted: Version?
    public let message: String?
    public let renamed: String?

    public init(_ platform: Platform, version: Version) {
        self.platform = platform
        self.version = version

        self.unavailable = false
        self.introduced = nil
        self.deprecated = nil
        self.obsoleted = nil
        self.message = nil
        self.renamed = nil
    }

    public init(
        _ platform: Platform,
        unavailable: Bool = false,
        introduced: Version? = nil,
        deprecated: Version? = nil,
        obsoleted: Version? = nil,
        message: String? = nil,
        renamed: String? = nil
    ) {
        self.platform = platform
        self.version = nil
        self.unavailable = unavailable
        self.introduced = introduced
        self.deprecated = deprecated
        self.obsoleted = obsoleted
        self.message = message
        self.renamed = renamed
    }

    public func buildAttribute(format: Format) -> Syntax {
        Syntax(AttributeSyntax {
            $0.useAtSignToken(SyntaxFactory.makeAtSignToken().withLeadingTrivia(.spaces(format.base)))
            $0.useAttributeName(SyntaxFactory.makeIdentifier("available"))
            $0.useLeftParen(SyntaxFactory.makeLeftParenToken())

            $0.useArgument(Syntax(AvailabilityConditionSyntax {
                if let version = version {
                    $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                        $0.useEntry(Syntax(AvailabilityVersionRestrictionSyntax {
                            $0.usePlatform(platform.syntax.withTrailingTrivia(.spaces(1)))
                            $0.useVersion(version.syntax)
                        }))

                        if platform != .swift {
                            $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                        }
                    })

                    if platform != .swift {
                        $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                            $0.useEntry(Syntax(SyntaxFactory.makeIdentifier("*")))
                        })
                    }
                } else {
                    $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                        $0.useEntry(Syntax(platform.syntax))
                        $0.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingTrivia(.spaces(1)))
                    })

                    if let introduced = introduced {
                        $0.addAvailabilityArgument(
                            AvailabilityArgumentSyntax {
                                $0.useEntry(
                                    Syntax(
                                        makeLabeledArgument(label: "introduced", value: Syntax(introduced.syntax))
                                    )
                                )
                                if unavailable || deprecated != nil || obsoleted != nil || message != nil || renamed != nil {
                                    $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                                }
                            }
                        )
                    }

                    if unavailable {
                        $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                            $0.useEntry(Syntax(SyntaxFactory.makeIdentifier("unavailable")))

                            if deprecated != nil || obsoleted != nil || message != nil || renamed != nil {
                                $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                            }
                        })
                    }

                    if let deprecated = deprecated {
                        $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                            $0.useEntry(Syntax(makeLabeledArgument(
                                label: "deprecated",
                                value: Syntax(deprecated.syntax)
                            )))

                            if obsoleted != nil || message != nil || renamed != nil {
                                $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                            }
                        })
                    }

                    if let obsoleted = obsoleted {
                        $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                            $0.useEntry(Syntax(makeLabeledArgument(
                                label: "obsolated",
                                value: Syntax(obsoleted.syntax)
                            )))

                            if message != nil || renamed != nil {
                                $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                            }
                        })
                    }

                    if let message = message {
                        $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                            $0.useEntry(Syntax(makeLabeledArgument(
                                label: "message",
                                value: Syntax(SyntaxFactory.makeStringLiteralExpr(message))
                            )))

                            if renamed != nil {
                                $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                            }
                        })
                    }

                    if let renamed = renamed {
                        $0.addAvailabilityArgument(AvailabilityArgumentSyntax {
                            $0.useEntry(Syntax(makeLabeledArgument(
                                label: "renamed",
                                value: Syntax(SyntaxFactory.makeStringLiteral(renamed))
                            )))
                        })
                    }
                }
            }))

            $0.useRightParen(SyntaxFactory.makeRightParenToken(leadingTrivia: .zero, trailingTrivia: .newlines(1)))
        })
    }
}

extension AvailableAttribute {
    public init(_ platform: Platform, _ major: Int, _ minor: Int, _ patch: Int? = nil) {
        self.init(platform, version: Version(major: major, minor: minor, patch: patch))
    }
}

private extension AvailableAttribute {
    func makeLabeledArgument(label: String, value: Syntax) -> AvailabilityLabeledArgumentSyntax {
        AvailabilityLabeledArgumentSyntax {
            $0.useLabel(SyntaxFactory.makeIdentifier(label))
            $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            $0.useValue(value)
        }
    }
}

private extension AvailableAttribute.Platform {
    var syntax: TokenSyntax {
        SyntaxFactory.makeIdentifier(rawValue)
    }
}

private extension AvailableAttribute.Version {
    var syntax: VersionTupleSyntax {
        VersionTupleSyntax {
            $0.useMajorMinor(Syntax(SyntaxFactory.makeIdentifier("\(major).\(minor)")))
            if let patch = patch {
                $0.usePatchPeriod(SyntaxFactory.makePeriodToken())
                $0.usePatchVersion(SyntaxFactory.makeIdentifier("\(patch)"))
            }
        }
    }
}
