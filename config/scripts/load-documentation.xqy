xquery version "1.0-ml";

(:
 :
 : controller documentation action list taglib
 :
 :
 :)

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";
 
let $base-dir :=
    let $config := admin:get-configuration()
    let $groupid := admin:group-get-id($config, "Default")
    return admin:appserver-get-root($config, admin:appserver-get-id($config, $groupid, admin:appserver-get-name($config, xdmp:server())))
        
for $dir in xdmp:filesystem-directory(fn:concat($base-dir, "/xqrails-app/docs"))/dir:entry/dir:filename/text()
return
    if ($dir ne ".DS_Store" and $dir ne ".svn") 
    then 
    (
        let $options :=
            <options xmlns="xdmp:document-load">
               <uri>/xqrails/documentation/{$dir}</uri>
               <permissions>{xdmp:permission("security-user", "read"), xdmp:permission("security-user", "execute"),
        xdmp:permission("security-user", "update"), xdmp:permission("security-user", "insert"),
        xdmp:permission("security-admin", "read"), xdmp:permission("security-admin", "execute"),
        xdmp:permission("security-admin", "update"), xdmp:permission("security-admin", "insert"),
        xdmp:permission("security-anon", "read"), xdmp:permission("security-anon", "update"),
        xdmp:default-permissions()}</permissions> 
            </options>
        return xdmp:document-load(fn:concat($base-dir, "/xqrails-app/docs/", $dir), $options)
    )
    else ()