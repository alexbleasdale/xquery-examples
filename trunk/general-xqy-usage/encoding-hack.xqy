(: saw this on the marklogic forums somewhere - TODO - update with more info later :)

declare function local:filesystem-file-head($path as xs:string, $length as xs:integer) as xs:string {
let $half-bytes := tokenize(substring(string(data(xdmp:document-get($path,
      <options xmlns="xdmp:document-get">
        <format>binary</format>
        <repair>none</repair>
      </options>))), 1, $length * 2), "")
let $bytes :=
    for $half-byte at $pos in $half-bytes
    where ($pos mod 2) = 0
    return
        xdmp:hex-to-integer(concat($half-byte, $half-bytes[$pos + 1]))

return
    codepoints-to-string($bytes)

};

declare function local:filesystem-file-xmldecl($path as xs:string) as xs:string {
    let $prolog :=
        local:filesystem-file-head($path, 100)
    return
        if (contains($prolog, "<?xml") and contains($prolog, "?>")) then
            concat(substring-before(concat("<?xml", substring-after($prolog, "<?xml")), "?>"), "?>")
        else
            ''
};

declare function local:filesystem-file-encoding($path as xs:string) as xs:string {
    let $xml-decl :=
        local:filesystem-file-xmldecl($path)
    return
    if (matches($xml-decl, "^<\?.*\sencoding='([^']*)'.*>$")) then
        replace($xml-decl, "^<\?.*\sencoding='([^']*)'.*>$", "$1")
    else if (matches($xml-decl, '<\?.*\sencoding="([^"]*)".*>$')) then
        replace($xml-decl, '<\?.*\sencoding="([^"]*)".*>$', "$1")
    else
        "UTF-8"
};

let $path := "c:\temp\test.xml"
let $xml-decl:= local:filesystem-file-xmldecl($path)
let $encoding := local:filesystem-file-encoding($path)
let $response-decl := replace($xml-decl, $encoding, "utf-8")
return (
    xdmp:set-response-content-type("application/xml; charset=utf-8"),
    $response-decl,
    xdmp:document-get($path, <options xmlns="xdmp:document-get"><format>xml</format><repair>none</repair><encoding>{$encoding}</encoding></options>)
)

(:
Create c:\temp\test.xml containing something like:

<?xml version="1.0" encoding="ISO-8859-1" standalone="yes" ?>
<TEST>Fûnny cháràctërs</TEST>
:)


