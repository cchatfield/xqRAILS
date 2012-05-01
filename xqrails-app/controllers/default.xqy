xquery version "1.0-ml";

(:
 :
 : default controller
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
 
module namespace xqrails-controller = "http://avalonconsult.com/xqrails/controller";

import module namespace xqrails = "http://avalonconsult.com/xqrails/core" at "/xqrails-core/xqrails.xqy";

declare namespace error = "http://marklogic.com/xdmp/error";

(:~
 : the default action for the controller
 : 
 :)
declare function xqrails-controller:index()
{
    xqrails:layout
    (
        'main', 
        (
            'browsertitle' ,'Welcome to xqRAILS',
            'breadcrumb', 'xqRails Home',
            'body', xqrails:view('default/index.html', ())                
        )
    )
};
       
