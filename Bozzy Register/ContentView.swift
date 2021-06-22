//
//  ContentView.swift
//  Bozzy Register
//
//  Created by vladukha on 17.06.2021.
//

import SwiftUI

struct ContentView: View {
	@State var order: [drink] = []
	var TotalPrice: ([drink])->Int = { menu in
		var total = 0
		for item in menu {
			total = total + item.price
		}
		return total
	}
	var body: some View {
		NavigationView {
			VStack {
				//список предметов в заказе
				ScrollView{
					ListOfItems(items: order, order: $order, remove: true)
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
	@Binding var order: [drink]
	var remove: Bool?
	var body: some View {
		VStack{
			ForEach(items, id: \.self) { item in
				Button {
					if (remove ?? false) {
						let removeIndex = order.firstIndex(where: {$0 == item})!
						order.remove(at: removeIndex)
					}
					else{
						order.append(item)
					}
					
				} label: {
					ItemBlock(item: item)
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
	@Binding var order: [drink]
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
