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

declare variable $error:errors as node()* external;

let $error:errors :=
    if ($error:errors)  then $error:errors else <errors/>
let $model := map:map()
let $_ := map:put($model,"errorCode", xdmp:get-response-code())
let $_ := map:put($model,"errorDescription", $error:errors)
let $_ := xdmp:log(fn:concat("********************* error boi! " ,  xdmp:get-response-code()[1]))

return
    if ($error:errors/error:code/text() eq "SVC-FILOPN") then
    (
        let $_ := map:put($model,"errorCode", 404)
        let $_ := map:put($model,"errorDescription", "File Not Found")
        let $_ := xdmp:log(fn:concat("********************* missing file! " ,  xdmp:get-response-code()[1]))
        return
            xqrails:layout
                (
                    'error', 
                    (
                        'responseFormat', 'text/html',
                        'message', if ($error:errors)  then $error:errors else <errors/>,
                        'statusCode', 404,
                        'body', xqrails:view('error/error.html', $model)
                    )
                ) 
    )
    else
    (
        xqrails:layout
                (
                    'error', 
                    (
                        'responseFormat', 'text/html',
                        'message', if ($error:errors)  then $error:errors else <errors/>,
                        'statusCode', xdmp:get-response-code(),
                        'body', xqrails:view('error/error.html', $model)
                    )
                ) 
    )

