module FilesTestHelper
  extend self
  extend ActionDispatch::TestProcess
  def upload
    file_path = Rails.root.join("app", "assets", "images", "default.jpg")
    fixture_file_upload(file_path, "image/jpeg")
  end
end
