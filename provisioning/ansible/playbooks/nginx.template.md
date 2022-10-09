Vars
+ `active_hosts_groups`: for example `tickerai_cms`
+ `../variables/nginx-list.json`

programmatically (or through global template) set defaults:

```yml
- name: Set defaults
with_items: "<< items_array >>"
# https://stackoverflow.com/questions/35105615/ansible-use-default-if-a-variable-is-not-defined
set_fact:
	item: "<< item | combine({
		'port': item.port | default('80'),
		'port_ssl': item.port_ssl | default('443')
	}, recursive=True)
	>>"
```

Task `Load NGINX host templates` creates `rendered_template`
```json
{
	rendered_template: {
		[key]: {
			main_template_pressl_final // from `templates/nginx-config-pressl.j2`,
			main_template_ssl: // from `templates/nginx-config-ssl.j2')`,
			extension_templates: 'TO_BE_SET',
			main_template_ssl_final: 'TO_BE_SET'
		}
	}
}
```
