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

- Instruction for nameserver to read zones' data file
- Configuration file's format is Bind specific
- Usually a line for the *directory* in which zone files are located
  - This can be overridden, by the `file` parameter within each zone's statement
- Only one `options` statements in the configuration file
- On a primary server one *zone statement* for each zone datafile to be read
  - Starts with *zone* keyword
  - Zone's domain name
  - And the class; *in* stands for internet
    - The default class is *in* for zone statement, and even if you delete the class from the statement, it will be assigned automatically
  - *type* master indicating a primary server
  - And *file* for zone data file
- An example of config for reading *root hints file* i also provided below
  - This comes by default with bind9, and you don't have to add one, but if you do it will override the default one


```bind

options {
  directory "/var/named";
  // Additional Options here
}

zone "movie.edu" in {
  type master;
  file "db.movie.edu"
}

zone "249.249.192.in-addr.arpa" in {
  type master;
  file "db.192.249.249";
}

zone "253.253.192.in-addr.arpa" in {
  type master;
  file "db.192.253.253";
}

zone "0.0.127.in-addr.arap" in {
  type master;
  file "db.127.0.0";
}

zone "." in {
  type hint;
  file "db.cache"
}
```

## Abbreviations

- Revising the zone data files

### Appending Domain Names

- The second field of a *zone* statement specifies a domain name
  - Key to most useful shortcut
  - Origin of all the data in the zone datafile
  - The origin is appended to all names in the zone file, that don't end with a dot
- So instead of entring `shrek.movie.edu. IN A 192.249.249.2` in `db.movie.edu` we could just add `shrek IN A 192.249.249.2`
- And instead of `2.249.249.192.in-addr.arpa. IN PTR shrek.movie.edu.` we could just add `2 IN PTR shrek.movie.edu.` in the `db.192.249.249` file
- What if we forget to add the dot, in a fully typed entry, so an entry like this `shrek.movie.edu IN A 192.249.249.2` would be translated into an entry like `shrek.movie.edu.movie.edu` not what you intended at all

### The @ Notation

- If a domain name is as the origin
- Can be used in the SOA record

### Repeat Last Name

- A Resource Record Name is a space bar or tab --> The name from the last recrod resource is used

```bind
wormhole  IN  A   192.249.249.1
          IN  A   192.253.253.1
```

- Can be used even if the resource records are different


### The shortened Zone Datafiles

- Let's go through our zone datafiles

```bind
$TTL    3h
;
; Origin added to names not ending
; in a dot: movie.edu

@ IN  SOA toystory.movie.edu. al.movie.edu. (
                          1         ; Serial
                          3h        ; Refresh after 3 hours
                          1h        ; Retry after 1 hour
                          1w        ; Expire after 1 week
                          1h )      ; Negative caching TTL of 1 hour

; Nameserves (The @ is Implied)
;
                  IN    NS    toystory.movie.edu.
                  IN    NS    wormhole.movie.edu.

; Addresses for the canonical names
;
localhost       IN    A     127.0.0.1
shrek           IN    A     192.249.249.2
toystory        IN    A     192.249.249.3
monsters-inc    IN    A     192.249.249.4
misery          IN    A     192.253.253.2
shining         IN    A     192.253.253.3
carrie          IN    A     192.253.253.4

wormhole        IN    A     192.249.249.1

; Aliases
;
toys            IN    CNAME toystory
mi              IN    CNAME monsters-inc
wh              IN    CNAME wormhole

; Interface specific names
;
wh249           IN    A     192.249.249.1
wh253           IN    A     192.253.253.1
```

## Hostname Checking

- For conformance to RFC 952
  - If not conforming, considered as a syntax error by bind
- Name field and data field in Resource Records
- Hostnames are in the `name` field of `A` records and `MX` records
- Hostnames are also in the `data` field of `SOA` and `NS` records
- `CNAME`s don't have to conform to the host-naming rules, because they point to names that are not hostnames

```bind
<name>      <class>     <type>      <data>
toystory      IN          A           192.249.249.3
```

- Allowed to
  - Contain alphabetic
  - Numeric
- Underscores are not allowed
- Hyphen allowed if in the middle
- names that are not hostnames can consist of any ASCII chars
- There is a way to turn the errors into warning messages for the hostnames (This shouldn't be used for ever)
- The second statement would completely ignore them
- If you are backup for a zone and getting errors with the hostnames and you don't have controll over it, you can still do that, only use `slave` instead of `master`
  - As in 3rd statement
- The same can be done for responses for queries
  - As in 4th statement

```bind
options {
  check-names master warn;
  check-names master ignore;
  check-names slave ignore;
  check-names response ignore;
};
```

- Bind defaults are

```bind
  options {
  check-names master fail;
  check-names slave warn;
  check-names response ignore;
  };
```

- Name checking can also be specified in a per-zone basis, which would override the global configuration
- The reason for having 2 fields in the zone specific error handling configuration, whereas we have 3 fields in the global configuration is that the context is already defined in the zone
  - Can be seen in the following example
  - The context is master and it is defined in teh first line of the zone statement

```bind
  zone "movie.edu" in {
    type master;
    file "db.movie.edu"
    check-names fail
  };
```

## Tools

- *h2n*
  - For converting `/etc/hosts` into the zone file
  - But I think it is not used widely today

## Bind 9 Tools

- `named-checkconf`
- `named-checkzone`
