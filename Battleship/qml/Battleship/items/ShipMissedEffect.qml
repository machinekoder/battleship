import Qt.labs.particles 1.0

Particles {
    x: 0; y: 0
    source: "../../images/star_particle.png"
    count: 1000
    lifeSpan: 200; lifeSpanDeviation: 50
    angleDeviation: 360
    angle: 0
    velocity: 100; velocityDeviation: 100
    emissionRate: 0
}
