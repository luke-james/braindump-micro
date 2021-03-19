resource "aws_elb" "load-balancer" {

    name = "${ var.service }-elb"

    access_logs {
        bucket = "${ var.id }"
        bucket_prefix = "${ var.service }-"
    }

    # Listen to incoming traffic on port 80 & forward to our target group on a given port.
    listener {
        instance_port = var.instance_port
        instance_protocol = "http"
        lb_port = var.lb_port
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:${ var.instance_port }/"
        interval = 30
    }

    tags = {
        Name = "${ var.id }-${ var.service }"
    }
}