Function Get-ADPrintQueue {
<#
.Synopsis
	���������� ���� ��� ��������� �������� AD � ������� printQueue. 
.Description
	Get-ADPrintQueue ���������� ������ printQueue ��� ��������� ����� ��� ��������� ���������
	�������� ADObject ������ printQueue.
			
	�������� `Identity` (��. about_ActiveDirectory_Identity) ��������� ������ Active Directory ������ printQueue.
	�� ������ ���������������� ������� ������ ����� ������ ��� (DN), GUID, ��� printQueue ��� (CN).
	�� ������ ������� ���� �������� ���� ��� �������� ��� �� ���������.
	
	��� ������ � �������� ���������� �������� ����������� ��������� `Filter` ��� `LDAPFilter`.
	�������� `Filter` ���������� PowerShell Expression Language ��� ������ ������ �������
	��� Active Directory (��. about_ActiveDirectory_Filter).
	���� �� ��� ������ LDAP ������, ����������� �������� `LDAPFilter`.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ����������� ���������� `Identity`.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� ���� ��� ��������� �������� ������ printQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue
.Link
	Get-ADObject
.Example
	Get-ADPrintQueue -Filter * -SearchBase "OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"
	���������� ��� ������� ������ � ���������� 'OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM'.
#>
	[CmdletBinding(
		DefaultParametersetName = 'Filter'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueue'
	)]

	param (
		# ������ � ���������� PowerShell Expression Language (��. about_ActiveDirectory_Filter)
		[Parameter(
			Mandatory = $false
			, ParameterSetName = 'Filter'
		)]
		[String]
		$Filter = '*'
	,
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 1
			, ValueFromPipeline = $true
			, ParameterSetName = 'Identity'
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		$Identity
	,
		# ������ ������� � ���������� ldap
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'LDAPFilter'
		)]
		[String]
		$LDAPFilter
	,
		# �������� ������� ������� printQueue ��� ������� �� ActiveDirectory
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
		# ���������� ��������, ���������� � ���� �������� ��� ldap ������
		[Parameter(
			Mandatory = $false
		)]
		[Int32]
		$ResultPageSize = 256
	,
		# ������������ ���������� ������������ �������� AD
		[Parameter(
			Mandatory = $false
		)]
		[Int32]
		$ResultSetSize = $null
	,
		# ���� � ���������� AD, � ������� ��������� ����������� �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$SearchBase
	,
		# ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADSearchScope]
		$SearchScope = ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::Subtree )
	,
		# ���������� ������ Active Directory
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
	���������� ���������� �� ������ AD � ������� printQueue � ���������� ���������.
.Description
	Test-ADPrintQueue ��������� ����� ��� ��������� ���������
	�������� ADObject ������ printQueue � ���������� ����������������, � ����������
	`$true` ���� ����� ������� ����, � `$false` � ��������� ������.
			
	�������� `Identity` (��. about_ActiveDirectory_Identity) ��������� ������ Active Directory ������ printQueue.
	�� ������ ���������������� ������� ������ ����� ������ ��� (DN), GUID, ��� printQueue ��� (CN).
	�� ������ ������� ���� �������� ���� ��� �������� ��� �� ���������.
	
	��� ������ � �������� ���������� �������� ����������� ��������� `Filter` ��� `LDAPFilter`.
	�������� `Filter` ���������� PowerShell Expression Language ��� ������ ������ �������
	��� Active Directory (��. about_ActiveDirectory_Filter).
	���� �� ��� ������ LDAP ������, ����������� �������� `LDAPFilter`.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ����������� ���������� `Identity`.
.Outputs
	bool
	������ - �������, ��������������� ��������� ������������, ����������;
	���� - �� ����������
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
		# ������ � ���������� PowerShell Expression Language (��. about_ActiveDirectory_Filter)
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'Filter'
		)]
		[String]
		$Filter
	,
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
		[Parameter(
			Mandatory = $true
			, Position = 1
			, ValueFromPipeline = $true
			, ParameterSetName = 'Identity'
		)]
		[Microsoft.ActiveDirectory.Management.ADObject]
		$Identity
	,
		# ������ ������� � ���������� ldap
		[Parameter(
			Mandatory = $true
			, ParameterSetName = 'LDAPFilter'
		)]
		[String]
		$LDAPFilter
	,
		# ���� � ���������� AD, � ������� ��������� ����������� �����
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$SearchBase
	,
		# ������� ������
		[Parameter(
			Mandatory = $false
		)]
		[Microsoft.ActiveDirectory.Management.ADSearchScope]
		$SearchScope = ( [Microsoft.ActiveDirectory.Management.ADSearchScope]::Subtree )
	,
		# ���������� ������ Active Directory
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
	������ �������� ��������� ��� ����������� �������� printQueue. 
.Description
	������ �������� ��������� ��� ����������� �������� printQueue.
	������ ������� ������� �������� ���������� ��� �������� �����������
	����������� � ��������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� �������� ��������� ��� ����� -PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Initialize-ADPrintQueuesEnvironment
.Link
	Get-ADObject
.Example
	Initialize-ADPrintQueuesEnvironment
	������ �������� ��������� � ����������� �� ���������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Initialize-ADPrintQueuesEnvironment'
	)]

	param (
		# �����, ��� �������� �������������� ������������ ������
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
		$Server
	,
		# ���������� �� ��������� ��������� ����� �� ���������
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
	���������� ��������� AD ��� ������� printQueue. 
.Description
	Get-ADPrintQueueContainer ���������� ������ ���������� ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
	���� ������ �� ������, ����� ���������� ��� ���������� ��������� ��� �������� ������.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� ��������� ��� ���������� ������� ������ printQueue.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueContainer
.Link
	Get-ADObject
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Get-ADPrintQueueContainer
	���������� ��������� ��� ������� ������ 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueContainer'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
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
		# �������� ������� ������� ���������� ��� ������� �� ActiveDirectory
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		$Properties
	,
		# �����, ��� �������� �������������� ������������ ������
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
	��������� ������� ���������� AD ��� ���������� ������� printQueue. 
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	bool
	������ - �������, ��������������� ��������� ������������, ����������;
	���� - �� ����������
.Link
	https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueContainer
.Link
	Get-ADPrintQueueContainer
.Link
	Get-ADObject
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | Test-ADPrintQueueContainer
	��������� ������� ���������� ��� ������� ������ 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Test-ADPrintQueueContainer'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
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
		# �����, ��� �������� �������������� ������������ ������
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
	������ ��������� AD ��� ���������� ������� printQueue. 
.Description
	New-ADPrintQueueContainer ������ ������ ���������� ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADObject
	���������� ��������� ��� ���������� ������� ������ printQueue
	��� ���������� � ������ PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueContainer
.Link
	New-ADObject
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueContainer
	������ ��������� ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueContainer -PassThru | % { do-something }
	������ ���������� ��� ���� �������� ������, ���� ��� �� ���������,
	� ��������� ��� ������� ���������� �� ���� ���� ��������.
	���� ��������� ��� ����������, �� �� ��������� � �� ������������, � ��������������
	�������� ��� ���� ��������� �� �����.
.Example
	Get-ADPrintQueue | ? { -not ( Test-ADPrintQueueContainer $_ ) } | New-ADPrintQueueContainer -Confirm
	������ ������ ������������� ���������� ��� ���� ������������������ � AD �������� ������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueContainer'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
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
		# �����, ��� �������� �������������� ������������ ������
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
		$Server
	,
		# ���������� �� ��������� ��������� ����� �� ���������
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
	������ ������ ������������ ��� ���������� ������� printQueue. 
.Description
	New-ADPrintQueueGroup ������ ������ ������������
	(������������ ��������, ��������� ��������) ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADGroup[]
	���������� ��������� ������ ������������ ��� ���������� � ������ PassThru.
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
	������ ������ ������������ ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueGroup -GroupType Users
	������ ������ ������������ "������������ ��������" ��� ���� ������������
	�������� ������.
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGroup'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
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
		# ��� ������: Users (������ �������������), Administrators (������ ���������������).
		# ������ ������������� ������� ����� ���������� ��������� �������� ��� ���� ������� ������, � ����� ������.
		# ������ ��������������� �� ������� ����� ���������� GPO, �� ������� ����� ������ � ����� ���������� ����� �����������
		# � ��������� ������� ������.
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		[ValidateSet( 'Users', 'Administrators' )]
		$GroupType = ( 'Users', 'Administrators' )
	,
		# �����, ��� �������� �������������� ������������ ������
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
		$Server
	,
		# ���������� �� ��������� ������ ����� �� ���������
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
	���������� ������������� ������ ������������ ��� ���������� ������� printQueue. 
.Description
	Get-ADPrintQueueGroup ���������� ������ ������������
	(������������ ��������, ��������� ��������) ��� ����������
	����� InputObject ������� printQueue.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.ActiveDirectory.Management.ADGroup[]
	���������� ������������� ������ ������������.
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
	���������� ������ ������������ ������������ �������� ��� ������� ������ 'prn001'.
#>
	[CmdletBinding(
		HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#Get-ADPrintQueueGroup'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
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
		# ��� ������: Users (������ �������������), Administrators (������ ���������������).
		# ������ ������������� ������� ����� ���������� ��������� �������� ��� ���� ������� ������, � ����� ������.
		# ������ ��������������� �� ������� ����� ���������� GPO, �� ������� ����� ������ � ����� ���������� ����� �����������
		# � ��������� ������� ������.
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		[ValidateSet( 'Users', 'Administrators' )]
		$GroupType = 'Users'
	,
		# �����, ��� �������� �������������� ������������ ������
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
	������ ��������� ��������, ����������� � ������������� ���������� ������� printQueue. 
.Description
	New-ADPrintQueueGPO ������ ������ ��������� �������� ��� "�����������" ������
	������ ������������ �������� ���������
	����� InputObject ������� ������.
.Notes
	���� ��������� �� �������� �� �������� Active Directory.
.Inputs
	Microsoft.ActiveDirectory.Management.ADObject
	ADObject ������ printQueue, ������������ Get-ADPrintQueue.
.Outputs
	Microsoft.GroupPolicy.Gpo
	���������� ��������� ��������� �������� ��� ���������� � ������ PassThru.
.Link
	https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGPO
.Link
	New-GPO
.Link
	Get-ADPrintQueue
.Example
	Get-ADPrintQueue -Filter {name -eq 'prn001'} | New-ADPrintQueueGPO
	������ ������ ��������� �������� ��� ������� ������ 'prn001'.
.Example
	Get-ADPrintQueue | New-ADPrintQueueGPO -Force
	������ ��������� �������� ��� ���� ������������
	�������� ������ ���� ��������� �� (���� GPO ����������).
#>
	[CmdletBinding(
		SupportsShouldProcess = $true
		, ConfirmImpact = 'Medium'
		, HelpUri = 'https://github.com/IT-Service/ITG.DomainUtils#New-ADPrintQueueGPO'
	)]

	param (
		# ������������� ������� AD (��. about_ActiveDirectory_Identity)
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
		# �����, ��� �������� �������������� ������������ ������
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
		$Server
	,
		# ��������� �� ������������ ������� GPO
		[Switch]
		$Force
	,
		# ������������� �� ������� ��� ������� �� ��������� ��� ���������� ��������� ���������
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
		# �������������� ������������ ������� � ��������� ������
		[Parameter(
			Mandatory = $false
		)]
		[String]
		$Port = ''
	,
		# ������������� �� ����������� � �������� ��� ����������. � ���� ������ ���� ��� ������������� ���������� ��������� ������� ��� ��������
		# ������� ����� �������� �������������. � ��������� ������ ������� ����� ������������ ������ ����� ���������� ��������� ������� � ������ � ������
		# ����������� ���������� ��������� �������.
		[Switch]
		$AsPersistent
	,
		# ���������� �� ��������� GPO ����� �� ���������
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
