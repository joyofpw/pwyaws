% This file is similar to a .htaccess file
% https://medium.com/@dr.linux/how-to-run-laravel-on-yaws-33cd61e75e37
% https://thestaticvoid.com/post/2009/08/04/replacing-apache-with-yaws/

-module(processwire).
-export([out/1]).
-include("/usr/local/lib/erlang/lib/yaws-2.1.1/include/yaws_api.hrl").

out(Arg) ->
    FullPathFileName = Arg#arg.docroot ++ Arg#arg.pathinfo,
    IsStaticFile = filelib:is_regular(FullPathFileName),
    if
        % The request equals to a static file
        % Let Yaws the serve file
        IsStaticFile == true ->
            [
                {page, Arg#arg.server_path}
            ];
        % Request is not equal a static file, call cgi responder
        true ->
            yaws_api:call_fcgi_responder(Arg, [
                {extra_env, [
                    {"SCRIPT_FILENAME", Arg#arg.docroot ++ "/index.php"}
                ]}
            ])
end.
