#ifndef GMSH_READER_H_
#define GMSH_READER_H_
typedef unsigned long Index;
typedef double Real;


/*Stores element data.*/
typedef struct{
	Index ie;
	Index	etype;
	Index numtags;
	Index nnodes;
	Index* tags;
	Index* ToV;
} gmshelm;





/**
 *GMSH element type tags.
 */
#define LINE_2N 1
#define TRI_3N 2
#define	QUAD_4N 3
#define	HEX_8N 5
#define	PRISM_6N 6 
#define	PYRAMID_5N 7 
#define	LINE_3N 8 
#define	TRI_6N 9 
#define	QUAD_9N 10 
#define	TET_10N 11 
#define	HEX_27N 12 
#define	PRISM_18N 13 
#define	PYRAMID_14N 14 
#define	POINT 15 
#define	QUAD_8N 16 
#define	HEX_20N 17 
#define	PRISM_15N 18 
#define	PYRAMID_13N 19 
#define	INC_TRI_9N 20 
#define	TRI_10N 21 
#define	INC_TRI_12N 22 
#define	TRI_15N 23 
#define	INC_TRI_15N 24 
#define	TRI_21N 25 
#define	EDGE_4N 26 
#define	EDGE_5N 27 
#define	EDGE_6N 28 
#define	TET_20N 29 
#define	TET_35N 30 
#define	TET_56N 31 
#define	HEX_64N 92 
#define	HEX_125N 93


gmshelm* read_gmsh_file(const char* filename, 
		Index* n_elements,
		Real** VX_out,
		Real** VY_out, 
		Real** VZ_out, 
		Index* nnodes);

Index get_elements_of_type(Index etype, 
		Index ne,
	 	gmshelm* elm, 
		Index** EToV, 
		Index* nElementsOfType,
		Index* nNodesOfType);


Index gmshelm_free(gmshelm* elm,Index ne);
Index get_nnodes(Index elmtag);




#endif
