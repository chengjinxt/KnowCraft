BEGIN {
    inserted = 0
}

NR == 1 && $0 == "rules:" {
    print
    print "- DOMAIN,www.5k40.com,DIRECT"
    print "- DOMAIN,555kp40.com,DIRECT"
    print "- DOMAIN,www.555dyx9.com,DIRECT"
    inserted = 1
    next
}

$0 == "- DOMAIN,www.5k40.com,DIRECT" { next }
$0 == "- DOMAIN,555kp40.com,DIRECT" { next }
$0 == "- DOMAIN,www.555dyx9.com,DIRECT" { next }

{
    print
}

END {
    if (!inserted) {
        exit 2
    }
}
