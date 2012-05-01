xquery version "1.0-ml";
(:
 :
 : router for url rewriting
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
import module namespace xqrails-conf = "http://avalonconsult.com/xqrails/core/config" at "/xqrails-app/conf/config.xqy";

let $url := xqrails:clean-url(xdmp:get-request-url())
let $log := xdmp:log(fn:concat("incoming start url [", $url, "]"))

let $method :=
    if (fn:contains($url, "method=")) then
    (
        fn:concat("&amp;responseFormat=", xqrails:get-response-format())
    )
    else
    (
        fn:concat("&amp;method=", xqrails:get-request-method(), "&amp;responseFormat=", xqrails:get-response-format())
    )
            

(: check first if there is a url mapping override :)
let $url-mapping := xqrails:calculate-url-mapping($url, xqrails:get-request-method())
return
    (: check for url mapping :)
    if ($url-mapping ne "") then
    (
       $url-mapping
    )
    else
    (
        (: check url for resources and route direct :)
        if (matches($url, concat("^/resources")) or matches($url, concat("^/favicon.ico"))) then
        (
            $url
        )
        (: check if root request and then route to default :)
        else if ($url eq "/" or $url eq "") then
        (
            let $returnVal :=
                fn:concat($xqrails-conf:app-root, "/?",
                    $xqrails-conf:controller-querystring-field,
                    "=",
                    $xqrails-conf:default-controller,
                    "&amp;",
                    $xqrails-conf:action-querystring-field,
                    "=",
                    $xqrails-conf:default-action,
                    $method
                    )
             return $returnVal
        )
        else    
        (
            let $suffix := replace($xqrails-conf:url-suffix, '\.', '\\.')
            (: /controller :)
            let $controller-pattern := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)", $suffix, "((\?)(.*))?$")
            let $controller-pattern-with-id := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/(", $xqrails-conf:uuid-format , ")((\?)(.*))?$")
            let $controller-pattern-with-numeric-id := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/(\d+)((\?)(.*))?$")
            let $controller-pattern-with-params := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)", $xqrails-conf:params-url-delimeter , "([\w\.-/,:]+)((\?)(.*))?$")
            let $controller-pattern-with-id-and-params := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/(", $xqrails-conf:uuid-format, ")", $xqrails-conf:params-url-delimeter , "([\w\.-/,:]+)((\?)(.*))?$")
            let $controller-pattern-with-numeric-id-and-params := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/(\d+)", $xqrails-conf:params-url-delimeter , "([\w\.-/,:]+)((\?)(.*))?$")
            
            (: /controller/action :)
            let $standard-pattern := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/([\w\.-]*)", $suffix, "((\?)(.*))?$")
            let $standard-pattern-with-id := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/([\w\.-]*)/(", $xqrails-conf:uuid-format , ")((\?)(.*))?$")
            let $standard-pattern-with-numeric-id := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/([\w\.-]*)/(\d+)((\?)(.*))?$")
            let $standard-pattern-with-params := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/([\w\.-]*)", $xqrails-conf:params-url-delimeter , "([\w\.-/,:]+)((\?)(.*))?$")
            let $standard-pattern-with-id-and-params := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/([\w\.-]*)/(", $xqrails-conf:uuid-format, ")", $xqrails-conf:params-url-delimeter , "([\w\.-/,:]+)((\?)(.*))?$")
            let $standard-pattern-with-numeric-id-and-params := concat("^", $xqrails-conf:app-root, "/([\w\.-]+)/([\w\.-]*)/(\d+)", $xqrails-conf:params-url-delimeter , "([\w\.-/,:]+)((\?)(.*))?$")
            
            return
                if (matches($url, $controller-pattern)) then
                (
                    let $from := $controller-pattern
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=", $xqrails-conf:default-action, "&amp;",
                        "$4",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                ) 
                else if (matches($url, $controller-pattern-with-id) or matches($url, $controller-pattern-with-numeric-id)) then
                (
                    let $from := 
                        if (matches($url, $controller-pattern-with-id)) then
                            $controller-pattern-with-id
                        else    
                            $controller-pattern-with-numeric-id
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=", $xqrails-conf:default-action, "&amp;",
                        $xqrails-conf:id-querystring-field,
                        "=$2&amp;",
                        "$5",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                )    
                else if (matches($url, $controller-pattern-with-id-and-params) or matches($url, $controller-pattern-with-numeric-id-and-params)) then
                (
                    let $from := 
                        if (matches($url, $controller-pattern-with-id-and-params)) then
                            $controller-pattern-with-id-and-params
                        else    
                            $controller-pattern-with-numeric-id-and-params
                    let $splitParams := fn:tokenize(fn:tokenize($url, $xqrails-conf:params-url-delimeter)[fn:last()], "?")[1]
                    let $paramsString := 
                        for $item at $i in fn:tokenize($splitParams, "/")
                        return 
                            if($item and $i mod 2 = 1) 
                            then 
                                (
                                fn:concat("&amp;", $splitParams [$i], "=", $splitParams [$i + 1])
                                ) 
                            else ()
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=", $xqrails-conf:default-action, "&amp;",
                        $xqrails-conf:id-querystring-field,
                        "=$2",
                        $paramsString,
                        "$6",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                )
                else if (matches($url, $controller-pattern-with-params)) then
                (
                    let $from := $controller-pattern-with-params
                    let $splitParams := fn:tokenize(fn:tokenize($url, $xqrails-conf:params-url-delimeter)[fn:last()], "?")[1]
                    let $paramsString := 
                        for $item at $i in fn:tokenize($splitParams, "/")
                        return 
                            if($item and $i mod 2 = 1) 
                            then 
                                (
                                fn:concat("&amp;", $splitParams [$i], "=", $splitParams [$i + 1])
                                ) 
                            else ()
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=", $xqrails-conf:default-action, "&amp;",
                        $paramsString,
                        "$5",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                )
                else if (matches($url, $standard-pattern)) then
                (
                    let $from := $standard-pattern
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=$2&amp;",
                        "$5",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                ) 
                else if (matches($url, $standard-pattern-with-id) or matches($url, $standard-pattern-with-numeric-id)) then
                (
                    let $from := 
                        if (matches($url, $standard-pattern-with-id)) then
                            $standard-pattern-with-id
                        else    
                            $standard-pattern-with-numeric-id
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=$2&amp;",
                        $xqrails-conf:id-querystring-field,
                        "=$3&amp;",
                        "$6",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                )    
                else if (matches($url, $standard-pattern-with-id-and-params) or matches($url, $standard-pattern-with-numeric-id-and-params)) then
                (
                    let $from := 
                        if (matches($url, $standard-pattern-with-id-and-params)) then
                            $standard-pattern-with-id-and-params
                        else    
                            $standard-pattern-with-numeric-id-and-params
                    let $splitParams := fn:tokenize(fn:tokenize($url, $xqrails-conf:params-url-delimeter)[fn:last()], "?")[1]
                    let $paramsString := 
                        for $item at $i in fn:tokenize($splitParams, "/")
                        return 
                            if($item and $i mod 2 = 1) 
                            then 
                                (
                                fn:concat("&amp;", $splitParams [$i], "=", $splitParams [$i + 1])
                                ) 
                            else ()
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=$2&amp;",
                        $xqrails-conf:id-querystring-field,
                        "=$3",
                        $paramsString,
                        "$7",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                )
                else if (matches($url, $standard-pattern-with-params)) then
                (
                    let $from := $standard-pattern-with-params
                    let $splitParams := fn:tokenize(fn:tokenize($url, $xqrails-conf:params-url-delimeter)[fn:last()], "?")[1]
                    let $paramsString := 
                        for $item at $i in fn:tokenize($splitParams, "/")
                        return 
                            if($item and $i mod 2 = 1) 
                            then 
                                (
                                fn:concat("&amp;", $splitParams [$i], "=", $splitParams [$i + 1])
                                ) 
                            else ()
                    let $to := concat($xqrails-conf:app-root,
                        "/?",
                        $xqrails-conf:controller-querystring-field,
                        "=$1&amp;",
                        $xqrails-conf:action-querystring-field,
                        "=$2",
                        $paramsString,
                        "$6",
                        $method)
                    let $new := replace($url, $from, $to)
                    return
                        $new
                )
                else
                (    
                    (: pattern not matched - return 404 :)
                    ("")
                )
            )
        )
 