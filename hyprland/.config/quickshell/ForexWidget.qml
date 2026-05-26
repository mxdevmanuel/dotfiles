import QtQuick 2.15
import QtQuick.Layouts 1.15

Widget {
    id: root
    title: "USD → MXN"
    property string rate: ""
    property string change: ""
    property string changeDir: ""
    property string status: ""

    content: Column {
        spacing: 4
        width: parent.width

        Text {
            text: root.rate !== "" ? root.rate : "—"
            color: Theme.text
            font.family: Theme.monoFont
            font.pixelSize: 22
        }

        Row {
            spacing: 4
            visible: root.change !== ""
            topPadding: 2

            Text {
                text: root.changeDir === "up" ? "▲" : root.changeDir === "down" ? "▼" : "—"
                color: root.changeDir === "up" ? Theme.green : root.changeDir === "down" ? Theme.red : Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 11
            }

            Text {
                text: root.change + "%"
                color: root.changeDir === "up" ? Theme.green : root.changeDir === "down" ? Theme.red : Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 11
            }

            Text {
                text: "vs prev"
                color: Theme.subtext
                font.family: Theme.monoFont
                font.pixelSize: 10
            }
        }
    }
}
