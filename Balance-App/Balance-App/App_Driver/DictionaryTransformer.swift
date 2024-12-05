//
//  DictionaryTransformer.swift
//  Balance-App
//
//  Created by user264048 on 12/4/24.
//


import Foundationclass DictionaryTransformer: ValueTransformer {    override func transformedValue(_ value: Any?) -> Any? {        guard let dictionary = value as? [Int: Double] else { return nil }        return try? JSONEncoder().encode(dictionary)    }    override func reverseTransformedValue(_ value: Any?) -> Any? {        guard let data = value as? Data else { return nil }        return try? JSONDecoder().decode([Int: Double].self, from: data)    }    static func register() {        let transformerName = NSValueTransformerName("DictionaryTransformer")        ValueTransformer.setValueTransformer(DictionaryTransformer(), forName: transformerName)    }}