# feature tests for Radio Buttons

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..') unless $SETUP_LOADED
require 'unittests/setup'

class TC_Radios < Test::Unit::TestCase
  include Watir::Exception
  
  def setup
    goto_page "radioButtons1.html"
  end
  
  def test_Radio_Exists
    assert(browser.radio(:name, "box1").exists?)   
    assert(browser.radio(:id, "box5").exists?)   
    
    assert_false(browser.radio(:name, "missingname").exists?)   
    assert_false(browser.radio(:id, "missingid").exists?)   
  end
  
  def test_radio_class
    assert_raises(UnknownObjectException) { browser.radio(:name, "noName").class_name }  
    assert_equal("radio_style", browser.radio(:name, "box1").class_name)   
    assert_equal("", browser.radio(:id, "box5").class_name)   
  end
  
  def test_Radio_Enabled
    assert_raises(UnknownObjectException, "UnknownObjectException was supposed to be thrown" ) {   browser.radio(:name, "noName").enabled?  }  
    assert_raises(UnknownObjectException, "UnknownObjectException was supposed to be thrown" ) {   browser.radio(:id, "noName").enabled?  }  
    assert_raises(UnknownObjectException, "UnknownObjectException was supposed to be thrown" ) {   browser.radio(:name => "box4", :value => 6).enabled?  }  
    
    assert_false(browser.radio(:name, "box2").enabled?)   
    assert(browser.radio(:id, "box5").enabled?)   
    assert(browser.radio(:name, "box1").enabled?)   
  end
  
  def test_little
    assert_false(browser.button(:value, "foo").enabled?)
  end
  
  def test_onClick
    
    assert_false(browser.radio(:name, "box5").set?)
    assert_false(browser.button(:value , "foo").enabled?)
    
    # first click the button is enabled and the radio is set
    browser.radio(:name => "box5", :value => 1).set
    assert(browser.radio(:name => "box5", :value => 1).set?)
    assert(browser.radio(:name => "box5", :value => 1).checked?)    
    assert(browser.button(:value, "foo").enabled?)
    
    # second click the button is disabled and the radio is still set
    browser.radio(:name => "box5", :value => 1).set
    assert(browser.radio(:name => "box5", :value => 1).set?)
    assert(browser.radio(:name => "box5", :value => 1).checked?)    
    assert_false(browser.button(:value, "foo").enabled?)
    
    # third click the button is enabled and the radio is still set
    browser.radio(:name => "box5", :value => 1).set
    assert(browser.radio(:name => "box5", :value => 1).set?)
    assert(browser.radio(:name => "box5", :value => 1).checked?)
    assert(browser.button(:value, "foo").enabled?)
    
    # click the radio with a value of 2 , button is disabled? and the radio is still set
    browser.radio(:name => "box5", :value => 2).set
    assert_false(browser.radio(:name => "box5", :value => 1).set?)
    assert_false(browser.radio(:name => "box5", :value => 1).checked?)    
    assert(browser.radio(:name => "box5", :value => 2).set?)
    assert(browser.radio(:name => "box5", :value => 2).checked?)    
    assert_false(browser.button(:value, "foo").enabled?)
  end
  
  def test_Radio_isSet
    assert_raises(UnknownObjectException) { browser.radio(:name, "noName").set?  }  
    
    assert_false(browser.radio(:name, "box1").set?)   
    assert( browser.radio(:name, "box3").set?)   
    assert_false(browser.radio(:name, "box2").set?)   
    assert( browser.radio(:name => "box4", :value => 1).set?)   
    assert_false(browser.radio(:name => "box4", :value => 2).set?)  

    assert_false(browser.radio(:name, "box1").checked?)   
    assert( browser.radio(:name, "box3").checked?)   
    assert_false(browser.radio(:name, "box2").checked?)   
    assert( browser.radio(:name => "box4", :value => 1).checked?)   
    assert_false(browser.radio(:name => "box4", :value => 2).checked?)   
  end
  
  def test_radio_clear
    assert_raises(UnknownObjectException) {   browser.radio(:name, "noName").clear  }  
    
    browser.radio(:name, "box1").clear
    assert_false(browser.radio(:name, "box1").set?)   
    
    assert_raises(ObjectDisabledException, "ObjectDisabledException was supposed to be thrown" ) {   browser.radio(:name, "box2").clear  } 
    assert_false(browser.radio(:name, "box2").set?)   
    
    browser.radio(:name, "box3").clear
    assert_false(browser.radio(:name, "box3").set?)   
    
    browser.radio(:name => "box4", :value => 1).clear
    assert_false(browser.radio(:name => "box4", :value => 1).set?)   
  end
  
  def test_radio_set
    assert_raises(UnknownObjectException, "UnknownObjectException was supposed to be thrown" ) {   browser.radio(:name, "noName").set  }  
    browser.radio(:name, "box1").set
    assert(browser.radio(:name, "box1").set?)   
    
    assert_raises(ObjectDisabledException, "ObjectDisabledException was supposed to be thrown" ) {   browser.radio(:name, "box2").set  }  
    
    browser.radio(:name, "box3").set
    assert(browser.radio(:name, "box3").set?)   
    
    # radioes that have the same name but different values
    browser.radio(:name => "box4", :value => 3).set
    assert(browser.radio(:name => "box4", :value => 3).set?)   
  end
  
  def test_radio_properties
    
    assert_raises(UnknownObjectException, "UnknownObjectException  was supposed to be thrown" ) {   browser.radio(:index, 199).value}  
    assert_raises(UnknownObjectException, "UnknownObjectException  was supposed to be thrown" ) {   browser.radio(:index, 199).name }  
    assert_raises(UnknownObjectException, "UnknownObjectException  was supposed to be thrown" ) {   browser.radio(:index, 199).id }  
    assert_raises(UnknownObjectException, "UnknownObjectException  was supposed to be thrown" ) {   browser.radio(:index, 199).disabled? }  
    assert_raises(UnknownObjectException, "UnknownObjectException  was supposed to be thrown" ) {   browser.radio(:index, 199).type }  
    
    assert_equal("on"   ,    browser.radio(:index, 0).value)  
    assert_equal("box1" ,    browser.radio(:index, 0).name )  
    assert_equal(""     ,    browser.radio(:index, 0).id )  
    assert_equal("radio",    browser.radio(:index, 0).type )  
    
    assert_equal( false, browser.radio(:index, 0).disabled? )
    assert_equal( true,  browser.radio(:index, 2).disabled? )
    
    assert_equal("box5"  ,    browser.radio(:index, 1).id )  
    assert_equal(""      ,    browser.radio(:index, 1).name )  
    
    assert_equal("box4-value5", browser.radio(:name => "box4", :value => 5).title  )
    assert_equal("", browser.radio(:name => "box4", :value => 4).title  )
  end
  
  def test_radio_iterators
    assert_equal(13, browser.radios.length)
    assert_equal("box5" , browser.radios[1].id )
    assert_equal(true ,  browser.radios[2].disabled? )
    assert_equal(false ,  browser.radios[0].disabled? )
    
    index = 0
    browser.radios.each do |r|
      assert_equal( browser.radio(:index, index).name , r.name )
      assert_equal( browser.radio(:index, index).id , r.id )
      assert_equal( browser.radio(:index, index).value, r.value)
      assert_equal( browser.radio(:index, index).disabled? , r.disabled? )
      index+=1
    end
    assert_equal(index, browser.radios.length)
  end
  
  # test radio buttons that have a string as a value
  def test_value_string
    tea = browser.radio(:name => 'box6', :value => 'Tea')
    milk = browser.radio(:name => 'box6', :value => 'Milk')
    
    assert(tea.exists?)
    assert(milk.exists?)

    milk.set
    assert(milk.set?)   
    assert_false(tea.set?)   

    tea.set
    assert_false(milk.set?)   
    assert(tea.set?)   

    tea.clear
    assert_false(tea.set?)
  end

end

