param([string]$process)

Function MoveWindowtoBottom() {

$WindowAPIDef = @"
	[DllImport("user32.dll", CharSet = CharSet.Unicode)]
	public static extern IntPtr FindWindow(IntPtr sClassName, String sAppName);
	
	[DllImport("user32.dll", CharSet = CharSet.Unicode)]
	public static extern IntPtr SetWindowPos(IntPtr hWnd, int hWndInsertAfter, int x, int Y, int cx, int cy, int wFlags);
	
	public static void MovetoBottom(IntPtr hWnd) {
		SetWindowPos(hWnd, 1, 0, 0, 0, 0, 0x0010 | 0x0002 | 0x0001);
	}
	
	
"@

$WindowAPI = Add-Type -Namespace Win32 -Name Funcs -MemberDefinition $WindowAPIDef -PassThru
	
$WindowName = Get-Process $Process |where {$_.mainWindowTItle}

$GetWindow = $WindowAPI::FindWindow([IntPtr]::Zero, $WindowName.MainWindowTitle)

$WindowAPI::MovetoBottom($GetWindow)
}


Do {
	$ProcessPID = Get-Process $Process -ErrorAction SilentlyContinue
	if ($ProcessPID) {
		MoveWindowtoBottom
	}
	Start-Sleep -m 1000
} while ($true)