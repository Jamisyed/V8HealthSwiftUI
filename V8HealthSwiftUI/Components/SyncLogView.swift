//
//  SyncLogView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct SyncLogView: View {
    let text: String
    let emptyPlaceholder: String
    let onSync: () -> Void
    let onDelete: () -> Void
    var docType: FeatureDocType?

    var body: some View {
        ScrollView {
            Text(text.isEmpty ? emptyPlaceholder : text)
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if let docType {
                    NavigationLink {
                        FeatureDocsView(docType: docType)
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
                Button("Sync", action: onSync)
                Button("Delete", role: .destructive, action: onDelete)
            }
        }
    }
}
