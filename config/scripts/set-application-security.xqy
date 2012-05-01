xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $port external;  
declare variable $name external;  

(: security :)

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $config := admin:appserver-set-authentication($config, admin:appserver-get-id($config, $groupid, fn:concat($port, "-", $name, "-http")), "application-level")
let $_ :=  admin:save-configuration($config)
let $config := admin:appserver-set-default-user($config, admin:appserver-get-id($config, $groupid, fn:concat($port, "-", $name, "-http")),
                                                                     xdmp:eval('
                                                                                  xquery version "1.0-ml";
                                                                                  import module "http://marklogic.com/xdmp/security" 
                                                                            at "/MarkLogic/security.xqy"; 
                                                                              sec:uid-for-name("security-anon")', (),  
                                                                       <options xmlns="xdmp:eval">
                                                                         <database>{xdmp:security-database()}</database>
                                                                       </options>))
let $_ :=  admin:save-configuration($config)

return fn:concat("Application configured for application level security")

