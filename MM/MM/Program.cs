using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MPI;

namespace MM
{
    class Program
    {
        public static int procid, numproc, start, finish, n=4, size, i, j, k;
        public static int[,] a = { { 1, 1, 1, 1 },
                                   { 1, 1, 1, 1 },
                                   { 1, 1, 1, 1 },
                                   { 1, 1, 1, 1 }  };
        public static int[,] b = { { 1, 0, 0, 0 },
                                   { 0, 1, 0, 0 },
                                   { 0, 0, 1, 0 },
                                   { 0, 0, 0, 1 }  };
        public static int[,] c = { { 0, 0, 0, 0},
                                   { 0, 0, 0, 0},
                                   { 0, 0, 0, 0},
                                   { 0, 0, 0, 0}};
        static void Main(string[] args)
        {
            using (new MPI.Environment(ref args))
            {
                Intracommunicator comm = Communicator.world;
                procid = comm.Rank;
                numproc = comm.Size;
                comm.Barrier();
                matrixM(a, b, c, comm);
                

            }
        }
        public static void PrintMatrix(int[,] c)
        {
            for (i = 0; i < n; ++i)
            {
                for (j = 0; j < n; ++j)
                {
                    Console.WriteLine("proc rank "+ procid);
                   Console.WriteLine("c["+i+"]["+j+"] = "+c[i,j]);
                }
            }
        }
        public static void matrixM(int[,] a, int[,] b, int[,] c, Intracommunicator comm)
        {
            size = n / numproc;
            start = procid * size;
            finish = (procid + 1) * size;
            Console.WriteLine("proc with rank"+procid+" is getting from "+start+" to "+ finish);
            
            for (i = start; i < finish; ++i)
            {
                for (j = 0; j < n; ++j)
                {
                    for (k = 0; k < n; ++k)
                    {
                        c[i,j] += a[i,k] * b[k,j];
                    }
                }
            }
            PrintMatrix(c);
        }

    }
}
