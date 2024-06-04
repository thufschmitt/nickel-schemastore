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
      "_js2n__-:definitions/meshapi.gateway.AdditionalEndpointBinding!predicate"
        | doc "AdditionalEndpointBinding is an additional gRPC method - HTTP endpoint binding specification."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "get" ],
                      _js2n__-prdslib.records.record
                        { get = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "put" ],
                      _js2n__-prdslib.records.record
                        { put = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "post" ],
                      _js2n__-prdslib.records.record
                        { post = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "delete" ],
                      _js2n__-prdslib.records.record
                        { delete = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "patch" ],
                      _js2n__-prdslib.records.record
                        { patch = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "custom" ],
                      _js2n__-prdslib.records.record
                        {
                          custom =
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.CustomPattern!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  body = _js2n__-prdslib.isType '"String",
                  custom =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.CustomPattern!predicate",
                  delete = _js2n__-prdslib.isType '"String",
                  disable_query_param_discovery =
                    _js2n__-prdslib.isType '"Bool",
                  get = _js2n__-prdslib.isType '"String",
                  patch = _js2n__-prdslib.isType '"String",
                  post = _js2n__-prdslib.isType '"String",
                  put = _js2n__-prdslib.isType '"String",
                  query_params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.QueryParameterBinding!predicate"
                        ],
                  response_body = _js2n__-prdslib.isType '"String",
                  stream =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.StreamConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.CustomPattern!predicate"
        | doc "CustomPattern describes an HTTP pattern and custom method."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  method = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.EndpointBinding!predicate"
        | doc "EndpointBinding is a gRPC method - HTTP endpoint binding specification."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "get" ],
                      _js2n__-prdslib.records.record
                        { get = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "put" ],
                      _js2n__-prdslib.records.record
                        { put = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "post" ],
                      _js2n__-prdslib.records.record
                        { post = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "delete" ],
                      _js2n__-prdslib.records.record
                        { delete = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "patch" ],
                      _js2n__-prdslib.records.record
                        { patch = _js2n__-prdslib.isType '"String", } {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "custom" ],
                      _js2n__-prdslib.records.record
                        {
                          custom =
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.CustomPattern!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  additional_bindings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.AdditionalEndpointBinding!predicate"
                        ],
                  body = _js2n__-prdslib.isType '"String",
                  custom =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.CustomPattern!predicate",
                  delete = _js2n__-prdslib.isType '"String",
                  disable_query_param_discovery =
                    _js2n__-prdslib.isType '"Bool",
                  get = _js2n__-prdslib.isType '"String",
                  patch = _js2n__-prdslib.isType '"String",
                  post = _js2n__-prdslib.isType '"String",
                  put = _js2n__-prdslib.isType '"String",
                  query_params =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.QueryParameterBinding!predicate"
                        ],
                  response_body = _js2n__-prdslib.isType '"String",
                  selector = _js2n__-prdslib.isType '"String",
                  stream =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.StreamConfig!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.GatewaySpec!predicate"
        | doc "GatewaySpec holds gRPC gateway configurations."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  endpoints =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.EndpointBinding!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.OpenAPIEnumSpec!predicate"
        | doc "OpenAPIEnumSpec defines configuration for generating OpenAPI documentation for protobuf enums."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                  selector = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.OpenAPIMessageSpec!predicate"
        | doc "OpenAPIMessageSpec defines configuration for generating OpenAPI documentation for protobuf messages."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  fields =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                  selector = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.OpenAPIServiceSpec!predicate"
        | doc "OpenAPIServiceSpec defines configuration for generating OpenAPI documentation for gRPC services."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  document =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Document!predicate",
                  methods =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Operation!predicate"
                        ],
                  selector = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.OpenAPISpec!predicate"
        | doc "OpenAPISpec defines the overall OpenAPI documentation configuration."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  document =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Document!predicate",
                  enums =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.OpenAPIEnumSpec!predicate"
                        ],
                  messages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.OpenAPIMessageSpec!predicate"
                        ],
                  services =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.OpenAPIServiceSpec!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.QueryParameterBinding!predicate"
        | doc "QueryParameterBinding describes a query parameter to request message binding."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ignore = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  selector = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.StreamConfig!predicate"
        | doc "StreamConfig sets the behavior of the HTTP server for gRPC streaming methods."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  disable_chunked_transfer = _js2n__-prdslib.isType '"Bool",
                  disable_sse = _js2n__-prdslib.isType '"Bool",
                  disable_websockets = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Components!predicate"
        | doc "Holds a set of reusable objects for different aspects of the OAS. All objects defined within the components object will have no effect on the API unless they are explicitly referenced from properties outside the components object.  See: https://spec.openapis.org/oas/latest.html#components-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Example!predicate"
                        ],
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Header!predicate"
                        ],
                  links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Link!predicate"
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Parameter!predicate"
                        ],
                  request_bodies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.RequestBody!predicate"
                        ],
                  responses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Response!predicate"
                        ],
                  schemas =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                  security_schemes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Contact!predicate"
        | doc "Contact information for the exposed API. See: https://spec.openapis.org/oas/v3.1.0#contact-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  email = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Discriminator!predicate"
        | doc "See: https://spec.openapis.org/oas/latest.html#discriminator-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  mapping =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  property_name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Document!predicate"
        | doc "This is the root object of the OpenAPI document. See: https://spec.openapis.org/oas/v3.1.0#openapi-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  components =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Components!predicate",
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.DocumentConfiguration!predicate",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  external_docs =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.ExternalDocumentation!predicate",
                  info =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Info!predicate",
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityRequirement!predicate"
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Server!predicate"
                        ],
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Tag!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.DocumentConfiguration!predicate"
        | doc "DocumentConfiguration allows for controlling the default responses"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  default_responses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Response!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Encoding!predicate"
        | doc "A single encoding definition applied to a single schema property. See: https://spec.openapis.org/oas/latest.html#encoding-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_reserved = _js2n__-prdslib.isType '"Bool",
                  content_type = _js2n__-prdslib.isType '"String",
                  explode = _js2n__-prdslib.isType '"Bool",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Header!predicate"
                        ],
                  style = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Example!predicate"
        | doc "See: https://spec.openapis.org/oas/latest.html#example-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  external_value = _js2n__-prdslib.isType '"String",
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                  summary = _js2n__-prdslib.isType '"String",
                  value =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.ExternalDocumentation!predicate"
        | doc "Allows referencing an external resource for extended documentation. See: https://spec.openapis.org/oas/v3.1.0#external-documentation-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.FieldConfiguration!predicate"
        | doc "FieldConfiguration provides additional field level properties used when generating the OpenAPI v3.1 file. These properties are not defined by OpenAPIv3, but they are used to control the generation."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  path_param_name = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Header!predicate"
        | doc "Header object follows the structure of the Parameter object with the following changes: 1. name MUST NOT be specified, it is given in the corresponding headers map.  2. in MUST NOT be specified, it is implicitly in header. 3. All traits that are affected by the location MUST be applicable to a location of header (for example, style). See: https://spec.openapis.org/oas/v3.1.0#header-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_empty_value = _js2n__-prdslib.isType '"Bool",
                  content =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.MediaType!predicate"
                        ],
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Example!predicate"
                        ],
                  explode = _js2n__-prdslib.isType '"Bool",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                  required = _js2n__-prdslib.isType '"Bool",
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                  style = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Info!predicate"
        | doc "Info captures OpenAPI Info object. NOTE: A generated value will be used for the required fields if they are left empty. See: https://spec.openapis.org/oas/v3.1.0#info-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  contact =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Contact!predicate",
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  license =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.License!predicate",
                  summary = _js2n__-prdslib.isType '"String",
                  terms_of_service = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.License!predicate"
        | doc "License information for the exposed API. See: https://spec.openapis.org/oas/v3.1.0#license-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  identifier = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Link!predicate"
        | doc "The Link object represents a possible design-time link for a response. The presence of a link does not guarantee the caller’s ability to successfully invoke it, rather it provides a known relationship and traversal mechanism between responses and other operations. See: https://spec.openapis.org/oas/v3.1.0#link-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "operation_ref" ],
                      _js2n__-prdslib.records.record
                        { operation_ref = _js2n__-prdslib.isType '"String", } {}
                        true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "operation_id" ],
                      _js2n__-prdslib.records.record
                        { operation_id = _js2n__-prdslib.isType '"String", } {}
                        true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  operation_id = _js2n__-prdslib.isType '"String",
                  operation_ref = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                  request_body =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                  server =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Server!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.MediaType!predicate"
        | doc "Each Media Type Object provides schema and examples for the media type identified by its key. See: https://spec.openapis.org/oas/latest.html#media-type-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  encoding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Encoding!predicate"
                        ],
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Example!predicate"
                        ],
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Operation!predicate"
        | doc "Describes a single API operation on a path. NOTE: this operation object is a partial implementation of the OpenAPI Operation object. Fields overridden here will only impact this method but will be used for all different HTTP bindings of the same method. See: https://spec.openapis.org/oas/v3.1.0#operation-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  external_docs =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.ExternalDocumentation!predicate",
                  operation_id = _js2n__-prdslib.isType '"String",
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Parameter!predicate"
                        ],
                  responses =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Response!predicate"
                        ],
                  security =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityRequirement!predicate"
                        ],
                  servers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Server!predicate"
                        ],
                  summary = _js2n__-prdslib.isType '"String",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Parameter!predicate"
        | doc "Describes a single operation parameter. A unique parameter is defined by a combination of a name and location. See: https://spec.openapis.org/oas/latest.html#parameter-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  allow_empty_value = _js2n__-prdslib.isType '"Bool",
                  allow_reserved = _js2n__-prdslib.isType '"Bool",
                  content =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.MediaType!predicate"
                        ],
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  example =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Example!predicate"
                        ],
                  explode = _js2n__-prdslib.isType '"Bool",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  "in" = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                  required = _js2n__-prdslib.isType '"Bool",
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                  style = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate"
        | doc "Reference allows referencing other components in the OpenAPI document, both internally and externally. For detailed information on the Reference object, refer to the OpenAPI Specification: https://spec.openapis.org/oas/latest.html#reference-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  summary = _js2n__-prdslib.isType '"String",
                  uri = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.RequestBody!predicate"
        | doc "Describes a single request body. See: https://spec.openapis.org/oas/latest.html#request-body-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  content =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.MediaType!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                  required = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Response!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  content =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.MediaType!predicate"
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  headers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Header!predicate"
                        ],
                  links =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Link!predicate"
                        ],
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
        | doc "Schema represents an OpenAPI v3.1 Schema object, providing a structured definition for data types used in the API. For detailed information on the Schema object, refer to the OpenAPI Specification: https://spec.openapis.org/oas/v3.1.0#schema-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  additional_properties =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                  all_of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                  any_of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                  config =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.FieldConfiguration!predicate",
                  "default" =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"String"
                        ],
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  description = _js2n__-prdslib.isType '"String",
                  discriminator =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Discriminator!predicate",
                  enum =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  exclusive_maximum = _js2n__-prdslib.isType '"Number",
                  exclusive_minimum = _js2n__-prdslib.isType '"Number",
                  external_docs =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.ExternalDocumentation!predicate",
                  extra =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  format = _js2n__-prdslib.isType '"String",
                  items =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema.Item!predicate",
                  max_items = _js2n__-prdslib.isType '"String",
                  max_length = _js2n__-prdslib.isType '"String",
                  max_properties = _js2n__-prdslib.isType '"String",
                  maximum = _js2n__-prdslib.isType '"Number",
                  min_items = _js2n__-prdslib.isType '"String",
                  min_length = _js2n__-prdslib.isType '"String",
                  min_properties = _js2n__-prdslib.isType '"String",
                  minimum = _js2n__-prdslib.isType '"Number",
                  multiple_of = _js2n__-prdslib.isType '"Number",
                  not =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                  one_of =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                  read_only = _js2n__-prdslib.isType '"Bool",
                  ref = _js2n__-prdslib.isType '"String",
                  required =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  schema = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                  types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.enum
                              [
                                "UNKNOWN",
                                0,
                                "ARRAY",
                                1,
                                "BOOLEAN",
                                2,
                                "INTEGER",
                                3,
                                "NULL",
                                4,
                                "NUMBER",
                                5,
                                "OBJECT",
                                6,
                                "STRING",
                                7
                              ])
                        ],
                  unique_items = _js2n__-prdslib.isType '"Bool",
                  write_only = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Schema.Item!predicate"
        | doc "Represents an item in a SchemaList, which can be a schema or another SchemaList."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "schema" ],
                      _js2n__-prdslib.records.record
                        {
                          schema =
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "list" ],
                      _js2n__-prdslib.records.record
                        {
                          list =
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema.SchemaList!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.record
                {
                  list =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema.SchemaList!predicate",
                  schema =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Schema.SchemaList!predicate"
        | doc "Represents a list of schemas for array validation or for object properties."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  items =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Schema!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.SecurityRequirement!predicate"
        | doc "Lists the required security schemes to execute this operation. See: https://spec.openapis.org/oas/v3.1.0#security-requirement-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  name = _js2n__-prdslib.isType '"String",
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme!predicate"
        | doc "Defines a security scheme that can be used by the operations. See: https://spec.openapis.org/oas/latest.html#security-scheme-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bearer_format = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  flows =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlows!predicate",
                  "in" = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  open_id_connect_url = _js2n__-prdslib.isType '"String",
                  ref =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.Reference!predicate",
                  scheme = _js2n__-prdslib.isType '"String",
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlow!predicate"
        | doc "Configuration details for a supported OAuth Flow See: https://spec.openapis.org/oas/latest.html#oauth-flow-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authorization_url = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  refresh_url = _js2n__-prdslib.isType '"String",
                  scopes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  token_url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlows!predicate"
        | doc "See: https://spec.openapis.org/oas/latest.html#oauth-flows-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  authorization_code =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlow!predicate",
                  client_credentials =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlow!predicate",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  implicit =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlow!predicate",
                  password =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.SecurityScheme.OAuthFlow!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Server!predicate"
        | doc "An object representing a Server. See: https://spec.openapis.org/oas/v3.1.0#server-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  url = _js2n__-prdslib.isType '"String",
                  variables =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.ServerVariable!predicate"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.ServerVariable!predicate"
        | doc "An object representing a Server Variable for server URL template substitution. See: https://spec.openapis.org/oas/v3.1.0#server-variable-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  default_value = _js2n__-prdslib.isType '"String",
                  description = _js2n__-prdslib.isType '"String",
                  enum_values =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/meshapi.gateway.openapi.Tag!predicate"
        | doc "Adds metadata to a single tag that is used by the Operation Object. See: https://spec.openapis.org/oas/v3.1.0#tag-object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  description = _js2n__-prdslib.isType '"String",
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  external_docs =
                    _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.openapi.ExternalDocumentation!predicate",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record
            {
              gateway =
                _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.GatewaySpec!predicate",
              openapi =
                _js2n__-refsenv."_js2n__-:definitions/meshapi.gateway.OpenAPISpec!predicate",
            } {} false _js2n__-prdslib.never
        ])