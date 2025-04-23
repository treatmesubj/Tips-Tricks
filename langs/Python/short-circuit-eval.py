#!/usr/bin/env python3

# ===== Don't write this =====
username, full_name, first_name = (None, None, 'John')
if username is not None:
    display_name = username
elif full_name is not None:
    display_name = full_name
elif first_name is not None:
    display_name = first_name
else:
    display_name = "Anonymous"

# ===== Write this instead =====
username, full_name, first_name = (None, None, 'John')
display_name = username or full_name or first_name or "Anonymous"
