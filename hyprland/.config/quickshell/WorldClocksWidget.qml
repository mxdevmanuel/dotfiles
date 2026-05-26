import QtQuick 2.15
import QtQuick.Layouts 1.15

Widget {
    id: root
    title: "WORLD CLOCKS"

    // Returns 1 if US DST is currently active, 0 otherwise.
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

    function fmtOffset(now, offsetHours) {
        var t = new Date(now.getTime() + now.getTimezoneOffset() * 60000 + offsetHours * 3.6e+06);
        var h = t.getHours();
        var m = t.getMinutes();
        return (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m;
    }

    content: RowLayout {
        width: parent.width

        Repeater {
            model: [
                { name: "Mountain Time", offset: -7, dst: true },
                { name: "Eastern Time", offset: -5, dst: true },
                { name: "Buenos Aires", offset: -3, dst: false }
            ]

            delegate: Column {
                spacing: 2
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true

                Text {
                    text: modelData.name
                    color: Theme.accent
                    font.family: Theme.monoFont
                    font.pixelSize: 10
                    font.letterSpacing: 1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: {
                        let now = DataManager.sharedClock.date;
                        let offset = modelData.offset;
                        if (modelData.dst) offset += root.usDst(now);
                        return root.fmtOffset(now, offset);
                    }
                    color: Theme.text
                    font.family: Theme.monoFont
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
