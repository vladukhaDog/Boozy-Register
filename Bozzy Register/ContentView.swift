//
//  ContentView.swift
//  Bozzy Register
//
//  Created by vladukha on 17.06.2021.
//

import SwiftUI

struct ContentView: View {
	@State var order: [drink:Int] = [:]
	var TotalPrice: ([drink:Int])->Int = { menu in
		var total = 0
		for item in menu {
			total = total + (item.key.price * item.value)
		}
		return total
	}
	var body: some View {
		NavigationView {
			VStack {
				//список предметов в заказе
				ScrollView{
					OrderList(items: Array(order.keys), order: $order)
				}
				
				//меню
				let midpoint = menu.count / 2
				let firstHalf = menu[..<midpoint]
				let secondHalf = menu[midpoint...]
				HStack{
					MenuList(Half: firstHalf, order: $order)
					MenuList(Half: secondHalf, order: $order)
					Text("Custom")
				}
				
			}
			.navigationBarTitle(String(TotalPrice(order)))
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}



struct ListOfItems: View {
	var items: [drink]
	@Binding var order: [drink:Int]
	var body: some View {
		VStack{
			ForEach(items, id: \.self) { item in
				Button {
					order[item] = 1 //append(item)
				} label: {
					ItemBlock(item: item)
				}
				
			}
		}
	}
}


struct OrderList: View {
	var items: [drink]
	let imageSize: CGFloat = 30.0
	@Binding var order: [drink:Int]
	var body: some View {
		VStack{
			ForEach(items, id: \.self) { item in
				HStack{
					Button {
						let removeIndex = order.firstIndex(where: {$0.key == item})!
						order.remove(at: removeIndex)
					} label: {
						Image(systemName: "trash")
							.resizable()
							.frame(width: imageSize, height: imageSize)
							.accentColor(.red)
					}
					ItemBlock(item: item)
					Button {
						if (order[item]! > 1) {
							order[item] = order[item]! - 1
						}
					} label: {
						Image(systemName: "minus.circle")
							.resizable()
							.frame(width: imageSize, height: imageSize)
					}
					Text(String(order[item]!))
					
					Button {
							order[item] = order[item]! + 1
					} label: {
						Image(systemName: "plus.circle")
							.resizable()
							.frame(width: imageSize, height: imageSize)
					}
				}
			}
		}
	}
}

struct ItemBlock: View {
	var item: drink
	var body: some View {
		VStack{
			HStack{
				Text(item.name)
				Text(String(item.price))
			}
			.padding()
		}
		.cornerRadius(10.0)
		.border(Color.gray, width: 1.0)
	}
}


struct MenuList: View {
	var Half: Array<Category>.SubSequence
	@Binding var order: [drink:Int]
	var body: some View {
		VStack{
			ForEach(Half, id: \.self) { category in
				NavigationLink(destination:
								ScrollView{
									ListOfItems(items: category.list, order: $order)}
				) {
					VStack{
						Text(category.name)
							.foregroundColor(.primary)
							.padding()
					}
					.border(Color.gray, width: 1.0)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
