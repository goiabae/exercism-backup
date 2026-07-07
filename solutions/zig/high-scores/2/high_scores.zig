const std = @import("std");

pub const HighScores = struct {
    scores: []const i32,
    top: [3]i32,

    pub fn init(scores: []const i32) HighScores {
        var hs: HighScores = .{ .scores = scores, .top = .{ 0, 0, 0 } };
        var fst: i32 = 0;
        var snd: i32 = 0;
        var trd: i32 = 0;
        for (scores) |score| {
            if (score > fst) {
                trd = snd;
                snd = fst;
                fst = score;
            } else if (score > snd) {
                trd = snd;
                snd = score;
            } else if (score > trd) {
                trd = score;
            }
        }
        hs.top[0] = fst;
        hs.top[1] = snd;
        hs.top[2] = trd;
        return hs;
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
        return self.top[0..@min(3, self.scores.len)];
    }
};
