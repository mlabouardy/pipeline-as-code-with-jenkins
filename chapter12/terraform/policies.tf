resource "aws_iam_policy" "sqs_producer_policy" {
  name = "SendMoviesToQueuePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "sqs:SendMessage",
            "Resource": "${aws_sqs_queue.queue.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-producer-policy" {
  role       = module.MoviesLoader.role
  policy_arn = aws_iam_policy.sqs_producer_policy.arn
}

resource "aws_iam_policy" "sqs_consumer_policy" {
  name = "GetMoviesFromQueuePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sqs:ReceiveMessage",
              "sqs:DeleteMessage",
              "sqs:GetQueueAttributes"
            ],
            "Resource": "${aws_sqs_queue.queue.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-consumer-policy" {
  role       = module.MoviesParser.role
  policy_arn = aws_iam_policy.sqs_consumer_policy.arn
}

resource "aws_iam_policy" "insert_movie_policy" {
  name = "InsertMovieToDynamoDBTablePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "${aws_dynamodb_table.movies.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-insert-movie-policy" {
  role       = module.MoviesParser.role
  policy_arn = aws_iam_policy.insert_movie_policy.arn
}

resource "aws_iam_policy" "get_movies_policy" {
  name = "GetMovieFromDynamoDBTablePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:Scan",
            "Resource": "${aws_dynamodb_table.movies.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-get-movies-policy" {
  role       = module.MoviesStoreListMovies.role
  policy_arn = aws_iam_policy.get_movies_policy.arn
}

resource "aws_iam_policy" "get_one_movie_policy" {
  name = "GetOneMovieFromDynamoDBTablePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:Scan",
            "Resource": "${aws_dynamodb_table.movies.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-get-one-movie-policy" {
  role       = module.MoviesStoreSearchMovie.role
  policy_arn = aws_iam_policy.get_one_movie_policy.arn
}

resource "aws_iam_policy" "get_favorites_policy" {
  name = "GetFavoritesFromDynamoDBTablePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:Scan",
            "Resource": "${aws_dynamodb_table.favorites.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-get-favorites-policy" {
  role       = module.MoviesStoreViewFavorites.role
  policy_arn = aws_iam_policy.get_favorites_policy.arn
}

resource "aws_iam_policy" "insert_favorite_policy" {
  name = "InsertFavoriteFromDynamoDBTablePolicy"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "${aws_dynamodb_table.favorites.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "attach-insert-favorite-policy" {
  role       = module.MoviesStoreAddToFavorites.role
  policy_arn = aws_iam_policy.insert_favorite_policy.arn
}