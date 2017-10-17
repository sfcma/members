class Attachment < ApplicationRecord
  has_attached_file :file
  validates :file, attachment_presence: true
  validates_with AttachmentSizeValidator, attributes: :file, less_than: 5.megabytes
  validates_attachment_content_type :file, content_type:
    ['image/jpg',
     'image/jpeg',
     'image/png',
     'image/gif',
     'application/msword',
     'application/vnd.ms-excel',
     'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     'application/pdf',
     'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
     'application/zip']
end
