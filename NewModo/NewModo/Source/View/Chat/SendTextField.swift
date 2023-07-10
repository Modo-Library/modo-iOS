//
//  SendTextField.swift
//  Modo
//
//  Created by MacBook on 2023/05/17.
//
import SwiftUI

struct TextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var lineCount: Int
    
    init(text: Binding<String>, lineCount: Binding<Int>) {
        self._text = text
        self._lineCount = lineCount
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = text
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Pretendard-Regular", size: 16)
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text,lineCount: $lineCount)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        let textViewPlaceHolder = "텍스트를 입력하세요"
        @Binding var text: String
        @Binding var lineCount: Int

        init(text: Binding<String>,lineCount: Binding<Int>) {
            _text = text
            _lineCount = lineCount
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            lineCount = textView.text.count / 15 + 1
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            lineCount = 1
        }
        
        func textViewDidChange(_ textView: UITextView) {
            lineCount = textView.text.count / 15 + 1
            print("\(text)")
        }

    }
}
