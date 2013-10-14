ITG.DomainUtils
===============

Данный модуль предоставляет набор командлет для автоматизации ряда операций в домене Windows.

Тестирование модуля и подготовка к публикации
---------------------------------------------

Для сборки модуля использую проект [psake](https://github.com/psake/psake). Для инициирования сборки используйте сценарий `build.ps1`.
Для модульных тестов использую проект [pester](https://github.com/pester/pester).


Версия модуля: **0.1.0**

ПОДДЕРЖИВАЮТСЯ КОМАНДЛЕТЫ
-------------------------

### ADPrintQueue

#### КРАТКОЕ ОПИСАНИЕ [Get-ADPrintQueue][]

Возвращает один или несколько объектов AD с классом printQueue.

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] -Filter <String> [-Properties <String[]>] <CommonParameters>

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] [-Identity] <ADObject> [-Properties <String[]>] <CommonParameters>

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] -LDAPFilter <String> [-Properties <String[]>] <CommonParameters>

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] [-Properties <String[]>] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase <String>] [-SearchScope] [-Server <String>] <CommonParameters>

ОПИСАНИЕ
--------

#### Get-ADPrintQueue

[Get-ADPrintQueue][] возвращает объект printQueue или выполняет поиск для выявления множества
объектов ADObject класса printQueue.

Параметр `Identity` указывает объект Active Directory класса printQueue.
Вы можете идентифицировать очередь печати через полное имя (DN), GUID, или printQueue имя (CN).
Вы можете указать этот параметр явно или передать его по конвейеру.

Для поиска и возврата нескольких объектов используйте параметры `Filter` или `LDAPFilter`.
Параметр `Filter` использует PowerShell Expression Language для записи строки запроса
для Active Directory (см. about_ActiveDirectory_Filter).
Если Вы уже имеете LDAP запрос, используйте параметр `LDAPFilter`.

##### ПСЕВДОНИМЫ

Get-ADPrinter

##### СИНТАКСИС

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] -Filter <String> [-Properties <String[]>] <CommonParameters>

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] [-Identity] <ADObject> [-Properties <String[]>] <CommonParameters>

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] -LDAPFilter <String> [-Properties <String[]>] <CommonParameters>

	Get-ADPrintQueue [-AuthType] [-Credential <PSCredential>] [-Properties <String[]>] [-ResultPageSize <Int32>] [-ResultSetSize <Int32>] [-SearchBase <String>] [-SearchScope] [-Server <String>] <CommonParameters>

##### ВХОДНЫЕ ДАННЫЕ

- Microsoft.ActiveDirectory.Management.ADObject
ADObject принимаемый параметром `Identity`.

##### ВЫХОДНЫЕ ДАННЫЕ

- Microsoft.ActiveDirectory.Management.ADObject
Возвращает один или несколько объектов класса printQueue.

##### ПАРАМЕТРЫ

- `[ADAuthType] AuthType`
	Метод аутентификации
	* Тип: Microsoft.ActiveDirectory.Management.ADAuthType
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `Negotiate`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[PSCredential] Credential`
	Учётные данные для выполнения данной операции
	* Тип: [System.Management.Automation.PSCredential][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[String] Filter`
	запрос в синтаксисе PowerShell Expression Language (см. about_ActiveDirectory_Filter)
	* Тип: [System.String][]
	* Требуется? да
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[ADObject] Identity`
	идентификация объекта AD
	* Тип: Microsoft.ActiveDirectory.Management.ADObject
	* Требуется? да
	* Позиция? 2
	* Принимать входные данные конвейера? true (ByValue)
	* Принимать подстановочные знаки? нет

- `[String] LDAPFilter`
	Строка запроса в синтаксисе ldap
	* Тип: [System.String][]
	* Требуется? да
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[String[]] Properties`
	Перечень свойств объекта printQueue для запроса из ActiveDirectory
	* Тип: [System.String][][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[Int32] ResultPageSize`
	Количество объектов, включаемых в одну страницу для ldap ответа
	* Тип: [System.Int32][]
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `256`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[Int32] ResultSetSize`
	Максимальное количество возвращаемых объектов AD
	* Тип: [System.Int32][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[String] SearchBase`
	путь к контейнеру AD, в котором требуется осуществить поиск
	* Тип: [System.String][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[ADSearchScope] SearchScope`
	область поиска
	* Тип: Microsoft.ActiveDirectory.Management.ADSearchScope
	* Требуется? нет
	* Позиция? named
	* Значение по умолчанию `Subtree`
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `[String] Server`
	Контроллер домена Active Directory
	* Тип: [System.String][]
	* Требуется? нет
	* Позиция? named
	* Принимать входные данные конвейера? false
	* Принимать подстановочные знаки? нет

- `<CommonParameters>`
	Этот командлет поддерживает общие параметры: Verbose, Debug,
	ErrorAction, ErrorVariable, WarningAction, WarningVariable,
	OutBuffer и OutVariable. Для получения дополнительных сведений см. раздел
	[about_CommonParameters][].


##### ПРИМЕРЫ

1. Возвращает все очереди печати в контейнере 'OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM'.

		Get-ADPrintQueue -Filter * -SearchBase "OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"

##### ПРИМЕЧАНИЯ

Этот командлет не работает со снимками Active Directory.

##### ССЫЛКИ ПО ТЕМЕ

- [Интернет версия](https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue)
- Get-ADObject
- Remove-ADPrintQueue
- Set-ADPrintQueue


[about_CommonParameters]: http://go.microsoft.com/fwlink/?LinkID=113216 "Describes the parameters that can be used with any cmdlet."
[Get-ADPrintQueue]: <#get-adprintqueue> "Возвращает один или несколько объектов AD с классом printQueue."
[System.Int32]: <http://msdn.microsoft.com/ru-ru/library/system.int32.aspx> "Int32 Class (System)"
[System.Management.Automation.PSCredential]: <http://msdn.microsoft.com/ru-ru/library/system.management.automation.pscredential.aspx> "PSCredential Class (System.Management.Automation)"
[System.String]: <http://msdn.microsoft.com/ru-ru/library/system.string.aspx> "String Class (System)"

---------------------------------------

Генератор: [ITG.Readme](https://github.com/IT-Service/ITG.Readme "Модуль PowerShell для генерации readme для модулей PowerShell").

