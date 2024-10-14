class MgSchoolAccountDataUpload < ApplicationRecord
  def self.demo(upload, file_name)
    accepted_formats = [".txt", ".pdf", ".xlsx", ".xls", ".jpg", ".jpeg", ".odt", ".pptx", ".pptm", ".xlsb", ".xla", ".jfif"]
    extension_check = []
    if accepted_formats.include?(File.extname(file_name))
      directory = "/u03/rubyworkspace/mcsms_upload"
      path = File.join(directory, file_name)
      File.open(path, "wb") { |f,|
        f.write(upload.read)
      }
      extension_check << 1
    else
      extension_check << 0
    end
    @data_save = extension_check
    @data_save
  end
end
