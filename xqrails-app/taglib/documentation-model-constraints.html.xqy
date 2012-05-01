xquery version "1.0-ml";

(:
 :
 : object description library
 :
 :)

import module namespace xqrails = "http://avalonconsult.com/xqrails/core" at "/xqrails-core/xqrails.xqy";
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";
 
declare variable $model external;

<div>
    <div class="module">
        <h2 class="buttons">Object Definition<a href="#TOP">Top</a></h2>
        <div class="content">
             <div class="xml">
                <textarea size="" class="xml">{if (map:get($model,"object")) then xdmp:quote(map:get($model,"object")) else "&#160;"}</textarea>
            </div>
        </div>
    </div>   
    <div class="module">
        <h2 class="buttons">Object Constraints<a href="#TOP">Top</a></h2>
        <div class="content">
            <div class="xml">
                <textarea size="" class="xml">{if (map:get($model,"constraints")) then xdmp:quote(map:get($model,"constraints")) else "&#160;"}</textarea>
            </div>
        </div>
    </div> 
</div> 
        
