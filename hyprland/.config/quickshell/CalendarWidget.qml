import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell

Widget {
    id: root
    title: "" // Handled customly in this widget
    Layout.maximumWidth: 300

    property int viewYear: (new Date()).getFullYear()
    property int viewMonth: (new Date()).getMonth()
    property var calData: {
        var _ = DataManager.sharedClock.date;
        var today = new Date();
        var first = new Date(viewYear, viewMonth, 1);
        var daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
        var cells = [];
        for (var i = 0; i < first.getDay(); i++) cells.push({ "day": 0, "isToday": false })
        for (var d = 1; d <= daysInMonth; d++) cells.push({
            "day": d,
            "isToday": d === today.getDate() && viewMonth === today.getMonth() && viewYear === today.getFullYear()
        })
        while (cells.length % 7 !== 0) cells.push({ "day": 0, "isToday": false })
        return cells;
    }

    content: Column {
        id: calBody
        spacing: 6
        width: parent.width

        Item {
            width: parent.width
            height: monthLabel.implicitHeight

            Text {
                text: "◀"
                color: Theme.accent
                font.family: Theme.monoFont
                font.pixelSize: 12
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.viewMonth === 0) {
                            root.viewMonth = 11;
                            root.viewYear--;
                        } else {
                            root.viewMonth--;
                        }
                    }
                }
            }

            Text {
                id: monthLabel
                text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy").toUpperCase()
                color: Theme.text
                font.family: Theme.monoFont
                font.pixelSize: 12
                font.letterSpacing: 2
                anchors.centerIn: parent
            }

            Text {
                text: "▶"
                color: Theme.accent
                font.family: Theme.monoFont
                font.pixelSize: 12
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.viewMonth === 11) {
                            root.viewMonth = 0;
                            root.viewYear++;
                        } else {
                            root.viewMonth++;
                        }
                    }
                }
            }
        }

        Row {
            width: parent.width
            Repeater {
                model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                Text {
                    width: calBody.width / 7
                    text: modelData
                    color: Theme.subtext
                    font.family: Theme.monoFont
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Repeater {
            model: Math.floor(root.calData.length / 7)
            Row {
                property int weekIdx: index
                width: calBody.width
                Repeater {
                    model: 7
                    Rectangle {
                        property var cell: root.calData[weekIdx * 7 + index]
                        width: calBody.width / 7
                        height: 20
                        color: cell.isToday ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15) : "transparent"
                        radius: 3

                        Text {
                            anchors.centerIn: parent
                            text: cell.day > 0 ? cell.day.toString() : ""
                            color: cell.isToday ? Theme.accent : Theme.text
                            font.family: Theme.monoFont
                            font.pixelSize: 12
                            font.bold: cell.isToday
                        }
                    }
                }
            }
        }
    }
}
