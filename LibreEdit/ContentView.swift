//
//  ContentView.swift
//  LibreEdit
//
//  Created by Christian Cleberg on 2024-01-13.
//

import SwiftUI
import UniformTypeIdentifiers

struct TextFile: FileDocument {
    static var readableContentTypes = [UTType.plainText]
    var text = ""

    // Initialize a new document
    init(initialText: String = "") {
        text = initialText
    }

    // Load an existing document
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }

    // Save document data to file
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

// Counts all words in the opened file
func countWords(text: String) -> Int {
    let words = text.split { $0 == " " || $0.isNewline }
    return words.count
}

struct ContentView: View {
    @Binding var document: TextFile
    @State private var showingPopover = false
    @State private var wordCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(wordCount) words")
                    .foregroundColor(Color.white)
                    .font(.headline)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.gray.opacity(0.3))
                    .padding(.top, 20)
                TextEditor(text: $document.text)
                    .onAppear {
                        self.wordCount = countWords(text: document.text)
                    }
                    .onChange(of: document.text) {
                        self.wordCount = countWords(text: document.text)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .secondaryAction) {
                            NavigationLink(destination: MarkdownView(document: $document)) {
                                Text("Show Rendered Markdown")
                            }
                            Button {
                                showingPopover = true
                            } label: {
                                Text("More Info")
                            }.popover(isPresented: $showingPopover) {
                                VStack(alignment: .leading) {
                                    Text("More Info")
                                        .font(.largeTitle)
                                    Text("")
                                    Text("Instructions")
                                        .font(.title)
                                    Text("")
                                    Text("LibreEdit provides a direct interface with the Apple Files app on your iPhone. Simply navigate to your preferred directory, edit existing files, or create new files!")
                                    Text("")
                                    Text("Developer")
                                        .font(.title)
                                    Text("")
                                    Text("LibreEdit is a free and open source text editor for iOS built by [Christian Cleberg](https://cleberg.net).")
                                    Text("")
                                    Text("Visit the [GitHub Repository](https://github.com/ccleberg/ios-edit) to view the source code.")
                                    Text("")
                                    Text("This project was developed under the [GNU GPL v3 license](https://github.com/ccleberg/ios-edit/LICENSE).")
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }
            }
        }
    }
}
