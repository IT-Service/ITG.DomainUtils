$ConfigCache = @{};

Function Initialize-DomainUtilsConfiguration {
<#
.Synopsis
	������������� ������������ ������. 
.Description
	������������� ������������ ������. 
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Initialize-DomainUtilsConfiguration
.Example
	Initialize-DomainUtilsConfiguration
	�������������� ������������ ������ ��� ������ ������������, �� ����� �������� �������� ���������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'High'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Initialize-DomainUtilsConfiguration'
	)]

	param (
		# �����, ��� �������� �������������� ������������ ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���� � ���������� AD, � ������� ����������� ��� ����������, ������������ ��������� ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase = ""
	,
		# ����� �����������, ������������� ������ �������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$ContainerClass = 'container'
	,
		# ���������� ������ Active Directory
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Server = ''
	,
		# �������������� �� ������������ � ������ � �������
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
	��������� ������� ������������ ������ ��� ���������� ������. 
.Description
	��������� ������� ������������ ������ ��� ���������� ������. 
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-DomainUtilsConfiguration
.Example
	Test-DomainUtilsConfiguration -Domain 'csm.nov.ru'
	��������� ������������� ������������ ��� ������ csm.nov.ru.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-DomainUtilsConfiguration'
	)]

	param (
		# �����, ��� �������� ��������� ������� ������������ ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
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
	�������� ������, ���������� ������������ ������ ��� ���������� ������. 
.Description
	�������� ������, ���������� ������������ ������ ��� ���������� ������. 
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-DomainUtilsConfiguration
.Example
	( Get-DomainUtilsConfiguration -Domain 'csm.nov.ru' ).ContainerClass
	���������� ����� �����������, ������������ ������� ��� ������ csm.nov.ru.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-DomainUtilsConfiguration'
	)]

	param (
		# �����, ��� �������� ����������� ������������ ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���������� ������ Active Directory
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
