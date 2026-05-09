import Quickshell // for PanelWindow
import Quickshell.Io // I/O
import QtQuick // for Text


Variants {
  model: Quickshell.screens;

  delegate: Component {

    PanelWindow {

      required property var modelData

      screen: modelData

      anchors {
        top: true
      }

      implicitHeight: 30

      Text {
        id: clock
        // center the bar in its parent component (the window)
        anchors.centerIn: parent

        Process {

          id: dateProc

          command: ['date']

          running: true

          stdout: StdioCollector {
            onStreamFinished: clock.text = this.text
          }
        }
      }

      Timer {
        interval: 1000

        running: true

        repeat: true

        onTriggered: dateProc.running = true
      }
    }
  }
}


