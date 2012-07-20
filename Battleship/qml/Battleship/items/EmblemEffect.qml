// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import Qt.labs.particles 1.0

Particles {
    x: 0; y: 0
    //width: 500
    //height: 500
    source: "../../images/green_particle.png"
    count: 100
    lifeSpan: 1000; lifeSpanDeviation: 200
    angleDeviation: 30
    angle: -90
    velocity: 100; velocityDeviation: 100
    emissionRate: 100
}
