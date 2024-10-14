﻿&НаКлиенте
Процедура ПослеОтветаНаВопросОбОчисткеТЧ(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.Начисления.Очистить();
	    ЗаполнитьГрафикНаСервере();
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьГрафикНаСервере()
		
	//Исхожу из того, что в 1 месяце не может быть больше 1 изменения оклада работника

	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	              |	КадроваяИсторияСотрудниковСрезПоследних.Период КАК Период,
	              |	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	              |	КадроваяИсторияСотрудниковСрезПоследних.ГрафикРаботы КАК ГрафикРаботы,
	              |	КадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад,
	              |	КадроваяИсторияСотрудниковСрезПоследних.Работает КАК Работает
	              |ПОМЕСТИТЬ ВТ_Начало
	              |ИЗ
	              |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаНачала, ) КАК КадроваяИсторияСотрудниковСрезПоследних
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	КадроваяИсторияСотрудниковСрезПоследних.Период КАК Период,
	              |	КадроваяИсторияСотрудниковСрезПоследних.Сотрудник КАК Сотрудник,
	              |	КадроваяИсторияСотрудниковСрезПоследних.ГрафикРаботы КАК ГрафикРаботы,
	              |	КадроваяИсторияСотрудниковСрезПоследних.Оклад КАК Оклад,
	              |	КадроваяИсторияСотрудниковСрезПоследних.Работает КАК Работает
	              |ПОМЕСТИТЬ ВТ_Конец
	              |ИЗ
	              |	РегистрСведений.КадроваяИсторияСотрудников.СрезПоследних(&ДатаОкончания, ) КАК КадроваяИсторияСотрудниковСрезПоследних
	              |;
	              |
	              |////////////////////////////////////////////////////////////////////////////////
	              |ВЫБРАТЬ
	              |	ВТ_Начало.Период КАК Период,
	              |	ВТ_Начало.Сотрудник КАК Сотрудник,
	              |	ВТ_Начало.ГрафикРаботы КАК ГрафикРаботы,
	              |	ВТ_Начало.Оклад КАК Оклад,
	              |	ВТ_Начало.Работает КАК Работает,
	              |	ВТ_Конец.Период КАК Период1,
	              |	ВТ_Конец.Сотрудник КАК Сотрудник1,
	              |	ВТ_Конец.ГрафикРаботы КАК ГрафикРаботы1,
	              |	ВТ_Конец.Оклад КАК Оклад1,
	              |	ВТ_Конец.Работает КАК Работает1
	              |ИЗ
	              |	ВТ_Конец КАК ВТ_Конец
	              |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Начало КАК ВТ_Начало
	              |		ПО ВТ_Конец.Сотрудник = ВТ_Начало.Сотрудник";
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Объект.ПериодНачисления));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Объект.ПериодНачисления));

	ВыборкаДетальные = Запрос.Выполнить().Выбрать();
	Пока ВыборкаДетальные.Следующий() Цикл  
		Если ВыборкаДетальные.Период = ВыборкаДетальные.Период1 Тогда
			СтрокаТЧ = Объект.Начисления.Добавить();
			СтрокаТЧ.Сотрудник = ВыборкаДетальные.Сотрудник;
			СтрокаТЧ.ГрафикРаботы = ВыборкаДетальные.ГрафикРаботы;
			СтрокаТЧ.ВидРасчета = ПредопределенноеЗначение("ПланВидовРасчета.Начисления.Оклад");
			СтрокаТЧ.ПоказательРасчета = ВыборкаДетальные.Оклад;
           	СтрокаТЧ.ДатаНачала = НачалоМесяца(Объект.ПериодНачисления);
			СтрокаТЧ.ДатаОкончания = КонецМесяца(Объект.ПериодНачисления);
		Иначе
			Если ЗначениеЗаполнено(ВыборкаДетальные.Сотрудник) Тогда
				СтрокаТЧ = Объект.Начисления.Добавить();
				СтрокаТЧ.Сотрудник = ВыборкаДетальные.Сотрудник;
				СтрокаТЧ.ГрафикРаботы = ВыборкаДетальные.ГрафикРаботы;
				СтрокаТЧ.ВидРасчета = ПредопределенноеЗначение("ПланВидовРасчета.Начисления.Оклад");
				СтрокаТЧ.ПоказательРасчета = ВыборкаДетальные.Оклад;
				СтрокаТЧ.ДатаНачала = НачалоМесяца(Объект.ПериодНачисления);
				СтрокаТЧ.ДатаОкончания = ВыборкаДетальные.Период1 - 86400;
			КонецЕсли;
			
			СтрокаТЧ = Объект.Начисления.Добавить();
			СтрокаТЧ.Сотрудник = ВыборкаДетальные.Сотрудник1;
			СтрокаТЧ.ГрафикРаботы = ВыборкаДетальные.ГрафикРаботы1;
			СтрокаТЧ.ВидРасчета = ПредопределенноеЗначение("ПланВидовРасчета.Начисления.Оклад");
			СтрокаТЧ.ПоказательРасчета = ВыборкаДетальные.Оклад1;
			СтрокаТЧ.ДатаНачала = ВыборкаДетальные.Период1;
			СтрокаТЧ.ДатаОкончания = КонецМесяца(Объект.ПериодНачисления);		
			
		КонецЕсли; 
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГрафик(Команда)
    ТекстВопроса = "Будет очищена табличная часть документа. Вы согласны продолжить?";
    Оповещение = Новый ОписаниеОповещения("ПослеОтветаНаВопросОбОчисткеТЧ", ЭтаФорма);
    ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,"Внимание!");


КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры
