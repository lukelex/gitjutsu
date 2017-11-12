module Github
  class File < SimpleDelegator
    TEST_FILE_OR_FOLDER = %r{(
      [_\/](spec|test)\b # file
      |
      (spec|test)\/ # folder
    )}ix

    def test_file?
      TEST_FILE_OR_FOLDER.match? filename
    end
  end
end
