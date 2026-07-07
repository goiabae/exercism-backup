const std = @import("std");

pub const HighScores = struct {
    scores: []const i32,
    // This struct, as well as its fields and methods, needs to be implemented.

    pub fn init(scores: []const i32) HighScores {
        return .{ .scores = scores };
    }

    pub fn latest(self: *const HighScores) ?i32 {
        return self.scores[self.scores.len-1];
    }

    pub fn personalBest(self: *const HighScores) ?i32 {
        var best: i32 = 0;
        for (self.scores) |score| {
            best = @max(best, score);
        }
        return best;
    }

    pub fn personalTopThree(self: *const HighScores) []const i32 {
        // std.mem.sort(i32, self.scores, {}, std.sort.asc(i32));
        return self.scores[self.scores.len-3..];
    }
};
