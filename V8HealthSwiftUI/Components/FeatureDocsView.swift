//
//  FeatureDocsView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct FeatureDocsView: View {
    let docType: FeatureDocType

    var body: some View {
        ScrollView {
            Text(docType.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .navigationTitle(docType.title)
        .trackLife()
    }
}
