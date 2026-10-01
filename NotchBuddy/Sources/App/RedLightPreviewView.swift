import SwiftUI

/// A local-only interaction prototype. It never reads agent state or sends approvals.
struct RedLightPreviewView: View {
    private enum SampleState: String, CaseIterable {
        case working = "Working"
        case needsInput = "Needs input"
        case finished = "Finished"

        var symbol: String {
            switch self {
            case .working: "hammer.fill"
            case .needsInput: "hand.raised.fill"
            case .finished: "checkmark.circle.fill"
            }
        }

        var color: Color {
            switch self {
            case .working: Color(hex: "#60A5FA")
            case .needsInput: Color(hex: "#F29B38")
            case .finished: Color(hex: "#22C55E")
            }
        }

        var detail: String {
            switch self {
            case .working: "Editing agent/decision-runtime.mjs"
            case .needsInput: "Agent is waiting for your permission"
            case .finished: "Task completed · 2 minutes ago"
            }
        }
    }

    @State private var sampleState: SampleState = .working

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Red Light companion")
                        .font(.system(size: 15, weight: .semibold))
                    Text("A preview using sample activity")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#A4A9B2"))
                }
                Spacer()
                Label("DEMO", systemImage: "sparkles")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "#FFD166"))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 5)
                    .background(Color(hex: "#FFD166").opacity(0.12), in: Capsule())
            }

            HStack(spacing: 12) {
                Image(systemName: sampleState.symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(sampleState.color)
                    .frame(width: 34, height: 34)
                    .background(sampleState.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("System One")
                            .font(.system(size: 12, weight: .semibold))
                        Text(sampleState.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(sampleState.color)
                    }
                    Text(sampleState.detail)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#C5C8CE"))
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                Spacer(minLength: 0)
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 8) {
                ForEach(SampleState.allCases, id: \.self) { option in
                    Button {
                        sampleState = option
                    } label: {
                        Label(option.rawValue, systemImage: option.symbol)
                            .font(.system(size: 10, weight: .medium))
                            .lineLimit(1)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 6)
                            .foregroundColor(sampleState == option ? option.color : Color(hex: "#C5C8CE"))
                            .background(sampleState == option ? option.color.opacity(0.13) : Color.white.opacity(0.045), in: Capsule())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Show sample state: \(option.rawValue)")
                    .accessibilityAddTraits(sampleState == option ? .isSelected : [])
                }
                Spacer(minLength: 0)
                Button("Close preview") {
                    NotificationCenter.default.post(name: .islandCollapse, object: nil)
                }
                .font(.system(size: 10, weight: .medium))
                .buttonStyle(.plain)
                .foregroundColor(Color(hex: "#A4A9B2"))
            }
        }
        .padding(.horizontal, 10)
        .accessibilityElement(children: .contain)
    }
}
