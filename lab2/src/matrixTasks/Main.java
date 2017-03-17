package matrixTasks;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Main
{
   public static void main (String arg[]) throws Exception
   {
      int dataA[][] = new int[][]
      {
         {1, 2},
         {1, 2},
         {1, 2},
         {1, 2}
      };
      
      int dataB[][] = new int[][]
      {
         {1,  2, 3},
         {1, 2, 3}
      };
      
      ExecutorService executor = Executors.newFixedThreadPool(3);
      
      Matrix matrixA = new Matrix (dataA);
      Matrix matrixB = new Matrix (dataB);
      System.out.println(matrixA.multiply(matrixB));
      
      executor.shutdown();
   }
}
   
  