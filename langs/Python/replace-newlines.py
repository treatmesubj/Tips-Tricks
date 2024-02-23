# can't use backslashes in f-string, so need string.format()
etymology_str += "{word_class}:\n    {etym_desc}\n{dashes}\n".format(
    word_class=homonym["word_class"],
    etym_desc=homonym["etym_desc"].replace("\n", "\n    "),
    dashes="-" * 20,
)
