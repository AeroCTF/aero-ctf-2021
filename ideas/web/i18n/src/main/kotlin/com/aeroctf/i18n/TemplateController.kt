package com.aeroctf.i18n

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.CookieValue
import org.springframework.web.bind.annotation.GetMapping

@Controller
class TemplateController {

    @GetMapping("/about")
    fun about(@CookieValue(value = "lang", defaultValue = "ru") lang: String): String {
        return "$lang/about"
    }

    @GetMapping("/contact")
    fun contact(@CookieValue(value = "lang", defaultValue = "ru") lang: String): String {
        return "$lang/contact"
    }

    @GetMapping(value = ["/index", "/"])
    fun index(@CookieValue(value = "lang", defaultValue = "ru") lang: String): String {
        return "$lang/index"
    }

}