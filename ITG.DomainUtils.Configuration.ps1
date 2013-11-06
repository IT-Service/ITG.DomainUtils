$ConfigCache = @{};

Function Initialize-DomainUtilsConfiguration {
<#
.Synopsis
	Инициализация конфигурации модуля. 
.Description
	Инициализация конфигурации модуля. 
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Initialize-DomainUtilsConfiguration
.Example
	Initialize-DomainUtilsConfiguration
	Инициализируем конфигурацию модуля для домена пользователя, от имени которого выполнен командлет.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'High'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Initialize-DomainUtilsConfiguration'
	)]

	param (
		# домен, для которого инициализируем конфигурацию модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# путь к контейнеру AD, в котором расположены все контейнеры, используемые утилитами данного модуля
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ""
	,
		# класс контейнеров, используемого данным модулем
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# Контроллер домена Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server = ''
	,
		# Перезаписывать ли конфигурацию в случае её наличия
		[Switch]
		$Force
	)

	try {
		$Params = @{};
		foreach ( $param in 'Server') {
			if ( $PSBoundParameters.ContainsKey( $param ) ) {
				$Params.Add( $param,  $PSBoundParameters.$param );
			};
		};
		$ADDomain = Get-ADDomain `
			-Identity $Domain `
			@Params `
		;
		if ( 
			(
				Test-DomainUtilsConfiguration `
					-Domain $Domain `
					@Params `
			) `
			-and -not $Force 
		) {
			Write-Error `
				-Message ( [String]::Format( $loc.ConfigExistsMessage, $ADDomain.DNSRoot ) ) `
				-Category ResourceExists `
				-CategoryActivity ( [String]::Format( $loc.ConfigInitialization, $ADDomain.DNSRoot ) ) `
				-CategoryReason ( [String]::Format( $loc.ConfigExistsMessage, $ADDomain.DNSRoot ) ) `
				-RecommendedAction ( [String]::Format( $loc.ConfigExistsRA, $ADDomain.DNSRoot ) ) `
			;
		} else {
			if ( $PSCmdlet.ShouldProcess( $ADDomain.DNSRoot ) ) {
				Write-Verbose `
					-Message ( [String]::Format( $loc.ConfigInitialization, $ADDomain.DNSRoot ) ) `
				;
				$ConfigCache.Item( $ADDomain.DNSRoot ) = @{
					DomainUtilsBase = Join-Path -Path "AD:$( $ADDomain.DistinguishedName )" -ChildPath $DomainUtilsBase;
					ContainerClass = $ContainerClass;
                    ContainerPathTemplate = & { 
          				if ( $ContainerClass -eq 'organizationalUnit' ) {
                            'OU={0}';
                        } else {
                            'CN={0}';
                        };
                    };
					PrintQueuesContainerName = $loc.PrintQueuesContainerName;
					PrintQueueContainerName = $loc.PrintQueueContainerName;
					PrintQueueUsersGroup = $loc.PrintQueueUsersGroup;
					PrintQueueUsersGroupAccountName = $loc.PrintQueueUsersGroupAccountName;
					PrintQueueAdministratorsGroup = $loc.PrintQueueAdministratorsGroup;
					PrintQueueAdministratorsGroupAccountName = $loc.PrintQueueAdministratorsGroupAccountName;
					PrintQueueGPOName = $loc.PrintQueueGPOName;
				};
			};
		};
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

Function Test-DomainUtilsConfiguration {
<#
.Synopsis
	Проверяем наличие конфигурации модуля для указанного домена. 
.Description
	Проверяем наличие конфигурации модуля для указанного домена. 
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-DomainUtilsConfiguration
.Example
	Test-DomainUtilsConfiguration -Domain 'csm.nov.ru'
	Проверяем существование конфигурации для домена csm.nov.ru.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-DomainUtilsConfiguration'
	)]

	param (
		# домен, для которого проверяем наличие конфигурации модуля
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
		$Server = ''
	)

	try {
		$Params = @{};
		foreach ( $param in 'Server') {
			if ( $PSBoundParameters.ContainsKey( $param ) ) {
				$Params.Add( $param,  $PSBoundParameters.$param );
			};
		};
		$ADDomain = Get-ADDomain `
			-Identity $Domain `
			@Params `
		;
		return $ConfigCache.ContainsKey( $ADDomain.DNSRoot );
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

New-Alias -Name Test-Config -Value Test-DomainUtilsConfiguration -Force;

Function Get-DomainUtilsConfiguration {
<#
.Synopsis
	Получаем объект, содержащий конфигурацию модуля для указанного домена. 
.Description
	Получаем объект, содержащий конфигурацию модуля для указанного домена. 
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-DomainUtilsConfiguration
.Example
	( Get-DomainUtilsConfiguration -Domain 'csm.nov.ru' ).ContainerClass
	Определяем класс контейнеров, используемых модулем для домена csm.nov.ru.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-DomainUtilsConfiguration'
	)]

	param (
		# домен, для которого запрашиваем конфигурацию модуля
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
		$Server = ''
	)

	try {
		$Params = @{};
		foreach ( $param in 'Server') {
			if ( $PSBoundParameters.ContainsKey( $param ) ) {
				$Params.Add( $param,  $PSBoundParameters.$param );
			};
		};
		$ADDomain = Get-ADDomain `
			-Identity $Domain `
			@Params `
		;
		if ( 
			-not (
				Test-DomainUtilsConfiguration `
					-Domain $Domain `
					@Params `
			) `
		) {
			Write-Error `
				-Message ( [String]::Format( $loc.ConfigDoesntExistsMessage, $ADDomain.DNSRoot ) ) `
				-Category NotInstalled `
				-CategoryActivity ( [String]::Format( $loc.ConfigRetriving, $ADDomain.DNSRoot ) ) `
				-CategoryReason ( [String]::Format( $loc.ConfigDoesntExistsMessage, $ADDomain.DNSRoot ) ) `
				-RecommendedAction ( [String]::Format( $loc.ConfigDoesntExistsRA, $ADDomain.DNSRoot ) ) `
			;
		} else {
			return $ConfigCache.Item( $ADDomain.DNSRoot );
		};
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

New-Alias -Name Get-Config -Value Get-DomainUtilsConfiguration -Force;
