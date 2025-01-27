﻿&НаКлиенте
Процедура ПриОткрытии(Отказ)
УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость()

СтрокаТипПолучателя = "";
Если Объект.ВидОперации =  ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаПодотчетнику")
	ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаЗаработнойПлаты") Тогда
    Элементы.Договор.Видимость = Ложь;
    Элементы.Получатель.Видимость = Истина;
    СтрокаТипПолучателя = "СправочникСсылка.Сотрудники";
ИначеЕсли Объект.ВидОперации =  ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ОплатаПоставщику")
    ИЛИ Объект.ВидОперации =  ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВозвратПокупателю") Тогда
    СтрокаТипПолучателя = "СправочникСсылка.Контрагенты";
    Элементы.Договор.Видимость = Истина;
    Элементы.Получатель.Видимость = Истина;
КонецЕсли;
Если ЗначениеЗаполнено(СтрокаТипПолучателя) Тогда
    Массив = Новый Массив();
    Массив.Добавить(Тип(СтрокаТипПолучателя));

    ОписаниеТипаПолучателя = Новый ОписаниеТипов(Массив);
    Элементы.Получатель.ОграничениеТипа = ОписаниеТипаПолучателя;
КонецЕсли;

Если Элементы.Договор.Видимость = Истина
    И ЗначениеЗаполнено(Объект.Получатель) Тогда
    Элементы.Договор.Видимость = ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Объект.Получатель);
КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)

МассивОчищаемыхРеквизитов = Новый Массив;
Если Объект.ВидОперации =  ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаПодотчетнику")
    И ЗначениеЗаполнено(Объект.Договор) Тогда
    МассивОчищаемыхРеквизитов.Добавить("Договор");

    ТекстВопроса = "При изменении реквизита ""Вид операции"" будут очищены следующие данные:
    | - Договор
    | Продолжить?";

КонецЕсли;

Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
    Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбИзмененииВидаОперации", ЭтаФорма, МассивОчищаемыхРеквизитов);
    ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,"Внимание!");
Иначе
    ВидОперации =  Объект.ВидОперации;
    УстановитьВидимость();
КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОбИзмененииВидаОперации(Результат, ДополнительныеПараметры) Экспорт
Если Результат = КодВозвратаДиалога.Да Тогда
    Для Каждого Реквизит Из ДополнительныеПараметры Цикл
        Объект[Реквизит] = Неопределено;
    КонецЦикла;
    УстановитьВидимость();
    ВидОперации =  Объект.ВидОперации;
Иначе
    Объект.ВидОперации = ВидОперации;
КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)

ЭтоПоставщик = ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Объект.Получатель);
МассивОчищаемыхРеквизитов = Новый Массив;

Если НЕ ЭтоПоставщик И ЗначениеЗаполнено(Объект.Договор) Тогда
    МассивОчищаемыхРеквизитов.Добавить("Договор");

    ТекстВопроса = "При изменении реквизита ""Получатель"" будут очищены следующие данные:
    | - Договор
    | Продолжить?";
КонецЕсли;

Если ЗначениеЗаполнено(МассивОчищаемыхРеквизитов) Тогда
    Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбИзмененииПолучатель", ЭтаФорма, МассивОчищаемыхРеквизитов);
    ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,"Внимание!");
Иначе
    Получатель =  Объект.Получатель;
    УстановитьВидимость();
КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОбИзмененииПолучатель(Результат, ДополнительныеПараметры) Экспорт

Если Результат = КодВозвратаДиалога.Да Тогда
    Для Каждого Реквизит Из ДополнительныеПараметры Цикл
        Объект[Реквизит] = Неопределено;
    КонецЦикла;
    УстановитьВидимость();
    Получатель =  Объект.Получатель;
Иначе
    Объект.Получатель = Получатель;
КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьРеквизитыФормы();     
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыФормы()

	Получатель = Объект.Получатель;
	ВидОперации = Объект.ВидОперации;

	Если Объект.Ссылка.Пустая() Тогда
	    Объект.ВидОперации = Перечисления.ВидыОперацийРасходаДенег.ВозвратДенегПокупателю;
	КонецЕсли;
КонецПроцедуры
 
&НаСервереБезКонтекста
Функция ПроверитьВидимостьДоговораВЗависимостиОтТипаКонтрагента(Получатель)
Запрос = Новый Запрос;
Запрос.УстановитьПараметр("Получатель", Получатель);
Запрос.Текст = "ВЫБРАТЬ
               |    Контрагенты.ТипКонтрагента КАК ТипКонтрагента,
               |    Контрагенты.Ссылка КАК Контрагент
               |ИЗ
               |    Справочник.Контрагенты КАК Контрагенты
               |ГДЕ
               |    Контрагенты.Ссылка = &Получатель";

Выборка = Запрос.Выполнить().Выбрать();
Выборка.Следующий();

Если ЗначениеЗаполнено(Выборка.ТипКонтрагента)
    И Выборка.ТипКонтрагента = Перечисления.ТипыКонтрагентов.Клиент Тогда
    возврат Ложь;
Иначе
    возврат Истина;
КонецЕсли;
КонецФункции