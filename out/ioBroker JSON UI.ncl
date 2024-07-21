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
      "_js2n__-:definitions/aliveProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  instance = _js2n__-prdslib.isType '"Number",
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  textAlive = _js2n__-prdslib.isType '"String",
                  textNotAlive = _js2n__-prdslib.isType '"String",
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/allowAddByFilterProp!predicate"
        | doc "If add allowed even if filter is set"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/alsoDependsOnSendProp!predicate"
        | doc "Depends on other attributes and will be re-calculated when other attributes changed"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/certificatesProps!predicate"
        | doc "Universal type that manages `certPublic`, `certPrivate`, `certChained` and `leCollection` attributes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/checkboxProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  doNotSave = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/componentType!predicate"
        | doc "Type of the element"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "alive",
                  "autocomplete",
                  "cron",
                  "deviceManager",
                  "fileSelector",
                  "text",
                  "textSendTo",
                  "number",
                  "port",
                  "color",
                  "checkbox",
                  "chips",
                  "header",
                  "slider",
                  "ip",
                  "user",
                  "room",
                  "func",
                  "select",
                  "icon",
                  "image",
                  "panel",
                  "password",
                  "file",
                  "sendTo",
                  "staticText",
                  "custom",
                  "pattern",
                  "table",
                  "accordion",
                  "instance",
                  "language",
                  "setState",
                  "certificate",
                  "certificates",
                  "staticImage",
                  "staticLink",
                  "divider",
                  "objectId",
                  "selectSendTo",
                  "autocompleteSendTo",
                  "checkLicense",
                  "uuid",
                  "timePicker",
                  "datePicker",
                  "qrCode"
                ]
            ],
      "_js2n__-:definitions/cronProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "complex" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "simple" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  complex = _js2n__-prdslib.isType '"Bool",
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  simple = _js2n__-prdslib.isType '"Bool",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/customProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  i18n = _js2n__-refsenv."_js2n__-:definitions/i18n!predicate",
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  name = _js2n__-prdslib.isType '"String",
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  url = _js2n__-prdslib.isType '"String",
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/deviceManagerProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/doNotSaveProp!predicate"
        | doc "Do not save this attribute as used only for internal calculations"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/fileSelectorProps!predicate" =
        _js2n__-prdslib.records.record
            {
              confirm = _js2n__-prdslib.always,
              darkStyle = _js2n__-prdslib.always,
              "default" = _js2n__-prdslib.always,
              defaultFunc = _js2n__-prdslib.always,
              defaultSendTo = _js2n__-prdslib.always,
              delete = _js2n__-prdslib.isType '"Bool",
              disabled = _js2n__-prdslib.always,
              fileTypes = _js2n__-prdslib.enum [ "audio", "image", "text" ],
              help = _js2n__-prdslib.always,
              helpLink = _js2n__-prdslib.always,
              hidden = _js2n__-prdslib.always,
              hideOnlyControl = _js2n__-prdslib.always,
              label = _js2n__-prdslib.always,
              lg = _js2n__-prdslib.always,
              maxSize = _js2n__-prdslib.isType '"String",
              md = _js2n__-prdslib.always,
              newLine = _js2n__-prdslib.always,
              noMultiEdit = _js2n__-prdslib.always,
              noNone = _js2n__-prdslib.isType '"Bool",
              noSize = _js2n__-prdslib.isType '"Bool",
              noTranslation = _js2n__-prdslib.always,
              objectID = _js2n__-prdslib.isType '"String",
              onChange = _js2n__-prdslib.always,
              pattern = _js2n__-prdslib.isType '"String",
              refresh = _js2n__-prdslib.isType '"Bool",
              sm = _js2n__-prdslib.always,
              style = _js2n__-prdslib.always,
              tooltip = _js2n__-prdslib.always,
              type = _js2n__-prdslib.always,
              upload = _js2n__-prdslib.isType '"String",
              validator = _js2n__-prdslib.always,
              validatorErrorText = _js2n__-prdslib.always,
              validatorNoSaveOnError = _js2n__-prdslib.always,
              withFolder = _js2n__-prdslib.isType '"Bool",
              xs = _js2n__-prdslib.always,
            } {} false _js2n__-prdslib.never,
      "_js2n__-:definitions/i18n!predicate"
        | doc "If translations will be provided via files, e.g. in admin/i18n/de/translations.json or provide the path to the i18n folder if it's custom or provide the translations inside this attribute as an object"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {}
                    {
                      "^.+" =
                        _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                    } true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/iconPositionProp!predicate"
        | doc "Only for panels that has `icon` attribute."
        = _js2n__-prdslib.enum [ "bottom", "end", "start", "top" ],
      "_js2n__-:definitions/instanceProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "adapter", "type" ],
              _js2n__-prdslib.records.record
                {
                  adapter = _js2n__-prdslib.isType '"String",
                  adapters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  all = _js2n__-prdslib.isType '"Bool",
                  allowDeactivate = _js2n__-prdslib.isType '"Bool",
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  long = _js2n__-prdslib.isType '"Bool",
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  onlyEnabled = _js2n__-prdslib.isType '"Bool",
                  short = _js2n__-prdslib.isType '"Bool",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/multilingual!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "en" ],
              _js2n__-prdslib.records.record {}
                {
                  "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" =
                    _js2n__-prdslib.isType '"String",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/noInternalProp!predicate"
        | doc "Do not show internal IP addresses"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:definitions/numberProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  doNotSave = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  max = _js2n__-prdslib.isType '"Number",
                  md = _js2n__-prdslib.always,
                  min = _js2n__-prdslib.isType '"Number",
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  placeholder = _js2n__-prdslib.isType '"String",
                  sm = _js2n__-prdslib.always,
                  step = _js2n__-prdslib.isType '"Number",
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/objectIdProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  customFilter = _js2n__-prdslib.isType '"String",
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  placeholder = _js2n__-prdslib.isType '"String",
                  root = _js2n__-prdslib.isType '"Bool",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  types =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "state",
                                  "channel",
                                  "device",
                                  "enum",
                                  "host",
                                  "adapter",
                                  "instance",
                                  "meta",
                                  "config",
                                  "script",
                                  "user",
                                  "group",
                                  "chart",
                                  "folder"
                                ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [
                                        "state",
                                        "channel",
                                        "device",
                                        "enum",
                                        "host",
                                        "adapter",
                                        "instance",
                                        "meta",
                                        "config",
                                        "script",
                                        "user",
                                        "group",
                                        "chart",
                                        "folder"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.maxItems 1
                            ]
                        ],
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/passwordProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  doNotSave = _js2n__-prdslib.always,
                  encrypted = _js2n__-prdslib.isType '"Bool",
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  maxLength = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  repeat = _js2n__-prdslib.isType '"Bool",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  visible = _js2n__-prdslib.isType '"Bool",
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/qrCodeProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "data", "type" ],
              _js2n__-prdslib.records.record
                {
                  bgColor = _js2n__-prdslib.isType '"String",
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  data = _js2n__-prdslib.isType '"String",
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  fgColor = _js2n__-prdslib.isType '"String",
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  level = _js2n__-prdslib.enum [ "L", "M", "Q", "H" ],
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  size = _js2n__-prdslib.isType '"Number",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/sendToProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "command", "type" ],
              _js2n__-prdslib.records.record
                {
                  color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "primary", "secondary" ]
                        ],
                  command = _js2n__-prdslib.isType '"String",
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  data = _js2n__-prdslib.isType 'Record,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  error = _js2n__-prdslib.isType 'Record,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  icon = _js2n__-prdslib.isType '"String",
                  jsonData = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  onLoaded = _js2n__-prdslib.isType '"Bool",
                  openUrl = _js2n__-prdslib.isType '"Bool",
                  placeholder = _js2n__-prdslib.isType '"String",
                  result = _js2n__-prdslib.isType 'Record,
                  showProcess = _js2n__-prdslib.isType '"Bool",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  useNative = _js2n__-prdslib.isType '"Bool",
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  variant =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "contained", "outlined" ]
                        ],
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/staticLinkProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "href", "type" ],
              _js2n__-prdslib.records.record
                {
                  button = _js2n__-prdslib.always,
                  color = _js2n__-prdslib.isType '"String",
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  href = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  text =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                        ],
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  variant =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "contained", "outlined", "text" ]
                        ],
                  xs = _js2n__-prdslib.always,
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/tableItemBaseProps!predicate" =
        _js2n__-prdslib.records.record
            {
              attr = _js2n__-prdslib.isType '"String",
              filter = _js2n__-prdslib.isType '"Bool",
              sort = _js2n__-prdslib.isType '"Bool",
              title =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                    ],
              width =
                _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"String"
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/tableItems!predicate"
        | doc "Items of the table"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "language", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required
                                [ "system", "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  system = _js2n__-prdslib.isType '"Bool",
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              type = _js2n__-prdslib.const "autocompleteSendTo",
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required
                                [ "command", "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  alsoDependsOn =
                                    _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                  attr = _js2n__-prdslib.always,
                                  command = _js2n__-prdslib.isType '"String",
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  data = _js2n__-prdslib.isType 'Record,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  freeSolo = _js2n__-prdslib.isType '"Bool",
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  jsonData = _js2n__-prdslib.isType '"String",
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  maxLength = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  placeholder =
                                    _js2n__-prdslib.isType '"String",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "selectSendTo", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required
                                [ "command", "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  alsoDependsOn =
                                    _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                  attr = _js2n__-prdslib.always,
                                  command = _js2n__-prdslib.isType '"String",
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  data = _js2n__-prdslib.isType 'Record,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  doNotSave =
                                    _js2n__-refsenv."_js2n__-:definitions/doNotSaveProp!predicate",
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  jsonData = _js2n__-prdslib.isType '"String",
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  manual = _js2n__-prdslib.isType '"Bool",
                                  md = _js2n__-prdslib.always,
                                  multiple = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "textSendTo", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required
                                [ "command", "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  alsoDependsOn =
                                    _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                  attr = _js2n__-prdslib.always,
                                  command = _js2n__-prdslib.isType '"String",
                                  confirm = _js2n__-prdslib.always,
                                  container = _js2n__-prdslib.isType '"String",
                                  copyToClipboard =
                                    _js2n__-prdslib.isType '"Bool",
                                  darkStyle = _js2n__-prdslib.always,
                                  data = _js2n__-prdslib.isType 'Record,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  jsonData = _js2n__-prdslib.isType '"String",
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "header", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "size", "text", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      size =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.maximum 5,
                                              _js2n__-prdslib.numbers.minimum 1
                                            ],
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      text =
                                        _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                            ],
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "color", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "divider", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      color =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "primary", "secondary" ]
                                            ],
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      height = _js2n__-prdslib.isType '"Number",
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "fileSelector", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  delete = _js2n__-prdslib.isType '"Bool",
                                  disabled = _js2n__-prdslib.always,
                                  fileTypes =
                                    _js2n__-prdslib.enum
                                        [ "audio", "image", "text" ],
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  maxSize = _js2n__-prdslib.isType '"String",
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noNone = _js2n__-prdslib.isType '"Bool",
                                  noSize = _js2n__-prdslib.isType '"Bool",
                                  noTranslation = _js2n__-prdslib.always,
                                  objectID = _js2n__-prdslib.isType '"String",
                                  onChange = _js2n__-prdslib.always,
                                  pattern = _js2n__-prdslib.isType '"String",
                                  refresh = _js2n__-prdslib.isType '"Bool",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  upload = _js2n__-prdslib.isType '"String",
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  withFolder = _js2n__-prdslib.isType '"Bool",
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "icon", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      crop = _js2n__-prdslib.isType '"Bool",
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      maxHeight =
                                        _js2n__-prdslib.isType '"Number",
                                      maxSize =
                                        _js2n__-prdslib.isType '"Number",
                                      maxWidth =
                                        _js2n__-prdslib.isType '"Number",
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      square = _js2n__-prdslib.isType '"Bool",
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "panel", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "items", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      icon = _js2n__-prdslib.isType '"String",
                                      iconPosition =
                                        _js2n__-refsenv."_js2n__-:definitions/iconPositionProp!predicate",
                                      items =
                                        _js2n__-refsenv."_js2n__-:definitions/topLevelProperties/properties/items!predicate",
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "image", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      accept = _js2n__-prdslib.isType '"String",
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      crop = _js2n__-prdslib.isType '"Bool",
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      filename =
                                        _js2n__-prdslib.isType '"String",
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      maxHeight =
                                        _js2n__-prdslib.isType '"Number",
                                      maxSize =
                                        _js2n__-prdslib.isType '"Number",
                                      maxWidth =
                                        _js2n__-prdslib.isType '"Number",
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      square = _js2n__-prdslib.isType '"Bool",
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "sendTo", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "command", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      color =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "primary", "secondary" ]
                                            ],
                                      command =
                                        _js2n__-prdslib.isType '"String",
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      data = _js2n__-prdslib.isType 'Record,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      error = _js2n__-prdslib.isType 'Record,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      icon = _js2n__-prdslib.isType '"String",
                                      jsonData =
                                        _js2n__-prdslib.isType '"String",
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      onLoaded = _js2n__-prdslib.isType '"Bool",
                                      openUrl = _js2n__-prdslib.isType '"Bool",
                                      placeholder =
                                        _js2n__-prdslib.isType '"String",
                                      result = _js2n__-prdslib.isType 'Record,
                                      showProcess =
                                        _js2n__-prdslib.isType '"Bool",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      title = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      useNative =
                                        _js2n__-prdslib.isType '"Bool",
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      variant =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "contained", "outlined" ]
                                            ],
                                      width = _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "password", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  encrypted = _js2n__-prdslib.isType '"Bool",
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  repeat = _js2n__-prdslib.isType '"Bool",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  visible = _js2n__-prdslib.isType '"Bool",
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "file", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "filename", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      filename =
                                        _js2n__-prdslib.isType '"String",
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "slider", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      max = _js2n__-prdslib.isType '"Number",
                                      md = _js2n__-prdslib.always,
                                      min = _js2n__-prdslib.isType '"Number",
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      step = _js2n__-prdslib.isType '"Number",
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "custom", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/customProps!predicate"
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "checkbox", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            {
                              type = _js2n__-prdslib.enum [ "number", "port" ],
                            } {} true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  doNotSave = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  max = _js2n__-prdslib.isType '"Number",
                                  md = _js2n__-prdslib.always,
                                  min = _js2n__-prdslib.isType '"Number",
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  placeholder =
                                    _js2n__-prdslib.isType '"String",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  step = _js2n__-prdslib.isType '"Number",
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "alive", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/aliveProps!predicate"
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "autocomplete", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "options", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      freeSolo = _js2n__-prdslib.isType '"Bool",
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      options =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.oneOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.isType
                                                      'Record
                                                  ])
                                            ],
                                      placeholder =
                                        _js2n__-prdslib.isType '"String",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "cron", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "complex" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "simple" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  complex = _js2n__-prdslib.isType '"Bool",
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  simple = _js2n__-prdslib.isType '"Bool",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "text", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  doNotSave = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  maxLength = _js2n__-prdslib.always,
                                  maxRows = _js2n__-prdslib.isType '"Number",
                                  md = _js2n__-prdslib.always,
                                  minRows = _js2n__-prdslib.isType '"Number",
                                  newLine = _js2n__-prdslib.always,
                                  noClearButton =
                                    _js2n__-prdslib.isType '"Bool",
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  placeholder =
                                    _js2n__-prdslib.isType '"String",
                                  readOnly = _js2n__-prdslib.isType '"Bool",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  text =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                        ],
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  trim = _js2n__-prdslib.isType '"Bool",
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "select", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  options =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "label", "value" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    hidden =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                    label =
                                                      _js2n__-prdslib.always,
                                                    value =
                                                      _js2n__-prdslib.always,
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ])
                                        ],
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "pattern", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "pattern", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      copyToClipboard =
                                        _js2n__-prdslib.isType '"Bool",
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      pattern =
                                        _js2n__-prdslib.isType '"String",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "setState", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "id", "type", "val" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      ack = _js2n__-prdslib.isType '"Bool",
                                      attr = _js2n__-prdslib.always,
                                      color =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "primary", "secondary" ]
                                            ],
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      error = _js2n__-prdslib.isType 'Record,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      icon = _js2n__-prdslib.isType '"String",
                                      id = _js2n__-prdslib.isType '"String",
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      okText = _js2n__-prdslib.isType '"String",
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      val = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      variant =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "contained", "outlined" ]
                                            ],
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "qrCode", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "data", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      bgColor =
                                        _js2n__-prdslib.isType '"String",
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      data = _js2n__-prdslib.isType '"String",
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      fgColor =
                                        _js2n__-prdslib.isType '"String",
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      level =
                                        _js2n__-prdslib.enum
                                            [ "L", "M", "Q", "H" ],
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      size = _js2n__-prdslib.isType '"Number",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "func", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      short = _js2n__-prdslib.isType '"String",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "room", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      short = _js2n__-prdslib.isType '"String",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "user", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      short = _js2n__-prdslib.isType '"String",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "ip", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      listenOnAllPorts =
                                        _js2n__-prdslib.isType '"Bool",
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noInternal =
                                        _js2n__-refsenv."_js2n__-:definitions/noInternalProp!predicate",
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      onlyIp4 = _js2n__-prdslib.isType '"Bool",
                                      onlyIp6 = _js2n__-prdslib.isType '"Bool",
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "certificate", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "certType", "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      certType =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "public",
                                                  "private",
                                                  "chained"
                                                ]
                                            ],
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "certificates", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/certificatesProps!predicate"
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "staticLink", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                                  _js2n__-refsenv."_js2n__-:definitions/staticLinkProps!predicate"
                                ],
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  color = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  href = _js2n__-prdslib.always,
                                  icon = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  text = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  variant = _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "staticText", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.oneOf
                                [
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "text" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "label" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ]
                                ],
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  text =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                        ],
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "instance", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required
                                [ "adapter", "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  adapter = _js2n__-prdslib.isType '"String",
                                  adapters =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.isType '"String")
                                        ],
                                  all = _js2n__-prdslib.isType '"Bool",
                                  allowDeactivate =
                                    _js2n__-prdslib.isType '"Bool",
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  long = _js2n__-prdslib.isType '"Bool",
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  onlyEnabled = _js2n__-prdslib.isType '"Bool",
                                  short = _js2n__-prdslib.isType '"Bool",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "staticImage", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      href = _js2n__-prdslib.isType '"String",
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      src = _js2n__-prdslib.isType '"String",
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "chips", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      attr = _js2n__-prdslib.always,
                                      confirm = _js2n__-prdslib.always,
                                      darkStyle = _js2n__-prdslib.always,
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc = _js2n__-prdslib.always,
                                      defaultSendTo = _js2n__-prdslib.always,
                                      delimiter =
                                        _js2n__-prdslib.isType '"String",
                                      disabled = _js2n__-prdslib.always,
                                      help = _js2n__-prdslib.always,
                                      helpLink = _js2n__-prdslib.always,
                                      hidden = _js2n__-prdslib.always,
                                      hideOnlyControl = _js2n__-prdslib.always,
                                      label = _js2n__-prdslib.always,
                                      lg = _js2n__-prdslib.always,
                                      md = _js2n__-prdslib.always,
                                      newLine = _js2n__-prdslib.always,
                                      noMultiEdit = _js2n__-prdslib.always,
                                      noTranslation = _js2n__-prdslib.always,
                                      onChange = _js2n__-prdslib.always,
                                      sm = _js2n__-prdslib.always,
                                      style = _js2n__-prdslib.always,
                                      tooltip = _js2n__-prdslib.always,
                                      type = _js2n__-prdslib.always,
                                      validator = _js2n__-prdslib.always,
                                      validatorErrorText =
                                        _js2n__-prdslib.always,
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.always,
                                      xs = _js2n__-prdslib.always,
                                    } {} false _js2n__-prdslib.never
                                ]
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "objectId", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  customFilter =
                                    _js2n__-prdslib.isType '"String",
                                  darkStyle = _js2n__-prdslib.always,
                                  "default" = _js2n__-prdslib.always,
                                  defaultFunc = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  filter = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  onChange = _js2n__-prdslib.always,
                                  placeholder =
                                    _js2n__-prdslib.isType '"String",
                                  root = _js2n__-prdslib.isType '"Bool",
                                  sm = _js2n__-prdslib.always,
                                  sort = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  title = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  types =
                                    _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "state",
                                                  "channel",
                                                  "device",
                                                  "enum",
                                                  "host",
                                                  "adapter",
                                                  "instance",
                                                  "meta",
                                                  "config",
                                                  "script",
                                                  "user",
                                                  "group",
                                                  "chart",
                                                  "folder"
                                                ]
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "state",
                                                        "channel",
                                                        "device",
                                                        "enum",
                                                        "host",
                                                        "adapter",
                                                        "instance",
                                                        "meta",
                                                        "config",
                                                        "script",
                                                        "user",
                                                        "group",
                                                        "chart",
                                                        "folder"
                                                      ]
                                                  ]),
                                              _js2n__-prdslib.arrays.maxItems 1
                                            ]
                                        ],
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  width = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "checkLicense", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  uuid = _js2n__-prdslib.isType '"Bool",
                                  version = _js2n__-prdslib.isType '"Bool",
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "uuid", } {} true
                            _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "datePicker", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  sm = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "timePicker", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/tableItemBaseProps!predicate",
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record
                                {
                                  attr = _js2n__-prdslib.always,
                                  confirm = _js2n__-prdslib.always,
                                  darkStyle = _js2n__-prdslib.always,
                                  defaultSendTo = _js2n__-prdslib.always,
                                  disabled = _js2n__-prdslib.always,
                                  format = _js2n__-prdslib.isType '"String",
                                  help = _js2n__-prdslib.always,
                                  helpLink = _js2n__-prdslib.always,
                                  hidden = _js2n__-prdslib.always,
                                  hideOnlyControl = _js2n__-prdslib.always,
                                  label = _js2n__-prdslib.always,
                                  lg = _js2n__-prdslib.always,
                                  md = _js2n__-prdslib.always,
                                  newLine = _js2n__-prdslib.always,
                                  noMultiEdit = _js2n__-prdslib.always,
                                  noTranslation = _js2n__-prdslib.always,
                                  returnFormat =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.enum
                                            [ "fullDate", "HH:mm:ss" ]
                                        ],
                                  sm = _js2n__-prdslib.always,
                                  style = _js2n__-prdslib.always,
                                  timeSteps =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              hours =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              minutes =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              seconds =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                  tooltip = _js2n__-prdslib.always,
                                  type = _js2n__-prdslib.always,
                                  validator = _js2n__-prdslib.always,
                                  validatorErrorText = _js2n__-prdslib.always,
                                  validatorNoSaveOnError =
                                    _js2n__-prdslib.always,
                                  views =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "hours",
                                                    "minutes",
                                                    "seconds"
                                                  ]
                                              ])
                                        ],
                                  xs = _js2n__-prdslib.always,
                                } {} false _js2n__-prdslib.never
                            ]) _js2n__-prdslib.always
                      ],
                    _js2n__-prdslib.records.required [ "type" ],
                    _js2n__-prdslib.records.record
                      {
                        button = _js2n__-prdslib.isType '"Bool",
                        confirm =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    alsoDependsOn =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    cancel =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                          ],
                                    condition =
                                      _js2n__-prdslib.isType '"String",
                                    ok =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                          ],
                                    text =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                          ],
                                    title =
                                      _js2n__-prdslib.oneOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                          ],
                                    type =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "info",
                                                "warning",
                                                "error",
                                                "none"
                                              ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ],
                        darkStyle = _js2n__-prdslib.isType '"String",
                        "default" = _js2n__-prdslib.always,
                        defaultFunc =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        alsoDependsOn =
                                          _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                        func = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ],
                        defaultSendTo = _js2n__-prdslib.isType '"String",
                        disabled = _js2n__-prdslib.isType '"String",
                        doNotSave =
                          _js2n__-refsenv."_js2n__-:definitions/doNotSaveProp!predicate",
                        help =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                              ],
                        helpLink = _js2n__-prdslib.isType '"String",
                        hidden = _js2n__-prdslib.isType '"String",
                        hideOnlyControl = _js2n__-prdslib.isType '"Bool",
                        label =
                          _js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                              ],
                        lg = _js2n__-prdslib.isType '"Number",
                        maxLength = _js2n__-prdslib.isType '"Number",
                        md = _js2n__-prdslib.isType '"Number",
                        newLine = _js2n__-prdslib.isType '"Bool",
                        noMultiEdit = _js2n__-prdslib.isType '"Bool",
                        noTranslation = _js2n__-prdslib.isType '"Bool",
                        onChange =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    alsoDependsOn =
                                      _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                    calculateFunc =
                                      _js2n__-prdslib.isType '"String",
                                    ignoreOwnChanges =
                                      _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ],
                        showFirstAddOnTop = _js2n__-prdslib.isType '"Bool",
                        showSecondAddAt = _js2n__-prdslib.isType '"Number",
                        sm = _js2n__-prdslib.isType '"Number",
                        style = _js2n__-prdslib.isType 'Record,
                        tooltip = _js2n__-prdslib.isType '"String",
                        type =
                          _js2n__-refsenv."_js2n__-:definitions/componentType!predicate",
                        validator = _js2n__-prdslib.isType '"String",
                        validatorErrorText = _js2n__-prdslib.isType '"String",
                        validatorNoSaveOnError = _js2n__-prdslib.isType '"Bool",
                        xs = _js2n__-prdslib.isType '"Number",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/textProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  confirm = _js2n__-prdslib.always,
                  darkStyle = _js2n__-prdslib.always,
                  "default" = _js2n__-prdslib.always,
                  defaultFunc = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  doNotSave = _js2n__-prdslib.always,
                  help = _js2n__-prdslib.always,
                  helpLink = _js2n__-prdslib.always,
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  maxLength = _js2n__-prdslib.always,
                  maxRows = _js2n__-prdslib.isType '"Number",
                  md = _js2n__-prdslib.always,
                  minRows = _js2n__-prdslib.isType '"Number",
                  newLine = _js2n__-prdslib.always,
                  noClearButton = _js2n__-prdslib.isType '"Bool",
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  onChange = _js2n__-prdslib.always,
                  placeholder = _js2n__-prdslib.isType '"String",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  text =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                        ],
                  tooltip = _js2n__-prdslib.always,
                  trim = _js2n__-prdslib.isType '"Bool",
                  type = _js2n__-prdslib.always,
                  validator = _js2n__-prdslib.always,
                  validatorErrorText = _js2n__-prdslib.always,
                  validatorNoSaveOnError = _js2n__-prdslib.always,
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/timePickerProps!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "type" ],
              _js2n__-prdslib.records.record
                {
                  darkStyle = _js2n__-prdslib.always,
                  defaultSendTo = _js2n__-prdslib.always,
                  disabled = _js2n__-prdslib.always,
                  format = _js2n__-prdslib.isType '"String",
                  hidden = _js2n__-prdslib.always,
                  hideOnlyControl = _js2n__-prdslib.always,
                  label = _js2n__-prdslib.always,
                  lg = _js2n__-prdslib.always,
                  md = _js2n__-prdslib.always,
                  newLine = _js2n__-prdslib.always,
                  noMultiEdit = _js2n__-prdslib.always,
                  noTranslation = _js2n__-prdslib.always,
                  returnFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "fullDate", "HH:mm:ss" ]
                        ],
                  sm = _js2n__-prdslib.always,
                  style = _js2n__-prdslib.always,
                  timeSteps =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              hours = _js2n__-prdslib.isType '"Number",
                              minutes = _js2n__-prdslib.isType '"Number",
                              seconds = _js2n__-prdslib.isType '"Number",
                            } {} false _js2n__-prdslib.never
                        ],
                  tooltip = _js2n__-prdslib.always,
                  type = _js2n__-prdslib.always,
                  views =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [ "hours", "minutes", "seconds" ]
                              ])
                        ],
                  xs = _js2n__-prdslib.always,
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/topLevelProperties!predicate" =
        _js2n__-prdslib.records.record
            {
              "$schema" = _js2n__-prdslib.isType '"String",
              i18n = _js2n__-refsenv."_js2n__-:definitions/i18n!predicate",
              items =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^.+" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "language",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "system", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                system =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "autocompleteSendTo",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "command", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                alsoDependsOn =
                                                  _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                                command =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                data =
                                                  _js2n__-prdslib.isType
                                                      'Record,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                freeSolo =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                jsonData =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                maxLength =
                                                  _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                placeholder =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "selectSendTo",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "command", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                alsoDependsOn =
                                                  _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                                command =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                data =
                                                  _js2n__-prdslib.isType
                                                      'Record,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                doNotSave =
                                                  _js2n__-refsenv."_js2n__-:definitions/doNotSaveProp!predicate",
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                jsonData =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                manual =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                md = _js2n__-prdslib.always,
                                                multiple =
                                                  _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "textSendTo",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "command", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                alsoDependsOn =
                                                  _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                                command =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                container =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                copyToClipboard =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                data =
                                                  _js2n__-prdslib.isType
                                                      'Record,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                jsonData =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "header",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "size", "text", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                size =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Number",
                                                        _js2n__-prdslib.numbers.maximum
                                                          5,
                                                        _js2n__-prdslib.numbers.minimum
                                                          1
                                                      ],
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                text =
                                                  _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                      ],
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "color",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "divider",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                color =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "primary",
                                                            "secondary"
                                                          ]
                                                      ],
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                height =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "icon",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                crop =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                maxHeight =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                maxSize =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                maxWidth =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                square =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "panel",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "items", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                icon =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                iconPosition =
                                                  _js2n__-refsenv."_js2n__-:definitions/iconPositionProp!predicate",
                                                innerStyle =
                                                  _js2n__-prdslib.always,
                                                items =
                                                  _js2n__-refsenv."_js2n__-:definitions/topLevelProperties/properties/items!predicate",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "image",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                accept =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                crop =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                filename =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                maxHeight =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                maxSize =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                maxWidth =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                square =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "sendTo",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/sendToProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "password",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/passwordProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "file",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "filename", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                filename =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                filter = _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                sort = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                title = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "slider",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                max =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                md = _js2n__-prdslib.always,
                                                min =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                step =
                                                  _js2n__-prdslib.isType
                                                      '"Number",
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "custom",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/customProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "checkbox",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/checkboxProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "fileSelector",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/fileSelectorProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "number", "port" ],
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/numberProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "alive",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/aliveProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "autocomplete",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "options", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                freeSolo =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                options =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.oneOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.isType
                                                                'Record
                                                            ])
                                                      ],
                                                placeholder =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "qrCode",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/qrCodeProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "cron",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/cronProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "deviceManager",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/deviceManagerProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "text",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/textProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "select",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                options =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [
                                                                  "label",
                                                                  "value"
                                                                ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  hidden =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  label =
                                                                    _js2n__-prdslib.always,
                                                                  value =
                                                                    _js2n__-prdslib.always,
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ])
                                                      ],
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "table",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "items", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                allowAddByFilter =
                                                  _js2n__-refsenv."_js2n__-:definitions/allowAddByFilterProp!predicate",
                                                clone =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                compact =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                encryptedAttributes =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                export =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                "import" =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                items =
                                                  _js2n__-refsenv."_js2n__-:definitions/tableItems!predicate",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noDelete =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                showSecondAddAt =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                uniqueColumns =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "pattern",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "pattern", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                copyToClipboard =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                pattern =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "setState",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "id", "type", "val" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                ack =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                color =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "primary",
                                                            "secondary"
                                                          ]
                                                      ],
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                error =
                                                  _js2n__-prdslib.isType
                                                      'Record,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                icon =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                id =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                okText =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                val = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                variant =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "contained",
                                                            "outlined"
                                                          ]
                                                      ],
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "func",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                short =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "room",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                short =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "user",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                short =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          { type = _js2n__-prdslib.const "ip", }
                                          {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                listenOnAllPorts =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noInternal =
                                                  _js2n__-refsenv."_js2n__-:definitions/noInternalProp!predicate",
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                onlyIp4 =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                onlyIp6 =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "certificate",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "certType", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                certType =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [
                                                            "public",
                                                            "private",
                                                            "chained"
                                                          ]
                                                      ],
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "certificates",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/certificatesProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "staticLink",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/staticLinkProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "staticText",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.records.required
                                                      [ "text" ],
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.records.required
                                                      [ "label" ],
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ]
                                              ],
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                text =
                                                  _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                      ],
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "instance",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/instanceProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "staticImage",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                href =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                src =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "chips",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                delimiter =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "objectId",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/objectIdProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "checkLicense",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            darkStyle = _js2n__-prdslib.always,
                                            defaultSendTo =
                                              _js2n__-prdslib.always,
                                            disabled = _js2n__-prdslib.always,
                                            hidden = _js2n__-prdslib.always,
                                            hideOnlyControl =
                                              _js2n__-prdslib.always,
                                            label = _js2n__-prdslib.always,
                                            lg = _js2n__-prdslib.always,
                                            md = _js2n__-prdslib.always,
                                            newLine = _js2n__-prdslib.always,
                                            noMultiEdit =
                                              _js2n__-prdslib.always,
                                            noTranslation =
                                              _js2n__-prdslib.always,
                                            sm = _js2n__-prdslib.always,
                                            style = _js2n__-prdslib.always,
                                            type = _js2n__-prdslib.always,
                                            uuid =
                                              _js2n__-prdslib.isType '"Bool",
                                            version =
                                              _js2n__-prdslib.isType '"Bool",
                                            xs = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never)
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "datePicker",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            darkStyle = _js2n__-prdslib.always,
                                            defaultSendTo =
                                              _js2n__-prdslib.always,
                                            disabled = _js2n__-prdslib.always,
                                            hidden = _js2n__-prdslib.always,
                                            hideOnlyControl =
                                              _js2n__-prdslib.always,
                                            label = _js2n__-prdslib.always,
                                            lg = _js2n__-prdslib.always,
                                            md = _js2n__-prdslib.always,
                                            newLine = _js2n__-prdslib.always,
                                            noMultiEdit =
                                              _js2n__-prdslib.always,
                                            noTranslation =
                                              _js2n__-prdslib.always,
                                            sm = _js2n__-prdslib.always,
                                            style = _js2n__-prdslib.always,
                                            type = _js2n__-prdslib.always,
                                            xs = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never)
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const
                                                  "timePicker",
                                          } {} true _js2n__-prdslib.always)
                                        _js2n__-refsenv."_js2n__-:definitions/timePickerProps!predicate"
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type = _js2n__-prdslib.const "uuid",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            darkStyle = _js2n__-prdslib.always,
                                            defaultSendTo =
                                              _js2n__-prdslib.always,
                                            disabled = _js2n__-prdslib.always,
                                            hidden = _js2n__-prdslib.always,
                                            hideOnlyControl =
                                              _js2n__-prdslib.always,
                                            label = _js2n__-prdslib.always,
                                            lg = _js2n__-prdslib.always,
                                            md = _js2n__-prdslib.always,
                                            newLine = _js2n__-prdslib.always,
                                            noMultiEdit =
                                              _js2n__-prdslib.always,
                                            noTranslation =
                                              _js2n__-prdslib.always,
                                            sm = _js2n__-prdslib.always,
                                            style = _js2n__-prdslib.always,
                                            type = _js2n__-prdslib.always,
                                            xs = _js2n__-prdslib.always,
                                          } {} false _js2n__-prdslib.never)
                                        _js2n__-prdslib.always,
                                      _js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            type =
                                              _js2n__-prdslib.const "accordion",
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "items", "type" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                clone =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                confirm =
                                                  _js2n__-prdslib.always,
                                                darkStyle =
                                                  _js2n__-prdslib.always,
                                                "default" =
                                                  _js2n__-prdslib.always,
                                                defaultFunc =
                                                  _js2n__-prdslib.always,
                                                defaultSendTo =
                                                  _js2n__-prdslib.always,
                                                disabled =
                                                  _js2n__-prdslib.always,
                                                help = _js2n__-prdslib.always,
                                                helpLink =
                                                  _js2n__-prdslib.always,
                                                hidden = _js2n__-prdslib.always,
                                                hideOnlyControl =
                                                  _js2n__-prdslib.always,
                                                items =
                                                  _js2n__-refsenv."_js2n__-:definitions/tableItems!predicate",
                                                label = _js2n__-prdslib.always,
                                                lg = _js2n__-prdslib.always,
                                                md = _js2n__-prdslib.always,
                                                newLine =
                                                  _js2n__-prdslib.always,
                                                noDelete =
                                                  _js2n__-prdslib.isType
                                                      '"Bool",
                                                noMultiEdit =
                                                  _js2n__-prdslib.always,
                                                noTranslation =
                                                  _js2n__-prdslib.always,
                                                onChange =
                                                  _js2n__-prdslib.always,
                                                showSecondAddAt =
                                                  _js2n__-prdslib.always,
                                                sm = _js2n__-prdslib.always,
                                                style = _js2n__-prdslib.always,
                                                titleAttr =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                tooltip =
                                                  _js2n__-prdslib.always,
                                                type = _js2n__-prdslib.always,
                                                validator =
                                                  _js2n__-prdslib.always,
                                                validatorErrorText =
                                                  _js2n__-prdslib.always,
                                                validatorNoSaveOnError =
                                                  _js2n__-prdslib.always,
                                                xs = _js2n__-prdslib.always,
                                              } {} false _js2n__-prdslib.never
                                          ]) _js2n__-prdslib.always
                                    ],
                                  _js2n__-prdslib.records.required [ "type" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      button = _js2n__-prdslib.isType '"Bool",
                                      confirm =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  alsoDependsOn =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"Array",
                                                          _js2n__-prdslib.arrays.arrayOf
                                                            (_js2n__-prdslib.isType
                                                              '"String")
                                                        ],
                                                  cancel =
                                                    _js2n__-prdslib.oneOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                        ],
                                                  condition =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  ok =
                                                    _js2n__-prdslib.oneOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                        ],
                                                  text =
                                                    _js2n__-prdslib.oneOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                        ],
                                                  title =
                                                    _js2n__-prdslib.oneOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                        ],
                                                  type =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "info",
                                                              "warning",
                                                              "error",
                                                              "none"
                                                            ]
                                                        ],
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      darkStyle =
                                        _js2n__-prdslib.isType '"String",
                                      "default" = _js2n__-prdslib.always,
                                      defaultFunc =
                                        _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      alsoDependsOn =
                                                        _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                                      func =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} false
                                                    _js2n__-prdslib.never
                                                ]
                                            ],
                                      defaultSendTo =
                                        _js2n__-prdslib.isType '"String",
                                      disabled =
                                        _js2n__-prdslib.isType '"String",
                                      doNotSave =
                                        _js2n__-refsenv."_js2n__-:definitions/doNotSaveProp!predicate",
                                      help =
                                        _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                            ],
                                      helpLink =
                                        _js2n__-prdslib.isType '"String",
                                      hidden = _js2n__-prdslib.isType '"String",
                                      hideOnlyControl =
                                        _js2n__-prdslib.isType '"Bool",
                                      innerStyle =
                                        _js2n__-prdslib.isType 'Record,
                                      label =
                                        _js2n__-prdslib.oneOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                            ],
                                      lg = _js2n__-prdslib.isType '"Number",
                                      maxLength =
                                        _js2n__-prdslib.isType '"Number",
                                      md = _js2n__-prdslib.isType '"Number",
                                      newLine = _js2n__-prdslib.isType '"Bool",
                                      noMultiEdit =
                                        _js2n__-prdslib.isType '"Bool",
                                      noTranslation =
                                        _js2n__-prdslib.isType '"Bool",
                                      onChange =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  alsoDependsOn =
                                                    _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                                  calculateFunc =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  ignoreOwnChanges =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      showSecondAddAt =
                                        _js2n__-prdslib.isType '"Number",
                                      sm = _js2n__-prdslib.isType '"Number",
                                      style = _js2n__-prdslib.isType 'Record,
                                      tooltip =
                                        _js2n__-prdslib.isType '"String",
                                      type =
                                        _js2n__-refsenv."_js2n__-:definitions/componentType!predicate",
                                      validator =
                                        _js2n__-prdslib.isType '"String",
                                      validatorErrorText =
                                        _js2n__-prdslib.isType '"String",
                                      validatorNoSaveOnError =
                                        _js2n__-prdslib.isType '"Bool",
                                      xs = _js2n__-prdslib.isType '"Number",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } true _js2n__-prdslib.always
                    ],
              type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "tabs", "panel" ]
                    ],
            } {} true _js2n__-prdslib.always,
      "_js2n__-:definitions/topLevelProperties/properties/items!predicate"
        | doc "Consists of objects representing e.g. a single tab"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^.+" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "language", }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "system", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        system = _js2n__-prdslib.isType '"Bool",
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.const
                                          "autocompleteSendTo",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "command", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        alsoDependsOn =
                                          _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                        command =
                                          _js2n__-prdslib.isType '"String",
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        data = _js2n__-prdslib.isType 'Record,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        freeSolo =
                                          _js2n__-prdslib.isType '"Bool",
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        jsonData =
                                          _js2n__-prdslib.isType '"String",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        maxLength = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        placeholder =
                                          _js2n__-prdslib.isType '"String",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "selectSendTo",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "command", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        alsoDependsOn =
                                          _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                        command =
                                          _js2n__-prdslib.isType '"String",
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        data = _js2n__-prdslib.isType 'Record,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        doNotSave =
                                          _js2n__-refsenv."_js2n__-:definitions/doNotSaveProp!predicate",
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        jsonData =
                                          _js2n__-prdslib.isType '"String",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        manual = _js2n__-prdslib.isType '"Bool",
                                        md = _js2n__-prdslib.always,
                                        multiple = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "textSendTo", }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "command", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        alsoDependsOn =
                                          _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                        command =
                                          _js2n__-prdslib.isType '"String",
                                        confirm = _js2n__-prdslib.always,
                                        container =
                                          _js2n__-prdslib.isType '"String",
                                        copyToClipboard =
                                          _js2n__-prdslib.isType '"Bool",
                                        darkStyle = _js2n__-prdslib.always,
                                        data = _js2n__-prdslib.isType 'Record,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        jsonData =
                                          _js2n__-prdslib.isType '"String",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "header", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "size", "text", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        size =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.numbers.maximum
                                                  5,
                                                _js2n__-prdslib.numbers.minimum
                                                  1
                                              ],
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        text =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                              ],
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "color", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "divider", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        color =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "primary", "secondary" ]
                                              ],
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        height =
                                          _js2n__-prdslib.isType '"Number",
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "icon", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        crop = _js2n__-prdslib.isType '"Bool",
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        maxHeight =
                                          _js2n__-prdslib.isType '"Number",
                                        maxSize =
                                          _js2n__-prdslib.isType '"Number",
                                        maxWidth =
                                          _js2n__-prdslib.isType '"Number",
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        square = _js2n__-prdslib.isType '"Bool",
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "panel", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "items", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        icon = _js2n__-prdslib.isType '"String",
                                        iconPosition =
                                          _js2n__-refsenv."_js2n__-:definitions/iconPositionProp!predicate",
                                        innerStyle = _js2n__-prdslib.always,
                                        items =
                                          _js2n__-refsenv."_js2n__-:definitions/topLevelProperties/properties/items!predicate",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "image", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        accept =
                                          _js2n__-prdslib.isType '"String",
                                        confirm = _js2n__-prdslib.always,
                                        crop = _js2n__-prdslib.isType '"Bool",
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        filename =
                                          _js2n__-prdslib.isType '"String",
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        maxHeight =
                                          _js2n__-prdslib.isType '"Number",
                                        maxSize =
                                          _js2n__-prdslib.isType '"Number",
                                        maxWidth =
                                          _js2n__-prdslib.isType '"Number",
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        square = _js2n__-prdslib.isType '"Bool",
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "sendTo", } {}
                                  true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/sendToProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "password", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/passwordProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "file", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "filename", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        filename =
                                          _js2n__-prdslib.isType '"String",
                                        filter = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        sort = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        title = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "slider", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        max = _js2n__-prdslib.isType '"Number",
                                        md = _js2n__-prdslib.always,
                                        min = _js2n__-prdslib.isType '"Number",
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        step = _js2n__-prdslib.isType '"Number",
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "custom", } {}
                                  true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/customProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "checkbox", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/checkboxProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "fileSelector",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/fileSelectorProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.enum [ "number", "port" ],
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/numberProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "alive", } {}
                                  true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/aliveProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "autocomplete",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "options", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        freeSolo =
                                          _js2n__-prdslib.isType '"Bool",
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        options =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.isType
                                                        'Record
                                                    ])
                                              ],
                                        placeholder =
                                          _js2n__-prdslib.isType '"String",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "qrCode", } {}
                                  true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/qrCodeProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "cron", } {}
                                  true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/cronProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type =
                                      _js2n__-prdslib.const "deviceManager",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/deviceManagerProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "text", } {}
                                  true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/textProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "select", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        options =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "label", "value" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          hidden =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          label =
                                                            _js2n__-prdslib.always,
                                                          value =
                                                            _js2n__-prdslib.always,
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "table", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "items", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        allowAddByFilter =
                                          _js2n__-refsenv."_js2n__-:definitions/allowAddByFilterProp!predicate",
                                        clone = _js2n__-prdslib.isType '"Bool",
                                        compact =
                                          _js2n__-prdslib.isType '"Bool",
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        encryptedAttributes =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        export = _js2n__-prdslib.isType '"Bool",
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        "import" =
                                          _js2n__-prdslib.isType '"Bool",
                                        items =
                                          _js2n__-refsenv."_js2n__-:definitions/tableItems!predicate",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noDelete =
                                          _js2n__-prdslib.isType '"Bool",
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        showSecondAddAt =
                                          _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        uniqueColumns =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "pattern", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "pattern", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        copyToClipboard =
                                          _js2n__-prdslib.isType '"Bool",
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        pattern =
                                          _js2n__-prdslib.isType '"String",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "setState", }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "id", "type", "val" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        ack = _js2n__-prdslib.isType '"Bool",
                                        color =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "primary", "secondary" ]
                                              ],
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        error = _js2n__-prdslib.isType 'Record,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        icon = _js2n__-prdslib.isType '"String",
                                        id = _js2n__-prdslib.isType '"String",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        okText =
                                          _js2n__-prdslib.isType '"String",
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        val = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        variant =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "contained", "outlined" ]
                                              ],
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "func", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        short =
                                          _js2n__-prdslib.isType '"String",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "room", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        short =
                                          _js2n__-prdslib.isType '"String",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "user", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        short =
                                          _js2n__-prdslib.isType '"String",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "ip", } {} true
                                  _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        listenOnAllPorts =
                                          _js2n__-prdslib.isType '"Bool",
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noInternal =
                                          _js2n__-refsenv."_js2n__-:definitions/noInternalProp!predicate",
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        onlyIp4 =
                                          _js2n__-prdslib.isType '"Bool",
                                        onlyIp6 =
                                          _js2n__-prdslib.isType '"Bool",
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "certificate",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "certType", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        certType =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "public",
                                                    "private",
                                                    "chained"
                                                  ]
                                              ],
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "certificates",
                                  } {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/certificatesProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "staticLink", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/staticLinkProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "staticText", }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.oneOf
                                      [
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "text" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                        _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.records.required
                                              [ "label" ],
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ]
                                      ],
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        text =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                              ],
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "instance", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/instanceProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "staticImage",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        href = _js2n__-prdslib.isType '"String",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        src = _js2n__-prdslib.isType '"String",
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "chips", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required [ "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        delimiter =
                                          _js2n__-prdslib.isType '"String",
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "objectId", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/objectIdProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "checkLicense",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    darkStyle = _js2n__-prdslib.always,
                                    defaultSendTo = _js2n__-prdslib.always,
                                    disabled = _js2n__-prdslib.always,
                                    hidden = _js2n__-prdslib.always,
                                    hideOnlyControl = _js2n__-prdslib.always,
                                    label = _js2n__-prdslib.always,
                                    lg = _js2n__-prdslib.always,
                                    md = _js2n__-prdslib.always,
                                    newLine = _js2n__-prdslib.always,
                                    noMultiEdit = _js2n__-prdslib.always,
                                    noTranslation = _js2n__-prdslib.always,
                                    sm = _js2n__-prdslib.always,
                                    style = _js2n__-prdslib.always,
                                    type = _js2n__-prdslib.always,
                                    uuid = _js2n__-prdslib.isType '"Bool",
                                    version = _js2n__-prdslib.isType '"Bool",
                                    xs = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "datePicker", }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    darkStyle = _js2n__-prdslib.always,
                                    defaultSendTo = _js2n__-prdslib.always,
                                    disabled = _js2n__-prdslib.always,
                                    hidden = _js2n__-prdslib.always,
                                    hideOnlyControl = _js2n__-prdslib.always,
                                    label = _js2n__-prdslib.always,
                                    lg = _js2n__-prdslib.always,
                                    md = _js2n__-prdslib.always,
                                    newLine = _js2n__-prdslib.always,
                                    noMultiEdit = _js2n__-prdslib.always,
                                    noTranslation = _js2n__-prdslib.always,
                                    sm = _js2n__-prdslib.always,
                                    style = _js2n__-prdslib.always,
                                    type = _js2n__-prdslib.always,
                                    xs = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "timePicker", }
                                  {} true _js2n__-prdslib.always)
                                _js2n__-refsenv."_js2n__-:definitions/timePickerProps!predicate"
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "uuid", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    darkStyle = _js2n__-prdslib.always,
                                    defaultSendTo = _js2n__-prdslib.always,
                                    disabled = _js2n__-prdslib.always,
                                    hidden = _js2n__-prdslib.always,
                                    hideOnlyControl = _js2n__-prdslib.always,
                                    label = _js2n__-prdslib.always,
                                    lg = _js2n__-prdslib.always,
                                    md = _js2n__-prdslib.always,
                                    newLine = _js2n__-prdslib.always,
                                    noMultiEdit = _js2n__-prdslib.always,
                                    noTranslation = _js2n__-prdslib.always,
                                    sm = _js2n__-prdslib.always,
                                    style = _js2n__-prdslib.always,
                                    type = _js2n__-prdslib.always,
                                    xs = _js2n__-prdslib.always,
                                  } {} false _js2n__-prdslib.never)
                                _js2n__-prdslib.always,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "accordion", }
                                  {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "items", "type" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        clone = _js2n__-prdslib.isType '"Bool",
                                        confirm = _js2n__-prdslib.always,
                                        darkStyle = _js2n__-prdslib.always,
                                        "default" = _js2n__-prdslib.always,
                                        defaultFunc = _js2n__-prdslib.always,
                                        defaultSendTo = _js2n__-prdslib.always,
                                        disabled = _js2n__-prdslib.always,
                                        help = _js2n__-prdslib.always,
                                        helpLink = _js2n__-prdslib.always,
                                        hidden = _js2n__-prdslib.always,
                                        hideOnlyControl =
                                          _js2n__-prdslib.always,
                                        items =
                                          _js2n__-refsenv."_js2n__-:definitions/tableItems!predicate",
                                        label = _js2n__-prdslib.always,
                                        lg = _js2n__-prdslib.always,
                                        md = _js2n__-prdslib.always,
                                        newLine = _js2n__-prdslib.always,
                                        noDelete =
                                          _js2n__-prdslib.isType '"Bool",
                                        noMultiEdit = _js2n__-prdslib.always,
                                        noTranslation = _js2n__-prdslib.always,
                                        onChange = _js2n__-prdslib.always,
                                        showSecondAddAt =
                                          _js2n__-prdslib.always,
                                        sm = _js2n__-prdslib.always,
                                        style = _js2n__-prdslib.always,
                                        titleAttr =
                                          _js2n__-prdslib.isType '"String",
                                        tooltip = _js2n__-prdslib.always,
                                        type = _js2n__-prdslib.always,
                                        validator = _js2n__-prdslib.always,
                                        validatorErrorText =
                                          _js2n__-prdslib.always,
                                        validatorNoSaveOnError =
                                          _js2n__-prdslib.always,
                                        xs = _js2n__-prdslib.always,
                                      } {} false _js2n__-prdslib.never
                                  ]) _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.records.required [ "type" ],
                          _js2n__-prdslib.records.record
                            {
                              button = _js2n__-prdslib.isType '"Bool",
                              confirm =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          alsoDependsOn =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
                                          cancel =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                ],
                                          condition =
                                            _js2n__-prdslib.isType '"String",
                                          ok =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                ],
                                          text =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                ],
                                          title =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                ],
                                          type =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "info",
                                                      "warning",
                                                      "error",
                                                      "none"
                                                    ]
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              darkStyle = _js2n__-prdslib.isType '"String",
                              "default" = _js2n__-prdslib.always,
                              defaultFunc =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              alsoDependsOn =
                                                _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                              func =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                              defaultSendTo = _js2n__-prdslib.isType '"String",
                              disabled = _js2n__-prdslib.isType '"String",
                              doNotSave =
                                _js2n__-refsenv."_js2n__-:definitions/doNotSaveProp!predicate",
                              help =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                    ],
                              helpLink = _js2n__-prdslib.isType '"String",
                              hidden = _js2n__-prdslib.isType '"String",
                              hideOnlyControl = _js2n__-prdslib.isType '"Bool",
                              innerStyle = _js2n__-prdslib.isType 'Record,
                              label =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                    ],
                              lg = _js2n__-prdslib.isType '"Number",
                              maxLength = _js2n__-prdslib.isType '"Number",
                              md = _js2n__-prdslib.isType '"Number",
                              newLine = _js2n__-prdslib.isType '"Bool",
                              noMultiEdit = _js2n__-prdslib.isType '"Bool",
                              noTranslation = _js2n__-prdslib.isType '"Bool",
                              onChange =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          alsoDependsOn =
                                            _js2n__-refsenv."_js2n__-:definitions/alsoDependsOnSendProp!predicate",
                                          calculateFunc =
                                            _js2n__-prdslib.isType '"String",
                                          ignoreOwnChanges =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              showSecondAddAt =
                                _js2n__-prdslib.isType '"Number",
                              sm = _js2n__-prdslib.isType '"Number",
                              style = _js2n__-prdslib.isType 'Record,
                              tooltip = _js2n__-prdslib.isType '"String",
                              type =
                                _js2n__-refsenv."_js2n__-:definitions/componentType!predicate",
                              validator = _js2n__-prdslib.isType '"String",
                              validatorErrorText =
                                _js2n__-prdslib.isType '"String",
                              validatorNoSaveOnError =
                                _js2n__-prdslib.isType '"Bool",
                              xs = _js2n__-prdslib.isType '"Number",
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.ifThenElse
        (_js2n__-prdslib.records.record { type = _js2n__-prdslib.const "tabs", }
          {} true _js2n__-prdslib.always)
        (_js2n__-prdslib.allOf
          [
            _js2n__-prdslib.isType 'Record,
            _js2n__-prdslib.allOf
              [
                _js2n__-refsenv."_js2n__-:definitions/topLevelProperties!predicate",
                _js2n__-prdslib.records.record
                  {
                    iconPosition =
                      _js2n__-refsenv."_js2n__-:definitions/iconPositionProp!predicate",
                  } {} true _js2n__-prdslib.always
              ],
            _js2n__-prdslib.records.required [ "type" ],
            _js2n__-prdslib.records.record
              {
                "$schema" = _js2n__-prdslib.always,
                i18n = _js2n__-prdslib.always,
                iconPosition = _js2n__-prdslib.always,
                items = _js2n__-prdslib.always,
                type = _js2n__-prdslib.always,
              } {} false _js2n__-prdslib.never
          ])
        (_js2n__-prdslib.allOf
          [
            _js2n__-prdslib.isType 'Record,
            _js2n__-prdslib.records.required [ "type" ],
            _js2n__-prdslib.records.record
              {
                "$schema" = _js2n__-prdslib.always,
                i18n = _js2n__-prdslib.always,
                items = _js2n__-prdslib.always,
                type = _js2n__-prdslib.always,
              } {} false _js2n__-prdslib.never,
            _js2n__-refsenv."_js2n__-:definitions/topLevelProperties!predicate"
          ]))