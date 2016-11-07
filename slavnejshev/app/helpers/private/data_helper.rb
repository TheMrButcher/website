module Private::DataHelper
  def get_or_add_datum(file_datum)
    file_hash = Private::Datum.digest(file_datum)
    datum = Private::Datum.find_by(datum_hash: file_hash)
    if datum.nil?
      file_path = 'storage/pano/' + file_hash
      datum = Private::Datum.create!(path: file_path, datum_hash: file_hash)
      FileUtils::mkdir_p Rails.root.join('storage', 'pano')
      File.open(file_path, 'wb') do |file|
        file.write(file_datum)
      end
    end
    datum
  end
  
  def make_pano_file(file_path, file_datum, file_type)
    datum = get_or_add_datum(file_datum)
    key = "pano/" + @pano_version.id.to_s + "/" + file_path
    datum.files.create(
      original_name: File.basename(file_path), key: key, storage: @pano_version, file_type: file_type)
  end
  
  def unzip_pano_archive(archive, file_type)
    require 'zip'
    archive_name = archive.original_filename
    Zip::File.open(archive.tempfile) do |zip_file|
      zip_file.each do |entry|
        next unless entry.file?
        make_pano_file(entry.name, entry.get_input_stream.read, file_type)
      end
    end
  end
end
