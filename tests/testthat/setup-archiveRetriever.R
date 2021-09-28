library("vcr") # *Required* as vcr is set up on loading
invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures"),
  preserve_exact_body_bytes = TRUE
))
vcr::check_cassette_names()
