﻿Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим) 
	
	// регистр ДенежныеСредства Приход
	Движения.ДенежныеСредства.Записывать = Истина;
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.БанковскийСчетКасса = Касса;
	Движение.Сумма = СуммаДокумента;
	АналитикаПроводки = ПолучитьАналитикуПроводки();

	Движения.Хозрасчетный.Записывать = Истина;
	Движение = Движения.Хозрасчетный.Добавить();
	Движение.СчетДт = АналитикаПроводки.СчетДебета;
	Движение.СчетКт = АналитикаПроводки.СчетКредита;
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = АналитикаПроводки.СодержаниеОперации;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, АналитикаПроводки.СубконтоДебет);
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, АналитикаПроводки.СубконтоКредит);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровИУслуг") Тогда
		// Заполнение шапки
		ВидОперации = Перечисления.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика;
		Договор = ДанныеЗаполнения.Договор;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Плательщик = ДанныеЗаполнения.Контрагент;
		Ответственный = ДанныеЗаполнения.Ответственный;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровИУслуг") Тогда
		// Заполнение шапки
		ВидОперации = Перечисления.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя;
		Договор = ДанныеЗаполнения.Договор;
		Касса = ДанныеЗаполнения.Касса;
		Комментарий = ДанныеЗаполнения.Комментарий;
		Плательщик = ДанныеЗаполнения.Контрагент;
		Ответственный = ДанныеЗаполнения.Ответственный;
		ДокументОснование = ДанныеЗаполнения.Ссылка;
		СуммаДокумента = ДанныеЗаполнения.СуммаДокумента;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Функция ПолучитьДанныеПоОплатеПоРеализацииТоваров(ДанныеЗаполнения)

    Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);

    Запрос.Текст=
    "ВЫБРАТЬ
    |	РеализацияТоваровИУслуг.Контрагент КАК Плательщик,
    |	РеализацияТоваровИУслуг.СуммаДокумента КАК СуммаДокумента,
    |	РеализацияТоваровИУслуг.Ссылка КАК ДокументОснование,
    |	РеализацияТоваровИУслуг.Касса КАК Касса
    |ИЗ
    |	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
    |ГДЕ
    |	РеализацияТоваровИУслуг.Ссылка = &Ссылка";

    Выборка =  Запрос.Выполнить().Выбрать();
    Выборка.Следующий();
    возврат Выборка;

КонецФункции

Функция ПолучитьАналитикуПроводки()
	
	ОплатаОтПокупателя         = Перечисления.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя;
	ВозвратОтПоставщика     = Перечисления.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика;
	ВозвратОтПодотчетника     = Перечисления.ВидыОперацийПоступленияДенег.ВозвратОтПодотчетника;    
	
	СтруктураАналитики = Новый Структура;
	СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.Касса);
	СтруктураАналитики.Вставить("СубконтоДебет", Касса);
	Если ВидОперации = ОплатаОтПокупателя Тогда
        СтруктураАналитики.Вставить("СодержаниеОперации", "Оплата от покупателя наличными в кассу");
    	СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПокупателями);
	    СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
	ИначеЕсли ВидОперации = ВозвратОтПоставщика Тогда
	    СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПоставщиками);
	    СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат от поставщика наличными в кассу");
	    СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
	ИначеЕсли ВидОперации = ВозвратОтПодотчетника Тогда 
	    СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчетыСПодотчетнымиЛицами);
	    СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат подотчетных средств"); 
	    СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
	КонецЕсли;
	
	Возврат СтруктураАналитики;

КонецФункции 
