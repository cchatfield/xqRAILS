xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $router external;
declare variable $error external;  
declare variable $source external;
declare variable $port external;  
declare variable $name external;  


(: forest :)

let $config := admin:get-configuration()
let $_ := 
    if (fn:not(admin:forest-exists($config, $name))) then
    (
        let $config := admin:forest-create($config, $name, xdmp:host(), ())
        return admin:save-configuration($config)
    )
    else ()

(: database :)

let $config := admin:get-configuration()
let $_ := 
    if (fn:not(admin:database-exists($config, $name))) then
    (
        let $config := admin:database-create($config, $name, xdmp:database("Security"), xdmp:database("Schemas"))
        let $_ := admin:save-configuration($config)
        let $config :=  admin:database-attach-forest($config, xdmp:database($name), xdmp:forest($name))
        return admin:save-configuration($config)
    )
    else ()

(: application server :)

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $server := 
    if (fn:not(admin:appserver-exists($config, $groupid, fn:concat($port, "-", $name, "-http")))) then
    (
        let $server := admin:http-server-create($config, $groupid, fn:concat($port, "-", $name, "-http"), $source, xs:integer($port), 0, admin:database-get-id($config, $name))
        return admin:save-configuration($server)
    )
    else ()

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $config := admin:appserver-set-url-rewriter($config, admin:appserver-get-id($config, $groupid, fn:concat($port, "-", $name, "-http")), $router)
let $config := admin:appserver-set-error-handler($config, admin:appserver-get-id($config, $groupid, fn:concat($port, "-", $name, "-http")), $error)
let $config := admin:database-set-triggers-database($config, xdmp:database($name), xdmp:database("Triggers"))  
(: set base database configuration parameters :)
let $config := admin:database-set-uri-lexicon($config, xdmp:database($name), fn:true())
let $config := admin:database-set-collection-lexicon($config, xdmp:database($name), fn:true())
let $config := admin:database-set-trailing-wildcard-searches($config, xdmp:database($name), fn:true())
let $_ :=  admin:save-configuration($config)

return fn:concat("Application install complete at localhost:" , $port)

