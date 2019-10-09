/*
    Este código fué creado por @nextsigner
    E-Mail: nextsigner@gmail.com

    SELECCIONAR VOCES EN WINDOWS
    Segun cómo esté configurado cada equipo

    Voz Microsoft Zira Desktop - English (United States) unik.speak("Hola soy Sabina", 0) //English
    Voz Microsoft Sabina Desktop - Spanish (Mexico) unik.speak("Hola soy Sabina", 1) //Español
    Voz Microsoft Hazel Desktop - English (Great Britain) unik.speak("Hello, i am Hazel", 2)
    Voz Microsoft Helena Desktop unik.speak("Hola soy Helena", 3) //Español
*/

import QtQuick 2.12
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import unik.UnikQProcess 1.0
ApplicationWindow{
    id:app
    visibility:"Maximized"
    color: '#333'
    Settings{
        id:appSettings
        property int voice
    }
    UnikQProcess{
        id:uqp
        onLogDataChanged: {
            let m0 = logData.split('\n')
            for(let i=0;i<m0.length;i++){
                if(m0[i].indexOf(')')===m0[i].length-2&&m0[i].indexOf('Microsoft')>=0){
                    console.log('uqp-: '+m0[i])
                    cbLm.append(cbLm.addItem(m0[i]))
                }
            }
        }
        Component.onCompleted: {
            let vbs ='Dim speech
Set speech=CreateObject("sapi.spvoice")
for i=0 to speech.GetVoices.Count-1 step 1
      WScript.Echo speech.GetVoices.Item(i).GetDescription
next'
            let vbsFileName=unik.getPath(2)+'/count.vbs'
            unik.setFile(vbsFileName, vbs)
            run('cmd /c cscript '+vbsFileName)
        }
    }
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
            ComboBox{
                id:cbVoices
                width: parent.width
                font.pixelSize: app.fs
                model: cbLm
                onCurrentTextChanged: {
                    if(cbVoices.currentText===''){
                        unik.speak("Se utilizará la voz configurada por defecto en el sistema.")
                    }else{
                        unik.speak("La voz seleccionada es "+cbVoices.currentText.replace(/\"/g, '').replace(/\r/g, '')+"",cbVoices.currentIndex)
                    }
                }
                ListModel{
                    id:cbLm
                    function addItem(k, v){
                        return{
                                key: k,
                                value: v
                        }
                    }
                }
            }
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
                    unik.speak(ti.text)
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
                    unik.speak(ti.text)
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
            if(cbVoices.currentText===''){
                unik.speak(t)
            }else{
                unik.speak(t,cbVoices.currentIndex)
            }
        }
    }
    function runVoice(t){
        timerSpeak.t=t
        timerSpeak.restart()
    }    
}
