using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MPI;



namespace RoyF
{
    class Program
    {
        public static int procid, numproc,j, n=4;
        //public static int[] local_mat;
        //public static string s;
        public const int INF = 99999;
        public static int[] local_mat = { 0,   5,  1, 10,      INF, 0,   3, INF,       INF, INF, 0,   1,         INF, INF, INF, 0 };
        static void Main(string[] args)
        {

            using (new MPI.Environment(ref args))
            {

                procid = Communicator.world.Rank;
                numproc = Communicator.world.Size;
                //Communicator.world.Barrier();
                Intracommunicator comm = Communicator.world;
                /* if (procid == 0)
                 {
                     Console.WriteLine("How many vertices?\n");
                     n = Convert.ToInt32(Console.ReadLine());
                 }
                 Communicator.world.Broadcast<int>(ref n, procid);*/
                /*if (procid == 0) Console.WriteLine("Enter the local_matrix\n");
                Read_matrix(local_mat, n, procid, numproc, comm);
                */
                Console.WriteLine("Matrix :\n");
                Print_matrix(local_mat, n, procid, numproc, comm);
                /*if (procid == 0) Console.WriteLine("\n");
                Floyd(local_mat, n, procid, numproc, comm);

                if (procid == 0) Console.WriteLine("The solution is:\n");
                Print_matrix(local_mat, n, procid, numproc, comm);*/
            }

        }
        /*public static void Read_matrix(int[] local_mat, int n, int procid, int numproc, Intracommunicator comm)
        {
            int i, j;
            int[] temp_mat = new int[40];
            int num;
            if (procid == 0)
            {

                for (i = 0; i < n; i++)
                    for (j = 0; j < n; j++)
                    {
                        num = i * n + j;
                        temp_mat[num] = Convert.ToInt32(Console.ReadLine());
                    }
                comm.Scatter<int>(temp_mat);
                //free(temp_mat);
            }
            else
            {
                comm.Scatter<int>(temp_mat);
            }

        }*/
        public static void Print_matrix(int[] local_mat, int n, int procid, int numproc, Intracommunicator comm)
        {
            int i, j;
            int[] temp_mat = new int[40];

            if (procid == 0)
            {
                temp_mat = comm.Gather<int>(n, 0);
                for (i = 0; i < n; i++)
                {
                    for (j = 0; j < n; j++)
                        if (temp_mat[i * n + j] == INF)
                            Console.WriteLine("inf ");
                        else
                            Console.WriteLine(temp_mat[i * n + j]);
                    Console.WriteLine("\n");
                }
                temp_mat = null;
            }
            else
            {
                temp_mat = comm.Gather<int>(numproc, 0);
            }
        }
        public static void Floyd(int[] local_mat, int n, int procid, int numproc, Intracommunicator comm)
        {
            int global_k, local_i, global_j, temp;
            int root;
            int[] row_k = new int[40];

            for (global_k = 0; global_k < n; global_k++)
            {
                root = global_k / (n / numproc);
                //root = Owner(global_k, numproc, n);
                if (procid == root)
                    Copy_row(local_mat, n, numproc, row_k, global_k);
                comm.Broadcast<int>(ref row_k, root);
                for (local_i = 0; local_i < n / numproc; local_i++)
                    for (global_j = 0; global_j < n; global_j++)
                    {
                        temp = local_mat[local_i * n + global_k] + row_k[global_j];
                        if (temp < local_mat[local_i * n + global_j])
                            local_mat[local_i * n + global_j] = temp;
                    }
            }
        }
        public static void Copy_row(int[] local_mat, int n, int numproc, int[] row_k, int k)
        {
            int j;
            int local_k = k % (n / numproc);

            for (j = 0; j < n; j++)
                row_k[j] = local_mat[local_k * n + j];
        }
       /* public static int Owner(int k, int numproc, int n)
        {
            return k / (n / numproc);
        }*/

    }
}