%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "gmshreader.h"

void yyerror(const char* s);


extern int yylex(void);
extern int yyparse(void);
extern FILE* yyin;

static Index nNodes;
static Real* VX;
static Real* VY;
static Real* VZ;

static Index ne;
static gmshelm* elms;
static Index tovid=0;
static Index counter=1;
static Index linecounter=0;

%}

%union{
	char* sval;
}

%token  MESHFORMAT ENDMESHFORMAT
%token  NODES ENDNODES
%token  ELEMENTS ENDELEMENTS
%token <sval> VAL
%token  EOL


%%

gmshfile:
				header nodes elements { /*printf("Done parsing gmsh file\n");*/}
;

header:
			MESHFORMAT EOL VAL VAL VAL EOL ENDMESHFORMAT EOL
{/*printf("Read in header\n");*/}
;

nodes: 
		 NODES EOL VAL EOL
{
nNodes=atoi($3);
VX=malloc(nNodes*sizeof(Real));
VY=malloc(nNodes*sizeof(Real));
VZ=malloc(nNodes*sizeof(Real));
}
|nodes VAL VAL VAL VAL EOL
{
Index id=atoi($2);
VX[id]=atof($3);
VY[id]=atof($4);
VZ[id]=atof($5);
}
| nodes ENDNODES EOL
{
/*printf("Finished reading nodes\n");*/
}
;

elements: ELEMENTS EOL VAL EOL				
{
ne=atoi($3);
elms=malloc(ne*sizeof(gmshelm));
}
|elements VAL
{
Index id=0;
if(counter==1){
	elms[linecounter].ie=atoi($2);
	counter++;
}
else if(counter==2){
	elms[linecounter].etype=atoi($2);
	counter++;
}
else if(counter==3){
	elms[linecounter].numtags=atoi($2);
	/*printf("numtags = %d\n",atoi($2));*/
	elms[linecounter].tags=malloc( elms[linecounter].numtags * sizeof(Index) );
	counter++;
}
else if( (counter>3) && (counter<=elms[linecounter].numtags+3) ){
	id=counter-(3+1);
	elms[linecounter].tags[id] = atoi($2);
	counter++;
}
else if(counter == (elms[linecounter].numtags+1+3)){
	elms[linecounter].nnodes=get_nnodes(elms[linecounter].etype);
	/*printf("nnodes = %d\n",elms[linecounter].nnodes);*/
	tovid=0;
	elms[linecounter].ToV=malloc(elms[linecounter].nnodes*sizeof(Index));
	elms[linecounter].ToV[tovid]=atoi($2);
	counter++;
	tovid++;
}
else{
	elms[linecounter].ToV[tovid]=atoi($2);
	counter++;
	tovid++;
}
}

| elements EOL{tovid=0;counter=1;linecounter++;}
| elements ENDELEMENTS{}
;

%%


void yyerror(const char* s){
	printf("Parse error: %s\n",s);
}

gmshelm* read_gmsh_file(const char* filename,
Index* n_elements,
Real** VX_out,
Real** VY_out, 
Real** VZ_out,
Index* nnodes){
	gmshelm* out;
	yyin=fopen(filename,"r");
	if(!yyin){
		fprintf(stderr,"Failed to open .msh file\n");
		return NULL;
	}
	do{
		yyparse();
	}while(!feof(yyin));
	out=malloc( ne*sizeof(gmshelm) );
	Index i=0;
	for(i=0;i<ne;i++){
		out[i].ie=elms[i].ie;
		out[i].etype=elms[i].etype;
		out[i].numtags=elms[i].numtags;
		out[i].nnodes=elms[i].nnodes;

		/*Allocate output tags array.*/
		out[i].tags = malloc( out[i].numtags * sizeof(Index) );	
		/*Copy tags from local memory to output memory.*/
		memcpy( out[i].tags, elms[i].tags, elms[i].numtags * sizeof(Index) );
		/*Free local tags array.*/
		free( elms[i].tags );
	
		/*Allocate output node connectivity array.*/	
		out[i].ToV = malloc( out[i].nnodes * sizeof(Index) );
		/*Copy node connectivity from local to output memory.*/
		memcpy( out[i].ToV , elms[i].ToV,  elms[i].nnodes * sizeof(Index) );
		/*Free local connectivity.*/	
		free( elms[i].ToV );
}
	/*Done with local element array.*/
	free(elms);
	
	memcpy(n_elements,&ne,sizeof(Index));
	memcpy(nnodes,&nNodes,sizeof(Index));

	/*Now copy nodes from local memory to output memory, after allocation.*/
	*VX_out = malloc( nNodes * sizeof(Real) );
	memcpy( *VX_out, VX, nNodes * sizeof(Real) );
	free(VX);

	*VY_out = malloc( nNodes * sizeof(Real) );
	memcpy( *VY_out, VY, nNodes * sizeof(Real) );
  free(VY);

	
	*VZ_out = malloc( nNodes * sizeof(Real) );
	memcpy( *VZ_out, VZ, nNodes * sizeof(Real) );
	free(VZ);
	

	return out;
}
