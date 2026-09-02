// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$HabitsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _nameMeta = const VerificationMeta('name');
@override
late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _categoryMeta = const VerificationMeta('category');
@override
late final GeneratedColumn<String> category = GeneratedColumn<String>('category', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('other'));
static const VerificationMeta _frequencyTypeMeta = const VerificationMeta('frequencyType');
@override
late final GeneratedColumn<String> frequencyType = GeneratedColumn<String>('frequency_type', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('daily'));
static const VerificationMeta _frequencyDaysMeta = const VerificationMeta('frequencyDays');
@override
late final GeneratedColumn<String> frequencyDays = GeneratedColumn<String>('frequency_days', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('1,2,3,4,5,6,7'));
static const VerificationMeta _targetCountMeta = const VerificationMeta('targetCount');
@override
late final GeneratedColumn<int> targetCount = GeneratedColumn<int>('target_count', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(1));
static const VerificationMeta _unitMeta = const VerificationMeta('unit');
@override
late final GeneratedColumn<String> unit = GeneratedColumn<String>('unit', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, name, category, frequencyType, frequencyDays, targetCount, unit];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'habits';
@override
VerificationContext validateIntegrity(Insertable<Habit> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('name')) {
context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));} else if (isInserting) {
context.missing(_nameMeta);
}
if (data.containsKey('category')) {
context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));}if (data.containsKey('frequency_type')) {
context.handle(_frequencyTypeMeta, frequencyType.isAcceptableOrUnknown(data['frequency_type']!, _frequencyTypeMeta));}if (data.containsKey('frequency_days')) {
context.handle(_frequencyDaysMeta, frequencyDays.isAcceptableOrUnknown(data['frequency_days']!, _frequencyDaysMeta));}if (data.containsKey('target_count')) {
context.handle(_targetCountMeta, targetCount.isAcceptableOrUnknown(data['target_count']!, _targetCountMeta));}if (data.containsKey('unit')) {
context.handle(_unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Habit map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Habit(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!, category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category'])!, frequencyType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}frequency_type'])!, frequencyDays: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}frequency_days'])!, targetCount: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}target_count'])!, unit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit']), );
}
@override
$HabitsTable createAlias(String alias) {
return $HabitsTable(attachedDatabase, alias);}}class Habit extends DataClass implements Insertable<Habit> 
{
final int id;
final String name;
final String category;
final String frequencyType;
final String frequencyDays;
final int targetCount;
final String? unit;
const Habit({required this.id, required this.name, required this.category, required this.frequencyType, required this.frequencyDays, required this.targetCount, this.unit});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['name'] = Variable<String>(name);
map['category'] = Variable<String>(category);
map['frequency_type'] = Variable<String>(frequencyType);
map['frequency_days'] = Variable<String>(frequencyDays);
map['target_count'] = Variable<int>(targetCount);
if (!nullToAbsent || unit != null){map['unit'] = Variable<String>(unit);
}return map; 
}
HabitsCompanion toCompanion(bool nullToAbsent) {
return HabitsCompanion(id: Value(id),name: Value(name),category: Value(category),frequencyType: Value(frequencyType),frequencyDays: Value(frequencyDays),targetCount: Value(targetCount),unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),);
}
factory Habit.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Habit(id: serializer.fromJson<int>(json['id']),name: serializer.fromJson<String>(json['name']),category: serializer.fromJson<String>(json['category']),frequencyType: serializer.fromJson<String>(json['frequencyType']),frequencyDays: serializer.fromJson<String>(json['frequencyDays']),targetCount: serializer.fromJson<int>(json['targetCount']),unit: serializer.fromJson<String?>(json['unit']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'name': serializer.toJson<String>(name),'category': serializer.toJson<String>(category),'frequencyType': serializer.toJson<String>(frequencyType),'frequencyDays': serializer.toJson<String>(frequencyDays),'targetCount': serializer.toJson<int>(targetCount),'unit': serializer.toJson<String?>(unit),};}Habit copyWith({int? id,String? name,String? category,String? frequencyType,String? frequencyDays,int? targetCount,Value<String?> unit = const Value.absent()}) => Habit(id: id ?? this.id,name: name ?? this.name,category: category ?? this.category,frequencyType: frequencyType ?? this.frequencyType,frequencyDays: frequencyDays ?? this.frequencyDays,targetCount: targetCount ?? this.targetCount,unit: unit.present ? unit.value : this.unit,);Habit copyWithCompanion(HabitsCompanion data) {
return Habit(
id: data.id.present ? data.id.value : this.id,name: data.name.present ? data.name.value : this.name,category: data.category.present ? data.category.value : this.category,frequencyType: data.frequencyType.present ? data.frequencyType.value : this.frequencyType,frequencyDays: data.frequencyDays.present ? data.frequencyDays.value : this.frequencyDays,targetCount: data.targetCount.present ? data.targetCount.value : this.targetCount,unit: data.unit.present ? data.unit.value : this.unit,);
}
@override
String toString() {return (StringBuffer('Habit(')..write('id: $id, ')..write('name: $name, ')..write('category: $category, ')..write('frequencyType: $frequencyType, ')..write('frequencyDays: $frequencyDays, ')..write('targetCount: $targetCount, ')..write('unit: $unit')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, name, category, frequencyType, frequencyDays, targetCount, unit);@override
bool operator ==(Object other) => identical(this, other) || (other is Habit && other.id == this.id && other.name == this.name && other.category == this.category && other.frequencyType == this.frequencyType && other.frequencyDays == this.frequencyDays && other.targetCount == this.targetCount && other.unit == this.unit);
}class HabitsCompanion extends UpdateCompanion<Habit> {
final Value<int> id;
final Value<String> name;
final Value<String> category;
final Value<String> frequencyType;
final Value<String> frequencyDays;
final Value<int> targetCount;
final Value<String?> unit;
const HabitsCompanion({this.id = const Value.absent(),this.name = const Value.absent(),this.category = const Value.absent(),this.frequencyType = const Value.absent(),this.frequencyDays = const Value.absent(),this.targetCount = const Value.absent(),this.unit = const Value.absent(),});
HabitsCompanion.insert({this.id = const Value.absent(),required String name,this.category = const Value.absent(),this.frequencyType = const Value.absent(),this.frequencyDays = const Value.absent(),this.targetCount = const Value.absent(),this.unit = const Value.absent(),}): name = Value(name);
static Insertable<Habit> custom({Expression<int>? id, 
Expression<String>? name, 
Expression<String>? category, 
Expression<String>? frequencyType, 
Expression<String>? frequencyDays, 
Expression<int>? targetCount, 
Expression<String>? unit, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (name != null)'name': name,if (category != null)'category': category,if (frequencyType != null)'frequency_type': frequencyType,if (frequencyDays != null)'frequency_days': frequencyDays,if (targetCount != null)'target_count': targetCount,if (unit != null)'unit': unit,});
}HabitsCompanion copyWith({Value<int>? id, Value<String>? name, Value<String>? category, Value<String>? frequencyType, Value<String>? frequencyDays, Value<int>? targetCount, Value<String?>? unit}) {
return HabitsCompanion(id: id ?? this.id,name: name ?? this.name,category: category ?? this.category,frequencyType: frequencyType ?? this.frequencyType,frequencyDays: frequencyDays ?? this.frequencyDays,targetCount: targetCount ?? this.targetCount,unit: unit ?? this.unit,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (name.present) {
map['name'] = Variable<String>(name.value);}
if (category.present) {
map['category'] = Variable<String>(category.value);}
if (frequencyType.present) {
map['frequency_type'] = Variable<String>(frequencyType.value);}
if (frequencyDays.present) {
map['frequency_days'] = Variable<String>(frequencyDays.value);}
if (targetCount.present) {
map['target_count'] = Variable<int>(targetCount.value);}
if (unit.present) {
map['unit'] = Variable<String>(unit.value);}
return map; 
}
@override
String toString() {return (StringBuffer('HabitsCompanion(')..write('id: $id, ')..write('name: $name, ')..write('category: $category, ')..write('frequencyType: $frequencyType, ')..write('frequencyDays: $frequencyDays, ')..write('targetCount: $targetCount, ')..write('unit: $unit')..write(')')).toString();}
}
class $HabitCompletionsTable extends HabitCompletions with TableInfo<$HabitCompletionsTable, HabitCompletion>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$HabitCompletionsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _habitIdMeta = const VerificationMeta('habitId');
@override
late final GeneratedColumn<int> habitId = GeneratedColumn<int>('habit_id', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true, defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES habits (id) ON DELETE CASCADE'));
static const VerificationMeta _dateMeta = const VerificationMeta('date');
@override
late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>('date', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: true);
static const VerificationMeta _countMeta = const VerificationMeta('count');
@override
late final GeneratedColumn<int> count = GeneratedColumn<int>('count', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
@override
List<GeneratedColumn> get $columns => [id, habitId, date, count];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'habit_completions';
@override
VerificationContext validateIntegrity(Insertable<HabitCompletion> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('habit_id')) {
context.handle(_habitIdMeta, habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));} else if (isInserting) {
context.missing(_habitIdMeta);
}
if (data.containsKey('date')) {
context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));} else if (isInserting) {
context.missing(_dateMeta);
}
if (data.containsKey('count')) {
context.handle(_countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override
List<Set<GeneratedColumn>> get uniqueKeys => [{habitId, date},
];
@override HabitCompletion map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return HabitCompletion(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, habitId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}habit_id'])!, date: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!, count: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}count'])!, );
}
@override
$HabitCompletionsTable createAlias(String alias) {
return $HabitCompletionsTable(attachedDatabase, alias);}}class HabitCompletion extends DataClass implements Insertable<HabitCompletion> 
{
final int id;
final int habitId;
final DateTime date;
final int count;
const HabitCompletion({required this.id, required this.habitId, required this.date, required this.count});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
map['habit_id'] = Variable<int>(habitId);
map['date'] = Variable<DateTime>(date);
map['count'] = Variable<int>(count);
return map; 
}
HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
return HabitCompletionsCompanion(id: Value(id),habitId: Value(habitId),date: Value(date),count: Value(count),);
}
factory HabitCompletion.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return HabitCompletion(id: serializer.fromJson<int>(json['id']),habitId: serializer.fromJson<int>(json['habitId']),date: serializer.fromJson<DateTime>(json['date']),count: serializer.fromJson<int>(json['count']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'habitId': serializer.toJson<int>(habitId),'date': serializer.toJson<DateTime>(date),'count': serializer.toJson<int>(count),};}HabitCompletion copyWith({int? id,int? habitId,DateTime? date,int? count}) => HabitCompletion(id: id ?? this.id,habitId: habitId ?? this.habitId,date: date ?? this.date,count: count ?? this.count,);HabitCompletion copyWithCompanion(HabitCompletionsCompanion data) {
return HabitCompletion(
id: data.id.present ? data.id.value : this.id,habitId: data.habitId.present ? data.habitId.value : this.habitId,date: data.date.present ? data.date.value : this.date,count: data.count.present ? data.count.value : this.count,);
}
@override
String toString() {return (StringBuffer('HabitCompletion(')..write('id: $id, ')..write('habitId: $habitId, ')..write('date: $date, ')..write('count: $count')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, habitId, date, count);@override
bool operator ==(Object other) => identical(this, other) || (other is HabitCompletion && other.id == this.id && other.habitId == this.habitId && other.date == this.date && other.count == this.count);
}class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletion> {
final Value<int> id;
final Value<int> habitId;
final Value<DateTime> date;
final Value<int> count;
const HabitCompletionsCompanion({this.id = const Value.absent(),this.habitId = const Value.absent(),this.date = const Value.absent(),this.count = const Value.absent(),});
HabitCompletionsCompanion.insert({this.id = const Value.absent(),required int habitId,required DateTime date,this.count = const Value.absent(),}): habitId = Value(habitId), date = Value(date);
static Insertable<HabitCompletion> custom({Expression<int>? id, 
Expression<int>? habitId, 
Expression<DateTime>? date, 
Expression<int>? count, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (habitId != null)'habit_id': habitId,if (date != null)'date': date,if (count != null)'count': count,});
}HabitCompletionsCompanion copyWith({Value<int>? id, Value<int>? habitId, Value<DateTime>? date, Value<int>? count}) {
return HabitCompletionsCompanion(id: id ?? this.id,habitId: habitId ?? this.habitId,date: date ?? this.date,count: count ?? this.count,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (habitId.present) {
map['habit_id'] = Variable<int>(habitId.value);}
if (date.present) {
map['date'] = Variable<DateTime>(date.value);}
if (count.present) {
map['count'] = Variable<int>(count.value);}
return map; 
}
@override
String toString() {return (StringBuffer('HabitCompletionsCompanion(')..write('id: $id, ')..write('habitId: $habitId, ')..write('date: $date, ')..write('count: $count')..write(')')).toString();}
}
class $AppSettingsTable extends AppSettings with TableInfo<$AppSettingsTable, AppSetting>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$AppSettingsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false, hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false, defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
static const VerificationMeta _firstLaunchDateMeta = const VerificationMeta('firstLaunchDate');
@override
late final GeneratedColumn<DateTime> firstLaunchDate = GeneratedColumn<DateTime>('first_launch_date', aliasedName, true, type: DriftSqlType.dateTime, requiredDuringInsert: false);
@override
List<GeneratedColumn> get $columns => [id, firstLaunchDate];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'app_settings';
@override
VerificationContext validateIntegrity(Insertable<AppSetting> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));}if (data.containsKey('first_launch_date')) {
context.handle(_firstLaunchDateMeta, firstLaunchDate.isAcceptableOrUnknown(data['first_launch_date']!, _firstLaunchDateMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override AppSetting map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return AppSetting(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!, firstLaunchDate: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}first_launch_date']), );
}
@override
$AppSettingsTable createAlias(String alias) {
return $AppSettingsTable(attachedDatabase, alias);}}class AppSetting extends DataClass implements Insertable<AppSetting> 
{
final int id;
final DateTime? firstLaunchDate;
const AppSetting({required this.id, this.firstLaunchDate});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<int>(id);
if (!nullToAbsent || firstLaunchDate != null){map['first_launch_date'] = Variable<DateTime>(firstLaunchDate);
}return map; 
}
AppSettingsCompanion toCompanion(bool nullToAbsent) {
return AppSettingsCompanion(id: Value(id),firstLaunchDate: firstLaunchDate == null && nullToAbsent ? const Value.absent() : Value(firstLaunchDate),);
}
factory AppSetting.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return AppSetting(id: serializer.fromJson<int>(json['id']),firstLaunchDate: serializer.fromJson<DateTime?>(json['firstLaunchDate']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<int>(id),'firstLaunchDate': serializer.toJson<DateTime?>(firstLaunchDate),};}AppSetting copyWith({int? id,Value<DateTime?> firstLaunchDate = const Value.absent()}) => AppSetting(id: id ?? this.id,firstLaunchDate: firstLaunchDate.present ? firstLaunchDate.value : this.firstLaunchDate,);AppSetting copyWithCompanion(AppSettingsCompanion data) {
return AppSetting(
id: data.id.present ? data.id.value : this.id,firstLaunchDate: data.firstLaunchDate.present ? data.firstLaunchDate.value : this.firstLaunchDate,);
}
@override
String toString() {return (StringBuffer('AppSetting(')..write('id: $id, ')..write('firstLaunchDate: $firstLaunchDate')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, firstLaunchDate);@override
bool operator ==(Object other) => identical(this, other) || (other is AppSetting && other.id == this.id && other.firstLaunchDate == this.firstLaunchDate);
}class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
final Value<int> id;
final Value<DateTime?> firstLaunchDate;
const AppSettingsCompanion({this.id = const Value.absent(),this.firstLaunchDate = const Value.absent(),});
AppSettingsCompanion.insert({this.id = const Value.absent(),this.firstLaunchDate = const Value.absent(),});
static Insertable<AppSetting> custom({Expression<int>? id, 
Expression<DateTime>? firstLaunchDate, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (firstLaunchDate != null)'first_launch_date': firstLaunchDate,});
}AppSettingsCompanion copyWith({Value<int>? id, Value<DateTime?>? firstLaunchDate}) {
return AppSettingsCompanion(id: id ?? this.id,firstLaunchDate: firstLaunchDate ?? this.firstLaunchDate,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<int>(id.value);}
if (firstLaunchDate.present) {
map['first_launch_date'] = Variable<DateTime>(firstLaunchDate.value);}
return map; 
}
@override
String toString() {return (StringBuffer('AppSettingsCompanion(')..write('id: $id, ')..write('firstLaunchDate: $firstLaunchDate')..write(')')).toString();}
}
abstract class _$AppDatabase extends GeneratedDatabase{
_$AppDatabase(QueryExecutor e): super(e);
$AppDatabaseManager get managers => $AppDatabaseManager(this);
late final $HabitsTable habits = $HabitsTable(this);
late final $HabitCompletionsTable habitCompletions = $HabitCompletionsTable(this);
late final $AppSettingsTable appSettings = $AppSettingsTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [habits, habitCompletions, appSettings];
@override
StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([WritePropagation(on: TableUpdateQuery.onTableName('habits' , limitUpdateKind: UpdateKind.delete), result: [TableUpdate('habit_completions', kind: UpdateKind.delete), ],), ],);
}
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({Value<int> id,required String name,Value<String> category,Value<String> frequencyType,Value<String> frequencyDays,Value<int> targetCount,Value<String?> unit,});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({Value<int> id,Value<String> name,Value<String> category,Value<String> frequencyType,Value<String> frequencyDays,Value<int> targetCount,Value<String?> unit,});
      final class $$HabitsTableReferences extends BaseReferences<
        _$AppDatabase,
        $HabitsTable,
        Habit> {
        $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);
        
                  
                  static MultiTypedResultKey<
          $HabitCompletionsTable,
          List<HabitCompletion>
        > _habitCompletionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(
          db.habitCompletions, 
          aliasName: $_aliasNameGenerator(
            db.habits.id,
            db.habitCompletions.habitId)
        );

          $$HabitCompletionsTableProcessedTableManager get habitCompletionsRefs {
        final manager = $$HabitCompletionsTableTableManager(
            $_db, $_db.habitCompletions
            ).filter(
              (f) => f.habitId.id(
              $_item.id
            )
          );

          final cache = $_typedResult.readTableOrNull(_habitCompletionsRefsTable($_db));
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));


        }
        

      }class $$HabitsTableFilterComposer extends Composer<
        _$AppDatabase,
        $HabitsTable> {
        $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get frequencyType => $composableBuilder(
      column: $table.frequencyType,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get targetCount => $composableBuilder(
      column: $table.targetCount,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit,
      builder: (column) => 
      ColumnFilters(column));
      
        Expression<bool> habitCompletionsRefs(
          Expression<bool> Function( $$HabitCompletionsTableFilterComposer f) f
        ) {
                final $$HabitCompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$HabitCompletionsTableFilterComposer(
              $db: $db,
              $table: $db.habitCompletions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return f(composer);
        }

        }
      class $$HabitsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $HabitsTable> {
        $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get frequencyType => $composableBuilder(
      column: $table.frequencyType,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get targetCount => $composableBuilder(
      column: $table.targetCount,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$HabitsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $HabitsTable> {
        $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => column);
      
GeneratedColumn<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => column);
      
GeneratedColumn<String> get frequencyType => $composableBuilder(
      column: $table.frequencyType,
      builder: (column) => column);
      
GeneratedColumn<String> get frequencyDays => $composableBuilder(
      column: $table.frequencyDays,
      builder: (column) => column);
      
GeneratedColumn<int> get targetCount => $composableBuilder(
      column: $table.targetCount,
      builder: (column) => column);
      
GeneratedColumn<String> get unit => $composableBuilder(
      column: $table.unit,
      builder: (column) => column);
      
        Expression<T> habitCompletionsRefs<T extends Object>(
          Expression<T> Function( $$HabitCompletionsTableAnnotationComposer a) f
        ) {
                final $$HabitCompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitCompletions,
      getReferencedColumn: (t) => t.habitId,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$HabitCompletionsTableAnnotationComposer(
              $db: $db,
              $table: $db.habitCompletions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return f(composer);
        }

        }
      class $$HabitsTableTableManager extends RootTableManager    <_$AppDatabase,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (Habit,$$HabitsTableReferences),
    Habit,
    PrefetchHooks Function({bool habitCompletionsRefs})
    > {
    $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$HabitsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$HabitsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$HabitsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<String> name = const Value.absent(),Value<String> category = const Value.absent(),Value<String> frequencyType = const Value.absent(),Value<String> frequencyDays = const Value.absent(),Value<int> targetCount = const Value.absent(),Value<String?> unit = const Value.absent(),})=> HabitsCompanion(id: id,name: name,category: category,frequencyType: frequencyType,frequencyDays: frequencyDays,targetCount: targetCount,unit: unit,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required String name,Value<String> category = const Value.absent(),Value<String> frequencyType = const Value.absent(),Value<String> frequencyDays = const Value.absent(),Value<int> targetCount = const Value.absent(),Value<String?> unit = const Value.absent(),})=> HabitsCompanion.insert(id: id,name: name,category: category,frequencyType: frequencyType,frequencyDays: frequencyDays,targetCount: targetCount,unit: unit,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), $$HabitsTableReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback:         ({habitCompletionsRefs = false}){
          return PrefetchHooks(
            db: db,
            explicitlyWatchedTables: [
             if (habitCompletionsRefs) db.habitCompletions
            ],
            addJoins: null,
            getPrefetchedDataCallback: (items) async {
            return [
                      if (habitCompletionsRefs) await $_getPrefetchedData(
                  currentTable: table,
                  referencedTable:
                      $$HabitsTableReferences._habitCompletionsRefsTable(db),
                  managerFromTypedResult: (p0) =>
                      $$HabitsTableReferences(db, table, p0).habitCompletionsRefs,
                  referencedItemsForCurrentItem: (item, referencedItems) =>
                      referencedItems.where((e) => e.habitId == item.id),
                  typedResults: items)
            
                ];
              },
          );
        }
,
        ));
        }
    typedef $$HabitsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (Habit,$$HabitsTableReferences),
    Habit,
    PrefetchHooks Function({bool habitCompletionsRefs})
    >;typedef $$HabitCompletionsTableCreateCompanionBuilder = HabitCompletionsCompanion Function({Value<int> id,required int habitId,required DateTime date,Value<int> count,});
typedef $$HabitCompletionsTableUpdateCompanionBuilder = HabitCompletionsCompanion Function({Value<int> id,Value<int> habitId,Value<DateTime> date,Value<int> count,});
      final class $$HabitCompletionsTableReferences extends BaseReferences<
        _$AppDatabase,
        $HabitCompletionsTable,
        HabitCompletion> {
        $$HabitCompletionsTableReferences(super.$_db, super.$_table, super.$_typedResult);
        
                          static $HabitsTable _habitIdTable(_$AppDatabase db) => 
            db.habits.createAlias($_aliasNameGenerator(
            db.habitCompletions.habitId,
            db.habits.id));
          

        $$HabitsTableProcessedTableManager? get habitId {
          if ($_item.habitId == null) return null;
          final manager = $$HabitsTableTableManager($_db, $_db.habits).filter((f) => f.id($_item.habitId!));
          final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
          if (item == null) return manager;
          return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
        }


      }class $$HabitCompletionsTableFilterComposer extends Composer<
        _$AppDatabase,
        $HabitCompletionsTable> {
        $$HabitCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get count => $composableBuilder(
      column: $table.count,
      builder: (column) => 
      ColumnFilters(column));
      
        $$HabitsTableFilterComposer get habitId {
                final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$HabitsTableFilterComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$HabitCompletionsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $HabitCompletionsTable> {
        $$HabitCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count,
      builder: (column) => 
      ColumnOrderings(column));
      
        $$HabitsTableOrderingComposer get habitId {
                final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$HabitsTableOrderingComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$HabitCompletionsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $HabitCompletionsTable> {
        $$HabitCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get date => $composableBuilder(
      column: $table.date,
      builder: (column) => column);
      
GeneratedColumn<int> get count => $composableBuilder(
      column: $table.count,
      builder: (column) => column);
      
        $$HabitsTableAnnotationComposer get habitId {
                final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder,{$addJoinBuilderToRootComposer,$removeJoinBuilderFromRootComposer }) => 
      $$HabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
        ));
          return composer;
        }
        }
      class $$HabitCompletionsTableTableManager extends RootTableManager    <_$AppDatabase,
    $HabitCompletionsTable,
    HabitCompletion,
    $$HabitCompletionsTableFilterComposer,
    $$HabitCompletionsTableOrderingComposer,
    $$HabitCompletionsTableAnnotationComposer,
    $$HabitCompletionsTableCreateCompanionBuilder,
    $$HabitCompletionsTableUpdateCompanionBuilder,
    (HabitCompletion,$$HabitCompletionsTableReferences),
    HabitCompletion,
    PrefetchHooks Function({bool habitId})
    > {
    $$HabitCompletionsTableTableManager(_$AppDatabase db, $HabitCompletionsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$HabitCompletionsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$HabitCompletionsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$HabitCompletionsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<int> habitId = const Value.absent(),Value<DateTime> date = const Value.absent(),Value<int> count = const Value.absent(),})=> HabitCompletionsCompanion(id: id,habitId: habitId,date: date,count: count,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),required int habitId,required DateTime date,Value<int> count = const Value.absent(),})=> HabitCompletionsCompanion.insert(id: id,habitId: habitId,date: date,count: count,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), $$HabitCompletionsTableReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback:         ({habitId = false}){
          return PrefetchHooks(
            db: db,
            explicitlyWatchedTables: [
             
            ],
            addJoins: <T extends TableManagerState<dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic,dynamic>>(state) {

                                  if (habitId){
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$HabitCompletionsTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$HabitCompletionsTableReferences._habitIdTable(db).id,
                  ) as T;
               }

                return state;
              }
,
            getPrefetchedDataCallback: (items) async {
            return [
            
                ];
              },
          );
        }
,
        ));
        }
    typedef $$HabitCompletionsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $HabitCompletionsTable,
    HabitCompletion,
    $$HabitCompletionsTableFilterComposer,
    $$HabitCompletionsTableOrderingComposer,
    $$HabitCompletionsTableAnnotationComposer,
    $$HabitCompletionsTableCreateCompanionBuilder,
    $$HabitCompletionsTableUpdateCompanionBuilder,
    (HabitCompletion,$$HabitCompletionsTableReferences),
    HabitCompletion,
    PrefetchHooks Function({bool habitId})
    >;typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion Function({Value<int> id,Value<DateTime?> firstLaunchDate,});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion Function({Value<int> id,Value<DateTime?> firstLaunchDate,});
class $$AppSettingsTableFilterComposer extends Composer<
        _$AppDatabase,
        $AppSettingsTable> {
        $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get firstLaunchDate => $composableBuilder(
      column: $table.firstLaunchDate,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$AppSettingsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $AppSettingsTable> {
        $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get firstLaunchDate => $composableBuilder(
      column: $table.firstLaunchDate,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$AppSettingsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $AppSettingsTable> {
        $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<int> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get firstLaunchDate => $composableBuilder(
      column: $table.firstLaunchDate,
      builder: (column) => column);
      
        }
      class $$AppSettingsTableTableManager extends RootTableManager    <_$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting,BaseReferences<_$AppDatabase,$AppSettingsTable,AppSetting>),
    AppSetting,
    PrefetchHooks Function()
    > {
    $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$AppSettingsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$AppSettingsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$AppSettingsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<int> id = const Value.absent(),Value<DateTime?> firstLaunchDate = const Value.absent(),})=> AppSettingsCompanion(id: id,firstLaunchDate: firstLaunchDate,),
        createCompanionCallback: ({Value<int> id = const Value.absent(),Value<DateTime?> firstLaunchDate = const Value.absent(),})=> AppSettingsCompanion.insert(id: id,firstLaunchDate: firstLaunchDate,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting,BaseReferences<_$AppDatabase,$AppSettingsTable,AppSetting>),
    AppSetting,
    PrefetchHooks Function()
    >;class $AppDatabaseManager {
final _$AppDatabase _db;
$AppDatabaseManager(this._db);
$$HabitsTableTableManager get habits => $$HabitsTableTableManager(_db, _db.habits);
$$HabitCompletionsTableTableManager get habitCompletions => $$HabitCompletionsTableTableManager(_db, _db.habitCompletions);
$$AppSettingsTableTableManager get appSettings => $$AppSettingsTableTableManager(_db, _db.appSettings);
}
