xquery version "1.0";
declare namespace fxx="http://xquery-examples.googlecode.com/fxx";

 declare function fxx:add-commas-to-positive-integer
 ( $in as xs:string? ) as xs:string {
   if (string-length($in) < 4)
     then ($in)
     else (
        (: mod is always 0, 1 or 2.  If mod is 1 or 2 then it is the range endpoint to get characters for prefix, if mod is zero we need to return 'nnn,' :)
        let $mod := string-length($in) mod 3
        (: prefix is 'n,' 'nn,' or 'nnn,' :)
        let $prefix := if ($mod = 0) then (concat(substring($in, 1, 3), ',')) else (concat(substring($in, 1, $mod), ','))
        (: remainder is all the characters after the prefix :)
        let $remainder :=  if ($mod = 0) then (substring($in, 4)) else (substring($in, $mod+1))
        (: if we have more that 6 digits we have two commas :)
        return concat($prefix, fxx:add-commas-to-positive-integer(($remainder)))
     )
 } ;
 
<html> <head><title>Test of add-commas-to-positive-integer()</title></head><body>
<h1>Test of add-commas-to-positive-integer() function</h1>
<!-- (1 12 123 1234 1234 12345 123456 1234567 12345678 123456789 1234567890) -->
<table border="1">
<thead>
  <tr>
    <th>Input</th>
    <th>Output</th>
  </tr>
</thead>
<tbody  align="right">
{

for $i in (1 to 100)
let $n := $i * $i * $i * $i * $i * $i
return
<tr >
 <td>{$n}</td><td>{fxx:add-commas-to-positive-integer(xs:string($n))}</td>
 </tr>
}
</tbody>
</table>

</body> </html> 