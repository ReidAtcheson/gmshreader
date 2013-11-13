#include "gmshreader.h"
#include "CUnit/Basic.h"
#include <stdlib.h>

static const char* straight_edged = "circle_badmesh.msh";
static const char* curved_edged = "circle_curvedmesh.msh";

int gmsh_init(void);
int gmsh_cleanup(void);

void test_read(void);
void test_get_element_of_type(void);


/*Dummy functions, unnecessary here.*/
int gmsh_init(void){return EXIT_SUCCESS;}
int gmsh_cleanup(void){return EXIT_SUCCESS;}

void test_read(void){

	/*Array of gmsh element structures.*/
	gmshelm* elm=NULL;

	/*Number of gmsh elements.*/
	int ne;

	/*Nodes.*/
	double* VX=NULL;
	double* VY=NULL;
	double* VZ=NULL;

	/*Number of nodes.*/
	int nn;

	/*Read in file.*/
	elm = read_gmsh_file(curved_edged, &ne, &VX, &VY, &VZ, &nn);

	int* EToV=NULL;
	int n_elements=0;
	int n_nodes=0;

	int status = get_elements_of_type(21,
			ne,
			elm,
			&EToV,
			&n_elements,
			&n_nodes);

	printf("number of elements: %d\n",n_elements);
	printf("number of nodes: %d\n",n_nodes);
	int r,c;
	for(r=0;r<n_elements;r++){
		printf("\n");
		for(c=0;c<n_nodes;c++)
			printf("%d ",EToV[r+c*n_elements]);
	}
					


}
void test_get_element_of_type(void){}


int main(int argc, char** argv){
	CU_pSuite pSuite = NULL;



	/*Initialization and cleanup.*/
	if (CUE_SUCCESS != CU_initialize_registry())
		return CU_get_error();
	pSuite = CU_add_suite("Basic gmshreader tests",gmsh_init,gmsh_cleanup);
	if(NULL==pSuite){
		CU_cleanup_registry();
		return CU_get_error();
	}



	/*Add tests and run.*/
	if(
			(NULL == CU_add_test(pSuite,"Testing mesh reading",test_read))
		){
		CU_cleanup_registry();
		return CU_get_error();
	}

	CU_basic_set_mode(CU_BRM_VERBOSE);
	CU_basic_run_tests();
	CU_cleanup_registry();

	return CU_get_error();


}
