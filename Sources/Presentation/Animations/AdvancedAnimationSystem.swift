//
// AdvancedAnimationSystem.swift
// iOS App Templates
//
// Created on 16/08/2024.
//

import SwiftUI
import Combine

// MARK: - Animation Curve Types
public enum AnimationCurve {
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case spring(response: Double, dampingFraction: Double, blendDuration: Double)
    case custom(c1x: Double, c1y: Double, c2x: Double, c2y: Double)
    case bounce
    case elastic(stiffness: Double, damping: Double)
    
    var animation: Animation {
        switch self {
        case .linear:
            return .linear
        case .easeIn:
            return .easeIn
        case .easeOut:
            return .easeOut
        case .easeInOut:
            return .easeInOut
        case .spring(let response, let dampingFraction, let blendDuration):
            return .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
        case .custom(let c1x, let c1y, let c2x, let c2y):
            return .timingCurve(c1x, c1y, c2x, c2y)
        case .bounce:
            return .interpolatingSpring(stiffness: 300, damping: 15)
        case .elastic(let stiffness, let damping):
            return .interpolatingSpring(stiffness: stiffness, damping: damping)
        }
    }
}

// MARK: - Advanced Animation Manager
public final class AdvancedAnimationManager: ObservableObject {
    
    // MARK: - Properties
    @Published public var isAnimating = false
    @Published public var animationProgress: Double = 0
    @Published public var currentPhase: AnimationPhase = .idle
    
    private var cancellables = Set<AnyCancellable>()
    private let animationQueue = DispatchQueue(label: "com.iosapptemplates.animation", qos: .userInteractive)
    
    // MARK: - Animation Phases
    public enum AnimationPhase {
        case idle
        case preparing
        case animating
        case completing
        case completed
        case cancelled
    }
    
    // MARK: - Singleton
    public static let shared = AdvancedAnimationManager()
    
    private init() {}
    
    // MARK: - Chain Animation
    public func chainAnimations(_ animations: [AnimationSequence]) {
        guard !isAnimating else { return }
        
        isAnimating = true
        currentPhase = .preparing
        
        animationQueue.async { [weak self] in
            self?.executeAnimationChain(animations, index: 0)
        }
    }
    
    private func executeAnimationChain(_ animations: [AnimationSequence], index: Int) {
        guard index < animations.count else {
            DispatchQueue.main.async {
                self.completeAnimation()
            }
            return
        }
        
        let animation = animations[index]
        
        DispatchQueue.main.async {
            self.currentPhase = .animating
            self.animationProgress = Double(index) / Double(animations.count)
            
            withAnimation(animation.curve.animation.delay(animation.delay)) {
                animation.action()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration + animation.delay) {
                self.executeAnimationChain(animations, index: index + 1)
            }
        }
    }
    
    private func completeAnimation() {
        currentPhase = .completing
        animationProgress = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.currentPhase = .completed
            self.isAnimating = false
            self.animationProgress = 0
        }
    }
    
    // MARK: - Cancel Animation
    public func cancelAnimation() {
        isAnimating = false
        currentPhase = .cancelled
        animationProgress = 0
    }
}

// MARK: - Animation Sequence
public struct AnimationSequence {
    let action: () -> Void
    let duration: TimeInterval
    let delay: TimeInterval
    let curve: AnimationCurve
    
    public init(
        action: @escaping () -> Void,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        curve: AnimationCurve = .easeInOut
    ) {
        self.action = action
        self.duration = duration
        self.delay = delay
        self.curve = curve
    }
}

// MARK: - Animatable View Modifier
public struct AnimatableModifier: ViewModifier {
    @Binding var value: Double
    let curve: AnimationCurve
    let duration: Double
    
    public func body(content: Content) -> some View {
        content
            .animation(curve.animation.speed(1.0 / duration), value: value)
    }
}

// MARK: - Parallax Effect
public struct ParallaxEffect: GeometryEffect {
    var offset: CGFloat
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}

// MARK: - Morphing Shape
public struct MorphingShape: Shape {
    var progress: CGFloat
    
    public var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        if progress < 0.5 {
            // Circle to Square transition
            let cornerRadius = radius * (1 - progress * 2)
            path.addRoundedRect(in: CGRect(x: center.x - radius, y: center.y - radius,
                                          width: radius * 2, height: radius * 2),
                              cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        } else {
            // Square to Star transition
            let adjustedProgress = (progress - 0.5) * 2
            let points = starPoints(center: center, radius: radius, progress: adjustedProgress)
            path.move(to: points[0])
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
        
        return path
    }
    
    private func starPoints(center: CGPoint, radius: CGFloat, progress: CGFloat) -> [CGPoint] {
        let innerRadius = radius * 0.4 * progress
        var points: [CGPoint] = []
        
        for i in 0..<10 {
            let angle = (CGFloat(i) * .pi * 2 / 10) - .pi / 2
            let r = i.isMultiple(of: 2) ? radius : innerRadius
            let x = center.x + cos(angle) * r
            let y = center.y + sin(angle) * r
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }
}

// MARK: - 3D Rotation Effect
public struct Rotation3DEffect: GeometryEffect {
    var angle: Double
    var axis: (x: CGFloat, y: CGFloat, z: CGFloat)
    
    public var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        let rotation = CATransform3DMakeRotation(CGFloat(angle), axis.x, axis.y, axis.z)
        return ProjectionTransform(rotation)
    }
}

// MARK: - Particle System
public struct ParticleSystem: View {
    @State private var particles: [Particle] = []
    let particleCount: Int
    let colors: [Color]
    let emissionRate: TimeInterval
    
    public init(
        particleCount: Int = 50,
        colors: [Color] = [.blue, .purple, .pink],
        emissionRate: TimeInterval = 0.1
    ) {
        self.particleCount = particleCount
        self.colors = colors
        self.emissionRate = emissionRate
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ParticleView(particle: particle)
                }
            }
            .onAppear {
                startEmitting(in: geometry.size)
            }
        }
    }
    
    private func startEmitting(in size: CGSize) {
        Timer.scheduledTimer(withTimeInterval: emissionRate, repeats: true) { _ in
            if particles.count < particleCount {
                particles.append(Particle(
                    position: CGPoint(x: size.width / 2, y: size.height),
                    velocity: CGPoint(x: Double.random(in: -50...50), y: Double.random(in: -200...-100)),
                    color: colors.randomElement() ?? .blue,
                    size: CGFloat.random(in: 5...15),
                    lifetime: Double.random(in: 2...4)
                ))
            }
            
            // Remove dead particles
            particles.removeAll { $0.isDead }
        }
    }
}

// MARK: - Particle Model
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let color: Color
    let size: CGFloat
    let lifetime: Double
    let birthTime = Date()
    
    var isDead: Bool {
        Date().timeIntervalSince(birthTime) > lifetime
    }
    
    var opacity: Double {
        let age = Date().timeIntervalSince(birthTime)
        return max(0, 1 - (age / lifetime))
    }
}

// MARK: - Particle View
struct ParticleView: View {
    let particle: Particle
    @State private var position: CGPoint
    
    init(particle: Particle) {
        self.particle = particle
        self._position = State(initialValue: particle.position)
    }
    
    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .opacity(particle.opacity)
            .position(position)
            .onAppear {
                withAnimation(.linear(duration: particle.lifetime)) {
                    position = CGPoint(
                        x: position.x + particle.velocity.x * particle.lifetime,
                        y: position.y + particle.velocity.y * particle.lifetime
                    )
                }
            }
    }
}

// MARK: - Wave Animation
public struct WaveAnimation: View {
    @State private var phase: CGFloat = 0
    let amplitude: CGFloat
    let frequency: CGFloat
    let color: Color
    
    public init(
        amplitude: CGFloat = 20,
        frequency: CGFloat = 1,
        color: Color = .blue
    ) {
        self.amplitude = amplitude
        self.frequency = frequency
        self.color = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height / 2
                
                path.move(to: CGPoint(x: 0, y: height))
                
                for x in stride(from: 0, through: width, by: 1) {
                    let relativeX = x / width
                    let y = sin(relativeX * .pi * 2 * frequency + phase) * amplitude + height
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(color, lineWidth: 2)
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    phase = .pi * 2
                }
            }
        }
    }
}

// MARK: - Shimmer Effect
public struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    let duration: Double
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
    }
}

// MARK: - View Extensions
public extension View {
    func animatable(value: Binding<Double>, curve: AnimationCurve = .easeInOut, duration: Double = 0.3) -> some View {
        modifier(AnimatableModifier(value: value, curve: curve, duration: duration))
    }
    
    func parallax(offset: CGFloat) -> some View {
        modifier(ParallaxEffect(offset: offset))
    }
    
    func rotation3D(angle: Double, axis: (x: CGFloat, y: CGFloat, z: CGFloat)) -> some View {
        modifier(Rotation3DEffect(angle: angle, axis: axis))
    }
    
    func shimmer(duration: Double = 1.5) -> some View {
        modifier(ShimmerEffect(duration: duration))
    }
}

// MARK: - Lottie-like Animation Controller
public class AnimationController: ObservableObject {
    @Published var currentFrame: Int = 0
    @Published var isPlaying: Bool = false
    @Published var progress: Double = 0
    
    private var timer: Timer?
    private let totalFrames: Int
    private let frameRate: Double
    
    public init(totalFrames: Int = 60, frameRate: Double = 60) {
        self.totalFrames = totalFrames
        self.frameRate = frameRate
    }
    
    public func play() {
        guard !isPlaying else { return }
        
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / frameRate, repeats: true) { _ in
            self.nextFrame()
        }
    }
    
    public func pause() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }
    
    public func stop() {
        pause()
        currentFrame = 0
        progress = 0
    }
    
    public func seek(to frame: Int) {
        currentFrame = min(max(0, frame), totalFrames - 1)
        progress = Double(currentFrame) / Double(totalFrames)
    }
    
    private func nextFrame() {
        if currentFrame < totalFrames - 1 {
            currentFrame += 1
            progress = Double(currentFrame) / Double(totalFrames)
        } else {
            stop()
        }
    }
}

// MARK: - Spring Physics Animation
public struct SpringPhysics {
    public let mass: Double
    public let stiffness: Double
    public let damping: Double
    
    public init(mass: Double = 1.0, stiffness: Double = 100.0, damping: Double = 10.0) {
        self.mass = mass
        self.stiffness = stiffness
        self.damping = damping
    }
    
    public func animate(from: Double, to: Double, velocity: Double = 0) -> Animation {
        let response = sqrt(mass / stiffness)
        let dampingFraction = damping / (2 * sqrt(mass * stiffness))
        
        return .spring(response: response, dampingFraction: dampingFraction)
    }
}