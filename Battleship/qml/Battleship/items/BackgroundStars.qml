import Qt.labs.particles 1.0

Particles {
    width: 500
    height: 500
    source: "../../images/star_particle.png"
    count: 50
    lifeSpan: 4000; lifeSpanDeviation: 8000
    angleDeviation: 10
    velocity: 0; velocityDeviation: 0
    emissionRate: 500
    //opacity: 0.5
}
