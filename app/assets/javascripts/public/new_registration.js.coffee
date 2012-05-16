window.stepClass = (current, idx, def) ->
  def   = def || 'span2'
  match = if $.isArray(idx) then idx.indexOf(current) > -1 else idx == current
  max   = if $.isArray(idx) then idx[idx.length - 1] else idx
  (if match then 'current ' else if current > max then 'done ' else '') + def

filled = (v) -> v && !v.match(/^\s*$/)
join   = (a, sep) -> $.map(a, (i) -> if filled(i) then i else null).join(sep)

ko.bindingHandlers.vis = {
  update: (element, valueAccessor) ->
    value = ko.utils.unwrapObservable(valueAccessor())
    isCurrentlyVisible = !(element.style.display == "none")
    if value && !isCurrentlyVisible
      element.style.display = "block"
    else if !value && isCurrentlyVisible
      element.style.display = "none"
}

class Popover
  constructor: (id, errors) ->
    @errors = errors
    @el = $(id).popover(content: @popoverContent, title: 'Please review', html: 'html')
    @po = @el.data().popover

    errors.subscribe =>
      items = @errors()
      @po.enabled = items.length > 0

  popoverContent: =>
    items = @errors()
    if items.length > 0
      "<ul>#{('<li>' + i + '</li>' for i in items).join('')}</ul>"
    else
      null



class NewRegistration
  constructor: (initPage = 0) ->
    self      = this
    @oname    = 'registration_request'
    oid       = "##{@oname}"
    @pages    = [ 'eligibility', 'identity', 'address', 'options', 'confirm', 'oath', 'download', 'congratulations' ]

    overseas  = $('input#overseas').val() == '1'

    @eligibilitySection(overseas)
    @identitySection(overseas)
    @addressSection(overseas)
    @optionsSection(overseas)

    # Summary
    @summaryFullName = ko.computed =>
      join([ @firstName(), @middleName(), @lastName(), @suffix() ], ' ')

    @summaryDOB = ko.computed =>
      if filled(@dobMonth()) && filled(@dobDay()) && filled(@dobYear())
        moment([ @dobYear(), parseInt(@dobMonth()) - 1, @dobDay() ]).format("MMMM D, YYYY")

    @summaryAddress1 = ko.computed =>
      if @vvrIsRural()
        @vvrRural()
      else
        join([ join([ @vvrStreetNumber(), @vvrApt() ], '/'), @vvrStreetName(), @vvrStreetType() ], ' ')

    @summaryAddress2 = ko.computed =>
      unless @vvrIsRural()
        join([ @vvrCity(), join([ @vvrState(), join([ @vvrZip5(), @vvrZip4() ], '-') ], ' ') ], ', ')

    @summaryStatus = ko.computed => if @requestingAbsentee() then 'Absentee' else 'In person'


    $(".section").show()

    # Navigation
    @currentPageIdx         = ko.observable(initPage)
    @page                   = ko.computed(=> @pages[@currentPageIdx()])

    $(window).hashchange =>
      hash = location.hash
      newIdx = @pages.indexOf(hash.replace('#', ''))
      newIdx = 0 if newIdx == -1
      @currentPageIdx(newIdx)

  # --- Validation

  eligibilitySection: (overseas) =>
    @isCitizen              = ko.observable()
    @isOldEnough            = ko.observable()
    @residence              = ko.observable(if overseas then 'outside' else 'in')
    @overseas               = ko.computed => @residence() == 'outside'
    @domestic               = ko.computed => !@overseas()
    @rightsWereRevoked      = ko.observable()
    @rightsRevokationReason = ko.observable()
    @rightsWereRestored     = ko.observable()

    @eligibilityErrors = ko.computed =>
      errors = []
      errors.push("Citizenship criteria") unless @isCitizen()
      errors.push("Age criteria") unless @isOldEnough()
      errors.push("Voting rights criteria") unless (@rightsWereRevoked() == 'no' or (@rightsRevokationReason() and @rightsWereRestored() == 'yes'))
      errors

    @eligibilityInvalid = ko.computed => @eligibilityErrors().length > 0
    new Popover('#eligibility .next.btn', @eligibilityErrors)

  identitySection: (overseas) =>
    @firstName              = ko.observable()
    @middleName             = ko.observable()
    @lastName               = ko.observable()
    @suffix                 = ko.observable()
    @dobYear                = ko.observable()
    @dobMonth               = ko.observable()
    @dobDay                 = ko.observable()
    @gender                 = ko.observable()
    @ssn                    = ko.observable()
    @noSSN                  = ko.observable()
    @phone                  = ko.observable()
    @email                  = ko.observable()

    @identityErrors = ko.computed =>
      errors = []
      errors.push('Last name') unless filled(@lastName())
      errors.push('Date of birth') unless filled(@dobYear()) and filled(@dobMonth()) and filled(@dobDay())
      errors.push('Gender') unless filled(@gender())
      errors.push('Social Security #') unless filled(@ssn()) or @noSSN()
      errors

    @identityInvalid = ko.computed => @identityErrors().length > 0
    new Popover('#identity .next.btn', @identityErrors)

  addressSection: (overseas) =>
    @vvrIsRural             = ko.observable(false)
    @vvrRural               = ko.observable()
    @maIsSame               = ko.observable('yes')
    @hasExistingReg         = ko.observable('no')
    @erIsRural              = ko.observable(false)
    @vvrStreetNumber        = ko.observable()
    @vvrStreetName          = ko.observable()
    @vvrStreetType          = ko.observable()
    @vvrApt                 = ko.observable()
    @vvrCity                = ko.observable()
    @vvrState               = ko.observable()
    @vvrZip5                = ko.observable()
    @vvrZip4                = ko.observable()
    @vvrCountyOrCity        = ko.observable()
    @vvrCountyOrCity.subscribe (coc) => @vvrCity(coc.replace(/\s+city/i, '')) if coc.match(/\s+city/i)
    @vvrOverseasRA          = ko.observable()
    @maAddress1             = ko.observable()
    @maCity                 = ko.observable()
    @maState                = ko.observable()
    @maZip5                 = ko.observable()
    @mauType                = ko.observable()
    @mauAPO1                = ko.observable()
    @mauAPO2                = ko.observable()
    @mauAPOZip5             = ko.observable()
    @mauAddress             = ko.observable()
    @mauAddress2            = ko.observable()
    @mauCity                = ko.observable()
    @mauState               = ko.observable()
    @mauPostalCode          = ko.observable()
    @mauCountry             = ko.observable()
    @erStreetNumber         = ko.observable()
    @erStreetName           = ko.observable()
    @erStreetType           = ko.observable()
    @erCity                 = ko.observable()
    @erState                = ko.observable()
    @erZip5                 = ko.observable()
    @erIsRural              = ko.observable()
    @erRural                = ko.observable()
    @erCancel               = ko.observable()

    @domesticMAFilled = ko.computed =>
      @maIsSame() == 'yes' or
      filled(@maAddress1()) and
      filled(@maCity()) and
      filled(@maState()) and
      filled(@maZip5())

    @nonUSMAFilled = ko.computed =>
      filled(@mauAddress()) and
      filled(@mauCity()) and
      filled(@mauState()) and
      filled(@mauPostalCode()) and
      filled(@mauCountry())

    @overseasMAFilled = ko.computed =>
      if   @mauType() == 'apo'
      then filled(@mauAPO1()) and filled(@mauAPO2()) and filled(@mauAPOZip5())
      else @nonUSMAFilled()


    @addressesErrors = ko.computed =>
      errors = []

      residental =
        if   @vvrIsRural()
        then filled(@vvrRural())
        else filled(@vvrStreetNumber()) and
             filled(@vvrStreetName()) and
             filled(@vvrStreetType()) and
             filled(@vvrCity()) and
             filled(@vvrState()) and
             filled(@vvrZip5()) and
             filled(@vvrCountyOrCity())

      if @overseas()
        residental = residental and filled(@vvrOverseasRA())
        mailing = @overseasMAFilled()
      else
        mailing = @domesticMAFilled()

      existing =
        @hasExistingReg() == 'no' or
        @erCancel() and
        if   @erIsRural()
        then filled(@erRural())
        else filled(@erStreetNumber()) and
             filled(@erStreetName()) and
             filled(@erStreetType()) and
             filled(@erCity()) and
             filled(@erState()) and
             filled(@erZip5())

      errors.push("Registration address") unless residental
      errors.push("Mailing address") unless mailing
      errors.push("Existing registration") unless existing
      errors

    @addressesInvalid = ko.computed => @addressesErrors().length > 0
    new Popover('#mailing .next.btn', @addressesErrors)

  optionsSection: (overseas) =>
    @isConfidentialAddress  = ko.observable(false)
    @requestingAbsentee     = ko.observable(overseas)
    @rabElection            = ko.observable()
    @rabElectionName        = ko.observable()
    @rabElectionDate        = ko.observable()
    @abSendTo               = ko.observable()
    @outsideType            = ko.observable()
    @needsServiceDetails    = ko.computed => @outsideType() && @outsideType().match(/duty/)
    @serviceId              = ko.observable()
    @rank                   = ko.observable()

    @abSchoolName           = ko.observable()
    @abStreetNumber         = ko.observable()
    @abStreetName           = ko.observable()
    @abStreetType           = ko.observable()
    @abCity                 = ko.observable()
    @abState                = ko.observable()
    @abZip5                 = ko.observable()
    @abCountry              = ko.observable()

    @abSTAddress            = ko.observable()
    @abSTCity               = ko.observable()
    @abSTState              = ko.observable()
    @abSTZip5               = ko.observable()
    @abSTCountry            = ko.observable()

    @optionsErrors = ko.computed =>
      errors = []
      if @requestingAbsentee()
        if @overseas()
          errors.push("Absense type") unless filled(@outsideType())
          errors.push("Service details") if @needsServiceDetails() and (!filled(@serviceId()) || !filled(@rank()))
        else
          if !filled(@rabElection()) or (@rabElection() == 'other' and (!filled(@rabElectionName()) or !filled(@rabElectionDate())))
            errors.push("Election details")

          if !filled(@abSchoolName()) or
            !filled(@abStreetNumber()) or
            !filled(@abSchoolName()) or
            !filled(@abStreetType()) or
            !filled(@abCity()) or
            !filled(@abState()) or
            !filled(@abZip5()) or
            !filled(@abCountry())
              errors.push("School details")

          if !filled(@abSendTo()) or
            (@abSendTo() == 'other' and
            ( !filled(@abSTAddress()) or
              !filled(@abSTCity()) or
              !filled(@abSTState()) or
              !filled(@abSTZip5()) or
              !filled(@abSTCountry()) ) )
                errors.push("Absentee ballot destination")

      errors

    @optionsInvalid = ko.computed => @optionsErrors().length > 0
    new Popover('#options .next.btn', @optionsErrors)

  # --- Navigation

  prevPage: => window.history.back()
  nextPage: (_, a) =>
    return if $(a.target).hasClass('disabled')
    newIdx = @currentPageIdx() + 1
    location.hash = @pages[newIdx]

ko.applyBindings(new NewRegistration(3))