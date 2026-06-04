import QtQuick 2.15
import QtQuick.Layouts 1.15

Widget {
    id: root
    title: "INBOX"
    property var model

    content: Column {
        width: parent.width

        Text {
            visible: root.model.count === 0
            text: "no unread mail"
            color: Theme.subtext
            font.family: Theme.monoFont
            font.pixelSize: 11
            font.italic: true
        }

        Repeater {
            model: root.model
            delegate: Column {
            width: parent.width
            spacing: 2
            topPadding: index === 0 ? 0 : 10

            Rectangle {
                visible: index > 0
                width: parent.width
                height: 1
                color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2)
            }

            Text {
                width: parent.width
                text: model.subject
                color: Theme.text
                font.family: Theme.monoFont
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: "  " + model.sender
                color: Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                visible: model.summary !== ""
                text: "  " + model.summary
                color: Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 11
                font.italic: true
                wrapMode: Text.WordWrap
            }
        }
        }
    }
}
