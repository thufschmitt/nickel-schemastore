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
      "_js2n__-:definitions/ARN!predicate" = _js2n__-prdslib.always,
      "_js2n__-:definitions/AZSubnetMapping!predicate"
        | doc "holds subnet to AZ mappings. If the key is an AZ, that also becomes the name of the subnet otherwise use the key to refer to this subnet."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/AZSubnetSpec!predicate"
            ],
      "_js2n__-:definitions/AZSubnetSpec!predicate" =
        _js2n__-prdslib.records.record
            {
              az = _js2n__-prdslib.isType '"String",
              cidr = _js2n__-prdslib.always,
              id = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/AccessConfig!predicate"
        | doc "specifies the access config for a cluster."
        = _js2n__-prdslib.records.record
            {
              accessEntries =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/AccessEntry!predicate"
                    ],
              authenticationMode = _js2n__-prdslib.always,
              bootstrapClusterCreatorAdminPermissions =
                _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/AccessEntry!predicate"
        | doc "represents an access entry for managing access to a cluster."
        = _js2n__-prdslib.records.record
            {
              accessPolicies =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/AccessPolicy!predicate"
                    ],
              kubernetesGroups =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              kubernetesUsername = _js2n__-prdslib.isType '"String",
              principalARN =
                _js2n__-refsenv."_js2n__-:definitions/ARN!predicate",
              type = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/AccessPolicy!predicate"
        | doc "An AccessPolicy represents a policy to associate with an access entry."
        = _js2n__-prdslib.records.record
            {
              accessScope =
                _js2n__-refsenv."_js2n__-:definitions/AccessScope!predicate",
              policyARN = _js2n__-refsenv."_js2n__-:definitions/ARN!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/AccessScope!predicate"
        | doc "defines the scope of an access policy."
        = _js2n__-prdslib.records.record
            {
              namespaces =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              type = _js2n__-prdslib.always,
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/Addon!predicate"
        | doc "holds the EKS addon configuration"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  attachPolicy =
                    _js2n__-refsenv."_js2n__-:definitions/InlineDocument!predicate",
                  attachPolicyARNs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  configurationValues = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  owners =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  permissionsBoundary = _js2n__-prdslib.isType '"String",
                  podIdentityAssociations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/PodIdentityAssociation!predicate"
                        ],
                  publishers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  resolveConflicts = _js2n__-prdslib.always,
                  serviceAccountRoleARN = _js2n__-prdslib.isType '"String",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  useDefaultPodIdentityAssociations =
                    _js2n__-prdslib.isType '"Bool",
                  version = _js2n__-prdslib.isType '"String",
                  wellKnownPolicies =
                    _js2n__-refsenv."_js2n__-:definitions/WellKnownPolicies!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/AddonsConfig!predicate"
        | doc "holds the addons config."
        = _js2n__-prdslib.records.record
            {
              autoApplyPodIdentityAssociations = _js2n__-prdslib.isType '"Bool",
              disableDefaultAddons = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/AutoModeConfig!predicate" =
        _js2n__-prdslib.records.record
            {
              enabled = _js2n__-prdslib.isType '"Bool",
              nodePools =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              nodeRoleARN =
                _js2n__-refsenv."_js2n__-:definitions/ARN!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/CapacityReservation!predicate"
        | doc "defines a nodegroup's Capacity Reservation targeting option"
        = _js2n__-prdslib.records.record
            {
              capacityReservationPreference = _js2n__-prdslib.isType '"String",
              capacityReservationTarget =
                _js2n__-refsenv."_js2n__-:definitions/CapacityReservationTarget!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/CapacityReservationTarget!predicate" =
        _js2n__-prdslib.records.record
            {
              capacityReservationID = _js2n__-prdslib.isType '"String",
              capacityReservationResourceGroupARN =
                _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterCloudWatch!predicate"
        | doc "contains config parameters related to CloudWatch"
        = _js2n__-prdslib.records.record
            {
              clusterLogging =
                _js2n__-refsenv."_js2n__-:definitions/ClusterCloudWatchLogging!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterCloudWatchLogging!predicate"
        | doc "container config parameters related to cluster logging"
        = _js2n__-prdslib.records.record
            {
              enableTypes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "api",
                                "audit",
                                "authenticator",
                                "controllerManager",
                                "scheduler",
                                "all",
                                "*"
                              ]
                          ])
                    ],
              logRetentionInDays = _js2n__-prdslib.isType 'Integer,
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterConfig!predicate"
        | doc "a simple config, to be replaced with Cluster API"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required
                [ "apiVersion", "kind", "metadata" ],
              _js2n__-prdslib.records.record
                {
                  accessConfig =
                    _js2n__-refsenv."_js2n__-:definitions/AccessConfig!predicate",
                  addons =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Addon!predicate"
                        ],
                  addonsConfig =
                    _js2n__-refsenv."_js2n__-:definitions/AddonsConfig!predicate",
                  apiVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "eksctl.io/v1alpha5" ]
                        ],
                  autoModeConfig =
                    _js2n__-refsenv."_js2n__-:definitions/AutoModeConfig!predicate",
                  availabilityZones =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  cloudWatch =
                    _js2n__-refsenv."_js2n__-:definitions/ClusterCloudWatch!predicate",
                  fargateProfiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FargateProfile!predicate"
                        ],
                  gitops =
                    _js2n__-refsenv."_js2n__-:definitions/GitOps!predicate",
                  iam =
                    _js2n__-refsenv."_js2n__-:definitions/ClusterIAM!predicate",
                  iamIdentityMappings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/IAMIdentityMapping!predicate"
                        ],
                  identityProviders =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/IdentityProvider!predicate"
                        ],
                  karpenter =
                    _js2n__-refsenv."_js2n__-:definitions/Karpenter!predicate",
                  kind =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "ClusterConfig" ]
                        ],
                  kubernetesNetworkConfig =
                    _js2n__-refsenv."_js2n__-:definitions/KubernetesNetworkConfig!predicate",
                  localZones =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  managedNodeGroups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ManagedNodeGroup!predicate"
                        ],
                  metadata =
                    _js2n__-refsenv."_js2n__-:definitions/ClusterMeta!predicate",
                  nodeGroups =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NodeGroup!predicate"
                        ],
                  outpost =
                    _js2n__-refsenv."_js2n__-:definitions/Outpost!predicate",
                  privateCluster =
                    _js2n__-refsenv."_js2n__-:definitions/PrivateCluster!predicate",
                  remoteNetworkConfig =
                    _js2n__-refsenv."_js2n__-:definitions/RemoteNetworkConfig!predicate",
                  secretsEncryption =
                    _js2n__-refsenv."_js2n__-:definitions/SecretsEncryption!predicate",
                  vpc =
                    _js2n__-refsenv."_js2n__-:definitions/ClusterVPC!predicate",
                  zonalShiftConfig =
                    _js2n__-refsenv."_js2n__-:definitions/ZonalShiftConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ClusterEndpoints!predicate"
        | doc "holds cluster api server endpoint access information"
        = _js2n__-prdslib.records.record
            {
              privateAccess = _js2n__-prdslib.isType '"Bool",
              publicAccess = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterIAM!predicate"
        | doc "holds all IAM attributes of a cluster"
        = _js2n__-prdslib.records.record
            {
              fargatePodExecutionRoleARN = _js2n__-prdslib.isType '"String",
              fargatePodExecutionRolePermissionsBoundary =
                _js2n__-prdslib.isType '"String",
              podIdentityAssociations =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/PodIdentityAssociation!predicate"
                    ],
              serviceAccounts =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        _js2n__-refsenv."_js2n__-:definitions/ClusterIAMServiceAccount!predicate"
                    ],
              serviceRoleARN = _js2n__-prdslib.isType '"String",
              serviceRolePermissionsBoundary = _js2n__-prdslib.isType '"String",
              vpcResourceControllerPolicy = _js2n__-prdslib.isType '"Bool",
              withOIDC = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterIAMMeta!predicate"
        | doc "holds information we can use to create ObjectMeta for service accounts"
        = _js2n__-prdslib.records.record
            {
              annotations =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
              labels =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
              name = _js2n__-prdslib.isType '"String",
              namespace = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterIAMServiceAccount!predicate"
        | doc "holds an IAM service account metadata and configuration"
        = _js2n__-prdslib.records.record
            {
              attachPolicy =
                _js2n__-refsenv."_js2n__-:definitions/InlineDocument!predicate",
              attachPolicyARNs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              attachRoleARN = _js2n__-prdslib.isType '"String",
              metadata =
                _js2n__-refsenv."_js2n__-:definitions/ClusterIAMMeta!predicate",
              permissionsBoundary = _js2n__-prdslib.isType '"String",
              roleName = _js2n__-prdslib.isType '"String",
              roleOnly = _js2n__-prdslib.isType '"Bool",
              status =
                _js2n__-refsenv."_js2n__-:definitions/ClusterIAMServiceAccountStatus!predicate",
              tags =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
              wellKnownPolicies =
                _js2n__-refsenv."_js2n__-:definitions/WellKnownPolicies!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterIAMServiceAccountStatus!predicate"
        | doc "holds status of the IAM service account"
        = _js2n__-prdslib.records.record
            {
              capabilities =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              roleARN = _js2n__-prdslib.isType '"String",
              stackName = _js2n__-prdslib.isType '"String",
              tags =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterMeta!predicate"
        | doc "contains general cluster information"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "name", "region" ],
              _js2n__-prdslib.records.record
                {
                  annotations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  region = _js2n__-prdslib.isType '"String",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "1.23",
                              "1.24",
                              "1.25",
                              "1.26",
                              "1.27",
                              "1.28",
                              "1.29",
                              "1.30",
                              "1.31"
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ClusterNAT!predicate"
        | doc "NAT config"
        = _js2n__-prdslib.records.record
            {
              gateway =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "HighlyAvailable", "Single", "Disable" ]
                    ],
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterSubnets!predicate"
        | doc "holds private and public subnets"
        = _js2n__-prdslib.records.record
            {
              private =
                _js2n__-refsenv."_js2n__-:definitions/AZSubnetMapping!predicate",
              public =
                _js2n__-refsenv."_js2n__-:definitions/AZSubnetMapping!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ClusterVPC!predicate"
        | doc "holds global subnet and all child subnets"
        = _js2n__-prdslib.records.record
            {
              autoAllocateIPv6 = _js2n__-prdslib.isType '"Bool",
              cidr = _js2n__-prdslib.always,
              clusterEndpoints =
                _js2n__-refsenv."_js2n__-:definitions/ClusterEndpoints!predicate",
              controlPlaneSecurityGroupIDs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              controlPlaneSubnetIDs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              extraCIDRs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              extraIPv6CIDRs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              hostnameType = _js2n__-prdslib.isType '"String",
              id = _js2n__-prdslib.isType '"String",
              ipv6Cidr = _js2n__-prdslib.isType '"String",
              ipv6Pool = _js2n__-prdslib.isType '"String",
              manageSharedNodeSecurityGroupRules =
                _js2n__-prdslib.isType '"Bool",
              nat = _js2n__-refsenv."_js2n__-:definitions/ClusterNAT!predicate",
              publicAccessCIDRs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              securityGroup = _js2n__-prdslib.isType '"String",
              sharedNodeSecurityGroup = _js2n__-prdslib.isType '"String",
              subnets =
                _js2n__-refsenv."_js2n__-:definitions/ClusterSubnets!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/FargateProfile!predicate"
        | doc "defines the settings used to schedule workload onto Fargate."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  podExecutionRoleARN = _js2n__-prdslib.isType '"String",
                  selectors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/FargateProfileSelector!predicate"
                        ],
                  status = _js2n__-prdslib.isType '"String",
                  subnets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/FargateProfileSelector!predicate"
        | doc "defines rules to select workload to schedule onto Fargate."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "namespace" ],
              _js2n__-prdslib.records.record
                {
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespace = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Flux!predicate"
        | doc "groups all configuration options related to a Git repository used for GitOps Toolkit (Flux v2)."
        = _js2n__-prdslib.records.record
            {
              flags =
                _js2n__-refsenv."_js2n__-:definitions/FluxFlags!predicate",
              gitProvider = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/FluxFlags!predicate"
        | doc "a map of string for passing arbitrary flags to Flux bootstrap"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/GitOps!predicate"
        | doc "groups all configuration options related to enabling GitOps Toolkit on a cluster and linking it to a Git repository. Note: this will replace the older Git types"
        = _js2n__-prdslib.records.record
            { flux = _js2n__-refsenv."_js2n__-:definitions/Flux!predicate", } {}
            false _js2n__-prdslib.never,
      "_js2n__-:definitions/IAMIdentityMapping!predicate"
        | doc "contains IAM accounts, users, roles and services that will be added to the aws-auth configmap to enable access to the cluster"
        = _js2n__-prdslib.records.record
            {
              account = _js2n__-prdslib.isType '"String",
              arn = _js2n__-prdslib.isType '"String",
              groups =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              namespace = _js2n__-prdslib.isType '"String",
              noDuplicateARNs = _js2n__-prdslib.isType '"Bool",
              serviceName = _js2n__-prdslib.isType '"String",
              username = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/IdentityProvider!predicate"
        | doc "holds an identity provider configuration. See [the example eksctl config](https://github.com/eksctl-io/eksctl/blob/main/examples/27-oidc-provider.yaml)."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/OIDCIdentityProvider!predicate"
                ],
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "oidc" ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InlineDocument!predicate"
        | doc "holds any arbitrary JSON/YAML documents, such as extra config parameters or IAM policies"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/InstanceSelector!predicate"
        | doc "holds EC2 instance selector options"
        = _js2n__-prdslib.records.record
            {
              cpuArchitecture =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "x86_64", "amd64", "arm64" ]
                    ],
              gpus = _js2n__-prdslib.isType 'Integer,
              memory = _js2n__-prdslib.isType '"String",
              vCPUs = _js2n__-prdslib.isType 'Integer,
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/Karpenter!predicate"
        | doc "provides configuration options"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "version" ],
              _js2n__-prdslib.records.record
                {
                  createServiceAccount = _js2n__-prdslib.isType '"Bool",
                  defaultInstanceProfile = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                  withSpotInterruptionQueue = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/KubernetesNetworkConfig!predicate"
        | doc "contains cluster networking options"
        = _js2n__-prdslib.records.record
            {
              ipFamily =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "IPv4", "IPv6" ]
                    ],
              serviceIPv4CIDR = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/LaunchTemplate!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "id" ],
              _js2n__-prdslib.records.record
                {
                  id = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ManagedNodeGroup!predicate"
        | doc "represents an EKS-managed nodegroup"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  additionalVolumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/VolumeMapping!predicate"
                        ],
                  ami = _js2n__-prdslib.isType '"String",
                  amiFamily =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "AmazonLinux2",
                              "AmazonLinux2023",
                              "UbuntuPro2204",
                              "Ubuntu2204",
                              "Ubuntu2004",
                              "Ubuntu1804",
                              "Bottlerocket",
                              "WindowsServer2019CoreContainer",
                              "WindowsServer2019FullContainer",
                              "WindowsServer2022CoreContainer",
                              "WindowsServer2022FullContainer"
                            ]
                        ],
                  asgSuspendProcesses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  availabilityZones =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  bottlerocket =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupBottlerocket!predicate",
                  capacityReservation =
                    _js2n__-refsenv."_js2n__-:definitions/CapacityReservation!predicate",
                  desiredCapacity = _js2n__-prdslib.isType 'Integer,
                  disableIMDSv1 = _js2n__-prdslib.isType '"Bool",
                  disablePodIMDS = _js2n__-prdslib.isType '"Bool",
                  ebsOptimized = _js2n__-prdslib.isType '"Bool",
                  efaEnabled = _js2n__-prdslib.isType '"Bool",
                  enableDetailedMonitoring = _js2n__-prdslib.isType '"Bool",
                  iam =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupIAM!predicate",
                  instanceName = _js2n__-prdslib.isType '"String",
                  instancePrefix = _js2n__-prdslib.isType '"String",
                  instanceSelector =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceSelector!predicate",
                  instanceType = _js2n__-prdslib.isType '"String",
                  instanceTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  launchTemplate =
                    _js2n__-refsenv."_js2n__-:definitions/LaunchTemplate!predicate",
                  maxPodsPerNode = _js2n__-prdslib.isType 'Integer,
                  maxSize = _js2n__-prdslib.isType 'Integer,
                  minSize = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  nodeRepairConfig =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupNodeRepairConfig!predicate",
                  outpostARN = _js2n__-prdslib.isType '"String",
                  overrideBootstrapCommand = _js2n__-prdslib.isType '"String",
                  placement =
                    _js2n__-refsenv."_js2n__-:definitions/Placement!predicate",
                  preBootstrapCommands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  privateNetworking = _js2n__-prdslib.isType '"Bool",
                  propagateASGTags = _js2n__-prdslib.isType '"Bool",
                  releaseVersion = _js2n__-prdslib.isType '"String",
                  securityGroups =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupSGs!predicate",
                  spot = _js2n__-prdslib.isType '"Bool",
                  ssh =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupSSH!predicate",
                  subnets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  taints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/NodeGroupTaint!predicate"
                        ],
                  updateConfig =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupUpdateConfig!predicate",
                  volumeEncrypted = _js2n__-prdslib.isType '"Bool",
                  volumeIOPS = _js2n__-prdslib.isType 'Integer,
                  volumeKmsKeyID = _js2n__-prdslib.isType '"String",
                  volumeName = _js2n__-prdslib.isType '"String",
                  volumeSize = _js2n__-prdslib.isType 'Integer,
                  volumeThroughput = _js2n__-prdslib.isType 'Integer,
                  volumeType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "gp2", "gp3", "io1", "sc1", "st1" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/MetricsCollection!predicate"
        | doc "used by the scaling config, see [cloudformation docs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-metricscollection.html)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "granularity" ],
              _js2n__-prdslib.records.record
                {
                  granularity = _js2n__-prdslib.isType '"String",
                  metrics =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NodeGroup!predicate"
        | doc "holds configuration attributes that are specific to an unmanaged nodegroup"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  additionalVolumes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/VolumeMapping!predicate"
                        ],
                  ami = _js2n__-prdslib.isType '"String",
                  amiFamily =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "AmazonLinux2",
                              "AmazonLinux2023",
                              "UbuntuPro2204",
                              "Ubuntu2204",
                              "Ubuntu2004",
                              "Ubuntu1804",
                              "Bottlerocket",
                              "WindowsServer2019CoreContainer",
                              "WindowsServer2019FullContainer",
                              "WindowsServer2022CoreContainer",
                              "WindowsServer2022FullContainer"
                            ]
                        ],
                  asgMetricsCollection =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/MetricsCollection!predicate"
                        ],
                  asgSuspendProcesses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  availabilityZones =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  bottlerocket =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupBottlerocket!predicate",
                  capacityReservation =
                    _js2n__-refsenv."_js2n__-:definitions/CapacityReservation!predicate",
                  classicLoadBalancerNames =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  clusterDNS = _js2n__-prdslib.isType '"String",
                  containerRuntime = _js2n__-prdslib.isType '"String",
                  cpuCredits = _js2n__-prdslib.isType '"String",
                  desiredCapacity = _js2n__-prdslib.isType 'Integer,
                  disableIMDSv1 = _js2n__-prdslib.isType '"Bool",
                  disablePodIMDS = _js2n__-prdslib.isType '"Bool",
                  ebsOptimized = _js2n__-prdslib.isType '"Bool",
                  efaEnabled = _js2n__-prdslib.isType '"Bool",
                  enableDetailedMonitoring = _js2n__-prdslib.isType '"Bool",
                  iam =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupIAM!predicate",
                  instanceName = _js2n__-prdslib.isType '"String",
                  instancePrefix = _js2n__-prdslib.isType '"String",
                  instanceSelector =
                    _js2n__-refsenv."_js2n__-:definitions/InstanceSelector!predicate",
                  instanceType = _js2n__-prdslib.isType '"String",
                  instancesDistribution =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupInstancesDistribution!predicate",
                  kubeletExtraConfig =
                    _js2n__-refsenv."_js2n__-:definitions/InlineDocument!predicate",
                  labels =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  localZones =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  maxInstanceLifetime = _js2n__-prdslib.isType 'Integer,
                  maxPodsPerNode = _js2n__-prdslib.isType 'Integer,
                  maxSize = _js2n__-prdslib.isType 'Integer,
                  minSize = _js2n__-prdslib.isType 'Integer,
                  name = _js2n__-prdslib.isType '"String",
                  outpostARN = _js2n__-prdslib.isType '"String",
                  overrideBootstrapCommand = _js2n__-prdslib.isType '"String",
                  placement =
                    _js2n__-refsenv."_js2n__-:definitions/Placement!predicate",
                  preBootstrapCommands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  privateNetworking = _js2n__-prdslib.isType '"Bool",
                  propagateASGTags = _js2n__-prdslib.isType '"Bool",
                  securityGroups =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupSGs!predicate",
                  ssh =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupSSH!predicate",
                  subnets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  taints =
                    _js2n__-refsenv."_js2n__-:definitions/taintsWrapper!predicate",
                  targetGroupARNs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  updateConfig =
                    _js2n__-refsenv."_js2n__-:definitions/NodeGroupUpdateConfig!predicate",
                  volumeEncrypted = _js2n__-prdslib.isType '"Bool",
                  volumeIOPS = _js2n__-prdslib.isType 'Integer,
                  volumeKmsKeyID = _js2n__-prdslib.isType '"String",
                  volumeName = _js2n__-prdslib.isType '"String",
                  volumeSize = _js2n__-prdslib.isType 'Integer,
                  volumeThroughput = _js2n__-prdslib.isType 'Integer,
                  volumeType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "gp2", "gp3", "io1", "sc1", "st1" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NodeGroupBottlerocket!predicate"
        | doc "holds the configuration for Bottlerocket based NodeGroups."
        = _js2n__-prdslib.records.record
            {
              enableAdminContainer = _js2n__-prdslib.isType '"Bool",
              settings =
                _js2n__-refsenv."_js2n__-:definitions/InlineDocument!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupIAM!predicate"
        | doc "holds all IAM attributes of a NodeGroup"
        = _js2n__-prdslib.records.record
            {
              attachPolicy =
                _js2n__-refsenv."_js2n__-:definitions/InlineDocument!predicate",
              attachPolicyARNs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              instanceProfileARN = _js2n__-prdslib.isType '"String",
              instanceRoleARN = _js2n__-prdslib.isType '"String",
              instanceRoleName = _js2n__-prdslib.isType '"String",
              instanceRolePermissionsBoundary =
                _js2n__-prdslib.isType '"String",
              withAddonPolicies =
                _js2n__-refsenv."_js2n__-:definitions/NodeGroupIAMAddonPolicies!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupIAMAddonPolicies!predicate"
        | doc "holds all IAM addon policies"
        = _js2n__-prdslib.records.record
            {
              albIngress = _js2n__-prdslib.isType '"Bool",
              appMesh = _js2n__-prdslib.isType '"Bool",
              appMeshPreview = _js2n__-prdslib.isType '"Bool",
              autoScaler = _js2n__-prdslib.isType '"Bool",
              awsLoadBalancerController = _js2n__-prdslib.isType '"Bool",
              certManager = _js2n__-prdslib.isType '"Bool",
              cloudWatch = _js2n__-prdslib.isType '"Bool",
              ebs = _js2n__-prdslib.isType '"Bool",
              efs = _js2n__-prdslib.isType '"Bool",
              externalDNS = _js2n__-prdslib.isType '"Bool",
              fsx = _js2n__-prdslib.isType '"Bool",
              imageBuilder = _js2n__-prdslib.isType '"Bool",
              xRay = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupInstancesDistribution!predicate"
        | doc "holds the configuration for [spot instances](/usage/spot-instances/)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "instanceTypes" ],
              _js2n__-prdslib.records.record
                {
                  capacityRebalance = _js2n__-prdslib.isType '"Bool",
                  instanceTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  maxPrice = _js2n__-prdslib.isType '"Number",
                  onDemandBaseCapacity = _js2n__-prdslib.isType 'Integer,
                  onDemandPercentageAboveBaseCapacity =
                    _js2n__-prdslib.isType 'Integer,
                  spotAllocationStrategy = _js2n__-prdslib.isType '"String",
                  spotInstancePools = _js2n__-prdslib.isType 'Integer,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/NodeGroupNodeRepairConfig!predicate"
        | doc "contains the auto repair configuration for the nodegroup"
        = _js2n__-prdslib.records.record
            { enabled = _js2n__-prdslib.isType '"Bool", } {} false
            _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupSGs!predicate"
        | doc "controls security groups for this nodegroup"
        = _js2n__-prdslib.records.record
            {
              attachIDs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              withLocal = _js2n__-prdslib.isType '"Bool",
              withShared = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupSSH!predicate"
        | doc "holds all the ssh access configuration to a NodeGroup"
        = _js2n__-prdslib.records.record
            {
              allow = _js2n__-prdslib.isType '"Bool",
              enableSsm = _js2n__-prdslib.isType '"Bool",
              publicKey = _js2n__-prdslib.isType '"String",
              publicKeyName = _js2n__-prdslib.isType '"String",
              publicKeyPath = _js2n__-prdslib.isType '"String",
              sourceSecurityGroupIds =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupTaint!predicate"
        | doc "represents a Kubernetes taint"
        = _js2n__-prdslib.records.record
            {
              effect = _js2n__-prdslib.always,
              key = _js2n__-prdslib.isType '"String",
              value = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/NodeGroupUpdateConfig!predicate"
        | doc "contains the configuration for updating NodeGroups."
        = _js2n__-prdslib.records.record
            {
              maxUnavailable = _js2n__-prdslib.isType 'Integer,
              maxUnavailablePercentage = _js2n__-prdslib.isType 'Integer,
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/OIDCIdentityProvider!predicate"
        | doc "holds the spec of an OIDC provider to use for EKS authzn"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required
                [ "clientID", "issuerURL", "name" ],
              _js2n__-prdslib.records.record
                {
                  clientID = _js2n__-prdslib.isType '"String",
                  groupsClaim = _js2n__-prdslib.isType '"String",
                  groupsPrefix = _js2n__-prdslib.isType '"String",
                  issuerURL = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  requiredClaims =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  usernameClaim = _js2n__-prdslib.isType '"String",
                  usernamePrefix = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Outpost!predicate"
        | doc "holds the Outpost configuration."
        = _js2n__-prdslib.records.record
            {
              controlPlaneInstanceType = _js2n__-prdslib.isType '"String",
              controlPlaneOutpostARN = _js2n__-prdslib.isType '"String",
              controlPlanePlacement =
                _js2n__-refsenv."_js2n__-:definitions/Placement!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/Placement!predicate"
        | doc "specifies placement group information"
        = _js2n__-prdslib.records.record
            { groupName = _js2n__-prdslib.isType '"String", } {} false
            _js2n__-prdslib.never,
      "_js2n__-:definitions/PodIdentityAssociation!predicate" =
        _js2n__-prdslib.records.record
            {
              createServiceAccount = _js2n__-prdslib.isType '"Bool",
              namespace = _js2n__-prdslib.isType '"String",
              permissionPolicy =
                _js2n__-refsenv."_js2n__-:definitions/InlineDocument!predicate",
              permissionPolicyARNs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              permissionsBoundaryARN = _js2n__-prdslib.isType '"String",
              roleARN = _js2n__-prdslib.isType '"String",
              roleName = _js2n__-prdslib.isType '"String",
              serviceAccountName = _js2n__-prdslib.isType '"String",
              tags =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {} {} true
                        (_js2n__-prdslib.isType '"String")
                    ],
              wellKnownPolicies =
                _js2n__-refsenv."_js2n__-:definitions/WellKnownPolicies!predicate",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/PrivateCluster!predicate"
        | doc "defines the configuration for a fully-private cluster."
        = _js2n__-prdslib.records.record
            {
              additionalEndpointServices =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
              enabled = _js2n__-prdslib.isType '"Bool",
              skipEndpointCreation = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/RemoteNetwork!predicate"
        | doc "RemoteNetwork"
        = _js2n__-prdslib.records.record
            {
              cidrs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.isType '"String")
                    ],
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/RemoteNetworkConfig!predicate"
        | doc "RemoteNetworkConfig"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required
                [ "remoteNodeNetworks", "vpcGatewayID" ],
              _js2n__-prdslib.records.record
                {
                  iam =
                    _js2n__-refsenv."_js2n__-:definitions/RemoteNodesIAM!predicate",
                  remoteNodeNetworks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RemoteNetwork!predicate"
                        ],
                  remotePodNetworks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/RemoteNetwork!predicate"
                        ],
                  vpcGatewayID =
                    _js2n__-refsenv."_js2n__-:definitions/VPCGateway!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/RemoteNodesIAM!predicate" =
        _js2n__-prdslib.records.record
            {
              caBundleCert = _js2n__-prdslib.isType '"String",
              provider = _js2n__-prdslib.isType '"String",
              roleARN = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/SecretsEncryption!predicate"
        | doc "defines the configuration for KMS encryption provider"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "keyARN" ],
              _js2n__-prdslib.records.record
                { keyARN = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/VPCGateway!predicate"
        | doc "VPCGatewayID the ID of the gateway that facilitates external connectivity from customer's VPC to their remote network(s). Valid options are Transit Gateway and Virtual Private Gateway."
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/VolumeMapping!predicate"
        | doc "Additional Volume Configurations"
        = _js2n__-prdslib.records.record
            {
              snapshotID = _js2n__-prdslib.isType '"String",
              volumeEncrypted = _js2n__-prdslib.isType '"Bool",
              volumeIOPS = _js2n__-prdslib.isType 'Integer,
              volumeKmsKeyID = _js2n__-prdslib.isType '"String",
              volumeName = _js2n__-prdslib.isType '"String",
              volumeSize = _js2n__-prdslib.isType 'Integer,
              volumeThroughput = _js2n__-prdslib.isType 'Integer,
              volumeType =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "gp2", "gp3", "io1", "sc1", "st1" ]
                    ],
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/WellKnownPolicies!predicate"
        | doc "for attaching common IAM policies"
        = _js2n__-prdslib.records.record
            {
              autoScaler = _js2n__-prdslib.isType '"Bool",
              awsLoadBalancerController = _js2n__-prdslib.isType '"Bool",
              certManager = _js2n__-prdslib.isType '"Bool",
              ebsCSIController = _js2n__-prdslib.isType '"Bool",
              efsCSIController = _js2n__-prdslib.isType '"Bool",
              externalDNS = _js2n__-prdslib.isType '"Bool",
              imageBuilder = _js2n__-prdslib.isType '"Bool",
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/ZonalShiftConfig!predicate"
        | doc "holds the zonal shift configuration."
        = _js2n__-prdslib.records.record
            { enabled = _js2n__-prdslib.isType '"Bool", } {} false
            _js2n__-prdslib.never,
      "_js2n__-:definitions/taintsWrapper!predicate"
        | doc "handles unmarshalling both map[string]string and []NodeGroupTaint"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/NodeGroupTaint!predicate"
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-refsenv."_js2n__-:definitions/ClusterConfig!predicate"
        ])