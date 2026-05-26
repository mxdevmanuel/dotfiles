pragma Singleton
import QtQuick 2.15
import Quickshell
import Quickshell.Io

Item {
    id: root

    SystemClock {
        id: sharedClock
        precision: SystemClock.Minutes
    }

    readonly property alias sharedClock: sharedClock

    property bool useMock: false
    property string scriptDir: "$HOME/.config/quickshell/scripts"
    property string pythonPath: scriptDir + "/.venv/bin/python"

    function getCommand(script) {
        let name = script + (useMock ? "_mock.py" : ".py");
        return ["sh", "-c", `${pythonPath} ${scriptDir}/${name}`];
    }

    // Models
    readonly property ListModel emailModel: ListModel {}
    readonly property ListModel calModel: ListModel {}
    readonly property ListModel todoModel: ListModel {}
    readonly property ListModel jiraModel: ListModel {}
    readonly property ListModel serverModel: ListModel {}

    // Status properties
    property string todoStatus: ""
    property string jiraStatus: ""
    property string forexStatus: ""
    property string forexRate: ""
    property string forexChange: ""
    property string forexChangeDir: ""

    // Helper component for fetching data
    component FetchProcess: Item {
        id: fetchRoot
        property alias command: proc.command
        property alias running: proc.running
        property var onLineRead: (line) => {}
        property var onRefresh: () => {}
        property int refreshInterval: 300000
        property ListModel modelToClear: null

        Process {
            id: proc
            running: true
            stdout: SplitParser {
                onRead: (line) => fetchRoot.onLineRead(line)
            }
            onRunningChanged: {
                if (!running) refreshTimer.start();
            }
        }

        Timer {
            id: refreshTimer
            interval: fetchRoot.refreshInterval
            onTriggered: {
                if (fetchRoot.modelToClear) fetchRoot.modelToClear.clear();
                fetchRoot.onRefresh();
                proc.running = true;
            }
        }
    }

    FetchProcess {
        id: dashboardProc
        command: getCommand("dashboard_fetch")
        onRefresh: () => {
            emailModel.clear();
            calModel.clear();
        }
        onLineRead: (line) => {
            const parts = line.split("|||");
            if (parts[0] === "EMAIL" && parts.length === 3)
                emailModel.append({ "subject": parts[1], "sender": parts[2] });
            else if (parts[0] === "CAL" && parts.length === 4)
                calModel.append({ "time": parts[1], "title": parts[2], "location": parts[3] });
        }
    }

    FetchProcess {
        id: tududiProc
        command: getCommand("tududi_fetch")
        modelToClear: todoModel
        onLineRead: (line) => {
            const parts = line.split("|||");
            if (parts[0] === "TODO" && parts.length === 3)
                todoModel.append({ "name": parts[1], "project": parts[2] });
            else if (parts[0] === "TODO_STATUS")
                todoStatus = parts[1] === "cached" ? "cached · " + parts[2] : parts[1] === "unavailable" ? "unavailable" : "";
        }
    }

    FetchProcess {
        id: jiraProc
        command: getCommand("jira_fetch")
        modelToClear: jiraModel
        onLineRead: (line) => {
            const parts = line.split("|||");
            if (parts[0] === "JIRA" && parts.length === 5)
                jiraModel.append({ "key": parts[1], "summary": parts[2], "priority": parts[3], "status": parts[4] });
            else if (parts[0] === "JIRA_STATUS")
                jiraStatus = parts[1] === "cached" ? "cached · " + parts[2] : parts[1] === "unavailable" ? "unavailable" : "";
        }
    }

    FetchProcess {
        id: serverProc
        command: getCommand("server_check")
        modelToClear: serverModel
        onLineRead: (line) => {
            const parts = line.split("|||");
            if (parts[0] === "SERVER" && parts.length === 3)
                serverModel.append({ "host": parts[1], "status": parts[2] });
        }
    }

    FetchProcess {
        id: forexProc
        command: getCommand("forex_fetch")
        refreshInterval: 3600000
        onLineRead: (line) => {
            const parts = line.split("|||");
            if (parts[0] === "FOREX" && parts.length >= 2)
                forexRate = parts[1];
            else if (parts[0] === "FOREX_CHANGE" && parts.length === 3) {
                forexChange = parts[1];
                forexChangeDir = parts[2];
            } else if (parts[0] === "FOREX_STATUS")
                forexStatus = parts[1] === "cached" ? "cached · " + parts[2] : parts[1] === "unavailable" ? "unavailable" : "";
        }
    }
}
