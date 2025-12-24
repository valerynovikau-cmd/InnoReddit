//
//  ProfileInfoView.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

import SwiftUI
import Factory
import Kingfisher

struct ProfileInfoView: View {
    @ScaledMetric var imageSize: CGFloat = 80
    @ScaledMetric var labelsFontSize: CGFloat = 15
    @ObservedObject var sessionManager: AuthSessionManager
    private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day]
        formatter.maximumUnitCount = 1
        return formatter
    }()

    
    init() {
        if let manager = (Container.shared.authSessionManager.resolve() as? AuthSessionManager) {
            sessionManager = manager
        }
        else {
            sessionManager = AuthSessionManager()
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            KFImage(URL(string: self.sessionManager.user?.iconImageURL ?? ""))
                .resizable()
                .scaledToFill()
                .background {
                    Asset.Assets.Colors.innoSecondaryBackgroundColor.swiftUIColor
                    ProgressView()
                }
                .clipShape(.circle)
                .frame(width: imageSize, height: imageSize)
                .padding()

                VStack {
                    LabeledContent(ProfileStrings.karmaLabel + ":", value: "\(sessionManager.user?.totalKarma ?? 0)")
                    Spacer()
                    LabeledContent(ProfileStrings.subscribersLabel + ":", value: "\(sessionManager.user?.subscribers ?? 0)")
                    Spacer()
                    LabeledContent(ProfileStrings.accountAgeSting + ":", value: self.accountAgeString())
                }
                .lineLimit(1)
                .font(.system(size: labelsFontSize, weight: .medium))
                .frame(height: imageSize)
                .padding([.vertical, .trailing])
        }
        .frame(maxWidth: .infinity)
        .background(Asset.Assets.Colors.innoBackgroundColor.swiftUIColor)
    }
    
    private func accountAgeString() -> String {
        guard let createdAt = self.sessionManager.user?.accountCreatedAt else {
            return ProfileStrings.errorLabel
        }
        let interval = Date().timeIntervalSince(createdAt)
        return self.durationFormatter.string(from: interval) ?? ProfileStrings.errorLabel
    }
}

#Preview {
    ProfileInfoView()
}
