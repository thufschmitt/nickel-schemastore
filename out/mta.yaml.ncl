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
      "_js2n__-:definitions/generic-memory!contract" =
        _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType '"String",
                _js2n__-prdslib.strings.pattern
                  "^[1-9][0-9]*(M|MB|G|GB|m|mb|g|gb)$"
              ]),
      "_js2n__-:definitions/hooks!contract" =
        Array
            {
              name
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                    ])
                | doc "An internal name which can be used for documentation purposes and shown by the deployer.",
              parameters
                | _js2n__-refsenv."_js2n__-:definitions/hooks-parameters!contract"
                | doc "Configuration parameters that are used when executing the hook to the target runtime environment."
                | optional,
              parameters-metadata
                | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                | doc "Additional information about the hook's parameters."
                | optional,
              phases
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.arrayOf
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.enum
                              [
                                "application.before-stop.live",
                                "application.before-stop.idle",
                                "application.after-stop.live",
                                "application.after-stop.idle"
                              ]
                          ])
                    ])
                | doc "A list of strings that define the points at which the hook must be executed."
                | optional,
              requires
                | Array
                  {
                    name
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.strings.pattern
                              "^[A-Za-z0-9_\\-\\.]+$"
                          ])
                      | doc "An MTA internal name which must match either a provided name, or a resource name within the same MTA.",
                    parameters
                      | {  .. }
                      | doc "Parameters can be used to influence the behavior of tools which interpret this descriptor. Parameters are not made available to the hook at runtime. Provided property values can be accessed by \"~{<provided-property-name>}\". Such expressions can be part of an arbitrary string"
                      | optional,
                    parameters-metadata
                      | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                      | doc "Additional information about the hook's parameters."
                      | optional,
                    ..
                  }
                | doc "List of names either matching a resource name or a provided dependency name provided within the same MTA that are required by this hook."
                | optional,
              type
                | std.enum.TagOrString
                | [| 'task |]
                | doc "Defines the type of action that should be executed by the deployer."
                | optional,
              ..
            },
      "_js2n__-:definitions/hooks-parameters!contract" =
        {
            command
              | String
              | doc "Defines the actual command that is executed as a Cloud Foundry task.",
            disk-quota
              | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
              | doc "Defines the disk space that is available to the Cloud Foundry task."
              | optional,
            memory
              | _js2n__-refsenv."_js2n__-:definitions/generic-memory!contract"
              | doc "Defines the memory that is available to the Cloud Foundry task."
              | optional,
            name
              | String
              | doc "Defines the name of the Cloud Foundry task that should be executed."
              | optional,
            ..
          },
      "_js2n__-:definitions/parameters!contract" = {  .. },
      "_js2n__-:definitions/parameters-metadata!contract" =
        { "optional" | Bool | optional, overwritable | Bool | optional, .. },
      "_js2n__-:definitions/properties!contract" = {  .. },
      "_js2n__-:definitions/properties-metadata!contract" =
        {
            datatype
              | std.enum.TagOrString
              | [| 'bool, 'float, 'int, 'str |]
              | optional,
            "optional" | Bool | optional,
            overwritable | Bool | optional,
            ..
          },
    }
    in
  {
      ID
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
            ])
        | doc "An application ID, that may contain any number of unicode characters and should be unique in the target runtime environment.",
      _schema-version
        | String
        | doc "The schema version that is being used for authoring a descriptor. The schema version should comply with the semantic versioning standard.",
      copyright
        | String
        | doc "A copyright statement from the provider."
        | optional,
      description
        | String
        | doc "A free text describing this application."
        | optional,
      includes
        | Array
          {
            name
              | String
              | doc "The name of an \"includes\" section. This name is used by a builder to generate a parameter section in the deployment descriptor.",
            path
              | String
              | doc "A path pointing to a file that contains a map of parameters, either in JSON or in YAML format.",
            ..
          }
        | doc "It is possible to define parameters in external files. The \"includes\" section is used to point to those files."
        | optional,
      modules
        | Array
          {
            build-parameters
              | {  .. }
              | doc "The build parameters define how the module is built by the corresponding tool."
              | optional,
            deployed-after
              | Array (String)
              | doc "A list of modules that must be deployed before deploying the current module."
              | optional,
            description
              | String
              | doc "A free text describing this module."
              | optional,
            hooks
              | _js2n__-refsenv."_js2n__-:definitions/hooks!contract"
              | doc "A list of hooks that will be executed for the module."
              | optional,
            includes
              | Array
                {
                  name
                    | String
                    | doc "The name of an \"includes\" section. This name is used by a builder to generate a parameter section in the deployment descriptor.",
                  path
                    | String
                    | doc "A path pointing to a file that contains a map of parameters, either in JSON or in YAML format.",
                  ..
                }
              | doc "It is possible to define parameters in external files. The \"includes\" section is used to point to those files."
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                  ])
              | doc "The MTA module name which must be unique and cannot be the same as any provided property set or resource name.",
            parameters
              | _js2n__-refsenv."_js2n__-:definitions/parameters!contract"
              | doc "Configuration parameters that are used when deploying the module to the target runtime environment."
              | optional,
            parameters-metadata
              | _js2n__-refsenv."_js2n__-:definitions/parameters-metadata!contract"
              | doc "Additional information about the module's parameters."
              | optional,
            path
              | String
              | doc "The path to a folder that contains the module artifacts."
              | optional,
            properties
              | _js2n__-refsenv."_js2n__-:definitions/properties!contract"
              | doc "A collection of key-value pairs that are available to the module at runtime."
              | optional,
            properties-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the module's properties."
              | optional,
            provides
              | Array
                {
                  name
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[A-Za-z0-9_\\-\\.]+$"
                        ])
                    | doc "The name of the property set that the module provides. The provided name must be unique and cannot be the same as any resource or module name.",
                  properties
                    | _js2n__-refsenv."_js2n__-:definitions/properties!contract"
                    | doc "A list of properties that are included in this property set."
                    | optional,
                  properties-metadata
                    | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                    | doc "Additional information about the provided set's properties."
                    | optional,
                  public
                    | Bool
                    | doc "Configures the accessibility of the provided property set; if set to \"true\", it is publicly accessible and can be consumed by other MTA projects."
                    | optional,
                  ..
                }
              | doc "Used to define the named property sets that other modules and resources can require."
              | optional,
            requires
              | Array
                {
                  group
                    | String
                    | doc "A \"group\" can be used to combine properties from multiple providers into one runtime lookup object, such as an environment variable. As of schema version 2.1, this property is DEPRECATED."
                    | optional,
                  includes
                    | Array
                      {
                        name
                          | String
                          | doc "The name of an \"includes\" section. This name is used by a builder to generate a parameter section in the deployment descriptor.",
                        path
                          | String
                          | doc "A path pointing to a file that contains a map of parameters, either in JSON or in YAML format.",
                        ..
                      }
                    | doc "It is possible to define parameters in external files. The \"includes\" section is used to point to those files."
                    | optional,
                  list
                    | String
                    | doc "Defines a name for a runtime lookup object, such as an environment variable, if the required property set contains multiple values; for example, if used to consume configuration data from outside this MTA project."
                    | optional,
                  name
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[A-Za-z0-9_\\-\\.]+$"
                        ])
                    | doc "The name of a provided property set or resource (provider) that this module requires.",
                  parameters
                    | _js2n__-refsenv."_js2n__-:definitions/parameters!contract"
                    | doc "Configuration parameters that are used when deploying the module to the target runtime environment."
                    | optional,
                  parameters-metadata
                    | _js2n__-refsenv."_js2n__-:definitions/parameters-metadata!contract"
                    | doc "Additional information about the modules' parameters."
                    | optional,
                  properties
                    | _js2n__-refsenv."_js2n__-:definitions/properties!contract"
                    | doc "Module properties whose values are determined by the provided properties. These properties can be referenced by the tilde notation: \"~{<provided-property-name>}\" "
                    | optional,
                  properties-metadata
                    | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                    | doc "Additional information about the modules' properties."
                    | optional,
                  ..
                }
              | doc "A list of property sets provided by other modules and/or resources (providers) that this module requires."
              | optional,
            type
              | String
              | doc "The module type that defines the design-time tools for the module.",
            ..
          }
        | doc "A list of modules."
        | optional,
      parameters
        | _js2n__-refsenv."_js2n__-:definitions/parameters!contract"
        | doc "Global parameters that are used when building or deploying the application"
        | optional,
      parameters-metadata
        | _js2n__-refsenv."_js2n__-:definitions/parameters-metadata!contract"
        | doc "Additional information about the global parameters."
        | optional,
      provider
        | String
        | doc "The provider or vendor of this application."
        | optional,
      resources
        | Array
          {
            active
              | Bool
              | doc "If a resource is declared to be inactive, the resource will not be allocated during the deployment process."
              | optional,
            description
              | String
              | doc "A free text describing this resource."
              | optional,
            includes
              | Array
                {
                  name
                    | String
                    | doc "The name of an \"includes\" section. This name is used by a builder to generate a parameter section in the deployment descriptor.",
                  path
                    | String
                    | doc "A path pointing to a file that contains a map of parameters, either in JSON or in YAML format.",
                  ..
                }
              | doc "It is possible to define parameters in external files. The \"includes\" section is used to point to those files."
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                  ])
              | doc "The resource name which must be unique and cannot be the same as any provided property set or module name.",
            "optional"
              | Bool
              | doc "If the resource is set to optional and the deployment tools are unable to allocate it, then the tools will issue a warning and continue the deployment process."
              | optional,
            parameters
              | _js2n__-refsenv."_js2n__-:definitions/parameters!contract"
              | doc "Configuration parameters that are used when provisioning the resource in the target runtime environment."
              | optional,
            parameters-metadata
              | _js2n__-refsenv."_js2n__-:definitions/parameters-metadata!contract"
              | doc "Additional information about the resource's parameters."
              | optional,
            processed-after
              | Array (String)
              | doc "A list containing the names of the resources that must be processed prior to this one."
              | optional,
            properties
              | _js2n__-refsenv."_js2n__-:definitions/properties!contract"
              | doc "A collection of key-value pairs that can be required by modules and/or other resources as configuration data at runtime."
              | optional,
            properties-metadata
              | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
              | doc "Additional information about the resource's properties."
              | optional,
            requires
              | Array
                {
                  includes
                    | Array
                      {
                        name
                          | String
                          | doc "The name of an \"includes\" section. This name is used by a builder to generate a parameter section in the deployment descriptor.",
                        path
                          | String
                          | doc "A path pointing to a file that contains a map of parameters, either in JSON or in YAML format.",
                        ..
                      }
                    | doc "It is possible to define parameters in external files. The \"includes\" section is used to point to those files."
                    | optional,
                  name
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[A-Za-z0-9_\\-\\.]+$"
                        ])
                    | doc "The name of a provided property set or resource (provider) that this resource requires.",
                  parameters
                    | _js2n__-refsenv."_js2n__-:definitions/parameters!contract"
                    | doc "Configuration parameters that are used when provisioning the resource in the target runtime environment."
                    | optional,
                  parameters-metadata
                    | _js2n__-refsenv."_js2n__-:definitions/parameters-metadata!contract"
                    | doc "Additional information about the required parameters."
                    | optional,
                  properties
                    | _js2n__-refsenv."_js2n__-:definitions/properties!contract"
                    | doc "Resource properties whose values are determined by the provided properties. These properties can be referenced by the tilde notation: \"~{<provided-property-name>}\" "
                    | optional,
                  properties-metadata
                    | _js2n__-refsenv."_js2n__-:definitions/properties-metadata!contract"
                    | doc "Additional information about the required properties."
                    | optional,
                  ..
                }
              | doc "A list of property sets provided by other modules and/or resources (providers) that this resource requires."
              | optional,
            type
              | String
              | doc "A type of resource supported by deployment tools in the target environment."
              | optional,
            ..
          }
        | doc "A list of resources that are required by the modules of this MTA project."
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(-(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?$"
            ])
        | doc "The application version that should comply with the semantic versioning standard.",
      ..
    }