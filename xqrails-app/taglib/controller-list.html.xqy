xquery version "1.0-ml";

(:
 :
 : controller list taglib
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

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";
 
let $base-dir :=
    let $config := admin:get-configuration()
    let $groupid := admin:group-get-id($config, "Default")
    return admin:appserver-get-root($config, admin:appserver-get-id($config, $groupid, admin:appserver-get-name($config, xdmp:server())))
        
let $controllers := 
    for $dir in xdmp:filesystem-directory(fn:concat($base-dir, "/xqrails-app/controllers"))/dir:entry/dir:filename/text()
    return
        if ($dir ne ".DS_Store" and $dir ne ".svn") 
        then 
            (
            fn:replace($dir, "\.xqy", "")
            )
        else ()
return
    <div style="width:25%;float:left;">
        <div class="buttons">
            Available Controllers and Documentation
        </div>
        <br/>
        {
        for $controller in $controllers
        let $_ := xdmp:log($controller)
        return 
            if ($controller ne "default") then
            (
                (<button style="width:75%;float:left;clear:left;" class="controller" onclick="location.href='/{$controller}';">{util:fix-camel-case-to-string($controller)}</button>,<button style="width:70px;margin-left:10px;float:left;" class="documentation" onclick="location.href='/{$controller}/documentation';">Docs</button>,<br clear="all" />)
            )
            else
                ()
        }
    </div>
        
        
