use std::collections::{VecDeque, HashSet};
use std::{env, fs::File};
use std::io::{self, BufRead};

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let file = File::open(filename).unwrap();
    let mut buf: String = "".to_string();
    let _ = io::BufReader::new(file).read_line(&mut buf).unwrap();
    let mut marker: VecDeque<char> = VecDeque::new();

    let mut answer: usize = 0;
    let marker_length = 4; // or 14

    print!("{}", buf);
    for c_pos in buf.char_indices() {
        // print!("{:?}", c_pos);
        let (i, c) = c_pos;
        marker.push_back(c);
        if marker.len() <= marker_length {
            continue;
        }

        marker.pop_front();

        let mut letters: HashSet<char> = HashSet::new();
        for c in marker.iter() {
            letters.insert(*c);
        }
        if letters.len() == marker_length {
            answer = i;
            break;
        }
        // print!("lol");
        // print!("{} {} {} {}", marker[0], marker[1], marker[2], marker[3]);
        
        
    }

    print!("{}", answer + 1);
}
