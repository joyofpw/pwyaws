# ProcessWire in Yaws
[YAWS (Yet Another Webserver)](https://github.com/erlyaws/yaws) is a HTTP 1.0/1.1 webserver which is completely written in [Erlang](https://www.erlang.org/). YAWS has been noted well suited for dynamic-content web applications in many cases.

Most developers who are moving from other web development environments to Erlang and Yaws will have used other web servers such as Nginx or Apache. The Erlang Yaws web server performs the same basic tasks, but the details of performing common actions are often different.

Erlang is not only a language, but also a runtime system and something that looks a lot like an application server. As such, Erlang and Yaws (or other web servers) will fill the same role as Apache/PHP/MySQL and other components all in one system.

The major differences between Erlang/Yaws and Apache/PHP have a lot to do with how Erlang tends to set things up. Erlang assumes that systems will be clustered, and processes in Erlang are somewhat different from those used in many other systems.

If you’ve used Apache with mod_php, you may remember that each request is handled by a process or thread (depending on how things are set up). The classic Common Gateway Interface (CGI) would start a new process for every request. These threads and processes are constructions of the OS and are relatively heavyweight objects. In Erlang the processes are owned not by the OS, but by the language runtime.

Because Yaws uses Erlang's lightweight threading system, it performs well under high concurrency. A load test conducted in 2002 comparing Yaws and Apache found that with the hardware tested, Apache failed at 4,000 concurrent connections, while Yaws continued functioning with over 80,000 concurrent connections.

## Erlang

The recommended way is using a package manager with a pre built _erlang_ installation.
Is recommended _Erlang_ 22 or newer.

- https://github.com/asdf-vm/asdf
- https://github.com/asdf-vm/asdf-erlang
- https://www.pluralsight.com/guides/installing-elixir-erlang-with-asdf

You can also follow the instructions at the [Erlang installation guide](https://www.erlang.org/doc/installation_guide/install).

Once you have _Erlang_ installed, you must install _YAWS_.

Follow futher instructions at https://github.com/erlyaws/yaws/

### Port fowarding

If you need to forward port 80 to 8080 on the firewall:

```shell
iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 8080
```

### Bragful

If you want to execute your PHP code inside _Erlang_, you can also use [Bragful](https://bragful.com/)
to interpret PHP code.

### Note

[.htaccess](https://github.com/processwire/processwire/blob/master/htaccess.txt) files are know as `appmods` in __yaws__. The provided file at `yaws/appmods/processwire.erl` is just a minimal `mod_rewrite`. It does not includes all the security considerations of the official _.htaccess_ file. Feel free to send a **Pull Request** to have a proper `appmod` for _ProcessWire_.

## Why?

Mixing Erlang and PHP is a powerful combination. PHP has a vast web development ecosystem and Erlang
has more than 30 years of production ready concurrency solutions that scale well.

## References

- https://github.com/erlyaws/yaws/
- https://medium.com/@dr.linux/how-to-run-laravel-on-yaws-33cd61e75e37
- https://thestaticvoid.com/post/2009/08/04/replacing-apache-with-yaws/
- https://www.oreilly.com/library/view/building-web-applications/9781449320621/ch02.html
- https://www.infoq.com/articles/vinoski-erlang-rest/
- https://lionet.livejournal.com/42016.html
- https://web.archive.org/web/20150518194538/https://www.sics.se/~joe/apachevsyaws.html
- http://steve.vinoski.net/pdf/IC-Yaws.pdf
- https://en.wikipedia.org/wiki/Yaws_(web_server)
- https://erlang.org/euc/02/yaws.pdf
- http://web.archive.org/web/20110811064942/http://kkovacs.eu/running-yaws-with-drupal-wordpress-zend-framework
- https://weblambdazero.blogspot.com/2008/08/php-zend-framework-on-yaws.html
- https://github.com/segeda/docker-yaws
- https://blog.lfe.io/tutorials/2015/11/28/2110-lfe-yaws-docker-update/
- https://github.com/lfe-deprecated/lfeyawsdemo
- https://github.com/Houdini/configs/tree/master/yaws

## Credits
Made with <i class="fa fa-heart">&#9829;</i> by <a href="https://ninjas.cl" target="_blank">Ninjas.cl</a>.
