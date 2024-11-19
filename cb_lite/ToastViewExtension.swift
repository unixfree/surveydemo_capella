import SwiftUI

extension View {
    func toast(isPresented: Binding<Bool>, message: String, duration: TimeInterval = 2) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.body)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 50)
                        .onAppear {
                            withAnimation(.easeInOut) { // withAnimation으로 변경
                                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                                    isPresented.wrappedValue = false
                                }
                            }
                        }
                }
                .transition(.opacity)
            }
        }
    }
}
