xquery version '1.0-ml';

(:~ 
 : ML example of function signature overloading - works with eXist too 
 :)

declare function local:error($code as xs:string)
{
  let $resp := <single-node>{$code}</single-node>
  return $resp
};


declare function local:error($code as xs:string, $details as xs:string)
{
    let $resp := <nodes><node1>{$code}</node1><node2>{$details}</node2></nodes>
    return $resp
};

(: xq :)
<results>
{local:error("test-one")}
</results>