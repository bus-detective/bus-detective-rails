task :deploy_index do
  Aws.config.update({
    region: 'us-east-1',
    credentials: Aws::Credentials.new(ENV.fetch('S3_KEY'), ENV.fetch('S3_SECRET')),
  }) 

  destination = Rails.root.join('public', 'index.html')
  s3_bucket = Aws::S3::Bucket.new(ENV.fetch('S3_BUCKET'))
  s3_bucket.object('index.html').get(response_target: destination)
end

# before executing 'rake assets:precompile' run 'deploy_index' first
Rake::Task['assets:precompile'].enhance ['deploy_index']
