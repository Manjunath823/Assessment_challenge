def nested_key(object_dict, field):
    """
    Input can be nested dict and a key, the function will return
    value for that key
    """
    keys_found = []

    for key, value in object_dict.items():

        if key == field:
            keys_found.append(value)

        elif isinstance(value, dict):
            #to check whether the value is key for nested dictionary
            out = nested_key(value, field)
            for each_out in out:
                keys_found.append(each_out)

        elif isinstance(value, list):
            for item in value:
                if isinstance(item, dict):
                    more_results = nested_key(item, field)
                    for another_result in more_results:
                        keys_found.append(another_result)

    return keys_found
#Example usage nested_key(object, key)

