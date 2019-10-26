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

PullDownMenu {

    property string pageName

    MenuItem {
        text: qsTr("About")
        onClicked: pageContainer.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
    }

    MenuItem {
        text: qsTr("Set as default")
        onClicked: {
            settings.setValue("defaultPage", pageName)
            pageStack.replaceAbove(
                        null, Qt.resolvedUrl("../pages/" + pageName), {}, PageStackAction.Immediate)
        }
    }
    MenuItem {
        text: frequencyBand === "2.4GHz" ? "5GHz" : "2.4GHz"
        onClicked: frequencyBand === "2.4GHz" ? frequencyBand = "5GHz" : frequencyBand = "2.4GHz"
    }
}
