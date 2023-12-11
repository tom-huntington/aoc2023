

hook global BufCreate .*\.noul %{
    set-option buffer filetype noulith
    echo -debug "BufCreat noul"
}


hook global BufSetOption filetype=(noulith) %{
    set-option buffer comment_line '#'
    set-option buffer comment_block_begin '#('
    set-option buffer comment_block_end ')'
}


hook -group noulith-highlight global WinSetOption filetype=noulith %{
    echo -debug "WinSetOption"
    require-module noulith
    add-highlighter window/noulith ref noulith
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/noulith }
}

provide-module noulith %{

    add-highlighter shared/noulith regions
    add-highlighter shared/noulith/code default-region group
    add-highlighter shared/noulith/comment region '#' '$' fill comment



    # String interpolation
    add-highlighter shared/noulith/f_triple_string region -match-capture [fF]("""|''') (?<!\\)(?:\\\\)*("""|''') group
    add-highlighter shared/noulith/f_triple_string/ fill string
    add-highlighter shared/noulith/f_triple_string/ regex \{.*?\} 0:value

    add-highlighter shared/noulith/f_double_string region '[fF]"'   (?<!\\)(\\\\)*" group
    add-highlighter shared/noulith/f_double_string/ fill string
    add-highlighter shared/noulith/f_double_string/ regex \{.*?\} 0:value

    add-highlighter shared/noulith/f_single_string region "[fF]'"   (?<!\\)(\\\\)*' group
    add-highlighter shared/noulith/f_single_string/ fill string
    add-highlighter shared/noulith/f_single_string/ regex \{.*?\} 0:value


    # Regular string
    add-highlighter shared/noulith/triple_string region -match-capture ("""|''') (?<!\\)(?:\\\\)*("""|''') fill string
    add-highlighter shared/noulith/double_string region '"'   (?<!\\)(\\\\)*" fill string
    add-highlighter shared/noulith/single_string region "'"   (?<!\\)(\\\\)*' fill string

    # Integer formats
    add-highlighter shared/noulith/code/ regex '(?i)\b0b[01]+l?\b' 0:value
    add-highlighter shared/noulith/code/ regex '(?i)\b0x[\da-f]+l?\b' 0:value
    add-highlighter shared/noulith/code/ regex '(?i)\b0o?[0-7]+l?\b' 0:value
    add-highlighter shared/noulith/code/ regex '(?i)\b([1-9]\d*|0)l?\b' 0:value
    # Float formats
    add-highlighter shared/noulith/code/ regex '\b\d+[eE][+-]?\d+\b' 0:value
    add-highlighter shared/noulith/code/ regex '(\b\d+)?\.\d+\b' 0:value
    add-highlighter shared/noulith/code/ regex '\b\d+\.' 0:value
    # Imaginary formats
    add-highlighter shared/noulith/code/ regex '\b\d+\+\d+[jJ]\b' 0:value




evaluate-commands %sh{
    # Grammar
    values="True False None self inf"
    meta="import from"

    # attributes and methods list based on https://docs.noulith.org/3/reference/datamodel.html
    attributes="__annotations__ __closure__ __code__ __defaults__ __dict__ __doc__
                __globals__ __kwdefaults__ __module__ __name__ __qualname__"


    # Keyword list is collected using `keyword.kwlist` from `keyword`
    keywords="if else while for yield into switch case null and or coalesce break try catch throw continue return consume pop remove swap every struct freeze import literally _"

    types="R F V"

    functions="abs acos acosh aes128_hazmat_decrypt_block
    aes128_hazmat_encrypt_block aes256_gcm_decrypt
    aes256_gcm_encrypt all and any anything append append_file
    apply asin asinh assert atan atan2 atanh base64_decode
    base64_encode blake3 butlast by bytes cbrt ceil chr
    combinations complex complex_parts const contains cos cosh
    count cycle debug default denominator dict
    discard drop each echo ends_with enumerate eval even exp
    factorize false filter find find? first flat_map flatten
    flip float floor flush fold frequencies from func gcd group
    hex_decode hex_encode id imag_part in index index? input
    insert int int_radix interact iota is is_alnum is_alpha
    is_ascii is_digit is_lower is_prime is_space is_upper
    items iterate join json_decode json_encode keys last
    len lines list ln locate locate? log10 log2 lower map
    map_keys map_values max md5 memoize merge min not not_in
    now nulltype number numerator odd of on only or ord
    pairwise partition permutations prefixes print product
    random random_bytes random_range rational read read_file
    read_file? read_file_bytes read_file_bytes? real_part
    reject repeat replace request reverse round satisfying
    scan search search_all second set sha256 signum sin sinh
    sleep sort split sqrt starts_with str str_radix stream
    strip subsequences subtract suffixes sum tail take tan
    tanh then third til time to transpose trim true type
    uncons uncons? unique unlines unsnoc unsnoc? unwords upper
    utf8_decode utf8_encode values vars vector window with
    words write write_file xor zip ziplongest"

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # Add the language's grammar to the static completion list
    printf %s\\n "declare-option str-list noulith_static_words $(join "${values} ${meta} ${attributes} ${exceptions} ${keywords} ${types} ${functions}" ' ')"

    # Highlight keywords
    printf %s "
        add-highlighter shared/noulith/code/ regex '\b($(join "${values}" '|'))\b' 0:value
        add-highlighter shared/noulith/code/ regex '\b($(join "${meta}" '|'))\b' 0:meta
        add-highlighter shared/noulith/code/ regex '\b($(join "${attributes}" '|'))\b' 0:attribute
        add-highlighter shared/noulith/code/ regex '\b($(join "${keywords}" '|'))\b' 0:keyword
        add-highlighter shared/noulith/code/ regex '\b($(join "${functions}" '|'))\b' 1:function
        add-highlighter shared/noulith/code/ regex '\b($(join "${types}" '|'))\b' 0:type
    "
}

add-highlighter shared/noulith/code/ regex (?<=[\w\s\d\)\]'"_])(<=>|<=|<<|>>|>=|<>?|>|!=|==|\||\^|&|\+|-|\*\*?|//?|%|~) 0:operator
add-highlighter shared/noulith/code/ regex (?<=[\w\s\d'"_])((?<![=<>!]):?=(?![=])|[+*-]=) 0:builtin
add-highlighter shared/noulith/code/ regex ^\h*(?:from|import)\h+(\S+) 1:module
}
