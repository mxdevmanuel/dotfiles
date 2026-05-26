import QtQuick 2.15
import QtQuick.Layouts 1.15

Widget {
    id: root
    title: "TASKS"
    property var model
    property string status: ""

    content: Repeater {
        model: root.model
        delegate: Row {
            width: parent.width
            spacing: 8
            topPadding: index === 0 ? 0 : 6
            bottomPadding: 6

            Text {
                text: "▸"
                color: Theme.accent
                font.family: Theme.monoFont
                font.pixelSize: 11
                topPadding: 1
            }

            Column {
                spacing: 1
                width: parent.width - 18

                Text {
                    width: parent.width
                    text: model.name
                    color: Theme.text
                    font.family: Theme.monoFont
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    text: model.project
                    color: Theme.subtext
                    font.family: Theme.monoFont
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    visible: model.project !== ""
                    height: visible ? implicitHeight : 0
                }
            }
        }
    }
}
