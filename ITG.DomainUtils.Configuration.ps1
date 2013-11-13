$ConfigCache = @{};

$ConfigContainerName = 'ITG DomainUtils';
$ConfigContainerParentDN = 'CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration';
$ConfigContainerDN = ( ( "CN=$ConfigContainerName", $ConfigContainerParentDN | ? { $_ } ) -join ',' );

Function Initialize-DomainUtilsConfiguration {
<#
.Synopsis
	������������� ������������ ������. 
.Description
	�������������� ������������ ������. ������������ ������ ����������� � Active Directory, ������ ����
	��� ������ csm.nov.ru �����
	`CN=ITG DomainUtils,CN=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=csm,DC=nov,DC=ru`.
	
	������������ ����������� � AD (� ����������� �� AD) �� ���� ������. � ���������, ������ ������������
	����������� � ������������ ��������� ������ �����������. �� � ������� ������ ��� ���������� �����
	���������������� ������ ������ �������������� ���� � �� �� ������������ ������, � ��������� - ����
	�����������, �������� ��������� ��� ���������� ����������� ��������������� �����, � ��� �����.

	� ������ ������� ������������ � AD � ����� ������������� ������������, ��������� ���� `-Force`,
	������ ���� ��� �� ������� � ������������ ��������� ����� �����������, �� ��������������,
	���������� ��������� �����. ������� ������������ ���� ������������ ������� � ������ �������������.
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
		# �����, ��� �������� �������������� ������������ ������. ���� �� ������ - ����� ������������, �� ����� �������� ������� ��������.
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Domain = ( ( Get-ADDomain ).DNSRoot )
	,
		# ���� (DN) � ���������� AD, � ������� ����������� ��� ����������, ������������ ��������� ������� ������.
		# ����������� ��� DN ������.
		# ��������, ��� `CN=ITG,DC=csm,DC=nov,DC=ru` ������� ������� `CN=ITG`.
		#
		# �� ��������� � �������� ��������� ���������� ������������ �������� ��������� ������.
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$DomainUtilsBase
	,
		# ����� �����������, ������������ ������ �������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		[ValidateSet(
			'container'
			, 'organizationalUnit'
		)]
		$ContainerClass = 'container'
	,
		# ���������� ������ Active Directory. ���� �� ������ ���� - ������������ �������� ���� PDC � ��������� ������.
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
		if ( -not  $Server ) {
			$Server = ( Get-ADDomainController -Discover -DomainName $Domain -Writable ).HostName;
		};
		$ADDomain = Get-ADDomain `
			-Identity $Domain `
			-Server $Server `
		;
		if ( 
			(
				Test-DomainUtilsConfiguration `
					-Domain $Domain `
					-Server $Server `
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
			Write-Verbose `
				-Message ( [String]::Format( $loc.ConfigInitialization, $ADDomain.DNSRoot ) ) `
			;
			if ( 
				Test-DomainUtilsConfiguration `
					-Domain $Domain `
					-Server $Server `
			) {
				$ConfigADObject = Get-ADObject `
					-Identity ( ( $ConfigContainerDN, $ADDomain.DistinguishedName | ? { $_ } ) -join ',' ) `
					-Server $Server `
					-Properties 'msDS-ObjectReference', 'msDS-Settings' `
				;
			};
			if ( -not $ConfigADObject ) {
				$ConfigADObject = New-ADObject `
					-Type 'msDS-App-Configuration' `
					-Path ( ( $ConfigContainerParentDN, $ADDomain.DistinguishedName | ? { $_ } ) -join ',' ) `
					-Name $ConfigContainerName `
					-ProtectedFromAccidentalDeletion $false `
					-PassThru `
					-Verbose:$VerbosePreference `
					-Server $Server `
				;
			};
			if ( $ConfigADObject ) {
				$ConfigADObject.'msDS-ObjectReference' = `
					( ( $DomainUtilsBase, $ADDomain.DistinguishedName | ? { $_ } ) -join ',' ) `
				;
				$ConfigADObject.'msDS-Settings' = `
					"ContainerClass=$ContainerClass" `
					, "PrintQueuesContainerName=$( $loc.PrintQueuesContainerName )" `
					, "PrintQueueContainerName=$( $loc.PrintQueueContainerName )" `
					, "PrintQueueUsersGroup=$( $loc.PrintQueueUsersGroup )" `
					, "PrintQueueUsersGroupAccountName=$( $loc.PrintQueueUsersGroupAccountName )" `
					, "PrintQueueAdministratorsGroup=$( $loc.PrintQueueAdministratorsGroup )" `
					, "PrintQueueAdministratorsGroupAccountName=$( $loc.PrintQueueAdministratorsGroupAccountName )" `
					, "PrintQueueGPOName=$( $loc.PrintQueueGPOName )" `
				;
				Set-ADObject `
					-Instance $ConfigADObject `
					-Verbose:$VerbosePreference `
					-Server $Server `
				;
				$null = Get-DomainUtilsConfiguration `
					-Domain $Domain `
					-Server $Server `
				;
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
		if ( $ConfigCache.ContainsKey( $ADDomain.DNSRoot ) ) { return $true; };
		return ( Test-Path -Path "AD:$( ( $ConfigContainerDN, $ADDomain.DistinguishedName | ? { $_ } ) -join ',' )" );
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
		if ( -not  $Server ) {
			$Server = ( Get-ADDomainController -Discover -DomainName $Domain -Writable ).HostName;
		};
		$ADDomain = Get-ADDomain `
			-Identity $Domain `
			-Server $Server `
		;
		if ( $ConfigCache.ContainsKey( $ADDomain.DNSRoot ) ) {
			return $ConfigCache.Item( $ADDomain.DNSRoot );
		} else {
			if ( 
				-not (
					Test-DomainUtilsConfiguration `
						-Domain $Domain `
						-Server $Server `
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
				$ConfigADObject = Get-ADObject `
					-Identity ( ( $ConfigContainerDN, $ADDomain.DistinguishedName | ? { $_ } ) -join ',' ) `
					-Server $Server `
					-Properties 'msDS-ObjectReference', 'msDS-Settings' `
				;
				$ConfigCache.Item( $ADDomain.DNSRoot ) = @{
					DomainUtilsBase = $ConfigADObject.'msDS-ObjectReference'[0];
				};
				$ConfigADObject.'msDS-Settings' `
				| % {
					if ( $_ -match '^(?<Param>\w+)=(?<Value>.*)$' ) {
						$ConfigCache.Item( $ADDomain.DNSRoot ).( $Matches[ 'Param' ] ) = $Matches[ 'Value' ];
					};
				};
		  		if ( $ConfigCache.Item( $ADDomain.DNSRoot ).ContainerClass -eq 'organizationalUnit' ) {
					$ConfigCache.Item( $ADDomain.DNSRoot ).ContainerPathTemplate = 'OU={0}';
				} else {
					$ConfigCache.Item( $ADDomain.DNSRoot ).ContainerPathTemplate = 'CN={0}';
				};
				$ConfigCache.Item( $ADDomain.DNSRoot ).PrintQueuesContainer = "$(
						[String]::Format(
							$ConfigCache.Item( $ADDomain.DNSRoot ).ContainerPathTemplate
							, $ConfigCache.Item( $ADDomain.DNSRoot ).PrintQueuesContainerName
						)
					),$( $ConfigCache.Item( $ADDomain.DNSRoot ).DomainUtilsBase )"
				;
				return $ConfigCache.Item( $ADDomain.DNSRoot );
			};
		};
	} catch {
		Write-Error `
			-ErrorRecord $_ `
		;
	};
}

New-Alias -Name Get-Config -Value Get-DomainUtilsConfiguration -Force;
