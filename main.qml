import QtQuick 2.12
import QtQuick.Controls 2.0
ApplicationWindow{
    id:app
    visibility:"Maximized"
    color: '#333'
    Item{
        id:xApp
        width:parent.width-48
        height: parent.height
        anchors.centerIn: parent
        Column{
            anchors.centerIn: parent
            spacing: 24
            Text{
                text:'Escribir un texto'
                font.pixelSize: 24
                color: 'white'
            }
            TextField{
                id: ti
                font.pixelSize: 24
                width: xApp.width
                Keys.onReturnPressed: {
                    speak(ti.text)
                }
            }
            Button{
                text: 'Hablar'
                onClicked: {
                    speak(ti.text)
                }
            }
            Text{
                text:'Detectar elemento'
                font.pixelSize: 24
                color: 'white'
            }
            Row{
                id:row
                spacing: 10
                Repeater{
                    id:rep
                    model:['red', 'yellow', 'blue', 'brown', 'pink']
                    property var a: ['rojo', 'amarillo', 'azul', 'marron', 'rosado']
                    Rectangle{
                        width: 50
                        height: 50
                        color: modelData
                        border.width: focus?10:0
                        border.color: "#ff8833"
                        //focus: true
                        KeyNavigation.tab: row.children[index+1]
                        function runVoice(){
                            timerSpeak.t='Sobre el color '+rep.a[index]
                            timerSpeak.restart()
                        }
                        onFocusChanged: if(focus)runVoice()
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                parent.runVoice()
                                parent.focus=true
                            }
                            onClicked: {
                                parent.runVoice()
                                parent.focus=true
                            }
                        }
                    }
                }
                Component.onCompleted: row.children[0].focus=true
            }
        }
    }


    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Timer{
        id: timerSpeak
        running: false
        repeat: false
        interval: 2500
        property string t: ''
        onTriggered: {
            speak(t)
        }
    }
    function speak(t){
        var d=new Date(Date.now())
        var f=unik.getPath(2)+'/voice-'+d.getTime()+'.vbs'
        var s='Dim speaks, speech\r\n'
        s+='speaks="'+t+'"\r\n'
        s+='Set speech=CreateObject("sapi.spvoice")\r\n'
        s+='speech.Speak speaks\r\n'
        unik.setFile(f,s)
        unik.run('cmd /c '+f)
    }
}
