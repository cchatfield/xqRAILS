xquery version "1.0-ml";
(:
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

declare variable $model as map:map external;

xdmp:set-response-content-type('text/html'),
$xqrails:doctype-xhtml-1.1,
<html>
    <head>
        <title>xqRAILS | { map:get($model, 'browsertitle') }</title>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/themes/smoothness/jquery-ui-1.8.16.custom.css"/>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/third-party/slick/slick.grid.css"/>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/third-party/uni-form/uni-form.css" />
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/third-party/uni-form/default.uni-form.css"/>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/third-party/codemirror/codemirror.css"/>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/third-party/codemirror/docs.css"/>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/third-party/codemirror/default.css"/>
        <link rel="stylesheet" type="text/css" media="screen" href="{ $xqrails:resource-dir }/css/main.css"/>
           
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/jquery/jquery-1.7.1.min.js"><!-- --></script>  
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/jquery/jquery-ui-1.8.16.custom.min.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/jquery/jquery-ui-timepicker-addon.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/jquery/jquery.event.drag-2.0.min.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/jquery/jquery.jsonp-1.1.0.min.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/codemirror/js/codemirror.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/codemirror/mode/xml/xml.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/codemirror/mode/javascript/javascript.js"><!-- --></script>
        <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/codemirror/js/formatting.js"><!-- --></script>
    </head>
    <body>
        <div id="xqrailsLogo"><a href="http://xqrails.org"><img src="/resources/images/xqrails-logo.png" alt="xqRAILS" border="0" /></a></div>
        { map:get($model, 'body') }
    </body>
</html>