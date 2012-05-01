xquery version "1.0-ml";

(:
 :
 : @object@ list view
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
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";
import module namespace @object-escaped@ = "@xqrails.core.namespace@/models/@object-escaped@" at "/xqrails-app/models/@object-escaped@.xqy";

(: model contains all presentation objects :)
declare variable $model as map:map external;
<div>
    <div class="nav">
        <span class="menuButton"><a class="home" href="/">Home</a></span>
        <span class="menuButton"><a href="/@object-escaped@/create" class="create">New {util:fix-camel-case-to-string("@object@")}</a></span>
        <span class="menuButton"><a href="/@object-escaped@/documentation" class="documentation">{util:fix-camel-case-to-string("@object-escaped@")} Documentation</a></span>
        <span class="menuButton" style="float:right;margin-top:-3px;"><input type="text" name="filter" id="searchFilter" class="textInput" value="{map:get($model, 'filter')}" />&nbsp;<a href="#" class="find" onclick="location.href='?filter=' + $('#searchFilter').val();"></a></span>
    </div>
    <div class="body">
        <div>
            <div id="myGrid" style="width:100%;height:600px;"><!-- --></div>
            
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/slick.core.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/slick.remotemodel.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/plugins/slick.cellrangedecorator.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/plugins/slick.cellrangeselector.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/plugins/slick.cellselectionmodel.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/plugins/slick.rowselectionmodel.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/slick.editors.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/slick.grid.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/xqrails/views/list.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/slick.dataview.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/controls/slick.pager.js"><!-- --></script>
            <script type="text/javascript" src="{ $xqrails:resource-dir }/js/third-party/slick/controls/slick.columnpicker.js"><!-- --></script>
            <script>
                
                var url = "/@object-escaped@/list?responseFormat=application/json";
                var objectName = "@object-escaped@";
                var filter = "{map:get($model, 'filter')}*";
                var keyField = "{$@object-escaped@:@object-escaped@-id-field-path}";
                var columns = [
                    {
                        fn:concat("{ &quot;id&quot;:&quot;edit&quot;, &quot;name&quot;:&quot;&quot;, &quot;field&quot;:&quot;edit&quot;, &quot;width&quot;:20},")
                    }
                    
                    {
                        let $columns :=
                            for $key in @object-escaped@:keys()
                            return 
                                if ($key ne "identifier") then
                                    fn:concat("{ &quot;id&quot;:&quot;", $key, "&quot;, &quot;name&quot;:&quot;" , util:fix-camel-case-to-string($key) ,"&quot;, &quot;field&quot;:&quot;", $key, "&quot;, &quot;width&quot;:150}")
                                else ()
                        return fn:string-join($columns, ",")
                    }
                    {
                        fn:concat(",{ &quot;id&quot;:&quot;delete&quot;, &quot;name&quot;:&quot;&quot;, &quot;field&quot;:&quot;delete&quot;, &quot;width&quot;:20}")
                    }
                    
                ];
        
            </script>
        </div>
    </div>
</div>

