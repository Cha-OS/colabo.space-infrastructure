# Problems

## Joining workers

docker joining for managers works fine, but for workers doesn't

the current workaround is to do it natively, with docker command through shell ansible commadn

TASK [Add swarm workers] *************************************************************************************************************************************************************************************************************************************************
skipping: [orchestrator-bgo]
fatal: [colaboflow-1]: FAILED! => {"changed": true, "cmd": "docker swarm join --token SWMTKN-1-61ttf518fqvb6b4d7d1jygdepq94vq8827dp6auf1j91p018h9-0ifvaptuqzhy10yls4umoux3g 158.39.201.131:2377", "delta": "0:00:00.106353", "end": "2020-05-09 17:24:50.358561", "msg": "non-zero return code", "rc": 1, "start": "2020-05-09 17:24:50.252208", "stderr": "Error response from daemon: This node is already part of a swarm. Use \"docker swarm leave\" to leave this swarm and join another one.", "stderr_lines": ["Error response from daemon: This node is already part of a swarm. Use \"docker swarm leave\" to leave this swarm and join another one."], "stdout": "", "stdout_lines": []}
fatal: [colaboflow-2]: FAILED! => {"changed": true, "cmd": "docker swarm join --token SWMTKN-1-61ttf518fqvb6b4d7d1jygdepq94vq8827dp6auf1j91p018h9-0ifvaptuqzhy10yls4umoux3g 158.39.201.131:2377", "delta": "0:00:00.145049", "end": "2020-05-09 17:24:50.486276", "msg": "non-zero return code", "rc": 1, "start": "2020-05-09 17:24:50.341227", "stderr": "Error response from daemon: This node is already part of a swarm. Use \"docker swarm leave\" to leave this swarm and join another one.", "stderr_lines": ["Error response from daemon: This node is already part of a swarm. Use \"docker swarm leave\" to leave this swarm and join another one."], "stdout": "", "stdout_lines": []}


# TODO


# Example of `docker_info`

```json
{
	"changed":False,
	"swarm_facts":{
		"ID":"3cskoabjguk55ika98ubd3n6g",
		"Version":{
			"Index":21
		},
		"CreatedAt":"2020-05-09T01:15:40.69057072Z",
		"UpdatedAt":"2020-05-09T13:15:40.728032553Z",
		"Spec":{
			"Name":"default",
			"Labels":{

			},
			"Orchestration":{
				"TaskHistoryRetentionLimit":5
			},
			"Raft":{
				"SnapshotInterval":10000,
				"KeepOldSnapshots":0,
				"LogEntriesForSlowFollowers":500,
				"ElectionTick":10,
				"HeartbeatTick":1
			},
			"Dispatcher":{
				"HeartbeatPeriod":5000000000
			},
			"CAConfig":{
				"NodeCertExpiry":7776000000000000
			},
			"TaskDefaults":{

			},
			"EncryptionConfig":{
				"AutoLockManagers":False
			}
		},
		"TLSInfo":{
			"TrustRoot":"-----BEGIN CERTIFICATE-----<certificate here>=="
		},
		"RootRotationInProgress":False,
		"DefaultAddrPool":[
			"10.0.0.0/8"
		],
		"SubnetSize":24,
		"DataPathPort":4789,
		"JoinTokens":{
			"Worker":"<same_part>-<worker_part>",
			"Manager":"<same_part>-<manager_part>"
		}
	},
	"can_talk_to_docker":True,
	"docker_swarm_active":True,
	"docker_swarm_manager":True,
	"failed":False
}"\"


}"
```