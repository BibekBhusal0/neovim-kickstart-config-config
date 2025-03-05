( jsx_closing_element ) @jsx.close
( jsx_opening_element ) @jsx.start
( jsx_self_closing_element ) @jsx.outer
( jsx_element ) @jsx.outer


(jsx_element
  (jsx_opening_element)
  ([
    ( jsx_element )
    ( jsx_text )
    ( jsx_expression )
    (jsx_opening_element)
    (jsx_closing_element)
    (jsx_self_closing_element)
  ])* @jsx.inner
  (jsx_closing_element)) @jsx.outer
