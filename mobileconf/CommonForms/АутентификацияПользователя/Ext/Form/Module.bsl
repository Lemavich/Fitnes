﻿
&НаКлиенте
Процедура Войти(Команда)
    Если ЭтаФорма.Логин = "" Тогда
        Сообщить("Введите логин пользователя!");
        Возврат;
    КонецЕсли;
    АутентификацияИАвторизация.ВыполнитьАутентификацию(ЭтаФорма.Логин);
    ЗавершитьРаботуСистемы(Ложь, Истина);

КонецПроцедуры
