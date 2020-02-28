//
//  ContentView.swift
//  SwiftUI Sliders
//
//  Created by Eric Dolecki on 2/28/20.
//  Copyright © 2020 Eric Dolecki. All rights reserved.
//

import SwiftUI
 
struct ContentView: View {
    
    @State private var celsius: Double = 0
    
    var body: some View {
        VStack {
            Spacer()
            Sliders()
                .padding(.bottom, 50)
            Slider(value: $celsius, in: -100...100, step: 1.0)
            Text("\(celsius, specifier: "%.0f")°C = \(celsius * 9 / 5 + 32, specifier: "%.0f")°F")
        }.padding()
    }
}

struct Sliders: View {

    @State var value1 = 100.0
    @State var value2 = 0.0
    @State var value3 = 0.0
    @State var value4 = 0.0

    var body: some View {

        // add all bindings which you want to synchronize
        let allBindings = [$value1, $value2, $value3, $value4]

        return VStack {
            VStack {
                Button(action: {
                    // Manually setting the values does not change the values such
                    // that they sum to 100. Use separate algorithm for this
                    self.value1 = 10
                    self.value2 = 40
                    self.value3 = 25
                    self.value4 = 25
                }) {
                    Text("Test")
                }
                Divider()
                    .padding(.bottom, 20)
                Text("\(value1, specifier: "%.0f")%")
                synchronizedSlider(from: allBindings, index: 0)

                Text("\(value2, specifier: "%.0f")%")
                synchronizedSlider(from: allBindings, index: 1)

                Text("\(value3, specifier: "%.0f")%")
                synchronizedSlider(from: allBindings, index: 2)

                Text("\(value4, specifier: "%.0f")%")
                synchronizedSlider(from: allBindings, index: 3)
            }.padding()
        }
        .padding()
        .background(Color(.lightGray).opacity(0.25))
        .cornerRadius(15.0)
    }


    func synchronizedSlider(from bindings: [Binding<Double>], index: Int) -> some View {
        return Slider(value: synchronizedBinding(from: bindings, index: index),
                      in: 0...100)
    }


    func synchronizedBinding(from bindings: [Binding<Double>], index: Int) -> Binding<Double> {

        return Binding(get: {
            return bindings[index].wrappedValue
        }, set: { newValue in

            let sum = bindings.indices.lazy.filter{ $0 != index }.map{ bindings[$0].wrappedValue }.reduce(0.0, +)
            // Use the 'sum' below if you initially provide values which sum to 100
            // and if you do not set the state in code (e.g. click the button)
            //let sum = 100.0 - bindings[index].wrappedValue

            let remaining = 100.0 - newValue

            if sum != 0.0 {
                for i in bindings.indices {
                    if i != index {
                        bindings[i].wrappedValue = bindings[i].wrappedValue * remaining / sum
                    }
                }
            } else {
                // handle 0 sum
                let newOtherValue = remaining / Double(bindings.count - 1)
                for i in bindings.indices {
                    if i != index {
                        bindings[i].wrappedValue = newOtherValue
                    }
                }
            }
            bindings[index].wrappedValue = newValue
        })

    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
