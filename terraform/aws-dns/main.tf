resource "aws_route53_zone" "main" {
	name = "shortyurl.org"
}

#fetching an already existing resource. so use data instead of resource
data "aws_eip" "webserver_eip" {
	id = "eipalloc-0d781ff8203215ea4"
}

resource "aws_route53_record" "record" {
	zone_id = aws_route53_zone.main.zone_id
	name = "shortyurl.org"
	# A stands for address. Address record. used to map domain to an IPv4 address. 
	type = "A"
	# time to live. caches the record for 300 sec. before querying the DNS again for updated info
	ttl = 300
	records = [data.aws_eip.webserver_eip.public_ip]
}
