

/*
  Copyright (C) 2015 Petr Vytovtov
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

Page {
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: header.height + content.height

        PageHeader {
            id: header
            title: qsTr("About") + " WiFi Analyser"
        }

        Column {
            id: content
            anchors.top: header.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2 * Theme.horizontalPageMargin
            spacing: Theme.paddingLarge

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge
                height: Theme.iconSizeExtraLarge
                source: "../harbour-wifianalyser.png"
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "v2.1.4"
            }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: "© 2016 Petr Vytovtov"
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("The simple tool for WiFi networks analyzing distributed under the terms of the GNU GPLv3.")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: qsTr("Homepage")
                onClicked: Qt.openUrlExternally("https://vk.com/kat_sailfishos")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: qsTr("Donate")
                onClicked: Qt.openUrlExternally(
                               "https://money.yandex.ru/to/410013326290845")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.buttonWidthMedium
                text: qsTr("Source code")
                onClicked: Qt.openUrlExternally(
                               "https://github.com/a-dekker/harbour-wifianalyser")
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                text: qsTr("This app uses icons by")
                      + " <a href=\"http://www.flaticon.com/authors/rami-mcmin\">Rami McMin</a>."
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
                text: qsTr("Localization") + ":<br>" + qsTr("Swedish")
                      + ": <a href=\"https://github.com/eson57\">Åke Engelbrektson</a><br>" + qsTr(
                          "Czech") + ": <a href=\"https://github.com/RikudouSage\">Rikudou Sennin</a><br>" + qsTr("French")
                      + ": <a href=\"https://github.com/Quent-in\">Rasher</a> & " + "<a href=\"https://github.com/Quenty31\">Quentí</a><br>" + qsTr(
                          "Finnish") + ": <a href=\"https://github.com/Gehock\">Sami Laine</a><br>"
                      + qsTr("Polish") + ": <a href=\"https://github.com/mp107\">mp107</a><br>"
                      + qsTr("Chinese") + ": <a href=\"https://github.com/dashinfantry\">dashinfantry</a>"
            }
        }

        VerticalScrollDecorator {
        }
    }
}
