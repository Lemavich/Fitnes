﻿
&НаКлиенте
Процедура УстановитьВидимость()
	Если Объект.Бессрочный Тогда
		Элементы.ДатаОкончания.Видимость = Ложь;
	Иначе
		Элементы.ДатаОкончания.Видимость = Истина;
	КонецЕсли;	
	
КонецПроцедуры


&НаКлиенте
Процедура СформироватьНаименованиеДоговора()
	Если ЗначениеЗаполнено(Объект.Номер) И ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Объект.Наименование = СтрШаблон("№ %1 от %2",Объект.Номер,Формат(Объект.ДатаНачала,"ДФ='dd.MM.yyyy ''г.'''"));

	ИначеЕсли ЗначениеЗаполнено(Объект.Номер) Тогда
		Объект.Наименование = СтрШаблон("№ %1",Объект.Номер);
	Иначе      
		Объект.Наименование = СтрШаблон("от %1",Формат(Объект.ДатаНачала,"ДФ='dd.MM.yyyy ''г.'''"));	
	КонецЕсли;	
	
	
КонецПроцедуры

 &НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		СформироватьНаименованиеДоговора();
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	СформироватьНаименованиеДоговора();
КонецПроцедуры  


&НаКлиенте
Процедура ДатаЗаключенияПриИзменении(Элемент)
	СформироватьНаименованиеДоговора();
КонецПроцедуры


&НаКлиенте
Процедура ПризнакБессрочностиПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.Бессрочный Тогда
		Объект.ДатаОкончания = Неопределено;
	КонецЕсли;	

КонецПроцедуры

