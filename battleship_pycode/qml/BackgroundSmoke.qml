// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import Qt.labs.particles 1.0

Particles {
    width: 500
    height: 500
    source: "../images/smoke_particle.png"
    count: 300
    lifeSpan: 3000; lifeSpanDeviation: 2000
    angleDeviation: 10
    velocity: 100; velocityDeviation: 100
    emissionRate: 500
}
