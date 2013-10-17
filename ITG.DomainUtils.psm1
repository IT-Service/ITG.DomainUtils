$CurrentDir = `
	Split-Path `
		-Path $MyInvocation.MyCommand.Path `
		-Parent `
;

Function Import-LocalizedData {
	<#
		.Synopsis
			«агружает локализованные строковые ресурсы.
		.ForwardHelpTargetName
			Import-LocalizedData
		.ForwardHelpCategory
			Cmdlet
	#>
	[CmdletBinding(
		HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113342'
	)]
	param(
		[Parameter(
			Position = 0
			, Mandatory = $false
		)]
		[Alias( 'Variable' )]
		[ValidateNotNullOrEmpty()]
		[String]
		${BindingVariable}
	,
		[Parameter(
			Position = 1
			, Mandatory = $false
		)]
		[System.Globalization.CultureInfo]
		${UICulture} = ( Get-Culture )
	,
		[Parameter(
			Mandatory = $false
		)]
		[String]
		${BaseDirectory}
	,
		[Parameter(
			Mandatory = $false
		)]
		[String]
		${FileName}
	,
		[Parameter(
			Mandatory = $false
		)]
		[String[]]
		${SupportedCommand}
	)

	try {
		$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
			'Import-LocalizedData'
			, [System.Management.Automation.CommandTypes]::Cmdlet
		);
		$loc = & $wrappedCmd @PSBoundParameters;
<#
		$PSLocRM = New-Object `
			-Type 'System.Resources.ResourceManager' `
			-ArgumentList `
				'HelpDisplayStrings' `
				, ( [System.Reflection.Assembly]::Load('System.Management.Automation') ) `
		;
		$PSloc = $PSLocRM.GetResourceSet( $UICulture, $true, $true );
		$PSloc `
		| % {
			if ( -not $loc.ContainsKey( $_.Name ) ) {
				$loc.Add( $_.Name, $_.Value.Trim() );
			};
		};
#>
	} catch {
		throw;
	};
	return $loc;
};

$loc = Import-LocalizedData;

. (	Join-Path -Path $CurrentDir -ChildPath 'ITG.DomainUtils.Printers.ps1' );

Export-ModuleMember `
	-Function `
		Get-ADPrintQueue `
		, Test-ADPrintQueue `
		, Install-ADPrintQueuesEnvironment `
		, Get-ADPrintQueueContainer `
		, Test-ADPrintQueueContainer `
		, New-ADPrintQueueContainer `
	-Alias `
		Get-ADPrinter `
		, Test-ADPrinter `
		, Get-ADPrinterContainer `
		, Test-ADPrinterContainer `
		, New-ADPrinterContainer `
;