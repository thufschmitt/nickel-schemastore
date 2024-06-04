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
      "_js2n__-:definitions/Category!contract"
        | doc "Broad plugin categories, values for PluginManifest.categories."
        = std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'Visualization,
                'Utilities,
                'Transformations,
                'Themes,
                'Simulation,
                'Segmentation,
                'Measurement,
                'IO,
                '"Image Processing",
                'Dataset,
                'Annotation,
                'Acquisition
              |]
            ],
      "_js2n__-:definitions/CommandContribution!predicate"
        | doc m%"
          Contribute a **command** (a python callable) consisting of a unique `id`,
          a `title` and (optionally) a `python_path` that points to a fully qualified python
          callable.  If a `python_path` is not included in the manifest, it *must* be
          registered during activation with `register_command`.
          
          Note, some other contributions (e.g. `readers`, `writers` and `widgets`) will
          *point* to a specific command.  The command itself (i.e. the callable python
          object) will always appear in the `contributions.commands` section, but those
          contribution types may add additional contribution-specific metadata.
          
          ```{admonition} Future Plans
          Command contributions will eventually include an **icon**, **category**, and
          **enabled** state. Enablement is expressed with *when clauses*, that capture a
          conditional expression determining whether the command should be enabled or not,
          based on the current state of the program.  (i.e. "*If the active layer is a
          `Labels` layer*")
          
          Commands will eventually be availble in a Command Palette (accessible with a
          hotkey) but they can also show in other menus.
          ```
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "title" ],
              _js2n__-prdslib.records.record
                {
                  category = _js2n__-prdslib.isType '"String",
                  enablement = _js2n__-prdslib.isType '"String",
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/Icon!predicate"
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  python_name = _js2n__-prdslib.isType '"String",
                  short_title = _js2n__-prdslib.isType '"String",
                  title = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ConfigurationContribution!predicate"
        | doc m%"
          A configuration contribution for a plugin.
          
          This enables plugins to provide a schema for their configurables.
          Configuration contributions are used to generate the settings UI.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "properties", "title" ],
              _js2n__-prdslib.records.record
                {
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/ConfigurationProperty!predicate"
                        ],
                  title = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ConfigurationProperty!predicate"
        | doc m%"
          Configuration for a single property in the plugin settings.
          
          This is a super-set of the JSON Schema (draft 7) specification.
          https://json-schema.org/understanding-json-schema/reference/index.html
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "$comment" = _js2n__-prdslib.isType '"String",
                  "$id" = _js2n__-prdslib.isType '"String",
                  "$schema" = _js2n__-prdslib.isType '"String",
                  additionalItems =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  additionalProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  allOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  anyOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  const = _js2n__-prdslib.always,
                  contains =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  contentEncoding = _js2n__-prdslib.isType '"String",
                  contentMediaType = _js2n__-prdslib.isType '"String",
                  "default" = _js2n__-prdslib.always,
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String"),
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ]
                              ])
                        ],
                  deprecationMessage = _js2n__-prdslib.isType '"String",
                  deprecationMessageFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "markdown", "plain" ]
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  descriptionFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "markdown", "plain" ]
                        ],
                  editPresentation =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "singleline", "multiline" ]
                        ],
                  "else" =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  enum =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always,
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  enumDescriptions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  enumDescriptionsFormat =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "markdown", "plain" ]
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  exclusiveMaximum = _js2n__-prdslib.isType '"Number",
                  exclusiveMinimum = _js2n__-prdslib.isType '"Number",
                  format = _js2n__-prdslib.isType '"String",
                  "if" =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                            ]
                        ],
                  maxItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maxProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maximum = _js2n__-prdslib.isType '"Number",
                  minItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minimum = _js2n__-prdslib.isType '"Number",
                  multipleOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  not =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  oneOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  order = _js2n__-prdslib.isType 'Integer,
                  pattern = _js2n__-prdslib.isType '"String",
                  patternErrorMessage = _js2n__-prdslib.isType '"String",
                  patternProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  propertyNames =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  required =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  "then" =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  title = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "array",
                                  "boolean",
                                  "integer",
                                  "null",
                                  "number",
                                  "object",
                                  "string"
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
                                        "array",
                                        "boolean",
                                        "integer",
                                        "null",
                                        "number",
                                        "object",
                                        "string"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  uniqueItems = _js2n__-prdslib.isType '"Bool",
                  writeOnly = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ContributionPoints!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  commands =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/CommandContribution!predicate"
                        ],
                  configuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ConfigurationContribution!predicate"
                        ],
                  keybindings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/KeyBindingContribution!predicate"
                        ],
                  menus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-refsenv."_js2n__-:definitions/MenuCommand!predicate",
                                      _js2n__-refsenv."_js2n__-:definitions/Submenu!predicate"
                                    ])
                              ])
                        ],
                  readers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ReaderContribution!predicate"
                        ],
                  sample_data =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/SampleDataGenerator!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/SampleDataURI!predicate"
                              ])
                        ],
                  submenus =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/SubmenuContribution!predicate"
                        ],
                  themes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/ThemeContribution!predicate"
                        ],
                  widgets =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/WidgetContribution!predicate"
                        ],
                  writers =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/WriterContribution!predicate"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Draft06JsonSchema!predicate"
        | doc "Model for Draft 6 JSON Schema."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "$id" = _js2n__-prdslib.isType '"String",
                  "$schema" = _js2n__-prdslib.isType '"String",
                  additionalItems =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  additionalProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  allOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  anyOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  const = _js2n__-prdslib.always,
                  contains =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  "default" = _js2n__-prdslib.always,
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String"),
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ]
                              ])
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  enum =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always,
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  exclusiveMaximum = _js2n__-prdslib.isType '"Number",
                  exclusiveMinimum = _js2n__-prdslib.isType '"Number",
                  format = _js2n__-prdslib.isType '"String",
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                            ]
                        ],
                  maxItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maxProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maximum = _js2n__-prdslib.isType '"Number",
                  minItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minimum = _js2n__-prdslib.isType '"Number",
                  multipleOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  not =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  oneOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                  patternProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate"
                        ],
                  propertyNames =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  required =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  title = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "array",
                                  "boolean",
                                  "integer",
                                  "null",
                                  "number",
                                  "object",
                                  "string"
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
                                        "array",
                                        "boolean",
                                        "integer",
                                        "null",
                                        "number",
                                        "object",
                                        "string"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  uniqueItems = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Draft07JsonSchema!predicate"
        | doc "Model for Draft 7 JSON Schema."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "$comment" = _js2n__-prdslib.isType '"String",
                  "$id" = _js2n__-prdslib.isType '"String",
                  "$schema" = _js2n__-prdslib.isType '"String",
                  additionalItems =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  additionalProperties =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  allOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  anyOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  const = _js2n__-prdslib.always,
                  contains =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  contentEncoding = _js2n__-prdslib.isType '"String",
                  contentMediaType = _js2n__-prdslib.isType '"String",
                  "default" = _js2n__-prdslib.always,
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.isType '"String"),
                                    _js2n__-prdslib.arrays.uniqueItems
                                  ]
                              ])
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  "else" =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  enum =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always,
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  examples =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf _js2n__-prdslib.always
                        ],
                  exclusiveMaximum = _js2n__-prdslib.isType '"Number",
                  exclusiveMinimum = _js2n__-prdslib.isType '"Number",
                  format = _js2n__-prdslib.isType '"String",
                  "if" =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  items =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                            ]
                        ],
                  maxItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maxLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maxProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  maximum = _js2n__-prdslib.isType '"Number",
                  minItems =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minLength =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  minimum = _js2n__-prdslib.isType '"Number",
                  multipleOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.numbers.minimum 0
                        ],
                  not =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  oneOf =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  pattern = _js2n__-prdslib.isType '"String",
                  patternProperties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  properties =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate"
                        ],
                  propertyNames =
                    _js2n__-refsenv."_js2n__-:definitions/Draft06JsonSchema!predicate",
                  readOnly = _js2n__-prdslib.isType '"Bool",
                  required =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  "then" =
                    _js2n__-refsenv."_js2n__-:definitions/Draft07JsonSchema!predicate",
                  title = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "array",
                                  "boolean",
                                  "integer",
                                  "null",
                                  "number",
                                  "object",
                                  "string"
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
                                        "array",
                                        "boolean",
                                        "integer",
                                        "null",
                                        "number",
                                        "object",
                                        "string"
                                      ]
                                  ]),
                              _js2n__-prdslib.arrays.minItems 1,
                              _js2n__-prdslib.arrays.uniqueItems
                            ]
                        ],
                  uniqueItems = _js2n__-prdslib.isType '"Bool",
                  writeOnly = _js2n__-prdslib.isType '"Bool",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Icon!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dark = _js2n__-prdslib.isType '"String",
                  light = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/KeyBindingContribution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command", "key" ],
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  linux = _js2n__-prdslib.isType '"String",
                  mac = _js2n__-prdslib.isType '"String",
                  when = _js2n__-prdslib.isType '"String",
                  win = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/MenuCommand!predicate"
        | doc "Contributes a command in a menu."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command" ],
              _js2n__-prdslib.records.record
                {
                  alt = _js2n__-prdslib.isType '"String",
                  command = _js2n__-prdslib.isType '"String",
                  group = _js2n__-prdslib.isType '"String",
                  when = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PackageMetadata!predicate"
        | doc m%"
          Pydantic model for standard python package metadata.
          
          https://www.python.org/dev/peps/pep-0566/
          https://packaging.python.org/specifications/core-metadata/
          
          The `importlib.metadata` provides the `metadata()` function,
          but it returns a somewhat awkward `email.message.Message` object.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name", "version" ],
              _js2n__-prdslib.records.record
                {
                  author = _js2n__-prdslib.isType '"String",
                  author_email = _js2n__-prdslib.isType '"String",
                  classifier =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  description = _js2n__-prdslib.isType '"String",
                  description_content_type = _js2n__-prdslib.isType '"String",
                  download_url = _js2n__-prdslib.isType '"String",
                  dynamic =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  home_page = _js2n__-prdslib.isType '"String",
                  keywords = _js2n__-prdslib.isType '"String",
                  license = _js2n__-prdslib.isType '"String",
                  maintainer = _js2n__-prdslib.isType '"String",
                  maintainer_email = _js2n__-prdslib.isType '"String",
                  metadata_version =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum
                                [
                                  "1.0",
                                  "1.1",
                                  "1.2",
                                  "2.0",
                                  "2.1",
                                  "2.2",
                                  "2.3"
                                ]
                            ],
                          _js2n__-prdslib.isType '"String"
                        ],
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$"
                        ],
                  obsoletes_dist =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  platform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  project_url =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  provides_dist =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  provides_extra =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requires_dist =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requires_external =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  requires_python = _js2n__-prdslib.isType '"String",
                  summary = _js2n__-prdslib.isType '"String",
                  supported_platform =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  version = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ReaderContribution!predicate"
        | doc m%"
          Contribute a file reader.
          
          Readers may be associated with specific **filename_patterns** (e.g. "*.tif",
          "*.zip") and are invoked whenever `viewer.open('some/path')` is used on the
          command line, or when a user opens a file in the graphical user interface by
          dropping a file into the canvas, or using `File -> Open...`
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "command", "filename_patterns" ],
              _js2n__-prdslib.records.record
                {
                  accepts_directories = _js2n__-prdslib.isType '"Bool",
                  command = _js2n__-prdslib.isType '"String",
                  filename_patterns =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/SampleDataGenerator!predicate"
        | doc "Contribute a callable command that creates data on demand."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "command", "display_name", "key" ],
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  display_name = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SampleDataURI!predicate"
        | doc m%"
          Contribute a URI to static local or remote data. This can be data included in
          the plugin package, or a URL to remote data.  The URI must be readable by either
          napari's builtin reader, or by a plugin that is included/required.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "display_name", "key", "uri" ],
              _js2n__-prdslib.records.record
                {
                  display_name = _js2n__-prdslib.isType '"String",
                  key = _js2n__-prdslib.isType '"String",
                  reader_plugin = _js2n__-prdslib.isType '"String",
                  uri = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Submenu!predicate"
        | doc "Contributes a submenu placement in a menu."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "submenu" ],
              _js2n__-prdslib.records.record
                {
                  group = _js2n__-prdslib.isType '"String",
                  submenu = _js2n__-prdslib.isType '"String",
                  when = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/SubmenuContribution!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "id", "label" ],
              _js2n__-prdslib.records.record
                {
                  icon =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/Icon!predicate"
                        ],
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ThemeColors!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  background = _js2n__-prdslib.isType '"String",
                  canvas = _js2n__-prdslib.isType '"String",
                  console = _js2n__-prdslib.isType '"String",
                  current = _js2n__-prdslib.isType '"String",
                  foreground = _js2n__-prdslib.isType '"String",
                  highlight = _js2n__-prdslib.isType '"String",
                  icon = _js2n__-prdslib.isType '"String",
                  primary = _js2n__-prdslib.isType '"String",
                  secondary = _js2n__-prdslib.isType '"String",
                  text = _js2n__-prdslib.isType '"String",
                  warning = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ThemeContribution!predicate"
        | doc m%"
          Contribute a color theme to napari.
          
          You must specify an **id**, **label**, and whether the theme is a dark theme or a
          light theme **type** (such that the rest of napari changes to match your theme).
          Any color keys omitted from the theme contribution will use the default napari
          dark/light theme colors.
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required
                [ "colors", "id", "label", "type" ],
              _js2n__-prdslib.records.record
                {
                  colors =
                    _js2n__-refsenv."_js2n__-:definitions/ThemeColors!predicate",
                  font_size = _js2n__-prdslib.isType '"String",
                  id = _js2n__-prdslib.isType '"String",
                  label = _js2n__-prdslib.isType '"String",
                  syntax_style = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "dark" ]
                            ],
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.enum [ "light" ]
                            ]
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/WidgetContribution!predicate"
        | doc m%"
          Contribute a widget that can be added to the napari viewer.
          
          Widget contributions point to a **command** that, when called, returns a widget
          *instance*; this includes functions that return a widget instance, (e.g. those
          decorated with `magicgui.magic_factory`) and subclasses of either
          [`QtWidgets.QWidget`](https://doc.qt.io/qt-5/qwidget.html) or
          [`magicgui.widgets.Widget`](https://napari.org/magicgui/api/_autosummary/magicgui.widgets._bases.Widget.html).
          
          Optionally, **autogenerate** may be used to create a widget (using
          [magicgui](https://napari.org/magicgui/)) from a command.  (In this case, the
          command needn't return a widget instance; it can be any function suitable as an
          argument to `magicgui.magicgui()`.)
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command", "display_name" ],
              _js2n__-prdslib.records.record
                {
                  autogenerate = _js2n__-prdslib.isType '"Bool",
                  command = _js2n__-prdslib.isType '"String",
                  display_name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/WriterContribution!predicate"
        | doc m%"
          Contribute a layer writer.
          
          Writers accept data from one or more layers and write them to file. Writers declare
          support for writing one or more **layer_types**, may be associated with specific
          **filename_patterns** (e.g. "\*.tif", "\*.zip") and are invoked whenever
          `viewer.layers.save('some/path.ext')` is used on the command line, or when a user
          requests to save one or more layers in the graphical user interface with `File ->
          Save Selected Layer(s)...` or `Save All Layers...`
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "command", "layer_types" ],
              _js2n__-prdslib.records.record
                {
                  command = _js2n__-prdslib.isType '"String",
                  display_name = _js2n__-prdslib.isType '"String",
                  filename_extensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  layer_types =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      categories
        | Array _js2n__-refsenv."_js2n__-:definitions/Category!contract"
        | doc "A list of categories that this plugin belongs to. This is used to help users discover your plugin. Allowed values: `[Acquisition, Annotation, Dataset, Image Processing, IO, Measurement, Segmentation, Simulation, Themes, Transformations, Utilities, Visualization]`"
        | optional,
      contributions
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/ContributionPoints!predicate"
        | doc "An object describing the plugin's [contributions](./contributions)"
        | optional,
      display_name
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.maxLength 90,
              _js2n__-prdslib.strings.minLength 3
            ])
        | doc "User-facing text to display as the name of this plugin. Must be 3-90 characters long and must not begin or end with an underscore, white space, or non-word character. If not provided, the manifest `name` will be used as the display name."
        | optional,
      icon
        | String
        | doc "The path to a square PNG icon of at least 128x128 pixels (256x256 for Retina screens). May be one of: <ul><li>a secure (https) URL </li><li>a path relative to the manifest file, (must be shipped in the sdist)</li><li>a string in the format `{package}:{resource}`, where `package` and `resource` are arguments to `importlib.resources.path(package, resource)`, (e.g. `top_module.some_folder:my_logo.png`).</li></ul>"
        | optional,
      name
        | String
        | doc "The name of the plugin. Though this field is mandatory, it *must* match the package `name` as defined in the python package metadata.",
      npe1_shim
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc "Whether this manifest was created as a shim for an npe1 plugin."
        | optional,
      on_activate
        | String
        | doc "Fully qualified python path to a function that will be called upon plugin activation (e.g. `'my_plugin.some_module:activate'`). The activate function can be used to connect command ids to python callables, or perform other side-effects. A plugin will be 'activated' when one of its contributions is requested by the user (such as a widget, or reader)."
        | optional,
      on_deactivate
        | String
        | doc "Fully qualified python path to a function that will be called when a user deactivates a plugin (e.g. `'my_plugin.some_module:deactivate'`). This is optional, and may be used to perform any plugin cleanup."
        | optional,
      package_metadata
        | _js2n__-prdslib.contract_from_predicate
          _js2n__-refsenv."_js2n__-:definitions/PackageMetadata!predicate"
        | doc "Package metadata following https://packaging.python.org/specifications/core-metadata/. For normal (non-dynamic) plugins, this data will come from the package's setup.cfg"
        | optional,
      schema_version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"String")
        | doc "A SemVer compatible version string matching the napari plugin schema version that the plugin is compatible with."
        | optional,
      visibility
        | std.enum.TagOrString
        | [| 'hidden, 'public |]
        | doc "Whether this plugin should be searchable and visible in the built-in plugin installer and the napari hub. By default (`'public'`) all plugins are visible. To prevent your plugin from appearing in search results, change this to `'hidden'`."
        | optional,
      ..
    }