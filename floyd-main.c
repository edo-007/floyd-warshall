#include <stdlib.h> 
#include <stdio.h>

#include "lib/floyd-library.h"
#include "lib/time-library.h"


#ifdef _USE_MPI
    #include <mpi.h>
#endif

#ifdef _USE_OMP
    #include <omp.h>
#endif



int main(int argc, char **argv){ /* _______________________________________________ MAIN ______________________________________________*/

    struct timespec start, end;

    double elapsed,mean,sum;
    mean = 0.0;
    sum = 0.0;

    int mpi_rank, mpi_size;
    mpi_rank = 0.0;
    mpi_size = 0.0;
    
    // char *fname = "graph.dot";
    int (*G) [ N ] ; // puntatore ad array di N elementi interi

    int (*C) [ N ] ;    // Costi
    int (*D) [ N ] ;    // Distanze
    int (*P) [ N ] ;    // Predecessori 

/*_____________________________________
 * 
 *          INIZIALIZZAZIONE
 *_____________________________________
*/

#ifdef _USE_MPI

/*
    memory allocation: only MPI0 allocate memory to store the entire graph, other
    process allocate only minimum storage necessary
*/ 
    
    if ( MPI_Init(&argc, &argv) != MPI_SUCCESS ) {
        fprintf(stderr , "Error in MPI_Init.\n" );
        exit(-1);
    }
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_size);       // Size
    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_rank);       // Rank

    /* root process */
    if (mpi_rank == 0) {

        /* Solo il processo root le alloca */    
        posix_memalign_all(&G,&C,&D,&P);
        initGraph (G,C,D,P, SEED);

    }
#else   

    /* NO MPI */                          
    posix_memalign_all(&G,&C,&D,&P);
    initGraph (G,C,D,P, SEED);  

#endif

#if ( defined _USE_OMP && defined _USE_MPI )

    if ( mpi_rank == 0) { 
        // omp_set_num_threads(4);
        printf("\n:: Using [OMP + MPI] ::\n");
        printf("\t* Communicator size = %d\n",    mpi_size);
        int nthreads, tid;
        #pragma omp parallel private(tid)
        {
            /* Only master thread does this */
            tid = omp_get_thread_num();
            if (tid == 0){
                nthreads = omp_get_num_threads();
                printf("\t* Number of threads = %d\n",nthreads);
            }
        } /* All threads join master thread and disband */

    }

#else
    #ifdef _USE_OMP
        printf("\n:: Using [OMP] ::\n");
        printf("\t* Number of threads = %d\n\n", omp_get_max_threads() );
        printf("\nN: %d\nNREP:%d\n", N,NREP);

    #elif _USE_MPI 

        if ( mpi_rank == 0) { 
            printf("\n:: Using [MPI] ::\n");
            printf("\t* Communicator size = %d\n", mpi_size);
            printf("\nN: %d\nNREP:%d\n", N,NREP);
        }
    #else 
        printf("\n:: Serial version ::");
    #endif

#endif

/*_____________________________________
 * 
 *  ESECUZIONE ALGORITMO FLOYD_WARSHALL
 *_____________________________________
*/

    
    int rep;
    for ( rep = 0; rep < NREP; rep++) {


#ifdef _USE_MPI
        if ( mpi_rank == ROOT){
#endif
            clock_gettime(CLOCK_REALTIME, &start);  /* start */

#ifdef _USE_MPI
        }
#endif

        FloydAlgorithmm(G,C,D,P, mpi_size, mpi_rank);

#ifdef _USE_MPI
        if ( mpi_rank == ROOT) {
#endif
            clock_gettime(CLOCK_REALTIME, &end);     /* End */
            elapsed = simple_sub_timespec(start, end);
            sum += elapsed;
#ifdef _USE_MPI
        }
#endif


    }

#ifdef _USE_MPI
    /* Terminazione di tutti i processi tranne quello root */
    MPI_Finalize();
    if ( mpi_rank != ROOT )
        exit(EXIT_SUCCESS);
#endif

    mean = sum/(float)NREP;
    printf("\nmedia: %lf\n", mean);

#ifdef _PRINT_DISTANCE
    stampa_matrice(P,N,N,'P');
    stampa_matrice(G,N,N,'g');
    printAPSP(G,C,D,P);
    stampa_matrice(G,N,N,'G');
    printGraph(G, C, "graph/graph.dot");

    /* stampa della matrice */
    stampa_matrice(D,N,N,'D');
#endif

    return 0;
}

