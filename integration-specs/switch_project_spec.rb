require 'integration-specs/spec_helper'

steps "log in and switch projects", :type => :request do

  let :project_1 do Factory(:project) end
  let :project_2 do Factory(:project) end
  let :user      do Factory(:user, :current_project => project_1) end

  let! :work_units do
    [ Factory(:work_unit, :project => project_1, :user => user),
      Factory(:work_unit, :project => project_1, :user => user),
      Factory(:work_unit, :project => project_1, :user => user),
      Factory(:work_unit, :project => project_2, :user => user),
      Factory(:work_unit, :project => project_2, :user => user),
      Factory(:work_unit, :project => project_2, :user => user)
    ]
  end

  it "should login as a user" do
    visit root_path
    fill_in "Login", :with => user.login
    fill_in "Password", :with => user.password
    click_button 'Login'
    page.should have_link("Logout")
  end

  it "should have a work unit form (XPath Gem format)" do
    page.should have_xpath(XPath.generate do |doc|
       doc.descendant(:form)[doc.attr(:id) == "new_work_unit"][doc.attr(:action) == '/work_units']
    end)
  end

  it "should have a work unit form (make_xpath format)" do
    page.should have_xpath(make_xpath{
      descendant(:form).attrs(:id => "new_work_unit", :action => '/work_units')
    })
  end

  it "should have a work unit form (Plain XPath format)" do
    page.should have_xpath("//form[@id='new_work_unit'][@action='/work_units']")
  end

  it "should have a work unit form (have_selector format)" do
    page.should have_selector("form#new_work_unit[action='/work_units']")
  end

  it "should have a work unit form (css hybrid)" do
    page.should have_xpath(make_xpath{
      css("form#new_work_unit").attrs(:action => '/work_units')
    })
  end

  it "should have the name of the project" do
    page.should have_xpath(make_xpath(project_1.name){|name|
      descendant(:h1).all(attr(:id) == 'headline', content(name))
    })
  end

  it "should have a timeclock with the name of the project" do
    page.should have_xpath(make_xpath(project_1.name){|name|
      descendant(:div).all(attr(:id) == 'timeclock', content(name))
    })
  end

  it "should list project 1's work units " do
    project_1.work_units.each do |work_unit|
      page.should have_xpath(make_xpath(work_unit.notes)){ |notes|
        css('#content #current_project table.listing').descendant(:tr, content(notes))
      }
    end
  end

  it "should not list project 2's work units" do
    project_2.work_units.each do |work_unit|
      page.should_not have_xpath(make_xpath(work_unit.notes)){ |notes|
        descendant(:tr, content(notes))
      }
    end
  end
  
  it 
  def headline(name)
    xpath = HandyXPaths::Builder.new
    xpath.descendant(:h1)[xpath.content(name)]
  end

  it "should have the name of the project (method style)" do
    page.should have_xpath(headline(project_1.name).attrs(:id => 'headline'))
  end

  it "should list project 1's work units - version 2" do
    project_1.work_units.each do |work_unit|
      page.should have_xpath( work_unit_listing_xpath.descendant(:tr).where(XPath::HTML.content(work_unit.notes)))
    end
  end

  def work_unit_listing_xpath
    make_xpath{ css('#content #current_project table.listing') }
  end


end
