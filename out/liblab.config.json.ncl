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
      "_js2n__-:properties/customizations/properties/hookDependencies/items!predicate"
        | doc "A dependency that should be installed for the hook"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "version" ],
              _js2n__-prdslib.records.record
                {
                  groupId = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                  version = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate"
        | doc "The list of authors who contribute to the SDK (In TypeScript the first is the only one displayed)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        email = _js2n__-prdslib.isType '"String",
                        name = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            ],
      "_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate"
        | doc "The name of the Github Repo that will be Pull Requested to"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate"
        | doc "A dependency that should be installed for the hook"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:properties/customizations/properties/hookDependencies/items!predicate"
            ],
      "_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate"
        | doc "List of files that shouldn't be produced by liblab, used for when you want to keep specific files safe from changes"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate"
        | doc "The version of the liblab SDK Generator"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^(\\d+)$"
            ],
      "_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate"
        | doc "renames all model properties with illegal names, during the SDK generation"
        = _js2n__-prdslib.isType '"Bool",
      "_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate"
        | doc "The version of the SDK"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate"
        | doc "The target to branch off from when opening a PR"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.minLength 2
            ],
      "_js2n__-:properties/languageOptions/properties/go/properties/additionalConstructorParameters!predicate"
        | doc "Additional variables to include in the constructor and access in the hooks"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.required [ "name" ],
                    _js2n__-prdslib.records.record
                      {
                        example = _js2n__-prdslib.isType '"String",
                        name = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ])
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.required [ "languages", "specFilePath" ],
          _js2n__-prdslib.records.record
            {
              apiName = _js2n__-prdslib.isType '"String",
              apiVersion = _js2n__-prdslib.isType '"String",
              auth =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [ "apikey", "basic", "bearer", "custom" ]
                          ])
                    ],
              baseUrl =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ],
              createDocs = _js2n__-prdslib.isType '"Bool",
              customizations =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          authentication =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      access =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  prefix =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      apiKey =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  header =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      basic =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.required
                                                [ "enabled" ],
                                              _js2n__-prdslib.records.record
                                                {
                                                  enabled =
                                                    _js2n__-prdslib.isType
                                                        '"Bool",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      custom =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  prefix =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          devContainer = _js2n__-prdslib.isType '"Bool",
                          documentation =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      snippets =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  format =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [ "md", "json" ]
                                                        ],
                                                } {} false _js2n__-prdslib.never
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          environmentVariables =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "description", "name" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            description =
                                              _js2n__-prdslib.isType '"String",
                                            name =
                                              _js2n__-prdslib.isType '"String",
                                          } {} false _js2n__-prdslib.never
                                      ])
                                ],
                          environments =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "name", "url" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            name =
                                              _js2n__-prdslib.isType '"String",
                                            url =
                                              _js2n__-prdslib.isType '"String",
                                          } {} false _js2n__-prdslib.never
                                      ])
                                ],
                          generateEnv = _js2n__-prdslib.isType '"Bool",
                          hookDependencies =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType 'Record,
                                        _js2n__-prdslib.records.required
                                          [ "name", "version" ],
                                        _js2n__-prdslib.records.record
                                          {
                                            groupId =
                                              _js2n__-prdslib.isType '"String",
                                            name =
                                              _js2n__-prdslib.isType '"String",
                                            version =
                                              _js2n__-prdslib.isType '"String",
                                          } {} false _js2n__-prdslib.never
                                      ])
                                ],
                          includeOptionalSnippetParameters =
                            _js2n__-prdslib.isType '"Bool",
                          inferServiceNames = _js2n__-prdslib.isType '"Bool",
                          injectedModels =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType '"Array",
                                  _js2n__-prdslib.arrays.arrayOf
                                    (_js2n__-prdslib.isType '"String")
                                ],
                          license =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      type =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "MIT",
                                                  "GPL3",
                                                  "APACHE",
                                                  "NONE",
                                                  "CUSTOM"
                                                ]
                                            ],
                                      url = _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          refreshToken =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "bearerKey", "endpoint", "refreshKey" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      bearerKey =
                                        _js2n__-prdslib.isType '"String",
                                      endpoint =
                                        _js2n__-prdslib.isType '"String",
                                      refreshKey =
                                        _js2n__-prdslib.isType '"String",
                                    } {} false _js2n__-prdslib.never
                                ],
                          responseHeaders = _js2n__-prdslib.isType '"Bool",
                          retry =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "retryDelay" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      backOffFactor =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.exclusiveMinimum
                                                0
                                            ],
                                      enabled = _js2n__-prdslib.isType '"Bool",
                                      httpCodesToRetry =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Integer,
                                                    _js2n__-prdslib.numbers.maximum
                                                      599,
                                                    _js2n__-prdslib.numbers.minimum
                                                      200
                                                  ])
                                            ],
                                      httpMethodsToRetry =
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
                                                        "GET",
                                                        "POST",
                                                        "PUT",
                                                        "DELETE",
                                                        "PATCH",
                                                        "HEAD",
                                                        "OPTIONS",
                                                        "CONNECT",
                                                        "TRACE"
                                                      ]
                                                  ])
                                            ],
                                      maxAttempts =
                                        _js2n__-prdslib.isType '"Number",
                                      maxDelay =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                      retryDelay =
                                        _js2n__-prdslib.isType '"Number",
                                      retryDelayJitter =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Number",
                                              _js2n__-prdslib.numbers.minimum 0
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              docs =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum [ "api", "snippets" ]
                          ])
                    ],
              languageOptions =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          csharp =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      authors =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "name" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        email =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        name =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ])
                                            ],
                                      githubRepoName =
                                        _js2n__-prdslib.isType '"String",
                                      homepage =
                                        _js2n__-prdslib.isType '"String",
                                      hookDependencies =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                _js2n__-refsenv."_js2n__-:properties/customizations/properties/hookDependencies/items!predicate"
                                            ],
                                      ignoreFiles =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      liblabVersion =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^(\\d+)$"
                                            ],
                                      packageId =
                                        _js2n__-prdslib.isType '"String",
                                      renameIllegalModelProperties =
                                        _js2n__-prdslib.isType '"Bool",
                                      sdkVersion =
                                        _js2n__-prdslib.isType '"String",
                                      targetBranch =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.minLength
                                                2
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                          go =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "goModuleName" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      additionalConstructorParameters =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.required
                                                      [ "name" ],
                                                    _js2n__-prdslib.records.record
                                                      {
                                                        example =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                        name =
                                                          _js2n__-prdslib.isType
                                                              '"String",
                                                      } {} false
                                                      _js2n__-prdslib.never
                                                  ])
                                            ],
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      goModuleName =
                                        _js2n__-prdslib.isType '"String",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          java =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      additionalConstructorParameters =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/go/properties/additionalConstructorParameters!predicate",
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      groupId =
                                        _js2n__-prdslib.isType '"String",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      packageName =
                                        _js2n__-prdslib.isType '"String",
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          php =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      additionalConstructorParameters =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/go/properties/additionalConstructorParameters!predicate",
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      packageName =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[\\da-z]([._-]?[\\da-z]+)*\\/[\\da-z](([._]|-{1,2})?[\\da-z]+)*$"
                                            ],
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          python =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      additionalConstructorParameters =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/go/properties/additionalConstructorParameters!predicate",
                                      alwaysInitializeOptionals =
                                        _js2n__-prdslib.isType '"Bool",
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      classifiers =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      enforceRequestValidation =
                                        _js2n__-prdslib.isType '"Bool",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      projectUrls =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.propertyNames
                                                (_js2n__-prdslib.strings.minLength
                                                  1),
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.isType
                                                  '"String")
                                            ],
                                      pypiPackageName =
                                        _js2n__-prdslib.isType '"String",
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      strictVersion =
                                        _js2n__-prdslib.isType '"Bool",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          swift =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          terraform =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [
                                      "providerGoModuleName",
                                      "providerName",
                                      "providerVersion"
                                    ],
                                  _js2n__-prdslib.records.record
                                    {
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      hideComputedDiff =
                                        _js2n__-prdslib.isType '"Bool",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      mockAcceptance =
                                        _js2n__-prdslib.isType '"Bool",
                                      providerGoModuleName =
                                        _js2n__-prdslib.isType '"String",
                                      providerName =
                                        _js2n__-prdslib.isType '"String",
                                      providerSchemaConfig =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record
                                                {
                                                  addressKey =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                  authTokenKey =
                                                    _js2n__-prdslib.isType
                                                        '"String",
                                                } {} false _js2n__-prdslib.never
                                            ],
                                      providerVersion =
                                        _js2n__-prdslib.isType '"String",
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                          typescript =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      authors =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/authors!predicate",
                                      bundle = _js2n__-prdslib.isType '"Bool",
                                      denoteCommon =
                                        _js2n__-prdslib.isType '"Bool",
                                      exportClassDefault =
                                        _js2n__-prdslib.isType '"Bool",
                                      githubRepoName =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/githubRepoName!predicate",
                                      homepage =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/homepage!predicate",
                                      hookDependencies =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/hookDependencies!predicate",
                                      httpClient =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "axios", "fetch", "https" ]
                                            ],
                                      ignoreFiles =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/ignoreFiles!predicate",
                                      liblabVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
                                      npmName =
                                        _js2n__-prdslib.isType '"String",
                                      npmOrg = _js2n__-prdslib.isType '"String",
                                      renameIllegalModelProperties =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/renameIllegalModelProperties!predicate",
                                      sdkVersion =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/sdkVersion!predicate",
                                      targetBranch =
                                        _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/targetBranch!predicate",
                                    } {} false _js2n__-prdslib.never
                                ],
                        } {} false _js2n__-prdslib.never
                    ],
              languages =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "java",
                                "python",
                                "typescript",
                                "csharp",
                                "go",
                                "terraform",
                                "swift",
                                "php"
                              ]
                          ]),
                      _js2n__-prdslib.arrays.minItems 1
                    ],
              liblabVersion =
                _js2n__-refsenv."_js2n__-:properties/languageOptions/properties/csharp/properties/liblabVersion!predicate",
              publishing =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        { githubOrg = _js2n__-prdslib.isType '"String", } {}
                        false _js2n__-prdslib.never
                    ],
              sdkName =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ],
              specFilePath =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.minLength 1
                    ],
              validationsToIgnore =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType 'Record,
                            _js2n__-prdslib.records.required [ "code" ],
                            _js2n__-prdslib.records.record
                              {
                                code =
                                  _js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.isType '"String",
                                        _js2n__-prdslib.isType '"Number"
                                      ],
                                path =
                                  _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.anyOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.isType '"Number"
                                            ])
                                      ],
                              } {} false _js2n__-prdslib.never
                          ])
                    ],
            } {} false _js2n__-prdslib.never
        ])