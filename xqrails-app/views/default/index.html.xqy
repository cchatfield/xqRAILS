xquery version "1.0-ml";

(:
 :
 : default list view
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

(: model contains all presentation objects :)
declare variable $model as map:map external;
<div>
    
    <div class="nav">
        <span class="menuButton"><a class="home" href="/">Home</a></span>
    </div>
    <div class="body">
        <div>
            {xqrails:taglib("controller-list.html", ())}
            <div style="width:75%;float:left;">
                <div class="buttons">
                    <b>Welcome to xqRAILS</b>
                </div>
                <div style="padding:10px;">
                    <p>
                        Congratulations, you have successfully started your first xqRAILS application! At the moment this is the default page, feel free to modify it to either redirect to a controller or display whatever content you may choose. To the left is a list of controllers that are currently deployed in this application, click on each to execute its default action.
                    </p>
                    <p>
                        To quickly add new objects, views and controllers, type ant from the root directory of the application to see the help file for generating scaffolded objects, views and controllers.
                    </p>
                </div>
            </div>
        </div>
    </div>
    <script>
    $(function() {{
        $( "button.controller" ).button({{
            icons: {{
                primary: "ui-icon-gear"
            }}
        }});
        $( "button.documentation" ).button({{
            icons: {{
                primary: "ui-icon-help"
            }}
        }});
    }});
    </script>
</div>

