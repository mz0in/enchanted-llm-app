//
//  EmptyConversaitonView.swift
//  Enchanted
//
//  Created by Augustinas Malinauskas on 10/02/2024.
//

import SwiftUI

struct EmptyConversaitonView: View, KeyboardReadable {
    @State var showPromptsAnimation = false
    @State var prompts: [SamplePrompts] = []
    var sendPrompt: (String) -> ()
#if os(iOS)
    @State var isKeyboardVisible = false
#endif
    
#if os(macOS)
    var columns = Array.init(repeating: GridItem(.flexible(), spacing: 15), count: 4)
#else
    var columns = [GridItem(.flexible()), GridItem(.flexible())]
#endif
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 25) {
                Text("Enchanted")
                    .font(Font.system(size: 46, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "4285f4"), Color(hex: "9b72cb"), Color(hex: "d96570"), Color(hex: "#d96570")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("How can I help you today?")
                    .font(.system(size: 25))
                    .foregroundStyle(Color(.systemGray))
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 15) {
                    ForEach(prompts.prefix(4), id: \.self) { prompt in
                        Button(action: {sendPrompt(prompt.prompt)}) {
                            VStack(alignment: .leading) {
                                Text(prompt.prompt)
                                    .font(.system(size: 15))
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    Image(systemName: prompt.type.icon)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color.gray5Custom)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                        }
                        .transition(.slide)
                        .showIf(showPromptsAnimation)
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: 700)
                .padding()
                .transition(AnyTransition(.opacity).combined(with: .slide))
#if os(iOS)
                .showIf(!isKeyboardVisible)
#endif
            }
            Spacer()
        }
        .onAppear {
            withAnimation {
                prompts = SamplePrompts.samples.shuffled()
                showPromptsAnimation = true
            }
        }
#if os(iOS)
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            withAnimation {
                isKeyboardVisible = newIsKeyboardVisible
            }
        }
#endif
        
    }
}

#Preview(traits: .fixedLayout(width: 1000, height: 1000)) {
    EmptyConversaitonView(sendPrompt: {_ in})
}
