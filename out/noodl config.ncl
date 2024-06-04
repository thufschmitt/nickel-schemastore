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
      "_js2n__-:definitions/Action!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  actionType =
                    _js2n__-refsenv."_js2n__-:definitions/ActionType!predicate",
                  contentType =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType!predicate",
                  dataKey =
                    _js2n__-refsenv."_js2n__-:definitions/DataKeyString!predicate",
                  dataObject =
                    _js2n__-refsenv."_js2n__-:definitions/DataObject!predicate",
                  dismissOnTouchOutside = _js2n__-prdslib.isType '"Bool",
                  emit = _js2n__-refsenv."_js2n__-:definitions/Emit!predicate",
                  funcName = _js2n__-prdslib.isType '"String",
                  goto = _js2n__-refsenv."_js2n__-:definitions/Goto!predicate",
                  object =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.isType '"Array"
                        ],
                  popUpView = _js2n__-prdslib.isType '"String",
                  reload = _js2n__-prdslib.isType '"Bool",
                  timer = _js2n__-prdslib.isType '"String",
                  timerTag = _js2n__-prdslib.isType '"String",
                  viewTag =
                    _js2n__-refsenv."_js2n__-:definitions/ViewTag!predicate",
                  wait =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType '"Number"
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ActionChain!predicate"
        | doc "A chain of actions in sequential order"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
            ],
      "_js2n__-:definitions/ActionType!predicate"
        | doc "An identifier/name for an action"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/AwaitReference!predicate"
        | doc "A reference that returns its result after the value at the referenced path is received"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[=.]*[a-zA-Z0-9]+.*@$"
            ],
      "_js2n__-:definitions/Boolean!predicate"
        | doc "A boolean value is either one of \"true\", true, \"false\", or false"
        = _js2n__-prdslib.enum [ "true", "false", true, false ],
      "_js2n__-:definitions/Border!predicate"
        | doc "Border styles"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      color =
                        _js2n__-refsenv."_js2n__-:definitions/Color!predicate",
                      line = _js2n__-prdslib.isType '"String",
                      style =
                        _js2n__-refsenv."_js2n__-:definitions/BorderStylePreset!predicate",
                      width =
                        _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/BorderPreset1!predicate"
        | doc "Removes border including the radius"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.enum [ "1", 1 ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number"
                ]
            ],
      "_js2n__-:definitions/BorderPreset2!predicate"
        | doc "Removes border from all sides (including radius) except the bottom. This will create an underline effect"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.enum [ 2, "2" ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number"
                ]
            ],
      "_js2n__-:definitions/BorderPreset3!predicate"
        | doc "Applies a solid border to all sides"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.enum [ "3", 3 ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number"
                ]
            ],
      "_js2n__-:definitions/BorderPreset4!predicate"
        | doc "Sets the border to be a dashed border"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.enum [ "4", 4 ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number"
                ]
            ],
      "_js2n__-:definitions/BorderPreset5!predicate"
        | doc "Removes border from all sides"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.enum [ "5", 5 ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number"
                ]
            ],
      "_js2n__-:definitions/BorderPreset6!predicate"
        | doc "Sets the border to be a solid border. This will also remove border radius from all sides"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.enum [ "6", 6 ],
              _js2n__-prdslib.oneOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number"
                ]
            ],
      "_js2n__-:definitions/BorderStylePreset!predicate"
        | doc "A set of border presets, each applying a different style"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/BorderPreset1!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BorderPreset2!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BorderPreset3!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BorderPreset4!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BorderPreset5!predicate",
              _js2n__-refsenv."_js2n__-:definitions/BorderPreset6!predicate"
            ],
      "_js2n__-:definitions/BuiltInEval!predicate"
        | doc "Objects that become built in functions when parsed/serialized"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^=.builtIn.[a-zA-Z0-9]+$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dataIn =
                                _js2n__-refsenv."_js2n__-:definitions/DataIn!predicate",
                              dataOut =
                                _js2n__-refsenv."_js2n__-:definitions/DataOut!predicate",
                            } {} true _js2n__-prdslib.always
                        ],
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Color!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^(0x)[a-zA-Z0-9]+$"
            ],
      "_js2n__-:definitions/Component!predicate"
        | doc "Components are the building blocks that construct to user interfaces"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  audioStream = _js2n__-prdslib.isType '"Bool",
                  borderRadius =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  children =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Component!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/Reference!predicate"
                              ])
                        ],
                  contentType =
                    _js2n__-refsenv."_js2n__-:definitions/ContentType!predicate",
                  dataKey =
                    _js2n__-refsenv."_js2n__-:definitions/DataKey!predicate",
                  ecosObj = _js2n__-prdslib.isType '"String",
                  global =
                    _js2n__-refsenv."_js2n__-:definitions/Boolean!predicate",
                  image = _js2n__-prdslib.isType '"String",
                  imgPath = _js2n__-prdslib.isType '"String",
                  isEdit =
                    _js2n__-refsenv."_js2n__-:definitions/Boolean!predicate",
                  isEditable =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Boolean!predicate",
                          _js2n__-prdslib.isType '"String"
                        ],
                  itemObject = _js2n__-prdslib.isType '"String",
                  iteratorVar = _js2n__-prdslib.isType '"String",
                  listObject =
                    _js2n__-prdslib.anyOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Empty!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/Reference!predicate",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  onBlur =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onChange =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onClick =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onEvent = _js2n__-prdslib.isType '"String",
                  onFocus =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onHover =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onInput =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onMouseEnter =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onMouseLeave =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onMouseOut =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  onMouseOver =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/UserEvent!predicate"
                        ],
                  options =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Array"
                        ],
                  overflow = _js2n__-prdslib.isType '"String",
                  path = _js2n__-refsenv."_js2n__-:definitions/Path!predicate",
                  placeholder =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/If!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  emit =
                                    _js2n__-refsenv."_js2n__-:definitions/Emit!predicate",
                                } {} true _js2n__-prdslib.always
                            ]
                        ],
                  popUpView = _js2n__-prdslib.isType '"String",
                  postMessage = _js2n__-prdslib.isType '"Array",
                  poster = _js2n__-prdslib.isType '"String",
                  required =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  resource = _js2n__-prdslib.isType '"String",
                  style =
                    _js2n__-refsenv."_js2n__-:definitions/Style!predicate",
                  text = _js2n__-refsenv."_js2n__-:definitions/Text!predicate",
                  "text=func" = _js2n__-prdslib.isType '"String",
                  textAlign =
                    _js2n__-refsenv."_js2n__-:definitions/TextAlign!predicate",
                  textBoard =
                    _js2n__-refsenv."_js2n__-:definitions/TextBoard!predicate",
                  type =
                    _js2n__-refsenv."_js2n__-:definitions/ComponentType!predicate",
                  videoFormat = _js2n__-prdslib.isType '"String",
                  videoStream = _js2n__-prdslib.isType '"Bool",
                  viewTag =
                    _js2n__-refsenv."_js2n__-:definitions/ViewTag!predicate",
                  zIndex = _js2n__-prdslib.isType '"Number",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/ComponentType!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/ConfigVersionObjectByDevice!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  cadlVersion =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              stable = _js2n__-prdslib.isType '"String",
                              test = _js2n__-prdslib.isType '"String",
                            } {} true _js2n__-prdslib.always
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ContentType!predicate"
        | doc "Determines the content type of the component. For example, a textField component may be a date textField if it has contentType: date, or a password textField with contentType: password, etc"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/DataIn!predicate"
        | doc "Argument(s) to the surrounding built in function"
        = _js2n__-refsenv."_js2n__-:definitions/Value!predicate",
      "_js2n__-:definitions/DataKey!predicate"
        | doc "A value/pointer to a a property of an object"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-refsenv."_js2n__-:definitions/DataKeyString!predicate",
              _js2n__-refsenv."_js2n__-:definitions/DataKeyObject!predicate"
            ],
      "_js2n__-:definitions/DataKeyObject!predicate"
        | doc "Data key in the emit object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                { "^[a-zA-Z0-9]+$" = _js2n__-prdslib.isType 'Record, } true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/DataKeyString!predicate"
        | doc "The path to a data object or value. It might provide a different behavior depending on where it is placed. For example, a dataKey set on a textField component will bind its value to the path in the dataKey, enabling it to mutate the value while updating textField's value"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/DataObject!predicate"
        | doc "An object that contains data. It is most commonly used in actions such as updateObject as a way to update its data values"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/DataOut!predicate"
        | doc "Return value(s) to the surrounding built in function"
        = _js2n__-refsenv."_js2n__-:definitions/Value!predicate",
      "_js2n__-:definitions/Emit!predicate"
        | doc "An emit is a special type of action that usually contains a dataKey paired with a list of actions that are called in order. Some emits can contain just a list of actions. When paired with a dataKey it is usually mutating the value at the path in the dataKey"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "actions" ],
              _js2n__-prdslib.records.record
                {
                  actions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-refsenv."_js2n__-:definitions/Action!predicate",
                                _js2n__-refsenv."_js2n__-:definitions/BuiltInEval!predicate"
                              ])
                        ],
                  dataKey =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/Empty!predicate"
        | doc "Empty value (empty string)"
        = _js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType '"String", _js2n__-prdslib.const "" ],
      "_js2n__-:definitions/Goto!predicate"
        | doc "The destination the user should navigate to"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-refsenv."_js2n__-:definitions/GotoObject!predicate"
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-refsenv."_js2n__-:definitions/GotoPageComponentUrl!predicate"
                    ]
                ],
              _js2n__-prdslib.not (_js2n__-prdslib.isType '"Number")
            ],
      "_js2n__-:definitions/GotoObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { destination = _js2n__-prdslib.isType '"String", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/GotoPageComponentUrl!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern
                "[a-zA-Z0-9]+@[a-zA-Z0-9]+#[a-zA-Z0-9]+"
            ],
      "_js2n__-:definitions/If!predicate"
        | doc "If objects contain an array with three items used for conditional checks. The first item is used as a test for truthiness which can be in the form of any data type such as a string, number, boolean, object, etc. Either the second or third item is returned depending on the result of the truthiness test"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "if" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Value!predicate",
                          _js2n__-prdslib.arrays.maxItems 3,
                          _js2n__-prdslib.arrays.minItems 3
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Init!predicate"
        | doc "One or more action(s) which will occur when entering a page"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/If!predicate",
                        _js2n__-prdslib.isType '"String",
                        _js2n__-refsenv."_js2n__-:definitions/Goto!predicate",
                        _js2n__-prdslib.allOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.const [ "" ]
                          ]
                      ])
                ],
              _js2n__-refsenv."_js2n__-:definitions/MixedActionChain!predicate"
            ],
      "_js2n__-:definitions/LocalEvalReference!predicate"
        | doc "Mutates the value at the referenced path after receiving its result"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^=[.][.][a-zA-Z0-9]+.*$"
            ],
      "_js2n__-:definitions/LocalReference!predicate"
        | doc "A reference whose scope is within the page object, making them invisible to the objects outside of its scope"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[.][.][a-zA-Z0-9]+.*$"
            ],
      "_js2n__-:definitions/MixedActionChain!predicate"
        | doc "An ActionChain but also includes the BuiltInEval objects =.builtIn.* as well as await/eval references"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-refsenv."_js2n__-:definitions/ActionChain!predicate",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"Array",
                        _js2n__-prdslib.arrays.arrayOf
                          _js2n__-refsenv."_js2n__-:definitions/BuiltInEval!predicate"
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "(=.[a-zA_Z0-9])*@$" =
                              _js2n__-refsenv."_js2n__-:definitions/Value!predicate",
                          } true _js2n__-prdslib.always
                      ]
                  ])
            ],
      "_js2n__-:definitions/NoodlUnit!predicate"
        | doc "A measurement adaptive to the size of the viewport"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Page!predicate"
        | doc "A page object"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  check = _js2n__-refsenv."_js2n__-:definitions/Init!predicate",
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/Component!predicate"
                        ],
                  init =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/Init!predicate",
                          _js2n__-prdslib.const ""
                        ],
                  module =
                    _js2n__-refsenv."_js2n__-:definitions/PageModule!predicate",
                  pageNumber =
                    _js2n__-refsenv."_js2n__-:definitions/PageNumber!predicate",
                  save = _js2n__-refsenv."_js2n__-:definitions/Init!predicate",
                  title = _js2n__-prdslib.isType '"String",
                  update =
                    _js2n__-refsenv."_js2n__-:definitions/Init!predicate",
                  viewPort = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/PageModule!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/PageNumber!predicate"
        | doc "A page number may help distinguish between pages with similar names"
        = _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/Path!predicate"
        | doc "A path can be in the form of a string, an if object, or an emit object"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-refsenv."_js2n__-:definitions/GotoPageComponentUrl!predicate"
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/BuiltInEval!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/If!predicate",
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record
                        {
                          emit =
                            _js2n__-refsenv."_js2n__-:definitions/Emit!predicate",
                        } {} true _js2n__-prdslib.always
                    ]
                ]
            ],
      "_js2n__-:definitions/Reference!predicate"
        | doc "Placeholder values that obtain their real values at a later time"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.oneOf
                [
                  _js2n__-refsenv."_js2n__-:definitions/LocalReference!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/RootReference!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/LocalEvalReference!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/RootEvalReference!predicate",
                  _js2n__-refsenv."_js2n__-:definitions/AwaitReference!predicate"
                ]
            ],
      "_js2n__-:definitions/RootConfig!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  android =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/ConfigVersionObjectByDevice!predicate"
                        ],
                  apiCheck = _js2n__-prdslib.isType 'Record,
                  apiHost = _js2n__-prdslib.isType '"String",
                  apiPort = _js2n__-prdslib.isType '"String",
                  appApiHost = _js2n__-prdslib.isType '"String",
                  cadlBaseUrl = _js2n__-prdslib.isType '"String",
                  cadlMain = _js2n__-prdslib.isType '"String",
                  cadlVersion = _js2n__-prdslib.isType 'Record,
                  connectiontimeout = _js2n__-prdslib.isType '"String",
                  debug =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType 'Record
                        ],
                  elasticClient = _js2n__-prdslib.isType 'Record,
                  ios =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-refsenv."_js2n__-:definitions/ConfigVersionObjectByDevice!predicate"
                        ],
                  isGetPosition =
                    _js2n__-refsenv."_js2n__-:definitions/Boolean!predicate",
                  keywords =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  loadingLevel = _js2n__-prdslib.isType '"Number",
                  log = _js2n__-prdslib.isType '"String",
                  myBaseUrl = _js2n__-prdslib.isType '"String",
                  searchLink = _js2n__-prdslib.isType 'Record,
                  syncHost = _js2n__-prdslib.isType '"String",
                  timestamp = _js2n__-prdslib.isType '"Number",
                  viewWidthHeightRatio =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              max = _js2n__-prdslib.isType '"Number",
                              min = _js2n__-prdslib.isType '"Number",
                            } {} true _js2n__-prdslib.always
                        ],
                  web =
                    _js2n__-refsenv."_js2n__-:definitions/ConfigVersionObjectByDevice!predicate",
                  webApiHost = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/RootEvalReference!predicate"
        | doc "Mutates the value at the root referenced path after receiving its result"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^=[.][a-zA-Z0-9]+.*$"
            ],
      "_js2n__-:definitions/RootReference!predicate"
        | doc "A reference whose scope is at the global level"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.strings.pattern "^[.][a-zA-Z0-9]+.*$"
            ],
      "_js2n__-:definitions/Style!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  align = _js2n__-prdslib.isType '"String",
                  axis = _js2n__-prdslib.isType '"String",
                  backgroundColor = _js2n__-prdslib.isType '"String",
                  border =
                    _js2n__-refsenv."_js2n__-:definitions/Border!predicate",
                  borderBottom = _js2n__-prdslib.isType '"String",
                  borderColor = _js2n__-prdslib.isType '"String",
                  borderRadius =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  borderWidth =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  boxShadow = _js2n__-prdslib.isType '"String",
                  boxSizing = _js2n__-prdslib.isType '"String",
                  color = _js2n__-prdslib.isType '"String",
                  fontFamily = _js2n__-prdslib.isType '"String",
                  fontSize =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  fontStyle = _js2n__-prdslib.isType '"String",
                  fontWeight =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"String"
                        ],
                  height =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  isEditable =
                    _js2n__-refsenv."_js2n__-:definitions/Boolean!predicate",
                  isHidden =
                    _js2n__-refsenv."_js2n__-:definitions/Boolean!predicate",
                  justifyContent = _js2n__-prdslib.isType '"String",
                  left =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  letterSpacing = _js2n__-prdslib.isType '"String",
                  lineHeight = _js2n__-prdslib.isType '"String",
                  margin =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  marginTop =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  opacity = _js2n__-prdslib.isType '"Number",
                  overflow = _js2n__-prdslib.isType '"String",
                  paddingBottom =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  paddingLeft =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  position = _js2n__-prdslib.isType '"String",
                  required = _js2n__-prdslib.isType '"String",
                  shadow =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Bool"
                        ],
                  textAlign =
                    _js2n__-refsenv."_js2n__-:definitions/TextAlign!predicate",
                  textColor =
                    _js2n__-refsenv."_js2n__-:definitions/Color!predicate",
                  textIndent = _js2n__-prdslib.isType '"String",
                  top =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  width =
                    _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
                  zIndex = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/Text!predicate"
        | doc "Used to display text in the user interface. Most commonly used in label components"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/If!predicate"
            ],
      "_js2n__-:definitions/TextAlign!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-refsenv."_js2n__-:definitions/TextAlignEnum!predicate",
              _js2n__-refsenv."_js2n__-:definitions/TextAlignObject!predicate"
            ],
      "_js2n__-:definitions/TextAlignEnum!predicate" =
        _js2n__-prdslib.isType '"String",
      "_js2n__-:definitions/TextAlignObject!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  x = _js2n__-prdslib.isType '"String",
                  y = _js2n__-prdslib.isType '"String",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/TextBoard!predicate"
        | doc "A component that contains children of text that are positioned inline (side by side)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        color = _js2n__-prdslib.isType '"String",
                        text =
                          _js2n__-refsenv."_js2n__-:definitions/Text!predicate",
                      } {} true _js2n__-prdslib.always
                  ])
            ],
      "_js2n__-:definitions/UserEvent!predicate"
        | doc "An event in the form of an ActionChain that triggers from user interactions, like onClick and onFocus"
        = _js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-refsenv."_js2n__-:definitions/Action!predicate"
                ],
              _js2n__-refsenv."_js2n__-:definitions/Reference!predicate"
            ],
      "_js2n__-:definitions/Value!predicate"
        | doc "A valid value in accordance to the noodl specification"
        = _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-refsenv."_js2n__-:definitions/NoodlUnit!predicate",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.isType '"Array",
              _js2n__-refsenv."_js2n__-:definitions/Reference!predicate",
              _js2n__-prdslib.isType 'Null,
              _js2n__-refsenv."_js2n__-:definitions/If!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      emit =
                        _js2n__-refsenv."_js2n__-:definitions/Emit!predicate",
                    } {} true _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/ViewTag!predicate"
        | doc "An identifier which is used to bind a component and an action together. Actions can define a viewTag that invokes certain behavior towards a component. The component must also contain the same viewTag key/value. If multiple components have the same viewTag, then the action will effect multiple components"
        = _js2n__-prdslib.isType '"String",
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.records.record {}
            {
              "^[a-zA-Z0-9]*$" =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-refsenv."_js2n__-:definitions/Page!predicate"
                    ],
            } true _js2n__-prdslib.always,
          _js2n__-refsenv."_js2n__-:definitions/RootConfig!predicate"
        ])