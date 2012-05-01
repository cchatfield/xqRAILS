xquery version "1.0-ml";

(:
 :
 : @object@ model (transient)
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
 
module namespace @object-escaped@ = "@xqrails.core.namespace@/models/@object-escaped@";

import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "../library/util.xqy";

declare namespace error = "http://marklogic.com/xdmp/error"; 

(:
 : general constraints for the $@object-escaped@ object
 :
 : fieldType [ "hidden", "string", "text", "upload", "date", "dateTime", "select", "checkBox" ]
 : validation types:
 :      required
 :      validateMinLength
 :      validateMin
 :      validateMaxLength
 :      validateMax
 :      validateSameAs
 :      validateEmail
 :      validateUrl
 :      validateNumber
 :      validateInteger
 :      validateAlpha
 :      validateAlphaNum
 :      validatePhrase
 :      validatePhone
 :      validateDate
 : minOccurs [ 0 - n ]
 : maxOccurs [ 0 - n, unbounded ]
 : options - pipe delimited list of available values
 :
 :)
declare variable $@object-escaped@-constraints :=
    element constraints
    {
        element identifier
        {
            attribute fieldType {"hidden"}
        },
        element title
        {
            attribute fieldType {"string"},
            attribute validation {"required"}
        },
        element description
        {
            attribute fieldType {"text"},
            attribute validation {"required"}
        },
        element createdBy
        {
            attribute fieldType {"string"},
            attribute validation {"required"}
        },
        element dateCreated
        {
            attribute fieldType {"dateTime"},
            attribute validation {"required"}
        },
        element lastUpdated
        {
            attribute fieldType {"dateTime"},
            attribute validation {"required"}
        }
    };

(: path to the id field :)    
declare variable $@object-escaped@-id-field-path := "identifier";

declare function @object-escaped@:build($values as map:map) as element(@object@)
{
    let $@object-escaped@ := @object-escaped@:new()
    return @object-escaped@:update($@object-escaped@, $values)
};

declare function @object-escaped@:new() as element(@object@)
{
    (: create default element :)
    element @object@ 
    {
        element identifier {util:generate-uuid-v4()},
        element title {},
        element description {},
        element createdBy {xdmp:get-current-user()},
        element dateCreated {fn:current-dateTime()},
        element lastUpdated {fn:current-dateTime()}
       (: add additional elements :)
    }
};

declare function @object-escaped@:update($@object-escaped@ as element(@object@), $values as map:map) as element(@object@)
{
    @object-escaped@:update-nodes($@object-escaped@, $values)
};

declare function @object-escaped@:validate($@object-escaped@ as element(@object@)) 
{
    (: future validation stub :)
    ()
};

declare function @object-escaped@:keys() as xs:string* 
{
    @object-escaped@:list-nodes(@object-escaped@:new()/element())
};

(: Private Functions :)
declare private function @object-escaped@:update-nodes($node as node(), $values as map:map) as element() 
{
    element {fn:node-name($node)}
    {
        $node/@*,
        if (fn:empty($node/node())) then
            if (fn:empty(map:get($values, fn:name($node)))) then 
                $node/fn:string(.)
            else 
                map:get($values, fn:name($node))
        else        
            for $child in $node/node()
            return 
                if ($child instance of element()) then 
                    @object-escaped@:update-nodes($child, $values)
                else 
                    if (fn:empty(map:get($values, fn:name($node)))) then 
                        $node/fn:string(.)
                    else 
                        map:get($values, fn:name($node))
    }
};

declare private function @object-escaped@:list-nodes($node as node()) as xs:string+
{
    if (fn:empty($node/node())) then
        fn:name($node)
    else
        for $child in $node/node()
        return 
            if ($child instance of element()) then 
                @object-escaped@:list-nodes($child)
            else 
                fn:name($node)
};

