| # | Layer        | Mnemonic   | Example    | TCP Data Encapsulation    |
| - | ------------ | ---------- | ---------- | ------------------------- |
| 7 | Application  | All        | Browser    | Data                      |
| 6 | Presentation | People     | HTTP       | -                         |
| 5 | Session      | Seem       | Port 80    | -                         |
| 4 | Transport    | To         | TCP/UDP    | Segment: TCP(Data)        |
| 3 | Network      | Need       | Router/IP  | Packet: IP(TCP(Data))     |
| 2 | Data-Link    | Data       | Switch/MAC | Frame: MAC(IP(TCP(Data))) |
| 1 | Physical     | Processing | Cable      | _sound/pulse/light_       |

