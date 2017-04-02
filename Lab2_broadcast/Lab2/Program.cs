using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MPI;

namespace Lab2
{
    class Program
    {
        static int rank, size;
        static int  nvalues;
        static int[] b = new int[50];
        static int i, j, dummy;
        static bool inrange, myfound;
        static void Main(string[] args)
        {
            using (new MPI.Environment(ref args))
            {

                rank = Communicator.world.Rank;
                size = Communicator.world.Size;
                Communicator.world.Barrier();
                myfound = false;
                if (rank == 0)
                {
                    for (i = 0; i < 50; ++i)
                    {
                        Random rnd = new Random();
                        b[i] = rnd.Next(1,10);
                        Console.WriteLine("rand "+ i+" = "+b[i]);
                    }
                }
                Communicator.world.Broadcast<int[]>(ref b, 0);
                Communicator.world.ImmediateReceive<int>(rank, 1);
                nvalues = 50 / size;
                i = rank * nvalues;
                Console.WriteLine("i : "+i);
                inrange = ((i <= ((rank + 1) * nvalues - 1)) & (i >= rank * nvalues));
                while (inrange)
                {
                    if (b[i] == 1)
                    {
                        dummy = 23;
                        for (j = 0; j < size; ++j)
                        {
                            Communicator.world.Send<int>(dummy, j, 1);
                        }
                        Console.WriteLine("P: "+ rank+" found it  !! "+b[i]+" !! at global index "+j+"\n");
                        
                        myfound = true;
                    }
                  ++i;
                  inrange = (i <= ((rank + 1) * nvalues - 1) && i >= rank * nvalues);
                }
                if (!myfound)
                {
                    Console.WriteLine("P: "+ rank+" stopped at global index "+(i-1)+ "\n");
                }
            }

        }
    }
}



