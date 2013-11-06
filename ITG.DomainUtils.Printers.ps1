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
			, 'uNCName'
			, 'driverName'
			, 'driverVersion'
			, 'location'
			, 'portName'
			, 'printAttributes'
			, 'printBinNames'
			, 'printCollate'
			, 'printColor'
			, 'printDuplexSupported'
			, 'printFormName'
			, 'printKeepPrintedJobs'
			, 'printLanguage'
			, 'printMACAddress'
			, 'printNetworkAddress'
			, 'printMaxCopies'
			, 'printMaxResolutionSupported'
			, 'printMaxXExtent'
			, 'printMaxYExtent'
			, 'printMinXExtent'
			, 'printMinYExtent'
			, 'printMediaReady'
			, 'printMediaSupported'
			, 'printOrientationsSupported'
			, 'printPagesPerMinute'
			, 'printSpooling'
			, 'printStaplingSupported'
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

Function Initialize-ADPrintQueuesEnvironment {
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
	https://github.com/IT-Service/ITG.DomainUtils#Initialize-ADPrintQueuesEnvironment
.Link
	Get-ADObject
.Example
	Initialize-ADPrintQueuesEnvironment
	Создаёт корневой контейнер с параметрами по умолчанию.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Initialize-ADPrintQueuesEnvironment'
	)]

	param (
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
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
		$Params = @{};
		foreach ( $param in 'Server') {
			if ( $PSBoundParameters.ContainsKey( $param ) ) {
				$Params.Add( $param,  $PSBoundParameters.$param );
			};
		};
		$Config = Get-DomainUtilsConfiguration `
			-Domain $Domain `
			@Params `
		;
		New-ADObject `
			-Type ( $Config.ContainerClass ) `
			-Path ( Split-Path -Path $Config.DomainUtilsBase -NoQualifier ) `
			-Name ( $Config.PrintQueuesContainerName ) `
			-Description ( $loc.PrintQueuesContainerDescription ) `
			-ProtectedFromAccidentalDeletion $true `
			-PassThru:$PassThru `
			-Verbose:$VerbosePreference `
			@Params `
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
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
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
			$Params = @{};
			foreach ( $param in 'Server') {
				if ( $PSBoundParameters.ContainsKey( $param ) ) {
					$Params.Add( $param,  $PSBoundParameters.$param );
				};
			};
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				@Params `
			;
			$Filter = "( objectClass -eq '$( $Config.ContainerClass )' )";
			if ( $InputObject ) {
				$Filter += " -and ( name -eq '$( [String]::Format( $Config.PrintQueueContainerName, $InputObject.PrinterName ) )'  )";
			};
			Get-ADObject `
				-Filter $Filter `
				-SearchBase ( Split-Path `
					-Path ( `
						$Config.DomainUtilsBase `
						| Join-Path -ChildPath ( [String]::Format( $Config.ContainerPathTemplate, $Config.PrintQueuesContainerName ) ) `
					) `
					-NoQualifier `
				) `
				-SearchScope ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::OneLevel ) `
				@Params `
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
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
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
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
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
			$Params = @{};
			foreach ( $param in 'Server') {
				if ( $PSBoundParameters.ContainsKey( $param ) ) {
					$Params.Add( $param,  $PSBoundParameters.$param );
				};
			};
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				@Params `
			;
			New-ADObject `
				-Type ( $Config.ContainerClass ) `
				-Path ( Split-Path `
					-Path ( `
						$Config.DomainUtilsBase `
						| Join-Path -ChildPath ( [String]::Format( $Config.ContainerPathTemplate, $Config.PrintQueuesContainerName ) ) `
					) `
					-NoQualifier `
				) `
				-Name ( [String]::Format( $Config.PrintQueueContainerName, $InputObject.PrinterName ) ) `
				-Description ( [String]::Format(
					$Description
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.Name
					, $InputObject.PrintShareName
				) ) `
				@Params `
				-Verbose:$VerbosePreference `
				-PassThru:$PassThru `
			;
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterContainer -Value New-ADPrintQueueContainer -Force;

Function New-ADPrintQueueGroup {
<#
.Synopsis
	Создаёт группы безопасности для указанного объекта printQueue. 
.Description
	New-ADPrintQueueGroup создаёт группы безопасности
	(Пользователи принтера, Операторы принтера) для указанного
	через InputObject объекта printQueue.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject класса printQueue, возвращаемый Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADGroup[]
	Возвращает созданные группы безопасности при выполнении с ключом PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGroup
.Link
	New-ADObject
.Link
	New-ADGroup
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueGroup
	Создаёт группы безопасности для очереди печати 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueGroup -GroupType Users
	Создаёт группы безопасности "Пользователи принтера" для всех обнаруженных
	очередей печати.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGroup'
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
		# тип группы: Users (группа пользователей), Administrators (группа администраторов).
		# Группа пользователей получит право применения групповой политики для этой очереди печати, и право печати.
		# Группа администраторов не получит право применения GPO, но получит право печати и право управления всеми документами
		# в указанной очереди печати.
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		[ValidateSet( 'Users', 'Administrators' )]
		$GroupType = ( 'Users', 'Administrators' )
	,
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# Передавать ли созданные группы далее по конвейеру
		[Switch]
		$PassThru
	)

	process {
		try {
			$Params = @{};
			foreach ( $param in 'Server') {
				if ( $PSBoundParameters.ContainsKey( $param ) ) {
					$Params.Add( $param,  $PSBoundParameters.$param );
				};
			};
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				@Params `
			;
			foreach ( $SingleGroupType in $GroupType ) {
				try {
					New-ADGroup `
						-Path ( Split-Path `
							-Path ( `
								$Config.DomainUtilsBase `
								| Join-Path -ChildPath ( [String]::Format( $Config.ContainerPathTemplate, $Config.PrintQueuesContainerName ) ) `
								| Join-Path -ChildPath (
									[String]::Format( 
										$Config.ContainerPathTemplate, 
										( [String]::Format( $Config.PrintQueueContainerName, $InputObject.PrinterName ) )
									)
								) `
							) `
							-NoQualifier `
						) `
						-Name ( [String]::Format( $Config."printQueue$( $SingleGroupType )Group", $InputObject.PrinterName ) ) `
						-SamAccountName ( [String]::Format(
							$Config."printQueue$( $SingleGroupType )GroupAccountName"
							, $InputObject.PrinterName
							, $InputObject.ServerName
							, $InputObject.Name
						) ) `
						-GroupCategory Security `
						-GroupScope DomainLocal `
						-Description ( [String]::Format(
							$loc."printQueue$( $SingleGroupType )GroupDescription"
							, $InputObject.PrinterName
							, $InputObject.ServerName
							, $InputObject.Name
							, $InputObject.PrintShareName
						) ) `
						-OtherAttributes @{
							info = ( [String]::Format(
								$loc."printQueue$( $SingleGroupType )GroupInfo"
								, $InputObject.PrinterName
								, $InputObject.ServerName
								, $InputObject.Name
								, $InputObject.PrintShareName
							) );
						} `
						@Params `
						-Verbose:$VerbosePreference `
						-PassThru:$PassThru `
					;
				} catch {
					Write-Error `
						-ErrorRecord $_ `
					;
				};
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterGroup -Value New-ADPrintQueueGroup -Force;

Function Get-ADPrintQueueGroup {
<#
.Synopsis
	Возвращает затребованные группы безопасности для указанного объекта printQueue. 
.Description
	Get-ADPrintQueueGroup возвращает группы безопасности
	(Пользователи принтера, Операторы принтера) для указанного
	через InputObject объекта printQueue.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject класса printQueue, возвращаемый Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADGroup[]
	Возвращает затребованные группы безопасности.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGroup
.Link
	Get-ADObject
.Link
	Get-ADGroup
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Get-ADPrintQueueGroup -GroupType Users
	Возвращает группу безопасности Пользователи принтера для очереди печати 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGroup'
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
		# тип группы: Users (группа пользователей), Administrators (группа администраторов).
		# Группа пользователей получит право применения групповой политики для этой очереди печати, и право печати.
		# Группа администраторов не получит право применения GPO, но получит право печати и право управления всеми документами
		# в указанной очереди печати.
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		[ValidateSet( 'Users', 'Administrators' )]
		$GroupType = 'Users'
	,
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
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
			$Params = @{};
			foreach ( $param in 'Server') {
				if ( $PSBoundParameters.ContainsKey( $param ) ) {
					$Params.Add( $param,  $PSBoundParameters.$param );
				};
			};
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				@Params `
			;
			foreach ( $SingleGroupType in $GroupType ) {
				try {
					Get-ADGroup `
						-SearchBase ( Split-Path `
							-Path ( `
								$Config.DomainUtilsBase `
								| Join-Path -ChildPath ( [String]::Format( $Config.ContainerPathTemplate, $Config.PrintQueuesContainerName ) ) `
								| Join-Path -ChildPath (
									[String]::Format( 
										$Config.ContainerPathTemplate, 
										( [String]::Format( $Config.PrintQueueContainerName, $InputObject.PrinterName ) )
									)
								) `
							) `
							-NoQualifier `
						) `
						-Filter "( name -eq '$( [String]::Format( $Config."printQueue$( $SingleGroupType )Group", $InputObject.PrinterName ) )' )" `
						-SearchScope OneLevel `
						@Params `
					;
				} catch {
					Write-Error `
						-ErrorRecord $_ `
					;
				};
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name Get-ADPrinterGroup -Value Get-ADPrintQueueGroup -Force;

Function New-ADPrintQueueGPO {
<#
.Synopsis
	Создаёт групповую политику, применяемую к пользователям указанного объекта printQueue. 
.Description
	New-ADPrintQueueGPO создаёт объект групповой политики для "подключения" членам
	группы Пользователи принтера указанной
	через InputObject очереди печати.
.Notes
	Этот командлет не работает со снимками Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject класса printQueue, возвращаемый Get-ADPrintQueue.
.Outputs
	Microsoft.GroupPolicy.Gpo
	Возвращает созданную групповую политику при выполнении с ключом PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGPO
.Link
	New-GPO
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueGPO
	Создаёт объект групповой политики для очереди печати 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueGPO -Force
	Создаёт групповые политики для всех обнаруженных
	очередей печати либо обновляет их (если GPO существуют).
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGPO'
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
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server
	,
		# Обновлять ли существующие объекты GPO
		[Switch]
		$Force
	,
		# Устанавливать ли принтер как принтер по умолчанию при отсутствии локальных принтеров
		[Parameter(
			Mandatory = $false
		)]
		[String]
		[ValidateSet(
			'DefaultPrinterWhenNoLocalPrintersPresent'
			, 'DefaultPrinter'
			, 'DontChangeDefaultPrinter'
		)]
		[Alias( 'Default' )]
		$DefaultPrinterSelectionMode = 'DefaultPrinterWhenNoLocalPrintersPresent'
	,
		# Ассоцирировать подключенный принтер с указанным портом
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Port = ''
	,
		# Устанавливать ли подключение к принтеру как постоянное. В этом случае даже при невозможности применения групповых политик при загрузке
		# принтер будет доступен пользователям. В противном случае принтер будет подключаться только после применения групповых политик и только в случае
		# возможности применения групповых политик.
		[Switch]
		$AsPersistent
	,
		# Передавать ли созданные GPO далее по конвейеру
		[Switch]
		$PassThru
	)

	process {
		try {
			if ( -not  $Server ) {
				$Server = ( Get-ADDomainController ).HostName;
			};
			$ADDomain = Get-ADDomain `
				-Identity $Domain `
				-Server $Server `
			;
			$Config = Get-DomainUtilsConfiguration `
				-Domain $Domain `
				-Server $Server `
			;
			switch ( $DefaultPrinterSelectionMode ) {
				'DefaultPrinterWhenNoLocalPrintersPresent' {
					$AsDefault = $true;
					$AsDefaultAlways = $false;
				}
				'DefaultPrinter' {
					$AsDefault = $true;
					$AsDefaultAlways = $true;
				}
				'DontChangeDefaultPrinter' {
					$AsDefault = $false;
					$AsDefaultAlways = $false;
				}
			};
			[Microsoft.GroupPolicy.Gpo] $GPO = New-GPO `
				-Domain $Domain `
				-Name ( [String]::Format(
					$Config.printQueueGPOName
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.Name
				) ) `
				-Comment ( [String]::Format(
					$loc.printQueueGPOComment
					, $InputObject.PrinterName
					, $InputObject.ServerName
					, $InputObject.Name
					, $InputObject.PrintShareName
				) ) `
				-Server $Server `
				-Verbose:$VerbosePreference `
			;
			$PrintQueueUsersGroup =	Get-ADPrintQueueGroup `
				-InputObject $InputObject `
				-GroupType Users `
				-Server $Server `
			;
			if ( $GPO ) { 
				try { 
					$GPO `
					| Set-GPPermission `
						-PermissionLevel GpoApply `
						-Replace `
						-TargetType Group `
						-TargetName ( $PrintQueueUsersGroup.SamAccountName ) `
						-Server $Server `
					| Set-GPPermission `
						-PermissionLevel GpoRead `
						-TargetType Group `
						-TargetName ( $PrintQueueUsersGroup.SamAccountName ) `
						-Server $Server `
					| Set-GPPermission `
						-PermissionLevel GpoRead `
						-Replace `
						-TargetType Group `
						-TargetName ( ( [System.Security.Principal.SecurityIdentifier] 'S-1-5-11' ).Translate( [System.Security.Principal.NTAccount] ).Value ) `
						-Server $Server `
					| Out-Null `
					;
					$GPOFilePartPath = (
						Get-ADObject `
							-Identity ( Split-Path `
								-Path ( 
									"AD:$( $ADDomain.DistinguishedName )" `
									| Join-Path -ChildPath 'CN=System' `
									| Join-Path -ChildPath 'CN=Policies' `
									| Join-Path -ChildPath ( "CN=$( $GPO.Id.ToString( 'B' ).ToUpperInvariant() )" ) `
								) `
								-NoQualifier `
							) `
							-Properties `
								gPCFileSysPath `
							-ErrorAction Stop `
							-Server $Server `
					).gPCFileSysPath;
					$GPO.Computer.Enabled = $false;
					$GPO.User.Enabled = $true;
					$FilePartDir = "$GPOFilePartPath\User\Preferences\Printers";
					$FilePartPath = "$FilePartDir\Printers.xml";
					$null = [System.IO.Directory]::CreateDirectory( $FilePartDir );

					[xml] $PrintersDoc = @"
<?xml version="1.0" encoding="utf-8"?>
<Printers clsid="{1F577D12-3D1B-471E-A1B7-060317597B9C}">
	<SharedPrinter
		clsid="{9A5E9697-9095-436D-A0EE-4D128FDFBCE5}"
		name="$( $InputObject.PrinterName )"
		status="$( [String]::Format(
			$loc.PrintQueueGPPStatus
			, $InputObject.PrinterName
			, $InputObject.ServerName
			, $InputObject.Name
			, $InputObject.PrintShareName
		) )"
		desc="$( [String]::Format(
			$loc.printQueueGPPComment
			, $InputObject.PrinterName
			, $InputObject.ServerName
			, $InputObject.Name
			, $InputObject.PrintShareName
		) )"
		image="1"
		changed="$( Get-Date -Format ( ( Get-Culture ).DateTimeFormat.UniversalSortableDateTimePattern ) )"
		uid="{FB9C0A41-67DC-4ED4-B305-A9B8CEB0EA73}"
		removePolicy="1"
		userContext="1"
		bypassErrors="1"
	>
		<Properties
			action="R"
			comment="$( [String]::Format(
				$loc.printQueueGPPComment
				, $InputObject.PrinterName
				, $InputObject.ServerName
				, $InputObject.Name
				, $InputObject.PrintShareName
			) )"
			deleteMaps="0"
			path="$( $InputObject.uNCName )"
			location="$( $InputObject.location )"
			default="$( [int] $AsDefault )"
			skipLocal="$( [int] ( -not $AsDefaultAlways ) )"
			persistent="$( [int] [bool] $AsPersistent )"
			deleteAll="0"
			port="$( $Port )"
		/>
	</SharedPrinter>
</Printers>
"@
					$Writer = [System.Xml.XmlWriter]::Create(
						$FilePartPath `
						, ( New-Object `
							-TypeName System.Xml.XmlWriterSettings `
							-Property @{
								Indent = $true;
								OmitXmlDeclaration = $false;
								NamespaceHandling = [System.Xml.NamespaceHandling]::OmitDuplicates;
								NewLineOnAttributes = $true;
								CloseOutput = $true;
								IndentChars = "`t";
							} `
						) `
					);
					$PrintersDoc.WriteTo( $Writer );
					$Writer.Close();

					if ( $Config.ContainerClass -eq 'organizationalUnit' ) {
						$null = New-GPLink `
							-Guid ( $GPO.Id ) `
							-Domain $Domain `
							-Target ( (
								Get-ADPrintQueueContainer `
									-InputObject $InputObject `
									-Domain $Domain `
									-Server $Server `
							).DistinguishedName ) `
							-Server $Server `
							-Verbose:$VerbosePreference `
						;
					};
				} catch {
					Remove-GPO `
						-Guid ( $GPO.Id ) `
						-Server $Server `
						-ErrorAction Continue `
					;
					throw;
				};

				if ( $PassThru ) { return $GPO; };
			};
		} catch {
			Write-Error `
				-ErrorRecord $_ `
			;
		};
	}
}

New-Alias -Name New-ADPrinterGPO -Value New-ADPrintQueueGPO -Force;
