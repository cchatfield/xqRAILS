xquery version "1.0-ml";

(:
 :
 : @object@ list json view
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
 
import module namespace xqrails = "http://avalonconsult.com/xqrails/core" at "/xqrails-core/xqrails.xqy";
import module namespace @object-escaped@ = "@xqrails.core.namespace@/models/@object-escaped@" at "/xqrails-app/models/@object-escaped@.xqy";

(: model contains all presentation objects :)
declare variable $model as map:map external;

let $search := map:get($model, 'search')
let $total := fn:data($search/@total)
let $count := fn:count($search//@object@)
let $payload :=
    for $object in map:get($model, '@object-escaped@')
        let $items := 
            for $node in $object/*
            return
               fn:concat(xdmp:to-json(fn:node-name($node)), ":", xdmp:to-json(fn:string-join($node/string(), "")))
    return 
        fn:concat("{", fn:string-join($items, ","), "}")           

return
    fn:concat
    (
        "{ &quot;data&quot;: {",
        "&quot;count&quot;:", $count, ",", 
        "&quot;total&quot;:", $total, ",", 
        "&quot;@object-escaped@&quot;: [",
        fn:string-join($payload, ","),
        "]}}"
    )
