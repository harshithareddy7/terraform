output "vpc_id"{
    value=aws_vpc.main.id
}

output "publicsubnetA_id"{
    value=aws_subnet.publicsubnetA.id
}

output "publicsubnetB_id"{
    value=aws_subnet.publicsubnetB.id
}

