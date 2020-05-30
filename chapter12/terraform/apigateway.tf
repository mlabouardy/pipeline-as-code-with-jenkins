resource "aws_api_gateway_rest_api" "api" {
  name        = "WatchlistAPI"
  description = "Watchlist Store RESTful API"
}

resource "aws_api_gateway_resource" "path_movies" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "movies"
}

resource "aws_api_gateway_resource" "path_search_movie" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_resource.path_movies.id
   path_part   = "{name}"
}

resource "aws_api_gateway_resource" "favorites" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "favorites"
}


module "GetMovies" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.path_movies.id
  method = "GET"
  lambda_arn = module.MoviesStoreListMovies.arn
  invoke_arn = module.MoviesStoreListMovies.invoke_arn
  api_execution_arn = aws_api_gateway_rest_api.api.execution_arn
}

module "GetOneMovie" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.path_search_movie.id
  method = "GET"
  lambda_arn = module.MoviesStoreSearchMovie.arn
  invoke_arn = module.MoviesStoreSearchMovie.invoke_arn
  api_execution_arn = aws_api_gateway_rest_api.api.execution_arn
}

module "GetFavorites" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.favorites.id
  method = "GET"
  lambda_arn = module.MoviesStoreViewFavorites.arn
  invoke_arn = module.MoviesStoreViewFavorites.invoke_arn
  api_execution_arn = aws_api_gateway_rest_api.api.execution_arn
}

module "PostFavorites" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.favorites.id
  method = "POST"
  lambda_arn = module.MoviesStoreAddToFavorites.arn
  invoke_arn = module.MoviesStoreAddToFavorites.invoke_arn
  api_execution_arn = aws_api_gateway_rest_api.api.execution_arn
}

resource "aws_api_gateway_deployment" "test" {
   depends_on = [
     module.GetMovies,
     module.GetOneMovie,
     module.GetFavorites,
     module.PostFavorites
   ]

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "test"
}

resource "aws_api_gateway_deployment" "sandbox" {
   depends_on = [
     module.GetMovies,
     module.GetOneMovie,
     module.GetFavorites,
     module.PostFavorites
   ]

   variables = {
    "environment" = "sandbox"
  }

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "sandbox"
}

resource "aws_api_gateway_deployment" "staging" {
   depends_on = [
     module.GetMovies,
     module.GetOneMovie,
     module.GetFavorites,
     module.PostFavorites
   ]

   variables = {
    "environment" = "staging"
  }

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "staging"
}

resource "aws_api_gateway_deployment" "production" {
   depends_on = [
     module.GetMovies,
     module.GetOneMovie,
     module.GetFavorites,
     module.PostFavorites
   ]

   variables = {
    "environment" = "production"
  }

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "production"
}

