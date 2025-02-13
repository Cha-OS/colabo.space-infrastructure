# LLM inferences

OpenAI
- https://openai.com/api/pricing/

groq
- https://groq.com/
- https://groq.com/products/
- https://groq.com/groqcloud/
- https://groq.com/groqrack/
- https://groq.com/pricing/
- 2024.12.
	- Llama 3.2 1B (Preview) 8k
		- $0.04/1M tokens
		- same for input and for output
	- Llama 3.3 70B Versatile 128k
		- $0.59/1M input tokens
		- $0.79/1M output tokens

https://www.together.ai/
- https://www.together.ai/pricing/
	- Llama 3.2, LLAMA 3.1, LLama 3 MODELS
		- 70B
			- $0.54/1M (input or output) LITE
			- $0.88 TURBO
			- $0.90 REFERENCE

Fireworks AI
- https://fireworks.ai/
- https://fireworks.ai/pricing
	- unclear a bit

# GPU

## Vast.ai

https://cloud.vast.ai/

## Hugging Face

Hugging Face
- Serverless Inference API
	- https://huggingface.co/docs/api-inference/en/index
		- Fast and **Free** to Get Started: The Inference API is free with higher rate limits for PRO users. 
		- For production needs, explore Inference Endpoints for dedicated resources, autoscaling, advanced security features, and more.
- Spaces Hardware
	- https://huggingface.co/pricing#spaces
	- CPU Basic is **FREE**
- Inference Endpoints
	- Inference Endpoints (dedicated) offers a secure production solution to easily deploy any ML model on dedicated and autoscaling infrastructure, right from the HF Hub.
	- https://ui.endpoints.huggingface.co/
	- https://huggingface.co/docs/inference-endpoints/index
	- https://huggingface.co/pricing#endpoints
		- @LLM: Granularity: Billing is calculated by the minute, allowing for cost-effective scaling based on actual usage.
	- [Access the Inference API](https://huggingface.co/docs/huggingface_hub/v0.13.2/en/guides/inference)
	- [Deploy LLMs with Hugging Face Inference Endpoints](https://huggingface.co/blog/inference-endpoints-llm)
	- [Run Inference on servers](https://huggingface.co/docs/huggingface_hub/main/en/guides/inference)

## AWS

https://instances.vantage.sh/aws/ec2/inf1.xlarge

https://aws.amazon.com/ec2/pricing/?p=pm&c=ec2&z=4
- EC2 usage is billed in one-second increments, with a minimum of 60 seconds.

https://aws.amazon.com/ec2/pricing/on-demand/
	- inf1.xlarge
		- VCPus:4, RAM: 8 GiB, Storage: EBS Only, Net: Up to 25 Gigabit
		- $0.285/hour => $210/month
		- Saving Plans (1 year, all upfront): $0.154/hour => $113/month => $1356/year = EUR 1288/year => 32% savings

### Additional costs

Storage:
- EC2 instances typically use Amazon **Elastic Block Store (EBS)** for persistent storage. Common options include:
	- General Purpose SSD (gp3): $0.08 per GB-month.
	- Provisioned IOPS SSD (io2): $0.125 per GB-month, plus $0.065 per provisioned IOPS-month.
- For example, a 100 GB gp3 volume would cost:
	- 100 GB * $0.08/GB = $8.00 per month.

Data Transfer Costs
- Inbound Data Transfer: Free.
- Outbound Data Transfer to the Internet:
	- First 1 GB per month: Free.
	- Up to 10 TB per month: $0.09 per GB.

Elastic IP
- An Elastic IP (EIP) associated with a running instance is free. 
- unattached EIPs incur a charge of $0.005 per hour, approximately $3.60 per month.

NAT Gateway
- https://aws.amazon.com/vpc/pricing/
-  a NAT Gateway costs $0.045 per hour plus $0.045 per GB of data processed.

Others
- Load Balancers, or AWS Storage Gateway

## Options

[Cheapest way to run huggingface model on online GPUs?](https://www.reddit.com/r/huggingface/comments/1ekhv3w/cheapest_way_to_run_huggingface_model_on_online/)
- https://huggingface.co/google-bert/bert-base-uncased

