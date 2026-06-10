//
//  LogExportView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct LogExportView: View {
    @State private var viewModel = LogExportViewModel()

    var body: some View {
        Form {
            LabeledContent("File", value: LogExportViewModel.fileName)
            LabeledContent("Size", value: viewModel.fileSizeText)
            LabeledContent("Exists", value: viewModel.fileExists ? "Yes" : "No")

            if viewModel.fileExists {
                ShareLink(item: viewModel.fileURL) {
                    Label("Export Log", systemImage: "square.and.arrow.up")
                }
            }

            Button("Create Log File") {
                viewModel.ensureLogFile()
            }

            Button("Delete Log", role: .destructive) {
                viewModel.deleteLog()
            }
            .disabled(!viewModel.fileExists)

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Log Export")
        .onAppear {
            viewModel.refresh()
            viewModel.ensureLogFile()
        }
        .trackLife()
    }
}
