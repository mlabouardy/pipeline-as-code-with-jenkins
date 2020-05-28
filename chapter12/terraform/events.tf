resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.queue.arn
  function_name    = module.MoviesParser.arn
  batch_size = 5
}