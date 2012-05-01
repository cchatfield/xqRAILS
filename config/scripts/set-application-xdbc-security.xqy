xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $port external;  
declare variable $name external;  

(: security :)

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $config := admin:appserver-set-authentication($config, admin:appserver-get-id($config, $groupid, fn:concat($port, "-", $name, "-xdbc")), "basic")
let $_ :=  admin:save-configuration($config)

return fn:concat("Application xdbc configured for application level security")

