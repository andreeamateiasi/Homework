using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MPI;
namespace R_F
{
    class Program
    {
        public const int INF = 99999;
        public static int[,] graph = {
            { 0,   5,  INF, 10 },
            { INF, 0,   3, INF },
            { INF, INF, 0,   1 },
            { INF, INF, INF, 0 }
        };
        static int procid, numproc, n = 4,j, k;

        static void Main(string[] args)
        {

            k = 0;
            
              
            using (new MPI.Environment(ref args))
            {
                Intracommunicator comm = Communicator.world;
                procid = Communicator.world.Rank;
                numproc = Communicator.world.Size;
                FloydWarshall(graph, 4,procid,numproc, comm);


              /*  for (k = 0; k < 4; k++)
                {
                    Console.WriteLine("heeeeeeeeereeee\n hereeeeee    " + k);
                   
                    
                }
                for (j = procid; j <= procid+1; j++)
                {
                   
                    Console.WriteLine("procid :" + procid);
                }*/

            }
            
        }
       

        private static void Print(int[,] distance, int verticesCount, int procid)
        {
            //Console.WriteLine("Shortest distances between every pair of vertices:");
           // Console.WriteLine("procid = " + procid);

            for (int i = 0; i < verticesCount; ++i)
            {
                for (int j = 0; j < verticesCount; ++j)
                {
                    if (procid == 0)
                    {
                       // Console.WriteLine("procid = " + procid + "\n");

                        if (distance[i, j] == INF)
                            Console.Write("INF".PadLeft(7));
                        else
                            Console.Write(distance[i, j].ToString().PadLeft(7));
                        //Console.WriteLine("\n");
                    }
                    Console.WriteLine("\n");
                }

                //Console.WriteLine();
            }
        }

        public static void FloydWarshall(int[,] graph, int verticesCount, int procid, int numproc, Intracommunicator comm)
        {
            int[,] distance = new int[verticesCount, verticesCount];

            int size = 4/numproc;
            int start = procid * size;
            int finish = (procid + 1) * size;
            //Console.WriteLine("here");
           // Console.WriteLine("procid = "+procid);
            for (k = 0; k < verticesCount; k++)
            {
                Communicator.world.Barrier();
                
                    for (int i = start; i < finish; ++i)
                        for (int j = 0; j < verticesCount; ++j)
                        {
                            
                                 //Console.WriteLine("line "+i+" for procid "+procid);
                                //Console.WriteLine("procid = " + procid);
                                 distance[i, j] = graph[i, j];
                                //Console.WriteLine("graph[" + i + ", " + j + "] = " + graph[i, j]);
                            
                        }
                
            }

            for (k = 0; k < verticesCount; k++)
            {
                for (int i = start; i < finish; ++i)
                {
                    for (int j = 0; j < verticesCount; ++j)
                    {
                        if (distance[i, k] + distance[k, j] < distance[i, j])
                            distance[i, j] = distance[i, k] + distance[k, j];
                        //Console.WriteLine("min distance["+i+", "+j+"] = "+ distance[i, j]);
                    }
                }
            }
            comm.Gather<int[,]>(distance, 0);
            Print(distance, verticesCount, procid);
           
        }
    }
}
