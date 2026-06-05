import QtQuick 2.15
import QtQuick.Controls 2.15

Widget {
    id: root
    title: "INBOX"
    property var model
    property int maxHeight: 9999

    // overhead: topMargin(12) + header text+padding(20) + widget bottom(12) = 44
    readonly property int listHeight: Math.max(40, maxHeight - 44)

    status: root.model.count > 0 ? root.model.count + " unread" : ""

    content: Column {
        width: parent.width
        spacing: 0

        Text {
            visible: root.model.count === 0
            text: "no unread mail"
            color: Theme.subtext
            font.family: Theme.monoFont
            font.pixelSize: 11
            font.italic: true
        }

        ListView {
            id: list
            visible: root.model.count > 0
            width: parent.width
            height: root.listHeight
            model: root.model
            clip: true
            spacing: 0
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
            }

            delegate: Column {
                width: list.width
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
                    text: (index + 1) + ". " + model.subject
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
