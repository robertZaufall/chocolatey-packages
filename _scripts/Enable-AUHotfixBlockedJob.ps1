function Enable-AUHotfixBlockedJob {
    [CmdletBinding()]
    param()

    $cmd = Get-Command Update-AUPackages -ErrorAction Stop
    $module = $cmd.Module

    # Already patched (idempotent).
    if ($cmd.ScriptBlock.ToString() -match 'AU_HOTFIX_BLOCKED_JOB') { return $true }

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
	                "${indent}try { Wait-Job `$job -Timeout 5 -ErrorAction SilentlyContinue | Out-Null } catch {}"
	                "${indent}if ( 'Stopped', 'Failed', 'Completed' -contains `$job.State ) {"
	                "${indent}  # Don't count this iteration; let the normal handler process+Remove-Job the now-stopped job."
	                "${indent}  `$p -= 1"
	                "${indent}  continue"
	                "${indent}}"
	                "${indent}try { Remove-Job -Id `$job.Id -Force -ErrorAction SilentlyContinue } catch {}"
	                "${indent}if (Get-Job -Id `$job.Id -ErrorAction SilentlyContinue) {"
	                "${indent}  try { Remove-Job -Name `$job.Name -Force -ErrorAction SilentlyContinue } catch {}"
	                "${indent}}"
	                "${indent}if (Get-Job -Id `$job.Id -ErrorAction SilentlyContinue) {"
	                "${indent}  # Last resort: clear all jobs so the queue can move on."
	                "${indent}  try { Remove-Job * -Force -ErrorAction SilentlyContinue } catch {}"
	                "${indent}}"
	                "${indent}continue"
	            ) -join "`n"
	        },
	        [System.Text.RegularExpressions.RegexOptions]::None
	    )

    if ($patched -eq $def) {
        Write-Warning "Enable-AUHotfixBlockedJob: Could not locate \"Invalid job state\" handler in Update-AUPackages; skipping hotfix."
        return $false
    }

    if (-not $module) {
        Write-Warning "Enable-AUHotfixBlockedJob: Update-AUPackages isn't associated with a module; skipping hotfix to avoid breaking module-scoped types."
        return $false
    }

    # IMPORTANT: Define the patched function *inside the chocolatey-au module scope*.
    # If we redefine it in global scope, module-defined classes (e.g. [AUPackage]) may not resolve at runtime.
    & $module {
        param($newBody)
        Set-Item -Path Function:\Update-AUPackages -Value ([ScriptBlock]::Create($newBody))
    } $patched

    $ok = & $module { (Get-Command Update-AUPackages -ErrorAction Stop).ScriptBlock.ToString() -match 'AU_HOTFIX_BLOCKED_JOB' }
    if (-not $ok) {
        # Fallback for CI: patch the installed module file on disk, then re-import.
        if ($Env:GITHUB_ACTIONS -ne 'true') {
            Write-Warning "Enable-AUHotfixBlockedJob: Attempted to patch Update-AUPackages but verification failed; skipping hotfix."
            return $false
        }

        $file = $cmd.ScriptBlock.File
        if (-not $file) {
            Write-Warning "Enable-AUHotfixBlockedJob: Verification failed and Update-AUPackages has no backing file; skipping hotfix."
            return $false
        }
        if (-not (Test-Path -LiteralPath $file)) {
            Write-Warning "Enable-AUHotfixBlockedJob: Verification failed and backing file not found: $file"
            return $false
        }

        try {
            $src = Get-Content -LiteralPath $file -Raw -ErrorAction Stop
            if ($src -notmatch 'AU_HOTFIX_BLOCKED_JOB') {
                $src2 = [regex]::Replace(
                    $src,
                    $pattern,
                    {
                        param($m)
                        $indent = $m.Groups[1].Value
                        $line = $m.Groups[2].Value
                        @(
                            $line
                            "${indent}# AU_HOTFIX_BLOCKED_JOB: remove invalid-state jobs (e.g. Blocked) so updateall can continue"
                            "${indent}try { Stop-Job `$job -Force -ErrorAction SilentlyContinue } catch {}"
                            "${indent}try { Wait-Job `$job -Timeout 5 -ErrorAction SilentlyContinue | Out-Null } catch {}"
                            "${indent}if ( 'Stopped', 'Failed', 'Completed' -contains `$job.State ) {"
                            "${indent}  `$p -= 1"
                            "${indent}  continue"
                            "${indent}}"
                            "${indent}try { Remove-Job -Id `$job.Id -Force -ErrorAction SilentlyContinue } catch {}"
                            "${indent}if (Get-Job -Id `$job.Id -ErrorAction SilentlyContinue) {"
                            "${indent}  try { Remove-Job -Name `$job.Name -Force -ErrorAction SilentlyContinue } catch {}"
                            "${indent}}"
                            "${indent}if (Get-Job -Id `$job.Id -ErrorAction SilentlyContinue) {"
                            "${indent}  try { Remove-Job * -Force -ErrorAction SilentlyContinue } catch {}"
                            "${indent}}"
                            "${indent}continue"
                        ) -join "`n"
                    },
                    [System.Text.RegularExpressions.RegexOptions]::None
                )

                if ($src2 -eq $src) {
                    Write-Warning "Enable-AUHotfixBlockedJob: CI fallback patch pattern not found in $file"
                    return $false
                }
                Set-Content -LiteralPath $file -Value $src2 -Encoding UTF8 -ErrorAction Stop
            }

            Remove-Module $module.Name -Force -ErrorAction SilentlyContinue
            Import-Module $module.Path -Force -ErrorAction Stop

            $ok = & (Get-Module $module.Name -ErrorAction Stop) { (Get-Command Update-AUPackages -ErrorAction Stop).ScriptBlock.ToString() -match 'AU_HOTFIX_BLOCKED_JOB' }
        } catch {
            Write-Warning ("Enable-AUHotfixBlockedJob: CI fallback patch failed: " + $_.Exception.Message)
            return $false
        }
    }
    return [bool]$ok
}
