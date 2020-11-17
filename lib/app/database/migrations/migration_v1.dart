import 'package:sqflite/sqflite.dart';

void createV1(Batch batch) {
  batch.execute('''
      create table todo (
        id integer primary key autoincrement,
        descricao varchar(500) not null,
        data_hora datetime,
        finalizado integer
      )
  ''');
}
