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
      "_js2n__-:definitions/disallowNodeProcessParams!predicate" =
        _js2n__-prdslib.not
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.records.required [ "nodeProcessParams" ],
                _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
              ]),
      "_js2n__-:definitions/iobrokerObject!contract" =
        { _id | String, common | {  .. } | optional, type | String, .. },
      "_js2n__-:definitions/isCompactTrue!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.records.required [ "compact" ],
              _js2n__-prdslib.records.record
                { compact = _js2n__-prdslib.const true, } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/license!predicate"
        | doc "The license this software is published under."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum
                [
                  "BSD-4.3TAHOE",
                  "AML-glslang",
                  "TCL",
                  "LGPL-3.0-only",
                  "OAR",
                  "OLDAP-2.8",
                  "GFDL-1.2-invariants-or-later",
                  "ODC-By-1.0",
                  "HPND-Markus-Kuhn",
                  "TCP-wrappers",
                  "Xdebug-1.03",
                  "OFL-1.0-RFN",
                  "GPL-1.0-only",
                  "AML",
                  "BSD-3-Clause-Attribution",
                  "DEC-3-Clause",
                  "DRL-1.0",
                  "SSPL-1.0",
                  "LPPL-1.3a",
                  "CC-BY-3.0-IGO",
                  "CC-BY-SA-3.0-IGO",
                  "BSD-3-Clause-No-Nuclear-License",
                  "BSD-Source-Code",
                  "OFL-1.0-no-RFN",
                  "LGPL-2.1-or-later",
                  "bcrypt-Solar-Designer",
                  "MPL-1.0",
                  "SHL-0.51",
                  "BSD-3-Clause-No-Military-License",
                  "CC-BY-SA-3.0-AT",
                  "CERN-OHL-1.1",
                  "HPND-export2-US",
                  "NIST-PD-fallback",
                  "SCEA",
                  "FSFAP",
                  "CC-BY-1.0",
                  "CECILL-1.1",
                  "APSL-1.0",
                  "LiLiQ-Rplus-1.1",
                  "NBPL-1.0",
                  "SugarCRM-1.1.3",
                  "LiLiQ-P-1.1",
                  "Nokia",
                  "Catharon",
                  "Unicode-3.0",
                  "GFDL-1.1-no-invariants-only",
                  "Barr",
                  "FDK-AAC",
                  "Rdisc",
                  "ZPL-2.0",
                  "RPL-1.5",
                  "MIT-feh",
                  "PolyForm-Noncommercial-1.0.0",
                  "PSF-2.0",
                  "CC-BY-ND-1.0",
                  "SunPro",
                  "CC-BY-NC-ND-2.5",
                  "Mackerras-3-Clause",
                  "BlueOak-1.0.0",
                  "TORQUE-1.1",
                  "Eurosym",
                  "JSON",
                  "ClArtistic",
                  "ICU",
                  "LPL-1.02",
                  "CC0-1.0",
                  "NLPL",
                  "AFL-1.2",
                  "CECILL-2.0",
                  "LiLiQ-R-1.1",
                  "TPDL",
                  "NIST-Software",
                  "GFDL-1.2-no-invariants-only",
                  "UCAR",
                  "OLDAP-2.0.1",
                  "mpi-permissive",
                  "hdparm",
                  "CERN-OHL-W-2.0",
                  "JPNIC",
                  "CC-BY-NC-ND-3.0-DE",
                  "Glulxe",
                  "Linux-man-pages-copyleft-2-para",
                  "TTWL",
                  "EFL-2.0",
                  "Xfig",
                  "swrule",
                  "OPL-1.0",
                  "CC-BY-NC-2.0",
                  "OLDAP-2.4",
                  "IPA",
                  "CERN-OHL-1.2",
                  "CFITSIO",
                  "BSD-Source-beginning-file",
                  "GFDL-1.1-invariants-or-later",
                  "RHeCos-1.1",
                  "dvipdfm",
                  "TGPPL-1.0",
                  "IBM-pibs",
                  "Leptonica",
                  "NAIST-2003",
                  "AGPL-3.0-or-later",
                  "CC-BY-NC-SA-2.5",
                  "MulanPSL-1.0",
                  "Jam",
                  "Saxpath",
                  "gnuplot",
                  "CMU-Mach-nodoc",
                  "X11-distribute-modifications-variant",
                  "PADL",
                  "LPPL-1.1",
                  "GCR-docs",
                  "CC-BY-NC-SA-2.0-FR",
                  "BSD-4-Clause-UC",
                  "HPND-UC-export-US",
                  "copyleft-next-0.3.1",
                  "EPICS",
                  "any-OSI",
                  "VOSTROM",
                  "AGPL-3.0-only",
                  "ECL-1.0",
                  "HPND-sell-MIT-disclaimer-xserver",
                  "NOSL",
                  "NASA-1.3",
                  "Naumen",
                  "CC-BY-2.5",
                  "CDDL-1.1",
                  "Arphic-1999",
                  "Dotseqn",
                  "GPL-3.0-only",
                  "HTMLTIDY",
                  "CPL-1.0",
                  "APAFML",
                  "MTLL",
                  "OSL-2.1",
                  "Spencer-99",
                  "xkeyboard-config-Zinoviev",
                  "Plexus",
                  "OLFL-1.3",
                  "Beerware",
                  "APSL-2.0",
                  "HPND-Fenneberg-Livingston",
                  "Elastic-2.0",
                  "SMLNJ",
                  "AMDPLPA",
                  "CC-BY-NC-SA-3.0-DE",
                  "OGL-UK-3.0",
                  "Unicode-DFS-2016",
                  "NCL",
                  "D-FSL-1.0",
                  "CC-BY-SA-4.0",
                  "W3C-19980720",
                  "MITNFA",
                  "pnmstitch",
                  "TU-Berlin-1.0",
                  "HPND-sell-variant-MIT-disclaimer",
                  "snprintf",
                  "OSL-1.0",
                  "HPND-doc-sell",
                  "GPL-2.0-or-later",
                  "LAL-1.2",
                  "OGC-1.0",
                  "CC-BY-NC-1.0",
                  "Aladdin",
                  "Imlib2",
                  "CC-BY-NC-SA-1.0",
                  "BSD-Attribution-HPND-disclaimer",
                  "Giftware",
                  "CC-BY-ND-3.0",
                  "CC-BY-SA-2.0",
                  "FBM",
                  "WTFPL",
                  "LGPL-2.1-only",
                  "BSD-Systemics",
                  "mailprio",
                  "OLDAP-1.1",
                  "FreeImage",
                  "Sleepycat",
                  "MirOS",
                  "CC-BY-NC-SA-2.0-DE",
                  "HPND-MIT-disclaimer",
                  "Libpng",
                  "AFL-2.0",
                  "CC-BY-NC-4.0",
                  "Glide",
                  "GLWTPL",
                  "O-UDA-1.0",
                  "CATOSL-1.1",
                  "ANTLR-PD-fallback",
                  "HPND-Intel",
                  "LPL-1.0",
                  "FSFULLRWD",
                  "CERN-OHL-P-2.0",
                  "CC-BY-NC-3.0",
                  "3D-Slicer-1.0",
                  "Python-2.0.1",
                  "w3m",
                  "X11",
                  "Pixar",
                  "RPL-1.1",
                  "MakeIndex",
                  "GFDL-1.3-no-invariants-or-later",
                  "OLDAP-2.0",
                  "Zlib",
                  "BSD-3-Clause-HP",
                  "BSD-3-Clause-flex",
                  "Parity-7.0.0",
                  "CC-BY-NC-ND-3.0",
                  "HPND-export-US",
                  "LPPL-1.0",
                  "BSD-3-Clause",
                  "CAL-1.0-Combined-Work-Exception",
                  "Zeeff",
                  "CECILL-1.0",
                  "OLDAP-2.7",
                  "AMD-newlib",
                  "Ruby",
                  "OLDAP-1.3",
                  "DL-DE-BY-2.0",
                  "Kastrup",
                  "EUPL-1.0",
                  "EUDatagrid",
                  "OLDAP-1.2",
                  "NRL",
                  "BSD-2-Clause-Darwin",
                  "Kazlib",
                  "Net-SNMP",
                  "RSCPL",
                  "Xnet",
                  "gtkbook",
                  "OFFIS",
                  "CC-BY-3.0-DE",
                  "LPPL-1.3c",
                  "CC-BY-2.0",
                  "TAPR-OHL-1.0",
                  "ODbL-1.0",
                  "LZMA-SDK-9.22",
                  "BSD-2-Clause-first-lines",
                  "Parity-6.0.0",
                  "Sendmail-8.23",
                  "OFL-1.1",
                  "MIT-Khronos-old",
                  "SMPPL",
                  "Condor-1.1",
                  "BSD-4-Clause-Shortened",
                  "CC-BY-NC-2.5",
                  "GFDL-1.3-no-invariants-only",
                  "OLDAP-1.4",
                  "TermReadKey",
                  "libpng-2.0",
                  "Frameworx-1.0",
                  "psutils",
                  "eGenix",
                  "LGPL-3.0-or-later",
                  "MPL-2.0",
                  "BSD-2-Clause",
                  "CC-BY-4.0",
                  "EUPL-1.1",
                  "TOSL",
                  "SISSL",
                  "Info-ZIP",
                  "CECILL-C",
                  "checkmk",
                  "GFDL-1.1-no-invariants-or-later",
                  "Sendmail",
                  "NGPL",
                  "CC-BY-ND-2.5",
                  "HP-1986",
                  "DRL-1.1",
                  "GFDL-1.2-no-invariants-or-later",
                  "SPL-1.0",
                  "HPND",
                  "CDDL-1.0",
                  "MIT-open-group",
                  "W3C",
                  "Python-2.0",
                  "COIL-1.0",
                  "BitTorrent-1.1",
                  "GFDL-1.3-invariants-only",
                  "Knuth-CTAN",
                  "GD",
                  "diffmark",
                  "MIT-advertising",
                  "ssh-keyscan",
                  "CC-BY-NC-SA-3.0-IGO",
                  "CC-BY-NC-ND-4.0",
                  "Adobe-Glyph",
                  "BSD-4.3RENO",
                  "Hippocratic-2.1",
                  "OSL-3.0",
                  "SAX-PD",
                  "CC-BY-3.0",
                  "OpenSSL",
                  "Zimbra-1.4",
                  "Wsuipa",
                  "cve-tou",
                  "GFDL-1.1-invariants-only",
                  "OCLC-2.0",
                  "NIST-PD",
                  "Sun-PPP-2000",
                  "NICTA-1.0",
                  "xpp",
                  "Apache-1.1",
                  "OpenPBS-2.3",
                  "CPAL-1.0",
                  "OLDAP-2.2",
                  "MIT-Festival",
                  "GFDL-1.2-or-later",
                  "CDLA-Permissive-2.0",
                  "NCGL-UK-2.0",
                  "Artistic-1.0-cl8",
                  "Boehm-GC",
                  "CC-BY-NC-SA-3.0",
                  "CC-BY-3.0-AT",
                  "CC-BY-SA-3.0-DE",
                  "Qhull",
                  "iMatix",
                  "CC-BY-ND-4.0",
                  "OPUBL-1.0",
                  "ASWF-Digital-Assets-1.0",
                  "IPL-1.0",
                  "FreeBSD-DOC",
                  "AGPL-1.0-only",
                  "EFL-1.0",
                  "SGP4",
                  "Linux-man-pages-copyleft-var",
                  "SHL-0.5",
                  "Linux-man-pages-1-para",
                  "Crossword",
                  "DL-DE-ZERO-2.0",
                  "CC-BY-3.0-AU",
                  "MS-RL",
                  "HPND-sell-variant",
                  "Afmparse",
                  "NPL-1.0",
                  "BSD-3-Clause-Clear",
                  "zlib-acknowledgement",
                  "CC-PDDC",
                  "BSD-Systemics-W3Works",
                  "CC-BY-NC-SA-4.0",
                  "ZPL-2.1",
                  "CECILL-B",
                  "Artistic-2.0",
                  "xlock",
                  "dtoa",
                  "IEC-Code-Components-EULA",
                  "OLDAP-2.1",
                  "ECL-2.0",
                  "NCBI-PD",
                  "JPL-image",
                  "BSD-3-Clause-Modification",
                  "CC-BY-NC-ND-1.0",
                  "LGPL-2.0-or-later",
                  "OGTSL",
                  "Soundex",
                  "AFL-3.0",
                  "CERN-OHL-S-2.0",
                  "Vim",
                  "BitTorrent-1.0",
                  "OML",
                  "BSD-3-Clause-Open-MPI",
                  "Cronyx",
                  "Spencer-94",
                  "Zimbra-1.3",
                  "Furuseth",
                  "OLDAP-2.3",
                  "AdaCore-doc",
                  "AFL-2.1",
                  "OLDAP-2.2.2",
                  "Sun-PPP",
                  "HPND-UC",
                  "CC-BY-SA-2.0-UK",
                  "Artistic-1.0",
                  "pkgconf",
                  "GPL-3.0-or-later",
                  "HPND-doc",
                  "libtiff",
                  "CECILL-2.1",
                  "MIT-0",
                  "bzip2-1.0.6",
                  "DOC",
                  "threeparttable",
                  "Lucida-Bitmap-Fonts",
                  "libutil-David-Nugent",
                  "BSD-Inferno-Nettverk",
                  "BSD-3-Clause-No-Nuclear-Warranty",
                  "BSD-Protection",
                  "Cube",
                  "SGI-B-2.0",
                  "AAL",
                  "EPL-2.0",
                  "BSD-3-Clause-acpica",
                  "Brian-Gladman-3-Clause",
                  "CMU-Mach",
                  "Unlicense",
                  "Newsletr",
                  "QPL-1.0",
                  "Symlinks",
                  "CC-BY-NC-SA-2.0-UK",
                  "CC-BY-NC-ND-2.0",
                  "MPEG-SSG",
                  "NPL-1.1",
                  "AMPAS",
                  "copyleft-next-0.3.0",
                  "FSFULLR",
                  "BSD-Advertising-Acknowledgement",
                  "MIT-Modern-Variant",
                  "SchemeReport",
                  "OLDAP-2.2.1",
                  "MIT-testregex",
                  "HPND-Kevlin-Henney",
                  "CC-BY-NC-3.0-DE",
                  "LZMA-SDK-9.11-to-9.20",
                  "Adobe-Display-PostScript",
                  "C-UDA-1.0",
                  "radvd",
                  "GL2PS",
                  "LPPL-1.2",
                  "Baekmuk",
                  "metamail",
                  "FTL",
                  "Latex2e",
                  "Mup",
                  "Gutmann",
                  "URT-RLE",
                  "SimPL-2.0",
                  "CDLA-Sharing-1.0",
                  "python-ldap",
                  "ASWF-Digital-Assets-1.1",
                  "GFDL-1.3-or-later",
                  "Clips",
                  "TTYP0",
                  "W3C-20150513",
                  "CC-BY-SA-1.0",
                  "FSFUL",
                  "MPL-2.0-no-copyleft-exception",
                  "SGI-B-1.1",
                  "Brian-Gladman-2-Clause",
                  "MIT-Wu",
                  "NTP-0",
                  "CC-BY-SA-2.5",
                  "UnixCrypt",
                  "ADSL",
                  "OGL-Canada-2.0",
                  "xinetd",
                  "ErlPL-1.1",
                  "OGL-UK-2.0",
                  "OGDL-Taiwan-1.0",
                  "blessing",
                  "App-s2p",
                  "CC-BY-SA-2.1-JP",
                  "Spencer-86",
                  "YPL-1.1",
                  "MMIXware",
                  "OFL-1.0",
                  "SGI-B-1.0",
                  "LGPLLR",
                  "ImageMagick",
                  "CPOL-1.02",
                  "OPL-UK-3.0",
                  "Zend-2.0",
                  "mpich2",
                  "NLOD-2.0",
                  "CC-BY-NC-SA-2.0",
                  "DSDP",
                  "QPL-1.0-INRIA-2004",
                  "JasPer-2.0",
                  "ISC",
                  "OGL-UK-1.0",
                  "MulanPSL-2.0",
                  "YPL-1.0",
                  "McPhee-slideshow",
                  "PDDL-1.0",
                  "Bahyph",
                  "GFDL-1.2-invariants-only",
                  "RSA-MD",
                  "GFDL-1.3-invariants-or-later",
                  "HPND-export-US-modify",
                  "MS-PL",
                  "EPL-1.0",
                  "CC-BY-3.0-NL",
                  "SISSL-1.2",
                  "NetCDF",
                  "CNRI-Python-GPL-Compatible",
                  "UMich-Merit",
                  "SSH-OpenSSH",
                  "OFL-1.1-RFN",
                  "TPL-1.0",
                  "CNRI-Jython",
                  "VSL-1.0",
                  "UPL-1.0",
                  "Minpack",
                  "ISC-Veillard",
                  "BSL-1.0",
                  "APL-1.0",
                  "magaz",
                  "OSET-PL-2.1",
                  "SNIA",
                  "LGPL-2.0-only",
                  "check-cvs",
                  "LPD-document",
                  "softSurfer",
                  "CC-BY-ND-3.0-DE",
                  "Abstyles",
                  "AGPL-1.0-or-later",
                  "MS-LPL",
                  "fwlw",
                  "xzoom",
                  "OSL-2.0",
                  "Adobe-Utopia",
                  "Watcom-1.0",
                  "Noweb",
                  "Martin-Birgmeier",
                  "FSFAP-no-warranty-disclaimer",
                  "0BSD",
                  "PHP-3.01",
                  "TMate",
                  "HPND-merchantability-variant",
                  "mplus",
                  "BSD-3-Clause-No-Nuclear-License-2014",
                  "XSkat",
                  "ZPL-1.1",
                  "Entessa",
                  "NTP",
                  "Widget-Workshop",
                  "BUSL-1.1",
                  "OFL-1.1-no-RFN",
                  "CDLA-Permissive-1.0",
                  "Borceux",
                  "CUA-OPL-1.0",
                  "BSD-3-Clause-Sun",
                  "psfrag",
                  "libselinux-1.0",
                  "NCSA",
                  "Adobe-2006",
                  "EUPL-1.2",
                  "Bitstream-Charter",
                  "SAX-PD-2.0",
                  "XFree86-1.1",
                  "SSH-short",
                  "Apache-2.0",
                  "NLOD-1.0",
                  "ulem",
                  "BSD-1-Clause",
                  "OLDAP-2.6",
                  "CC-BY-3.0-US",
                  "Fair",
                  "Intel-ACPI",
                  "Inner-Net-2.0",
                  "Multics",
                  "Graphics-Gems",
                  "MIT-CMU",
                  "ANTLR-PD",
                  "HPND-DEC",
                  "NPOSL-3.0",
                  "PPL",
                  "Bitstream-Vera",
                  "APSL-1.1",
                  "CC-BY-2.5-AU",
                  "PHP-3.0",
                  "Caldera-no-preamble",
                  "OSL-1.1",
                  "CC-BY-NC-ND-3.0-IGO",
                  "OpenVision",
                  "Linux-man-pages-copyleft",
                  "SSLeay-standalone",
                  "CDL-1.0",
                  "CrystalStacker",
                  "PolyForm-Small-Business-1.0.0",
                  "Xerox",
                  "OCCT-PL",
                  "BSD-3-Clause-LBNL",
                  "Mackerras-3-Clause-acknowledgment",
                  "Zed",
                  "LAL-1.3",
                  "AFL-1.1",
                  "OpenSSL-standalone",
                  "HPND-Pbmplus",
                  "curl",
                  "lsof",
                  "Unicode-TOU",
                  "LOOP",
                  "MIT",
                  "HPND-sell-variant-MIT-disclaimer-rev",
                  "HPND-export-US-acknowledgement",
                  "CNRI-Python",
                  "BSD-2-Clause-Patent",
                  "Linux-OpenIB",
                  "HPND-INRIA-IMAG",
                  "IJG-short",
                  "Apache-1.0",
                  "Ferguson-Twofish",
                  "GPL-2.0-only",
                  "MPL-1.1",
                  "Latex2e-translated-notice",
                  "CC-BY-SA-3.0",
                  "Caldera",
                  "Intel",
                  "TU-Berlin-2.0",
                  "HaskellReport",
                  "GFDL-1.1-only",
                  "Motosoto",
                  "APSL-1.2",
                  "SGI-OpenGL",
                  "Community-Spec-1.0",
                  "Cornell-Lossless-JPEG",
                  "HPND-sell-regexpr",
                  "GFDL-1.3-only",
                  "etalab-2.0",
                  "RPSL-1.0",
                  "MIT-enna",
                  "HP-1989",
                  "CC-BY-ND-2.0",
                  "IJG",
                  "GPL-1.0-or-later",
                  "PostgreSQL",
                  "GFDL-1.1-or-later",
                  "SL",
                  "UCL-1.0",
                  "Unicode-DFS-2015",
                  "GFDL-1.2-only",
                  "SWL",
                  "BSD-4-Clause",
                  "OLDAP-2.5",
                  "Artistic-1.0-Perl",
                  "CAL-1.0",
                  "Interbase-1.0",
                  "gSOAP-1.3b",
                  "BSD-2-Clause-Views"
                ]
            ],
      "_js2n__-:definitions/multilingual!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.records.required [ "en" ],
                _js2n__-prdslib.records.record {}
                  {
                    "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" =
                      _js2n__-prdslib.isType '"String",
                  } false _js2n__-prdslib.never
              ]),
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
    }
    in
  {
      "$schema" | String | doc "JSON schema for validation" | optional,
      common
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.ifThenElse
                _js2n__-refsenv."_js2n__-:definitions/isCompactTrue!predicate"
                _js2n__-refsenv."_js2n__-:definitions/disallowNodeProcessParams!predicate"
                _js2n__-prdslib.always,
              _js2n__-prdslib.records.required
                [
                  "desc",
                  "licenseInformation",
                  "mode",
                  "name",
                  "news",
                  "platform",
                  "tier",
                  "titleLang",
                  "version"
                ],
              _js2n__-prdslib.records.record
                {
                  adminColumns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "align", "name", "path", "width" ],
                                _js2n__-prdslib.records.record
                                  {
                                    align =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.enum
                                              [
                                                "left",
                                                "right",
                                                "center",
                                                "justify"
                                              ]
                                          ],
                                    edit = _js2n__-prdslib.isType '"Bool",
                                    name =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                          ],
                                    objTypes =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    path = _js2n__-prdslib.isType '"String",
                                    type = _js2n__-prdslib.isType '"String",
                                    width =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.numbers.minimum 0
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  adminTab =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required
                            [ "fa-icon", "link", "name" ],
                          _js2n__-prdslib.records.record
                            {
                              fa-icon = _js2n__-prdslib.isType '"String",
                              ignoreConfigUpdate =
                                _js2n__-prdslib.isType '"Bool",
                              link = _js2n__-prdslib.isType '"String",
                              name =
                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                              singleton = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                  adminUI =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "config" ],
                          _js2n__-prdslib.records.record
                            {
                              config =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "html",
                                          "json",
                                          "materialize",
                                          "none"
                                        ]
                                    ],
                              custom =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.const "json"
                                    ],
                              tab =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [ "html", "materialize" ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  allowInit = _js2n__-prdslib.isType '"Bool",
                  authors =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required [ "name" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        email =
                                          _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  automaticUpgrade =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "none", "patch", "minor", "major" ]
                        ],
                  availableModes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum
                                  [
                                    "none",
                                    "daemon",
                                    "schedule",
                                    "once",
                                    "extension"
                                  ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1
                        ],
                  blockedVersions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  blockly = _js2n__-prdslib.isType '"Bool",
                  compact = _js2n__-prdslib.isType '"Bool",
                  connectionType =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "none", "local", "cloud" ]
                        ],
                  controller = _js2n__-prdslib.isType '"Bool",
                  dataFolder = _js2n__-prdslib.isType '"String",
                  dataSource =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "none", "poll", "push", "assumption" ]
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  desc =
                    _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                  docs =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.required [ "en" ],
                          _js2n__-prdslib.records.record {}
                            {
                              "en|de|ru|pt|nl|fr|it|es|pl|uk|zh-cn" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Array"
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String"),
                                      _js2n__-prdslib.arrays.minItems 1
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                  enabled = _js2n__-prdslib.isType '"Bool",
                  eraseOnUpload = _js2n__-prdslib.isType '"Bool",
                  extIcon = _js2n__-prdslib.isType '"String",
                  getHistory = _js2n__-prdslib.isType '"Bool",
                  globalDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  icon = _js2n__-prdslib.isType '"String",
                  install = _js2n__-prdslib.isType '"Bool",
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  license =
                    _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                  licenseInformation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              {
                                type =
                                  _js2n__-prdslib.enum
                                      [ "paid", "commercial", "limited" ],
                              } {} true _js2n__-prdslib.always)
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "link" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ]) _js2n__-prdslib.always,
                          _js2n__-prdslib.records.required [ "type" ],
                          _js2n__-prdslib.records.record
                            {
                              license =
                                _js2n__-refsenv."_js2n__-:definitions/license!predicate",
                              link =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.strings.pattern
                                        "^https://.+$"
                                    ],
                              type =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum
                                        [
                                          "free",
                                          "paid",
                                          "commercial",
                                          "limited"
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  localLinks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.records.required
                                            [ "link" ],
                                          _js2n__-prdslib.records.record
                                            {
                                              cloud =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              color =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              description =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                    ],
                                              icon =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              intro =
                                                _js2n__-prdslib.isType '"Bool",
                                              link =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              name =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate"
                                                    ],
                                              order =
                                                _js2n__-prdslib.isType
                                                    '"Number",
                                              pro =
                                                _js2n__-prdslib.anyOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"Bool",
                                                      _js2n__-prdslib.isType
                                                        '"String"
                                                    ],
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  logTransporter = _js2n__-prdslib.isType '"Bool",
                  loglevel =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [ "silly", "debug", "info", "warn", "error" ]
                        ],
                  main = _js2n__-prdslib.isType '"String",
                  materialize = _js2n__-prdslib.isType '"Bool",
                  materializeTab = _js2n__-prdslib.isType '"Bool",
                  messagebox = _js2n__-prdslib.isType '"Bool",
                  messages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "buttons", "text", "title" ],
                                _js2n__-prdslib.records.record
                                  {
                                    buttons =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.enum
                                                [ "ok", "agree", "cancel" ])
                                          ],
                                    condition =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                operand =
                                                  _js2n__-prdslib.enum
                                                      [ "or", "and" ],
                                                rules =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                              } {} false _js2n__-prdslib.never
                                          ],
                                    level =
                                      _js2n__-prdslib.enum
                                          [ "info", "warn", "error" ],
                                    link = _js2n__-prdslib.isType '"String",
                                    linkText =
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                    text =
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                    title =
                                      _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  mode =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "none",
                              "daemon",
                              "schedule",
                              "once",
                              "extension"
                            ]
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(?![i|I][o|O][b|B][r|R][o|O][k|K][e|E][r|R])"
                        ],
                  news =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.maxProperties 20,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {}
                            {
                              "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$" =
                                _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                            } false _js2n__-prdslib.never
                        ],
                  noConfig = _js2n__-prdslib.isType '"Bool",
                  noIntro = _js2n__-prdslib.isType '"Bool",
                  noRepository = _js2n__-prdslib.isType '"Bool",
                  nodeProcessParams =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  nogit = _js2n__-prdslib.isType '"Bool",
                  nondeletable = _js2n__-prdslib.isType '"Bool",
                  onlyWWW = _js2n__-prdslib.isType '"Bool",
                  os =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [ "linux", "darwin", "win32" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.enum
                                      [ "linux", "darwin", "win32" ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1
                            ]
                        ],
                  osDependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              "linux|darwin|win32" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                  platform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "Javascript/Node.js" ]
                        ],
                  plugins = _js2n__-prdslib.isType 'Record,
                  preserveSettings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Array"
                            ],
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  readme = _js2n__-prdslib.isType '"String",
                  restartAdapters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  restartSchedule = _js2n__-prdslib.isType '"String",
                  schedule = _js2n__-prdslib.isType '"String",
                  serviceStates =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"String"
                        ],
                  singleton = _js2n__-prdslib.isType '"Bool",
                  singletonHost = _js2n__-prdslib.isType '"Bool",
                  stopBeforeUpdate = _js2n__-prdslib.isType '"Bool",
                  stopTimeout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.multipleOf 1,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  subscribable = _js2n__-prdslib.isType '"Bool",
                  supportCustoms = _js2n__-prdslib.isType '"Bool",
                  supportStopInstance =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.numbers.multipleOf 1,
                              _js2n__-prdslib.numbers.minimum 1000
                            ]
                        ],
                  supportedMessages =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              custom = _js2n__-prdslib.isType '"Bool",
                              deviceManager = _js2n__-prdslib.isType '"Bool",
                              getHistory = _js2n__-prdslib.isType '"Bool",
                              notifications = _js2n__-prdslib.isType '"Bool",
                              stopInstance =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.numbers.multipleOf 1,
                                          _js2n__-prdslib.numbers.minimum 1000
                                        ]
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  tier =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.maximum 3,
                          _js2n__-prdslib.numbers.minimum 1
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  titleLang =
                    _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum
                            [
                              "alarm",
                              "climate-control",
                              "communication",
                              "date-and-time",
                              "energy",
                              "metering",
                              "garden",
                              "general",
                              "geoposition",
                              "hardware",
                              "health",
                              "household",
                              "infrastructure",
                              "iot-systems",
                              "lighting",
                              "logic",
                              "messaging",
                              "misc-data",
                              "multimedia",
                              "network",
                              "protocols",
                              "storage",
                              "utility",
                              "vehicle",
                              "visualization",
                              "visualization-icons",
                              "visualization-widgets",
                              "weather"
                            ]
                        ],
                  unsafePerm = _js2n__-prdslib.isType '"Bool",
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
                        ],
                  visWidgets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.minProperties 1,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "components", "i18n", "url" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          components =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String"),
                                                  _js2n__-prdslib.arrays.minItems
                                                    1
                                                ],
                                          i18n =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.const true,
                                                  _js2n__-prdslib.const
                                                    "component",
                                                  _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {}
                                                        {
                                                          ".+" =
                                                            _js2n__-refsenv."_js2n__-:definitions/multilingual!predicate",
                                                        } true
                                                        _js2n__-prdslib.always
                                                    ]
                                                ],
                                          ignoreInVersions =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Number",
                                                        _js2n__-prdslib.numbers.multipleOf
                                                          1
                                                      ])
                                                ],
                                          url =
                                            _js2n__-prdslib.isType '"String",
                                        } {} true _js2n__-prdslib.always
                                    ],
                            } true _js2n__-prdslib.always
                        ],
                  webByVersion = _js2n__-prdslib.isType '"Bool",
                  webExtendable = _js2n__-prdslib.isType '"Bool",
                  webExtension = _js2n__-prdslib.isType '"String",
                  webPreSettings = _js2n__-prdslib.isType 'Record,
                  webservers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  welcomeScreen =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ])
                        ],
                  welcomeScreenPro =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType 'Record
                              ])
                        ],
                  wwwDontUpload = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ])
        | doc "Contains all common instance attributes",
      encryptedNative
        | Array (String)
        | doc "Array of config attributes which will be automatically encrypted when stored via Admin configuration page and automatically decrypted at adapter runtime, e.g. [\"password\", \"token\"]"
        | optional,
      instanceObjects
        | Array _js2n__-refsenv."_js2n__-:definitions/iobrokerObject!contract"
        | doc "Objects which will be created for each instance"
        | optional,
      native
        | {  .. }
        | doc "Predefined attributes which are accessible in index_m.html and at runtime via adapter.config.<attribute>, e.g. {\"port\": 1234, \"password\": \"secret\"}"
        | optional,
      notifications
        | Array
          {
            categories
              | Array
                {
                  category | String,
                  description
                    | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract",
                  limit
                    | Number
                    | doc "Maximum amount of notifications to collect of this type",
                  name
                    | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract",
                  regex | Array (String),
                  severity
                    | std.enum.TagOrString
                    | [| 'alert, 'notify, 'info |]
                    | doc "`info` will only be shown by admin, while `notify` might also be used by messaging adapters, `alert` ensures both",
                },
            description
              | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract"
              | doc "Description which will be shown to the user",
            name
              | _js2n__-refsenv."_js2n__-:definitions/multilingual!contract"
              | doc "Name which will be shown to the user",
            scope | String,
          }
        | doc "Register notifications for the built-in notification system"
        | optional,
      objects
        | Array _js2n__-refsenv."_js2n__-:definitions/iobrokerObject!contract"
        | doc "Objects which will be created for the adapter"
        | optional,
      protectedNative
        | Array (String)
        | doc "Array of config attributes which will only be accessible by the own adapter, e.g. [\"password\"]"
        | optional,
    }