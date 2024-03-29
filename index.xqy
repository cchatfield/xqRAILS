xquery version "1.0-ml";

(:
 :
 : xqrails entry point
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

let $controller := xqrails:controller()
let $action := xqrails:action()
let $log := xdmp:log(fn:concat("Requested Resource [", xdmp:get-request-url() , "]"))
return
    xqrails:route($controller, $action)
