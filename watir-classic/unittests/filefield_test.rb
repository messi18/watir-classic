# feature tests for file Fields

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'
require 'uri'

class TC_FileField < Test::Unit::TestCase
  tags :must_be_visible, :creates_windows
  include Watir
  
  def setup
    goto_page "fileupload.html"
  end
  
  def test_file_field_Exists
    # test for existance of 4 file area
    assert(browser.file_field(:name,"file1").exists?)
    assert(browser.file_field(:id,"file2").exists?)

    # test for missing 
    assert_false(browser.file_field(:name, "missing").exists?)   
    assert_false(browser.file_field(:name,"totallybogus").exists?)

    # pop one open and put something in it.
    file = $htmlRoot + "fileupload.html"
    file.gsub! 'file:///', ''
    file.gsub! '/', '\\'
    browser.file_field(:name,"file3").set(file)
    Watir::Wait.until {browser.file_field(:name,"file3").value!= ''}
    assert_equal file, browser.file_field(:name,"file3").value

    # click the upload button
    browser.button(:name,"upload").click
    assert(browser.text.include?("PASS"))
    uri = URI.parse(browser.url)
    assert uri.query =~ /fileupload.html&upload=upload/
   end
  
  def test_iterator
    assert_equal(6, browser.file_fields.length)
  end
  
end
