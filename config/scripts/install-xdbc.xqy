xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $source external;
declare variable $port external;  
declare variable $name external;  


(: xdbc server :)

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $server := 
    if (fn:not(admin:appserver-exists($config, $groupid, fn:concat($port, "-", $name, "-xdbc")))) then
    (
        let $server := admin:xdbc-server-create($config, $groupid, fn:concat($port, "-", $name, "-xdbc"), $source, xs:integer($port), 0, admin:database-get-id($config, $name))
        return admin:save-configuration($server)
    )
    else ()

return fn:concat("Application xdbc install complete at localhost:" , $port)

