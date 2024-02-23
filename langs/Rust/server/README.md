```text
$ cargo build && RUST_BACKTRACE=1 cargo run
   Compiling server v0.1.0 (/mnt/c/Users/JohnHupperts/Documents/Programming_Projects/Tips-Tricks/langs/Rust/server)
    Finished dev [unoptimized + debuginfo] target(s) in 3.40s
    Finished dev [unoptimized + debuginfo] target(s) in 0.07s
     Running `target/debug/server`
Hello, World!
HTTP method: GET / HTTP/1.1
```

```text
$ curl -v localhost:9999
* Host localhost:9999 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:9999...
* connect to ::1 port 9999 from ::1 port 34132 failed: Connection refused
*   Trying 127.0.0.1:9999...
* Connected to localhost (127.0.0.1) port 9999
> GET / HTTP/1.1
> Host: localhost:9999
> User-Agent: curl/8.6.0
> Accept: */*
>
< HTTP/1.1 200 OK
* no chunk, no close, no size. Assume close to signal end
<
<b>hello world</b>
* Closing connection
```
