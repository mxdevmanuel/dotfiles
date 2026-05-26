import QtQuick 2.15
import QtQuick.Layouts 1.15

Widget {
    id: root
    title: "HOMELAB"
    property var model

    content: Repeater {
        model: root.model
        delegate: Row {
            width: parent.width
            spacing: 6
            topPadding: index === 0 ? 0 : 5

            Text {
                text: "●"
                color: model.status === "up" ? Theme.green : Theme.red
                font.family: Theme.monoFont
                font.pixelSize: 11
                topPadding: 1
            }

            Text {
                text: model.host
                color: model.status === "up" ? Theme.text : Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 12
            }
        }
    }
}
