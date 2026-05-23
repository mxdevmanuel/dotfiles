// quickshell/shell.qml

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: clockWindow

            property var modelData
            property string todoStatus: ""
            property string jiraStatus: ""
            property string forexRate: ""
            property string forexStatus: ""

            screen: modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Bottom

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            margins {
                top: 16
            }

            Process {
                id: dashboardProc

                command: ["sh", "-c", "$HOME/.config/quickshell/scripts/.venv/bin/python $HOME/.config/quickshell/scripts/dashboard_fetch_mock.py"]
                running: true

                stdout: SplitParser {
                    onRead: (line) => {
                        const parts = line.split("|||");
                        if (parts[0] === "EMAIL" && parts.length === 3)
                            emailModel.append({
                            "subject": parts[1],
                            "sender": parts[2]
                        });
                        else if (parts[0] === "CAL" && parts.length === 4)
                            calModel.append({
                            "time": parts[1],
                            "title": parts[2],
                            "location": parts[3]
                        });
                    }
                }

            }

            Process {
                id: tududiProc

                command: ["sh", "-c", "$HOME/.config/quickshell/scripts/.venv/bin/python $HOME/.config/quickshell/scripts/tududi_fetch_mock.py"]
                running: true

                stdout: SplitParser {
                    onRead: (line) => {
                        const parts = line.split("|||");
                        if (parts[0] === "TODO" && parts.length === 3)
                            todoModel.append({
                            "name": parts[1],
                            "project": parts[2]
                        });
                        else if (parts[0] === "TODO_STATUS")
                            clockWindow.todoStatus = parts[1] === "cached" ? "cached · " + parts[2] : parts[1] === "unavailable" ? "unavailable" : "";
                    }
                }

            }

            Process {
                id: jiraProc

                command: ["sh", "-c", "$HOME/.config/quickshell/scripts/.venv/bin/python $HOME/.config/quickshell/scripts/jira_fetch_mock.py"]
                running: true

                stdout: SplitParser {
                    onRead: (line) => {
                        const parts = line.split("|||");
                        if (parts[0] === "JIRA" && parts.length === 5)
                            jiraModel.append({
                            "key": parts[1],
                            "summary": parts[2],
                            "priority": parts[3],
                            "status": parts[4]
                        });
                        else if (parts[0] === "JIRA_STATUS")
                            clockWindow.jiraStatus = parts[1] === "cached" ? "cached · " + parts[2] : parts[1] === "unavailable" ? "unavailable" : "";
                    }
                }

            }

            Process {
                id: forexProc

                command: ["sh", "-c", "$HOME/.config/quickshell/scripts/.venv/bin/python $HOME/.config/quickshell/scripts/forex_fetch_mock.py"]
                running: true

                stdout: SplitParser {
                    onRead: (line) => {
                        const parts = line.split("|||");
                        if (parts[0] === "FOREX" && parts.length >= 2)
                            clockWindow.forexRate = parts[1];
                        else if (parts[0] === "FOREX_STATUS")
                            clockWindow.forexStatus = parts[1] === "cached" ? "cached · " + parts[2] : parts[1] === "unavailable" ? "unavailable" : "";
                    }
                }

            }

            ColumnLayout {
                // RowLayout (top)
                // RowLayout (middle)
                // RowLayout (bottom)

                spacing: 8

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 16
                    rightMargin: 16
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        id: calendarWidget

                        property int viewYear: (new Date()).getFullYear()
                        property int viewMonth: (new Date()).getMonth()
                        property var calData: {
                            var _ = clock.date;
                            var today = new Date();
                            var first = new Date(viewYear, viewMonth, 1);
                            var daysInMonth = new Date(viewYear, viewMonth + 1, 0).getDate();
                            var cells = [];
                            for (var i = 0; i < first.getDay(); i++) cells.push({
                                "day": 0,
                                "isToday": false
                            })
                            for (var d = 1; d <= daysInMonth; d++) cells.push({
                                "day": d,
                                "isToday": d === today.getDate() && viewMonth === today.getMonth() && viewYear === today.getFullYear()
                            })
                            while (cells.length % 7 !== 0)cells.push({
                                "day": 0,
                                "isToday": false
                            })
                            return cells;
                        }

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.preferredWidth: 0
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: calBody.height + 24
                        Layout.maximumWidth: 300

                        SystemClock {
                            id: clock

                            precision: SystemClock.Minutes
                        }

                        Column {
                            id: calBody

                            spacing: 6

                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                topMargin: 12
                                leftMargin: 16
                                rightMargin: 16
                            }

                            Item {
                                width: parent.width
                                height: monthLabel.implicitHeight

                                Text {
                                    text: "◀"
                                    color: "#94e2d5"
                                    font.family: "monospace"
                                    font.pixelSize: 12
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (calendarWidget.viewMonth === 0) {
                                                calendarWidget.viewMonth = 11;
                                                calendarWidget.viewYear--;
                                            } else {
                                                calendarWidget.viewMonth--;
                                            }
                                        }
                                    }

                                }

                                Text {
                                    id: monthLabel

                                    text: Qt.formatDate(new Date(calendarWidget.viewYear, calendarWidget.viewMonth, 1), "MMMM yyyy").toUpperCase()
                                    color: "#cdd6f4"
                                    font.family: "monospace"
                                    font.pixelSize: 12
                                    font.letterSpacing: 2
                                    anchors.centerIn: parent
                                }

                                Text {
                                    text: "▶"
                                    color: "#94e2d5"
                                    font.family: "monospace"
                                    font.pixelSize: 12
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            if (calendarWidget.viewMonth === 11) {
                                                calendarWidget.viewMonth = 0;
                                                calendarWidget.viewYear++;
                                            } else {
                                                calendarWidget.viewMonth++;
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
                                        color: "#6c7086"
                                        font.family: "monospace"
                                        font.pixelSize: 11
                                        horizontalAlignment: Text.AlignHCenter
                                    }

                                }

                            }

                            Repeater {
                                model: Math.floor(calendarWidget.calData.length / 7)

                                Row {
                                    property int weekIdx: index

                                    width: calBody.width

                                    Repeater {
                                        model: 7

                                        Rectangle {
                                            property var cell: calendarWidget.calData[weekIdx * 7 + index]

                                            width: calBody.width / 7
                                            height: 20
                                            color: cell.isToday ? Qt.rgba(0.58, 0.886, 0.835, 0.15) : "transparent"
                                            radius: 3

                                            Text {
                                                anchors.centerIn: parent
                                                text: cell.day > 0 ? cell.day.toString() : ""
                                                color: cell.isToday ? "#94e2d5" : "#cdd6f4"
                                                font.family: "monospace"
                                                font.pixelSize: 12
                                                font.bold: cell.isToday
                                            }

                                        }

                                    }

                                }

                            }

                        }

                    }

                    Rectangle {
                        id: emailList

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: emailContent.height + 24

                        ListModel {
                            id: emailModel
                        }

                        Column {
                            id: emailContent

                            spacing: 0

                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                topMargin: 12
                                leftMargin: 12
                                rightMargin: 12
                            }

                            Text {
                                text: "// INBOX"
                                color: "#94e2d5"
                                font.family: "monospace"
                                font.pixelSize: 10
                                font.letterSpacing: 2
                                bottomPadding: 10
                            }

                            Repeater {
                                model: emailModel

                                delegate: Column {
                                    width: emailContent.width
                                    spacing: 2
                                    topPadding: index === 0 ? 0 : 10

                                    Rectangle {
                                        visible: index > 0
                                        width: parent.width
                                        height: 1
                                        color: Qt.rgba(0.58, 0.886, 0.835, 0.2)
                                    }

                                    Text {
                                        width: parent.width
                                        text: model.subject
                                        color: "#cdd6f4"
                                        font.family: "monospace"
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        width: parent.width
                                        text: "  " + model.sender
                                        color: "#6c7086"
                                        font.family: "monospace"
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                    }

                                }

                            }

                        }

                    }

                    Rectangle {
                        id: todayCal

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.maximumWidth: (clockWindow.modelData.height / 3)
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: calContent.height + 24

                        ListModel {
                            id: calModel
                        }

                        Column {
                            id: calContent

                            spacing: 0

                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                topMargin: 12
                                leftMargin: 12
                                rightMargin: 12
                            }

                            Text {
                                text: "// TODAY"
                                color: "#94e2d5"
                                font.family: "monospace"
                                font.pixelSize: 10
                                font.letterSpacing: 2
                                bottomPadding: 10
                            }

                            Repeater {
                                model: calModel

                                delegate: Row {
                                    width: calContent.width
                                    spacing: 8
                                    topPadding: index === 0 ? 0 : 6

                                    Text {
                                        text: model.time
                                        color: "#94e2d5"
                                        font.family: "monospace"
                                        font.pixelSize: 11
                                        width: 40
                                    }

                                    Column {
                                        spacing: 1
                                        width: calContent.width - 48

                                        Text {
                                            width: parent.width
                                            text: model.title
                                            color: "#cdd6f4"
                                            font.family: "monospace"
                                            font.pixelSize: 12
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            width: parent.width
                                            text: model.location
                                            color: "#6c7086"
                                            font.family: "monospace"
                                            font.pixelSize: 11
                                            elide: Text.ElideRight
                                            visible: model.location !== ""
                                            height: visible ? implicitHeight : 0
                                        }

                                    }

                                }

                            }

                        }

                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        id: todoList

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.preferredWidth: 0
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: todoContent.height + 24

                        ListModel {
                            id: todoModel
                        }

                        Column {
                            id: todoContent

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

                                Text {
                                    text: "// TASKS"
                                    color: "#94e2d5"
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    font.letterSpacing: 2
                                }

                                Text {
                                    text: clockWindow.todoStatus
                                    color: clockWindow.todoStatus === "unavailable" ? "#f38ba8" : "#6c7086"
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    visible: clockWindow.todoStatus !== ""
                                }

                            }

                            Repeater {
                                model: todoModel

                                delegate: Row {
                                    width: todoContent.width
                                    spacing: 8
                                    topPadding: index === 0 ? 0 : 6
                                    bottomPadding: 6

                                    Text {
                                        text: "▸"
                                        color: "#94e2d5"
                                        font.family: "monospace"
                                        font.pixelSize: 11
                                        topPadding: 1
                                    }

                                    Column {
                                        spacing: 1
                                        width: todoContent.width - 18

                                        Text {
                                            width: parent.width
                                            text: model.name
                                            color: "#cdd6f4"
                                            font.family: "monospace"
                                            font.pixelSize: 12
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            width: parent.width
                                            text: model.project
                                            color: "#6c7086"
                                            font.family: "monospace"
                                            font.pixelSize: 11
                                            elide: Text.ElideRight
                                            visible: model.project !== ""
                                            height: visible ? implicitHeight : 0
                                        }

                                    }

                                }

                            }

                        }

                    }

                    Rectangle {
                        id: jiraList

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.preferredWidth: 0
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: jiraContent.height + 24

                        ListModel {
                            id: jiraModel
                        }

                        Column {
                            id: jiraContent

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

                                Text {
                                    text: "// JIRA"
                                    color: "#94e2d5"
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    font.letterSpacing: 2
                                }

                                Text {
                                    text: clockWindow.jiraStatus
                                    color: clockWindow.jiraStatus === "unavailable" ? "#f38ba8" : "#6c7086"
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    visible: clockWindow.jiraStatus !== ""
                                }

                            }

                            Repeater {
                                model: jiraModel

                                delegate: Row {
                                    width: jiraContent.width
                                    spacing: 8
                                    topPadding: index === 0 ? 0 : 8
                                    bottomPadding: 2

                                    Text {
                                        text: {
                                            const p = model.priority;
                                            if (p === "Highest" || p === "High")
                                                return "▲";

                                            if (p === "Low" || p === "Lowest")
                                                return "▼";

                                            return "●";
                                        }
                                        color: {
                                            const p = model.priority;
                                            if (p === "Highest")
                                                return "#f38ba8";

                                            if (p === "High")
                                                return "#fab387";

                                            if (p === "Medium")
                                                return "#f9e2af";

                                            return "#6c7086";
                                        }
                                        font.family: "monospace"
                                        font.pixelSize: 10
                                        topPadding: 2
                                    }

                                    Column {
                                        spacing: 2
                                        width: jiraContent.width - 18

                                        Row {
                                            spacing: 6

                                            Text {
                                                text: model.key
                                                color: "#89b4fa"
                                                font.family: "monospace"
                                                font.pixelSize: 10
                                            }

                                            Text {
                                                text: model.status === "In Progress" ? "in progress" : "selected"
                                                color: model.status === "In Progress" ? "#a6e3a1" : "#6c7086"
                                                font.family: "monospace"
                                                font.pixelSize: 10
                                            }

                                        }

                                        Text {
                                            width: parent.width
                                            text: model.summary
                                            color: "#cdd6f4"
                                            font.family: "monospace"
                                            font.pixelSize: 12
                                            elide: Text.ElideRight
                                        }

                                    }

                                }

                            }

                        }

                    }

                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Rectangle {
                        // worldBody

                        id: clocksOfTheWorld

                        // Returns 1 if US DST is currently active, 0 otherwise.
                        // DST: 2nd Sunday March 02:00 EST → 1st Sunday November 02:00 EDT.
                        function usDst(now) {
                            var y = now.getUTCFullYear();
                            var m1 = new Date(Date.UTC(y, 2, 1));
                            var sun1Mar = (m1.getUTCDay() === 0) ? 1 : 8 - m1.getUTCDay();
                            var dstStart = Date.UTC(y, 2, sun1Mar + 7, 7); // 2 AM EST = UTC+5 → 07:00 UTC
                            var n1 = new Date(Date.UTC(y, 10, 1));
                            var sun1Nov = (n1.getUTCDay() === 0) ? 1 : 8 - n1.getUTCDay();
                            var dstEnd = Date.UTC(y, 10, sun1Nov, 6); // 2 AM EDT = UTC+4 → 06:00 UTC
                            return (now.getTime() >= dstStart && now.getTime() < dstEnd) ? 1 : 0;
                        }

                        function fmtOffset(offsetHours) {
                            var _ = clock.date;
                            var now = new Date();
                            var t = new Date(now.getTime() + now.getTimezoneOffset() * 60000 + offsetHours * 3.6e+06);
                            var h = t.getHours();
                            var m = t.getMinutes();
                            return (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m;
                        }

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: worldBody.implicitHeight + 24

                        Column {
                            // worldRow

                            id: worldBody

                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                topMargin: 12
                                leftMargin: 16
                                rightMargin: 16
                            }

                            Text {
                                text: "// WORLD CLOCKS"
                                color: "#94e2d5"
                                font.family: "monospace"
                                font.pixelSize: 10
                                font.letterSpacing: 2
                                bottomPadding: 10
                            }

                            RowLayout {
                                id: worldRow

                                width: parent.width

                                Column {
                                    spacing: 2
                                    Layout.alignment: Qt.AlignHCenter

                                    Text {
                                        text: "Mountain Time"
                                        color: "#94e2d5"
                                        font.family: "monospace"
                                        font.pixelSize: 10
                                        font.letterSpacing: 1.5
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Text {
                                        text: clocksOfTheWorld.fmtOffset(-7 + clocksOfTheWorld.usDst(new Date()))
                                        color: "#cdd6f4"
                                        font.family: "monospace"
                                        font.pixelSize: 14
                                    }

                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Column {
                                    spacing: 2
                                    Layout.alignment: Qt.AlignHCenter

                                    Text {
                                        text: "Eastern Time"
                                        color: "#94e2d5"
                                        font.family: "monospace"
                                        font.pixelSize: 10
                                        font.letterSpacing: 1.5
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Text {
                                        text: clocksOfTheWorld.fmtOffset(-5 + clocksOfTheWorld.usDst(new Date()))
                                        color: "#cdd6f4"
                                        font.family: "monospace"
                                        font.pixelSize: 14
                                    }

                                }

                                Item {
                                    Layout.fillWidth: true
                                }

                                Column {
                                    spacing: 2
                                    Layout.alignment: Qt.AlignHCenter

                                    Text {
                                        text: "Buenos Aires"
                                        color: "#94e2d5"
                                        font.family: "monospace"
                                        font.pixelSize: 10
                                        font.letterSpacing: 1.5
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Text {
                                        text: clocksOfTheWorld.fmtOffset(-3)
                                        color: "#cdd6f4"
                                        font.family: "monospace"
                                        font.pixelSize: 14
                                    }

                                }

                            }

                        }

                    }

                    Rectangle {
                        id: forexWidget

                        color: Qt.rgba(0, 0, 0, 0.25)
                        border.color: "#94e2d5"
                        border.width: 1
                        radius: 4
                        Layout.fillWidth: true
                        Layout.preferredWidth: 0
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: forexBody.implicitHeight + 24

                        Column {
                            id: forexBody

                            spacing: 4

                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                topMargin: 12
                                leftMargin: 16
                                rightMargin: 16
                            }

                            Row {
                                spacing: 8
                                bottomPadding: 10

                                Text {
                                    text: "// USD → MXN"
                                    color: "#94e2d5"
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    font.letterSpacing: 2
                                }

                                Text {
                                    text: clockWindow.forexStatus
                                    color: clockWindow.forexStatus === "unavailable" ? "#f38ba8" : "#6c7086"
                                    font.family: "monospace"
                                    font.pixelSize: 10
                                    visible: clockWindow.forexStatus !== ""
                                }

                            }

                            Text {
                                text: clockWindow.forexRate !== "" ? clockWindow.forexRate : "—"
                                color: "#cdd6f4"
                                font.family: "monospace"
                                font.pixelSize: 22
                            }

                        }


                    }
                        Rectangle {
                            color: Qt.rgba(0, 0, 0, 0.25)
                            border.color: "#94e2d5"
                            border.width: 1
                            radius: 4
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: 0
                            Layout.alignment: Qt.AlignTop
                        }
                    // RowLayout (world clocks)

                }

            }

        }

    }

}
