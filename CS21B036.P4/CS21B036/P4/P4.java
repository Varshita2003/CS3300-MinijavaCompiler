import syntaxtree.*;
import visitor.*;
import java.util.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         GJDepthFirst df = new GJDepthFirst();
         Object value = root.accept(df, 1); // Your assignment part is invoked here.
         // if(value == null)
         // {
         Object value2 = root.accept(df, 2);
         //    if(value2 == null)
         //    System.out.println("Program type checked sucessfully");
         // }
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
}
