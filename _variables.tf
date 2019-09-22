variable "options" {
    type = object({
        enable = bool
        sql_injection = bool
        cross_site_scripting = bool
        ip_blacklist = object({
            enable = bool
            list = list(string)
        })
    })
    default = {
        enable = "false"
        sql_injection = "false"
        cross_site_scripting = "false"
        ip_blacklist = {
            enable = "false"
            list = []
        }
    }
}