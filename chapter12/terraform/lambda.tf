module "MoviesLoader" {
  source = "./modules/function"
  name = "MoviesLoader"
  handler = "index.handler"
  runtime = "python3.7"
  environment = {
    SQS_URL = aws_sqs_queue.queue.id
  }
}

module "MoviesParser" {
  source = "./modules/function"
  name = "MoviesParser"
  handler = "main"
  runtime = "go1.x"
  environment = {
    TABLE_NAME = aws_dynamodb_table.movies.id
  }
}

module "MoviesStoreListMovies" {
  source = "./modules/function"
  name = "MoviesStoreListMovies"
  handler = "src/movies/findAll/index.handler"
  runtime = "nodejs14.x"
  environment = {
    TABLE_NAME = aws_dynamodb_table.movies.id
  }
}

module "MoviesStoreSearchMovie" {
  source = "./modules/function"
  name = "MoviesStoreSearchMovie"
  handler = "src/movies/findOne/index.handler"
  runtime = "nodejs14.x"
  environment = {
    TABLE_NAME = aws_dynamodb_table.movies.id
  }
}

module "MoviesStoreViewFavorites" {
  source = "./modules/function"
  name = "MoviesStoreViewFavorites"
  handler = "src/favorites/findAll/index.handler"
  runtime = "nodejs14.x"
  environment = {
    TABLE_NAME = aws_dynamodb_table.favorites.id
  }
}

module "MoviesStoreAddToFavorites" {
  source = "./modules/function"
  name = "MoviesStoreAddToFavorites"
  handler = "src/favorites/insert/index.handler"
  runtime = "nodejs14.x"
  environment = {
    TABLE_NAME = aws_dynamodb_table.favorites.id
  }
}