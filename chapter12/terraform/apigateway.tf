resource "aws_api_gateway_rest_api" "api" {
  name        = "WatchlistAPI"
  description = "Watchlist Store RESTful API"
}

 resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "{proxy+}"
}

module "GetMovies" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  method = "GET"
  lambda_arn = aws_lambda_function.MoviesStoreListMovies.arn
}

module "GetOneMovie" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  method = "GET"
  lambda_arn = aws_lambda_function.MoviesStoreSearchMovie.arn
}

module "GetFavorites" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  method = "GET"
  lambda_arn = aws_lambda_function.MoviesStoreViewFavorites.arn
}

module "PostFavorites" {
  source = "./modules/method"
  api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  method = "POST"
  lambda_arn = aws_lambda_function.MoviesStoreAddToFavorites.arn
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