use std::collections::{HashMap};
use std::{env, fs::File};
use std::io::{BufRead, BufReader};
use priority_queue::PriorityQueue;

fn dist(start: (usize, usize), target: &(usize, usize), field: &Vec<Vec<u32>>) -> u32 {
    println!("searching from {:?} to {:?}", start, target);

    let height = field.len();
    let width = field[0].len();

    let mut q:PriorityQueue<(usize, usize), i32> = PriorityQueue::new();
    let mut dist: HashMap<(usize, usize), u32> = HashMap::new();
    let mut prev: HashMap<(usize, usize), (usize, usize)> = HashMap::new();

    dist.insert(start, 0);
    q.push(start, 0);

    while q.len() > 0 {
        let ((h, w), prio) = q.pop().unwrap();
        // println!("{}, {}: {}", h, w, prio);
        let curr_elev = field[h][w];
        let curr_dist = dist.get(&(h, w)).unwrap().to_owned();

        let mut ns:Vec<Option<(usize, usize)>> = vec![None;4];
        ns[0] = if h > 0 {
            // println!("up: {:?}", (h-1, w));
            Some((h-1, w))
        } else {
            None
        };
    
        ns[1] = if h < height - 1 {
            // println!("down: {:?}", (h+1, w));
            Some((h+1,w))
        } else {
            None
        };
    
        // left
        ns[2] = if w > 0 {
            // println!("left: {:?}", (h, w-1));
            Some((h, w-1))
        } else {
            None
        };
    
        // right
        ns[3] = if w < width - 1 {
            // println!("right: {:?}", (h, w+1));
            Some((h, w+1))
        } else {
            None
        };

        for n_maybe in ns {
            if n_maybe == None {
                continue
            }
            let (nh, nw) = n_maybe.unwrap();
            let n_elev = field[nh][nw];
            if n_elev > curr_elev + 1 {
                continue
            }
            let n_dist = match dist.get(&(nh, nw)) {
                Some(e) => e.to_owned(),
                None => 10000,
            };
            let alt = curr_dist + 1;
            if alt < n_dist {
                dist.insert((nh, nw), alt);
                prev.insert((nh, nw), (h, w));
                q.push_decrease((nh, nw), -1 * (alt as i32));
            }
        }
    }

    // println!("{:?}", dist);

    match dist.get(target) {
        Some(d) => d.to_owned(),
        None => 10000,
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let problem = &args[2];
    let file = File::open(filename).unwrap();
    let reader = BufReader::new(file);

    let mut width = 0;
    let mut height = 0;

    for line in reader.lines() {
        let ln = line.unwrap();
        height+=1;
        width = ln.len();
    }
    
    let mut field: Vec<Vec<u32>> = vec![vec![0; width];height];

    let f2 = File::open(filename).unwrap();
    let r2 = BufReader::new(f2);

    let mut h = 0;
    // let mut w = 0;
    let mut target = (0, 0);
    // let mut start = (0, 0);
    let mut starts: Vec<(usize, usize)> = vec![];
    for line in r2.lines() {
        let ln = line.unwrap();

        for (i, c) in ln.char_indices() {
            field[h][i] = if c == 'S' {
                starts.push((h, i));
                0 // elevation a
            } else if c == 'E' {
                target = (h, i);
                25 // elevation z
            } else if c == 'a' && problem == "2" {
                starts.push((h, i));
                0
            } else {
                (c as u32) - 97
            }
        }
        h+=1;
    }

    let mut min = 10000;
    for s in starts {
        let distance = dist(s, &target, &field);
        if distance < min {
            min = distance;
        }
        println!("{:?}: {}", s, distance)
    }
    println!("min: {}", min);


}
