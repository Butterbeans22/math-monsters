import SwiftUI

enum GradeMonsterMood {
    case calm
    case excited
    case proud
    case determined
}

struct GradeMonsterBadge: View {
    let grade: GradeLevel
    var size: CGFloat = 52
    var mood: GradeMonsterMood = .calm
    var showsIdleMotion: Bool = false

    private let pupilColor = Color(red: 0.11, green: 0.34, blue: 0.72)
    private let mouthColor = Color(red: 0.84, green: 0.28, blue: 0.45)

    var body: some View {
        if showsIdleMotion {
            TimelineView(.animation(minimumInterval: 1.0 / 20.0)) { timeline in
                badgeBody(idleTime: timeline.date.timeIntervalSinceReferenceDate)
            }
        } else {
            badgeBody(idleTime: nil)
        }
    }

    private func badgeBody(idleTime: TimeInterval?) -> some View {
        ZStack(alignment: .topTrailing) {
            hornLayer
                .offset(y: size * (hornMoodOffset + idleHornDrift(for: idleTime)))

            headShape
                .fill(
                    LinearGradient(
                        colors: [grade.color.opacity(0.72), grade.color, grade.color.opacity(0.92)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            bellyPatch
                .offset(y: size * 0.09)

            spotLayer

            speciesAccessoryLayer

            browShape
                .fill(.white.opacity(0.16))
                .frame(width: size * browWidth, height: size * 0.2)
                .offset(y: -size * 0.12)

            eyeCluster
            .offset(y: size * eyeOffsetY)
            .scaleEffect(x: 1, y: eyeScaleY * idleBlinkScale(for: idleTime))

            HStack(spacing: size * 0.32) {
                Circle()
                    .fill(Color.orange.opacity(0.45))
                    .frame(width: size * 0.12, height: size * 0.12)

                Circle()
                    .fill(Color.purple.opacity(0.4))
                    .frame(width: size * 0.12, height: size * 0.12)
            }
            .offset(y: size * blushOffsetY)

            mouthShape
                .fill(mouthColor)
                .frame(width: size * mouthWidth, height: size * mouthHeight)
                .offset(y: size * mouthOffsetY)
                .scaleEffect(x: mouthScaleX, y: mouthScaleY)
                .rotationEffect(.degrees(mouthRotation))

            toothLayer
                .offset(y: size * (mouthOffsetY - 0.005))

            Text("\(grade.rawValue)")
                .font(.system(size: size * 0.22, weight: .black, design: .rounded))
                .foregroundStyle(grade.color)
                .padding(.horizontal, size * 0.12)
                .padding(.vertical, size * 0.06)
                .background(.white)
                .clipShape(Capsule())
                .padding(size * 0.08)
        }
        .frame(width: size, height: size)
        .scaleEffect(badgeScale)
        .rotationEffect(.degrees(badgeRotation + idleRotation(for: idleTime)))
        .offset(y: size * (badgeLift + idleLift(for: idleTime)))
        .shadow(color: grade.color.opacity(0.18), radius: size * 0.1, y: size * 0.05)
        .animation(.spring(response: 0.34, dampingFraction: 0.62), value: mood)
    }

    private var headShape: AnyShape {
        switch grade {
        case .grade1:
            return AnyShape(Circle())
        case .grade2:
            return AnyShape(RoundedRectangle(cornerRadius: size * 0.34, style: .continuous))
        case .grade3:
            return AnyShape(RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
        case .grade4:
            return AnyShape(UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: size * 0.34,
                    bottomLeading: size * 0.28,
                    bottomTrailing: size * 0.34,
                    topTrailing: size * 0.28
                ),
                style: .continuous
            ))
        case .grade5:
            return AnyShape(UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: size * 0.24,
                    bottomLeading: size * 0.38,
                    bottomTrailing: size * 0.24,
                    topTrailing: size * 0.38
                ),
                style: .continuous
            ))
        }
    }

    private var browShape: some Shape {
        Capsule(style: .continuous)
    }

    private var bellyPatch: some View {
        headShape
            .fill(.white.opacity(0.13))
            .scaleEffect(x: 0.68, y: 0.46, anchor: .bottom)
    }

    private var spotLayer: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.16))
                .frame(width: size * 0.14, height: size * 0.14)
                .offset(x: -size * 0.18, y: size * 0.14)

            Circle()
                .fill(Color.yellow.opacity(0.18))
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(x: size * 0.2, y: size * 0.02)

            RoundedRectangle(cornerRadius: size * 0.05, style: .continuous)
                .fill(Color.pink.opacity(0.12))
                .frame(width: size * 0.1, height: size * 0.16)
                .rotationEffect(.degrees(22))
                .offset(x: size * 0.08, y: size * 0.22)
        }
    }

    @ViewBuilder
    private var speciesAccessoryLayer: some View {
        switch grade {
        case .grade1:
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.9))
                    .frame(width: size * 0.1, height: size * 0.1)
                    .offset(x: -size * 0.19, y: -size * 0.29)

                Circle()
                    .fill(Color.orange.opacity(0.85))
                    .frame(width: size * 0.08, height: size * 0.08)
                    .offset(x: size * 0.18, y: -size * 0.3)
            }
        case .grade2:
            ZStack {
                Triangle()
                    .fill(Color.green.opacity(0.26))
                    .frame(width: size * 0.18, height: size * 0.16)
                    .rotationEffect(.degrees(-36))
                    .offset(x: -size * 0.34, y: -size * 0.04)

                Triangle()
                    .fill(Color.teal.opacity(0.24))
                    .frame(width: size * 0.18, height: size * 0.16)
                    .rotationEffect(.degrees(36))
                    .offset(x: size * 0.34, y: -size * 0.04)
            }
        case .grade3:
            ZStack {
                Capsule(style: .continuous)
                    .fill(Color.blue.opacity(0.18))
                    .frame(width: size * 0.54, height: size * 0.11)
                    .offset(y: -size * 0.01)
            }
        case .grade4:
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    Triangle()
                        .fill(Color.orange.opacity(0.32))
                        .frame(width: size * 0.11, height: size * 0.12)
                        .rotationEffect(.degrees(-70 + Double(index) * 24))
                        .offset(x: -size * 0.32 + CGFloat(index) * size * 0.08, y: size * 0.02)
                }

                ForEach(0..<3, id: \.self) { index in
                    Triangle()
                        .fill(Color.red.opacity(0.26))
                        .frame(width: size * 0.11, height: size * 0.12)
                        .rotationEffect(.degrees(70 - Double(index) * 24))
                        .offset(x: size * 0.32 - CGFloat(index) * size * 0.08, y: size * 0.02)
                }
            }
        case .grade5:
            ZStack {
                Capsule(style: .continuous)
                    .fill(Color.indigo.opacity(0.28))
                    .frame(width: size * 0.1, height: size * 0.24)
                    .rotationEffect(.degrees(22))
                    .offset(x: -size * 0.16, y: size * 0.28)

                Capsule(style: .continuous)
                    .fill(Color.purple.opacity(0.26))
                    .frame(width: size * 0.1, height: size * 0.24)
                    .rotationEffect(.degrees(-22))
                    .offset(x: size * 0.16, y: size * 0.28)
            }
        }
    }

    private var hornLayer: some View {
        HStack {
            horn(color: hornColors.0, rotation: hornRotations.0)

            Spacer(minLength: 0)

            horn(color: hornColors.1, rotation: hornRotations.1)
        }
        .padding(.horizontal, size * 0.16)
        .offset(y: -size * hornOffsetY)
    }

    private func eye(scale: CGFloat, tilt: Double) -> some View {
        ZStack {
            Ellipse()
                .fill(.white)
                .frame(width: size * 0.24 * scale, height: size * 0.22 * scale)

            Capsule(style: .continuous)
                .fill(pupilColor)
                .frame(width: size * 0.09 * scale, height: size * 0.14 * scale)
                .offset(x: size * 0.01 * scale, y: size * 0.005)

            Circle()
                .fill(.white.opacity(0.95))
                .frame(width: size * 0.03, height: size * 0.03)
                .offset(x: -size * 0.025 * scale, y: -size * 0.03 * scale)
        }
        .rotationEffect(.degrees(tilt))
    }

    @ViewBuilder
    private var eyeCluster: some View {
        switch grade {
        case .grade1:
            HStack(spacing: size * 0.08) {
                eye(scale: 1.02, tilt: leftEyeTilt)
                eye(scale: 0.92, tilt: rightEyeTilt)
            }
        case .grade2:
            HStack(spacing: size * 0.16) {
                eye(scale: 0.92, tilt: -10)
                eye(scale: 1.06, tilt: 8)
            }
        case .grade3:
            eye(scale: 1.34, tilt: 0)
        case .grade4:
            HStack(spacing: size * 0.07) {
                eye(scale: 0.9, tilt: -16)
                eye(scale: 1.12, tilt: 10)
            }
        case .grade5:
            VStack(spacing: size * 0.04) {
                eye(scale: 0.64, tilt: 0)
                HStack(spacing: size * 0.07) {
                    eye(scale: 0.9, tilt: -8)
                    eye(scale: 0.9, tilt: 8)
                }
            }
        }
    }

    private var toothLayer: some View {
        HStack(spacing: size * 0.02) {
            ForEach(0..<toothCount, id: \.self) { index in
                Triangle()
                    .fill(.white.opacity(0.95))
                    .frame(width: size * toothWidth, height: size * toothHeight)
                    .rotationEffect(.degrees(index.isMultiple(of: 2) ? 180 : 0))
            }
        }
        .opacity(toothCount == 0 ? 0 : 1)
    }

    private func horn(color: Color, rotation: Double) -> some View {
        hornShape
            .fill(color)
            .frame(width: size * hornWidth, height: size * hornHeight)
            .rotationEffect(.degrees(rotation))
    }

    private var hornShape: AnyShape {
        switch grade {
        case .grade1:
            return AnyShape(Capsule(style: .continuous))
        case .grade2:
            return AnyShape(RoundedRectangle(cornerRadius: size * 0.08, style: .continuous))
        case .grade3, .grade4, .grade5:
            return AnyShape(Triangle())
        }
    }

    private var hornColors: (Color, Color) {
        switch grade {
        case .grade1:
            return (.green.opacity(0.85), .mint.opacity(0.8))
        case .grade2:
            return (.green.opacity(0.85), .teal.opacity(0.8))
        case .grade3:
            return (.green.opacity(0.8), .blue.opacity(0.75))
        case .grade4:
            return (.orange.opacity(0.85), .red.opacity(0.75))
        case .grade5:
            return (.indigo.opacity(0.85), .purple.opacity(0.8))
        }
    }

    private var hornRotations: (Double, Double) {
        switch grade {
        case .grade1: return (-18, 18)
        case .grade2: return (-12, 12)
        case .grade3: return (-18, 18)
        case .grade4: return (-24, 24)
        case .grade5: return (-28, 28)
        }
    }

    private var hornWidth: CGFloat {
        switch grade {
        case .grade1: return 0.14
        case .grade2: return 0.12
        case .grade3, .grade4, .grade5: return 0.2
        }
    }

    private var hornHeight: CGFloat {
        switch grade {
        case .grade1: return 0.24
        case .grade2: return 0.2
        case .grade3: return 0.24
        case .grade4: return 0.26
        case .grade5: return 0.28
        }
    }

    private var hornOffsetY: CGFloat {
        switch grade {
        case .grade1, .grade2: return 0.09
        case .grade3: return 0.13
        case .grade4, .grade5: return 0.16
        }
    }

    private var browWidth: CGFloat {
        switch grade {
        case .grade1: return 0.66
        case .grade2: return 0.7
        case .grade3, .grade4, .grade5: return 0.72
        }
    }

    private var eyeOffsetY: CGFloat {
        switch mood {
        case .calm: return 0.02
        case .excited: return 0.0
        case .proud: return 0.03
        case .determined: return 0.015
        }
    }

    private var blushOffsetY: CGFloat {
        switch mood {
        case .calm: return 0.18
        case .excited: return 0.2
        case .proud: return 0.17
        case .determined: return 0.19
        }
    }

    private var mouthWidth: CGFloat {
        switch mood {
        case .calm: return 0.36
        case .excited: return 0.42
        case .proud: return 0.4
        case .determined: return 0.34
        }
    }

    private var mouthHeight: CGFloat {
        switch mood {
        case .calm: return 0.12
        case .excited: return 0.14
        case .proud: return 0.1
        case .determined: return 0.08
        }
    }

    private var mouthOffsetY: CGFloat {
        switch mood {
        case .calm: return 0.29
        case .excited: return 0.28
        case .proud: return 0.285
        case .determined: return 0.3
        }
    }

    private var mouthShape: AnyShape {
        switch mood {
        case .calm:
            return AnyShape(Capsule(style: .continuous))
        case .excited:
            return AnyShape(RoundedRectangle(cornerRadius: size * 0.08, style: .continuous))
        case .proud:
            return AnyShape(UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: size * 0.04,
                    bottomLeading: size * 0.1,
                    bottomTrailing: size * 0.1,
                    topTrailing: size * 0.04
                ),
                style: .continuous
            ))
        case .determined:
            return AnyShape(Capsule(style: .continuous))
        }
    }

    private var badgeScale: CGFloat {
        switch mood {
        case .calm: return 1
        case .excited: return 1.08
        case .proud: return 1.03
        case .determined: return 1.01
        }
    }

    private var badgeRotation: Double {
        switch mood {
        case .calm: return 0
        case .excited: return -4
        case .proud: return -2
        case .determined: return 2
        }
    }

    private var badgeLift: CGFloat {
        switch mood {
        case .calm: return 0
        case .excited: return -0.02
        case .proud: return -0.01
        case .determined: return 0.01
        }
    }

    private var hornMoodOffset: CGFloat {
        switch mood {
        case .calm: return 0
        case .excited: return -0.02
        case .proud: return -0.01
        case .determined: return 0.015
        }
    }

    private var eyeScaleY: CGFloat {
        switch mood {
        case .calm: return 1
        case .excited: return 1.06
        case .proud: return 0.96
        case .determined: return 0.82
        }
    }

    private var leftEyeTilt: Double {
        switch mood {
        case .calm: return -4
        case .excited: return -8
        case .proud: return -2
        case .determined: return -10
        }
    }

    private var rightEyeTilt: Double {
        switch mood {
        case .calm: return 5
        case .excited: return 8
        case .proud: return 3
        case .determined: return 10
        }
    }

    private var mouthScaleX: CGFloat {
        switch mood {
        case .calm: return 1
        case .excited: return 1.08
        case .proud: return 1.04
        case .determined: return 0.92
        }
    }

    private var mouthScaleY: CGFloat {
        switch mood {
        case .calm: return 1
        case .excited: return 1.2
        case .proud: return 0.88
        case .determined: return 0.72
        }
    }

    private var mouthRotation: Double {
        switch mood {
        case .calm: return 0
        case .excited: return 0
        case .proud: return -2
        case .determined: return 1.5
        }
    }

    private var toothCount: Int {
        switch mood {
        case .calm: return 2
        case .excited: return 4
        case .proud: return 3
        case .determined: return 1
        }
    }

    private var toothWidth: CGFloat {
        switch mood {
        case .calm: return 0.035
        case .excited: return 0.04
        case .proud: return 0.034
        case .determined: return 0.03
        }
    }

    private var toothHeight: CGFloat {
        switch mood {
        case .calm: return 0.045
        case .excited: return 0.06
        case .proud: return 0.05
        case .determined: return 0.04
        }
    }

    private func idleLift(for idleTime: TimeInterval?) -> CGFloat {
        guard let idleTime else { return 0 }
        return CGFloat(sin(idleTime * 1.8)) * 0.012
    }

    private func idleRotation(for idleTime: TimeInterval?) -> Double {
        guard let idleTime else { return 0 }
        return sin(idleTime * 1.2) * 1.4
    }

    private func idleHornDrift(for idleTime: TimeInterval?) -> CGFloat {
        guard let idleTime else { return 0 }
        return CGFloat(cos(idleTime * 1.5)) * 0.008
    }

    private func idleBlinkScale(for idleTime: TimeInterval?) -> CGFloat {
        guard let idleTime else { return 1 }
        let cycle = idleTime.truncatingRemainder(dividingBy: 4.2)
        let blinkCenter = 3.75
        let blinkWindow = 0.12
        let distance = abs(cycle - blinkCenter)

        guard distance < blinkWindow else { return 1 }

        let progress = 1 - (distance / blinkWindow)
        return 1 - CGFloat(progress) * 0.82
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
