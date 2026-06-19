import java.util.Arrays;

class BirdWatcher {
    private final int[] birdsPerDay;
    private static final int[] lastWeek = new int[] {0, 2, 5, 3, 7, 8, 4};

    public BirdWatcher(int[] birdsPerDay) {
        this.birdsPerDay = birdsPerDay.clone();
    }

    public static int[] getLastWeek() {
        return lastWeek;
    }

    public int getToday() {
        return Arrays.stream(birdsPerDay).reduce((a, b) -> { return b; }).getAsInt();
    }

    public void incrementTodaysCount() {
        birdsPerDay[birdsPerDay.length-1] += 1;
    }

    public boolean hasDayWithoutBirds() {
        return Arrays.stream(birdsPerDay).anyMatch((bird) -> { return bird == 0; });
    }

    public int getCountForFirstDays(int numberOfDays) {
        return Arrays.stream(birdsPerDay).limit(numberOfDays).sum();
    }

    public int getBusyDays() {
        return Arrays.stream(birdsPerDay).map((bird) -> { if (bird >= 5) return 1; else return 0;  }).sum();
    }
}
