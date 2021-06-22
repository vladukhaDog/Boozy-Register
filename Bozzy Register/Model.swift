//
//  Model.swift
//  Bozzy Register
//
//  Created by vladukha on 17.06.2021.
//

import Foundation

struct Category: Hashable, Codable
{
	var id: Int
	var name: String
	var list: [drink]
}

struct drink: Hashable, Codable
{
	var id: Int
	var name: String
	var price: Int
}

var menu: [Category] = load("Menu.json")








func load<T: Decodable>(_ filename: String) -> T {
	let data: Data

	guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
		else {
			fatalError("Couldn't find \(filename) in main bundle.")
	}

	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}

	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}
