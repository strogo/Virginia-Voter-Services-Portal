$ ->
  $(".mark-online").each (i, f) ->
    form = $(f)
    $("a.submit", form).click (e) ->
      e.preventDefault()
      form.submit()
