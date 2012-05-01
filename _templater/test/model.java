package org.xqrails.models;

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

import com.marklogic.ps.test.XQueryTestCase;
import com.marklogic.xcc.ResultSequence;
import com.marklogic.xcc.ValueFactory;
import com.marklogic.xcc.types.ValueType;
import com.marklogic.xcc.types.XdmValue;

@RunWith(JUnit4.class)
public class @object-escaped@Test extends XQueryTestCase {

	private String modulePath = "/xqrails-app/models/@object-escaped@.xqy";
	private String moduleNamespace = "@xqrails.core.namespace@/models/@object-escaped@";
	private String testIdentifier = "";
	
	@Before
	public void setUp() throws Exception {
		super.setUp();
		this.save();
	}
	
	@After
	public void tearDown() throws Exception {
		this.deleteById();
		super.tearDown();
	}
	
	@Test
	public void _new() throws Exception {
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "new", null);
		
		org.junit.Assert.assertNotNull(doc);
		
		// check root element name
		org.junit.Assert.assertEquals("@object@", doc.getRootElement().getName());
		
		XPath xpath = XPath.newInstance("/@object@/identifier");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/title");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/description");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/createdBy");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/dateCreated");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/lastUpdated");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/empty");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNull(response);
	    
	    xpath = XPath.newInstance("/@object@");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertEquals(6, response.getChildren().size());
	}
	
	@Test
	public void build() throws Exception {
		XdmValue[] map = new XdmValue[] { ValueFactory.newXSString("map"), ValueFactory.newXSString("title"),  ValueFactory.newXSString("Test") };
		XdmValue[] params = new XdmValue[] { 
			    ValueFactory.newSequence(map)
				};
		
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "build", params);
		
		org.junit.Assert.assertNotNull(doc);
		
		// check root element name
		org.junit.Assert.assertEquals("@object@", doc.getRootElement().getName());
		
		XPath xpath = XPath.newInstance("/@object@/identifier");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/title");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    org.junit.Assert.assertEquals("Test", response.getText());
	    
	    xpath = XPath.newInstance("/@object@/description");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/createdBy");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/dateCreated");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/lastUpdated");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    
	    xpath = XPath.newInstance("/@object@/empty");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNull(response);
	    
	    xpath = XPath.newInstance("/@object@");
	    response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertEquals(6, response.getChildren().size());
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
	
	@Test
	public void update() throws Exception {
		
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "new", null);
		
		DOMOutputter out = new DOMOutputter();
		org.w3c.dom.Document w3cDoc = out.output(doc);
		
		XdmValue[] map = new XdmValue[] { ValueFactory.newXSString("map"), ValueFactory.newXSString("title"),  ValueFactory.newXSString("UnitTestItem") };
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newElement(w3cDoc.getDocumentElement()),
			    ValueFactory.newSequence(map)
				};
		
	    doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "update", params);
		XPath xpath = XPath.newInstance("/@object@/title");
	    Element response = (Element) xpath.selectSingleNode(doc);
		
		org.junit.Assert.assertNotNull(response);
		org.junit.Assert.assertEquals("UnitTestItem", response.getText());
	}
	
	// @Test
	public void deleteById() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(this.testIdentifier)
				};
		
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "delete-by-id", params);
		
		org.junit.Assert.assertNotNull(rs);
	}
	
	@Test
	public void find() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString(this.testIdentifier)
				};
		
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "find", params);
		
		XPath xpath = XPath.newInstance("/@object@/identifier");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	}
	
	@Test
	public void findBy() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSString("UnitTestItem"),
				ValueFactory.newXSInteger(1),
				ValueFactory.newXSInteger(50),
				ValueFactory.newXSString("test")
				};
		
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "find-by", params);
		org.junit.Assert.assertNotNull(doc);
		XPath xpath = XPath.newInstance("//@object@/title");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	    org.junit.Assert.assertEquals("UnitTestItem", response.getText());
	}
	
	@Test
	public void findAllWithPaging() throws Exception {
		XdmValue[] params = new XdmValue[] { 
				ValueFactory.newXSInteger(1),
				ValueFactory.newXSInteger(50)
				};
		
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "find-all", params);
		org.junit.Assert.assertNotNull(doc);
		XPath xpath = XPath.newInstance("//@object@/title");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	}
	
	@Test
	public void findAll() throws Exception {
		Document doc = executeLibraryModuleAsDocument(modulePath, moduleNamespace, "find-all", null);
		org.junit.Assert.assertNotNull(doc);
		XPath xpath = XPath.newInstance("//@object@/title");
	    Element response = (Element) xpath.selectSingleNode(doc);
	    org.junit.Assert.assertNotNull(response);
	}
	
	@Test
	public void keys() throws Exception {
		ResultSequence rs = executeLibraryModule(modulePath, moduleNamespace, "keys", null);
		org.junit.Assert.assertNotNull(rs);
		org.junit.Assert.assertEquals("identifier", rs.itemAt(0).asString());
		org.junit.Assert.assertEquals("title", rs.itemAt(1).asString());
		org.junit.Assert.assertEquals("description", rs.itemAt(2).asString());
		org.junit.Assert.assertEquals("createdBy", rs.itemAt(3).asString());
		org.junit.Assert.assertEquals("dateCreated", rs.itemAt(4).asString());
		org.junit.Assert.assertEquals("lastUpdated", rs.itemAt(5).asString());
	}
}
