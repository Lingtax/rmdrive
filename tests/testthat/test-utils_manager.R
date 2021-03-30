###################################
####    test Utils Manager     ####
###################################

file_path <- ifelse(interactive(), "tests/testthat/test_files/", "test_files/")

#----    upload_document    ----

test_that("upload the document correctly", {
  skip_if_no_token()
  skip_if_offline()
  
  file <- paste0(file_path,"example_1.Rmd")
  file_info <- get_file_info(file)
  
  # # dribble_document_old
  # dribble_document_old <- get_dribble_info(gfile = "old_example_1", path = "writing_folder")
  # upload_document(file, file_info, gfile = "old_example_1", dribble_document_old, hide_code = FALSE, update = TRUE)
  # save(dribble_document_old, file = "tests/testthat/test_files/dribble_document_old.rda")
  load(paste0(file_path, "dribble_document_old.rda"))
  
  
  # upload new file
  vcr::use_cassette("upload_document_test_1", {
    dribble_new <- upload_document(file = file, file_info = file_info, 
                                   gfile = "new_example_1", dribble_document = dribble_document_old, 
                                   hide_code = FALSE, update = FALSE)
    
    googledrive::drive_rm(dribble_new)
  })
  expect_equal(dribble_new$name, "new_example_1")
  
  
  # update old file
  vcr::use_cassette("upload_document_test_2", {
    dribble_old <- upload_document(file = file, file_info = file_info, 
                                   gfile = "old_example_1", 
                                   dribble_document = dribble_document_old, 
                                   hide_code = TRUE, update = TRUE)
    
  })
  expect_equal(dribble_old$name, "old_example_1")
  
  # remove files
  ls_files <- list.files(paste0(file_path, ".trackdown"))
  file.remove(paste0(file_path, ".trackdown/",ls_files))
  file.remove(paste0(file_path, ".trackdown"), recursive = TRUE)
})

#----    upload_output    ----

test_that("upload the output correctly", {
  skip_if_no_token()
  skip_if_offline()
  
  # html
  output_html <- paste0(file_path,"example_1.html")
  output_info_html <- get_file_info(output_html)
  
  
  # # dribble_output_old
  # dribble_output_old <- get_dribble_info(gfile = "old_output", path = "writing_folder")
  # upload_output(path_output = output_html, output_info = output_info_html, 
  #               gfile_output = "old_output", dribble_output = dribble_output_old, 
  #               update = FALSE, .response = 2L)
  # save(dribble_output_old, file = "tests/testthat/test_files/dribble_output_old.rda")
  load(paste0(file_path, "dribble_output_old.rda"))
  
  
  # upload new output html
  vcr::use_cassette("upload_output_test_1", {
    dribble_new <- upload_output(path_output = output_html, output_info = output_info_html, 
                                 gfile_output = "new_output", dribble_output = dribble_output_old, 
                                 update = FALSE, .response = 2L)

    googledrive::drive_rm(dribble_new)
  })
  expect_equal(dribble_new$name, "new_output")
  
  
  # update old output
  vcr::use_cassette("upload_output_test_2", {
    dribble_old <- upload_output(path_output = output_html, output_info = output_info_html, 
                                 gfile_output = "old_output", dribble_output = dribble_output_old, 
                                 update = TRUE, .response = 1L)
  })
  expect_equal(dribble_old$name, "old_output")
  
})


#----

