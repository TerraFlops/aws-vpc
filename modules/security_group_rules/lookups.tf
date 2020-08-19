locals {
  # Create a lookup table of port numbers for use in Security Group rule descriptions, these were hastily ripped from Wikipedia
  lookup_protocol_names = merge({
    "1" = "TCPMUX",
    "5" = "Remote Job Entry",
    "7" = "Echo",
    "9" = "Wake On LAN",
    "11" = "Active Users (Sysstat)",
    "13" = "Daytime Protocol",
    "17" = "Quote Of The Day",
    "18" = "Message Send Protocol",
    "19" = "CHARGEN",
    "20" = "FTP Data Transfer",
    "21" = "FTP Control",
    "22" = "SSH/SCP/SFTP",
    "23" = "Telnet",
    "25" = "SMTP",
    "37" = "Time Protocol",
    "42" = "Host Name Server Protocol",
    "43" = "WHOIS",
    "49" = "TACACS",
    "50" = "IPSec",
    "51" = "IPSec",
    "52" = "Xerox Network Systems Time Protocol",
    "53" = "DNS",
    "54" = "Xerox Network Systems Clearinghouse",
    "56" = "Xerox Network Systems Authentication Protocol",
    "58" = "Xerox Network Systems Mail",
    "61" = "NIFTP Mail",
    "67" = "DHCP",
    "68" = "DHCP",
    "69" = "TFTP",
    "70" = "Gopher",
    "71" = "NETRJS",
    "72" = "NETRJS",
    "73" = "NETRJS",
    "74" = "NETRJS",
    "79" = "Finger",
    "80" = "HTTP",
    "81" = "TorPark Onion Routing",
    "82" = "TorPark Control",
    "83" = "MIT ML Device Network File System",
    "88" = "Kerberos",
    "90" = "PointCast",
    "95" = "SUPDUP",
    "101" = "NIC Host Name",
    "102" = "TSAP",
    "104" = "DICOM"
    "105" = "CCSO Nameserver",
    "110" = "POP3",
    "119" = "NNTP",
    "123" = "NTP",
    "135" = "NetBIOS",
    "136" = "NetBIOS",
    "137" = "NetBIOS",
    "138" = "NetBIOS",
    "139" = "NetBIOS",
    "143" = "IMAP4",
    "161" = "SNMP",
    "162" = "SNMP",
    "389" = "LDAP",
    "443" = "HTTPS",
    "445" = "SMB",
    "636" = "LDAP SSL",
    "1433" = "Microsoft SQL Server",
    "3268" = "LDAP GC",
    "3269" = "LDAP GC SSL",
    "3306" = "MySQL",
    "3389" = "Remote Desktop",
    "5432" = "PostgreSQL"
  }, var.lookup_protocol_names)

  # Create a lookup table of CIDR blocks for use in Security Group rule descriptions
  lookup_cidr_blocks = merge({
    anywhere = {
      name = "Anywhere"
      cidr_block = "0.0.0.0/0"
    },
    google_dns = {
      name = "Google DNS"
      cidr_block = "8.8.8.8/32"
    },
    aws_metadata = {
      name = "AWS Metadata Service"
      cidr_block = "169.265.169.254/32"
    }
  }, var.lookup_cidr_blocks)
}