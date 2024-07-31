//
//  Area.swift
//
//
//  Created by Aung Ko Min on 31/7/24.
//

import Foundation

public protocol StringViewRepresentable: Codable, Hashable, RawRepresentable, Identifiable, Equatable, CaseIterable {
    var id: RawValue { get }
}

public extension StringViewRepresentable {
    var id: String { "\(rawValue)" }
    var title: String {
        if id == "Any" { return "" }
        return id.components(separatedBy: "_").joined(separator: " ")
    }
    var typeName: String { "\(type(of: self))" }
    static var allCasesExpectEmpty: [Self] { Self.allCases.filter { $0.id != "Any" } }
}

public enum Area: String, StringViewRepresentable {
    public static var empty: Area { .Any }
    case `Any`, Bishan, Bukit_Batok, Bukit_Merah, Bukit_Panjang, Bukit_Timah, Central_Water_Catchment, Changi, Changi_Bay, Choa_Chu_Kang, Clementi, Geylang, Novena, Pasir_Ris, Paya_Lebar, Seletar, Sembawang, Bedok, Boon_Lay, Sengkang, Serangoon, Ang_Mo_Kio, Tengah, Toa_Payoh, Western_Water_Catchment, Yishun, Downtown_Core, Marina_East, Newton, Orchard, Woodlands, Marina_South, Museum, Hougang, Juront_East, Lim_Chu_Kang, Mandai, Marine_Parade, North_Eastern_Islands, Pioneer, Punggol, Queenstown, South_Islands, Tuas, Jurong_West, Kallang, Simpang, Sungei_Kadut, Tampines, Western_Islands, Tanglin, Outram, River_Velly, Rocher, Singapore_River, Straits_View
    public init?(
        string: String
    ) {
        let rawValue = string.components(
            separatedBy: " "
        ).map{
            $0.capitalized
        }.joined(
            separator: "_"
        )
        self.init(
            rawValue: rawValue
        )
    }
}
