# Setting up Bind

## Setting up Zone Data

- Configuration file which is usually named `named.conf`
- Zone file format is common to all DNS implementations
  - Called the *master file format*

## The zone datafiles

- Most entries in zone datafiles are called *DNS resource records*
- Case *insensitive*
- Reousrce records must start in the first column of a file
- The order of resource records in the zone datafiles is as follows:
  * SOA record
    - *Authority* for this zone file
  * NS record
    - *Nameserver* for this zone file
  * Other records
    - Data about hosts in this zone
  * A
    - Name-to-address mapping
  * PTR
    - Address-to-name mapping
  * CNAME
    - Canonical name (for aliases)

## Setting the zone's default TTL

- `$TTL` control statment specifies the time to live for all records in the file that follow the statement and don't have an explicit TTL
- So the first step would be to define the `$TTL`
- This would be supplied to other servers in query responses, allowing other servers to cache the data for the TTL interval

## SOA records

- After TTL the next record would be the start of authority resource record
- It indicates that this nameserver is the best source of information for the data within this zone
- Our nameserver is *authoritative* for the zone *movie.edu* because of the SOA record
- An SOA is required in each db.DOMAIN and db.ADDR file
- There can be one and only one, SOA record in a zone datafile
- IN stand for Internet
  - This is one class of data; other classes exist, but none of them is currently in widespread use
  - The class field is optional, and if it is removed the nameserver determines the class from the statement in the configuration file that instructs it to read this file
- The first name after SOA `toystory.movie.edu.` is the name of the primary nameserver for *movie.edu*
- The second name `al.movie.edu.` is the mail address of the person in charge of the zone
  - Meant for human consumption
  - Bind provides another resource record type `RP` which stands for *Responsible Person*
- The parantheses allow the SOA record to span more than one line
  - Most of the fields within them are for use by slave nameservers
- Same as the `db.movie.edu` we add Similar SOA records to the beginning of the `db.192.249.249` and `db.192.253.253`
  - In these files we change th first name in the SOA record from `movie.edu.` to the name of the appropriate *in-addr-arpa* zone:
    * `249.249.192.in-addr.arpa.`
    * `253.253.192.in-addr.arpa.`

## NS Records
- The next entries we add to each file are NS (nameserver) records
- One NS record for each nameserver authoritative for our zone
- Indicating that there are two nameservers for the zone *movie.edu*
- Like the SOA record we also the NS record to our `db.192.249.249` and `db.192.253.253` files too

## Addresses and Alias Records

- name-to-address mappings
- *`wormhole.movie.edu`* is a **multihomed** host. It has two addresses associated with its name and therefore two address records
- **CNAME** record maps an alias to its canonical name
  - When a nameserver looks up a name and finds a CNAME record, it replaces the name with the canonical name and looks up the new name
  - Aliases should neve appear on the right side of a resource record; Stated differently, you should always use the canonical name in the data portion of the resource record
- The last two records solve a special problem `wh249.movie.edu.` and `wh253.movie.edu.`
  - Each of them corresponds to one address and it is useful for troubleshooting
  - If a host is multihomed, create an address (A) record for each alias unique to one address (like `wh249.movie.edu.          IN  A     192.249.249.1` ) and then create a CNAME record for each alias common to all the addresses (like `wh.movie.edu.             IN  CNAME wormhole.movie.edu.`)

```bind
$TTL 3h                                                                         ; defining 3 hours of TTL
movie.edu.  IN  SOA toystory.movie.edu. al.movie.edu.  (
                          1           ; Serial
                          3h          ; Refresh after 3 hours
                          1h          ; Retry after 1 hour
                          1w          ; Expire after 1 week
                          1h )        ; Negative caching TTL of 1 hour

; NS (nameserver) records
;
movie.edu.  IN  NS  toystory.movie.edu.
movie.edu.  IN  NS  wormhole.movie.edu.

; name-to-address records
;
localhost.movie.edu.      IN  A 127.0.0.1
shrek.movie.edu.          IN  A 192.249.249.2
toystory.movie.edu.       IN  A 192.249.249.3
monsters-inc.movie.edu.   IN  A 192.249.249.4
misery.movie.edu.         IN  A 192.253.253.2
shining.movie.edu.        IN  A 192.253.253.3
carrie.movie.edu.        IN  A 192.253.253.4

; Multi-homed hosts
;
wormhole.movie.edu.       IN  A 192.249.249.1
wormhole.movie.edu.       IN  A 192.253.253.1

; Aliases
;
toys.movie.edu.           IN  CNAME toystory.movie.edu.
mi.movie.edu.             IN  CNAME monsters-inc.movie.edu.
wh.movie.edu.             IN  CNAME wormhole.movie.edu.
wh249.movie.edu.          IN  A     192.249.249.1
wh253.movie.edu           IN  A     192.253.253.1
```

## PTR Records

- Address to name mappings
- `db.192.249.249`
- DNS records for address-to-name mappings are **PTR (Pointer)** records
- One record for each network interface on this network
- A couple of things to pay attention to
  * Addresses should point to only a single name: *canonical* name
    * You can create two PTR records like one for *wormhole.movie.edu* and *wh249.movie.edu*
  * Even though *wormhole.movie.edu* has two addresses, you see only one of them, because this file only shows addresses on the network 192.249.249/24
- The same data should be created for 192.253.253/24 network

```bind
$TTL 3h
249.249.192.in-addr.arpa. IN  SOA toystory.movie.edu. al.movie.edu. (
                          1             ; Serial
                          3h            ; Refresh after 3 hours
                          1h            ; Retry after 1 hour
                          1w            ; Expire after 1 week
                          1h )          ; Negative caching TTL of 1 hour

; Name servers
;
249.249.192.in-addr.arpa. IN  NS  toystory.movie.edu.
249.249.192.in-addr.arpa. IN  NS  wormhole.movie.edu.

; Addresses point to canonical name
;
1.249.249.192.in-addr.arpa. IN  PTR wormhole.movie.edu.
2.249.249.192.in-addr.arpa. IN  PTR shrek.movie.edu.
3.249.249.192.in-addr.arpa. IN  PTR toystory.movie.edu.
4.249.249.192.in-addr.arpa. IN  PTR monsters-inc.movie.edu.
```

- Content of `db.192.253.253`

```bind
$TTL  3h
253.253.192.in-addr.arpa. IN  SOA toystory.movie.edu. al.movie.edu. (
                          1             ; Serial
                          3h            ; Refresh after 3 hours
                          1h            ; Retry after 1 hour
                          1w            ; Expire after 1 week
                          1h )          ; Negative caching TTL of 1 hour

; Name servers
;
253.253.192.in-addr.arpa. IN  NS  toystory.movie.edu.
253.253.192.in-addr.arpa. IN  NS  wormhole.movie.edu.

; Addresses point to canonical name
;
1.253.253.192.in-addr.arpa. IN  PTR wormhole.movie.edu.
2.253.253.192.in-addr.arpa. IN  PTR misery.movie.edu.
3.253.253.192.in-addr.arpa. IN  PTR shining.movie.edu.
4.253.253.192.in-addr.arpa. IN  PTR carrie.movie.edu.
```

## The Loopback Address

- For covering loopback traffic on hosts

```bind
$TTL  3h
0.0.127.in-addr.arpa. IN  SOA toystory.movie.edu. al.movie.edu. (
                      1             ; Serial
                      3h            ; Refresh after 3 hours
                      1h            ; Retry after 1 hour
                      1w            ; Expire after 1 week
                      1h )          ; Negative  caching TTL of 1 hour

0.0.127.in-addr.arpa.   IN  NS  toystory.movie.edu.
0.0.127.in-addr.arpa.   IN  NS  wormhole.movie.edu.

1.0.0.127.in-addr.arpa. IN  PTR localhost.
```

## The **Root Hints** Data

- Nameservers for the root zone
- The file is at `/usr/share/dns/root.hints`
- You can put data other than root nameserver data in this file, but it won't be used
- The nameserver stores the data read from this file in a special place in memory as *root hints*

## Setting up a BIND configuration file

-
