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
                    speak()
                }
            }
            Button{
                text: 'Hablar'
                onClicked: {
                        speak()
                }
            }
        }
    }


    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    function speak(){
        var d=new Date(Date.now())
        var f=unik.getPath(2)+'/voice-'+d.getTime()+'.vbs'
        var s='Dim speaks, speech\n'
        s+='speaks="'+ti.text+'"\n'
        s+='Set speech=CreateObject("sapi.spvoice")\n'
        s+='speech.Speak speaks\n'
        unik.setFile(f,s)
        unik.ejecutarLineaDeComandoAparte('cmd /c '+f)
    }
}
