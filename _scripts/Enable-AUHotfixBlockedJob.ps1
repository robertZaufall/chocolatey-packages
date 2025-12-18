function Enable-AUHotfixBlockedJob {
    [CmdletBinding()]
    param()

    $cmd = Get-Command Update-AUPackages -ErrorAction Stop

    # Already patched (idempotent).
    if ($cmd.ScriptBlock.ToString() -match 'AU_HOTFIX_BLOCKED_JOB') { return }

    $def = $cmd.ScriptBlock.ToString()

    # Patch strategy:
    # - Find the log line that prints "Invalid job state for ..."
    # - Immediately stop+remove that job and `continue` the foreach loop
    # This avoids the "Blocked" job being observed repeatedly and lets updateall proceed.
    $pattern = '(?m)^(\s*)(Write-(?:Host|Warning)\s+.*Invalid job state for.*)$'

    $patched = [regex]::Replace(
        $def,
        $pattern,
        {
            param($m)
            $indent = $m.Groups[1].Value
            $line = $m.Groups[2].Value
            @(
                $line
                "${indent}# AU_HOTFIX_BLOCKED_JOB: remove invalid-state jobs (e.g. Blocked) so updateall can continue"
                "${indent}try { Stop-Job `$job -Force -ErrorAction SilentlyContinue } catch {}"
                "${indent}try { Remove-Job `$job -Force -ErrorAction SilentlyContinue } catch {}"
                "${indent}continue"
            ) -join "`n"
        },
        [System.Text.RegularExpressions.RegexOptions]::None
    )

    if ($patched -eq $def) {
        Write-Warning "Enable-AUHotfixBlockedJob: Could not locate \"Invalid job state\" handler in Update-AUPackages; skipping hotfix."
        return
    }

    Set-Item -Path Function:\Update-AUPackages -Value ([ScriptBlock]::Create($patched))
}
