function Enable-AUHotfixBlockedJob {
    [CmdletBinding()]
    param()

    $cmd = Get-Command Update-AUPackages -ErrorAction Stop

    # Already patched (idempotent).
    if ($cmd.ScriptBlock.ToString() -match 'AU_HOTFIX_BLOCKED_JOB') { return }

    $def = $cmd.ScriptBlock.ToString()

    $pattern = @'
(?s)
if\s*\(\s*'Stopped'\s*,\s*'Failed'\s*,\s*'Completed'\s*-notcontains\s*\$job\.State\s*\)\s*\{\s*
Write-Host\s+"Invalid job state for\s+\$\(\$job\.Name\):\s*"\s+\$job\.State\s*
\}\s*
else\s*\{
'@

    $replacement = @'
if ( 'Stopped', 'Failed', 'Completed' -notcontains $job.State) {
    # AU_HOTFIX_BLOCKED_JOB: treat invalid job states (e.g. Blocked) as "ignored" and remove the job
    # so the update run can continue with the next package.
    Write-Host "Invalid job state for $($job.Name): " $job.State

    try { Stop-Job $job -Force -ErrorAction SilentlyContinue } catch {}
    try { Remove-Job $job -Force -ErrorAction SilentlyContinue } catch {}

    try {
        $pkg = [AUPackage]::new((Get-AUPackages $job.Name))
        $pkg.Ignored = $true
        $pkg.IgnoreMessage = "Invalid job state: $($job.State)"
        $pkg.Result = @('ignored', '', $pkg.IgnoreMessage)
        $result += $pkg
    } catch {
        # If we can't construct a package result, just continue; the important part is to unblock the queue.
    }

    continue
}
else {
'@

    $patched = [regex]::Replace($def, $pattern, $replacement, 'IgnoreCase')
    if ($patched -eq $def) {
        throw "Enable-AUHotfixBlockedJob: Patch pattern not found in Update-AUPackages (module version changed?)"
    }

    Set-Item -Path Function:\Update-AUPackages -Value ([ScriptBlock]::Create($patched))
}

