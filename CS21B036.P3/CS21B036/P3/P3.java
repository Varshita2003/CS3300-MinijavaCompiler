import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P3 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();
         GJDepthFirst df = new GJDepthFirst();
         Object value = root.accept(df, 1); // Your assignment part is invoked here.
         if(value == null)
        {
              //System.out.println("Type error");
            Object value2 = root.accept(df, 2);
         //   if(value2 == null)
         //    System.out.println("Program type checked successfully");
         }
        
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
