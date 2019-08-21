

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
import MeeGo.Connman 0.2

import "pages"

ApplicationWindow {
    id: rootApp

    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    _defaultPageOrientations: Orientation.Portrait | Orientation.Landscape
                              | Orientation.LandscapeInverted

    property string frequencyBand: "2.4GHz"


    /**
     * The method calculates the WiFi-network channel.
     * @param frequency - the frequency of current WiFi-network
     * @return The channel number of current WiFi-network
     */
    function calculateChannel(frequency) {
        switch (frequency) {
        case 2412:
            return 0
        case 2417:
            return 1
        case 2422:
            return 2
        case 2427:
            return 3
        case 2432:
            return 4
        case 2437:
            return 5
        case 2442:
            return 6
        case 2447:
            return 7
        case 2452:
            return 8
        case 2457:
            return 9
        case 2462:
            return 10
        case 2467:
            return 11
        case 2472:
            return 12
        case 2484:
            return 13
            // 5GHz
        case 5035:
            return 6
        case 5040:
            return 7
        case 5045:
            return 8
        case 5055:
            return 10
        case 5060:
            return 11
        case 5080:
            return 15
        case 5160:
            return 31
        case 5170:
            return 33
        case 5180:
            return 35
        case 5190:
            return 37
        case 5200:
            return 39
        case 5210:
            return 41
        case 5220:
            return 43
        case 5230:
            return 45
        case 5240:
            return 47
        case 5250:
            return 49
        case 5260:
            return 51
        case 5270:
            return 53
        case 5280:
            return 55
        case 5290:
            return 57
        case 5300:
            return 59
        case 5310:
            return 61
        case 5320:
            return 63
        case 5340:
            return 67
        case 5480:
            return 95
        case 5500:
            return 99
        case 5510:
            return 101
        case 5520:
            return 103
        case 5530:
            return 105
        case 5540:
            return 107
        case 5550:
            return 109
        case 5560:
            return 111
        case 5570:
            return 113
        case 5580:
            return 115
        case 5590:
            return 117
        case 5600:
            return 119
        case 5610:
            return 121
        case 5620:
            return 123
        case 5630:
            return 125
        case 5640:
            return 127
        case 5660:
            return 131
        case 5670:
            return 133
        case 5680:
            return 135
        case 5690:
            return 137
        case 5700:
            return 139
        case 5710:
            return 141
        case 5720:
            return 143
        case 5745:
            return 148
        case 5755:
            return 150
        case 5765:
            return 152
        case 5775:
            return 154
        case 5785:
            return 156
        case 5795:
            return 158
        case 5805:
            return 160
        case 5825:
            return 164
        case 5845:
            return 168
        case 5865:
            return 172
        case 4915:
            return 182
        case 4920:
            return 183
        case 4925:
            return 184
        case 4935:
            return 186
        case 4940:
            return 187
        case 4945:
            return 188
        case 4960:
            return 191
        case 4980:
            return 195
        default:
            return -1
            // default: return -1;
        }
    }

    initialPage: settings.value(
                     "defaultPage") ? Qt.createComponent(
                                          Qt.resolvedUrl(
                                              "pages/" + settings.value(
                                                  "defaultPage"))) : Qt.createComponent(
                                          Qt.resolvedUrl("pages/GraphPage.qml"))
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    Timer {
        id: updateTimer
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: networksList.requestScan()
    }

    // More info:
    // https://git.merproject.org/mer-core/libconnman-qt/blob/master/plugin/technologymodel.h
    // https://git.merproject.org/mer-core/libconnman-qt/blob/master/libconnman-qt/networkservice.h
    TechnologyModel {
        id: networksList
        name: "wifi"
    }
}
