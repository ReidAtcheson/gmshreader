%{
#include <stdlib.h>
#include <stdio.h>
#include "gmshdata.h"

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
int id;
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
	elms[linecounter].ToV=malloc(elms[linecounter].nnodes*sizeof(int));
	elms[linecounter].ToV[0]=atoi($2);
	counter++;
}
else{
	int id=counter-elms[linecounter].numtags-2;
	elms[linecounter].ToV[id]=atoi($2);
	counter++;
}
}

| elements EOL{counter=1;linecounter++;}
| elements ENDELEMENTS{}
;

%%


void yyerror(const char* s){
	printf("Parse error: %s\n",s);
}

void read_gmsh_file(const char* filename,gmshelm* out, int* n_elements){
	yyin=fopen(filename,"r");
	do{
		yyparse();
	}while(!feof(yyin));
	out=elms;
	n_elements=&ne;

}
