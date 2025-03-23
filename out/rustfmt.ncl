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
      array_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width of an array literal before falling back to vertical formatting.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `array_width` will take precedence.
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      attr_fn_like_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width of the args of a function-like attributes before falling back to vertical formatting.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `attr_fn_like_width` will take precedence.
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      binop_separator
        | std.enum.TagOrString
        | [| 'Back, 'Front |]
        | doc m%"
          Where to put a binary operator when a binary expression goes multiline.
          
          Stable: No (tracking issue: [#3368](https://github.com/rust-lang/rustfmt/issues/3368))
          
          
          #### `"Front"` (default):
          
          ```rust
          fn main() {
              let or = foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo
                  || barbarbarbarbarbarbarbarbarbarbarbarbarbarbarbar;
          
              let sum = 123456789012345678901234567890
                  + 123456789012345678901234567890
                  + 123456789012345678901234567890;
          
              let range = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
                  ..bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb;
          }
          ```
          
          #### `"Back"`:
          
          ```rust
          fn main() {
              let or = foofoofoofoofoofoofoofoofoofoofoofoofoofoofoofoo ||
                  barbarbarbarbarbarbarbarbarbarbarbarbarbarbarbar;
          
              let sum = 123456789012345678901234567890 +
                  123456789012345678901234567890 +
                  123456789012345678901234567890;
          
              let range = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa..
                  bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb;
          }
          ```
        "%
        | optional,
      blank_lines_lower_bound
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Minimum number of blank lines which must be put between items. If two items have fewer blank lines between
          them, additional blank lines are inserted.
          
          Possible values: *unsigned integer*
          
          Stable: No (tracking issue: [#3382](https://github.com/rust-lang/rustfmt/issues/3382))
          
          
          ### Example
          Original Code (rustfmt will not change it with the default value of `0`):
          
          ```rust
          #![rustfmt::skip]
          
          fn foo() {
              println!("a");
          }
          fn bar() {
              println!("b");
              println!("c");
          }
          ```
          
          #### `1`
          ```rust
          fn foo() {
          
              println!("a");
          }
          
          fn bar() {
          
              println!("b");
          
              println!("c");
          }
          ```
        "%
        | optional,
      blank_lines_upper_bound
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum number of blank lines which can be put between items. If more than this number of consecutive empty
          lines are found, they are trimmed down to match this integer.
          
          Possible values: any non-negative integer
          
          Stable: No (tracking issue: [#3381](https://github.com/rust-lang/rustfmt/issues/3381))
          
          
          ### Example
          Original Code:
          
          ```rust
          #![rustfmt::skip]
          
          fn foo() {
              println!("a");
          }
          
          
          
          fn bar() {
              println!("b");
          
          
              println!("c");
          }
          ```
          
          #### `1` (default):
          ```rust
          fn foo() {
              println!("a");
          }
          
          fn bar() {
              println!("b");
          
              println!("c");
          }
          ```
          
          #### `2`:
          ```rust
          fn foo() {
              println!("a");
          }
          
          
          fn bar() {
              println!("b");
          
          
              println!("c");
          }
          ```
          
          See also: `blank_lines_lower_bound`
        "%
        | optional,
      brace_style
        | std.enum.TagOrString
        | [| 'SameLineWhere, 'PreferSameLine, 'AlwaysNextLine |]
        | doc m%"
          Brace style for items
          
          Stable: No (tracking issue: [#3376](https://github.com/rust-lang/rustfmt/issues/3376))
          
          
          ### Functions
          
          #### `"SameLineWhere"` (default):
          
          ```rust
          fn lorem() {
              // body
          }
          
          fn lorem(ipsum: usize) {
              // body
          }
          
          fn lorem<T>(ipsum: T)
          where
              T: Add + Sub + Mul + Div,
          {
              // body
          }
          ```
          
          #### `"AlwaysNextLine"`:
          
          ```rust
          fn lorem()
          {
              // body
          }
          
          fn lorem(ipsum: usize)
          {
              // body
          }
          
          fn lorem<T>(ipsum: T)
          where
              T: Add + Sub + Mul + Div,
          {
              // body
          }
          ```
          
          #### `"PreferSameLine"`:
          
          ```rust
          fn lorem() {
              // body
          }
          
          fn lorem(ipsum: usize) {
              // body
          }
          
          fn lorem<T>(ipsum: T)
          where
              T: Add + Sub + Mul + Div, {
              // body
          }
          ```
          
          ### Structs and enums
          
          #### `"SameLineWhere"` (default):
          
          ```rust
          struct Lorem {
              ipsum: bool,
          }
          
          struct Dolor<T>
          where
              T: Eq,
          {
              sit: T,
          }
          ```
          
          #### `"AlwaysNextLine"`:
          
          ```rust
          struct Lorem
          {
              ipsum: bool,
          }
          
          struct Dolor<T>
          where
              T: Eq,
          {
              sit: T,
          }
          ```
          
          #### `"PreferSameLine"`:
          
          ```rust
          struct Lorem {
              ipsum: bool,
          }
          
          struct Dolor<T>
          where
              T: Eq, {
              sit: T,
          }
          ```
        "%
        | optional,
      chain_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width of a chain to fit on one line.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `chain_width` will take precedence.
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      color
        | std.enum.TagOrString
        | [| 'Never, 'Always, 'Auto |]
        | doc m%"
          Whether to use colored output or not.
          
          Stable: No (tracking issue: [#3385](https://github.com/rust-lang/rustfmt/issues/3385))
        "%
        | optional,
      combine_control_expr
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Combine control expressions with function calls.
          
          Stable: No (tracking issue: [#3369](https://github.com/rust-lang/rustfmt/issues/3369))
          
          
          #### `true` (default):
          
          ```rust
          fn example() {
              // If
              foo!(if x {
                  foo();
              } else {
                  bar();
              });
          
              // IfLet
              foo!(if let Some(..) = x {
                  foo();
              } else {
                  bar();
              });
          
              // While
              foo!(while x {
                  foo();
                  bar();
              });
          
              // WhileLet
              foo!(while let Some(..) = x {
                  foo();
                  bar();
              });
          
              // ForLoop
              foo!(for x in y {
                  foo();
                  bar();
              });
          
              // Loop
              foo!(loop {
                  foo();
                  bar();
              });
          }
          ```
          
          #### `false`:
          
          ```rust
          fn example() {
              // If
              foo!(
                  if x {
                      foo();
                  } else {
                      bar();
                  }
              );
          
              // IfLet
              foo!(
                  if let Some(..) = x {
                      foo();
                  } else {
                      bar();
                  }
              );
          
              // While
              foo!(
                  while x {
                      foo();
                      bar();
                  }
              );
          
              // WhileLet
              foo!(
                  while let Some(..) = x {
                      foo();
                      bar();
                  }
              );
          
              // ForLoop
              foo!(
                  for x in y {
                      foo();
                      bar();
                  }
              );
          
              // Loop
              foo!(
                  loop {
                      foo();
                      bar();
                  }
              );
          }
          ```
        "%
        | optional,
      comment_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum length of comments. No effect unless `wrap_comments = true`.
          
          Possible values: any positive integer
          
          Stable: No (tracking issue: [#3349](https://github.com/rust-lang/rustfmt/issues/3349))
          
          **Note:** A value of `0` results in `wrap_comments` being applied regardless of a line's width.
          
          #### `80` (default; comments shorter than `comment_width`):
          ```rust
          // Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          ```
          
          #### `60` (comments longer than `comment_width`):
          ```rust
          // Lorem ipsum dolor sit amet,
          // consectetur adipiscing elit.
          ```
          
          See also `wrap_comments`.
        "%
        | optional,
      condense_wildcard_suffixes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Replace strings of _ wildcards by a single .. in tuple patterns
          
          Stable: No (tracking issue: [#3384](https://github.com/rust-lang/rustfmt/issues/3384))
          
          
          #### `false` (default):
          
          ```rust
          fn main() {
              let (lorem, ipsum, _, _) = (1, 2, 3, 4);
              let (lorem, ipsum, ..) = (1, 2, 3, 4);
          }
          ```
          
          #### `true`:
          
          ```rust
          fn main() {
              let (lorem, ipsum, ..) = (1, 2, 3, 4);
          }
          ```
        "%
        | optional,
      control_brace_style
        | std.enum.TagOrString
        | [| 'ClosingNextLine, 'AlwaysSameLine, 'AlwaysNextLine |]
        | doc m%"
          Brace style for control flow constructs
          
          Stable: No (tracking issue: [#3377](https://github.com/rust-lang/rustfmt/issues/3377))
          
          
          #### `"AlwaysSameLine"` (default):
          
          ```rust
          fn main() {
              if lorem {
                  println!("ipsum!");
              } else {
                  println!("dolor!");
              }
          }
          ```
          
          #### `"AlwaysNextLine"`:
          
          ```rust
          fn main() {
              if lorem
              {
                  println!("ipsum!");
              }
              else
              {
                  println!("dolor!");
              }
          }
          ```
          
          #### `"ClosingNextLine"`:
          
          ```rust
          fn main() {
              if lorem {
                  println!("ipsum!");
              }
              else {
                  println!("dolor!");
              }
          }
          ```
        "%
        | optional,
      disable_all_formatting
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Don't reformat anything.
          
          Note that this option may be soft-deprecated in the future once the [ignore](#ignore) option is stabilized. Nightly toolchain users are encouraged to use [ignore](#ignore) instead when possible.
          
          Stable: Yes
        "%
        | optional,
      doc_comment_code_block_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Max width for code snippets included in doc comments. Only used if `format_code_in_doc_comments` is true.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: No (tracking issue: [#5359](https://github.com/rust-lang/rustfmt/issues/5359))
        "%
        | optional,
      edition
        | std.enum.TagOrString
        | [| '"2024", '"2021", '"2018", '"2015" |]
        | doc m%"
          Specifies which edition is used by the parser.
          
          Stable: Yes
          
          Rustfmt is able to pick up the edition used by reading the `Cargo.toml` file if executed
          through the Cargo's formatting tool `cargo fmt`. Otherwise, the edition needs to be specified
          in your config file:
          
          ```toml
          edition = "2018"
          ```
        "%
        | optional,
      empty_item_single_line
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Put empty-body functions and impls on a single line
          
          Stable: No (tracking issue: [#3356](https://github.com/rust-lang/rustfmt/issues/3356))
          
          
          #### `true` (default):
          
          ```rust
          fn lorem() {}
          
          impl Lorem {}
          ```
          
          #### `false`:
          
          ```rust
          fn lorem() {
          }
          
          impl Lorem {
          }
          ```
          
          See also `brace_style`, `control_brace_style`.
        "%
        | optional,
      enum_discrim_align_threshold
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          The maximum length of enum variant having discriminant, that gets vertically aligned with others.
          Variants without discriminants would be ignored for the purpose of alignment.
          
          Note that this is not how much whitespace is inserted, but instead the longest variant name that
          doesn't get ignored when aligning.
          
          Possible values: any positive integer
          
          Stable: No (tracking issue: [#3372](https://github.com/rust-lang/rustfmt/issues/3372))
          
          
          #### `0` (default):
          
          ```rust
          enum Foo {
              A = 0,
              Bb = 1,
              RandomLongVariantGoesHere = 10,
              Ccc = 71,
          }
          
          enum Bar {
              VeryLongVariantNameHereA = 0,
              VeryLongVariantNameHereBb = 1,
              VeryLongVariantNameHereCcc = 2,
          }
          ```
          
          #### `20`:
          
          ```rust
          enum Foo {
              A   = 0,
              Bb  = 1,
              RandomLongVariantGoesHere = 10,
              Ccc = 2,
          }
          
          enum Bar {
              VeryLongVariantNameHereA = 0,
              VeryLongVariantNameHereBb = 1,
              VeryLongVariantNameHereCcc = 2,
          }
          ```
        "%
        | optional,
      error_on_line_overflow
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Error if Rustfmt is unable to get all lines within `max_width`, except for comments and string
          literals. If this happens, then it is a bug in Rustfmt. You might be able to work around the bug by
          refactoring your code to avoid long/complex expressions, usually by extracting a local variable or
          using a shorter name.
          
          Stable: No (tracking issue: [#3391](https://github.com/rust-lang/rustfmt/issues/3391))
          
          See also `max_width`.
        "%
        | optional,
      error_on_unformatted
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Error if unable to get comments or string literals within `max_width`, or they are left with
          trailing whitespaces.
          
          Stable: No (tracking issue: [#3392](https://github.com/rust-lang/rustfmt/issues/3392))
        "%
        | optional,
      fn_args_layout
        | std.enum.TagOrString
        | [| 'Vertical, 'Tall, 'Compressed |]
        | doc m%"
          This option is deprecated and has been renamed to `fn_params_layout` to better communicate that
          it affects the layout of parameters in function signatures.
          
          Stable: Yes
          
          
          #### `"Tall"` (default):
          
          ```rust
          trait Lorem {
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet);
          
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet) {
                  // body
              }
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              );
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              ) {
                  // body
              }
          }
          ```
          
          #### `"Compressed"`:
          
          ```rust
          trait Lorem {
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet);
          
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet) {
                  // body
              }
          
              fn lorem(
                  ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet, consectetur: Consectetur,
                  adipiscing: Adipiscing, elit: Elit,
              );
          
              fn lorem(
                  ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet, consectetur: Consectetur,
                  adipiscing: Adipiscing, elit: Elit,
              ) {
                  // body
              }
          }
          ```
          
          #### `"Vertical"`:
          
          ```rust
          trait Lorem {
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
              );
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
              ) {
                  // body
              }
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              );
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              ) {
                  // body
              }
          }
          ```
          
          See also `fn_params_layout`
        "%
        | optional,
      fn_call_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width of the args of a function call before falling back to vertical formatting.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `fn_call_width` will take precedence.
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      fn_params_layout
        | std.enum.TagOrString
        | [| 'Vertical, 'Tall, 'Compressed |]
        | doc m%"
          Control the layout of parameters in function signatures.
          
          Stable: Yes
          
          
          #### `"Tall"` (default):
          
          ```rust
          trait Lorem {
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet);
          
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet) {
                  // body
              }
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              );
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              ) {
                  // body
              }
          }
          ```
          
          #### `"Compressed"`:
          
          ```rust
          trait Lorem {
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet);
          
              fn lorem(ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet) {
                  // body
              }
          
              fn lorem(
                  ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet, consectetur: Consectetur,
                  adipiscing: Adipiscing, elit: Elit,
              );
          
              fn lorem(
                  ipsum: Ipsum, dolor: Dolor, sit: Sit, amet: Amet, consectetur: Consectetur,
                  adipiscing: Adipiscing, elit: Elit,
              ) {
                  // body
              }
          }
          ```
          
          #### `"Vertical"`:
          
          ```rust
          trait Lorem {
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
              );
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
              ) {
                  // body
              }
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              );
          
              fn lorem(
                  ipsum: Ipsum,
                  dolor: Dolor,
                  sit: Sit,
                  amet: Amet,
                  consectetur: Consectetur,
                  adipiscing: Adipiscing,
                  elit: Elit,
              ) {
                  // body
              }
          }
          ```
        "%
        | optional,
      fn_single_line
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Put single-expression functions on a single line
          
          Stable: No (tracking issue: [#3358](https://github.com/rust-lang/rustfmt/issues/3358))
          
          
          #### `false` (default):
          
          ```rust
          fn lorem() -> usize {
              42
          }
          
          fn lorem() -> usize {
              let ipsum = 42;
              ipsum
          }
          ```
          
          #### `true`:
          
          ```rust
          fn lorem() -> usize { 42 }
          
          fn lorem() -> usize {
              let ipsum = 42;
              ipsum
          }
          ```
          
          See also `control_brace_style`.
        "%
        | optional,
      force_explicit_abi
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Always print the abi for extern items
          
          Stable: Yes
          
          **Note:** Non-"C" ABIs are always printed. If `false` then "C" is removed.
          
          #### `true` (default):
          
          ```rust
          extern "C" {
              pub static lorem: c_int;
          }
          ```
          
          #### `false`:
          
          ```rust
          extern {
              pub static lorem: c_int;
          }
          ```
        "%
        | optional,
      force_multiline_blocks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Force multiline closure and match arm bodies to be wrapped in a block
          
          Stable: No (tracking issue: [#3374](https://github.com/rust-lang/rustfmt/issues/3374))
          
          
          #### `false` (default):
          
          ```rust
          fn main() {
              result.and_then(|maybe_value| match maybe_value {
                  None => foo(),
                  Some(value) => bar(),
              });
          
              match lorem {
                  None => |ipsum| {
                      println!("Hello World");
                  },
                  Some(dolor) => foo(),
              }
          }
          ```
          
          #### `true`:
          
          ```rust
          fn main() {
              result.and_then(|maybe_value| {
                  match maybe_value {
                      None => foo(),
                      Some(value) => bar(),
                  }
              });
          
              match lorem {
                  None => {
                      |ipsum| {
                          println!("Hello World");
                      }
                  }
                  Some(dolor) => foo(),
              }
          }
          ```
        "%
        | optional,
      format_code_in_doc_comments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Format code snippet included in doc comments.
          
          Stable: No (tracking issue: [#3348](https://github.com/rust-lang/rustfmt/issues/3348))
          
          
          #### `false` (default):
          
          ```rust
          /// Adds one to the number given.
          ///
          /// # Examples
          ///
          /// ```rust
          /// let five=5;
          ///
          /// assert_eq!(
          ///     6,
          ///     add_one(5)
          /// );
          /// # fn add_one(x: i32) -> i32 {
          /// #     x + 1
          /// # }
          /// ```
          fn add_one(x: i32) -> i32 {
              x + 1
          }
          ```
          
          #### `true`
          
          ```rust
          /// Adds one to the number given.
          ///
          /// # Examples
          ///
          /// ```rust
          /// let five = 5;
          ///
          /// assert_eq!(6, add_one(5));
          /// # fn add_one(x: i32) -> i32 {
          /// #     x + 1
          /// # }
          /// ```
          fn add_one(x: i32) -> i32 {
              x + 1
          }
          ```
        "%
        | optional,
      format_generated_files
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Format generated files. A file is considered generated if any of the first several lines contain a `@generated` comment marker. The number of lines to check is configured by `generated_marker_line_search_limit`.
          
          By default, generated files are reformatted, i. e. `@generated` marker is ignored.
          This option is currently ignored for stdin (`@generated` in stdin is ignored.)
          
          Stable: No (tracking issue: [#5080](https://github.com/rust-lang/rustfmt/issues/5080))
        "%
        | optional,
      format_macro_bodies
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Format the bodies of declarative macro definitions.
          
          Stable: No (tracking issue: [#3355](https://github.com/rust-lang/rustfmt/issues/3355))
          
          
          #### `true` (default):
          
          ```rust
          macro_rules! foo {
              ($a: ident : $b: ty) => {
                  $a(42): $b;
              };
              ($a: ident $b: ident $c: ident) => {
                  $a = $b + $c;
              };
          }
          ```
          
          #### `false`:
          
          ```rust
          macro_rules! foo {
              ($a: ident : $b: ty) => { $a(42): $b; };
              ($a: ident $b: ident $c: ident) => { $a=$b+$c; };
          }
          ```
          
          See also `format_macro_matchers`.
        "%
        | optional,
      format_macro_matchers
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Format the metavariable matching patterns in macros.
          
          Stable: No (tracking issue: [#3354](https://github.com/rust-lang/rustfmt/issues/3354))
          
          
          #### `false` (default):
          
          ```rust
          macro_rules! foo {
              ($a: ident : $b: ty) => {
                  $a(42): $b;
              };
              ($a: ident $b: ident $c: ident) => {
                  $a = $b + $c;
              };
          }
          ```
          
          #### `true`:
          
          ```rust
          macro_rules! foo {
              ($a:ident : $b:ty) => {
                  $a(42): $b;
              };
              ($a:ident $b:ident $c:ident) => {
                  $a = $b + $c;
              };
          }
          ```
          
          See also `format_macro_bodies`.
        "%
        | optional,
      format_strings
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Format string literals where necessary
          
          Stable: No (tracking issue: [#3353](https://github.com/rust-lang/rustfmt/issues/3353))
          
          
          #### `false` (default):
          
          ```rust
          fn main() {
              let lorem = "ipsum dolor sit amet consectetur adipiscing elit lorem ipsum dolor sit amet consectetur adipiscing";
          }
          ```
          
          #### `true`:
          
          ```rust
          fn main() {
              let lorem = "ipsum dolor sit amet consectetur adipiscing elit lorem ipsum dolor sit amet \
                           consectetur adipiscing";
          }
          ```
          
          See also `max_width`.
        "%
        | optional,
      generated_marker_line_search_limit
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Number of lines to check for a `@generated` pragma header, starting from the top of the file. Setting this value to `0` will treat all files as non-generated. When`format_generated_files` is `true`, this option has no effect.
          
          Possible values: any positive integer
          
          Stable: No (tracking issue: [#5080](https://github.com/rust-lang/rustfmt/issues/5080))
          
          See also [format_generated_files](#format_generated_files) link here.
        "%
        | optional,
      group_imports
        | std.enum.TagOrString
        | [| 'One, 'StdExternalCrate, 'Preserve |]
        | doc m%"
          Controls the strategy for how consecutive imports are grouped together.
          
          Controls the strategy for grouping sets of consecutive imports. Imports may contain newlines between imports and still be grouped together as a single set, but other statements between imports will result in different grouping sets.
          
          Stable: No (tracking issue: [#5083](https://github.com/rust-lang/rustfmt/issues/5083))
          
          Each set of imports (one or more `use` statements, optionally separated by newlines) will be formatted independently. Other statements such as `mod ...` or `extern crate ...` will cause imports to not be grouped together.
          
          #### `Preserve` (default):
          
          Preserve the source file's import groups.
          
          ```rust
          use super::update::convert_publish_payload;
          use chrono::Utc;
          
          use alloc::alloc::Layout;
          use juniper::{FieldError, FieldResult};
          use uuid::Uuid;
          
          use std::sync::Arc;
          
          use broker::database::PooledConnection;
          
          use super::schema::{Context, Payload};
          use crate::models::Event;
          use core::f32;
          ```
          
          #### `StdExternalCrate`:
          
          Discard existing import groups, and create three groups for:
          1. `std`, `core` and `alloc`,
          2. external crates,
          3. `self`, `super` and `crate` imports.
          
          ```rust
          use alloc::alloc::Layout;
          use core::f32;
          use std::sync::Arc;
          
          use broker::database::PooledConnection;
          use chrono::Utc;
          use juniper::{FieldError, FieldResult};
          use uuid::Uuid;
          
          use super::schema::{Context, Payload};
          use super::update::convert_publish_payload;
          use crate::models::Event;
          ```
          
          #### `One`:
          
          Discard existing import groups, and create a single group for everything
          
          ```rust
          use super::schema::{Context, Payload};
          use super::update::convert_publish_payload;
          use crate::models::Event;
          use alloc::alloc::Layout;
          use broker::database::PooledConnection;
          use chrono::Utc;
          use core::f32;
          use juniper::{FieldError, FieldResult};
          use std::sync::Arc;
          use uuid::Uuid;
          ```
        "%
        | optional,
      hard_tabs
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Use tab characters for indentation, spaces for alignment
          
          Stable: Yes
          
          
          #### `false` (default):
          
          ```rust
          fn lorem() -> usize {
              42 // spaces before 42
          }
          ```
          
          #### `true`:
          
          ```rust
          fn lorem() -> usize {
          	42 // tabs before 42
          }
          ```
          
          See also: `tab_spaces`.
        "%
        | optional,
      hex_literal_case
        | std.enum.TagOrString
        | [| 'Lower, 'Upper, 'Preserve |]
        | doc m%"
          Control the case of the letters in hexadecimal literal values
          
          Stable: No (tracking issue: [#5081](https://github.com/rust-lang/rustfmt/issues/5081))
        "%
        | optional,
      hide_parse_errors
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          This option is deprecated and has been renamed to `show_parse_errors` to avoid confusion around the double negative default of `hide_parse_errors=false`.
          
          Stable: No (tracking issue: [#3390](https://github.com/rust-lang/rustfmt/issues/3390))
        "%
        | optional,
      ignore
        | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
        | doc m%"
          Skip formatting files and directories that match the specified pattern.
          The pattern format is the same as [.gitignore](https://git-scm.com/docs/gitignore#_pattern_format). Be sure to use Unix/forwardslash `/` style  paths. This path style will work on all platforms. Windows style paths with backslashes `\` are not supported.
          
          Default value: format every file
          
          Possible values: See an example below
          
          Stable: No (tracking issue: [#3395](https://github.com/rust-lang/rustfmt/issues/3395))
          
          
          ### Example
          
          If you want to ignore specific files, put the following to your config file:
          
          ```toml
          ignore = [
              "src/types.rs",
              "src/foo/bar.rs",
          ]
          ```
          
          If you want to ignore every file under `examples/`, put the following to your config file:
          
          ```toml
          ignore = [
              "examples",
          ]
          ```
          
          If you want to ignore every file under the directory where you put your rustfmt.toml:
          
          ```toml
          ignore = ["/"]
          ```
          
          If you want to allow specific paths that would otherwise be ignored, prefix those paths with a `!`:
          
          ```toml
          ignore = ["bar_dir/*", "!bar_dir/*/what.rs"]
          ```
          
          In this case, all files under `bar_dir` will be ignored, except files like `bar_dir/sub/what.rs`
          or `bar_dir/another/what.rs`.
        "%
        | optional,
      imports_granularity
        | std.enum.TagOrString
        | [| 'One, 'Item, 'Module, 'Crate, 'Preserve |]
        | doc m%"
          Controls how imports are structured in `use` statements. Imports will be merged or split to the configured level of granularity.
          
          Similar to other `import` related configuration options, this option operates within the bounds of user-defined groups of imports. See `group_imports` for more information on import groups.
          
          Note that rustfmt will not modify the granularity of imports containing comments if doing so could potentially lose or misplace said comments.
          
          Stable: No (tracking issue: [#4991](https://github.com/rust-lang/rustfmt/issues/4991))
          
          
          #### `Preserve` (default):
          
          Do not change the granularity of any imports and preserve the original structure written by the developer.
          
          ```rust
          use foo::b;
          use foo::b::{f, g};
          use foo::{a, c, d::e};
          use qux::{h, i};
          ```
          
          #### `Crate`:
          
          Merge imports from the same crate into a single `use` statement. Conversely, imports from different crates are split into separate statements.
          
          ```rust
          use foo::{
              a, b,
              b::{f, g},
              c,
              d::e,
          };
          use qux::{h, i};
          ```
          
          #### `Module`:
          
          Merge imports from the same module into a single `use` statement. Conversely, imports from different modules are split into separate statements.
          
          ```rust
          use foo::b::{f, g};
          use foo::d::e;
          use foo::{a, b, c};
          use qux::{h, i};
          ```
          
          #### `Item`:
          
          Flatten imports so that each has its own `use` statement.
          
          ```rust
          use foo::a;
          use foo::b;
          use foo::b::f;
          use foo::b::g;
          use foo::c;
          use foo::d::e;
          use qux::h;
          use qux::i;
          ```
          
          #### `One`:
          
          Merge all imports into a single `use` statement as long as they have the same visibility.
          
          ```rust
          pub use foo::{x, y};
          use {
              bar::{
                  a,
                  b::{self, f, g},
                  c,
                  d::e,
              },
              qux::{h, i},
          };
          ```
        "%
        | optional,
      imports_indent
        | std.enum.TagOrString
        | [| 'Visual, 'Block |]
        | doc m%"
          Indent style of imports
          
          Stable: No (tracking issue: [#3360](https://github.com/rust-lang/rustfmt/issues/3360))
          
          
          #### `"Block"` (default):
          
          ```rust
          use foo::{
              xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx, yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy,
              zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz,
          };
          ```
          
          #### `"Visual"`:
          
          ```rust
          use foo::{xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx, yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy,
                    zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz};
          ```
          
          See also: `imports_layout`.
        "%
        | optional,
      imports_layout
        | std.enum.TagOrString
        | [| 'Vertical, 'Mixed, 'HorizontalVertical, 'Horizontal |]
        | doc m%"
          Item layout inside a imports block
          
          Stable: No (tracking issue: [#3361](https://github.com/rust-lang/rustfmt/issues/3361))
          
          
          #### `"Mixed"` (default):
          
          ```rust
          use foo::{xxxxxxxxxxxxxxxxxx, yyyyyyyyyyyyyyyyyy, zzzzzzzzzzzzzzzzzz};
          
          use foo::{
              aaaaaaaaaaaaaaaaaa, bbbbbbbbbbbbbbbbbb, cccccccccccccccccc, dddddddddddddddddd,
              eeeeeeeeeeeeeeeeee, ffffffffffffffffff,
          };
          ```
          
          #### `"Horizontal"`:
          
          **Note**: This option forces all imports onto one line and may exceed `max_width`.
          
          ```rust
          use foo::{xxx, yyy, zzz};
          
          use foo::{aaa, bbb, ccc, ddd, eee, fff};
          ```
          
          #### `"HorizontalVertical"`:
          
          ```rust
          use foo::{xxxxxxxxxxxxxxxxxx, yyyyyyyyyyyyyyyyyy, zzzzzzzzzzzzzzzzzz};
          
          use foo::{
              aaaaaaaaaaaaaaaaaa,
              bbbbbbbbbbbbbbbbbb,
              cccccccccccccccccc,
              dddddddddddddddddd,
              eeeeeeeeeeeeeeeeee,
              ffffffffffffffffff,
          };
          ```
          
          #### `"Vertical"`:
          
          ```rust
          use foo::{
              xxx,
              yyy,
              zzz,
          };
          
          use foo::{
              aaa,
              bbb,
              ccc,
              ddd,
              eee,
              fff,
          };
          ```
        "%
        | optional,
      indent_style
        | std.enum.TagOrString
        | [| 'Visual, 'Block |]
        | doc m%"
          Indent on expressions or items.
          
          Stable: No (tracking issue: [#3346](https://github.com/rust-lang/rustfmt/issues/3346))
          
          
          ### Array
          
          #### `"Block"` (default):
          
          ```rust
          fn main() {
              let lorem = vec![
                  "ipsum",
                  "dolor",
                  "sit",
                  "amet",
                  "consectetur",
                  "adipiscing",
                  "elit",
              ];
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn main() {
              let lorem = vec!["ipsum",
                               "dolor",
                               "sit",
                               "amet",
                               "consectetur",
                               "adipiscing",
                               "elit"];
          }
          ```
          
          ### Control flow
          
          #### `"Block"` (default):
          
          ```rust
          fn main() {
              if lorem_ipsum
                  && dolor_sit
                  && amet_consectetur
                  && lorem_sit
                  && dolor_consectetur
                  && amet_ipsum
                  && lorem_consectetur
              {
                  // ...
              }
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn main() {
              if lorem_ipsum
                 && dolor_sit
                 && amet_consectetur
                 && lorem_sit
                 && dolor_consectetur
                 && amet_ipsum
                 && lorem_consectetur
              {
                  // ...
              }
          }
          ```
          
          See also: `control_brace_style`.
          
          ### Function arguments
          
          #### `"Block"` (default):
          
          ```rust
          fn lorem() {}
          
          fn lorem(ipsum: usize) {}
          
          fn lorem(
              ipsum: usize,
              dolor: usize,
              sit: usize,
              amet: usize,
              consectetur: usize,
              adipiscing: usize,
              elit: usize,
          ) {
              // body
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn lorem() {}
          
          fn lorem(ipsum: usize) {}
          
          fn lorem(ipsum: usize,
                   dolor: usize,
                   sit: usize,
                   amet: usize,
                   consectetur: usize,
                   adipiscing: usize,
                   elit: usize) {
              // body
          }
          ```
          
          ### Function calls
          
          #### `"Block"` (default):
          
          ```rust
          fn main() {
              lorem(
                  "lorem",
                  "ipsum",
                  "dolor",
                  "sit",
                  "amet",
                  "consectetur",
                  "adipiscing",
                  "elit",
              );
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn main() {
              lorem("lorem",
                    "ipsum",
                    "dolor",
                    "sit",
                    "amet",
                    "consectetur",
                    "adipiscing",
                    "elit");
          }
          ```
          
          ### Generics
          
          #### `"Block"` (default):
          
          ```rust
          fn lorem<
              Ipsum: Eq = usize,
              Dolor: Eq = usize,
              Sit: Eq = usize,
              Amet: Eq = usize,
              Adipiscing: Eq = usize,
              Consectetur: Eq = usize,
              Elit: Eq = usize,
          >(
              ipsum: Ipsum,
              dolor: Dolor,
              sit: Sit,
              amet: Amet,
              adipiscing: Adipiscing,
              consectetur: Consectetur,
              elit: Elit,
          ) -> T {
              // body
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn lorem<Ipsum: Eq = usize,
                   Dolor: Eq = usize,
                   Sit: Eq = usize,
                   Amet: Eq = usize,
                   Adipiscing: Eq = usize,
                   Consectetur: Eq = usize,
                   Elit: Eq = usize>(
              ipsum: Ipsum,
              dolor: Dolor,
              sit: Sit,
              amet: Amet,
              adipiscing: Adipiscing,
              consectetur: Consectetur,
              elit: Elit)
              -> T {
              // body
          }
          ```
          
          #### Struct
          
          #### `"Block"` (default):
          
          ```rust
          fn main() {
              let lorem = Lorem {
                  ipsum: dolor,
                  sit: amet,
              };
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn main() {
              let lorem = Lorem { ipsum: dolor,
                                  sit: amet };
          }
          ```
          
          See also: `struct_lit_single_line`, `indent_style`.
          
          ### Where predicates
          
          #### `"Block"` (default):
          
          ```rust
          fn lorem<Ipsum, Dolor, Sit, Amet>() -> T
          where
              Ipsum: Eq,
              Dolor: Eq,
              Sit: Eq,
              Amet: Eq,
          {
              // body
          }
          ```
          
          #### `"Visual"`:
          
          ```rust
          fn lorem<Ipsum, Dolor, Sit, Amet>() -> T
              where Ipsum: Eq,
                    Dolor: Eq,
                    Sit: Eq,
                    Amet: Eq
          {
              // body
          }
          ```
        "%
        | optional,
      inline_attribute_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Write an item and its attribute on the same line if their combined width is below a threshold
          
          Possible values: any positive integer
          
          Stable: No (tracking issue: [#3343](https://github.com/rust-lang/rustfmt/issues/3343))
          
          
          ### Example
          
          #### `0` (default):
          ```rust
          #[cfg(feature = "alloc")]
          use core::slice;
          ```
          
          #### `50`:
          ```rust
          #[cfg(feature = "alloc")] use core::slice;
          ```
        "%
        | optional,
      match_arm_blocks
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Controls whether arm bodies are wrapped in cases where the first line of the body cannot fit on the same line as the `=>` operator.
          
          The Style Guide requires that bodies are block wrapped by default if a line break is required after the `=>`, but this option can be used to disable that behavior to prevent wrapping arm bodies in that event, so long as the body contains neither multiple statements nor line comments.
          
          Stable: No (tracking issue: [#3373](https://github.com/rust-lang/rustfmt/issues/3373))
          
          
          #### `true` (default):
          
          ```rust
          fn main() {
              match lorem {
                  ipsum => {
                      foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo(x)
                  }
                  dolor => println!("{}", sit),
                  sit => foo(
                      "foooooooooooooooooooooooo",
                      "baaaaaaaaaaaaaaaaaaaaaaaarr",
                      "baaaaaaaaaaaaaaaaaaaazzzzzzzzzzzzz",
                      "qqqqqqqqquuuuuuuuuuuuuuuuuuuuuuuuuuxxx",
                  ),
              }
          }
          ```
          
          #### `false`:
          
          ```rust
          fn main() {
              match lorem {
                  lorem =>
                      foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo(x),
                  ipsum => println!("{}", sit),
                  sit => foo(
                      "foooooooooooooooooooooooo",
                      "baaaaaaaaaaaaaaaaaaaaaaaarr",
                      "baaaaaaaaaaaaaaaaaaaazzzzzzzzzzzzz",
                      "qqqqqqqqquuuuuuuuuuuuuuuuuuuuuuuuuuxxx",
                  ),
              }
          }
          ```
          
          See also: `match_block_trailing_comma`.
        "%
        | optional,
      match_arm_leading_pipes
        | std.enum.TagOrString
        | [| 'Preserve, 'Never, 'Always |]
        | doc m%"
          Controls whether to include a leading pipe on match arms
          
          Stable: Yes
          
          
          #### `Never` (default):
          ```rust
          // Leading pipes are removed from this:
          // fn foo() {
          //     match foo {
          //         | "foo" | "bar" => {}
          //         | "baz"
          //         | "something relatively long"
          //         | "something really really really realllllllllllllly long" => println!("x"),
          //         | "qux" => println!("y"),
          //         _ => {}
          //     }
          // }
          
          // Becomes
          fn foo() {
              match foo {
                  "foo" | "bar" => {}
                  "baz"
                  | "something relatively long"
                  | "something really really really realllllllllllllly long" => println!("x"),
                  "qux" => println!("y"),
                  _ => {}
              }
          }
          ```
          
          #### `Always`:
          ```rust
          // Leading pipes are emitted on all arms of this:
          // fn foo() {
          //     match foo {
          //         "foo" | "bar" => {}
          //         "baz"
          //         | "something relatively long"
          //         | "something really really really realllllllllllllly long" => println!("x"),
          //         "qux" => println!("y"),
          //         _ => {}
          //     }
          // }
          
          // Becomes:
          fn foo() {
              match foo {
                  | "foo" | "bar" => {}
                  | "baz"
                  | "something relatively long"
                  | "something really really really realllllllllllllly long" => println!("x"),
                  | "qux" => println!("y"),
                  | _ => {}
              }
          }
          ```
          
          #### `Preserve`:
          ```rust
          fn foo() {
              match foo {
                  | "foo" | "bar" => {}
                  | "baz"
                  | "something relatively long"
                  | "something really really really realllllllllllllly long" => println!("x"),
                  | "qux" => println!("y"),
                  _ => {}
              }
          
              match baz {
                  "qux" => {}
                  "foo" | "bar" => {}
                  _ => {}
              }
          }
          ```
        "%
        | optional,
      match_block_trailing_comma
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Put a trailing comma after a block based match arm (non-block arms are not affected)
          
          Stable: Yes
          
          
          #### `false` (default):
          
          ```rust
          fn main() {
              match lorem {
                  Lorem::Ipsum => {
                      println!("ipsum");
                  }
                  Lorem::Dolor => println!("dolor"),
              }
          }
          ```
          
          #### `true`:
          
          ```rust
          fn main() {
              match lorem {
                  Lorem::Ipsum => {
                      println!("ipsum");
                  },
                  Lorem::Dolor => println!("dolor"),
              }
          }
          ```
          
          See also: `trailing_comma`, `match_arm_blocks`.
        "%
        | optional,
      max_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width of each line
          
          Possible values: any positive integer
          
          Stable: Yes
          
          See also `error_on_line_overflow`.
        "%
        | optional,
      merge_derives
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Merge multiple derives into a single one.
          
          Stable: Yes
          
          
          #### `true` (default):
          
          ```rust
          #[derive(Eq, PartialEq, Debug, Copy, Clone)]
          pub enum Foo {}
          ```
          
          #### `false`:
          
          ```rust
          #[derive(Eq, PartialEq, Debug, Copy, Clone)]
          pub enum Bar {}
          
          #[derive(Eq, PartialEq)]
          #[derive(Debug)]
          #[derive(Copy, Clone)]
          pub enum Foo {}
          ```
        "%
        | optional,
      merge_imports
        | std.enum.TagOrString
        | [| 'Windows, 'Unix, 'Native, 'Auto |]
        | doc m%"
          This option is deprecated. Use `imports_granularity = "Crate"` instead.
          
          - **Default value**: `false`
          - **Possible values**: `true`, `false`
          
          #### `false` (default):
          
          ```rust
          use foo::{a, c, d};
          use foo::{b, g};
          use foo::{e, f};
          ```
          
          #### `true`:
          
          ```rust
          use foo::{a, b, c, d, e, f, g};
          ```
          
          
          ## `newline_style`
          
          Unix or Windows line endings
          
          Stable: Yes
          
          
          #### `Auto` (default):
          
          The newline style is detected automatically on a per-file basis. Files
          with mixed line endings will be converted to the first detected line
          ending style.
          
          #### `Native`
          
          Line endings will be converted to `\r\n` on Windows and `\n` on all
          other platforms.
          
          #### `Unix`
          
          Line endings will be converted to `\n`.
          
          #### `Windows`
          
          Line endings will be converted to `\r\n`.
        "%
        | optional,
      normalize_comments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Convert /* */ comments to // comments where possible
          
          Stable: No (tracking issue: [#3350](https://github.com/rust-lang/rustfmt/issues/3350))
          
          
          #### `false` (default):
          
          ```rust
          // Lorem ipsum:
          fn dolor() -> usize {}
          
          /* sit amet: */
          fn adipiscing() -> usize {}
          ```
          
          #### `true`:
          
          ```rust
          // Lorem ipsum:
          fn dolor() -> usize {}
          
          // sit amet:
          fn adipiscing() -> usize {}
          ```
        "%
        | optional,
      normalize_doc_attributes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Convert `#![doc]` and `#[doc]` attributes to `//!` and `///` doc comments.
          
          Stable: No (tracking issue: [#3351](https://github.com/rust-lang/rustfmt/issues/3351))
          
          
          #### `false` (default):
          
          ```rust
          #![doc = "Example documentation"]
          
          #[doc = "Example item documentation"]
          pub enum Bar {}
          
          /// Example item documentation
          pub enum Foo {}
          ```
          
          #### `true`:
          
          ```rust
          //! Example documentation
          
          /// Example item documentation
          pub enum Foo {}
          ```
        "%
        | optional,
      overflow_delimited_expr
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          When structs, slices, arrays, and block/array-like macros are used as the last
          argument in an expression list, allow them to overflow (like blocks/closures)
          instead of being indented on a new line.
          
          Stable: No (tracking issue: [#3370](https://github.com/rust-lang/rustfmt/issues/3370))
          
          
          #### `false` (default):
          
          ```rust
          fn example() {
              foo(ctx, |param| {
                  action();
                  foo(param)
              });
          
              foo(
                  ctx,
                  Bar {
                      x: value,
                      y: value2,
                  },
              );
          
              foo(
                  ctx,
                  &[
                      MAROON_TOMATOES,
                      PURPLE_POTATOES,
                      ORGANE_ORANGES,
                      GREEN_PEARS,
                      RED_APPLES,
                  ],
              );
          
              foo(
                  ctx,
                  vec![
                      MAROON_TOMATOES,
                      PURPLE_POTATOES,
                      ORGANE_ORANGES,
                      GREEN_PEARS,
                      RED_APPLES,
                  ],
              );
          }
          ```
          
          #### `true`:
          
          ```rust
          fn example() {
              foo(ctx, |param| {
                  action();
                  foo(param)
              });
          
              foo(ctx, Bar {
                  x: value,
                  y: value2,
              });
          
              foo(ctx, &[
                  MAROON_TOMATOES,
                  PURPLE_POTATOES,
                  ORGANE_ORANGES,
                  GREEN_PEARS,
                  RED_APPLES,
              ]);
          
              foo(ctx, vec![
                  MAROON_TOMATOES,
                  PURPLE_POTATOES,
                  ORGANE_ORANGES,
                  GREEN_PEARS,
                  RED_APPLES,
              ]);
          }
          ```
        "%
        | optional,
      remove_nested_parens
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Remove nested parens.
          
          Default value: `true`,
          
          Stable: Yes
          
          
          #### `true` (default):
          ```rust
          fn main() {
              (foo());
          }
          ```
          
          #### `false`:
          ```rust
          fn main() {
              (foo());
          
              ((((foo()))));
          }
          ```
        "%
        | optional,
      reorder_impl_items
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Reorder impl items. `type` and `const` are put first, then macros and methods.
          
          Stable: No (tracking issue: [#3363](https://github.com/rust-lang/rustfmt/issues/3363))
          
          
          #### `false` (default)
          
          ```rust
          struct Dummy;
          
          impl Iterator for Dummy {
              fn next(&mut self) -> Option<Self::Item> {
                  None
              }
          
              type Item = i32;
          }
          
          impl Iterator for Dummy {
              type Item = i32;
          
              fn next(&mut self) -> Option<Self::Item> {
                  None
              }
          }
          ```
          
          #### `true`
          
          ```rust
          struct Dummy;
          
          impl Iterator for Dummy {
              type Item = i32;
          
              fn next(&mut self) -> Option<Self::Item> {
                  None
              }
          }
          ```
        "%
        | optional,
      reorder_imports
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Reorder import and extern crate statements alphabetically in groups (a group is
          separated by a newline).
          
          Stable: Yes
          
          
          #### `true` (default):
          
          ```rust
          use dolor;
          use ipsum;
          use lorem;
          use sit;
          ```
          
          #### `false`:
          
          ```rust
          use lorem;
          use ipsum;
          use dolor;
          use sit;
          ```
        "%
        | optional,
      reorder_modules
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Reorder `mod` declarations alphabetically in group.
          
          Stable: Yes
          
          
          #### `true` (default)
          
          ```rust
          mod a;
          mod b;
          
          mod dolor;
          mod ipsum;
          mod lorem;
          mod sit;
          ```
          
          #### `false`
          
          ```rust
          mod b;
          mod a;
          
          mod lorem;
          mod ipsum;
          mod dolor;
          mod sit;
          ```
          
          **Note** `mod` with `#[macro_export]` will not be reordered since that could change the semantics
          of the original source code.
        "%
        | optional,
      required_version
        | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
        | doc m%"
          Require a specific version of rustfmt. If you want to make sure that the
          specific version of rustfmt is used in your CI, use this option.
          
          Possible values: any published version (e.g. `"0.3.8"`)
          
          Stable: No (tracking issue: [#3386](https://github.com/rust-lang/rustfmt/issues/3386))
        "%
        | optional,
      short_array_element_width_threshold
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          The width threshold for an array element to be considered "short".
          
          The layout of an array is dependent on the length of each of its elements. 
          If the length of every element in an array is below this threshold (all elements are "short") then the array can be formatted in the mixed/compressed style, but if any one element has a length that exceeds this threshold then the array elements will have to be formatted vertically.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          
          #### `10` (default):
          ```rust
          fn main() {
              pub const FORMAT_TEST: [u64; 5] = [
                  0x0000000000000000,
                  0xaaaaaaaaaaaaaaaa,
                  0xbbbbbbbbbbbbbbbb,
                  0xcccccccccccccccc,
                  0xdddddddddddddddd,
              ];
          }
          ```
          #### `20`:
          ```rust
          fn main() {
              pub const FORMAT_TEST: [u64; 5] = [
                  0x0000000000000000, 0xaaaaaaaaaaaaaaaa, 0xbbbbbbbbbbbbbbbb, 0xcccccccccccccccc,
                  0xdddddddddddddddd,
              ];
          }
          ```
          See also `max_width`.
        "%
        | optional,
      show_parse_errors
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Show parse errors if the parser failed to parse files.
          
          Stable: No (tracking issue: [#5977](https://github.com/rust-lang/rustfmt/issues/5977))
        "%
        | optional,
      single_line_if_else_max_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum line length for single line if-else expressions. A value of `0` (zero) results in if-else expressions always being broken into multiple lines. Note this occurs when `use_small_heuristics` is set to `Off`.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `single_line_if_else_max_width` will take precedence.
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      single_line_let_else_max_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum line length for single line let-else statements.
          See the [let-else statement section of the Rust Style Guide](https://github.com/rust-lang/rust/blob/master/src/doc/style-guide/src/statements.md#else-blocks-let-else-statements) for more details on when a let-else statement may be written on a single line.
          A value of `0` (zero) means the divergent `else` block will always be formatted over multiple lines.
          Note this occurs when `use_small_heuristics` is set to `Off`.
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `single_line_let_else_max_width` will take precedence.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          
          #### `50` (default):
          
          ```rust
          fn main() {
              let Some(w) = opt else { return Ok(()) };
          
              let Some(x) = opt else { return };
          
              let Some(y) = opt else {
                  return;
              };
          
              let Some(z) = some_very_very_very_very_long_name else {
                  return;
              };
          }
          ```
          
          #### `0`:
          
          ```rust
          fn main() {
              let Some(w) = opt else {
                  return Ok(());
              };
          
              let Some(x) = opt else {
                  return;
              };
          
              let Some(y) = opt else {
                  return;
              };
          
              let Some(z) = some_very_very_very_very_long_name else {
                  return;
              };
          }
          ```
          
          #### `100`:
          
          ```rust
          fn main() {
              let Some(w) = opt else { return Ok(()) };
          
              let Some(x) = opt else { return };
          
              let Some(y) = opt else {
                  return;
              };
          
              let Some(z) = some_very_very_very_very_long_name else { return };
          }
          ```
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      skip_children
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Don't reformat out of line modules
          
          Stable: No (tracking issue: [#3389](https://github.com/rust-lang/rustfmt/issues/3389))
        "%
        | optional,
      skip_macro_invocations
        | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
        | doc m%"
          Skip formatting the bodies of macro invocations with the following names.
          
          rustfmt will not format any macro invocation for macros with names set in this list.
          Including the special value "*" will prevent any macro invocations from being formatted.
          
          Note: This option does not have any impact on how rustfmt formats macro definitions.
          
          Possible values: a list of macro name idents, `["name_0", "name_1", ..., "*"]`
          
          Stable: No (tracking issue: [#5346](https://github.com/rust-lang/rustfmt/issues/5346))
          
          
          #### `[]` (default):
          
          rustfmt will follow its standard approach to formatting macro invocations.
          
          No macro invocations will be skipped based on their name. More information about rustfmt's standard macro invocation formatting behavior can be found in [#5437](https://github.com/rust-lang/rustfmt/discussions/5437).
          
          ```rust
          lorem!(
              const _: u8 = 0;
          );
          
          ipsum!(
              const _: u8 = 0;
          );
          ```
          
          #### `["lorem"]`:
          
          The named macro invocations will be skipped.
          
          ```rust
          lorem!(
                  const _: u8 = 0;
          );
          
          ipsum!(
              const _: u8 = 0;
          );
          ```
          
          #### `["*"]`:
          
          The special selector `*` will skip all macro invocations.
          
          ```rust
          lorem!(
                  const _: u8 = 0;
          );
          
          ipsum!(
                  const _: u8 = 0;
          );
          ```
        "%
        | optional,
      space_after_colon
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Leave a space after the colon.
          
          Stable: No (tracking issue: [#3366](https://github.com/rust-lang/rustfmt/issues/3366))
          
          
          #### `true` (default):
          
          ```rust
          fn lorem<T: Eq>(t: T) {
              let lorem: Dolor = Lorem {
                  ipsum: dolor,
                  sit: amet,
              };
          }
          ```
          
          #### `false`:
          
          ```rust
          fn lorem<T:Eq>(t:T) {
              let lorem:Dolor = Lorem {
                  ipsum:dolor,
                  sit:amet,
              };
          }
          ```
          
          See also: `space_before_colon`.
        "%
        | optional,
      space_before_colon
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Leave a space before the colon.
          
          Stable: No (tracking issue: [#3365](https://github.com/rust-lang/rustfmt/issues/3365))
          
          
          #### `false` (default):
          
          ```rust
          fn lorem<T: Eq>(t: T) {
              let lorem: Dolor = Lorem {
                  ipsum: dolor,
                  sit: amet,
              };
          }
          ```
          
          #### `true`:
          
          ```rust
          fn lorem<T : Eq>(t : T) {
              let lorem : Dolor = Lorem {
                  ipsum : dolor,
                  sit : amet,
              };
          }
          ```
          
          See also: `space_after_colon`.
        "%
        | optional,
      spaces_around_ranges
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Put spaces around the .., ..=, and ... range operators
          
          Stable: No (tracking issue: [#3367](https://github.com/rust-lang/rustfmt/issues/3367))
          
          
          #### `false` (default):
          
          ```rust
          fn main() {
              let lorem = 0..10;
              let ipsum = 0..=10;
          
              match lorem {
                  1..5 => foo(),
                  _ => bar,
              }
          
              match lorem {
                  1..=5 => foo(),
                  _ => bar,
              }
          
              match lorem {
                  1...5 => foo(),
                  _ => bar,
              }
          }
          ```
          
          #### `true`:
          
          ```rust
          fn main() {
              let lorem = 0 .. 10;
              let ipsum = 0 ..= 10;
          
              match lorem {
                  1 .. 5 => foo(),
                  _ => bar,
              }
          
              match lorem {
                  1 ..= 5 => foo(),
                  _ => bar,
              }
          
              match lorem {
                  1 ... 5 => foo(),
                  _ => bar,
              }
          }
          ```
        "%
        | optional,
      struct_field_align_threshold
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          The maximum diff of width between struct fields to be aligned with each other.
          
          Possible values: any non-negative integer
          
          Stable: No (tracking issue: [#3371](https://github.com/rust-lang/rustfmt/issues/3371))
          
          
          #### `0` (default):
          
          ```rust
          struct Foo {
              x: u32,
              yy: u32,
              zzz: u32,
          }
          ```
          
          #### `20`:
          
          ```rust
          struct Foo {
              x:   u32,
              yy:  u32,
              zzz: u32,
          }
          ```
        "%
        | optional,
      struct_lit_single_line
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Put small struct literals on a single line
          
          Stable: No (tracking issue: [#3357](https://github.com/rust-lang/rustfmt/issues/3357))
          
          
          #### `true` (default):
          
          ```rust
          fn main() {
              let lorem = Lorem { foo: bar, baz: ofo };
          }
          ```
          
          #### `false`:
          
          ```rust
          fn main() {
              let lorem = Lorem {
                  foo: bar,
                  baz: ofo,
              };
          }
          ```
          
          See also: `indent_style`.
        "%
        | optional,
      struct_lit_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width in the body of a struct literal before falling back to vertical formatting. A value of `0` (zero) results in struct literals always being broken into multiple lines. Note this occurs when `use_small_heuristics` is set to `Off`.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `struct_lit_width` will take precedence.
          
          See also `max_width`, `use_small_heuristics`, and `struct_lit_single_line`
        "%
        | optional,
      struct_variant_width
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Maximum width in the body of a struct variant before falling back to vertical formatting. A value of `0` (zero) results in struct literals always being broken into multiple lines. Note this occurs when `use_small_heuristics` is set to `Off`.
          
          Possible values: any positive integer that is less than or equal to the value specified for `max_width`
          
          Stable: Yes
          
          By default this option is set as a percentage of `max_width` provided by `use_small_heuristics`, but a value set directly for `struct_variant_width` will take precedence.
          
          See also `max_width` and `use_small_heuristics`
        "%
        | optional,
      style_edition
        | _js2n__-prdslib.contract_from_predicate _js2n__-prdslib.always
        | doc m%"
          Controls the edition of the [Rust Style Guide] to use for formatting ([RFC 3338])
          
          Possible values: `"2015"`, `"2018"`, `"2021"`, `"2024"` (unstable variant)
          
          Stable: No
          
          [Rust Style Guide]: https://doc.rust-lang.org/nightly/style-guide/
          [RFC 3338]: https://rust-lang.github.io/rfcs/3338-style-evolution.html
        "%
        | optional,
      tab_spaces
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType 'Integer)
        | doc m%"
          Number of spaces per tab
          
          Possible values: any positive integer
          
          Stable: Yes
          
          
          #### `4` (default):
          
          ```rust
          fn lorem() {
              let ipsum = dolor();
              let sit = vec![
                  "amet consectetur adipiscing elit amet",
                  "consectetur adipiscing elit amet consectetur.",
              ];
          }
          ```
          
          #### `2`:
          
          ```rust
          fn lorem() {
            let ipsum = dolor();
            let sit = vec![
              "amet consectetur adipiscing elit amet",
              "consectetur adipiscing elit amet consectetur.",
            ];
          }
          ```
          
          See also: `hard_tabs`.
        "%
        | optional,
      trailing_comma
        | std.enum.TagOrString
        | [| 'Vertical, 'Never, 'Always |]
        | doc m%"
          How to handle trailing commas for lists
          
          Stable: No (tracking issue: [#3379](https://github.com/rust-lang/rustfmt/issues/3379))
          
          
          #### `"Vertical"` (default):
          
          ```rust
          fn main() {
              let Lorem { ipsum, dolor, sit } = amet;
              let Lorem {
                  ipsum,
                  dolor,
                  sit,
                  amet,
                  consectetur,
                  adipiscing,
              } = elit;
          }
          ```
          
          #### `"Always"`:
          
          ```rust
          fn main() {
              let Lorem { ipsum, dolor, sit, } = amet;
              let Lorem {
                  ipsum,
                  dolor,
                  sit,
                  amet,
                  consectetur,
                  adipiscing,
              } = elit;
          }
          ```
          
          #### `"Never"`:
          
          ```rust
          fn main() {
              let Lorem { ipsum, dolor, sit } = amet;
              let Lorem {
                  ipsum,
                  dolor,
                  sit,
                  amet,
                  consectetur,
                  adipiscing
              } = elit;
          }
          ```
          
          See also: `match_block_trailing_comma`.
        "%
        | optional,
      trailing_semicolon
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Add trailing semicolon after break, continue and return
          
          Stable: No (tracking issue: [#3378](https://github.com/rust-lang/rustfmt/issues/3378))
          
          
          #### `true` (default):
          ```rust
          fn foo() -> usize {
              return 0;
          }
          ```
          
          #### `false`:
          ```rust
          fn foo() -> usize {
              return 0
          }
          ```
        "%
        | optional,
      type_punctuation_density
        | std.enum.TagOrString
        | [| 'Wide, 'Compressed |]
        | doc m%"
          Determines if `+` or `=` are wrapped in spaces in the punctuation of types
          
          Stable: No (tracking issue: [#3364](https://github.com/rust-lang/rustfmt/issues/3364))
          
          
          #### `"Wide"` (default):
          
          ```rust
          fn lorem<Ipsum: Dolor + Sit = Amet>() {
              // body
          }
          ```
          
          #### `"Compressed"`:
          
          ```rust
          fn lorem<Ipsum: Dolor+Sit=Amet>() {
              // body
          }
          ```
        "%
        | optional,
      unstable_features
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Enable unstable features on the unstable channel.
          
          Stable: No (tracking issue: [#3387](https://github.com/rust-lang/rustfmt/issues/3387))
        "%
        | optional,
      use_field_init_shorthand
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Use field initialize shorthand if possible.
          
          Stable: Yes
          
          
          #### `false` (default):
          
          ```rust
          struct Foo {
              x: u32,
              y: u32,
              z: u32,
          }
          
          fn main() {
              let x = 1;
              let y = 2;
              let z = 3;
              let a = Foo { x, y, z };
              let b = Foo { x: x, y: y, z: z };
          }
          ```
          
          #### `true`:
          
          ```rust
          struct Foo {
              x: u32,
              y: u32,
              z: u32,
          }
          
          fn main() {
              let x = 1;
              let y = 2;
              let z = 3;
              let a = Foo { x, y, z };
          }
          ```
        "%
        | optional,
      use_small_heuristics
        | std.enum.TagOrString
        | [| 'Max, 'Off, 'Default |]
        | doc m%"
          This option can be used to simplify the management and bulk updates of the granular width configuration settings (`fn_call_width`, `attr_fn_like_width`, `struct_lit_width`, `struct_variant_width`, `array_width`, `chain_width`, `single_line_if_else_max_width`), that respectively control when formatted constructs are multi-lined/vertical based on width.
          
          Note that explicitly provided values for the width configuration settings take precedence and override the calculated values determined by `use_small_heuristics`.
          
          Stable: Yes
          
          
          #### `Default` (default):
          When `use_small_heuristics` is set to `Default`, the values for the granular width settings are calculated as a ratio of the value for `max_width`.
          
          The ratios are:
          * `fn_call_width` - `60%`
          * `attr_fn_like_width` - `70%`
          * `struct_lit_width` - `18%`
          * `struct_variant_width` - `35%`
          * `array_width` - `60%`
          * `chain_width` - `60%`
          * `single_line_if_else_max_width` - `50%`
          * `single_line_let_else_max_width` - `50%`
          
          For example when `max_width` is set to `100`, the width settings are:
          * `fn_call_width=60`
          * `attr_fn_like_width=70`
          * `struct_lit_width=18`
          * `struct_variant_width=35`
          * `array_width=60`
          * `chain_width=60`
          * `single_line_if_else_max_width=50`
          * `single_line_let_else_max_width=50`
          
          and when `max_width` is set to `200`:
          * `fn_call_width=120`
          * `attr_fn_like_width=140`
          * `struct_lit_width=36`
          * `struct_variant_width=70`
          * `array_width=120`
          * `chain_width=120`
          * `single_line_if_else_max_width=100`
          * `single_line_let_else_max_width=100`
          
          ```rust
          enum Lorem {
              Ipsum,
              Dolor(bool),
              Sit { amet: Consectetur, adipiscing: Elit },
          }
          
          fn main() {
              lorem(
                  "lorem",
                  "ipsum",
                  "dolor",
                  "sit",
                  "amet",
                  "consectetur",
                  "adipiscing",
              );
          
              let lorem = Lorem {
                  ipsum: dolor,
                  sit: amet,
              };
              let lorem = Lorem { ipsum: dolor };
          
              let lorem = if ipsum { dolor } else { sit };
          }
          ```
          
          #### `Off`:
          When `use_small_heuristics` is set to `Off`, the granular width settings are functionally disabled and ignored. See the documentation for the respective width config options for specifics.
          
          ```rust
          enum Lorem {
              Ipsum,
              Dolor(bool),
              Sit {
                  amet: Consectetur,
                  adipiscing: Elit,
              },
          }
          
          fn main() {
              lorem("lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing");
          
              let lorem = Lorem {
                  ipsum: dolor,
                  sit: amet,
              };
          
              let lorem = if ipsum {
                  dolor
              } else {
                  sit
              };
          }
          ```
          
          #### `Max`:
          When `use_small_heuristics` is set to `Max`, then each granular width setting is set to the same value as `max_width`.
          
          So if `max_width` is set to `200`, then all the width settings are also set to `200`.
          * `fn_call_width=200`
          * `attr_fn_like_width=200`
          * `struct_lit_width=200`
          * `struct_variant_width=200`
          * `array_width=200`
          * `chain_width=200`
          * `single_line_if_else_max_width=200`
          * `single_line_let_else_max_width=200`
          
          ```rust
          enum Lorem {
              Ipsum,
              Dolor(bool),
              Sit { amet: Consectetur, adipiscing: Elit },
          }
          
          fn main() {
              lorem("lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing");
          
              let lorem = Lorem { ipsum: dolor, sit: amet };
          
              let lorem = if ipsum { dolor } else { sit };
          }
          ```
          
          
          See also:
          * `max_width`
          * `fn_call_width`
          * `attr_fn_like_width`
          * `struct_lit_width`
          * `struct_variant_width`
          * `array_width`
          * `chain_width`
          * `single_line_if_else_max_width`
          * `single_line_let_else_max_width`
        "%
        | optional,
      use_try_shorthand
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Replace uses of the try! macro by the ? shorthand
          
          Stable: Yes
          
          
          #### `false` (default):
          
          ```rust
          fn main() {
              let lorem = ipsum.map(|dolor| dolor.sit())?;
          
              let lorem = try!(ipsum.map(|dolor| dolor.sit()));
          }
          ```
          
          #### `true`:
          
          ```rust
          fn main() {
              let lorem = ipsum.map(|dolor| dolor.sit())?;
          }
          ```
        "%
        | optional,
      version
        | std.enum.TagOrString
        | [| 'Two, 'One |]
        | doc m%"
          This option is deprecated and has been replaced by `style_edition`.
          `version = "One"` is equivalent to `style_edition = "(2015|2018|2021)"` and
          `version = "Two"` is equivalent to `style_edition = "2024"`
          
          Stable: No (tracking issue: [#3383](https://github.com/rust-lang/rustfmt/issues/3383))
          
          
          ### Example
          
          ```toml
          version = "Two"
          ```
        "%
        | optional,
      where_single_line
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Forces the `where` clause to be laid out on a single line.
          
          Stable: No (tracking issue: [#3359](https://github.com/rust-lang/rustfmt/issues/3359))
          
          
          #### `false` (default):
          
          ```rust
          impl<T> Lorem for T
          where
              Option<T>: Ipsum,
          {
              // body
          }
          ```
          
          #### `true`:
          
          ```rust
          impl<T> Lorem for T
          where Option<T>: Ipsum
          {
              // body
          }
          ```
          
          See also `brace_style`, `control_brace_style`.
        "%
        | optional,
      wrap_comments
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.isType '"Bool")
        | doc m%"
          Break comments to fit on the line
          
          Note that no wrapping will happen if:
          1. The comment is the start of a markdown header doc comment
          2. An URL was found in the comment
          
          Stable: No (tracking issue: [#3347](https://github.com/rust-lang/rustfmt/issues/3347))
          
          
          #### `false` (default):
          
          ```rust
          // Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          // sed do eiusmod tempor incididunt ut labore et dolore
          // magna aliqua. Ut enim ad minim veniam, quis nostrud
          // exercitation ullamco laboris nisi ut aliquip ex ea
          // commodo consequat.
          
          // Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
          
          // Information on the lorem ipsum can be found at the following url: https://en.wikipedia.org/wiki/Lorem_ipsum. Its text is: lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
          
          /// # This doc comment is a very long header (it starts with a '#'). Had it not been a header it would have been wrapped. But because it is a header, it will not be. That is because wrapping a markdown header breaks it.
          struct Foo {}
          ```
          
          #### `true`:
          
          ```rust
          // Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          // sed do eiusmod tempor incididunt ut labore et dolore
          // magna aliqua. Ut enim ad minim veniam, quis nostrud
          // exercitation ullamco laboris nisi ut aliquip ex ea
          // commodo consequat.
          
          // Lorem ipsum dolor sit amet, consectetur adipiscing elit,
          // sed do eiusmod tempor incididunt ut labore et dolore
          // magna aliqua. Ut enim ad minim veniam, quis nostrud
          // exercitation ullamco laboris nisi ut aliquip ex ea
          // commodo consequat.
          
          // Information on the lorem ipsum can be found at the following url: https://en.wikipedia.org/wiki/Lorem_ipsum. Its text is: lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
          
          /// # This doc comment is a very long header (it starts with a '#'). Had it not been a header it would have been wrapped. But because it is a header, it will not be. That is because wrapping a markdown header breaks it.
          struct Foo {}
          ```
        "%
        | optional,
      ..
    }