import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

public class 二分查找 {

	public static int search(int[] nums, int target) {
		
		if (nums == null || nums.length == 0) return -1;
		
		int left = 0;
		int right = nums.length - 1;
		while (left < right) {
			int mid = left + (right - left) / 2;
			if (nums[mid] < target) {
				left = mid + 1;
			} else {
				right = mid;
			}
		}		
		return nums[left] == target ? left : -1;
	}
	//冒泡
	public static int[] BubbleSort (int[] arr) {
		for (int i = 0; i < arr.length; i++) {            
            for (int j = 0; j < arr.length - i - 1; j++) {
                if (arr[j] > arr[j+1]) {
                	int temp = arr[j];
                	arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
            }
        }
       return arr;
	}
	//选择
	public static int[] SelectSort (int[] arr) {
        for (int i = 0; i < arr.length-1; i++) {            
            for (int j = i + 1; j < arr.length; j++) {
                int temp = arr[i];
                if (arr[i] > arr[j]) {
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
            }
        }
       return arr;
	}
	
	public static int[] twoSum (int[] numbers, int target) {
     Map<Integer, Integer> map = new HashMap<>();
     
     for (int i = 0; i < numbers.length; i++) {
         int cur = numbers[i];
         if (map.containsKey(target-cur)) {
             return new int[]{map.get(target-cur), i};
         }
         map.put(numbers[i], i);
			System.out.println(map);

     }
     throw new RuntimeException("results not exits");
     
	}
	
	public static int maxLength (int[] arr) {
        
		Queue<Integer> queue = new LinkedList<>();
		int res = 0;
		for (int i =0; i< arr.length;i++) {
			int cur = arr[i];
			while(queue.contains(cur)) {
				queue.poll();
			}
			queue.add(cur);
			res = Math.max(res, queue.size());
		}
		System.out.println(res);

		return res;
	
    }
	
	public static int search2 (int[] nums, int target) {
        if (nums.length == 0 || nums == null)  return -1;
        
        int left = 0;
        int right = nums.length - 1;
        
        while (left < right) {
            int mid = left + (right - left) / 2;
            if ( nums[mid] < target) {
                left = mid + 1;
            }else {
            	right = mid;
            }
        }
        return nums[left] == target  ? left : -1;
        
    }
	
	
	public static void main(String[] args) {

//		int[] nums =  {5,5,5,5};
//		int target = 5;
//		int res = search(nums, target);
//		System.out.println(res + "");
		
		int[] nums = {4,5,2,3,1,4,5};
//		System.out.println(MySort(nums).toString());
		int[] n = SelectSort(nums);
//		int[] n = BubbleSort(nums);
//		for (int c : n) {
//			System.out.println(c);
//		}
//		int[] nums1 = {3,2,4};
//		int[] res = twoSum(nums1,8);
//		for (int c : res) {
//			System.out.println(c);
//		}
		
		int[] strings = {1,3,3,4,3,2,6,2,5,2};
		
		maxLength(strings);
		
	}

	
}
