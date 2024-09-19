import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Page {
    id: qstnPage

    background: Rectangle {
        anchors.fill: parent
        color: "transparent"
    }

    property var colors: ["#5BC0EB", "#FDE74C", "#9BC53D", "#C3423F"]


    footer: ColumnLayout {
        width: parent.width

        ListView {
                width: parent.width
                height: 100
                model: players
                delegate: Rectangle {
                    width: 100; height: 100
                    color: colors[playerId]

                    border.color: "yellow"
                    border.width: playerId == thisPlayerNum ? 3 : 0

                    Text {
                        anchors.centerIn: parent
                        text: playerName.toUpperCase()
                        font.pointSize: 26
                    }

                    Rectangle {
                        visible: playerId == currentMove
                        width: 100
                        height: 10
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                    }
                }
                spacing: (parent.width - players.count * 100) / (players.count - 1)
                orientation: Qt.Horizontal
            }
    }

    ColumnLayout {

        anchors.centerIn: parent
        spacing: 20

        Text {
            text: selectedCat
            font.pointSize: 50
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: selectedCost
            font.pointSize: 20
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: selectedQstn
            font.pointSize: 40
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: selectedAns
            visible: thisPlayerNum == 0
            font.pointSize: 20
            color: "white"
            horizontalAlignment: Qt.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Ответить"
            onClicked: {
                stack.pop()
                socket.sendTextMessage("start: " + code)
            }
        }
    }
}
