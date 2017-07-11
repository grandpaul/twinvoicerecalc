//  Taiwan invoice reverse calculator
//  Copyright (C) 2014 Ying-Chun Liu (PaulLiu) <paulliu@debian.org>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0

Image {
    id: root
    property real vat: 0.05
    property bool forwardMode: true
    source: "../image/background.jpg"

    width: 800
    height: 500

    MouseArea {
        enabled: false
        property real px: 0
        property real py: 0
        anchors.fill: parent
        onPressed: {
            px=mouse.x;
            py=mouse.y;
        }
        onReleased: {
            console.log("x: "+px/parent.width+" * parent.width");
            console.log("y: "+py/parent.height+" * parent.height");
            console.log("width: "+(mouse.x-px)/parent.width+" * parent.width");
            console.log("height: "+(mouse.y-py)/parent.height+" * parent.height");
        }
    }

    Rectangle {
        x: 0.48625 * parent.width
        y: 0.082 * parent.height
        width: 0.0425 * parent.width
        height: 0.032 * parent.height
	color: "white"
        ChineseNumberText {
            anchors.fill: parent
            num: {
                var now = new Date();
                return Math.floor(now.getMonth()/2)*2+1;
            }
        }
    }

    Rectangle {
        x: 0.5575 * parent.width
        y: 0.082 * parent.height
        width: 0.04375 * parent.width
        height: 0.032 * parent.height
	color: "white"
        ChineseNumberText {
            anchors.fill: parent
            num: {
                var now = new Date();
                return Math.floor(now.getMonth()/2)*2+2;
            }
        }
    }

    Rectangle {
        x: 0.3938 * parent.width
        y: 0.082 * parent.height
        width: 0.06625 * parent.width
        height: 0.032 * parent.height
	color: "white"
        ChineseNumberText {
            anchors.fill: parent
            num: {
                var now = new Date();
                return now.getFullYear()-1911;
            }
        }
    }

    Rectangle {
        x: 0.57125 * parent.width
        y: 0.19 * parent.height
        width: 0.035 * parent.width
        height: 0.03 * parent.height
	color: "white"
        Text {
            id: dateYear
	    anchors.fill: parent
            text: {
                var now = new Date();
                return now.getFullYear()-1911;
            }
            font.pixelSize: Math.min(width, height)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Text {
        id: dateMonth
        x: 0.6375 * parent.width
        y: 0.188 * parent.height
        width: 0.038 * parent.width
        height: 0.038 * parent.height

        text: {
            var now = new Date();
            return now.getMonth()+1;
        }

        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: dateDate
        x: 0.71 * parent.width
        y: 0.188 * parent.height
        width: 0.038 * parent.width
        height: 0.038 * parent.height

        text: {
            var now = new Date();
            return now.getDate();
        }

        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: message
        x: 0.68125 * parent.width
        y: 0.36 * parent.height
        width: 0.26 * parent.width
        height: 0.044 * parent.height
	visible: !root.forwardMode

        text: ""
        
        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        states: [
            State {
                name: "waitForTotal"
                when: !(total.text)
                PropertyChanges { target: message; text: "請先輸入總計" }
            },
            State {
                name: "verified"
                when: total.isPriceSame
                PropertyChanges { target: message; text: "驗證成功" }
            },
            State {
                name: "waitForUnitPrice"
                when: total.text && (! total.isPriceSame)
                PropertyChanges { target: message; text: "輸入數量及粗估單價" }
            }
        ]
    }

    Repeater {
        id: vendorVAT
	model: [
	    { x: 0.16 },
	    { x: 0.195 },
	    { x: 0.23 },
	    { x: 0.265 },
	    { x: 0.30 },
	    { x: 0.335 },
	    { x: 0.37 },
	    { x: 0.405 }
	]
        delegate: TextInput {
            id: vendorVAT1
            x: modelData.x * parent.width
            y: 0.19 * parent.height
            width: 0.02625 * parent.width
            height: 0.042 * parent.height
            font.pixelSize: Math.min(width, height)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
	}
    }

    Image {
        id: stampImage
        x: 0.68 * parent.width
        y: 0.54 * parent.height
        width: (208.45 / 800.0) * parent.width
        height: (181.47 / 500.0) * parent.height
        source: "../image/stamp.png"
        states: [
            State {
                name: "canbefixed"
                when: !total.isPriceSame && Math.abs(parseInt(total.text)-parseInt(itemTotalPriceSum.text)-parseInt(itemTax.text)) <= 10
        PropertyChanges { target: stampImage; visible: true; source: "../image/molumen_ussr_calculator.png" }
                PropertyChanges { target: stampMouseArea; enabled: true }
            },
            State {
                name: "nonverified"
                when: !total.isPriceSame
                PropertyChanges { target: stampImage; visible: false }
                PropertyChanges { target: stampMouseArea; enabled: false }
            },
            State {
                name: "verified"
                when: total.isPriceSame
                PropertyChanges { target: stampImage; visible: true; source: "../image/stamp.png" }
                PropertyChanges { target: stampMouseArea; enabled: false }
            }
        ]
        MouseArea {
            id: stampMouseArea
            anchors.fill: parent
            enabled: false

            function truncate(number) {
                return x > 0
                ? Math.floor(number)
                : Math.ceil(number);
            }

            function correctUnitPrices() {
                var bestAnswer = null;
                var bestAnswerMin = Infinity;
                var bestAnswerMinSum = Infinity;

                var anso=new Array(itemTable.count);
                var ans=new Array(itemTable.count);
                var itemunitprices = new Array(itemTable.count);
                var itemcounts = new Array(itemTable.count);
                for (var i=0; i<anso.length; i++) {
                    anso[i]=-1;
                }
                for (var i=0; i<ans.length; i++) {
                    ans[i]=0;
                }
                for (var i=0; i<itemunitprices.length; i++) {
                    itemunitprices[i] = itemTable.itemAt(i).itemUnitPrice;
                }
                for (var i=0; i<itemcounts.length; i++) {
                    itemcounts[i] = parseInt(itemTable.itemAt(i).itemCount.text);
                }

                for (var i=0; i>=0; ) {
                    if (i>=ans.length) {
                        // check if valid
                        var vsum=0;
                        for (var j=0; j<itemcounts.length; j++) {
                            if ( !itemcounts[j] ) {
                                continue;
                            }
                            if ( !itemunitprices[j].text) {
                                continue;
                            }
                            vsum += (parseInt(itemunitprices[j].text)+ans[j])*itemcounts[j];
                        }
                        vsum = vsum + Math.round(vsum*vat);
                        if (vsum == parseInt(total.text)) {
                            // valid
                            var nowMaxABS=0;
                            var nowSumABS=0;
                            for (var j=0; j<ans.length; j++) {
                                if (Math.abs(ans[j]) > nowMaxABS) {
                                    nowMaxABS = Math.abs(ans[j]);
                                }
                                nowSumABS += Math.abs(ans[j]);
                            }
                            if (nowMaxABS < bestAnswerMin) {
                                bestAnswerMin = nowMaxABS;
                                bestAnswerMinSum = nowSumABS;
                                bestAnswer = ans.slice(0);
                            } else if (nowMaxABS <= bestAnswerMin && nowSumABS < bestAnswerMinSum) {
                                bestAnswerMin = nowMaxABS;
                                bestAnswerMinSum = nowSumABS;
                                bestAnswer = ans.slice(0);
                            }
                        }
                        i--;
                        continue;
                    }
                    anso[i]++;
                    if (anso[i]>20) {
                        anso[i]=-1;
                        ans[i]=0;
                        i--;
                        continue;
                    }
                    ans[i] = truncate(((anso[i]%2)*2-1)*((anso[i]+1)/2));
                    if (Math.abs(ans[i]) > bestAnswerMin) {
                        anso[i]=-1;
                        ans[i]=0;
                        i--;
                        continue;
                    }
                    var sum001=0;
                    for (var j=0; j<=i; j++) {
                        sum001 += Math.abs(ans[j]);
                    }
                    if (sum001 > bestAnswerMinSum) {
                        anso[i]=-1;
                        ans[i]=0;
                        i--;
                        continue;
                    }
                    if ( (!(itemcounts[i])) && ans[i] != 0) {
                        anso[i]=-1;
                        ans[i]=0;
                        i--;
                        continue;
                    }
                    if ( (itemunitprices[i].text) && parseInt(itemunitprices[i].text)+ans[i] <= 0) {
                        continue;
                    }
                    i++;
                }
                if (bestAnswer) {
                    for (var i=0; i<bestAnswer.length; i++) {
                        if (!itemunitprices[i].text) {
                            continue;
                        }
                        if (!bestAnswer[i]) {
                            continue;
                        }
                        itemunitprices[i].text = parseInt(itemunitprices[i].text) + bestAnswer[i];
                    }
                }
	    }

            onClicked: {
                correctUnitPrices();
            }
        }
    }

    Repeater {
        id: itemTable
        model: [
                   { y: 0.350 },
                   { y: 0.411 },
                   { y: 0.473 },
                   { y: 0.535 },
                   { y: 0.597 }
               ]
        delegate: Item {
            id: itemDelegate
            anchors {
                left: parent.left
                right: parent.right
            }
            y: modelData.y * parent.height
            height: 0.055 * parent.height
            property var itemCount: itemCount1
            property var itemUnitPrice: itemUnitPrice1
            property var itemTotalPrice: itemTotalPrice1

            TextInput {
                id: itemName1
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                x: 0.05125 * parent.width
                width: 0.239 * parent.width

                font.pixelSize: 0.7 * Math.min(width, height)
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            TextInput {
                id: itemCount1
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                x: 0.2975 * parent.width
                width: 0.0875 * parent.width

                font.pixelSize: 0.7 * Math.min(width, height)
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            TextInput {
                id: itemUnitPrice1
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                x: 0.397 * parent.width
                width: 0.0875 * parent.width

                font.pixelSize: 0.7 * Math.min(width, height)
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: itemTotalPrice1
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                x: 0.49625 * parent.width
                width: 0.16875 * parent.width

                text: {
                    if (!(itemUnitPrice1.text) || (!itemCount1.text)) {
                        return "";
                    } else {
                        return itemUnitPrice1.text * itemCount1.text;
                    }
                }
                font.pixelSize: 0.7 * Math.min(width, height)
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Image {
        id: columnsCancelMarkImage
        source: "../image/columns_cancel_mark.svg"
        x: 0.49625 * parent.width
	y: 0.652 * parent.height - height
        width: 0.16875 * parent.width
	property int itemTableCount: {
	    var ret1=0;
	    for (var i=0; i<itemTable.count; i++) {
	        var item = itemTable.itemAt(i);
	        if (item.itemTotalPrice.text != "") {
		    ret1=i+1;
		}
	    }
	    return ret1;
	}
	height: 0.300 * parent.height * (itemTable.count - itemTableCount) / itemTable.count
	visible: itemTableCount == itemTable.count ? false : true
    }

    Text {
        id: itemTotalPriceSum
        x: 0.49625 * parent.width
        y: 0.659 * parent.height
        width: 0.16875 * parent.width
        height: 0.055 * parent.height

        text: {
            var sum=0;
            for (var i=0; i<itemTable.count; i++) {
                var item = itemTable.itemAt(i);

                if (item.itemTotalPrice.text !== "") {
                    sum = sum + parseInt(item.itemTotalPrice.text);
                } else if (i<=0) {
                    return "";
                }
            }
            return sum;
        }

        font.pixelSize: 0.7 * Math.min(width, height)
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: itemTax
        x: 0.49625 * parent.width
        y: 0.73 * parent.height
        width: 0.16875 * parent.width
        height: 0.055 * parent.height

        text: {
            var tax = 0.0;
            if (itemTotalPriceSum.text !== "") {
                tax = Math.round(vat * parseInt(itemTotalPriceSum.text));
            } else {
                return "";
            }
            return tax;
        }

        font.pixelSize: 0.7 * Math.min(width, height)
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    TextInput {
        id: total
        x: 0.4975 * parent.width
        y: 0.794 * parent.height
        width: 0.16875 * parent.width
        height: 0.055 * parent.height
        maximumLength: 9

        font.pixelSize: 0.7 * Math.min(width, height)
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        readonly property bool isPriceSame: {
            var sum=0;
            if (itemTotalPriceSum.text != "" && itemTax.text != "") {
                sum = parseInt(itemTotalPriceSum.text) + parseInt(itemTax.text);
            }
            if (sum != parseInt(total.text)) {
                return false;
            }
            return true;
        }

        states: [
            State {
                name: "forward"
                when: root.forwardMode
                PropertyChanges { target: total; readOnly: true; text: itemTotalPriceSum.text != "" && itemTax.text != "" ? parseInt(itemTotalPriceSum.text) + parseInt(itemTax.text) : "" }
            },
            State {
                name: "backward"
                when: !root.forwardMode
                PropertyChanges { target: total; readOnly: false; text: "" }
            }
        ]
        color: isPriceSame ? "black" : "red"
    }

    function getDigit(a, base) {
        if (a >= base) {
            return (a/base)%10;
        } else {
            return -1;
        }
    }

    function intPow(a, r) {
        var ans = 1;
        var t=a;
        while (r>=1) {
            if (r%2==0) {
                r/=2;
            } else {
                ans*=t;
                r=(r-1)/2;
            }
            t=t*t;
        }
        return ans;
    }

    Repeater {
        model: [
                   { x: 0.144,  digit: 8 },
                   { x: 0.204,  digit: 7 },
                   { x: 0.264,  digit: 6 },
                   { x: 0.322,  digit: 5 },
                   { x: 0.3815, digit: 4 },
                   { x: 0.4365, digit: 3 },
                   { x: 0.495,  digit: 2 },
                   { x: 0.554,  digit: 1 },
                   { x: 0.614,  digit: 0 }
               ]
        delegate: ChineseCapitalNumberText {
            x: modelData.x * parent.width
            y: 0.866 * parent.height
            width: 0.028 * parent.width
            height: 0.036 * parent.height
            digit: getDigit(total.text, intPow(10,modelData.digit));
        }
    }

    Rectangle {
        id: totalLine1
        x: 0.140 * parent.width
        y: 0.880 * parent.height
        width: 0.529 * parent.width
        height: 0.0025 * parent.height
        color: "black"
        visible: false
        states: [
            State {
                name: "100000000"
                when: parseInt(total.text) >= 100000000
                PropertyChanges { target: totalLine1; visible: false}
            },
            State {
                name: "10000000"
                when: parseInt(total.text) >= 10000000
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 1.0 / 9.0 * parent.width }
            },
            State {
                name: "1000000"
                when: parseInt(total.text) >= 1000000
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 2.0 / 9.0 * parent.width }
            },
            State {
                name: "100000"
                when: parseInt(total.text) >= 100000
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 3.0 / 9.0 * parent.width }
            },
            State {
                name: "10000"
                when: parseInt(total.text) >= 10000
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 4.0 / 9.0 * parent.width }
            },
            State {
                name: "1000"
                when: parseInt(total.text) >= 1000
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 5.0 / 9.0 * parent.width }
            },
            State {
                name: "100"
                when: parseInt(total.text) >= 100
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 6.0 / 9.0 * parent.width }
            },
            State {
                name: "10"
                when: parseInt(total.text) >= 10
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 7.0 / 9.0 * parent.width }
            },
            State {
                name: "1"
                when: parseInt(total.text) >= 1
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 8.0 / 9.0 * parent.width }
            },
            State {
                name: "0"
                when: parseInt(total.text) >= 0
                PropertyChanges { target: totalLine1; visible: true; width: 0.529 * 9.0 / 9.0 * parent.width }
            }
        ]
    }

    Rectangle {
        id: totalLine2
        anchors.left: totalLine1.left
        anchors.right: totalLine1.right
        y: 0.890 * parent.height
        height: totalLine1.height
        color: "black"
        visible: totalLine1.visible
    }

    Text {
        id: taxCheck
        x: 0.26625 * parent.width
        y: 0.755 * parent.height
        width: 0.0225 * parent.width
        height: 0.036 * parent.height

        text: "✓"
        
        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    TextInput {
        id: title
        x: 0.155 * parent.width
        y: 0.13 * parent.height
        width: 0.29875 * parent.width
        height: 0.034 * parent.height

        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}
