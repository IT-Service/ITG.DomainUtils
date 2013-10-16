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
		# Перечень свойств объекта printQueue для запроса из ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties
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
			}
			$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
				'Get-ADObject'
				, [System.Management.Automation.CommandTypes]::Cmdlet
			);
			$scriptCmd = { & $wrappedCmd @PSBoundParameters };
			$steppablePipeline = $scriptCmd.GetSteppablePipeline( $myInvocation.CommandOrigin );
			$steppablePipeline.Begin( $PSCmdlet );
		} catch {
			throw;
		};
	}
	process {
		try {
			$steppablePipeline.Process( $_ );
		} catch {
			throw;
		};
	}
	end {
		try {
			$steppablePipeline.End();
		} catch {
			throw;
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
	bool
	- истина - объекты, соответствующие указанным ограничениям, существуют
	- ложь - не существуют
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
		# Перечень свойств объекта printQueue для запроса из ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties
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

	process {
		try {
			$outBuffer = $null;
			if ( $PSBoundParameters.TryGetValue( 'OutBuffer', [ref]$outBuffer ) ) {
				$PSBoundParameters['OutBuffer'] = 1;
			}
			$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
				'Get-ADPrintQueue'
				, [System.Management.Automation.CommandTypes]::Function
			);
			[bool] ( & $wrappedCmd @PSBoundParameters );
		} catch {
			throw;
		};
	}
}

New-Alias -Name Test-ADPrinter -Value Test-ADPrintQueue -Force;
