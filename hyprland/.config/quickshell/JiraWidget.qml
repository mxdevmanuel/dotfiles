import QtQuick 2.15
import QtQuick.Controls 2.15

Widget {
    id: root
    title: "JIRA"
    property var model
    property string status: ""
    property int maxHeight: 9999

    // overhead: topMargin(12) + header text+padding(20) + widget bottom(12) = 44
    readonly property int listHeight: Math.max(40, maxHeight - 44)

    content: ListView {
        id: list
        width: parent.width
        height: root.listHeight
        model: root.model
        clip: true
        spacing: 6
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        delegate: Row {
            width: list.width
            spacing: 8
            bottomPadding: 2

            Text {
                text: {
                    const p = model.priority;
                    if (p === "Highest" || p === "High") return "▲";
                    if (p === "Low" || p === "Lowest") return "▼";
                    return "●";
                }
                color: {
                    const p = model.priority;
                    if (p === "Highest") return Theme.red;
                    if (p === "High") return Theme.peach;
                    if (p === "Medium") return Theme.yellow;
                    return Theme.subtext;
                }
                font.family: Theme.monoFont
                font.pixelSize: 10
                topPadding: 2
            }

            Column {
                spacing: 2
                width: parent.width - 18

                Row {
                    spacing: 6
                    Text {
                        text: model.key
                        color: Theme.blue
                        font.family: Theme.monoFont
                        font.pixelSize: 10
                    }
                    Text {
                        text: model.status === "In Progress" ? "in progress" : "selected"
                        color: model.status === "In Progress" ? Theme.green : Theme.subtext
                        font.family: Theme.monoFont
                        font.pixelSize: 10
                    }
                }

                Text {
                    width: parent.width
                    text: model.summary
                    color: Theme.text
                    font.family: Theme.monoFont
                    font.pixelSize: 12
                    elide: Text.ElideRight
                }
            }
        }
    }
}
