xquery version "1.0-ml";

(:
 :
 : @object@ show view
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
import module namespace @object-escaped@ = "@xqrails.core.namespace@/models/@object-escaped@" at "/xqrails-app/models/@object-escaped@.xqy";
import module namespace uni-form = "http://avalonconsult.com/xqrails/library/uniform" at "/xqrails-app/library/uni-form.xqy";
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";

(: model contains all presentation objects :)
declare variable $model as map:map external;

<div>
    <div class="nav">
        <span class="menuButton"><a class="home" href="/@object-escaped@/">Home</a></span>
        <span class="menuButton"><a href="/@object-escaped@/list" class="list">{util:fix-camel-case-to-string("@object@")} List</a></span>
        <span class="menuButton"><a href="/@object-escaped@/create" class="create">New {util:fix-camel-case-to-string("@object@")}</a></span>
        <span class="menuButton"><a href="/@object-escaped@/documentation" class="documentation">{util:fix-camel-case-to-string("@object-escaped@")} Documentation</a></span>
    </div>
    <div class="body">
        <div class="buttons">
            Show {util:fix-camel-case-to-string("@object@")}
        </div>
        {
            uni-form:build-form-read-only(@object-escaped@:keys(), "inlineLabels", map:get($model, '@object-escaped@'))
        }
        <div class="buttons">
            <form action="/@object-escaped@/edit/{ @object-escaped@:id(map:get($model, '@object-escaped@')) }" method="get" style="float:left;">
                 <span class="button"><input type="submit" value="Edit" class="edit" /></span>
            </form>
            <form action="/@object-escaped@/{ @object-escaped@:id(map:get($model, '@object-escaped@')) }?method=delete" method="post"  style="float:left;">
                 <span class="button"><input type="submit" value="Delete" class="delete" onclick="return confirm('Are you sure?');"/></span>
            </form>
        </div>
        <script>
            $(function(){{
                $("textarea.xml").each(function (i, item){{
                    CodeMirror.fromTextArea(item, {{
                        lineNumbers: true,
                        mode: {{name: "xml", htmlMode: true}},
                        readOnly: true
                    }});
                }});
            }});
        </script>
    </div>
</div>
