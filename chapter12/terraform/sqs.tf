resource "aws_sqs_queue" "queue" {
  name = "movies_to_parse"
  tags = {
    Stack = "Watchlist"
  }
}