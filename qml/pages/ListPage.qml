

/*
  Copyright (C) 2016 Petr Vytovtov
  Contact: Petr Vytovtov <osanwe@protonmail.ch>
  All rights reserved.

  This file is part of WiFi Analyser for Sailfish OS.

  WiFi Analyser is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  WiFi Analyser is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with WiFi Analyser.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.2
import Sailfish.Silica 1.0

import "../views"

Page {
    id: graphPage

    ViewPlaceholder {
        enabled: !networksList.powered
        text: qsTr("Please, turn WiFi on")
    }

    ViewPlaceholder {
        enabled: networksList.powered && networksList.count === 0
        text: qsTr("There are no WiFi networks")
    }

    SilicaListView {
        id: wifiInfoList

        anchors.fill: parent

        TopMenu {
            pageName: "ListPage.qml"
        }

        model: networksList

        delegate: Item {
            width: parent.width
            height: Theme.itemSizeHuge

            Column {
                anchors {
                    fill: parent
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                    topMargin: Theme.paddingLarge
                    verticalCenter: parent.verticalCenter
                }

                Row {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    height: childrenRect.height

                    Label {
                        width: parent.width / 2
                        horizontalAlignment: Text.AlignLeft
                        font.bold: true
                        text: modelData.name
                        truncationMode: TruncationMode.Fade
                        color: (calculateChannel(modelData.frequency) + 1)
                               > 14 ? Theme.highlightColor : Theme.primaryColor
                    }

                    Label {
                        width: parent.width / 4
                        horizontalAlignment: Text.AlignRight
                        text: (calculateChannel(
                                   modelData.frequency) + 1) + " ch."
                    }

                    Label {
                        width: parent.width / 4
                        horizontalAlignment: Text.AlignRight
                        text: (modelData.strength - 120) + " dBm"
                    }
                }

                Item {
                    anchors.right: parent.right
                    anchors.left: parent.left
                    height: childrenRect.height

                    Label {
                        anchors.left: parent.left
                        text: "bssid: " + modelData.bssid
                    }

                    Label {
                        anchors.right: parent.right
                        text: modelData.security.join("/")
                    }
                }

                ProgressBar {
                    width: parent.width
                    minimumValue: 0
                    maximumValue: 100
                    value: modelData.strength
                }
            }
        }

        VerticalScrollDecorator {
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Active && pageContainer.depth === 1
                && settings.value("defaultPage") === "ListPage.qml")
            pageContainer.pushAttached(Qt.resolvedUrl("GraphPage.qml"))
    }
}
