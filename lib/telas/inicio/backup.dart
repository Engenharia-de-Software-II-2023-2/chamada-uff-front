// ListTile(
// title: Text('Dia da Chamada', style: TextStyle(fontSize: 20)),
// ),
// ListView.separated(
// shrinkWrap: true,
// itemCount: weekDays.length,
// separatorBuilder: (context, index) {
// return Divider(height: 1, color: Colors.grey);
// },
// itemBuilder: (context, index) {
// final weekDay = weekDays[index];
// return GestureDetector(
// onTap: () {
// setState(() {
// selectedWeekDay = weekDay;
// });
// },
// child: ClipRRect(
// borderRadius: BorderRadius.all(Radius.circular(8.0)),
// child: Container(
// decoration: BoxDecoration(
// color: Colors.white,
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.5),
// spreadRadius: 2,
// blurRadius: 3,
// offset: Offset(0, 2),
// ),
// ],
// ),
// padding: EdgeInsets.all(16.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(weekDay),
// if (selectedWeekDay == weekDay)
// Icon(Icons.check_circle, color: Colors.green),
// ],
// ),
// ),
// ),
// );
// },
// ),
// ListTile(
// title: Padding(
// padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Adicione o padding apenas na parte inferior
// child: Text('Horário da Chamada', style: TextStyle(fontSize: 20)),
// ),
// ),
// ListTile(
// title: Container(
// padding: EdgeInsets.all(1.0),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.all(Radius.circular(8.0)),
// boxShadow: [
// BoxShadow(
// color: Colors.grey.withOpacity(0.5),
// spreadRadius: 2,
// blurRadius: 3,
// offset: Offset(0, 2),
// ),
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 8.0),
// child: GestureDetector(
// onTap: () async {
// TimeOfDay? selectedTime = await showTimePicker(
// context: context,
// initialTime: TimeOfDay.now(),
// );

// if (selectedTime != null) {
// String formattedTime = selectedTime.format(context);
// setState(() {
// attendance.start = formattedTime;
// });
// }
// },
// child: Row(
// children: [
// Icon(Icons.access_time), // Ícone de relógio
// SizedBox(width: 8.0),
// Text(
// attendance.start,
// style: TextStyle(fontSize: 16),
// ),
// ],
// ),
// ),
// ),
// ),
// ),


// import 'package:flutter/material.dart';

// class AttendanceListScreen extends StatefulWidget {
// @override
// _AttendanceListScreenState createState() => _AttendanceListScreenState();
// }

// class _AttendanceListScreenState extends State<AttendanceListScreen> {
// List<String> attendanceList = []; // Lista de chamadas

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// title: Text('Lista de Chamadas'),
// ),
// body: ListView.builder(
// itemCount: attendanceList.length,
// itemBuilder: (context, index) {
// final attendance = attendanceList[index];

// return ListTile(
// title: Text(attendance),
// trailing: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// IconButton(
// icon: Icon(Icons.edit),
// onPressed: () {
// // Implemente a lógica de edição aqui
// },
// ),
// IconButton(
// icon: Icon(Icons.delete),
// onPressed: () {
// // Implemente a lógica de exclusão aqui
// setState(() {
// attendanceList.removeAt(index);
// });
// },
// ),
// ],
// ),
// );
// },
// ),
// floatingActionButton: FloatingActionButton(
// onPressed: () async {
// // Exibe um diálogo para adicionar uma nova chamada
// final newAttendance = await showDialog<String>(
// context: context,
// builder: (context) {
// return AlertDialog(
// title: Text('Adicionar Chamada'),
// content: TextField(
// decoration: InputDecoration(labelText: 'Nome da Chamada'),
// textCapitalization: TextCapitalization.words,
// onChanged: (value) {
// // Implemente a lógica para atualizar o nome da chamada
// },
// ),
// actions: [
// TextButton(
// child: Text('Cancelar'),
// onPressed: () {
// Navigator.of(context).pop(); // Fecha o diálogo
// },
// ),
// TextButton(
// child: Text('Salvar'),
// onPressed: () {
// // Implemente a lógica para salvar a chamada
// Navigator.of(context).pop(); // Fecha o diálogo
// },
// ),
// ],
// );
// },
// );

// if (newAttendance != null && newAttendance.isNotEmpty) {
// setState(() {
// attendanceList.add(newAttendance);
// });
// }
// },
// child: Icon(Icons.add),
// ),
// );
// }
// }

// void main() {
// runApp(MaterialApp(
// home: AttendanceListScreen(),
// ));
// }
