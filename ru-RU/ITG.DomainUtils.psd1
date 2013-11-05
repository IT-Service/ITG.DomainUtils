# culture="ru-RU"

ConvertFrom-StringData @'
ConfigExistsMessage = Конфигурация модуля ITG.DomainUtils уже определена для домена {0}.
ConfigInitialization = Инициализация конфигурации модуля ITG.DomainUtils.
ConfigExistsRA = Для переопределения конфигурации используйте ключ -Force.
ConfigRetriving = Чтение конфигурации модуля ITG.DomainUtils
ConfigDoesntExistsMessage = Конфигурация модуля ITG.DomainUtils для домена {0} отсутствует.
ConfigDoesntExistsRA = Перед использованием командлет модуля ITG.DomainUtils для домена {0} инициализируйте конфигурацию модуля следующим образом: \r\n\tInitialize-DomainUtilsConfiguration -Domain {0} \r\n\r\n

PrintQueuesContainerName = printQueues
PrintQueuesContainerDescription = Данный контейнер создан и используется сценариями ITG.DomainUtils \r\n(см. https://github.com/IT-Service/ITG.DomainUtils). \r\nСодержит контейнеры для групп безопасности для каждой опубликованной в AD очереди печати.
PrintQueueContainerName = {0}
PrintQueueContainerDescription = Очередь печати {0}, сервер {1}. Группы безопасности для указанной очереди печати. \r\nСоздан и используется сценариями ITG.DomainUtils \r\n(см. https://github.com/IT-Service/ITG.DomainUtils).
PrintQueueUsersGroup = Пользователи
PrintQueueUsersGroupAccountName = prnUsers {0}
PrintQueueUsersGroupDescription = Группа, получающая право печати на очереди печати {0}.
PrintQueueUsersGroupInfo = Членам группы так же будет применена групповая политика публикации этой очереди печати. \r\n\r\nСоздана и используется сценариями ITG.DomainUtils \r\n(см. https://github.com/IT-Service/ITG.DomainUtils).
PrintQueueAdministratorsGroup = Операторы
PrintQueueAdministratorsGroupAccountName = prnAdmins {0}
PrintQueueAdministratorsGroupDescription = Группа, получающая права печати на очереди печати {0} и управления всеми документами в этой очереди.
PrintQueueAdministratorsGroupInfo = Групповая политика не будет применена, и очередь печати не будет автоматически подключена членам этой группы. \r\n\r\nСоздана и используется сценариями ITG.DomainUtils \r\n(см. https://github.com/IT-Service/ITG.DomainUtils).
PrintQueueGPOName = itg-Принтер {0}
PrintQueueGPOComment = Данный объект групповой политики предназначен для подключения очереди печати {0} с сервера {1} членам группы Пользователи данной очереди печати. \r\n\r\nСоздан и используется сценариями ITG.DomainUtils \r\n(см. https://github.com/IT-Service/ITG.DomainUtils).
PrintQueueGPPComment = Подключения очереди печати {0} с сервера {1}.
PrintQueueGPPStatus = Принтер {0} на сервере {1}.
'@
