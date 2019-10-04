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
                onFocusChanged: if(focus)runVoice('Escribir aquí un texto y presionar la tecla Enter')
                KeyNavigation.tab: btnSpeak
                Keys.onReturnPressed: {
                    speak(ti.text)
                }
                Rectangle{
                    width: parent.width+10
                    height: parent.height+10
                    color: 'transparent'
                    border.width: parent.focus?10:0
                    border.color: "#ff8833"
                    anchors.centerIn: parent
                }
            }
            Button{
                id:btnSpeak
                text: 'Hablar'
                onFocusChanged: {
                    if(focus&&ti.text!=='')runVoice('Hacer click en este boton para hablar')
                    if(focus&&ti.text==='')runVoice('El campo de texto esta vacio, ingrese un texto para poder convertirlo a voz.')
                }
                KeyNavigation.tab: row.children[0]
                onClicked: {
                    speak(ti.text)
                }
                Rectangle{
                    width: parent.width+10
                    height: parent.height+10
                    color: 'transparent'
                    border.width: parent.focus?10:0
                    border.color: "#ff8833"
                    anchors.centerIn: parent
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
                        objectName: 'rect'+index
                        KeyNavigation.tab: index===3?row.children[5]: index===4?ti:row.children[index+1]
                        onFocusChanged: if(focus)runVoice('Sobre el color '+rep.a[index])
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                runVoice('Sobre el color '+rep.a[index])
                                parent.focus=true
                            }
                            onClicked: {
                                runVoice('Sobre el color '+rep.a[index])
                                parent.focus=true
                            }
                        }
                    }
                }                
            }
        }
        Component.onCompleted: ti.focus=true
    }


    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Timer{
        id: timerSpeak
        running: false
        repeat: false
        interval: 1500
        property string t: ''
        onTriggered: {
            speak(t)
        }
    }
    function runVoice(t){
        timerSpeak.t=t
        timerSpeak.restart()
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
