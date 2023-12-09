
import java.util.Vector;

public class SetOperations {
    public static Vector<Integer> setMinus(Vector<Integer> set1, Vector<Integer> set2) {
        Vector<Integer> difference = new Vector<>(set1);
        difference.removeAll(set2);
        return difference;
    }

    public static void main(String[] args) {
        Vector<Integer> set1 = new Vector<>();
        // set1.add(1);
        // set1.add(2);
        // set1.add(3);

        Vector<Integer> set2 = new Vector<>();
        set2.add(3);
        set2.add(4);
        set2.add(5);

        Vector<Integer> minus = setMinus(set1, set2);
        System.out.println("Set Minus: " + minus);
    }
}
