xquery version "1.0-ml";

(:
 :
 : Application config file
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

(:~
 : Application-level configuration.
 :)
module namespace xqrails-conf = "http://avalonconsult.com/xqrails/core/config";

(:
 : Absolute path of this web application within the App-Server, WITHOUT
 : trailing slash.  If it's in the root of the App Server, LEAVE BLANK.
 : 
 : eg: This web app is in a subdir named 'webapp' of the App-Server: '/webapp'
 : eg: This web app is in the root of the App-Server (leave blank):  ''
 :)
declare variable $app-root as xs:string := '';

(:
 : Application Name
 :)
declare variable $app-name as xs:string := 'xqrails';


(:
 : Enables/disables debug output.  This will affect performance of the
 : application and should be off in production environments.
 :)
declare variable $debug as xs:boolean := fn:true();

(:
 : If URL Rewriting is on, you may optionally allow all your urls to contain a 
 : suffix, such as "http://host.com/webapp/controller/function.html".  Leave 
 : blank for no suffix.
 :)
declare variable $url-suffix as xs:string := '';

(:
 : Default controller path, if none specified.
 :)
declare variable $default-controller-path as xs:string := 'xqrails-app/controllers/default.xqy';
(:
 : Default controller to load, if none specified.
 :)
declare variable $default-controller as xs:string := 'default';

(:
 : Default plugin to load, needed if default controller is not in main application.
 :)
declare variable $default-action as xs:string := 'index';

(:
 : Default plugin to load, needed if default controller is not in main application.
 :)
declare variable $use-default-controller-on-fail as xs:boolean := fn:false();

(:
 : Field name to use in the querystring when specifying which Controller to 
 : load.
 :)
declare variable $controller-querystring-field as xs:string := '_c';

(:
 : Field name to use in the querystring when specifying which Function to 
 : execute.
 :)
declare variable $action-querystring-field as xs:string := '_a';

(:
 : Field name to use in the querystring when specifying which Plugin to 
 : use.  If omitted in the querystring, no plugin is used.
 :)
declare variable $id-querystring-field as xs:string := '_i';


declare variable $uuid-format as xs:string := "[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}";

declare variable $params-url-delimeter as xs:string := "/q/";

