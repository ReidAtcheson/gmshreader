
/*Stores element data.*/
typedef struct{
	int ie;
	int	etype;
	int numtags;
	int nnodes;
	int* tags;
	int* ToV;
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
void read_gmsh_file(const char* filename, gmshelm* out, int* n_elements);
int get_nnodes(int elmtag);


int get_nnodes(int elmtag){
	int out=0;
	switch (elmtag) { 
		case LINE_2N:
			out=2;
			break;
		case TRI_3N:
			out=3;
			break;
		case QUAD_4N:
			out=4;
			break;
		case HEX_8N:
			out=8;
			break;
		case PRISM_6N:
			out=6;
			break;
		case PYRAMID_5N:
			out=5;
			break;
		case LINE_3N:
			out=3;
			break;
		case TRI_6N:
			out=6;
			break;
		case QUAD_9N:
			out=9;
			break;
		case TET_10N:
			out=10;
			break;
		case HEX_27N:
			out=27;
			break;
		case PRISM_18N:
			out=18;
			break;
		case PYRAMID_14N:
			out=14;
			break;
		case POINT:
			out=1;
			break;
		case QUAD_8N:
			out=8;
			break;
		case HEX_20N:
			out=20;
			break;
		case PRISM_15N:
			out=15;
			break;
		case PYRAMID_13N:
			out=13;
			break;
		case INC_TRI_9N:
			out=9;
			break;
		case TRI_10N:
			out=10;
			break;
		case INC_TRI_12N:
			out=12;
			break;
		case TRI_15N:
			out=15;
			break;
		case INC_TRI_15N:
			out=15;
			break;
		case TRI_21N:
			out=21;
			break;
		case EDGE_4N:
			out=4;
			break;
		case EDGE_5N:
			out=5;
			break;
		case EDGE_6N:
			out=6;
			break;
		case TET_20N:
			out=20;
			break;
		case TET_35N:
			out=35;
			break;
		case TET_56N:
			out=56;
			break;
		case HEX_64N:
			out=64;
			break;
		case HEX_125N:
			out=125;
			break;
	}
	return out;
}
