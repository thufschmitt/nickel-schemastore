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
      "_js2n__-:definitions/aggregator!predicate"
        | doc "Configuration settings for the function result aggregator."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  batchSize = _js2n__-prdslib.isType 'Integer,
                  flushTimeout =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cosmosDB-extension!predicate"
        | doc "Configuration settings for Azure Cosmos DB bindings and triggers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connectionMode = _js2n__-prdslib.enum [ "Gateway", "Direct" ],
                  protocol = _js2n__-prdslib.enum [ "Https", "Tcp" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/cosmosDB-extension-v2!predicate"
        | doc "Configuration settings for Azure Cosmos DB bindings and triggers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  connectionMode = _js2n__-prdslib.enum [ "Gateway", "Direct" ],
                  leaseOptions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { leasePrefix = _js2n__-prdslib.isType '"String", }
                            {} false _js2n__-prdslib.never
                        ],
                  protocol = _js2n__-prdslib.enum [ "Https", "Tcp" ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/durableTask-extension!predicate"
        | doc "Configuration settings for 'orchestration'/'activity' triggers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  extendedSessionIdleTimeoutInSeconds =
                    _js2n__-prdslib.isType 'Integer,
                  extendedSessionsEnabled = _js2n__-prdslib.isType '"Bool",
                  hubName = _js2n__-prdslib.isType '"String",
                  maxConcurrentActivityFunctions =
                    _js2n__-prdslib.isType 'Integer,
                  maxConcurrentOrchestratorFunctions =
                    _js2n__-prdslib.isType 'Integer,
                  maxEntityOperationBatchSize = _js2n__-prdslib.isType 'Integer,
                  notifications =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              eventGrid =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          keySettingName =
                                            _js2n__-prdslib.isType '"String",
                                          publishEventTypes =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "Started",
                                                            "Pending",
                                                            "Completed",
                                                            "Failed",
                                                            "Terminated"
                                                          ]
                                                      ]),
                                                  _js2n__-prdslib.arrays.uniqueItems
                                                ],
                                          publishRetryCount =
                                            _js2n__-prdslib.isType 'Integer,
                                          publishRetryInterval =
                                            _js2n__-prdslib.isType '"String",
                                          topicEndpoint =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  storageProvider =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              connectionStringName =
                                _js2n__-prdslib.isType '"String",
                              controlQueueBatchSize =
                                _js2n__-prdslib.isType 'Integer,
                              controlQueueBufferThreshold =
                                _js2n__-prdslib.isType 'Integer,
                              controlQueueVisibilityTimeout =
                                _js2n__-prdslib.isType '"String",
                              maxQueuePollingInterval =
                                _js2n__-prdslib.isType '"String",
                              partitionCount = _js2n__-prdslib.isType 'Integer,
                              trackingStoreConnectionStringName =
                                _js2n__-prdslib.isType '"String",
                              trackingStoreNamePrefix =
                                _js2n__-prdslib.isType '"String",
                              useLegacyPartitionManagement =
                                _js2n__-prdslib.isType '"Bool",
                              workItemQueueVisibilityTimeout =
                                _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  tracing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              traceInputsAndOutputs =
                                _js2n__-prdslib.isType '"Bool",
                              traceReplayEvents =
                                _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  useAppLease = _js2n__-prdslib.isType '"Bool",
                  useGracefulShutdown = _js2n__-prdslib.isType '"Bool",
                  useTablePartitionManagement = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/functionTimeout!predicate"
        | doc "Value indicating the timeout duration for all functions."
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.strings.pattern
                    "^(-1|(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d)$"
                ],
              _js2n__-prdslib.enum [ null ]
            ],
      "_js2n__-:definitions/functions!predicate"
        | doc "The list of functions the host should load."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/healthMonitor!predicate"
        | doc "Configuration settings for the Functions host health monitor"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  counterThreshold = _js2n__-prdslib.isType '"Number",
                  enabled = _js2n__-prdslib.isType '"Bool",
                  healthCheckInterval =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  healthCheckThreshold = _js2n__-prdslib.isType 'Integer,
                  healthCheckWindow =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/http-extension!predicate"
        | doc "Configuration settings for 'http' triggers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "routePrefix" ],
              _js2n__-prdslib.records.record
                {
                  customHeaders = _js2n__-prdslib.isType 'Record,
                  dynamicThrottlesEnabled = _js2n__-prdslib.isType '"Bool",
                  hsts =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              excludedHosts =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String"),
                                      _js2n__-prdslib.arrays.uniqueItems
                                    ],
                              includeSubDomains =
                                _js2n__-prdslib.isType '"Bool",
                              isEnabled = _js2n__-prdslib.isType '"Bool",
                              maxAge = _js2n__-prdslib.isType '"String",
                              preload = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  maxConcurrentRequests = _js2n__-prdslib.isType 'Integer,
                  maxOutstandingRequests = _js2n__-prdslib.isType 'Integer,
                  routePrefix = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/queues-extension!predicate"
        | doc "Configuration settings for 'queue' triggers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  batchSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 32,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  maxDequeueCount = _js2n__-prdslib.isType 'Integer,
                  maxPollingInterval = _js2n__-prdslib.isType 'Integer,
                  newBatchThreshold = _js2n__-prdslib.isType 'Integer,
                  visibilityTimeout =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/queues-extension-v2!predicate"
        | doc "Configuration settings for 'queue' triggers."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  batchSize =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.maximum 32,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  maxDequeueCount = _js2n__-prdslib.isType 'Integer,
                  maxPollingInterval =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9](?:\\.[0-9]+)?$"
                        ],
                  messageEncoding =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "base64", "none" ]
                        ],
                  newBatchThreshold = _js2n__-prdslib.isType 'Integer,
                  visibilityTimeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[0-9][0-9]:[0-9][0-9]:[0-9][0-9](?:\\.[0-9]+)?$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/singleton!predicate"
        | doc "Configuration settings for Singleton lock behavior."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  listenerLockPeriod =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  listenerLockRecoveryPollingInterval =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  lockAcquisitionPollingInterval =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  lockAcquisitionTimeout =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                  lockPeriod =
                    _js2n__-prdslib.strings.pattern
                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/version-1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  aggregator =
                    _js2n__-refsenv."_js2n__-:definitions/aggregator!predicate",
                  applicationInsights =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              sampling =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          isEnabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          maxTelemetryItemsPerSecond =
                                            _js2n__-prdslib.isType 'Integer,
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  documentDB =
                    _js2n__-refsenv."_js2n__-:definitions/cosmosDB-extension!predicate",
                  durableTask =
                    _js2n__-refsenv."_js2n__-:definitions/durableTask-extension!predicate",
                  eventHub =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              batchCheckpointFrequency =
                                _js2n__-prdslib.isType 'Integer,
                              maxBatchSize = _js2n__-prdslib.isType 'Integer,
                              prefetchCount = _js2n__-prdslib.isType 'Integer,
                            } {} false _js2n__-prdslib.never
                        ],
                  functionTimeout =
                    _js2n__-refsenv."_js2n__-:definitions/functionTimeout!predicate",
                  functions =
                    _js2n__-refsenv."_js2n__-:definitions/functions!predicate",
                  healthMonitor =
                    _js2n__-refsenv."_js2n__-:definitions/healthMonitor!predicate",
                  http =
                    _js2n__-refsenv."_js2n__-:definitions/http-extension!predicate",
                  id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.minLength 1
                        ],
                  logger =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              categoryLevels =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {} {} true
                                        (_js2n__-prdslib.enum
                                          [
                                            "Critical",
                                            "Debug",
                                            "Error",
                                            "Information",
                                            "None",
                                            "Trace",
                                            "Warning"
                                          ])
                                    ],
                              defaultLevel =
                                _js2n__-prdslib.enum
                                    [
                                      "Critical",
                                      "Debug",
                                      "Error",
                                      "Information",
                                      "None",
                                      "Trace",
                                      "Warning"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  queues =
                    _js2n__-refsenv."_js2n__-:definitions/queues-extension!predicate",
                  serviceBus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              autoComplete = _js2n__-prdslib.isType '"Bool",
                              autoRenewTimeout =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                    ],
                              maxConcurrentCalls =
                                _js2n__-prdslib.isType 'Integer,
                              prefetchCount = _js2n__-prdslib.isType 'Integer,
                            } {} false _js2n__-prdslib.never
                        ],
                  singleton =
                    _js2n__-refsenv."_js2n__-:definitions/singleton!predicate",
                  tracing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              consoleLevel =
                                _js2n__-prdslib.enum
                                    [
                                      "off",
                                      "error",
                                      "warning",
                                      "info",
                                      "verbose"
                                    ],
                              fileLoggingMode =
                                _js2n__-prdslib.enum
                                    [ "never", "always", "debugOnly" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  watchDirectories =
                    _js2n__-refsenv."_js2n__-:definitions/watchDirectories!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/version-2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "version" ],
              _js2n__-prdslib.records.record
                {
                  aggregator =
                    _js2n__-refsenv."_js2n__-:definitions/aggregator!predicate",
                  concurrency =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dynamicConcurrencyEnabled =
                                _js2n__-prdslib.isType '"Bool",
                              snapshotPersistenceEnabled =
                                _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  customHandler =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              description =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          arguments =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
                                          defaultExecutablePath =
                                            _js2n__-prdslib.isType '"String",
                                          workingDirectory =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                              enableForwardingHttpRequest =
                                _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  extensionBundle =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              id = _js2n__-prdslib.isType '"String",
                              version = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              blobs =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          maxDegreeOfParallelism =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          poisonBlobThreshold =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              cosmosDB =
                                _js2n__-refsenv."_js2n__-:definitions/cosmosDB-extension-v2!predicate",
                              durableTask =
                                _js2n__-refsenv."_js2n__-:definitions/durableTask-extension!predicate",
                              eventHubs =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              batchCheckpointFrequency =
                                                _js2n__-prdslib.isType 'Integer,
                                              clientRetryOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          delay =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d\\.\\d\\d$"
                                                                ],
                                                          maxDelay =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                                ],
                                                          maxRetries =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                          mode =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "exponential",
                                                                      "fixed"
                                                                    ]
                                                                ],
                                                          tryTimeout =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              customEndpointAddress =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              initialOffsetOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          enqueuedTimeUtc =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "fromStart",
                                                                      "fromEnd",
                                                                      "fromEnqueuedTime"
                                                                    ]
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              maxEventBatchSize =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Integer,
                                                      _js2n__-prdslib.numbers.minimum
                                                        1
                                                    ],
                                              prefetchCount =
                                                _js2n__-prdslib.isType 'Integer,
                                              targetUnprocessedEventThreshold =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Integer,
                                                      _js2n__-prdslib.numbers.minimum
                                                        1
                                                    ],
                                              transportType =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "amqpTcp",
                                                          "amqpWebSockets"
                                                        ]
                                                    ],
                                              webProxy =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              batchCheckpointFrequency =
                                                _js2n__-prdslib.isType 'Integer,
                                              eventProcessorOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          maxBatchSize =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                          prefetchCount =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              initialOffsetOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          type =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "fromStart",
                                                                      "fromEnd",
                                                                      "fromEnqueuedTime"
                                                                    ]
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              batchCheckpointFrequency =
                                                _js2n__-prdslib.isType 'Integer,
                                              maxBatchSize =
                                                _js2n__-prdslib.isType 'Integer,
                                              prefetchCount =
                                                _js2n__-prdslib.isType 'Integer,
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                              http =
                                _js2n__-refsenv."_js2n__-:definitions/http-extension!predicate",
                              queues =
                                _js2n__-refsenv."_js2n__-:definitions/queues-extension-v2!predicate",
                              sendGrid =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          from =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              serviceBus =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              batchOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          autoComplete =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          maxMessageCount =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                          operationTimeout =
                                                            _js2n__-prdslib.strings.pattern
                                                                "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              messageHandlerOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          autoComplete =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          maxAutoRenewDuration =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                                ],
                                                          maxConcurrentCalls =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                              prefetchCount =
                                                _js2n__-prdslib.isType 'Integer,
                                              sessionHandlerOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          autoComplete =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          maxAutoRenewDuration =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                                ],
                                                          maxConcurrentSessions =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                          messageWaitTimeout =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ],
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              autoCompleteMessages =
                                                _js2n__-prdslib.isType '"Bool",
                                              clientRetryOptions =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          delay =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d\\.\\d\\d$"
                                                                ],
                                                          maxDelay =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                                ],
                                                          maxRetries =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                          mode =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "exponential",
                                                                      "fixed"
                                                                    ]
                                                                ],
                                                          tryTimeout =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.strings.pattern
                                                                    "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                                ],
                                                        } {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                              enableCrossEntityTransactions =
                                                _js2n__-prdslib.isType '"Bool",
                                              maxAutoLockRenewalDuration =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.pattern
                                                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                    ],
                                              maxBatchWaitTime =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.pattern
                                                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                    ],
                                              maxConcurrentCalls =
                                                _js2n__-prdslib.isType 'Integer,
                                              maxConcurrentSessions =
                                                _js2n__-prdslib.isType 'Integer,
                                              maxMessageBatchSize =
                                                _js2n__-prdslib.isType 'Integer,
                                              prefetchCount =
                                                _js2n__-prdslib.isType 'Integer,
                                              sessionIdleTimeout =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.strings.pattern
                                                        "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                                    ],
                                              transportType =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.enum
                                                        [
                                                          "amqpTcp",
                                                          "amqpWebSockets"
                                                        ]
                                                    ],
                                              webProxy =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  functionTimeout =
                    _js2n__-refsenv."_js2n__-:definitions/functionTimeout!predicate",
                  functions =
                    _js2n__-refsenv."_js2n__-:definitions/functions!predicate",
                  healthMonitor =
                    _js2n__-refsenv."_js2n__-:definitions/healthMonitor!predicate",
                  languageWorker =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              workersDirectory =
                                _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                  logging =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              applicationInsights =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          enableDependencyTracking =
                                            _js2n__-prdslib.isType '"Bool",
                                          enableLiveMetrics =
                                            _js2n__-prdslib.isType '"Bool",
                                          enableLiveMetricsFilters =
                                            _js2n__-prdslib.isType '"Bool",
                                          enablePerformanceCountersCollection =
                                            _js2n__-prdslib.isType '"Bool",
                                          httpAutoCollectionOptions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      enableHttpTriggerExtendedInfoCollection =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      enableResponseHeaderInjection =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      enableW3CDistributedTracing =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                          samplingSettings =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      evaluationInterval =
                                                        _js2n__-prdslib.strings.pattern
                                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                                      excludedTypes =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      includedTypes =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                      initialSamplingPercentage =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      isEnabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      maxSamplingPercentage =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      maxTelemetryItemsPerSecond =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      minSamplingPercentage =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      movingAverageRatio =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      samplingPercentageDecreaseTimeout =
                                                        _js2n__-prdslib.strings.pattern
                                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                                      samplingPercentageIncreaseTimeout =
                                                        _js2n__-prdslib.strings.pattern
                                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          snapshotConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      agentEndpoint =
                                                        _js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ null ]
                                                            ],
                                                      captureSnapshotMemoryWeight =
                                                        _js2n__-prdslib.isType
                                                            '"Number",
                                                      failedRequestLimit =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      handleUntrackedExceptions =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      isEnabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      isEnabledInDeveloperMode =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      isEnabledWhenProfiling =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      isExceptionSnappointsEnabled =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      isLowPrioritySnapshotUploader =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      maximumCollectionPlanSize =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.maximum
                                                                9999,
                                                              _js2n__-prdslib.numbers.minimum
                                                                1
                                                            ],
                                                      maximumSnapshotsRequired =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Integer,
                                                              _js2n__-prdslib.numbers.maximum
                                                                999,
                                                              _js2n__-prdslib.numbers.minimum
                                                                1
                                                            ],
                                                      problemCounterResetInterval =
                                                        _js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.strings.pattern
                                                                "^(?:[01]\\d|2[0-4]):[0-5]\\d:[0-5]\\d$"
                                                            ],
                                                      provideAnonymousTelemetry =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      reconnectInterval =
                                                        _js2n__-prdslib.strings.pattern
                                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$",
                                                      shadowCopyFolder =
                                                        _js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ null ]
                                                            ],
                                                      shareUploaderProcess =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      snapshotInLowPriorityThread =
                                                        _js2n__-prdslib.isType
                                                            '"Bool",
                                                      snapshotsPerDayLimit =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      snapshotsPerTenMinutesLimit =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      tempFolder =
                                                        _js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ null ]
                                                            ],
                                                      thresholdForSnapshotting =
                                                        _js2n__-prdslib.isType
                                                            'Integer,
                                                      uploaderProxy =
                                                        _js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.enum
                                                                [ null ]
                                                            ],
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              fileLoggingMode =
                                _js2n__-prdslib.enum
                                    [ "never", "always", "debugOnly" ],
                              logLevel =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          "default" =
                                            _js2n__-prdslib.enum
                                                [
                                                  "Critical",
                                                  "Debug",
                                                  "Error",
                                                  "Information",
                                                  "None",
                                                  "Trace",
                                                  "Warning"
                                                ],
                                        } {} true
                                        (_js2n__-prdslib.enum
                                          [
                                            "Critical",
                                            "Debug",
                                            "Error",
                                            "Information",
                                            "None",
                                            "Trace",
                                            "Warning"
                                          ])
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  managedDependency =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { enabled = _js2n__-prdslib.isType '"Bool", } {}
                            false _js2n__-prdslib.never
                        ],
                  retry =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              delayInterval =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                        ],
                                      _js2n__-prdslib.enum [ null ]
                                    ],
                              maxRetryCount = _js2n__-prdslib.isType 'Integer,
                              maximumInterval =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                        ],
                                      _js2n__-prdslib.enum [ null ]
                                    ],
                              minimumInterval =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.strings.pattern
                                            "^(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$"
                                        ],
                                      _js2n__-prdslib.enum [ null ]
                                    ],
                              strategy =
                                _js2n__-prdslib.enum
                                    [ "exponentialBackoff", "fixedDelay" ],
                            } {} true _js2n__-prdslib.always
                        ],
                  sendCanceledInvocationsToWorker =
                    _js2n__-prdslib.isType '"Bool",
                  singleton =
                    _js2n__-refsenv."_js2n__-:definitions/singleton!predicate",
                  version = _js2n__-prdslib.enum [ "2.0" ],
                  watchDirectories =
                    _js2n__-refsenv."_js2n__-:definitions/watchDirectories!predicate",
                  watchFiles =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.minLength 1
                              ]),
                          _js2n__-prdslib.arrays.uniqueItems,
                          _js2n__-prdslib.records.record {} {} false
                            _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/watchDirectories!predicate"
        | doc "Set of shared code directories that should be monitored for changes to ensure that when code in these directories is changed, it is picked up by your functions"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/version-1!predicate",
              _js2n__-refsenv."_js2n__-:definitions/version-2!predicate"
            ]
        ])