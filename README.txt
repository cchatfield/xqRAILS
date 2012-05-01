1. Create an xdbc server so the ant install scripts can be executed
	a. xdbc server authentication has to be set to basic
	b. xdbc modules setting must be set to Modules
	
2. Update build.properties in config folder
	a. update the xqRails.xdbc.connectionString property to the newly created xdbc server	
	
3. From the root directory run ant install

4. If you change the default ports in the build.properties, update the following files:
	a. test/resources/xdbc.properties 
	b. test/resources/xmlHttpConnection.properties