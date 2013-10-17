# culture="ru-RU"

ConvertFrom-StringData @'
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
'@
