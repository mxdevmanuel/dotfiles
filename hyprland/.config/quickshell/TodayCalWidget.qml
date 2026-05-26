import QtQuick 2.15
import QtQuick.Layouts 1.15

Widget {
    id: root
    title: "TODAY"
    property var model

    content: Repeater {
        model: root.model
        delegate: Row {
            width: parent.width
            spacing: 8
            topPadding: index === 0 ? 0 : 6

            Text {
                text: model.time
                color: Theme.accent
                font.family: Theme.monoFont
                font.pixelSize: 11
                width: 40
            }

            Column {
                spacing: 1
                width: parent.width - 48

                Text {
                    width: parent.width
                    text: model.title
                    color: Theme.text
                    font.family: Theme.monoFont
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }

                Text {
                    width: parent.width
                    text: model.location
                    color: Theme.subtext
                    font.family: Theme.monoFont
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    visible: model.location !== ""
                    height: visible ? implicitHeight : 0
                }
            }
        }
    }
}
