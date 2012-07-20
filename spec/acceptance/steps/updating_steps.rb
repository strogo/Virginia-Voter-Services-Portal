steps_for :updating do

  step 'I look up :kind record' do |kind|
    visit search_path

    if kind == 'residential voter'
      voter_id = '123123123'
    else
      voter_id = '111222333'
    end

    fill_in "search_query_first_name", with: 'First'
    fill_in "search_query_last_name",  with: 'Last'
    select  "1",       from: "search_query_dob_3i_"
    select  "January", from: "search_query_dob_2i_"
    select  "1995",    from: "search_query_dob_1i_"
    select  "ACCOMACK COUNTY", from: "search_query_locality"

    fill_in "search_query_voter_id", with: voter_id
    check   "swear"

    click_button "Next"
  end

  step 'I should see view and update page' do
    page.should have_content("View & Update")
  end

  step 'I should see :status status selected' do |status|
    page.should have_checked_field status
  end

  step "I don't change status" do
    step 'I proceed'
  end

  step 'I proceed without making changes' do
    step 'I proceed'
    step 'I should see the addresses page'
    step 'I proceed'
    step 'I should see the options page'
    step 'I proceed'
    step 'I should see the confirmation page'
    step 'I proceed'
    step 'I should see the oath page'
    step 'I check boxes on the oath page'
    step 'I proceed'
  end

  step 'I proceed' do
    el = first(:css, ".btn.next", {})
    el.click
  end

  step 'I should see the addresses page' do
    should_be_visible "Registration address"
    should_be_visible "Mailing address"
  end

  step 'I should see the options page' do
    should_be_visible "Options"
  end

  step 'I should see the confirmation page' do
    should_be_visible "Confirm"
  end

  step 'I should see the oath page' do
    should_be_visible "Oath"
  end

  step 'I check boxes on the oath page' do
    check "registration_information_correct"
    check "registration_privacy_agree"
  end

  step 'I should see the download page' do
    page.should have_content "Download"
  end

  step 'the next button should be disabled' do
    page.should have_css ".btn.next.disabled"
  end

  step 'choose overseas absentee status option' do
    choose  "Overseas/Military Absentee Voter"
    step    "I proceed"
  end

  step 'change status to overseas absentee' do
    step    "choose overseas absentee status option"

    step    "I should see the addresses page"
    choose  "My Virginia residence is still available to me"

    choose  "I prefer that voting materials be sent to me at an APO/DPO/FPO address"
    fill_in "registration_apo_address", with: "Sample address"
    fill_in "registration_apo_zip5", with: "12345"
    step   "I proceed"

    step    "I should see the options page"
    choose  "Active Duty Merchant Marine or Armed Forces"
    fill_in "registration_service_id", with: "service-id"
    fill_in "registration_rank", with: "rank"
    step    "I proceed"
  end

  step 'I should not see :new_status option' do |new_status|
    page.should_not have_content new_status
  end

  step 'change status to residential voter' do
    choose  "Virginia Residential Voter"
    step    "I proceed"

    step    "I should see the addresses page"
    step    "I proceed"

    step    "I should see the options page"
    step    "I proceed"
  end

  step 'I should see :new_status on confirm page' do |new_status|
    step "I should see the confirmation page"
    page.should have_content new_status
  end

  step 'I should see :msg' do |msg|
    page.should have_content msg
  end

  step 'should be able to submit the update' do
    step "I proceed"
    step 'I should see the oath page'
    step 'I check boxes on the oath page'
    step 'I proceed'
    step 'I should see the download page'
  end

  step 'I should not see an absentee checkbox' do
    step 'I should see the addresses page'
    step 'I proceed'

    page.should_not have_css("input#registration_requesting_absentee[type='checkbox']")
  end

  step 'I should see an unchecked absentee checkbox' do
    step 'I should see the addresses page'
    step 'I proceed'

    e = find(:css, "input#registration_requesting_absentee[type='checkbox']")
    e.should_not be_checked
  end

  step 'when checked, the list of options should be empty' do
    check 'registration_requesting_absentee'
    select 'I am working and commuting to/from home for 11 or more hours between 6:00 AM and 7:00 PM on Election Day', from: 'registration_ab_reason'
    find('#registration_ab_field_1').value.should be_empty
    find('#registration_ab_time_1_4i_').value.should be_empty
    find('#registration_ab_time_1_5i_').value.should be_empty
    find('#registration_ab_time_2_4i_').value.should be_empty
    find('#registration_ab_time_2_5i_').value.should be_empty
    find('#registration_ab_street_number').value.should be_empty
    find('#registration_ab_street_name').value.should be_empty
    find('#registration_ab_street_type').value.should be_empty
    find('#registration_ab_apt').value.should be_empty
    find('#registration_ab_city').value.should be_empty
    find('#registration_ab_state').value.should be_empty
    find('#registration_ab_zip5').value.should be_empty
    find('#registration_ab_zip4').value.should be_empty
    find('#registration_ab_country').value.should be_empty
  end

  private

  def should_be_visible(label)
    first("h3", text: label).should be_visible
  end

end
