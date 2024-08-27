aws_config = { region: ENV['AWS_REGION'] || 'us-west-2' }

# Use a local DynamoDB endpoint for development if specified
if (local_dynamo = ENV['DYNAMODB_ENDPOINT']).present?
  aws_config[:endpoint] = local_dynamo
end

# For local - credentials are explicitly provided; In prod, use IAM
if (aws_key_id = ENV['AWS_ACCESS_KEY_ID']).present?
  aws_config[:credentials] = Aws::Credentials.new(aws_key_id, ENV['AWS_SECRET_ACCESS_KEY'])
end

# AppRunner or ECS, use IAM instance role for DynamoDB access

Aws.config.update(aws_config)