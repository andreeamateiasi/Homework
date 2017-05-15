import java.util.ArrayList;


public class Qs extends Thread {
	private ArrayList<Integer> arr;
	int left;
	int right;

	public Qs(ArrayList<Integer> arr, int left, int right) {
		this.arr = arr;
		this.left = left;
		this.right = right;

	}

	public void run() {
		if (left >= right || left < 0 || right >= arr.size()) {
			return;
		}
		if (right - left < 10) {
			for (int i = left; i <= right; i++) {
				int tmp = arr.get(i);
				int j = i;
				for (; j > 0 && tmp < arr.get(j - 1); j--)
					arr.set(j, arr.get(j - 1));

				arr.set(j, tmp);
			}
			return;
		}
		int pivotIdx = (right + left) / 2;
		int pivot = arr.get(pivotIdx);
		int i = left;
		int j = right;

		while (i < j) {
			while (arr.get(i) < pivot)
				i++;

			while (arr.get(j) > pivot)
				j--;
			if (i >= j)
				break;
			int tmp = arr.get(i);
			arr.set(i, arr.get(j));
			arr.set(j, tmp);
		}
		Qs leftQS = new Qs(arr, left, i - 1 );
		leftQS.start();
		Qs rightQS = new Qs(arr, i + 1, right);
		rightQS.start();

	}

	public static void main(String[] args) {
		ArrayList<Integer> arr = new ArrayList<Integer>();
		for (int i = 10; i > 0; i--) {
			int value = (int) (Math.random() * 10);
			arr.add(value);

		}
		for (int t = 0; t < 10; t++) {
			System.out.println(t + " " + arr.get(t));
		}
		//ThreadGroup group = new ThreadGroup("QuickSorter");
		Thread t = new Qs(arr, 0, arr.size() - 1);
		t.start();
		while (t.isAlive()) {
		}
		for (int k = 0; k < 10; k++)
			System.out.println(arr.get(k));
	}
}
