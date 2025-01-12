# DO NOT EDIT
# This file was automatically generated using json-schema-to-nickel
let _js2n__-prdslib
  = {
    allOf
      : Array (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `allOf preds` succeeds if all of the predicates in `preds` succeed
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.1]
      "%
      = fun
          preds
          x
          =>
          std.array.fold_right
            (fun pred acc => (match { 'Ok => acc, 'Err s => 'Err s, }) (pred x))
            'Ok preds,
    always : Dyn -> [| 'Ok, 'Err String |] = std.function.const 'Ok,
    anyOf
      : Array (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `anyOf preds` succeeds if at least one of the predicates in `preds` succeeds
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.2]
      "%
      = fun
          preds
          x
          =>
          (match {
            'Ok =>
              'Ok,
            'Errs
              msgs =>
              'Err
                m%"
                  anyOf: none of the options matched
                  %{std.string.join
                    m%"
                      
                      
                    "% msgs}
                "%,
          })
            (std.array.fold_right
              (fun
                pred
                acc
                =>
                (match {
                  'Ok =>
                    'Ok,
                  'Errs
                    msgs =>
                    (match {
                      'Ok =>
                        'Ok,
                      'Err
                        msg =>
                        'Errs ([ "  - %{msg}" ] @ msgs),
                    }) (pred x),
                }) acc) ('Errs [  ]) preds),
    arrays =
      {
          additionalItems
            : (Dyn -> [| 'Ok, 'Err String |])
            -> Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.2]"
            = fun
                pred
                start
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  let value_length
                      = std.array.length x
                      in
                    if start >= value_length then
                        'Ok
                      else
                        arrayOf pred
                          ((std.array.slice start value_length x)
                          | Dyn),
          arrayOf
            : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              Apply a predicate to all elements of an array, succeeding if all
              applications succeed.
            "%
            = fun
                pred
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  std.array.fold_right
                      (fun
                        x
                        acc
                        =>
                        (match { 'Ok => acc, 'Err msg => 'Err msg, }) (pred x))
                      'Ok x,
          contains
            : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.6]"
            = fun
                pred
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  (match {
                      'Ok =>
                        'Ok,
                      'Errs
                        msgs =>
                        'Err
                          m%"
                            contains: no elements matched
                            %{std.string.join
                              m%"
                                
                                
                              "% msgs}
                          "%,
                    })
                      (std.array.fold_right
                        (fun
                          x
                          acc
                          =>
                          (match {
                            'Ok =>
                              'Ok,
                            'Errs
                              msgs =>
                              (match {
                                'Ok =>
                                  'Ok,
                                'Err
                                  msg =>
                                  'Errs ([ "  - %{msg}" ] @ msgs),
                              }) (pred x),
                          }) acc) ('Errs [  ]) x),
          items
            : Array (Dyn -> [| 'Ok, 'Err String |])
            -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.1]"
            = fun
                preds
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  let x
                    | Array Dyn
                    = x
                    in
                  let length_to_check
                      = std.number.min (std.array.length preds)
                        (std.array.length x)
                      in
                    std.array.fold_right
                        (fun
                          i
                          acc
                          =>
                          (match { 'Err msg => 'Err msg, 'Ok => acc, })
                            (std.array.at i preds (std.array.at i x))) 'Ok
                        (std.array.range 0 length_to_check),
          maxItems
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `maxItems n x` fails if `x` is an array of length strictly greater than `n` and succeeds otherwise.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.3]
            "%
            = fun
                n
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  if (std.array.length (x | Array Dyn)) > n then
                    'Err
                      "array is longer than %{std.string.from_number n} items"
                  else
                    'Ok,
          minItems
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `minItems n x` fails if `x` is an array of length strictly smaller than `n` and succeeds otherwise.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.4]
            "%
            = fun
                n
                x
                =>
                if !(std.is_array x) then
                  'Ok
                else
                  if (std.array.length (x | Array Dyn)) < n then
                    'Err
                      "array is shorter than %{std.string.from_number n} items"
                  else
                    'Ok,
          uniqueItems
            : Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              Succeeds for any array if its elements are pairwise distinct.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.5]
            "%
            = let find_duplicate
                : Array Dyn
                -> {
                  has_duplicate : Bool,
                  duplicate : Dyn,
                  seen : { _ : Bool }
                }
                = std.array.fold_right
                  (fun
                    elt
                    acc
                    =>
                    if acc.has_duplicate then
                      acc
                    else
                      let index
                        = std.serialize 'Json elt
                        in
                      if std.record.has_field index acc.seen then
                          {
                            duplicate = elt,
                            has_duplicate = true,
                            seen = acc.seen,
                          }
                        else
                          {
                            duplicate = null,
                            has_duplicate = false,
                            seen = std.record.insert index true acc.seen,
                          })
                  { duplicate = null, has_duplicate = false, seen = {}, }
                in
              fun
                  x
                  =>
                  if !(std.is_array x) then
                    'Ok
                  else
                    let { has_duplicate, duplicate, .. }
                      = find_duplicate (x | Array Dyn)
                      in
                    if has_duplicate then
                        'Err "duplicate found: %{std.serialize 'Json duplicate}"
                      else
                        'Ok,
        },
    const
      : Dyn -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `const value x` succeeds if and only if `x` is equal to `value`
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.3]
      "%
      = fun
          value
          x
          =>
          if x == value then
            'Ok
          else
            'Err "expected %{std.serialize 'Json value}",
    contract_from_predicate
      : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> Dyn -> Dyn
      = fun
          predicate
          label
          value
          =>
          (match {
            'Ok =>
              value,
            'Err
              msg =>
              (std.contract.blame_with_message msg label)
              | Dyn,
          }) (predicate value),
    enum
      : Array Dyn -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `enum values x` succeeds if and only if `x` is equal to one of the elements of `values`.
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.2]
      "%
      = let checkEqual
          = fun
            input
            variant
            =>
            (input == variant)
            || ((std.is_enum input)
            && (((std.string.from_enum input) == variant)
            | Bool))
          in
        fun
            values
            x
            =>
            std.array.fold_right
              (fun value acc => if checkEqual x value then 'Ok else acc)
              ('Err "expected one of %{std.serialize 'Json (values | Dyn)}")
              values,
    from_simple_predicate
      : String -> (Dyn -> Bool) -> Dyn -> [| 'Ok, 'Err String |]
      | doc "Convert a simple boolean predicate into a predicate supporting error messages"
      = fun error' pred x => if pred x then 'Ok else 'Err error',
    ifThenElse
      : (Dyn -> [| 'Ok, 'Err String |])
      -> (Dyn -> [| 'Ok, 'Err String |])
      -> (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `ifThenElse i t e` first checks if the predicate `i` succeeds. If it does, it's equivalent to `t`, otherwise it's equivalent to `e`.
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.6]
      "%
      = fun i t e x => (match { 'Ok => t x, 'Err msg => e x, }) (i x),
    isType
      : [| '"Array", '"Bool", 'Integer, 'Null, '"Number", 'Record, '"String" |]
      -> Dyn -> [| 'Ok, 'Err String |]
      = fun
          t
          =>
          (match {
            'Null =>
              from_simple_predicate "expected `null`" (fun x => x == null),
            'Integer =>
              from_simple_predicate "expected an integer"
                (fun
                  x
                  =>
                  (std.is_number x) && (std.number.is_integer (x | Number))),
            _ =>
              from_simple_predicate
                "value is not of type %{std.string.from_enum t}"
                (fun x => (std.typeof x) == t),
          }) t,
    never : Dyn -> [| 'Ok, 'Err String |] = std.function.const ('Err "never"),
    not
      : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `not pred` succeeds if and only if `pred` fails
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.4]
      "%
      = fun
          pred
          x
          =>
          (match {
            'Ok =>
              'Err "Inverted predicate succeeded unexpectedly",
            'Err
              msg =>
              'Ok,
          }) (pred x),
    numbers =
      {
          exclusiveMaximum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.3]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) < limit then
                    'Ok
                  else
                    'Err
                      "expected an exclusive maximum of %{std.string.from_number
                        limit}",
          exclusiveMinimum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.5]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) > limit then
                    'Ok
                  else
                    'Err
                      "expected an exclusive minimum of %{std.string.from_number
                        limit}",
          maximum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.2]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) <= limit then
                    'Ok
                  else
                    'Err
                      "expected a maximum of %{std.string.from_number limit}",
          minimum
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.4]"
            = fun
                limit
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if (x | Number) >= limit then
                    'Ok
                  else
                    'Err
                      "expected a minimum of %{std.string.from_number limit}",
          multipleOf
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.1]"
            = fun
                mult
                x
                =>
                if !(std.is_number x) then
                  'Ok
                else
                  if std.number.is_integer ((x | Number) / mult) then
                    'Ok
                  else
                    'Err
                      "expected a multiple of %{std.string.from_number mult}",
        },
    oneOf
      : Array (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
      | doc m%"
        `oneOf preds` succeeds if precisely one of the predicates in `preds` succeeds
        Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.3]
      "%
      = fun
          preds
          x
          =>
          let count_ok
            : Array [| 'Ok, 'Err String |] -> Number
            = fun
              results
              =>
              std.array.fold_left (fun n b => if b == 'Ok then n + 1 else n) 0
                results
            in
          let results
              = std.array.map (fun pred => pred x) preds
              in
            let count
                = count_ok results
                in
              if count == 0 then
                  let errors
                    = std.array.flat_map
                      (fun
                        result
                        =>
                        (match { 'Ok => [  ], 'Err s => [ "  - %{s}" ], })
                          result) results
                    in
                  'Err
                      m%"
                        oneOf: none of the options matched
                        %{std.string.join
                          m%"
                            
                            
                          "% errors}
                      "%
                else
                  if count > 1 then
                    'Err "oneOf: more than one of the options matched"
                  else
                    'Ok,
    records =
      {
          dependencies
            : { _ : Dyn } -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.7]"
            = let mustHaveFields
                : Array String -> { _ : Dyn } -> [| 'Ok, 'Err String |]
                = fun
                  fields
                  x
                  =>
                  std.array.fold_right
                    (fun
                      field
                      acc
                      =>
                      if !(std.record.has_field field x) then
                        'Err "expected field `%{field}`"
                      else
                        acc) 'Ok fields
                in
              fun
                  deps
                  x
                  =>
                  if !(std.is_record x) then
                    'Ok
                  else
                    let x
                      | { _ : Dyn }
                      = x
                      in
                    std.array.fold_right
                        (fun
                          { field, value, }
                          =>
                          fun
                            acc
                            =>
                            if !(std.record.has_field field x) then
                              acc
                            else
                              let result
                                = if std.is_array value then
                                  mustHaveFields (value | Array String) x
                                else
                                  let pred
                                    | Dyn -> [| 'Ok, 'Err String |]
                                    = value
                                    in
                                  pred (x | Dyn)
                                in
                              (match {
                                  'Err
                                    msg =>
                                    'Err
                                      "dependency of `%{field}` failed: %{msg}",
                                  'Ok =>
                                    acc,
                                }) result) 'Ok (std.record.to_array deps),
          maxProperties
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `maxProperties n x` fails if `x` is a record containing stricly more than `n` fields.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun
                n
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  if (std.record.length (x | { _ : Dyn })) > n then
                    'Err
                      "record contains more than %{std.string.from_number
                        n} fields"
                  else
                    'Ok,
          minProperties
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `minProperties n x` fails if `x` is a record containing stricly less than `n` fields.
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun
                n
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  if (std.record.length (x | { _ : Dyn })) < n then
                    'Err
                      "record contains fewer than %{std.string.from_number
                        n} fields"
                  else
                    'Ok,
          propertyNames
            : (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.8]"
            = fun
                pred
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  std.array.fold_right
                    (fun
                      field
                      acc
                      =>
                      (match {
                        'Err
                          msg =>
                          'Err
                            "field `%{field}` did not validate against `propertyNames` schema",
                        'Ok =>
                          acc,
                      }) (pred (field | Dyn))) 'Ok
                    (std.record.fields (x | { _ : Dyn })),
          record
            : { _ : Dyn -> [| 'Ok, 'Err String |] }
            -> { _ : Dyn -> [| 'Ok, 'Err String |] }
            -> Bool
            -> (Dyn -> [| 'Ok, 'Err String |]) -> Dyn -> [| 'Ok, 'Err String |]
            | doc m%"
              `record properties patternProperties additionalAllowed
              additionalProperties x` is a combination of the `properties`,
              `patternProperties` and `additionalProperties` validation keywords in
              JSON schema.
              
              Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5]
            "%
            = fun
                properties
                patternProperties
                additionalAllowed
                additionalProperties
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  let x
                    | { _ : Dyn }
                    = x
                    in
                  let check_properties
                      : {
                        result : [| 'Ok, 'Err String |],
                        checked : { _ : Bool }
                      }
                      = std.array.fold_right
                        (fun
                          { field, value, }
                          =>
                          fun
                            acc
                            =>
                            if !(std.record.has_field field x) then
                              acc
                            else
                              (match {
                                'Err
                                  msg =>
                                  {
                                    checked : { _ : Bool } = {},
                                    result =
                                      'Err
                                          "field `%{field}` didn't validate: %{msg}",
                                  },
                                'Ok =>
                                  {
                                    checked =
                                      std.record.insert field true acc.checked,
                                    result = acc.result,
                                  },
                              }) (value x."%{field}"))
                        { checked = {}, result = 'Ok, }
                        (std.record.to_array properties)
                      in
                    let matching_fields
                        : String -> { _ : Dyn }
                        = fun
                          pattern
                          =>
                          let matcher
                            = std.string.is_match pattern
                            in
                          std.array.fold_left
                              (fun
                                acc
                                =>
                                fun
                                  { field, value, }
                                  =>
                                  if matcher field then
                                    std.record.insert field value acc
                                  else
                                    acc) {} (std.record.to_array x)
                        in
                      let check_pattern_properties
                          : {
                            result : [| 'Ok, 'Err String |],
                            checked : { _ : Bool }
                          }
                          = std.array.fold_right
                            (fun
                              { field = pattern, value = pred, }
                              =>
                              fun
                                acc
                                =>
                                (match {
                                  r @ { result = 'Err msg, .. } =>
                                    r,
                                  { result = 'Ok, checked = ch, } =>
                                    {
                                      checked =
                                        std.array.fold_left
                                            (fun
                                              r
                                              field
                                              =>
                                              if !(std.record.has_field field
                                                r) then
                                                std.record.insert field true r
                                              else
                                                r) acc.checked
                                            (std.record.fields ch),
                                      result = acc.result,
                                    },
                                })
                                  (std.array.fold_right
                                    (fun
                                      { field, value, }
                                      =>
                                      fun
                                        acc
                                        =>
                                        (match {
                                          'Err
                                            msg =>
                                            {
                                              checked : { _ : Bool } = {},
                                              result =
                                                'Err
                                                    "field `%{field}` didn't validate: %{msg}",
                                            },
                                          'Ok =>
                                            {
                                              checked =
                                                std.record.insert field true
                                                    acc.checked,
                                              result = acc.result,
                                            },
                                        }) (pred value))
                                    {
                                      checked : { _ : Bool } = {},
                                      result = 'Ok,
                                    }
                                    (std.record.to_array
                                      (matching_fields pattern))))
                            { checked : { _ : Bool } = {}, result = 'Ok, }
                            (std.record.to_array patternProperties)
                          in
                        let remaining_fields
                            = std.array.fold_left
                              (fun
                                acc
                                field
                                =>
                                if !(std.record.has_field field acc) then
                                  acc
                                else
                                  std.record.remove field acc) x
                              ((std.record.fields check_properties.checked)
                              @ (std.record.fields
                                check_pattern_properties.checked))
                            in
                          let check_additional_properties
                              : [| 'Ok, 'Err String |]
                              = if (!additionalAllowed)
                              && (!(std.record.is_empty remaining_fields)) then
                                'Err
                                  "extra fields %{std.serialize 'Json
                                    ((std.record.fields remaining_fields)
                                    | Dyn)}"
                              else
                                std.array.fold_right
                                  (fun
                                    { field, value, }
                                    =>
                                    fun
                                      acc
                                      =>
                                      (match {
                                        'Err
                                          msg =>
                                          'Err
                                            "field `%{field}` didn't validate: %{msg}",
                                        'Ok =>
                                          acc,
                                      }) (additionalProperties value)) 'Ok
                                  (std.record.to_array remaining_fields)
                              in
                            (match {
                                'Err
                                  msg =>
                                  check_properties.result,
                                'Ok =>
                                  (match {
                                    'Err
                                      msg =>
                                      check_pattern_properties.result,
                                    'Ok =>
                                      check_additional_properties,
                                  }) check_pattern_properties.result,
                              }) check_properties.result,
          required
            : Array String -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.3]"
            = fun
                fields
                x
                =>
                if !(std.is_record x) then
                  'Ok
                else
                  std.array.fold_right
                    (fun
                      field
                      acc
                      =>
                      if !(std.record.has_field field (x | { _ : Dyn })) then
                        'Err "missing required field %{field}"
                      else
                        acc) 'Ok fields,
        },
    strings =
      {
          maxLength
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.1]"
            = fun
                limit
                x
                =>
                if !(std.is_string x) then
                  'Ok
                else
                  if (std.string.length (x | String)) <= limit then
                    'Ok
                  else
                    'Err
                      "expected a string of length no larger than %{std.string.from_number
                        limit}",
          minLength
            : Number -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.2]"
            = fun
                limit
                x
                =>
                if !(std.is_string x) then
                  'Ok
                else
                  if (std.string.length (x | String)) >= limit then
                    'Ok
                  else
                    'Err
                      "expected a string of length no smaller than %{std.string.from_number
                        limit}",
          pattern
            : String -> Dyn -> [| 'Ok, 'Err String |]
            | doc "Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.3]"
            = fun
                pattern
                x
                =>
                if !(std.is_string x) then
                  'Ok
                else
                  if std.string.is_match pattern (x | String) then
                    'Ok
                  else
                    'Err "expected a string matching the pattern `%{pattern}`",
        },
  }
  in
let rec _js2n__-refsenv
    = {
      "_js2n__-:definitions/blkio_limit!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  rate =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/blkio_weight!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path = _js2n__-prdslib.isType '"String",
                  weight =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/command!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType 'Null,
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/config!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  content = _js2n__-prdslib.isType '"String",
                  environment = _js2n__-prdslib.isType '"String",
                  external =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Record
                            ],
                          _js2n__-prdslib.records.record
                            { name = _js2n__-prdslib.isType '"String", } {} true
                            _js2n__-prdslib.always
                        ],
                  file = _js2n__-prdslib.isType '"String",
                  labels =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  template_driver = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/deployment!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  endpoint_mode = _js2n__-prdslib.isType '"String",
                  labels =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  mode = _js2n__-prdslib.isType '"String",
                  placement =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              constraints =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                              max_replicas_per_node =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              preferences =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                spread =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              }
                                              {
                                                "^x-" = _js2n__-prdslib.always,
                                              } false _js2n__-prdslib.never
                                          ])
                                    ],
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  replicas =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  resources =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              limits =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          cpus =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType
                                                    '"String"
                                                ],
                                          memory =
                                            _js2n__-prdslib.isType '"String",
                                          pids =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.isType
                                                    '"String"
                                                ],
                                        } { "^x-" = _js2n__-prdslib.always, }
                                        false _js2n__-prdslib.never
                                    ],
                              reservations =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          cpus =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType
                                                    '"String"
                                                ],
                                          devices =
                                            _js2n__-refsenv."_js2n__-:definitions/devices!predicate",
                                          generic_resources =
                                            _js2n__-refsenv."_js2n__-:definitions/generic_resources!predicate",
                                          memory =
                                            _js2n__-prdslib.isType '"String",
                                        } { "^x-" = _js2n__-prdslib.always, }
                                        false _js2n__-prdslib.never
                                    ],
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  restart_policy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              condition = _js2n__-prdslib.isType '"String",
                              delay = _js2n__-prdslib.isType '"String",
                              max_attempts =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              window = _js2n__-prdslib.isType '"String",
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  rollback_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delay = _js2n__-prdslib.isType '"String",
                              failure_action = _js2n__-prdslib.isType '"String",
                              max_failure_ratio =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              monitor = _js2n__-prdslib.isType '"String",
                              order =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "start-first", "stop-first" ]
                                    ],
                              parallelism =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"String"
                                    ],
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  update_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delay = _js2n__-prdslib.isType '"String",
                              failure_action = _js2n__-prdslib.isType '"String",
                              max_failure_ratio =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              monitor = _js2n__-prdslib.isType '"String",
                              order =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "start-first", "stop-first" ]
                                    ],
                              parallelism =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"String"
                                    ],
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/development!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  watch =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "action", "path" ],
                                _js2n__-prdslib.records.record
                                  {
                                    action =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "rebuild",
                                                "sync",
                                                "restart",
                                                "sync+restart",
                                                "sync+exec"
                                              ]
                                          ],
                                    exec =
                                      _js2n__-refsenv."_js2n__-:definitions/service_hook!predicate",
                                    ignore =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    path = _js2n__-prdslib.isType '"String",
                                    target = _js2n__-prdslib.isType '"String",
                                  } { "^x-" = _js2n__-prdslib.always, } false
                                  _js2n__-prdslib.never
                              ])
                        ],
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/devices!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "capabilities" ],
                    _js2n__-prdslib.records.record
                      {
                        capabilities =
                          _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                        count =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Integer
                              ],
                        device_ids =
                          _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                        driver = _js2n__-prdslib.isType '"String",
                        options =
                          _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                      } { "^x-" = _js2n__-prdslib.always, } false
                      _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/env_file!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.oneOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "path" ],
                            _js2n__-prdslib.records.record
                              {
                                format = _js2n__-prdslib.isType '"String",
                                path = _js2n__-prdslib.isType '"String",
                                required =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"Bool",
                                        _js2n__-prdslib.isType '"String"
                                      ],
                              } {} false _js2n__-prdslib.never
                          ]
                      ])
                ]
            ],
      "_js2n__-:definitions/extra_hosts!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      ".+" =
                        _js2n__-prdslib.oneOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ]
                            ],
                    } false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ],
      "_js2n__-:definitions/generic_resources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        discrete_resource_spec =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    kind = _js2n__-prdslib.isType '"String",
                                    value =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.isType '"String"
                                          ],
                                  } { "^x-" = _js2n__-prdslib.always, } false
                                  _js2n__-prdslib.never
                              ],
                      } { "^x-" = _js2n__-prdslib.always, } false
                      _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/gpus!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        capabilities =
                          _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                        count =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Integer
                              ],
                        device_ids =
                          _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                        driver = _js2n__-prdslib.isType '"String",
                        options =
                          _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                      } { "^x-" = _js2n__-prdslib.always, } false
                      _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:definitions/healthcheck!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  interval = _js2n__-prdslib.isType '"String",
                  retries =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  start_interval = _js2n__-prdslib.isType '"String",
                  start_period = _js2n__-prdslib.isType '"String",
                  test =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.isType '"String")
                            ]
                        ],
                  timeout = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/include!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      env_file =
                        _js2n__-refsenv."_js2n__-:definitions/string_or_list!predicate",
                      path =
                        _js2n__-refsenv."_js2n__-:definitions/string_or_list!predicate",
                      project_directory = _js2n__-prdslib.isType '"String",
                    } {} false _js2n__-prdslib.never
                ]
            ],
      "_js2n__-:definitions/label_file!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String")
                ]
            ],
      "_js2n__-:definitions/list_of_strings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/list_or_dict!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      ".+" =
                        _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType 'Null
                            ],
                    } false _js2n__-prdslib.never
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.isType '"String"),
                  _js2n__-prdslib.arrays.uniqueItems
                ]
            ],
      "_js2n__-:definitions/network!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  attachable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  driver = _js2n__-prdslib.isType '"String",
                  driver_opts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^.+$" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  enable_ipv6 =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  external =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Record
                            ],
                          _js2n__-prdslib.records.record
                            { name = _js2n__-prdslib.isType '"String", }
                            { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  internal =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  ipam =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              config =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                aux_addresses =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {}
                                                          {
                                                            "^.+$" =
                                                              _js2n__-prdslib.isType
                                                                  '"String",
                                                          } false
                                                          _js2n__-prdslib.never
                                                      ],
                                                gateway =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                ip_range =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                subnet =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              }
                                              {
                                                "^x-" = _js2n__-prdslib.always,
                                              } false _js2n__-prdslib.never
                                          ])
                                    ],
                              driver = _js2n__-prdslib.isType '"String",
                              options =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          "^.+$" =
                                            _js2n__-prdslib.isType '"String",
                                        } false _js2n__-prdslib.never
                                    ],
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  labels =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/secret!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  driver = _js2n__-prdslib.isType '"String",
                  driver_opts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^.+$" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  environment = _js2n__-prdslib.isType '"String",
                  external =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Record
                            ],
                          _js2n__-prdslib.records.record
                            { name = _js2n__-prdslib.isType '"String", } {} true
                            _js2n__-prdslib.always
                        ],
                  file = _js2n__-prdslib.isType '"String",
                  labels =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  name = _js2n__-prdslib.isType '"String",
                  template_driver = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/service!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  attach =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  blkio_config =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              device_read_bps =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/blkio_limit!predicate"
                                    ],
                              device_read_iops =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/blkio_limit!predicate"
                                    ],
                              device_write_bps =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/blkio_limit!predicate"
                                    ],
                              device_write_iops =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/blkio_limit!predicate"
                                    ],
                              weight =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.isType '"String"
                                    ],
                              weight_device =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        _js2n__-refsenv."_js2n__-:definitions/blkio_weight!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  build =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  additional_contexts =
                                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                                  args =
                                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                                  cache_from =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  cache_to =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  context = _js2n__-prdslib.isType '"String",
                                  dockerfile = _js2n__-prdslib.isType '"String",
                                  dockerfile_inline =
                                    _js2n__-prdslib.isType '"String",
                                  entitlements =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  extra_hosts =
                                    _js2n__-refsenv."_js2n__-:definitions/extra_hosts!predicate",
                                  isolation = _js2n__-prdslib.isType '"String",
                                  labels =
                                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                                  network = _js2n__-prdslib.isType '"String",
                                  no_cache =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                  platforms =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  privileged =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                  pull =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"Bool",
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                  secrets =
                                    _js2n__-refsenv."_js2n__-:definitions/service_config_or_secret!predicate",
                                  shm_size =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                  ssh =
                                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                                  tags =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  target = _js2n__-prdslib.isType '"String",
                                  ulimits =
                                    _js2n__-refsenv."_js2n__-:definitions/ulimits!predicate",
                                } { "^x-" = _js2n__-prdslib.always, } false
                                _js2n__-prdslib.never
                            ]
                        ],
                  cap_add =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  cap_drop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  cgroup =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "host", "private" ]
                        ],
                  cgroup_parent = _js2n__-prdslib.isType '"String",
                  command =
                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                  configs =
                    _js2n__-refsenv."_js2n__-:definitions/service_config_or_secret!predicate",
                  container_name = _js2n__-prdslib.isType '"String",
                  cpu_count =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.minimum 0
                            ]
                        ],
                  cpu_percent =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 100,
                              _js2n__-prdslib.numbers.minimum 0
                            ]
                        ],
                  cpu_period =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  cpu_quota =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  cpu_rt_period =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  cpu_rt_runtime =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  cpu_shares =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  cpus =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  cpuset = _js2n__-prdslib.isType '"String",
                  credential_spec =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              config = _js2n__-prdslib.isType '"String",
                              file = _js2n__-prdslib.isType '"String",
                              registry = _js2n__-prdslib.isType '"String",
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  depends_on =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9._-]+$" =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.required
                                            [ "condition" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              condition =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "service_started",
                                                          "service_healthy",
                                                          "service_completed_successfully"
                                                        ]
                                                    ],
                                              required =
                                                _js2n__-prdslib.isType '"Bool",
                                              restart =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Bool",
                                                      _js2n__-prdslib.isType
                                                        '"String"
                                                    ],
                                            }
                                            { "^x-" = _js2n__-prdslib.always, }
                                            false _js2n__-prdslib.never
                                        ],
                                } false _js2n__-prdslib.never
                            ]
                        ],
                  deploy =
                    _js2n__-refsenv."_js2n__-:definitions/deployment!predicate",
                  develop =
                    _js2n__-refsenv."_js2n__-:definitions/development!predicate",
                  device_cgroup_rules =
                    _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                  devices =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "source" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        permissions =
                                          _js2n__-prdslib.isType '"String",
                                        source =
                                          _js2n__-prdslib.isType '"String",
                                        target =
                                          _js2n__-prdslib.isType '"String",
                                      } { "^x-" = _js2n__-prdslib.always, }
                                      false _js2n__-prdslib.never
                                  ]
                              ])
                        ],
                  dns =
                    _js2n__-refsenv."_js2n__-:definitions/string_or_list!predicate",
                  dns_opt =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  dns_search =
                    _js2n__-refsenv."_js2n__-:definitions/string_or_list!predicate",
                  domainname = _js2n__-prdslib.isType '"String",
                  entrypoint =
                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                  env_file =
                    _js2n__-refsenv."_js2n__-:definitions/env_file!predicate",
                  environment =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  expose =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  extends =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required [ "service" ],
                              _js2n__-prdslib.records.record
                                {
                                  file = _js2n__-prdslib.isType '"String",
                                  service = _js2n__-prdslib.isType '"String",
                                } {} false _js2n__-prdslib.never
                            ]
                        ],
                  external_links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  extra_hosts =
                    _js2n__-refsenv."_js2n__-:definitions/extra_hosts!predicate",
                  gpus = _js2n__-refsenv."_js2n__-:definitions/gpus!predicate",
                  group_add =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number"
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  healthcheck =
                    _js2n__-refsenv."_js2n__-:definitions/healthcheck!predicate",
                  hostname = _js2n__-prdslib.isType '"String",
                  image = _js2n__-prdslib.isType '"String",
                  init =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  ipc = _js2n__-prdslib.isType '"String",
                  isolation = _js2n__-prdslib.isType '"String",
                  label_file =
                    _js2n__-refsenv."_js2n__-:definitions/label_file!predicate",
                  labels =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  logging =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              driver = _js2n__-prdslib.isType '"String",
                              options =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          "^.+$" =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType 'Null
                                                ],
                                        } true _js2n__-prdslib.always
                                    ],
                            } { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  mac_address = _js2n__-prdslib.isType '"String",
                  mem_limit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  mem_reservation =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Integer
                        ],
                  mem_swappiness =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  memswap_limit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  network_mode = _js2n__-prdslib.isType '"String",
                  networks =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {}
                                {
                                  "^[a-zA-Z0-9._-]+$" =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  aliases =
                                                    _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                                                  driver_opts =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {}
                                                            {
                                                              "^.+$" =
                                                                _js2n__-prdslib.anyOf
                                                                    [
                                                                      _js2n__-prdslib.isType
                                                                        '"String",
                                                                      _js2n__-prdslib.isType
                                                                        '"Number"
                                                                    ],
                                                            } true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  ipv4_address =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  ipv6_address =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  link_local_ips =
                                                    _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                                                  mac_address =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  "priority" =
                                                    _js2n__-prdslib.isType
                                                        '"Number",
                                                }
                                                {
                                                  "^x-" =
                                                    _js2n__-prdslib.always,
                                                } false _js2n__-prdslib.never
                                            ],
                                          _js2n__-prdslib.isType 'Null
                                        ],
                                } false _js2n__-prdslib.never
                            ]
                        ],
                  oom_kill_disable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  oom_score_adj =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.numbers.maximum 1000,
                              _js2n__-prdslib.numbers.minimum (-1000)
                            ]
                        ],
                  pid =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Null
                        ],
                  pids_limit =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  platform = _js2n__-prdslib.isType '"String",
                  ports =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        app_protocol =
                                          _js2n__-prdslib.isType '"String",
                                        host_ip =
                                          _js2n__-prdslib.isType '"String",
                                        mode = _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                        protocol =
                                          _js2n__-prdslib.isType '"String",
                                        published =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.isType 'Integer
                                              ],
                                        target =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType 'Integer,
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                      } { "^x-" = _js2n__-prdslib.always, }
                                      false _js2n__-prdslib.never
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  post_start =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/service_hook!predicate"
                        ],
                  pre_stop =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/service_hook!predicate"
                        ],
                  privileged =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  profiles =
                    _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate",
                  pull_policy =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "always",
                              "never",
                              "if_not_present",
                              "build",
                              "missing"
                            ]
                        ],
                  read_only =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  restart = _js2n__-prdslib.isType '"String",
                  runtime = _js2n__-prdslib.isType '"String",
                  scale =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ],
                  secrets =
                    _js2n__-refsenv."_js2n__-:definitions/service_config_or_secret!predicate",
                  security_opt =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  shm_size =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stdin_open =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  stop_grace_period = _js2n__-prdslib.isType '"String",
                  stop_signal = _js2n__-prdslib.isType '"String",
                  storage_opt = _js2n__-prdslib.isType 'Record,
                  sysctls =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  tmpfs =
                    _js2n__-refsenv."_js2n__-:definitions/string_or_list!predicate",
                  tty =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  ulimits =
                    _js2n__-refsenv."_js2n__-:definitions/ulimits!predicate",
                  user = _js2n__-prdslib.isType '"String",
                  userns_mode = _js2n__-prdslib.isType '"String",
                  uts = _js2n__-prdslib.isType '"String",
                  volumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        bind =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    create_host_path =
                                                      _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Bool",
                                                            _js2n__-prdslib.isType
                                                              '"String"
                                                          ],
                                                    propagation =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    recursive =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.enum
                                                              [
                                                                "enabled",
                                                                "disabled",
                                                                "writable",
                                                                "readonly"
                                                              ]
                                                          ],
                                                    selinux =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"String",
                                                            _js2n__-prdslib.enum
                                                              [ "z", "Z" ]
                                                          ],
                                                  }
                                                  {
                                                    "^x-" =
                                                      _js2n__-prdslib.always,
                                                  } false _js2n__-prdslib.never
                                              ],
                                        consistency =
                                          _js2n__-prdslib.isType '"String",
                                        read_only =
                                          _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType '"Bool",
                                                _js2n__-prdslib.isType '"String"
                                              ],
                                        source =
                                          _js2n__-prdslib.isType '"String",
                                        target =
                                          _js2n__-prdslib.isType '"String",
                                        tmpfs =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    mode =
                                                      _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Number",
                                                            _js2n__-prdslib.isType
                                                              '"String"
                                                          ],
                                                    size =
                                                      _js2n__-prdslib.oneOf
                                                          [
                                                            _js2n__-prdslib.allOf
                                                              [
                                                                _js2n__-prdslib.isType
                                                                  'Integer,
                                                                _js2n__-prdslib.numbers.minimum
                                                                  0
                                                              ],
                                                            _js2n__-prdslib.isType
                                                              '"String"
                                                          ],
                                                  }
                                                  {
                                                    "^x-" =
                                                      _js2n__-prdslib.always,
                                                  } false _js2n__-prdslib.never
                                              ],
                                        type = _js2n__-prdslib.isType '"String",
                                        volume =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    nocopy =
                                                      _js2n__-prdslib.anyOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              '"Bool",
                                                            _js2n__-prdslib.isType
                                                              '"String"
                                                          ],
                                                    subpath =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  }
                                                  {
                                                    "^x-" =
                                                      _js2n__-prdslib.always,
                                                  } false _js2n__-prdslib.never
                                              ],
                                      } { "^x-" = _js2n__-prdslib.always, }
                                      false _js2n__-prdslib.never
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  volumes_from =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  working_dir = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/service_config_or_secret!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            gid = _js2n__-prdslib.isType '"String",
                            mode =
                              _js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.isType '"String"
                                  ],
                            source = _js2n__-prdslib.isType '"String",
                            target = _js2n__-prdslib.isType '"String",
                            uid = _js2n__-prdslib.isType '"String",
                          } { "^x-" = _js2n__-prdslib.always, } false
                          _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:definitions/service_hook!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  command =
                    _js2n__-refsenv."_js2n__-:definitions/command!predicate",
                  environment =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  privileged =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  user = _js2n__-prdslib.isType '"String",
                  working_dir = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/string_or_list!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/list_of_strings!predicate"
            ],
      "_js2n__-:definitions/ulimits!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-z]+$" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType '"String"
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.required
                                [ "hard", "soft" ],
                              _js2n__-prdslib.records.record
                                {
                                  hard =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                  soft =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType '"String"
                                        ],
                                } { "^x-" = _js2n__-prdslib.always, } false
                                _js2n__-prdslib.never
                            ]
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/volume!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.isType 'Null
                ],
              _js2n__-prdslib.records.record
                {
                  driver = _js2n__-prdslib.isType '"String",
                  driver_opts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "^.+$" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number"
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  external =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"Bool",
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType 'Record
                            ],
                          _js2n__-prdslib.records.record
                            { name = _js2n__-prdslib.isType '"String", }
                            { "^x-" = _js2n__-prdslib.always, } false
                            _js2n__-prdslib.never
                        ],
                  labels =
                    _js2n__-refsenv."_js2n__-:definitions/list_or_dict!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } { "^x-" = _js2n__-prdslib.always, } false
                _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              configs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9._-]+$" =
                            _js2n__-refsenv."_js2n__-:definitions/config!predicate",
                        } false _js2n__-prdslib.never
                    ],
              include =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/include!predicate"
                    ],
              name = _js2n__-prdslib.isType '"String",
              networks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9._-]+$" =
                            _js2n__-refsenv."_js2n__-:definitions/network!predicate",
                        } true _js2n__-prdslib.always
                    ],
              secrets =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9._-]+$" =
                            _js2n__-refsenv."_js2n__-:definitions/secret!predicate",
                        } false _js2n__-prdslib.never
                    ],
              services =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9._-]+$" =
                            _js2n__-refsenv."_js2n__-:definitions/service!predicate",
                        } false _js2n__-prdslib.never
                    ],
              version = _js2n__-prdslib.isType '"String",
              volumes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9._-]+$" =
                            _js2n__-refsenv."_js2n__-:definitions/volume!predicate",
                        } false _js2n__-prdslib.never
                    ],
            } { "^x-" = _js2n__-prdslib.always, } false _js2n__-prdslib.never
        ])