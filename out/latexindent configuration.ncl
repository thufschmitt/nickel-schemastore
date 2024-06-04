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
    = {}
    in
  {
      backupExtension
        | String
        | doc "when the -w, --overwrite switch is active, a back-up file is created with this extension"
        | optional,
      commandCodeBlocks
        | {
          commandNameSpecial
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.isType '"Array"
                    ],
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType 'Record
                          ],
                        _js2n__-prdslib.records.record
                          {
                            amalgamate =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.enum [ 0, 1 ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "there are some particular commands that need individual attention"
            | optional,
          roundParenthesesAllowed
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to not allow/allow round parenthesis () between arguments"
            | optional,
          stringsAllowedBetweenArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.isType '"Array"
                    ],
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType 'Record
                          ],
                        _js2n__-prdslib.records.record
                          {
                            amalgamate =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.enum [ 0, 1 ]
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | doc "strings allowed between arguments"
            | optional,
          ..
        }
        | doc "command code blocks need some particular attention"
        | optional,
      cycleThroughBackUps
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.enum [ 0, 1 ] ])
        | doc "when the -w, --overwrite switch is active, back-up files can be overwritten in order; see also maxNumberOfBackUps"
        | optional,
      defaultIndent
        | String
        | doc "default indentation, needs to be specified as horizontal space"
        | optional,
      dos2unixlinebreaks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.enum [ 0, 1 ] ])
        | doc "0/1, binary switch to convert dos line breaks to unix line breaks"
        | optional,
      fileContentsEnvironments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "specify the names of *filecontents* in this field"
        | optional,
      fileExtensionPreference
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                { ".*" = _js2n__-prdslib.isType 'Integer, } true
                _js2n__-prdslib.always
            ])
        | doc "calling latexindent.pl to operate on myfile (without extension) is fine, and in which case the file extensions from this field will be used in order"
        | optional,
      fineTuning
        | {
          UnNamedGroupingBracesBrackets
            | {
              follow
                | String
                | doc "regular expression for what UN named grouping braces follow"
                | optional,
              ..
            }
            | doc "fine tuning, for UnNamedGroupingBracesBrackets"
            | optional,
          arguments
            | {
              before
                | String
                | doc "regular expression for what can come BEFORE arguments"
                | optional,
              between
                | String
                | doc "regular expression for what can come BETWEEN arguments"
                | optional,
              ..
            }
            | doc "fine tuning, for arguments"
            | optional,
          commands
            | {
              name
                | String
                | doc "regular expression for commands name"
                | optional,
              ..
            }
            | doc "fine tuning, for commands"
            | optional,
          environments
            | {
              name
                | String
                | doc "regular expression for environment name"
                | optional,
              ..
            }
            | doc "fine tuning, for environments"
            | optional,
          ifElseFi
            | {
              name
                | String
                | doc "regular expression for ifElseFi name"
                | optional,
              ..
            }
            | doc "fine tuning, for ifElseFi"
            | optional,
          items
            | {
              canBeFollowedBy
                | String
                | doc "regular expression for what can follow items"
                | optional,
              ..
            }
            | doc "fine tuning, for items"
            | optional,
          keyEqualsValuesBracesBrackets
            | {
              follow
                | String
                | doc "regular expression for what key = values follow"
                | optional,
              name
                | String
                | doc "regular expression for key = value name"
                | optional,
              ..
            }
            | doc "fine tuning, for keyEqualsValuesBracesBrackets"
            | optional,
          modifyLineBreaks
            | {
              betterFullStop
                | String
                | doc "regular expression for the 'better full stop' in the one-sentence-per-line routine"
                | optional,
              comma
                | String
                | doc "regular expression for the comma used in the comma-based poly-switches"
                | optional,
              doubleBackSlash
                | String
                | doc "regular expression for the double back slash used in the DBS poly-switches"
                | optional,
              ..
            }
            | doc "fine tuning for some of the -m switch based features"
            | optional,
          namedGroupingBracesBrackets
            | {
              follow
                | String
                | doc "regular expression for what named grouping braces follow"
                | optional,
              name
                | String
                | doc "regular expression for named grouping braces name"
                | optional,
              ..
            }
            | doc "fine tuning, for namedGroupingBracesBrackets"
            | optional,
          trailingComments
            | {
              afterComment
                | String
                | doc "regular expression for what can come after %"
                | optional,
              notPreceededBy
                | String
                | doc "regular expression for what can NOT come before %, for example \\%"
                | optional,
              ..
            }
            | doc "fine tuning, for trailing comments"
            | optional,
          ..
        }
        | doc "fine tuning, proceed with caution!"
        | optional,
      indentAfterHeadings
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              indentAfterThisHeading =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              level =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 1
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "indentation after headings"
        | optional,
      indentAfterItems
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "specify the names of environments that contain items"
        | optional,
      indentPreamble
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.enum [ 0, 1 ] ])
        | doc "0/1, binary switch to instruct latexindent.pl to operate on preamble or not"
        | optional,
      indentRules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                { ".*" = _js2n__-prdslib.isType '"String", } true
                _js2n__-prdslib.always
            ])
        | doc "per-code block indentation rule"
        | optional,
      indentRulesGlobal
        | {
          UnNamedGroupingBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          afterHeading
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          commands
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          environments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          filecontents
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          ifElseFi
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          items
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          keyEqualsValuesBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          mandatoryArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          namedGroupingBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          optionalArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          specialBeginEnd
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.isType '"String"
                ])
            | doc "indentation rules per *type* of code block"
            | optional,
          ..
        }
        | doc "*types* of code blocks indentation rules"
        | optional,
      itemNames
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "names of items"
        | optional,
      logFilePreferences
        | {
          Dumper
            | {
              Deparse
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | optional,
              Indent
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | optional,
              Pair | String | optional,
              Quotekeys
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | optional,
              Sortkeys
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | optional,
              Terse
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | optional,
              Useqq
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | optional,
              ..
            }
            | doc "options to be passed to the Dumper module; most helpful when -t, -tt active."
            | optional,
          endLogFileWith
            | String
            | doc "string decoration to finish indent.log"
            | optional,
          showAmalgamatedSettings
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to show the overall/amalgamated settings in indent.log"
            | optional,
          showDecorationFinishCodeBlockTrace
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to show decorations at *finish* of code block in indent.log when -t, -tt switches active"
            | optional,
          showDecorationStartCodeBlockTrace
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to show decorations at *start* of code block in indent.log when -t, -tt switches active"
            | optional,
          showEveryYamlRead
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to show every YAML file's settings in indent.log"
            | optional,
          showGitHubInfoFooter
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to show GitHub information in footer of indent.log"
            | optional,
          ..
        }
        | doc "latexindent.pl will write logging information to indent.log; the appearance of some of the information can be customised"
        | optional,
      lookForAlignDelims
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.isType 'Record
                            ],
                          _js2n__-prdslib.records.record
                            {
                              alignContentAfterDoubleBackSlash =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              alignDoubleBackSlash =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              alignFinalDoubleBackSlash =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              alignRowsWithoutMaxDelims =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              delimiterJustification =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "left", "right" ]
                                    ],
                              delimiterRegEx = _js2n__-prdslib.isType '"String",
                              delims =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              dontMeasure =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Array"
                                        ],
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.isType 'Record
                                              ],
                                            _js2n__-prdslib.records.record
                                              {
                                                applyTo =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"String",
                                                        _js2n__-prdslib.enum
                                                          [ "cell", "row" ]
                                                      ],
                                                regex =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                this =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                              justification =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.enum [ "left", "right" ]
                                    ],
                              lookForChildCodeBlocks =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              multiColumnGrouping =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              spacesAfterAmpersand =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              spacesAfterDoubleBackSlash =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              spacesBeforeAmpersand =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                              spacesBeforeDoubleBackSlash =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.numbers.minimum 0
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "list of names of code blocks detailing that latexindent.pl should align at delimiters"
        | optional,
      lookForPreamble
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "list of extensions detailing which files latexindent.pl should look for preamble"
        | optional,
      maxNumberOfBackUps
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Integer,
              _js2n__-prdslib.numbers.minimum 0
            ])
        | doc "when the -w, --overwrite switch is active, the default is to create a back-up file for each call to latexindent.pl. This field sets the maximum number of back-up files"
        | optional,
      maximumIndentation
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType 'Integer
            ])
        | doc "maximum value of indentation; specify as horizontal space"
        | optional,
      modifyLineBreaks
        | {
          commands
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      CommandNameFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      CommandStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  CommandNameFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  CommandStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for commands (GLOBAL)"
            | optional,
          condenseMultipleBlankLinesInto
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.numbers.minimum 0
                ])
            | doc "condense multiple blank lines into this many blank lines"
            | optional,
          environments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      BeginStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      BodyStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      EndFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      EndStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  BeginStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  BodyStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  EndFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  EndStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for environments (GLOBAL)"
            | optional,
          ifElseFi
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      BodyStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      ElseFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      ElseStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      FiFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      FiStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      IfStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      OrFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      OrStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  BodyStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  ElseFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  ElseStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  FiFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  FiStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  IfStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  OrFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  OrStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for ifElseFi (GLOBAL)"
            | optional,
          items
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      ItemFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      ItemStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  ItemFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  ItemStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for items (GLOBAL)"
            | optional,
          keyEqualsValuesBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      EqualsFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      EqualsStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      KeyStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  EqualsFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  EqualsStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  KeyStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for key equals value (GLOBAL)"
            | optional,
          mandatoryArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      LCuBStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      MandArgBodyStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      RCuBFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      RCuBStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  LCuBStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  MandArgBodyStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  RCuBFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  RCuBStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for mandatory arguments (GLOBAL)"
            | optional,
          namedGroupingBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      NameFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      NameStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  NameFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  NameStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for namedGroupingBracesBrackets (GLOBAL)"
            | optional,
          oneSentencePerLine
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.records.record
                {
                  manipulateSentences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                  multipleSpacesToSingle =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                  removeSentenceLineBreaks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                  sentenceIndent = _js2n__-prdslib.isType '"String",
                  sentencesBeginWith =
                    _js2n__-prdslib.records.record
                        {
                          A-Z =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          a-z =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          other =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType '"String"
                                ],
                        } {} true _js2n__-prdslib.always,
                  sentencesDoNOTcontain =
                    _js2n__-prdslib.records.record
                        {
                          other =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType '"String"
                                ],
                        } {} true _js2n__-prdslib.always,
                  sentencesEndWith =
                    _js2n__-prdslib.records.record
                        {
                          basicFullStop =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          betterFullStop =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          exclamationMark =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          other =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType '"String"
                                ],
                          questionMark =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                        } {} true _js2n__-prdslib.always,
                  sentencesFollow =
                    _js2n__-prdslib.records.record
                        {
                          blankLine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          commentOnPreviousLine =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          exclamationMark =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          fullStop =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          other =
                            _js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.isType '"String"
                                ],
                          par =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          questionMark =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                          rightBrace =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Integer,
                                  _js2n__-prdslib.enum [ 0, 1 ]
                                ],
                        } {} true _js2n__-prdslib.always,
                  textWrapSentences =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } {} true _js2n__-prdslib.always)
            | optional,
          optionalArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      LSqBStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      OptArgBodyStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      RSqBFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      RSqBStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  LSqBStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  OptArgBodyStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  RSqBFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  RSqBStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for optional arguments (GLOBAL)"
            | optional,
          preserveBlankLines
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to preserve blank lines or not"
            | optional,
          specialBeginEnd
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      SpecialBeginStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      SpecialBodyStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      SpecialEndFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      SpecialEndStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  SpecialBeginStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  SpecialBodyStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  SpecialEndFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  SpecialEndStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for specialBeginEnd (GLOBAL)"
            | optional,
          textWrapOptions
            | {
              blocksBeginWith
                | {
                  "0-9"
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether text wrap block can begin with a digit or not"
                    | optional,
                  A-Z
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether text wrap block can begin with an uppercase letter or not"
                    | optional,
                  a-z
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether text wrap block can begin with a lowercase letter or not"
                    | optional,
                  other
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ])
                    | doc "regular expression detailing what text wrap blocks can begin with. Can be turned off by setting 0. Default is 0 if not specified"
                    | optional,
                  ..
                }
                | doc "field containing switches that text wrap blocks *begin with*"
                | optional,
              blocksEndBefore
                | {
                  commentOnOwnLine
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether text wrap block should end before a comment on its own line or not"
                    | optional,
                  filecontents
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether text wrap block should end before a filecontents environment or not"
                    | optional,
                  other
                    | String
                    | doc "regular expression detailing what text wrap blocks should end before. Can be turned off by setting 0. The default value corresponds to begin statements, display math, and end statements"
                    | optional,
                  verbatim
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether text wrap block should end before a verbatim environment or not"
                    | optional,
                  ..
                }
                | doc "field containing switches that text wrap blocks *end before*"
                | optional,
              blocksFollow
                | {
                  blankLine
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to instruct latexindent to find text wrap blocks after a blank line or not"
                    | optional,
                  commentOnPreviousLine
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to instruct latexindent to find text wrap blocks after a comment on its own line or not"
                    | optional,
                  filecontents
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to instruct latexindent to find text wrap blocks after a filecontents environment or not"
                    | optional,
                  headings
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to instruct latexindent to find text wrap blocks after the fields listed in indentAfterHeading (regardless of the value of indentAfterThisHeading or level) or not. The heading command can, optionally, be followed by a label command"
                    | optional,
                  other
                    | String
                    | doc "regular expression detailing what text wrap blocks should follow. Can be turned off by setting 0. The default value corresponds to the end of display math or an item command"
                    | optional,
                  par
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to instruct latexindent to find text wrap blocks after \\par or not"
                    | optional,
                  verbatim
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to instruct latexindent to find text wrap blocks after a verbatim block or not"
                    | optional,
                  ..
                }
                | doc "field containing switches that text wrap blocks *follow*"
                | optional,
              break
                | String
                | doc "passed to Perl's Text::Wrap module"
                | optional,
              columns
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.numbers.minimum (-1)
                    ])
                | doc "integer > 0 sets the number of columns for the text wrap routine, or if -1 then text wrap blocks simply have line breaks removed"
                | optional,
              comments
                | {
                  inheritLeadingSpace
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether comments should inherit leading spaces"
                    | optional,
                  wrap
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ])
                    | doc "0/1, binary switch to determine whether comments should be combined and wrapped"
                    | optional,
                  ..
                }
                | doc "instructions for wrapping comments"
                | optional,
              huge
                | std.enum.TagOrString
                | [| 'die, 'wrap, 'overflow |]
                | doc "WARNING: I don't recommend changing this from overflow; passed to Perl's Text::Wrap module"
                | optional,
              multipleSpacesToSingle
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | doc "0/1, binary switch to determine whether text wrap should convert multiple spaces to single space"
                | optional,
              removeBlockLineBreaks
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | doc "0/1, binary switch to determine whether text wrap should convert multiple spaces to single space"
                | optional,
              separator
                | String
                | doc "passed to Perl's Text::Wrap module"
                | optional,
              separator2
                | String
                | doc "passed to Perl's Text::Wrap module"
                | optional,
              tabstop
                | std.number.Integer
                | doc "passed to Perl's Text::Wrap module"
                | optional,
              unexpand
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Integer,
                      _js2n__-prdslib.enum [ 0, 1 ]
                    ])
                | doc "passed to Perl's Text::Wrap module"
                | optional,
              when
                | std.enum.TagOrString
                | [| 'after, 'before |]
                | doc "optional: string specifying whether text wrapping should be made before/after code blocks have been found. Default is 'before' if not specified"
                | optional,
              ..
            }
            | doc "options for the text wrap routine"
            | optional,
          verbatim
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      VerbatimBeginStartsOnOwnLine =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                      VerbatimEndFinishesWithLineBreak =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Integer,
                              _js2n__-prdslib.enum [ -1, 0, 1, 2, 3, 4 ]
                            ],
                    }
                    {
                      ".*" =
                        _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  VerbatimBeginStartsOnOwnLine =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                  VerbatimEndFinishesWithLineBreak =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.enum
                                            [ -1, 0, 1, 2, 3, 4 ]
                                        ],
                                } {} true _js2n__-prdslib.always
                            ],
                    } true _js2n__-prdslib.always
                ])
            | doc "poly-switches for verbatim (GLOBAL)"
            | optional,
          ..
        }
        | doc "when -m switch active, latexindent.pl has ability to modify line breaks"
        | optional,
      noAdditionalIndent
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "names of code blocks to not have additional indentation"
        | optional,
      noAdditionalIndentGlobal
        | {
          UnNamedGroupingBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          afterHeading
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          commands
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          environments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          filecontents
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          ifElseFi
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          items
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          keyEqualsValuesBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          mandatoryArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          namedGroupingBracesBrackets
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          optionalArguments
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          specialBeginEnd
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to mean *type* of code block does not have/has additional indentation"
            | optional,
          ..
        }
        | doc "*types* of code blocks to not have additional indentation"
        | optional,
      noIndentBlock
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "specify the names of *noIndentBlock* in this field"
        | optional,
      onlyOneBackUp
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.enum [ 0, 1 ] ])
        | doc "when the -w, --overwrite switch is active, the default is to create a back-up file for each call to latexindent.pl. Changing onlyOneBackUp to 1 means that only one back-up file is created"
        | optional,
      preambleCommandsBeforeEnvironments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.enum [ 0, 1 ] ])
        | doc "0/1, binary switch to instruct latexindent.pl to search for commands before environments in preamble"
        | optional,
      removeTrailingWhitespace
        | {
          afterProcessing
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to remove horizontal space *after* indenting"
            | optional,
          beforeProcessing
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Integer,
                  _js2n__-prdslib.enum [ 0, 1 ]
                ])
            | doc "0/1, binary switch to remove horizontal space *before* indenting"
            | optional,
          ..
        }
        | doc "remove horizontal space at the *end* of lines"
        | optional,
      replacements
        | Array
          {
            amalgamate
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.enum [ 0, 1 ]
                  ])
              | doc "optional: 0/1, binary switch to add to/overwrite previously loaded items. Default is 1 if not specified"
              | optional,
            lookForThis
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.enum [ 0, 1 ]
                  ])
              | doc "optional: 0/1, binary switch detailing look for this or not. Default is 1 if not specified"
              | optional,
            substitution
              | String
              | doc "regular expression of the form 's/regex/replacement/modifiers; works only if 'this' is blank"
              | optional,
            that | String | doc "string to replace with" | optional,
            this | String | doc "string to be replaced" | optional,
            when
              | std.enum.TagOrString
              | [| 'after, 'before |]
              | doc "optional: string specifying whether replacement should be made before/after indentation. Default is 'before' if not specified"
              | optional,
            ..
          }
        | doc "replacements to be made; requires -r, -rr or -rv switch"
        | optional,
      specialBeginEnd
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  specialBeforeCommand =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                }
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              begin = _js2n__-prdslib.isType '"String",
                              body = _js2n__-prdslib.isType '"String",
                              end = _js2n__-prdslib.isType '"String",
                              lookForThis =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Integer,
                                      _js2n__-prdslib.enum [ 0, 1 ]
                                    ],
                              middle = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "special code blocks have begin, end, and optionally 'middle' specified as regular expressions"
        | optional,
      verbatimCommands
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "specify the names of verbatim *commands* in this field"
        | optional,
      verbatimEnvironments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  ".*" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.enum [ 0, 1 ]
                        ],
                } true _js2n__-prdslib.always
            ])
        | doc "specify the names of verbatim environments in this field"
        | optional,
      ..
    }