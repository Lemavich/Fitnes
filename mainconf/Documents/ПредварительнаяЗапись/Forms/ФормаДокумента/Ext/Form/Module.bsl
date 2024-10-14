﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    ПроверкаОказанияУслуги=Документы.ПредварительнаяЗапись.ПроверитьОказаниеУслуг(Объект.Ссылка);
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.УслугаОказана = Ложь; 
	ИначеЕсли ПроверкаОказанияУслуги <> Ложь Тогда
		Объект.УслугаОказана = Истина; 
	Иначе
		Объект.УслугаОказана = Ложь; 

	КонецЕсли;
	
	//Если Объект.Ссылка.Пустая() Тогда

	//	Если Параметры.Свойство("Начало") Тогда 
	//	Объект.ДатаЗаписи = Параметры.Начало;
	//	КонецЕсли;

	//	Если Параметры.Свойство("Окончание") Тогда
	//	Объект.ДатаОкончанияЗаписи = Параметры.Окончание;
	//	КонецЕсли;

	//	Если Параметры.Свойство("Сотрудник") Тогда
	//	Объект.Сотрудник = Параметры.Сотрудник;
	//	КонецЕсли;

	//	Если ЗначениеЗаполнено(Объект.ДатаЗаписи) Тогда
	//	Объект.Дата = НачалоДня(Объект.ДатаЗаписи);
	//	КонецЕсли;    

	//КонецЕсли;

	УстановитьДоступностьЭлементовФормы()	
	


КонецПроцедуры       

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
    Если НЕ РольДоступна("Администратор") Тогда
        Элементы.УслугаОказана.ТолькоПросмотр = Истина;
    КонецЕсли;        
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    Оповестить("Записан заказ");
КонецПроцедуры
  
Процедура ПересчитатьСуммуДокумента()
   	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма")+ Объект.Абонементы.Итог("Сумма");
КонецПроцедуры    

&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Услуга) Тогда
		СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Услуга,
		ПредопределенноеЗначение("Перечисление.ВидыЦенПродаж.Розничная"));
	Иначе
		СтрокаТЧ.Цена = 0;		
	КонецЕсли;
	РаботаСТабличнымиЧастями.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
    ПересчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастями.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
    ПересчитатьСуммуДокумента();
 КонецПроцедуры

&НаКлиенте
 Процедура УслугиЦенаПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастями.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
    ПересчитатьСуммуДокумента();
 КонецПроцедуры
 
&НаКлиенте
 Процедура АбонементыАбонементПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Абонементы.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТЧ.Абонемент) Тогда
		СтрокаТЧ.Сумма = РаботаСЦенами.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Абонемент,
		ПредопределенноеЗначение("Перечисление.ВидыЦенПродаж.Розничная"));
		СтрокаТЧ.Количество = ОбщиеФункции.ПолучитьСрокДействияАбонемента(СтрокаТЧ.Абонемент);
		
	Иначе
		СтрокаТЧ.Сумма = 0;		
	КонецЕсли;
    ПересчитатьСуммуДокумента();
 КонецПроцедуры

&НаКлиенте
 Процедура УслугиПослеУдаления(Элемент)
    ПересчитатьСуммуДокумента();
 КонецПроцедуры

&НаКлиенте
 Процедура АбонементыПослеУдаления(Элемент)
    ПересчитатьСуммуДокумента();
 КонецПроцедуры
