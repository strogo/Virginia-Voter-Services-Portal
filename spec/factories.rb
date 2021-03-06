FactoryGirl.define do
  factory :registration do |f|
    trait :existing do
      voter_id '1'
    end

    trait :residential_voter do
      residence           'in'
      requesting_absentee '0'
    end

    trait :domestic_absentee do
      residence           'in'
      requesting_absentee '1'
    end

    trait :overseas do
      residence           'outside'
      requesting_absentee '1'
    end

    factory :existing_residential_voter do
      voter_id            '123123123'
      current_residence   'in'
      first_name          'Wanda'
      middle_name         'Hunt'
      last_name           'Phepts'
      suffix              'III'
      phone               '540-555-1212'
      gender              'Female'
      dob                 Date.parse('1950-11-06 00:00:00.000')
      choose_party        '1'
      party               'Democratic Party'

      vvr_address_1       '518 Vance ST'
      vvr_county_or_city  'BRUNSWICK COUNTY'
      vvr_town            'Queensberry'
      vvr_state           'VA'
      vvr_zip5            '24201'
      vvr_zip4            '2445'
      vvr_is_rural        '0'

      ma_is_different     '1'
      ma_address          '518 Vance St'
      ma_city             'Queensberry'
      ma_state            'VA'
      ma_zip5             '24201'
      ma_zip4             '2445'

      pr_status           '0'

      is_confidential_address '1'
      ca_type             'TSC'

      be_official         '1'

      existing            true

      poll_locality       "BRUNSWICK COUNTY"
      poll_precinct       "220 - RATCLIFFE"
      poll_district       "FAIRFIELD DISTRICT"

      districts           [ [ 'Congressional',  [ '09', '9th District' ] ],
                            [ 'Senate',         [ '038', '38th District' ] ],
                            [ 'State House',    [ '003', '3rd District' ] ],
                            [ 'Local',          [ '', 'SOUTHERN DISTRICT' ] ] ]

      past_elections      [ [ '2007 November', 'Absentee' ] ]
      ob_eligible         true
    end

    factory :existing_overseas_voter do
      voter_id            '111222333'
      current_residence   'outside'
      first_name          'Overseas'
      last_name           'Marine'
      gender              'Male'
      dob                 40.years.ago

      vvr_address_1       '5 First ST'
      vvr_county_or_city  'BRISTOL CITY'
      vvr_state           'VA'
      vvr_zip5            '12345'
      vvr_zip4            ''
      vvr_is_rural        '0'

      vvr_uocava_residence_available '0'
      vvr_uocava_residence_unavailable_since 5.years.ago

      mau_type            'apo'
      apo_address         'Apo street'
      apo_city            'APO'
      apo_state           'AA'
      apo_zip5            '23456'

      outside_type        'ActiveDutyMerchantMarineOrArmedForces'
      service_branch      'Army'
      service_id          '112233'
      rank                'Major'

      pr_status           '0'
      current_absentee_until 2.months.from_now

      existing            true

      poll_locality       "LOUDOUN COUNTY"
      poll_precinct       "301 - PURCELLVILLE ONE"
      poll_district       "BLUE RIDGE DISTRICT"

      districts           [ [ 'Congressional',  [ '09', '9th District' ] ],
                            [ 'Senate',         [ '038', '38th District' ] ],
                            [ 'State House',    [ '003', '3rd District' ] ],
                            [ 'Local',          [ '', 'SOUTHERN DISTRICT' ] ] ]

      past_elections      [ [ '2007 November', 'Absentee' ] ]
    end
  end

  factory :active_form do
    form 'F'
  end
end
