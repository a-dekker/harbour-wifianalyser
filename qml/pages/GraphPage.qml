

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

import "../views"

Page {
    id: graphPage

    property bool largeScreen: screen.width > 1080
    property bool mediumScreen: (screen.width > 540 && screen.width <= 1080)
    property bool smallScreen: (screen.width <= 540)
    property variant channelsInfo: [11, 16, 21, 26, 31, 36, 41, 46, 51, 56, 61, 66, 71, 83]

    property var strokeColors: ["rgb(255, 0, 0)", "rgb(128, 128, 0)", "rgb(255, 255, 0)", "rgb(0, 128, 0)", "rgb(0, 255, 0)", "rgb(0, 128, 128)", "rgb(0, 255, 255)", "rgb(0, 0, 128)", "rgb(0, 0, 255)", "rgb(128, 0, 128)", "rgb(255, 0, 255)", "rgb(128, 0, 0)"]
    property var fillColors: ["rgba(255, 0, 0, 0.33)", "rgba(128, 128, 0, 0.33)", "rgba(255, 255, 0, 0.33)", "rgba(0, 128, 0, 0.33)", "rgba(0, 255, 0, 0.33)", "rgba(0, 128, 128, 0.33)", "rgba(0, 255, 255, 0.33)", "rgba(0, 0, 128, 0.33)", "rgba(0, 0, 255, 0.33)", "rgba(128, 0, 128, 0.33)", "rgba(255, 0, 255, 0.33)", "rgba(128, 0, 0, 0.33)"]

    function calculateChannelsPositions(width) {
        var channels = []
        var step = (width - Theme.horizontalPageMargin) / 94
        for (var index in channelsInfo) {

            channels[index] = channelsInfo[index] * step + Theme.horizontalPageMargin
        }
        return channels
    }

    function rescaleFor5GHz(channel) {
        if (channel > 14) {
            channel = (channel / 15).toFixed(0)
        }
        return channel
    }

    function calculateSignalLevelsPositions(height) {
        var levels = []
        var step = (height - Theme.paddingLarge) / 10
        for (var index = 0; index < 10; ++index) {
            levels[index] = index * step + Theme.paddingLarge
        }
        return levels
    }

    function calculateCurrentSignalLevelPosition(height, level) {
        return (height - Theme.paddingLarge) / 100 * Math.abs(
                    level) + Theme.paddingLarge
    }

    function calculateBoundsPositionForChannel(width, channel) {
        var step = (width - Theme.horizontalPageMargin) / 94
        channel = rescaleFor5GHz(channel)
        var left = (channelsInfo[channel] - 11) * step + Theme.horizontalPageMargin
        var right = (channelsInfo[channel] + 11) * step + Theme.horizontalPageMargin
        return [left, right]
    }

    function drawGraphBounds(context) {
        context.beginPath()
        context.moveTo(2 * Theme.horizontalPageMargin, Theme.paddingLarge)
        context.lineTo(graph.width - Theme.horizontalPageMargin,
                       Theme.paddingLarge)
        context.lineTo(graph.width - Theme.horizontalPageMargin,
                       graph.height - Theme.paddingLarge)
        context.lineTo(2 * Theme.horizontalPageMargin,
                       graph.height - Theme.paddingLarge)
        context.closePath()
        context.stroke()
    }

    function drawChannelAxe(context, channelCoord) {
        context.beginPath()
        context.moveTo(channelCoord, Theme.paddingLarge)
        context.lineTo(channelCoord, graph.height - Theme.paddingLarge)
        context.closePath()
        context.stroke()
    }

    function drawChannelNumber(context, channelIndex, channelCoord) {
        var text = parseInt(channelIndex) + 1
        var textWidth = context.measureText(text).width
        context.fillText(text, channelCoord - (textWidth / 2), graph.height)
    }

    function drawChannelsAxes(context, channels) {
        context.lineWidth = 1
        for (var channelIndex in channels) {
            drawChannelAxe(context, channels[channelIndex])
            if (frequencyBand === "5GHz") {
                drawChannelNumber(context, channelIndex * 14,
                                  channels[channelIndex])
            } else {
                drawChannelNumber(context, channelIndex, channels[channelIndex])
            }
        }
    }

    function drawSignalLevelAxe(context, signalLevelCoord) {
        context.beginPath()
        context.moveTo(2 * Theme.horizontalPageMargin, signalLevelCoord)
        context.lineTo(graph.width - Theme.horizontalPageMargin,
                       signalLevelCoord)
        context.closePath()
        context.stroke()
    }

    function drawSignalLevel(context, signalLevel, signalLevelCoord) {
        if (signalLevel === '0')
            return
        var text = '-' + signalLevel + '0'
        var textWidth = context.measureText(text).width
        context.fillText(text, Theme.horizontalPageMargin - (textWidth / 2),
                         signalLevelCoord)
    }

    function drawSignalLevelsAxes(context, levels) {
        // draw raster
        for (var levelIndex in levels) {
            drawSignalLevelAxe(context, levels[levelIndex])
            drawSignalLevel(context, levelIndex, levels[levelIndex])
        }
    }

    function drawAxes(context, channels, levels) {
        drawGraphBounds(context)
        drawChannelsAxes(context, channels)
        drawSignalLevelsAxes(context, levels)
    }

    // More info:
    // http://codetheory.in/calculate-control-point-to-make-your-canvas-curve-hit-a-specific-point/
    function calculateCurrentPoint(channelCoord, levelPosition, bounds) {
        var cpx = 2 * channelCoord - (bounds[0] + bounds[1]) / 2
        var cpy = 2 * levelPosition - (graph.height + graph.height - (2 * Theme.paddingLarge)) / 2
        return {
            "x": cpx,
            "y": cpy
        }
    }

    function drawWifiFigure(context, channelCoord, levelPosition, bounds) {
        var cp = calculateCurrentPoint(channelCoord, levelPosition, bounds)
        context.beginPath()
        context.moveTo(bounds[0], graph.height - Theme.paddingLarge)
        context.quadraticCurveTo(cp.x, cp.y, bounds[1],
                                 graph.height - Theme.paddingLarge)
        context.closePath()
        context.stroke()
        context.fill()
    }

    function drawWifiName(context, wifiInfo, channels, levelPosition) {
        var textWidth = context.measureText(wifiInfo.name).width
        var mychan = calculateChannel(wifiInfo.frequency)
        if (mychan > 14 && frequencyBand === "5GHz") {
            mychan = rescaleFor5GHz(mychan)
        } else if (mychan < 15 && frequencyBand === "5GHz") {
            // set to dummy so 2.4 GHz it won't show up
            mychan = -1
        }
        context.fillText(wifiInfo.name, channels[mychan] - (textWidth / 2),
                         levelPosition - Theme.paddingSmall)
    }

    function drawWifiFigures(context, width, height, channels) {
        context.lineWidth = 2
        for (var networkIndex = 0; networkIndex < networksList.count; ++networkIndex) {
            var levelPosition = calculateCurrentSignalLevelPosition(
                        height, (networksList.get(networkIndex).strength - 120))
            var bounds = calculateBoundsPositionForChannel(
                        width, calculateChannel(networksList.get(
                                                    networkIndex).frequency))
            context.strokeStyle = strokeColors[networkIndex % strokeColors.length]
            context.fillStyle = fillColors[networkIndex % fillColors.length]
            var mychan = calculateChannel(networksList.get(
                                              networkIndex).frequency)
            if (mychan > 14 && frequencyBand === "5GHz") {
                mychan = rescaleFor5GHz(mychan)
            } else if (mychan < 15 && frequencyBand === "5GHz") {
                // set to dummy so 2.4 GHz it won't show up
                mychan = -1
            }
            drawWifiFigure(context, channels[mychan], levelPosition, bounds)
            context.fillStyle = context.strokeStyle
            drawWifiName(context, networksList.get(networkIndex), channels,
                         levelPosition)
        }
    }

    function drawGraph() {
        console.log("redraw now")
        var context = graph.getContext("2d")
        context.clearRect(0, 0, graph.width, graph.height)
        context.lineWidth = 3
        context.strokeStyle = "gray"
        context.fillStyle = "gray"
        smallScreen ? context.font = "12pt sans-serif" : mediumScreen ? context.font = "28pt sans-serif" : context.font = "32pt sans-serif"

        var channels = calculateChannelsPositions(graph.width)
        var levels = calculateSignalLevelsPositions(graph.height)
        drawAxes(context, channels, levels)

        if (networksList.count === 0)
            return
        drawWifiFigures(context, graph.width, graph.height, channels)
    }

    ViewPlaceholder {
        enabled: !networksList.powered
        text: qsTr("Please, turn WiFi on")
    }

    ViewPlaceholder {
        enabled: networksList.powered && networksList.count === 0
        text: qsTr("There are no WiFi networks")
    }

    SilicaFlickable {
        anchors.fill: parent

        TopMenu {
            pageName: "GraphPage.qml"
        }

        Canvas {
            id: graph
            anchors {
                fill: parent
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
                topMargin: Theme.paddingLarge
                bottomMargin: Theme.paddingLarge
            }

            onVisibleChanged: requestPaint()
            onPaint: drawGraph()
        }
    }

    Connections {
        target: networksList
        onScanRequestFinished: graph.requestPaint()
    }

    onOrientationChanged: graph.requestPaint()

    onStatusChanged: {
        if (status === PageStatus.Active && pageContainer.depth === 1
                && (!settings.value("defaultPage") || settings.value(
                        "defaultPage") === "GraphPage.qml"))
            pageContainer.pushAttached(Qt.resolvedUrl("ListPage.qml"))
    }
}
