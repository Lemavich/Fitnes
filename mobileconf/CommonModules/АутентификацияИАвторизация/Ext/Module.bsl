﻿Процедура ВыполнитьАутентификацию(Логин) Экспорт    
    Соединение    = Новый HTTPСоединение(Константы.ЛокальныйIP.Получить(),,Константы.ПользовательВОсновнойБазе.Получить());//(1)
    Запрос        = Новый HTTPЗапрос("Fitnes/hs/users/getUser?username="+Логин);//(2)
    Ответ        = Соединение.Получить(Запрос);//(3)    
    Если Ответ.КодСостояния = 200 Тогда
        МассивДанныхПользователя = ОбменСОсновнойБазой.JSONВОбъект(Ответ.ПолучитьТелоКакСтроку());
        Если МассивДанныхПользователя.Количество() = 0 Тогда //(4)
            Сообщить("По логину " + Логин +" пользователь не найден!");
        ИначеЕсли ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() = 0 Тогда //(5)
            АвторизоватьПользователя(МассивданныхПользователя[0]);
        КонецЕсли;
    Иначе
        Сообщить("При попытке аутентификации произошла ошибка!");
    КонецЕсли;    
КонецПроцедуры

Процедура АвторизоватьПользователя(ДанныеПользователя) Экспорт
    
    НовыйПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
    НовыйПользовательИБ.Имя = ДанныеПользователя.name;
    НовыйПользовательИБ.Роли.Добавить(Метаданные.Роли.АвторизованныйПользователь);
    НовыйПользовательИБ.Записать();

    ТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию(ДанныеПользователя.name);
    Если ТекущийПользователь.Пустая() Тогда
        НовыйПользователь = Справочники.Пользователи.СоздатьЭлемент();
        НовыйПользователь.Код = НовыйПользовательИБ.УникальныйИдентификатор;
        НовыйПользователь.ВнешнийGUID = ДанныеПользователя.code;  
        НовыйПользователь.Наименование = ДанныеПользователя.name;
        НовыйПользователь.Записать(); 
        ТекущийПользователь = НовыйПользователь.Ссылка; 
    КонецЕсли;
    
    ПараметрыСеанса.ТекущийПользователь = ТекущийПользователь;
        
КонецПроцедуры

&НаСервере
Процедура Разлогиниться() Экспорт
    Если ПользователиИнформационнойБазы.ПолучитьПользователей().Количество() > 0 Тогда
        ПользователиИнформационнойБазы.ТекущийПользователь().Удалить();
    	ТекущийПользователь = Справочники.Пользователи.НайтиПоНаименованию(ПараметрыСеанса.ТекущийПользователь.Наименование);
		ТекущийПользователь.ПолучитьОбъект().Удалить();
    КонецЕсли;
КонецПроцедуры   

Процедура ЗарегистрироватьПользователя(Логин, Телефон) Экспорт
	//Создаем JSON
    СтруктураРеквизитовДокумента = Новый Структура;
    СтруктураРеквизитовДокумента.Вставить("Логин", Логин);
    СтруктураРеквизитовДокумента.Вставить("Телефон", Телефон);
    
   
    СтруктураРеквизитовДокументаJSON = ОбменСОсновнойБазой.ПолучитьТекстJSON(СтруктураРеквизитовДокумента);
    
    //Отправляем в основную базу
    ДокументУспешноОтправлен = ОбменСОсновнойБазой.ОтправитьДанныеДляРегистрацииВЦентральнуюБазу(СтруктураРеквизитовДокументаJSON);
    Если ДокументУспешноОтправлен Тогда        

    
    Иначе    
        СообщениеПользователю = Новый СообщениеПользователю;
        СообщениеПользователю.Текст    = "Не удалось зарегистрироваться!";
        СообщениеПользователю.Сообщить();
    КонецЕсли;    
    
	ВыполнитьАутентификацию(Логин); 
	  

КонецПроцедуры   