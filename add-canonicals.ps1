# add-canonicals.ps1
# Run this from the root of your cball8475.github.io repo folder
# It adds a <link rel="canonical"> to every HTML file that doesn't already have one.

$base = "https://florencescservices.com"

$map = @{
    "index.html"                                          = "$base/"
    "about.html"                                          = "$base/about"
    "contact.html"                                        = "$base/contact"
    "pricing.html"                                        = "$base/pricing"
    "privacy.html"                                        = "$base/privacy"
    "terms.html"                                          = "$base/terms"
    "services.html"                                       = "$base/services"
    "service-area.html"                                   = "$base/service-area"
    "darlington.html"                                     = "$base/darlington"
    "hartsville.html"                                     = "$base/hartsville"
    "lake-city.html"                                      = "$base/lake-city"
    "marion.html"                                         = "$base/marion"
    "dillon.html"                                         = "$base/dillon"
    "florence-sc-dumpster-rental.html"                    = "$base/florence-sc-dumpster-rental"
    "dumpster-rental-florence-sc.html"                    = "$base/dumpster-rental-florence-sc"
    "darlington-sc-dumpster-rental.html"                  = "$base/darlington-sc-dumpster-rental"
    "hartsville-sc-dumpster-rental.html"                  = "$base/hartsville-sc-dumpster-rental"
    "lake-city-sc-dumpster-rental.html"                   = "$base/lake-city-sc-dumpster-rental"
    "marion-sc-dumpster-rental.html"                      = "$base/marion-sc-dumpster-rental"
    "construction-dumpster-rental-florence-sc.html"       = "$base/construction-dumpster-rental-florence-sc"
    "florence-sc-landfill-guide.html"                     = "$base/florence-sc-landfill-guide"
    "residential-dumpster-rental-darlington-hartsville.html" = "$base/residential-dumpster-rental-darlington-hartsville"
}

foreach ($file in $map.Keys) {
    if (-not (Test-Path $file)) {
        Write-Host "SKIP (not found): $file"
        continue
    }

    $content = Get-Content $file -Raw -Encoding UTF8
    $url = $map[$file]
    $tag = "    <link rel=`"canonical`" href=`"$url`" />"

    # Skip if canonical already exists
    if ($content -match 'rel="canonical"') {
        Write-Host "ALREADY HAS CANONICAL: $file"
        continue
    }

    # Insert after the last <meta> tag in <head>, or just before </head>
    if ($content -match '(?i)([ \t]*<meta[^>]+>\s*\n)(?=\s*(</head>|<link|<title|<style|<script))') {
        # Try to insert after the last meta block — easier approach: before </head>
    }

    # Reliable approach: insert before </head>
    $newContent = $content -replace '(?i)([ \t]*</head>)', "$tag`n`$1"

    Set-Content $file -Value $newContent -Encoding UTF8 -NoNewline
    Write-Host "DONE: $file  =>  $url"
}

Write-Host ""
Write-Host "All done. Review changes with: git diff"
Write-Host "Then commit and push: git add -A && git commit -m 'Add canonical tags to all pages' && git push"
