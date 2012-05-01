xquery version "1.0-ml";

import module namespace sec = "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare variable $name external;  

(: security anon role:)
let $role := "security-anon"

let $role-exists :=
    let $evalStatement :=
        fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:role-exists("', $role, '")')
    return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)

let $_ := 
    if (fn:not($role-exists)) then
    (
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:create-role("', $role, '", "Base security role in xqrails", ("dls-user"), (), ())')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
    )
    else ()
    
(: security user role:)
let $role := "security-user"

let $role-exists :=
    let $evalStatement :=
        fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:role-exists("', $role, '")')
    return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)

let $_ := 
    if (fn:not($role-exists)) then
    (
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:create-role("', $role, '", "Base security role in xqrails", ("security-anon", "pipeline-execution"), (), ())')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
    )
    else ()
    
(: security admin role:)
let $role := "security-admin"

let $role-exists :=
    let $evalStatement :=
        fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:role-exists("', $role, '")')
    return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)

let $_ := 
    if (fn:not($role-exists)) then
    (
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:create-role("', $role, '", "Base security role in xqrails", ("dls-admin", "security", "security-user"), (), ())')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
    )
    else ()
    
(: security anon user :)
let $user := "security-anon"

let $user-exists :=
    let $evalStatement :=
        fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:user-exists("', $user, '")')
    return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)


let $_ := 
    if (fn:not($user-exists)) then
    (
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:create-user("', $user, '", "Base security user in xqrails", "234adfkj4rqerf", ("', $role, '"), (), ())')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
    )
    else ()    

(: security anon role:)
let $role := "security-anon"
   
(: set security privileges  :)
let $xqrailsPrivilege := fn:concat("http://", $name, "/xdmp/privileges/[***]")

let $privilege-exists :=
    let $evalStatement :=
        fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:privilege-exists("', $xqrailsPrivilege, '", "execute")')
    return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
let $_ :=
    if (fn:not($privilege-exists)) then
    (
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:create-privilege("', fn:concat($name, ":all"), '", "',  $xqrailsPrivilege, '", "execute", ("' ,$role, '"))')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
    )
    else 
    (
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:privilege-add-roles("', $xqrailsPrivilege, '", "execute", ("', $role, '"))')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
    )


let $privileges :=
    ("http://marklogic.com/xdmp/privileges/xdmp-invoke",
         "http://marklogic.com/xdmp/privileges/xdmp-eval",
         "http://marklogic.com/xdmp/privileges/xdmp-login",
         "http://marklogic.com/xdmp/privileges/xdmp-eval-in",
         "http://marklogic.com/xdmp/privileges/xdmp-value",
         "http://marklogic.com/xdmp/privileges/xdmp-filesystem-directory",
         "http://marklogic.com/xdmp/privileges/any-uri",     
         "http://marklogic.com/xdmp/privileges/any-collection",
         "http://marklogic.com/xdmp/privileges/admin-module-read")
let $_ :=
    for $privilege in $privileges
    return
        let $evalStatement :=
            fn:concat('xquery version "1.0-ml";import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; sec:privilege-add-roles("', $privilege, '", "execute", ("', $role, '"))')
        return xdmp:eval($evalStatement, (), <options xmlns="xdmp:eval"><database>{xdmp:security-database()}</database></options>)
        

return fn:concat("Security setup completed for xqrails base security configuration - role-exists [", $role-exists, "]")

