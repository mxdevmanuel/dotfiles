// quickshell/shell.qml

import QtQuick 2.15
import QtQuick.Layouts 1.15
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
    // Monitor statically assigned to workspace 10, resolved at startup from Hyprland rules
    property string ws10Monitor: ""

    Process {
        running: true
        command: ["sh", "-c", "hyprctl workspacerules -j | jq -r '.[] | select(.workspaceString == \"10\") | .monitor'"]
        stdout: SplitParser {
            onRead: line => { if (line.trim() !== "") ws10Monitor = line.trim(); }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: clockWindow
            property var modelData: modelData
            screen: modelData
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Bottom

            // Single monitor: always show. Multiple monitors: show only on ws10's monitor.
            readonly property bool isTarget:
                Quickshell.screens.length <= 1 || modelData.name === ws10Monitor

            visible: isTarget

            // Available height per row: screen height minus top/bottom margins and two row gaps
            readonly property int rowMaxHeight: Math.floor((modelData.height - 32 - 24 - 16) / 3)

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            margins {
                top: 32
                left: 24
                right: 24
                bottom: 24
            }

            ColumnLayout {
                spacing: 8
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 24
                    rightMargin: 24
                }

                // Row 1: Calendar, Email, Today's Events
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    CalendarWidget {}

                    EmailWidget {
                        model: DataManager.emailModel
                        maxHeight: clockWindow.rowMaxHeight
                    }

                    TodayCalWidget {
                        model: DataManager.calModel
                        Layout.maximumWidth: (clockWindow.modelData.height / 3)
                    }
                }

                // Row 2: Tasks, Jira
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    TodoWidget {
                        model: DataManager.todoModel
                        status: DataManager.todoStatus
                    }

                    JiraWidget {
                        model: DataManager.jiraModel
                        status: DataManager.jiraStatus
                        maxHeight: clockWindow.rowMaxHeight
                    }
                }

                // Row 3: World Clocks, Forex, Server Status
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    WorldClocksWidget {}

                    ForexWidget {
                        rate: DataManager.forexRate
                        change: DataManager.forexChange
                        changeDir: DataManager.forexChangeDir
                        status: DataManager.forexStatus
                    }

                    ServerWidget {
                        model: DataManager.serverModel
                    }
                }
            }
        }
    }
}
