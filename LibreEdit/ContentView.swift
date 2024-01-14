//
//  ContentView.swift
//  LibreEdit
//
//  Created by Christian Cleberg on 2024-01-13.
//

import SwiftUI

func getDatetime() -> String {
    let dateFormatter = DateFormatter()
    let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    dateFormatter.calendar = Calendar(identifier: .gregorian)

    let iso8601String = dateFormatter.string(from: Date())

    return iso8601String
}

// Ensure that `Supports Document Browser` = YES in the `ios-edit.xcodeproj` file,
// so that users can browse saved files in the Files app
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

struct ContentView: View {
    enum FocusedField {
        case content
    }
    
    @State private var content = ""
    @State private var wordCount: Int = 0
    @State private var showingPopover = false
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(wordCount) words")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
                TextEditor(text: $content)
                    .onChange(of: content) {
                        let words = content.split { $0 == " " || $0.isNewline }
                        self.wordCount = words.count
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .focused($focusedField, equals: .content)
            }
            .onAppear {
                focusedField = .content
            }
            .padding()
            .navigationTitle("Libre Edit")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        do {
                            let data = Data(self.content.utf8)
                            let url = URL.documentsDirectory.appending(path: (getDatetime() + ".txt"))
                            try data.write(to: url, options: [.atomic, .completeFileProtection])

                            // TODO: Alerts currently aren't working/aren't visible
                            Text("File saved successfully!")
                                .foregroundColor(.white)
                                .bold()
                                .font(.footnote)
                                .frame(width: 140, height: 30)
                                .background(Color.indigo.cornerRadius(7))
                            print("Saved content to file: \(url)")
                        } catch {
                            // TODO: Alerts currently aren't working/aren't visible
                            Text("Failed to save file.")
                                .foregroundColor(.white)
                                .bold()
                                .font(.footnote)
                                .frame(width: 140, height: 30)
                                .background(Color.red.cornerRadius(7))
                            print("Error saving content to file: \(error)")
                        }
                    }) {
                        Text("Save")
                    }
                    // TODO: Confirm (possibly save) & then clear TextEditor
                    Button(action: {
                        print("TODO: This will create a new note.")
                    }) {
                        Text("New")
                    }
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    Button {
                        showingPopover = true
                    } label: {
                        Text("App Info")
                    }.popover(isPresented: $showingPopover) {
                        VStack(alignment: .leading) {
                            Text("App Info")
                                .font(.largeTitle)
                            Text("")
                            Text("Libre Edit is a free and open source text editor for iOS built by [Christian Cleberg](https://cleberg.net).")
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

#Preview {
    ContentView()
}
