xquery version "1.0-ml";

(:
 :
 : controller documentation action list taglib
 :
 :
 :)

import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";
 
declare variable $model external;

let $target := map:get($model, "target")

let $documentation := fn:doc(fn:concat("/application/documentation/", $target, ".xml"))/*

let $output :=
    <div  style="position:relative;">
        <div class="module">
            <h2 class="buttons">{$documentation/title/fn:string(.)}<a href="#TOP">Top</a></h2>
            <div class="content">
                <p>{$documentation/description/fn:string(.)}</p>
            </div>
        </div>    
        <div class="module">
            <h2 class="buttons">Notes<a href="#TOP">Top</a></h2>
            <div class="content">
                <p>
                <ul>
                {
                for $note in $documentation//note
                return
                    <li>{$note/fn:string(.)}</li>
                }
                </ul>
                </p>
            </div>
        </div>  
        
        <div class="module" style="position:relative;">
        <h2 class="buttons">Service Calls <a href="#TOP">Top</a></h2>
            <div class="content accordion" style="width:100%;margin-left:-10px;height:auto;position:relative;">
            {
            for $request in $documentation//request
            return
                (
                    <div class="module">
                    <h2 class="buttons"><div style="width:80px;float:left;padding-left:15px;">{$request/method/fn:string(.)}</div> {$request/url/fn:string(.)} <a href="#TOP">Top</a></h2>
                    <div class="content">
                    <table>
                        <tr>
                            <td>Method:</td>
                            <td>{$request/method/fn:string(.)}</td>
                        </tr>
                        <tr>
                            <td>URL:</td>
                            <td>{$request/url/fn:string(.)}</td>
                        </tr>
                        <tr>
                            <td>Description:</td>
                            <td>{$request/description/fn:string(.)}</td>
                        </tr>
                        <tr>
                            <td>Parameters:</td>
                            <td>
                                {   
                                for $parameter in $request//parameter
                                return
                                    (
                                    <table>
                                        <tr>
                                            <td>Name:</td>
                                            <td>{$parameter/name/fn:string(.)}</td>
                                        </tr>
                                        <tr>
                                            <td>Type:</td>
                                            <td>{$parameter/type/fn:string(.)}</td>
                                        </tr>
                                        <tr>
                                            <td>Description:</td>
                                            <td>{$parameter/description/fn:string(.)}</td>
                                        </tr>
                                        <tr>
                                            <td>Required:</td>
                                            <td>{$parameter/required/fn:string(.)}</td>
                                        </tr>
                                    </table>
                                    )
                                }
                            </td>
                        </tr>
                        <tr>
                            <td>Responses:</td>
                            <td>
                                {   
                                for $response in $request//response
                                return
                                    (
                                    <table>
                                        <tr>
                                            <td>HTTP Code:</td>
                                            <td>{$response/httpCode/fn:string(.)}</td>
                                        </tr>
                                        <tr>
                                            <td>Description:</td>
                                            <td>{$response/description/fn:string(.)}</td>
                                        </tr>
                                        <tr>
                                            <td>Output:</td>
                                            <td>
                                                {   
                                                for $output in $response//output
                                                return
                                                    (
                                                    <table>
                                                        <tr>
                                                        <td>Type:</td>
                                                        <td>{$output/type/fn:string(.)}</td>
                                                        </tr>
                                                        <tr>
                                                        <td>Sample:</td>
                                                        {
                                                        if ($output/type/fn:string(.) eq "application/json") then
                                                        (
                                                            <td class="json clear">
                                                                <textarea size="" class="json">{if ($output/sample/fn:string(.)) then $output/sample/fn:string(.) else "&#160;"}</textarea>
                                                                <br clear="all" />
                                                            </td>
                                                        )
                                                        else
                                                        (
                                                            <td class="xml clear">
                                                                <textarea size="" class="xml">{if ($output/sample/*) then xdmp:quote($output/sample/*) else "&#160;"}</textarea>
                                                                <br clear="all" />        
                                                            </td>
                                                        )
                                                        }
                                                        </tr>
                                                    </table>
                                                    )
                                                }
                                            </td>
                                        </tr>
                                    </table>
                                    )
                                }
                            </td>
                        </tr>
                    </table>
                    <br clear="all"/>
                    </div>
                    </div>
                )
            }
            </div>
            <br clear="all"/>
        </div>
        <br clear="all"/>
    </div>

return $output

        
        
