//
//  MarkdownView.swift
//  LibreEdit
//
//  Created by Christian Cleberg on 2024-01-14.
//

import SwiftUI
import MarkdownUI

struct MarkdownView: View {
    @Binding var document: TextFile
    
    var body: some View {
        ScrollView {
            Markdown {
                MarkdownContent(document.text)
            }
            .markdownTheme(.docC)
            .padding()
        }
        .navigationTitle("Rendered Markdown")
    }
}
