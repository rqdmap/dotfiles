import copy
import yaml
import json


# xxx + xxx + xxx
def parse(desc: str, is_from=False):
    keys = [i.strip() for i in desc.split('+')]
    if is_from:
        result = {"modifiers": {"mandatory": keys[0:-1]}}
    else:
        result = {"modifiers": keys[0:-1]}
    if keys[-1].startswith("button"):
        result['pointing_button'] = keys[-1]
    else:
        result['key_code'] = keys[-1]
    return result


yaml_file = 'config.yaml'
with open(yaml_file, 'r') as file:
    config = yaml.safe_load(file)

result = {
    "title": config['title'],
    "version": config['version'],
    "maintainers": config['maintainers'],
    "author": config['author'],
    "rules": []
}

for _rule in config["rules"]:
    rule = {
        "description": _rule['description'],
        "manipulators": []
    }
    for _item in _rule['manipulators']:
        item = {
            "description": _item['description'],
            "type": "basic",
        }
        item['from'] = parse(_item['description'].split('=')[0], True)
        item['to'] = parse(_item['description'].split('=')[1])
        if _item.get('conditions'):
            for _condition in _item['conditions']:
                item['conditions'] = []
                condition = {
                    "type": _condition['type'],
                    "bundle_identifiers": _condition['identifiers']
                }
                item['conditions'].append(condition)
        rule['manipulators'].append(item)

    result["rules"].append(rule)


json_str = json.dumps(result, indent=2)
print(json_str)

# with open('custom.json', 'r') as json_file:
#     data = json.load(json_file)
#     new_data = copy.deepcopy(data)
#     new_data['rules'][0]['manipulators'] = []
#     for item in data['rules'][0]['manipulators']:
#         new_item = {}
#         new_item['description'] = item['description']
#         if item.get('conditions'):
#             for condition in item['conditions']:
#                 new_item['conditions'] = []
#                 new_item['conditions'].append({
#                     "type": condition['type'],
#                     "identifiers": condition['bundle_identifiers']
#                 })
#             # new_item['conditions'] = {
#             #     "type": item['conditions'][0]['type'],
#             #     "identifiers": item['conditions'][0]['bundle_identifiers']
#             # }
#
#         new_data['rules'][0]['manipulators'].append(new_item)


# print(new_data)
# yaml.dump(new_data, open('custom.yaml', 'w'), sort_keys=False)

