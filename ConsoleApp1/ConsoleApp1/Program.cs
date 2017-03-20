using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System;
using MPI;


namespace ConsoleApp1
{
    class Program
    {
        private static int partner, message, procid, numproc;

        static void Main(string[] args) {

            using (new MPI.Environment(ref args)) {

                Console.WriteLine("Hello, World! from rank " + Communicator.world.Rank 
                 + " (running on " + MPI.Environment.ProcessorName + ")");
                    numproc = Communicator.world.Size;
                    procid = Communicator.world.Rank;
                if (procid < numproc / 2){
                    partner = Communicator.world.Size / 2 + Communicator.world.Rank;
                    Communicator.world.Send(procid, partner, 1);
                    message = Communicator.world.Receive<int>(partner, 1);
                 
                 }
                else if (procid >= numproc / 2){
                    partner = Communicator.world.Rank - Communicator.world.Size / 2;
                    message = Communicator.world.Receive<int>(partner, 1);
                    Communicator.world.Send(Communicator.world.Rank, partner, 1);
                }
                Console.WriteLine("Proc " + procid+" is partner with "+message);
            }

         }

    }
}