// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
#if canImport(UIKit)
    @available(macOS 10.15, *)

    public struct AutoCompleteTextFieldView: View {
        @State var names: [String] = ["Apple", "Peach", "Orange", "Banana", "Melon", "Watermelon", "Mandarin", "Mulberries", "Lemon", "Lime", "Loquat", "Longan", "Lychee", "Grape", "Pear", "Kiwi", "Mango"]
        @Binding var editing: Bool
        @Binding var inputText: String
        @State var verticalOffset: CGFloat
        @State var horizontalOffset: CGFloat

        public var filteredTexts: Binding<[String]> { Binding(
            get: {
                names.filter { $0.contains(inputText) && $0.prefix(1) == inputText.prefix(1) }
            },
            set: { _ in })
        }

        public init(editing: Binding<Bool>, text: Binding<String>) {
            _editing = editing
            _inputText = text
            verticalOffset = 0
            horizontalOffset = 0
        }

        public init(editing: Binding<Bool>, text: Binding<String>, verticalOffset: CGFloat, horizontalOffset: CGFloat) {
            _editing = editing
            _inputText = text
            self.verticalOffset = verticalOffset
            self.horizontalOffset = horizontalOffset
        }

        public var body: some View {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredTexts.wrappedValue, id: \.self) { textSearched in

                        Text(textSearched)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 25)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: 50,
                                   alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture(perform: {
                                inputText = textSearched
                                editing = false
                                self.endTextEditing()
                            })
                        Divider()
                            .padding(.horizontal, 10)
                    }
                }
            }.background(Color.white)

                .cornerRadius(15)
                .foregroundColor(Color(.black))
                .ignoresSafeArea()
                .frame(maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: 50 * CGFloat(filteredTexts.wrappedValue.count > 3 ? 3 : filteredTexts.wrappedValue.count))
                .shadow(radius: 4)
                .padding(.horizontal, 25)
                .offset(x: horizontalOffset, y: verticalOffset)
                .isHidden(!editing, remove: !editing)
        }
    }

    public extension View {
        @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
            if hidden {
                if !remove {
                    self.hidden()
                }
            } else {
                self
            }
        }

        func endTextEditing() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }

#endif

