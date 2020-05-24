module "MoviesLoader" {
  source = "./modules/function"
  name = "MoviesLoader"
  handler = "main.py"
  runtime = "python3.7"
}

module "MoviesParser" {
  source = "./modules/function"
  name = "MoviesParser"
  handler = "main"
  runtime = "go1.x"
}

module "MoviesStoreListMovies" {
  source = "./modules/function"
  name = "MoviesStoreListMovies"
  handler = "index.js"
  runtime = "nodejs12.x"
}

module "MoviesStoreSearchMovie" {
  source = "./modules/function"
  name = "MoviesStoreSearchMovie"
  handler = "index.js"
  runtime = "nodejs12.x"
}

module "MoviesStoreViewFavorites" {
  source = "./modules/function"
  name = "MoviesStoreViewFavorites"
  handler = "index.js"
  runtime = "nodejs12.x"
}

module "MoviesStoreAddToFavorites" {
  source = "./modules/function"
  name = "MoviesStoreAddToFavorites"
  handler = "index.js"
  runtime = "nodejs12.x"
}