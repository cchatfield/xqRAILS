xquery version "1.0-ml";

(:
 :
 : lesson create view
 :
 : Copyright 2011 McGraw-Hill
 :
 :)
 
import module namespace xqrails = "http://avalonconsult.com/xqrails/core" at "/xqrails-core/xqrails.xqy";
import module namespace @object-escaped@ = "@xqrails.core.namespace@/models/@object-escaped@" at "/xqrails-app/models/@object-escaped@.xqy";
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";

(: model contains all presentation objects :)
declare variable $model as map:map external;
<div>
    <div class="nav">
        <span class="menuButton"><a class="home" href="/">Home</a></span>
        <span class="menuButton"><a href="/@object-escaped@/list" class="list">{util:fix-camel-case-to-string("@object-escaped@")} List</a></span>
        <span class="menuButton"><a href="/@object-escaped@/documentation" class="documentation">{util:fix-camel-case-to-string("@object-escaped@")} Documentation</a></span>
    </div>
    <div class="body">
        <a name="TOP"><!-- --> </a>
        <div class="documentation">
            {xqrails:taglib("documentation-controller-actions.html", ("target", "@object-escaped@"))}
            {xqrails:taglib("documentation-model-constraints.html", ($model))}
        </div>
    </div>  
    <script>
        $(function() {{
           $("textarea.xml").each(function (i, item){{
                var e = CodeMirror.fromTextArea(item, {{
                    lineNumbers: true,
                    mode: "xml"
                }});
                
                CodeMirror.commands["selectAll"](e);
                e.autoFormatRange(e.getCursor(true), e.getCursor(false));
                
            }});
           $("textarea.json").each(function (i, item){{
                var e = CodeMirror.fromTextArea(item, {{
                    lineNumbers: true,
                    mode: "javascript",
                    lineWrapping:true
                }});
                
                CodeMirror.commands["selectAll"](e);
                e.autoFormatRange(e.getCursor(true), e.getCursor(false));
           }});
        }});
    </script>
</div>
