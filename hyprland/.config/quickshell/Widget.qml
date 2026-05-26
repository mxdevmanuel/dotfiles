import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    property alias content: container.data
    property string title: ""
    property string status: ""

    color: Theme.bg
    border.color: Theme.accent
    border.width: 1
    radius: 4
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignTop
    implicitHeight: container.height + 24

    Column {
        id: container
        spacing: 0
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 12
            leftMargin: 12
            rightMargin: 12
        }

        Row {
            spacing: 8
            bottomPadding: 10
            visible: root.title !== ""

            Text {
                text: "// " + root.title.toUpperCase()
                color: Theme.accent
                font.family: Theme.monoFont
                font.pixelSize: 10
                font.letterSpacing: 2
            }

            Text {
                text: root.status
                color: root.status === "unavailable" ? Theme.red : Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 10
                visible: root.status !== ""
            }
        }
    }
}
