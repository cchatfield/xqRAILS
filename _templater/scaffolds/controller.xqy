xquery version "1.0-ml";

(:
 :
 : @object@ controller
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
 
module namespace xqrails-controller = "http://avalonconsult.com/xqrails/controller";

import module namespace xqrails = "http://avalonconsult.com/xqrails/core" at "/xqrails-core/xqrails.xqy";
import module namespace @object-escaped@ = "@xqrails.core.namespace@/models/@object-escaped@" at "/xqrails-app/models/@object-escaped@.xqy";

declare namespace error = "http://marklogic.com/xdmp/error";

(:~
 : the default action for the controller
 : 
 :)
declare function xqrails-controller:index()
{
    let $params := xqrails:build-params-map()
    return
        if (map:get($params, "method") eq "get") then
            if (map:get($params, "id")) then
                show($params)
            else
                list($params)
        else if (map:get($params, "method") eq "post") then 
            save($params)
        else if (map:get($params, "method") eq "put") then    
            update($params)
        else if (map:get($params, "method") eq "delete") then
            delete($params)
        else
            list($params)
};

(:~
 : the list action for the controller
 : 
 :)
declare function xqrails-controller:list()
{
    let $params := xqrails:build-params-map()
    return list($params)
};

declare function xqrails-controller:list($params as map:map)
{
    try
    {
        (: implement base call to grab list of records :)
        let $offset :=
            if (map:get($params, 'offset')) then
                xs:integer(map:get($params, 'offset'))
            else 
                1
        let $max :=  
            if (map:get($params, 'max')) then
                xs:integer(map:get($params, 'max'))
            else 
                $@object-escaped@:@object-escaped@-default-page-size
        let $filter :=  
            if (map:get($params, 'filter')) then
                map:get($params, 'filter')
            else 
                ""
        let $sort :=  
            if (map:get($params, 'sort')) then
                map:get($params, 'sort')
            else 
                $@object-escaped@:@object-escaped@-default-sort       

        let $search := @object-escaped@:find-by($filter, $offset, $max, $sort)
        let $@object-escaped@ := $search//@object@
        
        let $model := map:map()
        let $_ := map:put($model, '@object-escaped@', $@object-escaped@)
        let $_ := map:put($model, 'filter', $filter)
        let $_ := map:put($model, 'search', $search)
        return
            if (map:get($params, "responseFormat") eq "application/json") then
            (
                xqrails:layout
                (
                    'json', 
                    (
                        'body', xqrails:view('@object-escaped@/list.json', $model)
                    )
                )
            )
            else if (map:get($params, "responseFormat") eq "application/xml") then
            (
                xqrails:layout
                (
                    'xml', 
                    (
                        'body', xqrails:view('@object-escaped@/list.xml', $model)
                    )
                )
            )
            else
            (
                xqrails:layout
                (
                    'main', 
                    (
                        'browsertitle' ,'List @object-escaped@',
                        'breadcrumb', 'List @object-escaped@',
                        'body', xqrails:view('@object-escaped@/list.html', $model)
                    )
                )
            )
    } 
    catch ($e)
    {
        xdmp:log(fn:concat('CONTROLLER', xdmp:quote($e))) 
    }
};

(:~
 : the create action for the controller
 : 
 :)
declare function xqrails-controller:create()
{
    xqrails:layout
    (
        'main', 
        (
            'browsertitle' ,'New @object-escaped@',
            'breadcrumb', 'New @object-escaped@',
            'body', xqrails:view('@object-escaped@/create.html', ('@object-escaped@', @object-escaped@:new()))                
        )
    )
};

(:~
 : the save action for the controller
 : 
 :)
declare function xqrails-controller:save()
{
    let $params := xqrails:build-params-map()
    return save($params)
};

declare function xqrails-controller:save($params)
{
    let $@object-escaped@ := @object-escaped@:build($params)
    return
        if (map:get($params, "responseFormat") eq "application/json") then
        (
            (
            @object-escaped@:save($@object-escaped@),
            xqrails:layout
            (
                'json', 
                (
                    'body', xqrails:view('@object-escaped@/show.json', ('@object-escaped@', $@object-escaped@))
                )
            )
            )
        )
        else if (map:get($params, "responseFormat") eq "application/xml") then
        (
            (
            @object-escaped@:save($@object-escaped@),
            xqrails:layout
            (
                'xml', 
                (
                    'body', xqrails:view('@object-escaped@/show.xml', ('@object-escaped@', $@object-escaped@))
                )
            )
            )
        )
        else
        (
            (
            @object-escaped@:save($@object-escaped@),
            xdmp:redirect-response(fn:concat("/@object-escaped@/show/", @object-escaped@:id($@object-escaped@)))
            )
        )
        
};

(:~
 : the show action for the controller
 : 
 :)
declare function xqrails-controller:show()
{
    let $params := xqrails:build-params-map()
    return show($params)
};

declare function xqrails-controller:show($params as map:map)
{
    if (map:get($params, "id")) then
    (
        let $@object-escaped@ := @object-escaped@:find(map:get($params, "id"))
        return
            if ($@object-escaped@) then
            (
                if (map:get($params, "responseFormat") eq "application/json") then
                (
                    xqrails:layout
                    (
                        'json', 
                        (
                            'body', xqrails:view('@object-escaped@/show.json', ('@object-escaped@', $@object-escaped@))
                        )
                    )
                )
                else if (map:get($params, "responseFormat") eq "application/xml") then
                (
                    xqrails:layout
                    (
                        'xml', 
                        (
                            'body', xqrails:view('@object-escaped@/show.xml', ('@object-escaped@', $@object-escaped@))
                        )
                    )
                )
                else
                (
                    xqrails:layout
                    (
                        'main', 
                        (
                            'browsertitle', 'Show @object-escaped@',
                            'body', xqrails:view('@object-escaped@/show.html', ('@object-escaped@', $@object-escaped@))
                        )
                    )
                )
            )
            else
            (
                xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
            )
    )        
    else
        xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
};

(:~
 : the edit action for the controller
 : 
 :)
declare function xqrails-controller:edit()
{
    let $params := xqrails:build-params-map()
    return edit($params)
};

declare function xqrails-controller:edit($params as map:map)
{
    if (map:get($params, "id")) then
    (
        let $@object-escaped@ := @object-escaped@:find(map:get($params, "id"))
        return
            if ($@object-escaped@) then
            (
                xqrails:layout
                (
                    'main', 
                    (
                        'browsertitle', 'Show @object-escaped@',
                        'body', xqrails:view('@object-escaped@/edit.html', ('@object-escaped@', $@object-escaped@))
                    )
                )
            )
            else
            (
                xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
            )
    )        
    else
        xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
};

(:~
 : the update action for the controller
 : 
 :)
declare function xqrails-controller:update()
{
    let $params := xqrails:build-params-map()
    return update($params)
};

declare function xqrails-controller:update($params as map:map)
{
    if (map:get($params, "id")) then
    (
        let $@object-escaped@ := @object-escaped@:find(map:get($params, "id"))
        return
            if (fn:not($@object-escaped@)) then
            (
                xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
            )
            else
            (
                let $updated-@object-escaped@ :=  @object-escaped@:update($@object-escaped@, $params)
                return
                    if (map:get($params, "responseFormat") eq "application/json") then
                    (
                        (
                        @object-escaped@:save($updated-@object-escaped@),
                        xqrails:layout
                        (
                            'json', 
                            (
                                'body', xqrails:view('@object-escaped@/show.json', ('@object-escaped@', $@object-escaped@))
                            )
                        )
                        )
                    )
                    else if (map:get($params, "responseFormat") eq "application/xml") then
                    (
                        (
                        @object-escaped@:save($updated-@object-escaped@),
                        xqrails:layout
                        (
                            'xml', 
                            (
                                'body', xqrails:view('@object-escaped@/show.xml', ('@object-escaped@', $@object-escaped@))
                            )
                        )
                        )
                    )
                    else
                    (
                        (
                        @object-escaped@:save($updated-@object-escaped@),
                        xdmp:redirect-response(fn:concat("/@object-escaped@/show/", @object-escaped@:id($@object-escaped@)))
                        )
                    )
            )
    )
    else
        xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
};

(:~
 : the delete action for the controller
 : 
 :)
declare function xqrails-controller:delete()
{
    let $params := xqrails:build-params-map()
    return delete($params)
};  
 
declare function xqrails-controller:delete($params as map:map)
{
    if (map:get($params, "id")) then
    (
        (: TODO: update path to the document in the uri structure :)
        let $@object-escaped@ := @object-escaped@:find(map:get($params, "id"))
        return
            if ($@object-escaped@) then
            (
                if (map:get($params, "responseFormat") eq "application/json") then
                (
                    (
                    @object-escaped@:delete($@object-escaped@),
                    xqrails:http-204()
                    )
                )
                else if (map:get($params, "responseFormat") eq "application/xml") then
                (
                    (
                    @object-escaped@:delete($@object-escaped@),
                    xqrails:http-204()
                    )
                )
                else
                (
                    (
                    @object-escaped@:delete($@object-escaped@),
                    xdmp:redirect-response("/@object-escaped@")
                    )
                )
               
            )
            else
            (
                xqrails-controller:error(map:get($params, "responseFormat"), 404, 404, "Not Found")
            )
    )        
    else
        ()
};

(:~
 : the documentation action for the controller
 : 
 :)
declare function xqrails-controller:documentation()
{
    xqrails:layout
    (
        'main', 
        (
            'body', xqrails:view('@object-escaped@/documentation.html', ('object', @object-escaped@:new(), 'constraints', $@object-escaped@:@object-escaped@-constraints))
        )
    )
};

(:~
 : the error action for the controller
 : 
 :)
declare function xqrails-controller:error($responseFormat as xs:string, $statusCode as xs:integer, $errorCode as xs:integer, $errorDescription as xs:string)
{
    if ($responseFormat eq "application/json") then
    (
        xqrails:layout
        (
            'error', 
            (
                'responseFormat', $responseFormat,
                'statusCode', $statusCode,
                'error', xqrails:view('error/error.json', ('errorCode', $errorCode, 'errorDescription', $errorDescription))
            )
        )
    )
    else if ($responseFormat eq "application/xml") then
    (
        xqrails:layout
        (
            'error', 
            (
                'responseFormat', $responseFormat,
                'statusCode', $statusCode,
                'error', xqrails:view('error/error.xml', ('errorCode', $errorCode, 'errorDescription', $errorDescription))
            )
        )
    )
    else
    (
        xqrails:layout
        (
            'error', 
            (
                'responseFormat', $responseFormat,
                'browsertitle', 'Error',
                'statusCode', $statusCode,
                'error', xqrails:view('error/error.html', ('errorCode', $errorCode, 'errorDescription', $errorDescription))
            )
        )
    )
};         
