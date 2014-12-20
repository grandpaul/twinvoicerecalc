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

Rectangle {
    id: root
    
    property real vat: 0.05

    Image {
        anchors.fill: parent
        source: "../image/background.jpg"
    }

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

            property var bestAnswer: null
            property int bestAnswerMin: 100000
            property int bestAnswerMinSum: 100000
            onClicked: {
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

                bestAnswer = null;
                bestAnswerMin = 100000;
                bestAnswerMinSum = 100000;
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
        }
    }

    Repeater {
        id: itemTable
        model: [
                   { y: 0.358 },
                   { y: 0.417 },
                   { y: 0.484 },
                   { y: 0.546 },
                   { y: 0.606 }
               ]
        delegate: Item {
            id: itemDelegate
            anchors.fill: parent
            property var itemCount: itemCount1
            property var itemUnitPrice: itemUnitPrice1
            property var itemTotalPrice: itemTotalPrice1

            TextInput {
                id: itemName1
                x: 0.05125 * parent.width
                y: modelData.y * parent.height
                width: 0.239 * parent.width
                height: 0.040 * parent.height

                font.pixelSize: Math.min(width, height)
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            TextInput {
                id: itemCount1
                x: 0.2975 * parent.width
                y: modelData.y * parent.height
                width: 0.0875 * parent.width
                height: 0.040 * parent.height

                font.pixelSize: Math.min(width, height)
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            TextInput {
                id: itemUnitPrice1
                x: 0.397 * parent.width
                y: modelData.y * parent.height
                width: 0.0875 * parent.width
                height: 0.040 * parent.height

                font.pixelSize: Math.min(width, height)
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: itemTotalPrice1
                x: 0.49625 * parent.width
                y: modelData.y * parent.height
                width: 0.16875 * parent.width
                height: 0.040 * parent.height

                text: {
                    if (!(itemUnitPrice1.text) || (!itemCount1.text)) {
                        return "";
                    } else {
                        return itemUnitPrice1.text * itemCount1.text;
                    }
                }
                font.pixelSize: Math.min(width, height)
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    Text {
        id: itemTotalPriceSum
        x: 0.49625 * parent.width
        y: 0.666 * parent.height
        width: 0.16875 * parent.width
        height: 0.040 * parent.height

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

        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: itemTax
        x: 0.49625 * parent.width
        y: 0.742 * parent.height
        width: 0.16875 * parent.width
        height: 0.040 * parent.height

        text: {
            var tax = 0.0;
            if (itemTotalPriceSum.text !== "") {
                tax = Math.round(vat * parseInt(itemTotalPriceSum.text));
            } else {
                return "";
            }
            return tax;
        }

        font.pixelSize: Math.min(width, height)
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    TextInput {
        id: total
        x: 0.4975 * parent.width
        y: 0.810 * parent.height
        width: 0.16875 * parent.width
        height: 0.04 * parent.height
        maximumLength: 9

        font.pixelSize: Math.min(width, height)
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
                   { x: 0.140,  digit: 8 },
                   { x: 0.200,  digit: 7 },
                   { x: 0.260,  digit: 6 },
                   { x: 0.318,  digit: 5 },
                   { x: 0.3775, digit: 4 },
                   { x: 0.4325, digit: 3 },
                   { x: 0.491,  digit: 2 },
                   { x: 0.550,  digit: 1 },
                   { x: 0.610,  digit: 0 }
               ]
        delegate: ChineseCapitalNumberText {
            x: modelData.x * parent.width
            y: 0.866 * parent.height
            width: 0.036 * parent.width
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
        y: 0.758 * parent.height
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
