#ifndef GMSH_READER_H_
#define GMSH_READER_H_
typedef struct{
	int ie;
	int	etype;
	int numtags;
	int nnodes;
	int* tags;
	int* ToV;
} gmshelm;


void read_gmsh_file(const char* filename, gmshelm* out, int* n_elements);
/*Stores element data.*/

#endif
