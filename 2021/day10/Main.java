import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.io.IOException;
import java.util.*;

public class Main {

    public enum Brackets {
        CURLY, SQUARE, PAREN, GT
    }

    public static final String INPUT = "/Users/kpcraig/workspace/advent/2021/day10/input";
    public static final String SAMPLE = "/Users/kpcraig/workspace/advent/2021/day10/sample";

    public static void main(String[] args) throws IOException{
        List<String> lines = asLines(INPUT);
        int score = 0;
        List<Long> goodScores = new ArrayList<>();
        // int goodScore = 0;
        for (String s : lines) {
            char[] chars = s.toCharArray();
            Stack<Brackets> st = new Stack<>();
            boolean bad = false;
            lineTest: 
            for (char c: chars) {
                switch (c) {
                    case '[':
                        st.push(Brackets.SQUARE);
                        break;
                    case '{':
                        st.push(Brackets.CURLY);
                        break;
                    case '<':
                        st.push(Brackets.GT);
                        break;
                    case '(':
                        st.push(Brackets.PAREN);
                        break;
                    case ']':
                        if(st.isEmpty() || st.peek() != Brackets.SQUARE) {
                            score += score(c);
                            bad = true;
                            break lineTest;
                        } else {
                            st.pop();
                            break;
                        }
                    case '}':
                        if(st.isEmpty() || st.peek() != Brackets.CURLY) {
                            score += score(c);
                            bad = true;
                            break lineTest;
                        } else {
                            st.pop();
                            break;
                        }
                    case '>':
                        if(st.isEmpty() || st.peek() != Brackets.GT) {
                            score += score(c);
                            bad = true;
                            break lineTest;
                        } else {
                            st.pop();
                            break;
                        }
                    case ')':
                        if(st.isEmpty() || st.peek() != Brackets.PAREN) {
                            score += score(c);
                            bad = true;
                            break lineTest;
                        } else {
                            st.pop();
                            break;
                        }
                    default:
                        break;
                }
            }
            if(bad) {
                continue;
            }
            long goodScore = 0;
            // line is incomplete
            while(!st.empty()) {
                Brackets b = st.pop();
                goodScore *= 5;
                switch(b) {
                    case CURLY:
                        goodScore += 3;
                        break;
                    case SQUARE:
                        goodScore += 2;
                        break;
                    case PAREN:
                        goodScore += 1;
                        break;
                    case GT:
                        goodScore += 4;
                        break;
                }
            }
            // if(goodScore != 0) {
                goodScores.add(goodScore);
            // }
        }
        System.out.println(score);
        Collections.sort(goodScores);
        System.out.println(goodScores);
        System.out.println(goodScores.size());
        System.out.println(goodScores.get(goodScores.size() / 2));
    }

    public static List<String> asLines(String filename) throws IOException {
        Path p = Paths.get(filename);
        return Files.readAllLines(p);
    }

    public static int score(char c) {
        System.out.println("scoring");
        switch (c) {
            case ']':
                return 57;
            case '}':
                return 1197;
            case '>':
                return 25137;
            case ')':
                return 3;
            default:
                return 0;
        }
    }
}