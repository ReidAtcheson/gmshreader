%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "gmshreader.h"

void yyerror(const char* s);


extern int yylex(void);
extern int yyparse(void);
extern FILE* yyin;

static int nNodes;
static double* VX;
static double* VY;
static double* VZ;

static int ne;
static gmshelm* elms;
static int tovid=0;
static int counter=1;
static int linecounter=0;

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
VX=malloc(nNodes*sizeof(double));
VY=malloc(nNodes*sizeof(double));
VZ=malloc(nNodes*sizeof(double));
}
|nodes VAL VAL VAL VAL EOL
{
int id=atoi($2);
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
int id=0;
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
	elms[linecounter].tags=malloc( elms[linecounter].numtags * sizeof(int) );
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
	elms[linecounter].ToV=malloc(elms[linecounter].nnodes*sizeof(int));
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
int* n_elements,
double** VX_out,
double** VY_out, 
double** VZ_out,
int* nnodes){
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
	int i=0;
	for(i=0;i<ne;i++){
		out[i].ie=elms[i].ie;
		out[i].etype=elms[i].etype;
		out[i].numtags=elms[i].numtags;
		out[i].nnodes=elms[i].nnodes;

		/*Allocate output tags array.*/
		out[i].tags = malloc( out[i].numtags * sizeof(int) );	
		/*Copy tags from local memory to output memory.*/
		memcpy( out[i].tags, elms[i].tags, elms[i].numtags * sizeof(int) );
		/*Free local tags array.*/
		free( elms[i].tags );
	
		/*Allocate output node connectivity array.*/	
		out[i].ToV = malloc( out[i].nnodes * sizeof(int) );
		/*Copy node connectivity from local to output memory.*/
		memcpy( out[i].ToV , elms[i].ToV,  elms[i].nnodes * sizeof(int) );
		/*Free local connectivity.*/	
		free( elms[i].ToV );
}
	/*Done with local element array.*/
	free(elms);
	
	memcpy(n_elements,&ne,sizeof(int));
	memcpy(nnodes,&nNodes,sizeof(int));

	/*Now copy nodes from local memory to output memory, after allocation.*/
	*VX_out = malloc( nNodes * sizeof(double) );
	memcpy( *VX_out, VX, nNodes * sizeof(double) );
	free(VX);

	*VY_out = malloc( nNodes * sizeof(double) );
	memcpy( *VY_out, VY, nNodes * sizeof(double) );
  free(VY);

	
	*VZ_out = malloc( nNodes * sizeof(double) );
	memcpy( *VZ_out, VZ, nNodes * sizeof(double) );
	free(VZ);
	

	return out;
}
