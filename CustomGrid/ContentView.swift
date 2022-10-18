//
//  ContentView.swift
//  CustomGrid
//
//  Created by Jonni Akesson on 2022-10-18.
//

import SwiftUI

struct ContentView: View {
    
    private let cols: CGFloat = 100
    private let rows: CGFloat = 100
    private let gridH: CGFloat = 20
    private let spacing: CGFloat = 2
    
    @State private var gridRect: CGRect = .zero
    @State private var scrollToTop = false
    
    @Namespace var TOP_LEADING
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .top, spacing: spacing) {
                
                VStack(spacing: spacing) {
                    VStack {
                        //Text("TL")
                    }
                    .frame(width: gridH, height: gridH)
                    .background()
                    
                    //MARK: Rows number
                    ScrollView(.vertical) {
                        VStack(spacing: 0.0) {
                            ForEach(0..<100) { index in
                                Text("\(index + 1)")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.center)
                                    .frame(width: gridH, height: gridH - 1)
                                    .background()
                                    .padding(.vertical, 0.5)
                            }
                        }
                        .offset(y: gridRect.minY)
                        .frame(width: gridH, height: gridH*100)
                    }
                    .scrollDisabled(true)
                    //Rows Number End
                }
                
                VStack(spacing: spacing) {
                    //MARK: Cols number
                    ScrollView(.horizontal) {
                        HStack(spacing: 0.0) {
                            ForEach(0..<100) { index in
                                Text("\(index + 1)")
                                    .font(.system(size: 10))
                                    .multilineTextAlignment(.center)
                                    .frame(width: gridH - 1, height: gridH)
                                    .background()
                                    .padding(.horizontal, 0.5)
                            }
                        }
                        .offset(x: gridRect.minX)
                        .frame(width: gridH*100, height: gridH)
                    }
                    .scrollDisabled(true)
                    //Cols Number End
                    
                    //MARK: Grid
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        ScrollViewReader { proxy in
                            GeometryReader { geo in
                                VStack() {
                                    let widthMax =  geo.size.width
                                    let heightMax = geo.size.height
                                    let xSpacing = widthMax / cols
                                    let ySpacing = heightMax / rows
                                    //MARK: Grid
                                    Path { path in
                                        for index in 0...Int(cols) {
                                            let xOffset: CGFloat = CGFloat(index) * xSpacing
                                            path.move(to: CGPoint(x: xOffset, y: 0))
                                            path.addLine(to: CGPoint(x: xOffset, y: heightMax))
                                        }
                                        for index in 0...Int(rows) {
                                            let yOffset: CGFloat = CGFloat(index) * ySpacing
                                            path.move(to: CGPoint(x: 0, y: yOffset))
                                            path.addLine(to: CGPoint(x: widthMax, y: yOffset))
                                        }
                                    }
                                    .stroke(Color(uiColor: .systemGray5)).opacity(1)
                                }
                                .background()
                                .updateOffset(geo.frame(in: .named("GRID_RECT")))
                            }
                            .frame(width: gridH*100, height: gridH*100)
                            .onChange(of: scrollToTop) { newValue in
                                withAnimation {
                                    proxy.scrollTo(TOP_LEADING, anchor: .topLeading)
                                }
                            }
                            .id(TOP_LEADING)
                        }
                        
                        
                    }
                    .coordinateSpace(name: "GRID_RECT")
                    .background(Color(uiColor: .systemGroupedBackground))
                    
                    //Grid End
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
        .onPreferenceChange(RectPreferenceKey.self, perform: { rect in
            self.gridRect = rect
        })
        .overlay {
            VStack(spacing: 20) {
                Text("minY: \(gridRect.minY)")
                Text("minX: \(gridRect.minX)")
                Button("Scroll to Top Leading") {
                    scrollToTop.toggle()
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct RectPreferenceKey: PreferenceKey {
    static var defaultValue = CGRect.zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    func updateOffset(_ rect: CGRect) -> some View {
        preference(key: RectPreferenceKey.self, value: rect)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
