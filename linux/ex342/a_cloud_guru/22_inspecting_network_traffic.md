# Inspecting Network Traffic

- *Wireshark* and *tcp dump* both use **pcap** which is packet caputer API for capturing network packets
- There is something wrong with `tshark`, if you run it without root it gives you a **permission denied** and if you run it with root it says **Running as user "root" and group "root". This could be dangerous.**
