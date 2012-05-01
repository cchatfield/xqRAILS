xquery version "1.0-ml";

(:
 :
 : @object@ model
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
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare namespace error = "http://marklogic.com/xdmp/error"; 

(: 
 : general constraints for the $@object-escaped@ object
 :
 : fieldType [ "hidden", "string", "text", "upload", "date", "dateTime", "select", "checkBox", "xml" ]
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

(: default sort element :)    
declare variable $@object-escaped@-default-sort := "title";

(: max results to return :)    
declare variable $@object-escaped@-max-results := 1000;

(: default page size :)    
declare variable $@object-escaped@-default-page-size := 10;

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
    util:update-nodes($@object-escaped@, $values, $@object-escaped@-constraints)
};

declare function @object-escaped@:validate($@object-escaped@ as element(@object@)) 
{
    (: future validation stub :)
    ()
};

declare function @object-escaped@:save($@object-escaped@ as element(@object@))
{
    let $uri := fn:concat( "/docs/@object-escaped@/", $@object-escaped@/identifier/fn:string(), ".xml")
    let $collection := "@xqrails.core.namespace@/models/@object-escaped@"
    let $permissions := 
    (
        xdmp:permission("security-user", "read"), xdmp:permission("security-user", "execute"),
        xdmp:permission("security-user", "update"), xdmp:permission("security-user", "insert"),
        xdmp:permission("security-admin", "read"), xdmp:permission("security-admin", "execute"),
        xdmp:permission("security-admin", "update"), xdmp:permission("security-admin", "insert"),
        xdmp:permission("security-anon", "read"), xdmp:permission("security-anon", "update"),
        xdmp:default-permissions()
    )
    return
        xdmp:document-insert($uri, $@object-escaped@, $permissions, $collection)
};

declare function @object-escaped@:find($id as xs:string) as element(@object@)? 
{
    xdmp:value(fn:concat("/@object@[", $@object-escaped@-id-field-path, " eq $id]"))
};

declare function @object-escaped@:find-all() as element(search:response)
{
    @object-escaped@:find-by("", 1, $@object-escaped@-max-results, $@object-escaped@-id-field-path)
};

declare function @object-escaped@:find-all($offset as xs:integer, $max as xs:integer) as element(search:response) 
{
    @object-escaped@:find-by("", $offset, $max, $@object-escaped@-id-field-path)
};

declare function @object-escaped@:find-by($filter as xs:string, $offset as xs:integer, $max as xs:integer, $sort as xs:string) as element(search:response)
{
    search:search($filter, @object-escaped@:build-search-options($sort), $offset, $max)
};
declare function @object-escaped@:id($@object-escaped@ as element(@object@)) as xs:string
{
    xdmp:value(fn:concat("$@object-escaped@/", $@object-escaped@-id-field-path, "/fn:string(.)"))
};

declare function @object-escaped@:delete($@object-escaped@ as element(@object@)) 
{
    xdmp:document-delete(xdmp:node-uri($@object-escaped@))
};

declare function @object-escaped@:delete-by-id($id as xs:string) 
{
    xdmp:document-delete(fn:concat("/docs/@object-escaped@/", $id, ".xml"))
};

declare function @object-escaped@:keys() as xs:string* 
{
    util:list-nodes(@object-escaped@:new()/element())
};

(: Private Functions :)

declare private function @object-escaped@:build-search-options($sort as xs:string) as element()?
{
    <options xmlns="http://marklogic.com/appservices/search">
        <searchable-expression>
            fn:collection("@xqrails.core.namespace@/models/@object-escaped@")
        </searchable-expression>
        <sort-order type="xs:string" collation="http://marklogic.com/collation/" direction="ascending">
            <element ns="@xqrails.core.namespace@/models/@object-escaped@" name="{ $sort }"/>
        </sort-order>
        <transform-results apply="build-full-doc-snippet" ns="@xqrails.core.namespace@/models/@object-escaped@" at="/xqrails-app/models/@object-escaped@.xqy" />
    </options>
};



declare private function @object-escaped@:build-full-doc-snippet($result as node(), $ctsquery as schema-element(cts:query), $options as element(search:transform-results)?) as element(search:snippet)?
{
    element search:snippet 
    {
        $result
    }
};
