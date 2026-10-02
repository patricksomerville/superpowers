# Install/refresh the Superpowers port for Kilo Code (VS Code extension + TUI/CLI).
# This installer uses Kilo-supported legacy paths for compatibility with the
# existing Somertime setup. Current Kilo docs recommend the newer locations
# described below; this script does not migrate or remove existing files.
#
# Superpowers is not shipped by Kilo, so this ports it using Kilo surfaces:
#   * skills      -> ~/.kilocode/skills/<name>/SKILL.md   (legacy; current default: ~/.kilo/skills)
#   * bootstrap   -> ~/.kilocode/rules/superpowers.md     (legacy global rules path)
#   * command     -> ~/.config/kilo/command/superpowers.md (legacy singular path; current default: ~/.config/kilo/commands)
#
# Kilo's current compatibility and location docs:
# https://kilo.ai/docs/customize/skills
# https://kilo.ai/docs/customize/custom-rules
# https://kilo.ai/docs/customize/workflows
#
# Re-run after `git pull` in this repo to refresh skills and regenerate the bootstrap.

$ErrorActionPreference = 'Stop'

$repo    = Split-Path -Parent $PSScriptRoot
$skills  = Join-Path $repo 'skills'
$use     = Join-Path $skills 'using-superpowers'
$skillMd = Join-Path $use 'SKILL.md'
$mapMd   = Join-Path $use 'references\kilo-tools.md'

if (-not (Test-Path -LiteralPath $skillMd)) { throw "Cannot find $skillMd" }
if (-not (Test-Path -LiteralPath $mapMd))   { throw "Cannot find $mapMd" }

# These legacy global paths remain supported by current Kilo. The script does
# not probe runtime discovery or modify the user's global Kilo configuration.
$home_ = $HOME

# --- 1. Skills ---------------------------------------------------------------
$skillsDest = Join-Path $home_ '.kilocode\skills'
New-Item -ItemType Directory -Force -Path $skillsDest | Out-Null

$installed = @()
Get-ChildItem -LiteralPath $skills -Directory | ForEach-Object {
    $target = Join-Path $skillsDest $_.Name
    Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
    $installed += $_.Name
}

# --- 2. Bootstrap (always-on rule) -------------------------------------------
$raw  = Get-Content -LiteralPath $skillMd -Raw
$body = $raw -replace '(?s)^---\r?\n.*?\r?\n---\r?\n', ''
$map  = Get-Content -LiteralPath $mapMd -Raw

$preamble = '<EXTREMELY_IMPORTANT>
You have superpowers.

**IMPORTANT: The using-superpowers skill content is included below. It is ALREADY LOADED - you are currently following it. Do NOT invoke the skill tool to load "using-superpowers" again - that would be redundant.**

'
$bootstrap = $preamble + $body.TrimEnd() + "`n`n" + $map.TrimEnd() + "`n`n</EXTREMELY_IMPORTANT>`n"

$rulesDir = Join-Path $home_ '.kilocode\rules'
New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
Set-Content -LiteralPath (Join-Path $rulesDir 'superpowers.md') -Value $bootstrap -Encoding UTF8

# --- 3. /superpowers command --------------------------------------------------
$cmdDir = Join-Path $home_ '.config\kilo\command'
New-Item -ItemType Directory -Force -Path $cmdDir | Out-Null

$command = @'
---
description: Superpowers - brainstorm before building, plan, TDD, systematic debugging, code review. Loads the using-superpowers bootstrap.
---
You have the Somertime port of the Superpowers skills library installed.

If `$ARGUMENTS` is empty: use the `skill` tool to list the available skills, then briefly say what each is for and ask what I want to work on.

Otherwise: invoke the `skill` tool to load `using-superpowers`, follow it, and apply the Superpowers workflow to this request:

$ARGUMENTS
'@
Set-Content -LiteralPath (Join-Path $cmdDir 'superpowers.md') -Value $command -Encoding UTF8

# --- Report ------------------------------------------------------------------
Write-Output "Superpowers for Kilo installed."
Write-Output ("  skills    : {0}" -f $skillsDest)
Write-Output ("  discovered: {0} ({1})" -f $installed.Count, ($installed -join ', '))
Write-Output ("  bootstrap : {0}" -f (Join-Path $rulesDir 'superpowers.md'))
Write-Output ("  command   : {0}" -f (Join-Path $cmdDir 'superpowers.md'))
