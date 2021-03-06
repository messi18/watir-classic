# feature tests for Text Fields & Labels

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_Fields < Test::Unit::TestCase
  include Watir::Exception
  
  def setup
    goto_page "textfields1.html"
  end
  
  tag_method :test_text_field_exists, :fails_on_firefox
  def test_text_field_exists
    assert(browser.text_field(:name, "text1").exists?)   
    assert_false(browser.text_field(:name, "missing").exists?)   
    
    assert(browser.text_field(:id, "text2").exists?)   
    assert_false(browser.text_field(:id, "alsomissing").exists?)   
    
    assert(browser.text_field(:value, 'foo').exists?)
  end
  
  tag_method :test_text_field_dragContentsTo, :fails_on_firefox
  def test_text_field_dragContentsTo
    browser.text_field(:name, "text1").drag_contents_to(:id, "text2")
    assert_equal(browser.text_field(:name, "text1").value, "") 
    assert_equal(browser.text_field(:id, "text2").value, "goodbye allHello World") 
  end
  
  def test_text_field_verify_contains
    assert(browser.text_field(:name, "text1").verify_contains("Hello World"))  
    assert(browser.text_field(:name, "text1").verify_contains(/Hello\sW/))  
    assert_false(browser.text_field(:name, "text1").verify_contains("Ruby"))  
    assert_false(browser.text_field(:name, "text1").verify_contains(/R/))  
    assert_raises(UnknownObjectException) { browser.text_field(:name, "NoName").verify_contains("No field to get a value of") } 
    
    assert(browser.text_field(:id, "text2").verify_contains("goodbye all") )  
    assert_raises(UnknownObjectException) { browser.text_field(:id, "noID").verify_contains("No field to get a value of") }          
  end
  
  def test_text_field_enabled
    assert_false(browser.text_field(:name, "disabled").enabled? )  
    assert(browser.text_field(:name, "text1").enabled? )  
    assert(browser.text_field(:id, "text2").enabled? )  
  end
  
  def test_text_field_readonly
    assert_false(browser.text_field(:name, "disabled").readonly? )  
    assert(browser.text_field(:name, "readOnly").readonly? )  
    assert(browser.text_field(:id, "readOnly2").readonly? )  
  end
  
  def test_text_field_get_contents
    assert_raises(UnknownObjectException) { browser.text_field(:name, "missing_field").append("Some Text") }  
    assert_equal("Hello World", browser.text_field(:name, "text1").value)  
  end
  
  tag_method :test_text_field_append, :fails_on_firefox
  def test_text_field_append
    assert_raises(ObjectReadOnlyException) { browser.text_field(:id, "readOnly2").append("Some Text") }  
    assert_raises(ObjectDisabledException) { browser.text_field(:name, "disabled").append("Some Text") }  
    assert_raises(UnknownObjectException) { browser.text_field(:name, "missing_field").append("Some Text") }  
    
    browser.text_field(:name, "text1").append(" Some Text")
    assert_equal("Hello World Some Text", browser.text_field(:name, "text1").value)  
  end
  
  def test_text_field_clear
    browser.text_field(:name, "text1").clear
    assert_equal("", browser.text_field(:name, "text1").value)  
  end
  
  def test_text_field_set
    browser.text_field(:name, "text1").set("watir IE Controller")
    assert_equal("watir IE Controller", browser.text_field(:name, "text1").value)  
    # adding for issue: http://jira.openqa.org/browse/WTR-89
    browser.text_field(:name, /reGex/i).set("pass")
    assert_equal("pass", browser.text_field(:name, /REgEx/i).value)
  end
  
  def test_text_field_properties
    assert_raises(UnknownObjectException) { browser.text_field(:index, 199).value }  
    assert_raises(UnknownObjectException) { browser.text_field(:index, 199).name }  
    assert_raises(UnknownObjectException) { browser.text_field(:index, 199).id }  
    assert_raises(UnknownObjectException) { browser.text_field(:index, 199).disabled? }  
    assert_raises(UnknownObjectException) { browser.text_field(:index, 199).type }  
    
    assert_equal("Hello World" , browser.text_field(:index, 0).value) 
    assert_equal("text"        , browser.text_field(:index, 0).type)
    assert_equal("text1"       , browser.text_field(:index, 0).name)
    assert_equal(""            , browser.text_field(:index, 0).id)
    assert_equal(false         , browser.text_field(:index, 0).disabled?)
    
    assert_equal(""            , browser.text_field(:index, 1).name)
    assert_equal("text2"       , browser.text_field(:index, 1).id)
    
    assert(browser.text_field(:index, 3).disabled?)
    
    assert_equal("This used to test :afterText", browser.text_field(:name, "aftertest").title)
    assert_equal("", browser.text_field(:index, 0).title)
    # adding for issue: http://jira.openqa.org/browse/WTR-89
    assert_equal("RegEx test", browser.text_field(:name, /REgEx/i).value)
  end
  
  def test_text_field_iterators
    assert_equal(14, browser.text_fields.length)
    
    assert_equal("Hello World", browser.text_fields[0].value)
    assert_equal("text1", browser.text_fields[0].name)
    assert_equal("password", browser.text_fields[browser.text_fields.length - 1].type)
    
    index = 0
    browser.text_fields.each do |t|
      assert_equal(browser.text_field(:index, index).value, t.value) 
      assert_equal(browser.text_field(:index, index).id,    t.id)
      assert_equal(browser.text_field(:index, index).name,  t.name)
      index += 1
    end
    assert_equal(index, browser.text_fields.length)         
  end
  
  tag_method :test_JS_Events, :fails_on_firefox
  def test_JS_Events
    browser.text_field(:name, 'events_tester').requires_typing.set('p')
    
    # the following line has an extra keypress at the begining, as we mimic the delete key being pressed
    assert_equal( "keypresskeydownkeypresskeyup" , browser.text_field(:name, 'events_text').value.gsub(/(\r|\n)/ , "")  )
    browser.button(:value, "Clear Events Box").click
    browser.text_field(:name, 'events_tester').requires_typing.set('ab')
    
    # the following line has an extra keypress at the begining, as we mimic the delete key being pressed
    assert_equal( "keypresskeydownkeypresskeyupkeydownkeypresskeyup", browser.text_field(:name , 'events_text').value.gsub(/(\r|\n)/ , "") )
  end
  
  def test_password
    browser.text_field(:name, "password1").set("secret")
    assert( 'secret' , browser.text_field(:name, "password1").value )
    
    browser.text_field(:id, "password1").set("top_secret")
    assert('top_secret', browser.text_field(:id, "password1").value )
  end
  
  def test_labels_iterator
    assert_equal(3, browser.labels.length)
    assert_equal('Label For this Field' , browser.labels[0].text.strip )
    assert_equal('Password With ID ( the text here is a label for it )' , browser.labels[2].text )
    
    count=0
    browser.labels.each do |l|
      count +=1
    end
    assert_equal(count, browser.labels.length)
  end
  
  def test_label_properties
    assert_raises(UnknownObjectException) { browser.label(:index,20).text } 
    assert_raises(UnknownObjectException) { browser.label(:index,20).for } 
    assert_raises(UnknownObjectException) { browser.label(:index,20).id } 
    
    assert_false(browser.label(:index,10).exists?) 
    assert_false(browser.label(:id,'missing').exists?) 
    assert(browser.label(:index,0).exists?) 
    
    assert_equal("", browser.label(:index,0).id)
    assert_false(browser.label(:index,0).disabled?) 
    assert(browser.label(:index,0).enabled?)
    
    assert_equal("label2", browser.label(:index,1).id )
    
    assert_equal("Password With ID ( the text here is a label for it )" , browser.label(:index,2).text)
    assert_equal("password1", browser.label(:index,2).for)
  end

  def test_max_length_is_not_exceeded
    browser.text_field(:name, 'text1').set("abcdefghijklmnopqrstuv")
    assert_equal("abcdefghijklmnopqrst", browser.text_field(:name, 'text1').value )
  end

  def test_max_length
    assert_equal(20, browser.text_field(:name, 'text1').maxlength)
  end
  
end
