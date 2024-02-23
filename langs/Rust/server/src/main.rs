use std::io::{BufRead, Write};

fn main() {
    print!("Hello, World!\r\n");
    let listener = std::net::TcpListener::bind("127.0.0.1:9999").unwrap();
    for mut stream in listener.incoming().flatten() {
        let mut rdr = std::io::BufReader::new(&mut stream);
        let mut l = String::new();
        rdr.read_line(&mut l).unwrap();
        print!("HTTP method: {l}");
        match l.trim().split(' ').collect::<Vec<_>>().as_slice() {
            ["GET", resource, "HTTP/1.1"] => {
                loop {
                    let mut l = String::new();
                    rdr.read_line(&mut l).unwrap();
                    if l.trim().is_empty() { break; }
                }
                let mut p = std::path::PathBuf::new();
                p.push("site-src");
                p.push(resource.trim_start_matches("/"));
                print!("req'd resource: {resource}");
                if resource.ends_with('/') { p.push("index.html"); }
                stream.write_all(b"HTTP/1.1 200 OK\r\n\r\n").unwrap();
                stream.write_all(&std::fs::read(p).unwrap()).unwrap();
            },
            _ => todo!()
        }
    }
}
