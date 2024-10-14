class FileUploadData < ApplicationRecord
  attr_accessor(:upload)

  def self.demo(upload)
    name = upload.[]("datafile").original_filename
    directory = "upload/public/data"
    path = File.join(directory, name)
    File.open(path, "wb") { |f,|
      f.write(upload.[]("datafile").read)
    }
  end

  def self.save(upload, content_type)
    name = upload.[]("datafile").original_filename
    directory = "upload/public/data"
    path = File.join(directory, name)
    File.extname(name)
  end

  def self.uploadfile(upload)
    name = upload.[]("datafile").original_filename
    directory = "upload/public/data"
    path = File.join(directory, name)
    File.read(path)
  end
end
