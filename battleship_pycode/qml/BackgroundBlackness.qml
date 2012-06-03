import Qt.labs.particles 1.0

Particles {
    source: "../images/black_particle.png"
    count: 300
    lifeSpan: 3000; lifeSpanDeviation: 2000
    angleDeviation: 10
    velocity: 0; velocityDeviation: 0
    emissionRate: 500
}
