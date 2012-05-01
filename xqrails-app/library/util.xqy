xquery version "1.0-ml";

(:
 :
 : util library
 :
 : Copyright 2011 Avalon Consulting, LLC 
 :
 : Licensed under the Apache License, Version 2.0 (the "License"); 
 : you may not use this file except in compliance with the License. 
 : You may obtain a copy of the License at 
 :
 :       http://www.apache.org/licenses/LICENSE-2.0 
 :
 : Unless required by applicable law or agreed to in writing, software 
 : distributed under the License is distributed on an "AS IS" BASIS, 
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
 : See the License for the specific language governing permissions and 
 : limitations under the License. 
 :
 :)
 
module namespace util = "http://avalonconsult.com/xqrails/library/util";
import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";

declare function util:random-hex($length as xs:integer) as xs:string{
    fn:string-join(
        for $n in 1 to $length
        return
            xdmp:integer-to-hex(xdmp:random(15)),""
    )
};
     
declare function util:generate-uuid-v4() as xs:string{
    fn:string-join(
        (
            util:random-hex(8),
            util:random-hex(4),   
            util:random-hex(4),
            util:random-hex(4),
            util:random-hex(12)
        ),
        "-"
    )
};

declare function util:change-attribute-values(
   $node as node(),
   $element as xs:string,
   $attribute as xs:string,
   $old-value as xs:string,
   $new-value as xs:string) as element() {
       element
         {fn:node-name($node)}
         {if (xs:string(fn:node-name($node))=$element)
           then
              for $att in $node/@*
              return
                if (fn:name($att)=$attribute and fn:data($att) eq $old-value)
                  then
                     attribute {fn:name($att)} {$new-value}
                   else
                      $att
           else
              $node/@*
           ,
               for $child in $node/node()
                 return if ($child instance of element())
                    then util:change-attribute-values($child, $element, $attribute, $old-value, $new-value)
                    else $child 
         }
};

declare function util:change-all-attribute-values(
   $node as node(),
   $attribute as xs:string,
   $old-value as xs:string,
   $new-value as xs:string) as element() {
       element
         {fn:node-name($node)}
         {    
          for $att in $node/@*
          return
            if (fn:name($att)=$attribute and fn:data($att) eq $old-value)
              then
                 attribute {fn:name($att)} {$new-value}
               else
                  $att
           ,
               for $child in $node/node()
                 return if ($child instance of element())
                    then util:change-all-attribute-values($child, $attribute, $old-value, $new-value)
                    else $child 
         }
};

declare function util:change-node-values(
   $node as node(),
   $element as xs:string,
   $new-value as xs:string) as element() {
       element
         {fn:node-name($node)}
         {
         if (xs:string(fn:node-name($node)) = $element) then
         (
             $node/@*,
             $new-value
         )
         else
         (
             $node/@*,
             for $child in $node/node()
             return 
                 if ($child instance of element())
                 then util:change-node-values($child, $element, $new-value)
                 else $child 
         )
         }
};

declare function util:remove-elements-deep-matching-attribute 
  ( $nodes as node()* , $name as xs:string, $attribute-name as xs:string, $attribute-val as xs:string)  as node()* {
       
  for $node in $nodes
   return
     if ($node instance of element()) then 
        if (functx:name-test(fn:name($node),$name)) then 
            let $found := fn:false()
            let $_ :=
                for $att in $node/@*
                where ($found ne fn:true())
                return
                    if (fn:name($att) eq $attribute-name and fn:data($att) eq $attribute-val) then
                        
                        xdmp:set($found, fn:true())
                    else
                        ()
            return 
                if ($found) then 
                (     
                    ()
                )
                else
                (
                    $node
                )
        else
            element { fn:node-name($node)}
                    { $node/@*,util:remove-elements-deep-matching-attribute($node/node(), $name, $attribute-name, $attribute-val)}
     else 
        $node
 } ;


declare function util:map-keys-to-string-join(
   $map as map:map,
   $separator as xs:string) as xs:string {
      fn:string-join(map:keys($map),$separator) 
};

declare function util:base64-string-to-binary($string as xs:string) as binary()
{
    binary{xs:hexBinary(xs:base64Binary($string))}
};

declare function util:binary-to-base64-string($node as binary())
{
      xs:base64Binary(xs:hexBinary($node)) cast as xs:string
};

declare function util:get-map-value($params as map:map, $key as xs:string, $default as xs:string)
{
    if (map:get($params, $key)) then
    (
        map:get($params, $key)
    )
    else
    (
        $default
    ) 
};

declare function util:fix-camel-case-to-string($string as xs:string) as xs:string
{
    let $fixed := functx:camel-case-to-words($string, " ")
    let $fixed := fn:replace($fixed, ":", " ")
    let $fixed := functx:capitalize-first($fixed)
    return $fixed
};


declare function util:convert-string-to-element($item)
{
    if ($item instance of xs:string) then
    (
        xdmp:unquote(fn:replace($item, "&#160;", ""))
    )
    else
    (
        $item/node()
    )
};

declare function util:list-nodes($node as node()) as xs:string+
{
    if (fn:empty($node/node())) then
        fn:name($node)
    else
        for $child in $node/node()
        return 
            if ($child instance of element()) then 
                util:list-nodes($child)
            else 
                fn:name($node)
};

declare function util:is-xml-constraint($constraint as element(constraints), $name as xs:string) as xs:boolean
{
    if (xdmp:value(fn:concat("fn:data($constraint/", $name, "/@fieldType)")) eq "xml") then
    (
        fn:true()
    )
    else
    (
        fn:false()
    )
};

declare function util:update-nodes($node as node(), $values as map:map, $constraint as element(constraints)) as element() 
{
    element {fn:node-name($node)}
    {
        $node/@*,
        if (fn:empty($node/node())) then
            if (fn:empty(map:get($values, fn:name($node)))) then 
                $node/fn:string(.)
            else 
                if (is-xml-constraint($constraint, fn:name($node))) then
                (
                    if(map:get($values, fn:name($node)) instance of element()) then
                    (
                        map:get($values, fn:name($node))
                    )
                    else
                    (
                        convert-string-to-element(map:get($values, fn:name($node)))
                    )
                )
                else
                (
                    map:get($values, fn:name($node))
                )
        else        
            for $child in $node/node()
            return 
                if ($child instance of element() and fn:not(is-xml-constraint($constraint, fn:name($node)))) then 
                    update-nodes($child, $values, $constraint)
                else 
                    if (fn:empty(map:get($values, fn:name($node)))) then
                        if (is-xml-constraint($constraint, fn:name($node))) then
                        (
                            $node/*
                        )
                        else
                        (
                            $node/fn:string(.)
                        )
                    else 
                        if (is-xml-constraint($constraint, fn:name($node))) then
                        (
                            convert-string-to-element(map:get($values, fn:name($node)))
                        )
                        else
                        (
                            map:get($values, fn:name($node))
                        )
                        
    }
};


