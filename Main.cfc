component extends="railoRunner" {

	variables.mypath = getDirectoryFromPath(getCurrentTemplatePath());
	variables.pmpath = "http://www.getrailo.org/ExtensionProvider.cfc?wsdl"
	

	function list(paramArray=[]){

		var ws = createObject("webservice", variables.pmpath);
		var retSTring =""; 
		var apps = ws.listApplications();
		
		var aItems = [];
		var maxWidth = 1;


		//Do a requery so we limit it. 
		query dbtype="query" name="apps"{
			WriteOutput("SELECT name, version,category FROM apps WHERE CATEGORY = 'Framework'");
		}


		return formatForOutput(apps, true);

	}

	function formatForOutput(any object, boolean queryShowColumns = false){
		var returnString = "";

		if(isQuery(object)){
			
			var aColLengths = {};
			
			loop query="arguments.object" {
				loop list=arguments.object.columnlist index="local.c" {

					if(!StructKeyExists(aColLengths, local.c)){
						aColLengths[local.c] = 1;
					}
					var colSize = Len(arguments.object[local.c]); 
					if(colSize GT aColLengths[local.c]){
 						aColLengths[local.c] = colSize;
					}		
				}
			}	

			//Add the colums if we must
			if(arguments.queryShowColumns){
				loop list=arguments.object.columnlist index="local.c" {
					returnString &= "| " & local.c;

					//Now add the spaces
					if(aColLengths[local.c] GT Len(local.c)){
						loop from="1" to="#aColLengths[local.c] - Len(local.c)+1#" index="local.s"{
							returnString &= " ";							
						}
					}
							
				}
				returnString &= "|" & chr(10);

				//Add a == underneath
				loop list=arguments.object.columnlist index="local.c" {
					returnString &= "--";

					//Now add the spaces
					
					loop from="1" to="#aColLengths[local.c]+1#" index="local.s"{
							returnString &= "-";							
					}
				}
				returnString &= "-" & chr(10);
			}

			//Add the rows now
			loop query="arguments.object" {

				loop list=arguments.object.columnlist index="local.c" {
					returnString &= "| " & arguments.object[local.c];

					if(aColLengths[local.c] GT Len(local.c)){
						loop from="1" to="#aColLengths[local.c] - Len(arguments.object[local.c])+1#" index="local.s"{
							returnString &= " ";							
						}
					}
				}


				returnString &= "|" & chr(10);
			}

			return returnString;

			//return formatForOutput(aColLengths);	
		}

		return SerializeJSON(object);
		
	}

	
	function install(paramArray=[]){

		return "This would install the selected plugins for the railo cli";
	
	}
	
	function uninstall(paramArray=[]){

		return "This would uninstall the selected plugins for the railo cli";
	
	}
	
	function help(){
		return "The current commands you can send to the railo PackageManager are: list, uninstall";
	}


	
}