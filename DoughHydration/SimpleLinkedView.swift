//
//  SimpleLinkedView.swift
//  DoughHydration
//
//  Created by Ronan Shortall on 09/06/2026.
//

import SwiftUI

@Observable
class SimpleModel {

    var firstValue: Int = 20

    var secondValue: Int = 30

    var thirdValue: Int {
        get { firstValue + secondValue }
        set { secondValue = newValue - firstValue }
    }
}

struct SimpleEntryview: View {

    let title: String

    @Binding var value: Int

    var body: some View {

        HStack {

            Text(title)
                .font(.title)
                .multilineTextAlignment(.trailing)
                .frame(width: 200)

            Spacer()

            TextField("Title", value: $value, format: .number)
                .font(.title)
        }
        .frame(width: .infinity)
    }
}

struct SimpleLinkedView: View {

    @State var viewModel = SimpleModel()

    var body: some View {

        VStack {
            
            SimpleEntryview(title: "First: ", value: $viewModel.firstValue)

            SimpleEntryview(title: "Second: ", value: $viewModel.secondValue)

            Rectangle()
                .fill(.black)
                .frame(height: 1)

            SimpleEntryview(title: "Total: ", value: $viewModel.thirdValue)

        }
        .onChange(of: viewModel.thirdValue) {
            print("Third value updated: \(viewModel.thirdValue)")
        }
        .padding()
    }
}

#Preview {
    SimpleLinkedView()
}
