import QtQuick 2.7
import QtQuick.Layouts 1.3
import "../Base"

HRectangle {
    property string displayName: ""
    property string topic: ""

    property alias buttonsImplicitWidth: viewButtons.implicitWidth
    property int buttonsWidth: viewButtons.Layout.preferredWidth
    property var activeButton: "members"

    property bool collapseButtons: width < 400

    id: roomHeader
    color: theme.chat.roomHeader.background

    HRowLayout {
        id: row
        spacing: 8
        anchors.fill: parent

        HRoomAvatar {
            id: avatar
            roomId: chatPage.roomId
            dimension: roomHeader.height
            Layout.alignment: Qt.AlignTop
        }

        HLabel {
            id: roomName
            text: displayName
            font.pixelSize: theme.fontSize.big
            elide: Text.ElideRight
            maximumLineCount: 1

            Layout.maximumWidth: Math.max(
                0,
                row.width - row.totalSpacing - avatar.width -
                viewButtons.width -
                (expandButton.visible ? expandButton.width : 0)
            )
        }

        HLabel {
            id: roomTopic
            text: topic
            font.pixelSize: theme.fontSize.small
            elide: Text.ElideRight
            maximumLineCount: 1

            Layout.maximumWidth: Math.max(
                0,
                row.width - row.totalSpacing - avatar.width -
                roomName.width - viewButtons.width -
                (expandButton.visible ? expandButton.width : 0)
            )
        }

        HSpacer {}

        Row {
            id: viewButtons
            Layout.preferredWidth: collapseButtons ? 0 : implicitWidth
            Layout.fillHeight: true

            Repeater {
                model: [
                    "members", "files", "notifications", "history", "settings"
                ]
                HButton {
                    iconName: "room_view_" + modelData
                    iconDimension: 22
                    autoExclusive: true
                    checked: activeButton == modelData
                    onClicked: activeButton = activeButton == modelData ?
                                              null : modelData
                }
            }

            Behavior on Layout.preferredWidth {
                HNumberAnimation { id: buttonsAnimation }
            }
        }
    }

    HButton {
        id: expandButton
        z: 1
        anchors.right: parent.right
        opacity: collapseButtons ? 1 : 0
        visible: opacity > 0
        iconName: "reduced_room_buttons"

        Behavior on opacity {
            HNumberAnimation { duration: buttonsAnimation.duration * 2 }
        }
    }
}
