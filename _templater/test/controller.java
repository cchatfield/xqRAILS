package org.xqrails.controllers;

import org.apache.http.NameValuePair;
import org.apache.http.client.HttpResponseException;
import org.apache.http.message.BasicNameValuePair;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.Text;
import org.jdom.output.DOMOutputter;
import org.jdom.xpath.XPath;
import org.junit.Before;
import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.JUnit4;
import org.junit.Assert;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
 

import com.marklogic.ps.test.XQueryXmlHttpTestCase;
import com.marklogic.ps.util.JDomUtils;
import com.marklogic.xcc.ResultSequence;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.ValueType;
import com.marklogic.xcc.types.XdmValue;

@RunWith(JUnit4.class)
public class @object-escaped@Test extends XQueryXmlHttpTestCase {

	private String modulePath = "/xqrails-app/models/@object-escaped@.xqy";
	private String moduleNamespace = "@xqrails.core.namespace@/models/@object-escaped@";
	private String testIdentifier = "";
	
	@Before
	public void setUp() throws Exception {
		this.setServicePath("@object-escaped@/");
		super.setUp();
		this.save();
	}
	
	@After
	public void tearDown() throws Exception {
		try {
			this.deleteById(this.testIdentifier);
		} catch (Exception ex) {
		}
		super.tearDown();
	}
	
	// @Test
	public void save() throws Exception {
		XdmValue[] map = new XdmValue[] { ValueFactory.newXSString("map"), ValueFactory.newXSString("title"),  ValueFactory.newXSString("UnitTestItem") };
		XdmValue[] params = new XdmValue[] { 
			    ValueFactory.newSequence(map)
				};
		
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "build", params);
		
		DOMOutputter out = new DOMOutputter();
		org.w3c.dom.Document w3cDoc = out.output(doc);
		
		params = new XdmValue[] { 
			    ValueFactory.newElement(w3cDoc.getDocumentElement())
				};
		
		XPath xpath = XPath.newInstance("/@object@/identifier");
	    Element response = (Element) xpath.selectSingleNode(doc);
		this.testIdentifier = response.getText();
		
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "save", params);
		
		org.junit.Assert.assertNotNull(rs);
	}
	
	// @Test
	public void deleteById(String id) throws Exception {
		System.out.println("Deleting record with id: " + id);
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(id)
				};
		
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "delete-by-id", params);
		
		org.junit.Assert.assertNotNull(rs);
	}
	
	@Test
	public void index_GET_HTML() throws Exception {
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "get")
		};
		String response = this.executeQuery(params);
		org.junit.Assert.assertNotNull(response);
	}
	
	@Test
	public void index_GET_XML() throws Exception {
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "get"),
				new BasicNameValuePair("responseFormat", "application/xml")
		};
		Document doc = this.executeQueryAsDocument(params);
		org.junit.Assert.assertNotNull(doc);
		org.junit.Assert.assertEquals("data", doc.getRootElement().getName());
	}
	
	@Test
	public void index_GET_JSON() throws Exception {
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "get"),
				new BasicNameValuePair("responseFormat", "application/json")
		};
		String response = this.executeQuery(params);
		org.junit.Assert.assertNotNull(response);
	}
	
	@Test
	public void index_POST_HTML() throws Exception {
		String newId = "";
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "post"),
				new BasicNameValuePair("title", "UnitTestItem"),
				new BasicNameValuePair("description", "UnitPOSTHTMLTestItem")
		};
		int statusCode = 0;
		String message = "";
		try {
			String response = this.executeQuery(params);
		} catch (HttpResponseException expected) {
			statusCode = expected.getStatusCode();
			message = expected.getMessage();
			
		}
		org.junit.Assert.assertEquals(302, statusCode);
		if (statusCode == 302){
			newId = findIdentifier(message);
			this.deleteById(newId);
		}
	}
	
	@Test
	public void index_POST_XML() throws Exception {
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "post"),
				new BasicNameValuePair("title", "UnitTestItem"),
				new BasicNameValuePair("description", "UnitPOSTXMLTestItem"),
				new BasicNameValuePair("responseFormat", "application/xml")
		};
		Document doc = this.executeQueryAsDocument(params);
		org.junit.Assert.assertNotNull(doc);
		org.junit.Assert.assertEquals("data", doc.getRootElement().getName());
		
		XPath xpath = XPath.newInstance("/data/@object@/identifier");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    this.deleteById(response.getText());
	}
	
	@Test
	public void index_POST_JSON() throws Exception {
		String newId = "";
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "post"),
				new BasicNameValuePair("title", "UnitTestItem"),
				new BasicNameValuePair("description", "UnitPOSTJSONTestItem"),
				new BasicNameValuePair("responseFormat", "application/json")
		};
		String response = this.executeQuery(params);
		System.out.println("index_POST_JSON response [" + response + "]");
		newId = findIdentifier(response);
		org.junit.Assert.assertNotNull(response);
		this.deleteById(newId);
	}
	
	@Test
	public void index_PUT_HTML() throws Exception {
		appendServiceUrl(this.testIdentifier);
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "put"),
				new BasicNameValuePair("title", "UnitTestItemUpdate"),
				new BasicNameValuePair("description", "UnitPUTHTMLTestItem")
		};
		int statusCode = 0;
		String message = "";
		try {
			String response = this.executeQuery(params);
		} catch (HttpResponseException expected) {
			statusCode = expected.getStatusCode();
			message = expected.getMessage();
			
		}
		org.junit.Assert.assertEquals(302, statusCode);
	}
	
	@Test
	public void index_PUT_XML() throws Exception {
		appendServiceUrl(this.testIdentifier);
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "put"),
				new BasicNameValuePair("title", "UnitTestItemUpdate"),
				new BasicNameValuePair("description", "UnitPUTXMLTestItem"),
				new BasicNameValuePair("responseFormat", "application/xml")
		};
		Document doc = this.executeQueryAsDocument(params);
		org.junit.Assert.assertNotNull(doc);
		org.junit.Assert.assertEquals("data", doc.getRootElement().getName());
		
		XPath xpath = XPath.newInstance("/data/@object@/identifier");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    //this.deleteById(response.getText());
	}
	
	@Test
	public void index_PUT_JSON() throws Exception {
		appendServiceUrl(this.testIdentifier);
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "put"),
				new BasicNameValuePair("title", "UnitTestItemUpdate"),
				new BasicNameValuePair("description", "UnitPUTJSONTestItem"),
				new BasicNameValuePair("responseFormat", "application/json")
		};
		String response = this.executeQuery(params);
		System.out.println("index_PUT_JSON response [" + response + "]");
		org.junit.Assert.assertNotNull(response);
		//this.deleteById(newId);
	}
	
	@Test
	public void index_DELETE_HTML() throws Exception {
		appendServiceUrl(this.testIdentifier);
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "delete")
		};
		int statusCode = 0;
		String message = "";
		try {
			String response = this.executeQuery(params);
		} catch (HttpResponseException expected) {
			statusCode = expected.getStatusCode();
			message = expected.getMessage();
			
		}
		org.junit.Assert.assertEquals(302, statusCode);
		try {
			deleteById(this.testIdentifier);
		} catch (Exception ex) {
			org.junit.Assert.assertTrue(true);
		}
	}
	
	@Test
	public void index_DELETE_XML() throws Exception {
		appendServiceUrl(this.testIdentifier);
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "delete"),
				new BasicNameValuePair("responseFormat", "application/xml")
		};
		try {
			String response = this.executeQuery(params);
		} catch (Exception ex) {
			try {
				deleteById(this.testIdentifier);
			} catch (Exception ex2) {
				org.junit.Assert.assertTrue(true);
			}
		}
	}
	
	@Test
	public void index_DELETE_JSON() throws Exception {
		appendServiceUrl(this.testIdentifier);
		NameValuePair[] params = new NameValuePair[] {
				new BasicNameValuePair("method", "delete"),
				new BasicNameValuePair("responseFormat", "application/json")
		};
		try {
			String response = this.executeQuery(params);
		} catch (Exception ex) {
			try {
				deleteById(this.testIdentifier);
			} catch (Exception ex2) {
				org.junit.Assert.assertTrue(true);
			}
		}
	}
	
	private String findIdentifier(String input) throws Exception {
		String identifier = "[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}";
		Pattern pattern = Pattern.compile(identifier);
		Matcher matcher = pattern.matcher(input);
		while (matcher.find())
	            return matcher.group();
		return "";
	}
}
