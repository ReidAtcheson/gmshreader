%{
#include "gmsh.tab.h"
%}

%%
"$MeshFormat"    { 
									return MESHFORMAT;   
								 }

"$EndMeshFormat" { 
									return ENDMESHFORMAT;
							   }

"$Nodes"				 { 
									return NODES;  			
								 }

"$EndNodes"      { 
								  return ENDNODES;     
								 }

"$Elements"      { 
									return ELEMENTS;     
								 }

"$EndElements"   { 
									return ENDELEMENTS;  
								 }

" "              {/*ignore.*/
								 }

"\n"						 {
									
return EOL;					
								 
}
([-+]?)[0-9]*\.?[0-9]*([Ee][+-]?[0-9]+)?[f|F|l|L]? { 

/*Recognize C/Fortran style floats with optional trailing C specifiers.*/
yylval.sval=strdup(yytext);
return VAL;
}
