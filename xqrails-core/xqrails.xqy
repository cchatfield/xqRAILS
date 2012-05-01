xquery version "1.0-ml";

(:
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
 
module namespace xqrails = "http://avalonconsult.com/xqrails/core";

import module namespace xqrails-conf = "http://avalonconsult.com/xqrails/core/config" at "/xqrails-app/conf/config.xqy";

declare variable $controller-dir as xs:string := fn:concat($xqrails-conf:app-root, '/xqrails-app/controllers');
declare variable $view-dir as xs:string := fn:concat($xqrails-conf:app-root, '/xqrails-app/views');
declare variable $layout-dir as xs:string := fn:concat($xqrails-conf:app-root, '/xqrails-app/views/layouts');
declare variable $taglib-dir as xs:string := fn:concat($xqrails-conf:app-root, '/xqrails-app/taglib');
declare variable $resource-dir as xs:string := fn:concat($xqrails-conf:app-root, '/resources');

declare variable $doctype-html-4.01-strict :=       '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">';
declare variable $doctype-html-4.01-transitional := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">';
declare variable $doctype-html-4.01-frameset :=     '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">';
declare variable $doctype-xhtml-1.0-strict :=       '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">';
declare variable $doctype-xhtml-1.0-transitional := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
declare variable $doctype-xhtml-1.0-frameset :=     '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">';
declare variable $doctype-xhtml-1.1 :=              '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">';

(:~
 : function takes incoming routing requests and returns the calculated output through and eval of the controller
 : in the case of options requests, they are routed back immediately with a 204
 :
 : @param $controller - controller 
 : @param $action - action
 : @return rendered output of controller and action request
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function route($controller as xs:string, $action as xs:string) as item()*
{
    let $controller-file := fn:concat($controller-dir, '/', $controller, '.xqy')
    return
        if (fn:lower-case(xdmp:get-request-method()) eq "options") then
        (
            http-204()
        )
        else if (_isAuthorized($controller, $action, xdmp:get-request-field("method"))) then 
        (
            let $import-declaration := fn:concat('import module namespace xqrails-controller = "http://avalonconsult.com/xqrails/controller" at "', $controller-file, '";')
            let $action-call := fn:concat('xqrails-controller:', $action, '()')
            return
                xdmp:eval(fn:concat($import-declaration, $action-call),
                    (),
                    <options xmlns="xdmp:eval">
                        <isolation>different-transaction</isolation>
                        <prevent-deadlocks>true</prevent-deadlocks>
                    </options>
                )
        )
        else 
        (
            not-authorized()
        )
};

(:~
 : private function takes incoming file and params and renders a partial output
 :
 : @param $file - the file to execute 
 : @param $pairs - the params to evaluate in the file
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare private function partial-render($file as xs:string, $pairs as item()*) as item()*
{
    xdmp:invoke
    (
        $file,
        (xs:QName("model"), sequence-to-map($pairs)),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
            <prevent-deadlocks>true</prevent-deadlocks>
        </options>
    )
};

(:~
 : function takes incoming view file and params and calls partial-render
 :
 : @param $file - the file to execute 
 : @param $pairs - the params to evaluate in the file
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function view($view as xs:string, $pairs as item()*) as item()*
{
    partial-render(fn:concat($view-dir, '/', $view, '.xqy'), $pairs)
};

(:~
 : function takes incoming view file and calls partial render without params
 :
 : @param $file - the file to execute 
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function view($view as xs:string) as item()*
{
    view($view, ())
};

(:~
 : function takes incoming layout file and params and calls partial-render
 :
 : @param $file - the file to execute 
 : @param $pairs - the params to evaluate in the file
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function layout($layout as xs:string, $pairs as item()*) as item()*
{
    partial-render(fn:concat($layout-dir, '/', $layout, '.xqy'), $pairs)
};

(:~
 : function takes incoming layout file and calls partial render without params
 :
 : @param $file - the file to execute 
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function layout($layout as xs:string) as item()*
{
    layout($layout, ())
};

(:~
 : function takes incoming taglib file and params and calls partial-render
 :
 : @param $file - the file to execute 
 : @param $pairs - the params to evaluate in the file
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function taglib($taglib as xs:string, $pairs as item()*) as item()*
{
    partial-render(fn:concat($taglib-dir, '/', $taglib, '.xqy'), $pairs)
};

(:~
 : function takes incoming taglib file and calls partial render without params
 :
 : @param $file - the file to execute 
 : @return rendered partial output 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function taglib($taglib as xs:string) as item()*
{
    taglib($taglib, ())
};

(:~
 : function determines the controller from the params
 :
 : @return controller string 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function controller() as xs:string
{
    xdmp:get-request-field($xqrails-conf:controller-querystring-field, $xqrails-conf:default-controller)
};

(:~
 : function determines the action from the params and defaults to index if none exists
 :
 : @return action string 
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function action() as xs:string
{
    xdmp:get-request-field($xqrails-conf:action-querystring-field, 'index')
};

(:~
 : function converts sequences to maps and if a map is passed it will pass through
 :
 : @param $pairs sequence of items or map
 : @return map
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function sequence-to-map($pairs as item()*) as map:map
{
    if ($pairs instance of map:map) then
    (
        $pairs
    )
    else
    (
        let $map := map:map()
        let $put :=
            for $i in (1 to fn:count($pairs))[. mod 2 ne 0]
                return map:put($map, $pairs[$i], $pairs[$i+1])
        return $map
    )
};

(:~
 : function takes incoming parameters in post or querystring and converts to a map
 :
 : @return map
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function build-params-map() as map:map
{
    let $map := map:map()
    let $params :=
        for $name in xdmp:get-request-field-names()
        (: remove potential underscores for jquery escaped namespaces :)
        return 
            if ($name eq $xqrails-conf:id-querystring-field) then
                map:put($map, "id", xdmp:get-request-field(fn:string($name)))
            else
                map:put($map, fn:replace($name, "_", ":"), xdmp:get-request-field(fn:string($name)))
    return $map
           
};

(:~
 : function gets the incoming accept header and determines the appropriate response format
 :
 : @return response format string
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function get-response-format()
{
    let $accept := 
        if (xdmp:get-request-field("responseFormat")) then
            xdmp:get-request-field("responseFormat")
        else
            fn:tokenize(xdmp:get-request-header("Accept"), ",")[1]
    return 
        if ($accept)
        then
            (
            $accept
            )
        else
            (
            "text/html"
            )
};

(:~
 : function gets the incoming method and overrides if passed as param
 :
 : @return http method string
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function get-request-method() as xs:string
{
    if (xdmp:get-request-field("method", "") ne "") then
        fn:lower-case(xdmp:get-request-field("method"))
    else    
        fn:lower-case(xdmp:get-request-method())
};
   
(:~
 : function converts mapping format to param names
 :
 : @param $url incoming mapping url
 : @return sequence of params
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)   
declare function convert-url-to-param-names($url as xs:string) as item()*
{
    for $part in fn:tokenize($url ,"/")
    return
        if (fn:matches($part, "^\$")) then
        (
            fn:replace($part, "\$", "")
        )
        else ()
};

(:~
 : function converts mapping url to regex
 :
 : @param $url 
 : @return regex
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function convert-url-to-regexes($url as xs:string) as xs:string*
{
    let $parts :=
        for $part in fn:tokenize($url ,"/")
        return
            if (fn:matches($part, "^\$")) then
            (
                "([\w\-\.:'_]+)"
            )
            else 
            (
                $part
            )
    return 
        (
        fn:concat("^", fn:string-join($parts, "/"), "$"), 
        fn:concat("^", fn:string-join($parts, "/"), "/params(.*)$") 
        )
};

(:~
 : function takes and incoming url and determines if it matches a url mapping and then presents the parameterized routed url
 :
 : @param $url incoming url
 : @param $httpMethod the incoming method
 : @return map
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function calculate-url-mapping($url as xs:string, $httpMethod as xs:string) as xs:string
{   
    let $urlParts := fn:tokenize($url, "\?")
    let $found := fn:false()
    let $mapping := 
        for $item in /mappings//mapping
        where ($found eq fn:false())
        return
            let $regex := convert-url-to-regexes($item/url/fn:string())
            return 
                if (fn:matches($urlParts[1], $regex[1]) or fn:matches($urlParts[1], $regex[2])) then
                    (xdmp:set($found, fn:true()), $item)
                else ()
    return
        if ($mapping) then (
            let $replaceString := 
                for $param at $i in convert-url-to-param-names($mapping/url/fn:string())
                return
                    fn:concat("&amp;", $param, "=$", $i)
            let $regex := convert-url-to-regexes($mapping/url/fn:string())
            (: look for url with /params/ in url to specify additional params :)
            let $parts := fn:tokenize($urlParts[1], "/params/")
            let $queryString := fn:replace($parts[1], $regex, fn:string-join($replaceString, ""))[1]
            let $queryString :=
                if ($urlParts[2]) then
                (
                    fn:concat($queryString, "&amp;", $urlParts[2])
                )
                else
                (
                    $queryString
                )
            let $queryString :=
                if ($parts[2]) then
                (
                    let $splitParams := fn:tokenize($parts[2], "/")
                    let $paramsString := 
                        for $item at $i in fn:tokenize($splitParams, "/")
                        return 
                            if($item and $i mod 2 = 1) 
                            then 
                                (
                                fn:concat("&amp;", $splitParams [$i], "=", $splitParams [$i + 1])
                                ) 
                            else ()
                    return fn:concat($queryString, $paramsString)
                )
                else
                (
                    $queryString
                )
            let $queryString :=
                if (fn:contains($queryString, "method=")) then
                (
                    $queryString
                )
                else
                (
                    
                    fn:concat($queryString, "&amp;method=", $httpMethod)
                )
            let $controller := 
                if ($mapping/controller/fn:string()) then
                (
                    $mapping/controller/fn:string()
                )
                else
                (
                    $xqrails-conf:default-controller
                )
            let $action := 
                if ($mapping/action/fn:string()) then
                (
                    $mapping/action/fn:string()
                )
                else
                (
                    $xqrails-conf:default-action
                )
            return 
                fn:concat($xqrails-conf:app-root,
                    "/?",
                    $xqrails-conf:controller-querystring-field,
                    "=",
                    $controller,
                    "&amp;",
                    $xqrails-conf:action-querystring-field,
                    "=",
                    $action,
                    $queryString
                    )
                
        )
        else 
        ( 
            "" 
        )    
};

(:~
 : function calculates if the request is authorized
 :
 : @param $controller controller
 : @param $action action
 : @param $method http method
 : @return boolean
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare private function _isAuthorized($controller, $action, $method) as xs:boolean
{
    let $privileges := (fn:concat("http://", $xqrails-conf:app-name, "/xdmp/privileges/", "[", fn:lower-case($method), "]", $controller, "/", $action), fn:concat("http://", $xqrails-conf:app-name, "/xdmp/privileges/[*]", $controller, "/", $action),fn:concat("http://", $xqrails-conf:app-name, "/xdmp/privileges/[**]", $controller),fn:concat("http://", $xqrails-conf:app-name, "/xdmp/privileges/[***]"))
    let $authorized := fn:false()
    
    let $check :=
        for $privilege in $privileges
        where ($authorized eq fn:false())
        return
            try{
                xdmp:set($authorized, xdmp:has-privilege($privilege, "execute"))
            } catch ($e) { () }    
    return
        $authorized
};

(:~
 : function cleans an incoming url of extra chars
 :
 : @param $url incoming url
 : @return map
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function clean-url($url as xs:string) as xs:string
{
    if (fn:ends-with($url, "/")) then
    (
        fn:substring($url, 1, fn:string-length($url) - 1)
    )
    else if (fn:contains($url, "/?")) then
    (
        fn:replace($url, "/\?", "?")
    )
    else $url
};

(:~
 : generic not authorized response builder
 :
 : @return not authorized
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function not-authorized()
{
    (
        xdmp:set-response-code(401,"Not Authorized"),
        xqrails:set-headers(),
        xdmp:set-response-content-type("text/html"),
        <html><head><title>Not Authorized</title></head><body>401 Not Authorized</body></html>
    ) 
};

(:~
 : generic not allowed response builder
 :
 : @return not allowed
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function not-allowed()
{
    not-allowed("")
};

(:~
 : generic not allowed response builder
 
 : @param extra information for not allowed
 : @return not authorized
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function not-allowed($more as xs:string)
{
    (
        xdmp:set-response-code(405,"Not Allowed"),
        xqrails:set-headers(),
        xdmp:set-response-content-type("text/html"),
        <html><head><title>Not Allowed</title></head><body><h1>405 Not Allowed</h1><div>{xdmp:unquote($more)}</div></body></html>
    ) 
};

(:~
 : generic not found response builder
 :
 : @return not authorized
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function not-found()
{
    (
        xdmp:set-response-code(404,"Not Allowed"),
        xqrails:set-headers(),
        xdmp:set-response-content-type("text/html"),
        <html><head><title>Not Found</title></head><body>404 Not Found</body></html>
    ) 
};

(:~
 : generic 202 response builder
 :
 : @return 202
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function http-202()
{
    (
        xdmp:set-response-code(202,""),
        xqrails:set-headers()
    ) 
};

(:~
 : generic 204 response builder
 :
 : @return 204
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function http-204()
{
    (
        xdmp:set-response-code(204,""),
        xqrails:set-headers()
    ) 
};

(:~
 : adds additional headers to all responses
 :
 : @return headers
 : @author Chad Chatfield 
 : @since 1.0
 : 
 :)
declare function set-headers()
{
    (
        xdmp:add-response-header("Access-Control-Allow-Origin", "*"),
        xdmp:add-response-header("Access-Control-Allow-Methods", "*")
    ) 
};