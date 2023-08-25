var finddir,list,list2,i,fn;

finddir=directory_previous(working_directory)

list=file_find_list(finddir,"*",fa_directory,false)
list2=dslist()

i=0 repeat (ds_list_size(list)) {
    fn=ds_list_find_value(list,i)+"\johnny.cfg"
    if (file_exists(fn)) ds_list_add(list2,fn)
i+=1}

if (!ds_list_size(list2)) {
    show_message("Johnny v0.21#GM8.2 documentation generator##Run in the github folder.")
    exit
}

i=0 repeat (ds_list_size(list2)) {
    process_johnny_file(ds_list_find_value(list2,i),finddir)
i+=1}

game_end()
