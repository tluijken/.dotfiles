import QtQuick 2.0

FocusScope {
    id: container
    width: 80; height: 30

    property color color: "white"
    property color borderColor: "#ababab"
    property color focusColor: "#266294"
    property color hoverColor: "#5692c4"
    property alias font: txtMain.font
    property alias textColor: txtMain.color
    property alias echoMode: txtMain.echoMode
    property alias text: txtMain.text

    Rectangle {
        id: main

        anchors.fill: parent

        color: container.color
        border.color: container.borderColor
        border.width: 1
        radius: config.RoundCorners

        Behavior on border.color { ColorAnimation { duration: 100 } }

        states: [
            State {
                name: "hover"; when: mouseArea.containsMouse
                PropertyChanges { target: main; border.width: 1; border.color: container.hoverColor }
            },
            State {
                name: "focus"; when: container.activeFocus && !mouseArea.containsMouse
                PropertyChanges { target: main; border.width: 1; border.color: container.focusColor }
            }
        ]
    }

    MouseArea {
        id: mouseArea
        anchors.fill: container

        cursorShape: Qt.IBeamCursor

        hoverEnabled: true

        onEntered: if (main.state == "") main.state = "hover";
        onExited: if (main.state == "hover") main.state = "";
        onClicked: container.focus = true;
    }

    TextInput {
        id: txtMain
        width: parent.width - 16
        anchors.centerIn: parent

        color: "red"

        clip: true
        focus: true

        passwordCharacter: "\u25cf"
    }
}
