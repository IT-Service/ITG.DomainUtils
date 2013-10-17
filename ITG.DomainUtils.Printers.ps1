$printQueuesContainerName = 'printQueues';

Function Get-ADPrintQueue {
<#
.Synopsis
	Возвращает один или несколько объектов AD с классом printQueue. 
.Description
	Get-ADPrintQueue возвращает объект printQueue или выполняет поиск для выявления множества
	объектов ADObject класса printQueue.
			
	Параметр `Identity` (см. about_ActiveDirectory_Identity) указывает объект Active Directory класса printQueue.
	Вы можете идентифицировать очередь печати через полное имя (DN), GUID, или printQueue имя (CN).
	Вы можете указать этот параметр явно или передать его по конвейеру.
	
	Для поиска и возврата нескольких объектов используйте параметры `Filter` или `LDAPFilter`.
	Параметр `Filter` использует PowerShell Expression Language для записи строки запроса
	для Active Directory (см. about_ActiveDirectory_Filter).
	Если Вы уже имеете LDAP запрос, используйте параметр `LDAPFilter`.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject принимаемый параметром `Identity`.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	Возвращает один или несколько объектов класса printQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue
.Link
	Get-ADObject
.Example
	Get-ADPrintQueue -Filter * -SearchBase "OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"
	Возвращает все очереди печати в контейнере 'OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM'.
#>
	[CmdletBinding(
		DefaultParametersetName = 'Filter'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue'
	)]

	param (
		# запрос в синтаксисе PowerShell Expression Language (см. about_ActiveDirectory_Filter)
		[Parameter(
			Mandatory = $false
			, ParameterSetName = 'Filter'
		)]
		[String]
		$Filter = '*'
	,
		# идентификация объекта AD (см. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 1
			, ValueFromPipeline = $true
			, ParameterSetName = 'Identity'
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		$Identity
	,
		# Строка запроса в синтаксисе ldap
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'LDAPFilter'
		)]
		[String]
		$LDAPFilter
	,
		# Перечень свойств объекта printQueue для запроса из ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties = @(
			'DistinguishedName'
			, 'Name'
			, 'printerName'
			, 'printShareName'
			, 'serverName'
			, 'ObjectClass'
			, 'ObjectGUID'
		)
	,
		# Количество объектов, включаемых в одну страницу для ldap ответа
		[Parameter(
			Mandatory = $false
		)]
		[Int32]
		$ResultPageSize = 256
	,
		# Максимальное количество возвращаемых объектов AD
		[Parameter(
			Mandatory = $false
		)]
		[Int32]
		$ResultSetSize = $null
	,
		# путь к контейнеру AD, в котором требуется осуществить поиск
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$SearchBase
	,
		# область поиска
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADSearchScope]
		$SearchScope = ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::Subtree )
	,
		# Метод аутентификации
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# Учётные данные для выполнения данной операции
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	begin {
		try {
			foreach ( $param in 'Properties' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			switch ( $PsCmdlet.ParameterSetName ) {
				'Identity' {
				}
				'Filter' {
					if ( $Filter -eq '*' ) {
						$PSBoundParameters['Filter'] = "objectClass -eq 'printQueue'";
					} else {
						$PSBoundParameters['Filter'] = "(objectClass -eq 'printQueue') -and ($Filter)";
					};
				}
				'LDAPFilter' {
					$PSBoundParameters['LDAPFilter'] = "(& (objectClass=printQueue) ($LDAPFilter))";
				}
			};
			$outBuffer = $null;
			if ( $PSBoundParameters.TryGetValue( 'OutBuffer', [ref]$outBuffer ) ) {
				$PSBoundParameters['OutBuffer'] = 1;
			};
			$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
				'Get-ADObject'
				, [System.Management.Automation.CommandTypes]::Cmdlet
			);
			$scriptCmd = { & $wrappedCmd `
				-Properties $Properties `
				@PSBoundParameters `
			};
			$steppablePipeline = $scriptCmd.GetSteppablePipeline( $myInvocation.CommandOrigin );
			$steppablePipeline.Begin( $PSCmdlet );
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
	process {
		try {
			$steppablePipeline.Process( $_ );
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
	end {
		try {
			$steppablePipeline.End();
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinter -Value Get-ADPrintQueue -Force;

Function Test-ADPrintQueue {
<#
.Synopsis
	Определяет существует ли объект AD с классом printQueue с указанными фильтрами.
.Description
	Test-ADPrintQueue выполняет поиск для выявления множества
	объектов ADObject класса printQueue с указанными характеристиками, и возвращает
	`$true` если такие объекты есть, и `$false` в противном случае.
			
	Параметр `Identity` (см. about_ActiveDirectory_Identity) указывает объект Active Directory класса printQueue.
	Вы можете идентифицировать очередь печати через полное имя (DN), GUID, или printQueue имя (CN).
	Вы можете указать этот параметр явно или передать его по конвейеру.
	
	Для поиска и возврата нескольких объектов используйте параметры `Filter` или `LDAPFilter`.
	Параметр `Filter` использует PowerShell Expression Language для записи строки запроса
	для Active Directory (см. about_ActiveDirectory_Filter).
	Если Вы уже имеете LDAP запрос, используйте параметр `LDAPFilter`.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject принимаемый параметром `Identity`.
.Outputs
	bool
	истина - объекты, соответствующие указанным ограничениям, существуют;
	ложь - не существуют
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueue
.Link
	Get-ADPrintQueue
.Example
	Test-ADPrintQueue -Filter * -SearchBase "OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"
#>
	[CmdletBinding(
		DefaultParametersetName = 'Filter'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueue'
	)]

	param (
		# запрос в синтаксисе PowerShell Expression Language (см. about_ActiveDirectory_Filter)
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'Filter'
		)]
		[String]
		$Filter
	,
		# идентификация объекта AD (см. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 1
			, ValueFromPipeline = $true
			, ParameterSetName = 'Identity'
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		$Identity
	,
		# Строка запроса в синтаксисе ldap
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'LDAPFilter'
		)]
		[String]
		$LDAPFilter
	,
		# путь к контейнеру AD, в котором требуется осуществить поиск
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$SearchBase
	,
		# область поиска
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADSearchScope]
		$SearchScope = ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::Subtree )
	,
		# Метод аутентификации
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# Учётные данные для выполнения данной операции
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		[bool] ( Get-ADPrintQueue @PSBoundParameters );
	}
}

New-Alias -Name Test-ADPrinter -Value Test-ADPrintQueue -Force;

Function Install-ADPrintQueuesEnvironment {
<#
.Synopsis
	Создаёт корневой контейнер для контейнеров объектов printQueue. 
.Description
	Создаёт корневой контейнер для контейнеров объектов printQueue.
	Данную функцию следует вызывать однократно для создания необходимых
	контейнеров и объектов.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	Возвращает корневой контейнер при ключе -PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Install-ADPrintQueuesEnvironment
.Link
	Get-ADObject
.Example
	Install-ADPrintQueuesEnvironment
	Создаёт корневой контейнер с параметрами по умолчанию.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Install-ADPrintQueuesEnvironment'
	)]

	param (
		# путь к контейнеру AD, в котором расположены все контейнеры, используемые утилитами данного модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = "$( ( Get-ADDomain ).DistinguishedName )"
	,
		# имя (displayName) контейнера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerDisplayName = ( $loc.PrintQueuesContainerName )
	,
		# класс контейнера, создаваемого для каждого принтера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# описание контейнера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Description = ( $loc.PrintQueuesContainerDescription )
	,
		# Метод аутентификации
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# Учётные данные для выполнения данной операции
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# Передавать ли созданный контейнер далее по конвейеру
		[Switch]
		$PassThru
	)

	try {
		foreach ( $param in 'DomainUtilsBase', 'ContainerClass', 'ContainerDisplayName', 'Description' ) {
			$null = $PSBoundParameters.Remove( $param );
		};
		New-ADObject `
			-Type $ContainerClass `
			-Path $DomainUtilsBase `
			-Name $printQueuesContainerName `
			-Description $Description `
			-DisplayName $ContainerDisplayName `
			-ProtectedFromAccidentalDeletion $true `
			@PSBoundParameters `
		;
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

Function Get-ADPrintQueueContainer {
<#
.Synopsis
	Возвращает контейнер AD для объекта printQueue. 
.Description
	Get-ADPrintQueueContainer возвращает объект контейнера для указанного
	через InputObject объекта printQueue.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject класса printQueue, возвращаемый Get-ADPrintQueue.
	Если объект не указан, будут возвращены все контейнеры созданные для очередей печати.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	Возвращает контейнер для указанного объекта класса printQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueContainer
.Link
	Get-ADObject
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Get-ADPrintQueueContainer
	Возвращает контейнер для очереди печати 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueContainer'
	)]

	param (
		# идентификация объекта AD (см. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $false
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# Перечень свойств объекта контейнера для запроса из ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties
	,
		# путь к контейнеру AD, в котором расположены все контейнеры, используемые утилитами данного модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ( ( Get-ADDomain ).DistinguishedName )
	,
		# класс контейнера, создаваемого для каждого принтера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# Метод аутентификации
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# Учётные данные для выполнения данной операции
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		try {
			foreach ( $param in 'PrinterName', 'InputObject', 'DomainUtilsBase', 'ContainerClass' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			$Filter = "( objectClass -eq '$ContainerClass' )";
			if ( $InputObject ) {
				$Filter += " -and ( name -eq '$( $InputObject.PrinterName )'  )";
			};
			Get-ADObject `
				-Filter $Filter `
				-SearchBase "CN=$printQueuesContainerName,$DomainUtilsBase" `
				-SearchScope ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::OneLevel ) `
				@PSBoundParameters `
			;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinterContainer -Value Get-ADPrintQueueContainer -Force;

Function Test-ADPrintQueueContainer {
<#
.Synopsis
	Проверяет наличие контейнера AD для указанного объекта printQueue. 
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject класса printQueue, возвращаемый Get-ADPrintQueue.
.Outputs
	bool
	истина - объекты, соответствующие указанным ограничениям, существуют;
	ложь - не существуют
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueContainer
.Link
	Get-ADPrintQueueContainer
.Link
	Get-ADObject
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Test-ADPrintQueueContainer
	Проверяем наличие контейнера для очереди печати 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueContainer'
	)]

	param (
		# идентификация объекта AD (см. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $false
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# путь к контейнеру AD, в котором расположены все контейнеры, используемые утилитами данного модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ( ( Get-ADDomain ).DistinguishedName )
	,
		# класс контейнера, создаваемого для каждого принтера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# Метод аутентификации
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# Учётные данные для выполнения данной операции
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	)

	process {
		[bool] ( Get-ADPrintQueueContainer @PSBoundParameters );
	}
}

New-Alias -Name Test-ADPrinterContainer -Value Test-ADPrintQueueContainer -Force;

Function New-ADPrintQueueContainer {
<#
.Synopsis
	Создаёт контейнер AD для указанного объекта printQueue. 
.Description
	New-ADPrintQueueContainer создаёт объект контейнера для указанного
	через InputObject объекта printQueue.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject класса printQueue, возвращаемый Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	Возвращает контейнер для указанного объекта класса printQueue
	при выполнении с ключом PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueContainer
.Link
	New-ADObject
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueContainer
	Создаёт контейнер для очереди печати 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueContainer -PassThru | % { do-something }
	Создаёт контейнеры для всех очередей печати, если они не сущетвуют,
	и выполняет для каждого созданного то либо иное действие.
	Если контейнер уже существует, он не удаляется и не пересоздаётся, и дополнительных
	действий для него выполнено не будет.
.Example
	Get-ADPrintQueue | ? { -not ( Test-ADPrintQueueContainer $_ ) } | New-ADPrintQueueContainer -Confirm
	Создаём только отсутствующие контейнеры для всех зарегистрированных в AD очередей печати.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueContainer'
	)]

	param (
		# идентификация объекта AD (см. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 0
			, ValueFromPipeline = $true
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		[ValidateScript( {
			( $_.objectClass -eq 'printQueue' ) `
			-and ( $_.printerName ) `
		} )]
		$InputObject
	,
		# путь к контейнеру AD, в котором расположены все контейнеры, используемые утилитами данного модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ( ( Get-ADDomain ).DistinguishedName )
	,
		# класс контейнера, создаваемого для каждого принтера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# описание контейнера
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Description = ( $loc.PrintQueueContainerDescription )
	,
		# Метод аутентификации
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADAuthType]
		$AuthType = ( [Microsoft.ActiveDirectory.Management.ADAuthType]::Negotiate )
	,
		# Учётные данные для выполнения данной операции
		[Parameter(
			Mandatory = $false
		)]
		[System.Management.Automation.PSCredential]
		$Credential
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# Передавать ли созданный контейнер далее по конвейеру
		[Switch]
		$PassThru
	)

	process {
		try {
			foreach ( $param in 'InputObject', 'DomainUtilsBase', 'ContainerClass', 'Description' ) {
				$null = $PSBoundParameters.Remove( $param );
			};
			New-ADObject `
				-Type $ContainerClass `
				-Path "CN=$printQueuesContainerName,$DomainUtilsBase" `
				-Name $InputObject.PrinterName `
				-Description ( [String]::Format(
					$Description
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.PrintShareName
				) ) `
				@PSBoundParameters `
			;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterContainer -Value New-ADPrintQueueContainer -Force;
