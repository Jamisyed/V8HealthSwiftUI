//
//  ECGWaveformView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct ECGWaveformView: View {
    let samples: [Double]

    var body: some View {
        Canvas { context, size in
            guard samples.count > 1 else { return }

            let minValue = samples.min() ?? 0
            let maxValue = samples.max() ?? 1
            let range = max(maxValue - minValue, 1)
            let stepX = size.width / CGFloat(samples.count - 1)

            var path = Path()
            for index in samples.indices {
                let x = CGFloat(index) * stepX
                let normalized = (samples[index] - minValue) / range
                let y = size.height - (CGFloat(normalized) * size.height)
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }

            context.stroke(path, with: .color(.red), lineWidth: 1.5)
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
