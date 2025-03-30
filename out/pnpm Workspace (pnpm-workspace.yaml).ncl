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
      "_js2n__-:definitions/catalog!predicate"
        | doc m%"
          Define dependency version ranges as reusable constants,
          for later reference in package.json files.
          This (singular) field creates a catalog named default.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always,
              _js2n__-refsenv."_js2n__-:definitions/dependency!predicate"
            ],
      "_js2n__-:definitions/dependency!predicate"
        | doc m%"
          Dependencies are specified with a simple hash of package name to version range.
          The version range is a string which has one or more space-separated descriptors.
          Dependencies can also be identified with a tarball or git URL.
          
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.propertyNames
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.maxLength 214,
                    _js2n__-prdslib.strings.minLength 1
                  ]),
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.minLength 1
                  ])
            ],
      "_js2n__-:definitions/optionalDependency!predicate"
        | doc "Specifies dependencies that are optional for your project. These dependencies are attempted to be installed during the npm install process, but if they fail to install, the installation process will not fail."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/peerDependency!predicate"
        | doc "Specifies dependencies that are required by the package but are expected to be provided by the consumer of the package."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/peerDependencyMeta!predicate"
        | doc "When a user installs your package, warnings are emitted if packages specified in \"peerDependencies\" are not already installed. The \"peerDependenciesMeta\" field serves to provide more information on how your peer dependencies are utilized. Most commonly, it allows peer dependencies to be marked as optional. Metadata for this field is specified with a simple hash of the package name to a metadata object."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      { "optional" = _js2n__-prdslib.isType '"Bool", } {} true
                      _js2n__-prdslib.always
                  ])
            ],
    }
    in
  {
      allowNonAppliedPatches
        | Bool
        | doc "When true, installation won't fail if some of the patches from the \"patchedDependencies\" field were not applied."
        | optional,
      allowedDeprecatedVersions
        | {  .. }
        | doc "A list of deprecated versions that the warnings are suppressed."
        | optional,
      auditConfig
        | {
          ignoreCves
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^CVE-\\d{4}-\\d{4,7}$"
                  ])
            )
            | doc "A list of CVE IDs that will be ignored by \"pnpm audit\"."
            | optional,
          ignoreGhsas
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^GHSA(-[23456789cfghjmpqrvwx]{4}){3}$"
                  ])
            )
            | doc "A list of GHSA Codes that will be ignored by \"pnpm audit\"."
            | optional,
        }
        | optional,
      autoInstallPeers
        | Bool
        | doc "When true, any missing non-optional peer dependencies are automatically installed."
        | optional,
      ca
        | String
        | doc "The Certificate Authority signing certificate that is trusted for SSL connections to the registry."
        | optional,
      cacheDir
        | String
        | doc "The location of the cache (package metadata and dlx)."
        | optional,
      cafile
        | String
        | doc "A path to a file containing one or multiple Certificate Authority signing certificates."
        | optional,
      catalog
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always,
              _js2n__-refsenv."_js2n__-:definitions/dependency!predicate"
            ])
        | doc m%"
          Define dependency version ranges as reusable constants,
          for later reference in package.json files.
          This (singular) field creates a catalog named default.
          
        "%
        | optional,
      catalogs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.minProperties 1,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/catalog!predicate"
            ])
        | doc "Define arbitrarily named catalogs"
        | optional,
      cert
        | String
        | doc "A client certificate to pass when accessing the registry."
        | optional,
      childConcurrency
        | Number
        | doc "The maximum number of child processes to allocate simultaneously to build node_modules."
        | optional,
      color
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "always", "auto", "never" ]
                ]
            ])
        | doc "Controls colors in the output."
        | optional,
      configDependencies
        | {  .. }
        | doc "Configurational dependencies are installed before all the other types of dependencies (before 'dependencies', 'devDependencies', 'optionalDependencies')."
        | optional,
      dedupeDirectDeps
        | Bool
        | doc "When set to true, dependencies that are already symlinked to the root node_modules directory of the workspace will not be symlinked to subproject node_modules directories."
        | optional,
      dedupeInjectedDeps
        | Bool
        | doc "When this setting is enabled, dependencies that are injected will be symlinked from the workspace whenever possible."
        | optional,
      dedupePeerDependents
        | Bool
        | doc "When this setting is set to true, packages with peer dependencies will be deduplicated after peers resolution."
        | optional,
      deployAllFiles
        | Bool
        | doc "When deploying a package or installing a local package, all files of the package are copied."
        | optional,
      disallowWorkspaceCycles
        | Bool
        | doc "When set to true, installation will fail if the workspace has cycles."
        | optional,
      dlxCacheMaxAge
        | Number
        | doc "The time in minutes after which dlx cache expires."
        | optional,
      enableModulesDir
        | Bool
        | doc "When false, pnpm will not write any files to the modules directory (node_modules)."
        | optional,
      enablePrePostScripts
        | Bool
        | doc "When true, pnpm will run any pre/post scripts automatically."
        | optional,
      engineStrict
        | Bool
        | doc "If this is enabled, pnpm will not install any package that claims to not be compatible with the current Node version."
        | optional,
      executionEnv
        | {
          nodeVersion
            | String
            | doc "Specifies which exact Node.js version should be used for the project's runtime."
            | optional,
        }
        | optional,
      extendNodePath
        | Bool
        | doc "When false, the NODE_PATH environment variable is not set in the command shims."
        | optional,
      fetchRetries
        | Number
        | doc "How many times to retry if pnpm fails to fetch from the registry."
        | optional,
      fetchRetryFactor
        | Number
        | doc "The exponential factor for retry backoff."
        | optional,
      fetchRetryMaxtimeout
        | Number
        | doc "The maximum fallback timeout to ensure the retry factor does not make requests too long."
        | optional,
      fetchRetryMintimeout
        | Number
        | doc "The minimum (base) timeout for retrying requests."
        | optional,
      fetchTimeout
        | Number
        | doc "The maximum amount of time to wait for HTTP requests to complete."
        | optional,
      forceLegacyDeploy
        | Bool
        | doc "By default, pnpm deploy will try creating a dedicated lockfile from a shared lockfile for deployment. If this setting is set to true, the legacy deploy behavior will be used."
        | optional,
      gitBranchLockfile
        | Bool
        | doc "When set to true, the generated lockfile name after installation will be named based on the current branch name to completely avoid merge conflicts."
        | optional,
      gitChecks
        | Bool
        | doc "Check if current branch is your publish branch, clean, and up-to-date with remote."
        | optional,
      gitShallowHosts
        | Array (String)
        | doc "When fetching dependencies that are Git repositories, if the host is listed in this setting, pnpm will use shallow cloning to fetch only the needed commit, not all the history."
        | optional,
      globalBinDir
        | String
        | doc "Allows to set the target directory for the bin files of globally installed packages."
        | optional,
      globalDir
        | String
        | doc "Specify a custom directory to store global packages."
        | optional,
      globalPnpmfile
        | String
        | doc "The location of a global pnpmfile. A global pnpmfile is used by all projects during installation."
        | optional,
      hoist
        | Bool
        | doc "When true, all dependencies are hoisted to node_modules/.pnpm/node_modules."
        | optional,
      hoistPattern
        | Array (String)
        | doc "Tells pnpm which packages should be hoisted to node_modules/.pnpm/node_modules"
        | optional,
      hoistWorkspacePackages
        | Bool
        | doc "When true, packages from the workspaces are symlinked to either <workspace_root>/node_modules/.pnpm/node_modules or to <workspace_root>/node_modules depending on other hoisting settings (hoistPattern and publicHoistPattern)."
        | optional,
      httpsProxy
        | String
        | doc "A proxy to use for outgoing HTTPS requests. If the HTTPS_PROXY, https_proxy, HTTP_PROXY or http_proxy environment variables are set, their values will be used instead."
        | optional,
      ignoreCompatibilityDb
        | Bool
        | doc "During installation the dependencies of some packages are automatically patched. If you want to disable this, set this config to false."
        | optional,
      ignoreDepScripts
        | Bool
        | doc "Do not execute any scripts of the installed packages. Scripts of the projects are executed."
        | optional,
      ignorePnpmfile
        | Bool
        | doc ".pnpmfile.cjs will be ignored. Useful together with --ignore-scripts when you want to make sure that no script gets executed during install."
        | optional,
      ignoreScripts
        | Bool
        | doc "Do not execute any scripts defined in the project package.json and its dependencies."
        | optional,
      ignoreWorkspaceCycles
        | Bool
        | doc "When set to true, no workspace cycle warnings will be printed."
        | optional,
      ignoredBuiltDependencies
        | Array (String)
        | doc "A list of package names that should not be built during installation."
        | optional,
      ignoredOptionalDependencies
        | Array (String)
        | doc "A list of optional dependencies that the install should be skipped."
        | optional,
      includeWorkspaceRoot
        | Bool
        | doc "When executing commands recursively in a workspace, execute them on the root workspace project as well."
        | optional,
      injectWorkspacePackages
        | Bool
        | doc "Enables hard-linking of all local workspace dependencies instead of symlinking them."
        | optional,
      key
        | String
        | doc "A client key to pass when accessing the registry."
        | optional,
      linkWorkspacePackages
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "deep" ]
                ]
            ])
        | doc "If this is enabled, locally available packages are linked to node_modules instead of being downloaded from the registry."
        | optional,
      localAddress
        | String
        | doc "The IP address of the local interface to use when making connections to the npm registry."
        | optional,
      lockfile
        | Bool
        | doc "When set to false, pnpm won't read or generate a pnpm-lock.yaml file."
        | optional,
      lockfileIncludeTarballUrl
        | Bool
        | doc "Add the full URL to the package's tarball to every entry in pnpm-lock.yaml."
        | optional,
      loglevel
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "debug", "info", "warn", "error" ]
                ]
            ])
        | doc "Any logs at or higher than the given level will be shown. "
        | optional,
      managePackageManagerVersions
        | Bool
        | doc "When enabled, pnpm will automatically download and run the version of pnpm specified in the packageManager field of package.json."
        | optional,
      maxsockets
        | Number
        | doc "The maximum number of connections to use per origin (protocol/host/port combination)."
        | optional,
      mergeGitBranchLockfilesBranchPattern
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [ _js2n__-prdslib.isType '"Array", _js2n__-prdslib.isType 'Null ])
        | doc "This configuration matches the current branch name to determine whether to merge all git branch lockfile files. "
        | optional,
      modulesCacheMaxAge
        | Number
        | doc "The time in minutes after which orphan packages from the modules directory should be removed."
        | optional,
      modulesDir
        | String
        | doc "The directory in which dependencies will be installed (instead of node_modules)."
        | optional,
      networkConcurrency
        | Number
        | doc "Controls the maximum number of HTTP(S) requests to process simultaneously."
        | optional,
      neverBuiltDependencies
        | Array (String)
        | doc "A list of dependencies to run builds for."
        | optional,
      nodeLinker
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "isolated", "hoisted", "pnp" ]
                ]
            ])
        | doc "Defines what linker should be used for installing Node packages."
        | optional,
      nodeOptions
        | String
        | doc "Options to pass through to Node.js via the NODE_OPTIONS environment variable."
        | optional,
      nodeVersion
        | String
        | doc "The Node.js version to use when checking a package's engines setting."
        | optional,
      noproxy
        | String
        | doc "A comma-separated string of domain extensions that a proxy should not be used for."
        | optional,
      npmPath
        | String
        | doc "The location of the npm binary that pnpm uses for some actions, like publishing."
        | optional,
      onlyBuiltDependencies
        | Array (String)
        | doc "A list of package names that are allowed to be executed during installation."
        | optional,
      onlyBuiltDependenciesFile
        | String
        | doc "Specifies a JSON file that lists the only packages permitted to run installation scripts during the pnpm install process."
        | optional,
      optimisticRepeatInstall
        | Bool
        | doc "When enabled, a fast check will be performed before proceeding to installation. This way a repeat install or an install on a project with everything up-to-date becomes a lot faster."
        | optional,
      overrides
        | {  .. }
        | doc "Used to override any dependency in the dependency graph."
        | optional,
      packageExtensions
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^.+$" =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              dependencies =
                                _js2n__-refsenv."_js2n__-:definitions/dependency!predicate",
                              optionalDependencies =
                                _js2n__-refsenv."_js2n__-:definitions/optionalDependency!predicate",
                              peerDependencies =
                                _js2n__-refsenv."_js2n__-:definitions/peerDependency!predicate",
                              peerDependenciesMeta =
                                _js2n__-refsenv."_js2n__-:definitions/peerDependencyMeta!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } false _js2n__-prdslib.never
            ])
        | doc "Used to extend the existing package definitions with additional information."
        | optional,
      packageImportMethod
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [ "auto", "hardlink", "copy", "clone", "clone-or-copy" ]
                ]
            ])
        | doc "Controls the way packages are imported from the store (if you want to disable symlinks inside node_modules, then you need to change the nodeLinker setting, not this one)."
        | optional,
      packageManagerStrict
        | Bool
        | doc "If this setting is disabled, pnpm will not fail if a different package manager is specified in the packageManager field of package.json. When enabled, only the package name is checked (since pnpm v9.2.0), so you can still run any version of pnpm regardless of the version specified in the packageManager field."
        | optional,
      packageManagerStrictVersion
        | Bool
        | doc "When enabled, pnpm will fail if its version doesn't exactly match the version specified in the packageManager field of package.json."
        | optional,
      packages
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String"),
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.arrays.uniqueItems
            ])
        | doc "Workspace package paths. Glob patterns are supported"
        | optional,
      patchedDependencies
        | {  .. }
        | doc "A list of dependencies that are patched."
        | optional,
      patchesDir
        | String
        | doc "The generated patch file will be saved to this directory."
        | optional,
      peerDependencyRules
        | {
          allowAny
            | Array (String)
            | doc "Any peer dependency matching the pattern will be resolved from any version, regardless of the range specified in \"peerDependencies\"."
            | optional,
          allowedVersions
            | {  .. }
            | doc "Unmet peer dependency warnings will not be printed for peer dependencies of the specified range."
            | optional,
          ignoreMissing
            | Array (String)
            | doc "pnpm will not print warnings about missing peer dependencies from this list."
            | optional,
        }
        | optional,
      peersSuffixMaxLength
        | Number
        | doc "Max length of the peer IDs suffix added to dependency keys in the lockfile. If the suffix is longer, it is replaced with a hash."
        | optional,
      pnpmfile | String | doc "The location of the local pnpmfile." | optional,
      preferFrozenLockfile
        | Bool
        | doc "When set to true and the available pnpm-lock.yaml satisfies the package.json dependencies directive, a headless installation is performed."
        | optional,
      preferSymlinkedExecutables
        | Bool
        | doc "Create symlinks to executables in node_modules/.bin instead of command shims. This setting is ignored on Windows, where only command shims work."
        | optional,
      preferWorkspacePackages
        | Bool
        | doc "If this is enabled, local packages from the workspace are preferred over packages from the registry, even if there is a newer version of the package in the registry."
        | optional,
      proxy
        | String
        | doc "A proxy to use for outgoing http requests. If the HTTP_PROXY or http_proxy environment variables are set, proxy settings will be honored by the underlying request library."
        | optional,
      publicHoistPattern
        | Array (String)
        | doc "Unlike hoistPattern, which hoists dependencies to a hidden modules directory inside the virtual store, publicHoistPattern hoists dependencies matching the pattern to the root modules directory."
        | optional,
      publishBranch
        | String
        | doc "The primary branch of the repository which is used for publishing the latest changes."
        | optional,
      recursiveInstall
        | Bool
        | doc "If this is enabled, the primary behaviour of pnpm install becomes that of pnpm install -r, meaning the install is performed on all workspace or subdirectory packages."
        | optional,
      registry
        | String
        | doc "The base URL of the npm package registry (trailing slash included)."
        | optional,
      registrySupportsTimeField
        | Bool
        | doc "Set this to true if the registry that you are using returns the \"time\" field in the abbreviated metadata."
        | optional,
      requiredScripts
        | Array (String)
        | doc "A list of scripts that must exist in each project."
        | optional,
      resolutionMode
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum
                    [ "highest", "time-based", "lowest-direct" ]
                ]
            ])
        | doc "Determines how pnpm resolves dependencies, See https://pnpm.io/npmrc#resolution-mode"
        | optional,
      resolvePeersFromWorkspaceRoot
        | Bool
        | doc "When enabled, dependencies of the root workspace project are used to resolve peer dependencies of any projects in the workspace."
        | optional,
      savePrefix
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "^", "~", "" ]
                ]
            ])
        | doc "Configure how versions of packages installed to a package.json file get prefixed."
        | optional,
      saveWorkspaceProtocol
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"Bool",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.enum [ "rolling" ]
                ]
            ])
        | doc "This setting controls how dependencies that are linked from the workspace are added to package.json."
        | optional,
      scriptShell
        | String
        | doc "The shell to use for scripts run with the pnpm run command."
        | optional,
      shamefullyHoist
        | Bool
        | doc "By default, pnpm creates a semistrict node_modules, meaning dependencies have access to undeclared dependencies but modules outside of node_modules do not."
        | optional,
      sharedWorkspaceLockfile
        | Bool
        | doc "If this is enabled, pnpm creates a single pnpm-lock.yaml file in the root of the workspace."
        | optional,
      shellEmulator
        | Bool
        | doc "When true, pnpm will use a JavaScript implementation of a bash-like shell to execute scripts."
        | optional,
      sideEffectsCache
        | Bool
        | doc "Use and cache the results of (pre/post)install hooks."
        | optional,
      sideEffectsCacheReadonly
        | Bool
        | doc "Only use the side effects cache if present, do not create it for new packages."
        | optional,
      stateDir
        | String
        | doc "The location where all the packages are saved on the disk."
        | optional,
      storeDir
        | String
        | doc "The location where all the packages are saved on the disk."
        | optional,
      strictDepBuilds
        | Bool
        | doc "When strictDepBuilds is enabled, the installation will exit with a non-zero exit code if any dependencies have unreviewed build scripts (aka postinstall scripts)."
        | optional,
      strictPeerDependencies
        | Bool
        | doc "If this is enabled, commands will fail if there is a missing or invalid peer dependency in the tree."
        | optional,
      strictSsl
        | Bool
        | doc "Whether or not to do SSL key validation when making requests to the registry via HTTPS."
        | optional,
      strictStorePkgContentCheck
        | Bool
        | doc "Some registries allow the exact same content to be published under different package names and/or versions. "
        | optional,
      supportedArchitectures
        | {
          cpu | Array (String) | optional,
          libc | Array (String) | optional,
          os | Array (String) | optional,
        }
        | doc "Specifies architectures for which you'd like to install optional dependencies, even if they don't match the architecture of the system running the install."
        | optional,
      symlink
        | Bool
        | doc "When symlink is set to false, pnpm creates a virtual store directory without any symlinks. It is a useful setting together with nodeLinker=pnp."
        | optional,
      syncInjectedDepsAfterScripts
        | Bool
        | doc "Injected workspace dependencies are collections of hardlinks, which don't add or remove the files when their sources change."
        | optional,
      tag
        | String
        | doc "If you pnpm add a package and you don't provide a specific version, then it will install the package at the version registered under the tag from this setting."
        | optional,
      unsafePerm
        | Bool
        | doc "Set to true to enable UID/GID switching when running package scripts. If set explicitly to false, then installing as a non-root user will fail."
        | optional,
      updateConfig
        | {
          ignoreDependencies
            | Array (String)
            | doc "A list of packages that should be ignored when running \"pnpm outdated\" or \"pnpm update --latest\"."
            | optional,
        }
        | optional,
      updateNotifier
        | Bool
        | doc "When true, pnpm will check for updates to the installed packages and notify the user."
        | optional,
      useBetaCli
        | Bool
        | doc "Experimental option that enables beta features of the CLI."
        | optional,
      useNodeVersion
        | String
        | doc "Specifies which exact Node.js version should be used for the project's runtime."
        | optional,
      useStderr
        | Bool
        | doc "When true, all the output is written to stderr."
        | optional,
      verifyDepsBeforeRun
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Bool"
                    ],
                  _js2n__-prdslib.enum
                    [ "install", "warn", "error", "prompt", false ]
                ]
            ])
        | doc "This setting allows the checking of the state of dependencies before running scripts."
        | optional,
      verifyStoreIntegrity
        | Bool
        | doc "By default, if a file in the store has been modified, the content of this file is checked before linking it to a project's node_modules. "
        | optional,
      virtualStoreDir
        | String
        | doc "The directory with links to the store."
        | optional,
      virtualStoreDirMaxLength
        | Number
        | doc "Sets the maximum allowed length of directory names inside the virtual store directory (node_modules/.pnpm)."
        | optional,
    }