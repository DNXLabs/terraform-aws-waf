variable "options" {
    type = object({
        sql_injection = bool
        cross_site_scripting = bool
        ip_blacklist = object({
            enable = bool
            list = list(string)
        })
    })
    default = {
        sql_injection = "false"
        cross_site_scripting = "false"
        ip_blacklist = {
            enable = "false"
            list = []
        }
    }
}