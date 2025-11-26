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

