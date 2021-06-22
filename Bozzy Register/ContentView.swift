//
//  ContentView.swift
//  Bozzy Register
//
//  Created by vladukha on 17.06.2021.
//

import SwiftUI

struct ContentView: View {
	@State var order: [drink:Int] = [:]
	@State var discount = ""
	var TotalPrice: ([drink:Int], Int)->Int = { menu, discount in
		var total = 0
		for item in menu {
			total = total + (item.key.price * item.value)
		}
		return (total - (total / 100 * discount))
	}
	var body: some View {
		NavigationView {
			VStack {
				//список предметов в заказе
				ScrollView{
					OrderList(items: Array(order.keys), order: $order)
				}
				
				//меню
				let midpoint = menu.count / 3
				let firstHalf = menu[..<midpoint]
				let secondHalf = menu[midpoint..<(midpoint*2)]
				let thirdHalf = menu[(midpoint*2)...]
				ScrollView{
				HStack{
					MenuList(Half: firstHalf, order: $order)
					MenuList(Half: secondHalf, order: $order)
					MenuList(Half: thirdHalf, order: $order)
					//Text("Custom")
				}
				}
				HStack{
					TextField("%", text: $discount)
						.keyboardType(.numberPad)
						.padding()
					Image(systemName: "keyboard.chevron.compact.down")
						.resizable()
						.frame(width: 30, height: 30)
						.padding()
						.onTapGesture{
							hideKeyboard()
						}
					NavigationLink(destination:
					CustomDrink(order: $order)
					) {
						VStack{
							Text("Custom")
								.foregroundColor(.primary)
								.padding()
						}
						.border(Color.gray, width: 1.0)
					}
					Button {
						order.removeAll()
						discount = ""
					} label: {
						Text("Reset")
					}
				}
			}
			.navigationBarTitle(String(TotalPrice(order, Int(discount) ?? 0)))
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

struct CustomDrink: View {
	@Binding var order: [drink:Int]
	@State var Name = ""
	@State var Price = ""
	
	var body: some View
	{
		VStack{
			TextField("Name", text: $Name)
			TextField("Price", text: $Price)
				.keyboardType(.numberPad)
			Button {
				let Drink: drink = drink(id: 200, name: Name, price: Int(Price) ?? 1)
				order[Drink] = 1
			} label: {
				Text("Reset")
			}
		}
	}
}



struct ListOfItems: View {
	var items: [drink]
	@Binding var order: [drink:Int]
	var body: some View {
		HStack{
			let midpoint = items.count / 2
			let firstHalf = items[..<midpoint]
			let secondHalf = items[midpoint...]
			VStack{
			ForEach(firstHalf, id: \.self) { item in
				Button {
					order[item] = 1 //append(item)
				} label: {
					ItemBlock(item: item)
				}
			}
			}
			VStack{
			ForEach(secondHalf, id: \.self) { item in
				Button {
					order[item] = 1 //append(item)
				} label: {
					ItemBlock(item: item)
				}
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

extension View {
	func hideKeyboard() {
		UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
