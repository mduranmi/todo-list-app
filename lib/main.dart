import 'dart:ffi';
import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

//////////////////////////////////////////////////////////////////// Objeto Item
class ItemCheckbox {
    bool itempressed = false;
    String texto;
    String cantidad;
    VoidCallback? onChanged;

    ItemCheckbox(this.itempressed, this.texto, this.cantidad, {this.onChanged});
}
////////////////////////////////////////////////////////////////////  Cambiar el estado de los items
class _State extends State<MyApp> {
  List <ItemCheckbox> listaObjeto= [];

  void onItemCheckboxChanged(ItemCheckbox item, bool value) {
    setState(() {
      item.itempressed = value;
      if (item.onChanged != null) {
        item.onChanged!();
      }
    });
  }

///////////////////////////////////////////////////////////////// Controladores de texto
final _controlTexto = TextEditingController();
final _controlTextoCantidad = TextEditingController();
//////////////////////////////////////////////////////////////////// Cuadro de dialogo para crear nuevo elemento
  void crearNuevoElementoLista(){
    showDialog(context: this.context, builder: (context){
      return AlertDialog(
        content: Container(
            height: 205,
            child: Column(
                children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.0),
                      ///Texto del cuadro de diálogo - Nombre
                      child: TextField(
                        maxLength: 22,
                        controller: _controlTexto,
                        decoration: InputDecoration(
                          hintText: "Agrega un nuevo item",
                          icon : Icon(Icons.add_business_outlined),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        ///Texto del cuadro de diálogo - Cantidad
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _controlTextoCantidad,
                          decoration: InputDecoration(
                            hintText: "Agrega una cantidad",
                            icon: Icon(Icons.add_circle),
                          ),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                            children: [
                              ///Boton de salvar
                              Expanded(
                                  child: Padding (
                                    padding: EdgeInsets.symmetric(horizontal:2.0),
                                    child: crearBoton("Salvar"),
                                  ),
                              ),
                              ///Boton de cancelar
                              Expanded(
                                  child: Padding (
                                    padding: EdgeInsets.symmetric(horizontal:2.0),
                                    child: crearBoton("Cancelar"),

                                  )
                              ),
                            ]
                        )
                    )
                  ],
                )
        )
      );
    },
    );
  }
//////////////////////////////////////////////////////////////////// Salvar Tarea
  void salvarTarea(){
    setState(() {
      ItemCheckbox nuevoItem = ItemCheckbox(
          false,
          _controlTexto.text,
          _controlTextoCantidad.text
      );
      listaObjeto.add(nuevoItem);
    });
  }
//////////////////////////////////////////////////////////////////// Función para crear el botón del cuadro de texto para agregar items.
  MaterialButton crearBoton (String texto){
    VoidCallback onPressed;
    onPressed = (){
      if(texto == "Salvar"){
        setState(() {
          salvarTarea();
          Navigator.of(context).pop();
        });
      }else {
        Navigator.of(context).pop();
      }
    };
    _controlTexto.clear();
    _controlTextoCantidad.clear();

    return MaterialButton(
      color: Colors.blueGrey,
      onPressed: onPressed,
      child: Text(texto),
    );
  }
////////////////////////////////////////////////////////////////////  items pintados en el scaffold.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        //centerTitle: (true),
        title: const Text('Your Daily List'),
      ),
////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        onPressed: crearNuevoElementoLista,
        child: Icon(Icons.add),
      ),
////////////////////////////////////////////////////////////////////  Checkbox generator
        body: ListView.builder(
        itemCount: listaObjeto.length,
        itemBuilder: (BuildContext Context, int index){
          return Dismissible(
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete,
                  color: Colors.white,
                ),
              ),
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  // Remove the item from the data source
                  listaObjeto.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Item dismissed")),
                );
              },
              child: CheckboxListTile(
              shape: RoundedRectangleBorder(),
              title: Text(listaObjeto[index].texto),
              subtitle: Text(listaObjeto[index].cantidad),
              value: listaObjeto[index].itempressed,
              activeColor: Colors.pinkAccent,
              secondary: Icon(
                Icons.add_business_rounded,
              ),
            onChanged: (value) => onItemCheckboxChanged(listaObjeto[index], value!),
            )
          );
        }
      )
    );
  }
}