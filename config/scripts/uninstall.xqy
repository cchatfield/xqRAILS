xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $router external;  
declare variable $source external;
declare variable $httpPort external;  
declare variable $xdbcPort external;  
declare variable $name external;  



(: application server :)

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $server := 
    if (admin:appserver-exists($config, $groupid, fn:concat($httpPort, "-", $name, "-http"))) then
    (
        let $server := admin:appserver-delete($config, admin:appserver-get-id($config, $groupid, fn:concat($httpPort, "-", $name, "-http")))
        return admin:save-configuration($server)
    )
    else ()

(: xdbc server :)

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $server := 
    if (admin:appserver-exists($config, $groupid, fn:concat($xdbcPort, "-", $name, "-xdbc"))) then
    (
        let $server := admin:appserver-delete($config, admin:appserver-get-id($config, $groupid, fn:concat($xdbcPort, "-", $name, "-xdbc")))
        return admin:save-configuration($server)
    )
    else ()

(: database :)

let $config := admin:get-configuration()
let $_ := 
    if (admin:database-exists($config, $name)) then
    (
        let $config := admin:database-delete($config, admin:database-get-id($config, $name))
        return admin:save-configuration($config)
    )
    else ()

(: forest :)

let $config := admin:get-configuration()
let $_ := 
    if (admin:forest-exists($config, $name)) then
    (
        let $config := admin:forest-delete($config, xdmp:forest($name), fn:true())
        return admin:save-configuration($config)
    )
    else ()


return fn:concat("Application uninstall complete")

