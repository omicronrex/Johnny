//make list of source files
var f,dir,output,files,fn,is_c,mode,helpline,comments,looking_for_main_comment,str,out,i,b,b2,funcs;

f=file_text_open_read(argument0)
dir=filename_dir(argument0)+"\"

extname=file_text_read_string(f) file_text_readln(f)

output=argument1+"gm82hub\help\"+extname+".hlp"
files=ds_list_create()
do {
    ds_list_add(files,file_text_read_string(f)) file_text_readln(f)
} until file_text_eof(f)

//show_message("Johnny v0.2##"+dslist(files))

//go through source files collecting functions
funcs=ds_list_create()

repeat (ds_list_size(files)) {fn=ds_list_find_value(files,0) ds_list_delete(files,0)
    f=file_text_open_read(dir+fn)

    if (filename_ext(fn)==".c" || filename_ext(fn)==".cpp") is_c=1
    else is_c=0

    mode=0

    helpline=""
    comments=""
    looking_for_main_comment=0
    do {
        str=file_text_read_string(f) file_text_readln(f)
        //look for triple slash function declarations
        if (string_pos('GMREAL',str) || string_pos('GMSTR',str) || string_pos('#define',str)) {
            if (helpline!="" && !string_pos("__",helpline)) {
                ds_list_add(funcs,helpline+"|"+comments)
            }
            helpline=""
            comments=""
        }
        if (string_pos('///',str) && string_pos('(',str) && string_pos(')',str)) {
            if (helpline!="" && !string_pos("__",helpline)) {
                ds_list_add(funcs,helpline+"|"+comments)
            }
            helpline=string_delete_edge_spaces(string_replace(str,"///",""))
            comments=""
            looking_for_main_comment=1
        } else if (string_pos('//',str) && looking_for_main_comment) {
            str=string_delete_edge_spaces(string_replace(str,"//",""))
            if (str!="") comments+=str+"#"
        } else looking_for_main_comment=0
    } until file_text_eof(f)

    file_text_close(f)
}

ds_list_sort(funcs,1)

out=""
i=0 repeat (ds_list_size(funcs)) {
    out+=ds_list_find_value(funcs,i)+chr_crlf
    i+=1
}

b=buffer_create()
buffer_write_data(b,out)
buffer_deflate(b)

b2=buffer_create()
buffer_write_string(b2,"Johnny")
buffer_copy_part(b2,b,0,buffer_get_size(b))
buffer_destroy(b)
buffer_save(b2,output)

show_message(string(ds_list_size(funcs))+" functions written to "+output)
ds_list_destroy(funcs)
