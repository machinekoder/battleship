// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: 500
    height: 500
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#000000"
        }

        GradientStop {
            position: 1
            color: "#000000"
        }
    }

    Grid {
        id: grid1
        rows: 10
        columns: 10
        anchors.fill: parent

        FieldPart {
            id: fieldpart1
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart2
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart3
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart4
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart5
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart6
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart7
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart8
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart9
            width: parent.width / 10
            height: parent.height / 10
        }
        FieldPart {
            id: fieldpart10
            width: parent.width / 10
            height: parent.height / 10
        }
    }
}
