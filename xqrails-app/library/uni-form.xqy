xquery version "1.0-ml";

(:
 :
 : uni-form library
 :
 : adapted to uni-form at http://sprawsm.com/uni-form/
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

module namespace uni-form = "http://avalonconsult.com/xqrails/library/uniform";
import module namespace util = "http://avalonconsult.com/xqrails/library/util" at "/xqrails-app/library/util.xqy";

declare function build-form($keys as xs:string*, $constraints as element(constraints), $style as xs:string, $target as xs:string, $object as element()) as element(form)
{
    let $style :=
        if ($style eq "default" or $style eq "inlineLabels") then 
        (
            $style
        )
        else 
        (
            "default"
        )
    return
        <form class="uniForm" action="{$target}" method="post">
            <fieldset class="{$style}">
            {
                for $item in $keys
                return generate-field($item, $constraints, $object) 
            }
            </fieldset>
            <div class="buttons">
                <span class="button"><input type="submit" name="create" class="save" value="Save" id="create" /></span>
            </div>
        </form>
}; 

declare function build-form-read-only($keys as xs:string*, $style as xs:string, $object as element()) as element(div)
{
    let $style :=
        if ($style eq "default" or $style eq "inlineLabels") then 
        (
            $style
        )
        else 
        (
            "default"
        )
    return
        <div class="uniForm">
            <fieldset class="{$style}">
            {
                for $item in $keys
                let $value := xdmp:value(fn:concat("$object//", $item))
                return 
                    if ($value/node() instance of element()) then
                    (
                        <div class="ctrlHolder">
                            <label for="">{util:fix-camel-case-to-string($item)}</label>
                            <div class="xml">
                                <textarea id="{$item}" name="{$item}" size="" class="xml textInput">{if ($value) then xdmp:quote($value/*) else "&nbsp;"}</textarea>
                            </div>
                        </div>
                    )
                    else
                    (
                        let $value := fn:string($value)
                        return
                            <div class="ctrlHolder">
                                <label for="">{util:fix-camel-case-to-string($item)}</label>
                                <div class="textInput">{if ($value) then $value else "&nbsp;"}</div>
                            </div>
                    )
            }
            </fieldset>
        </div>
}; 

declare private function generate-field($field as xs:string, $constraints as element(constraints), $object as element()) as element(div)
{
    let $constraint := xdmp:value(fn:concat("$constraints//", $field))
    let $validation :=
        if ($constraint/@validation) then
        (
            fn:data($constraint/@validation)
        )
        else ""
    let $hint :=
        if ($constraint/@hint) then
        (
            fn:data($constraint/@hint)
        )
        else ""
    let $value := xdmp:value(fn:concat("$object//", $field)) 
    let $value :=
        if ($value/node() instance of element()) then
        (
            $value/*
        )
        else
        (
            fn:string($value)
        )
    let $value :=
        if ($value) then
            $value
        else
            ""
    let $data := fn:data($constraint/@options)
    let $data :=
        if(fn:contains($data, "|")) then 
        (
            fn:tokenize($data, "\|")
        )
        else $data       
    let $fieldType := fn:data($constraint/@fieldType)
    return
        if ($fieldType eq "string") then 
        (
            text-field($field, $value, $validation, $hint)
        )
        else if($fieldType eq "file") then 
        (
            text-file-field($field, $value, $validation, $hint)
        )
        else if($fieldType eq "text") then 
        (
            text-area-field($field, $value, $validation, $hint)
        )
        else if($fieldType eq "select") then 
        (
            select-field($field, $value, $validation, $hint, $data)
        )
        else if($fieldType eq "checkBox") then 
        (
            checkbox-field($field, $value, $validation, $hint, $data)
        )
        else if($fieldType eq "hidden") then 
        (
            hidden-field($field, $value, $validation, $hint)
        )
        else if($fieldType eq "date") then 
        (
            date-field($field, $value, $validation, $hint)
        )
        else if($fieldType eq "dateTime") then 
        (
            date-time-field($field, $value, $validation, $hint)
        )
        else if($fieldType eq "xml") then 
        (
            xml-field($field, $value, $validation, $hint)
        )
        else 
        (
            text-field($field, $value, $validation, $hint)
        )
};

declare private function text-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <input type="text" id="{$field}" name="{$field}" size="" class="textInput {$validation}" value="{$value}"/>
        <p class="formHint">{$hint}</p>
    </div>
};

declare private function date-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <input type="text" id="{$field}" name="{$field}" size="" class="date textInput {$validation}" value="{$value}"/>
        <p class="formHint">{$hint}</p>
    </div>
};

declare private function date-time-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <input type="text" id="{$field}" name="{$field}" size="" class="dateTime textInput {$validation}" value="{$value}"/>
        <p class="formHint">{$hint}</p>
    </div>
};

declare private function hidden-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string) as element(input)
{
    <input type="hidden" id="{$field}" name="{$field}" size="" value="{$value}"/>
};

declare private function text-file-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <input type="file" id="{$field}" name="{$field}" size="" class="{$validation}"/>
        <p class="formHint">{$hint}</p>
    </div>
};

declare private function text-area-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <textarea id="{$field}" name="{$field}" size="" class="{$validation}">{if ($value) then $value else "&nbsp;"}</textarea>
        <p class="formHint">{$hint}</p>
    </div>
};

declare private function xml-field($field as xs:string, $value as item(), $validation as xs:string, $hint as xs:string) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <div class="xml">
        <textarea id="{$field}" name="{$field}" size="" class="xml {$validation}">{if ($value) then xdmp:quote($value) else "&#160;"}</textarea>
        </div>
        <p class="formHint">{$hint}</p>
    </div>
};

declare private function select-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string, $data as xs:string*) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        <select id="{$field}" name="{$field}" size="" class="{$validation}">
            {
                build-options-from-string-list($data, $value)  
            }
        </select>
        <p class="formHint">{$hint}</p>
    </div>
};
declare private function checkbox-field($field as xs:string, $value as xs:string, $validation as xs:string, $hint as xs:string, $data as xs:string*) as element(div)
{
    <div class="ctrlHolder">
        <label for="">{util:fix-camel-case-to-string($field)}</label>
        {
            if ($data eq $value) then 
            ( 
                (<input type="checkbox" id="{$field}" name="{$field}" size="" class="{$validation}" checked="checked" value="{$data}" />,fn:concat("&nbsp;", $data))
            ) 
            else 
            ( 
                (<input type="checkbox" id="{$field}" name="{$field}" size="" class="{$validation}" value="{$data}" />,fn:concat("&nbsp;", $data))
            )
        }
        <p class="formHint">{$hint}</p>
    </div>
};
declare private function build-options-from-string-list($data as xs:string*, $value as xs:string) as element(option)*
{
    for $item in $data
    return
        if ($item eq $value) then
        (
            <option selected="selected" value="{$item}">{$item}</option>
        )
        else
        (
            <option value="{$item}">{$item}</option>
        )
};


