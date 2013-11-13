#include <stdlib.h>

#include "gmshreader.h"






static inline int get_offset(int nr, int nc, int r, int c);
int gmshelm_free(gmshelm* elm,int ne);



/**
 *Loads array of gmshelms and generates contiguous array of desired element type from it.
 *@param etype Integer flag for type of element. Possibilities #defined in gmshdata.h
 *@param ne Length of gmshelm array.
 *@param elms Array of gmesh elements.
 *@param EToV Output element to node connectivity.
 */
int get_elements_of_type(int etype, int ne, gmshelm* elm, int** EToV, int* nElementsOfType,int* nNodesOfType){
	/*Get number of nodes for element type.*/
	int nnodes = get_nnodes(etype);

	int i=0;
	int ec=0;
	/*Do first pass to see how many of type etype there are.*/
	for(i=0;i<ne;i++)	{
		if(elm[i].etype==etype)
			ec++;
	}
	/*Allocate contiguous block of memory for EToV.*/
	*EToV = malloc( nnodes*ec*sizeof(int) );
	/*Now populate EToV.*/
	int eid=0;
	int c=0;
	for(i=0;i<ne;i++){
		if(elm[i].etype==etype){
			for(c=0;c<nnodes;c++){
				int offset = get_offset(ec,nnodes,eid,c);
				(*EToV)[offset] = elm[i].ToV[c];
			}

			eid++;
		}
	}

	/*Return number of elements.*/
	*nElementsOfType=ec;

	/*Return number of nodes.*/
	*nNodesOfType = nnodes;

	return EXIT_SUCCESS;
}


int gmshelm_free(gmshelm* elm,int ne){
	int i=0;
	if(elm!=NULL){
		for(i=0;i<ne;i++){
			free(elm[i].tags);
			free(elm[i].ToV);
		}
	}
	free(elm);
	return EXIT_SUCCESS;
}


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






/*Matrix offset calculator.*/
#define USE_COLUMN_MAJOR
static inline int get_offset(int nr, int nc, int r, int c){

#ifdef USE_COLUMN_MAJOR
	return r+c*nr;
#elif 
	return r*nc+c;
#endif

}
#undef USE_COLUMN_MAJOR
