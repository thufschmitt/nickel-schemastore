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
      "_js2n__-:definitions/enum_monitoring_commands!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'RELEASE_UPDATES,
                'UNUSED_LICENSES,
                'MISSING_ATTRIBUTES,
                'METADATA_STATUS,
                'UNUSED_METADATAS,
                'LINT_ACCESS,
                'LEGACY_API,
                'AUDIT_TRAIL
              |]
            ],
      "_js2n__-:definitions/enum_notification_types!contract" =
        std.contract.Sequence
            [
              std.enum.TagOrString,
              [|
                'RELEASE_UPDATES,
                'UNUSED_LICENSES,
                'MISSING_ATTRIBUTES,
                'METADATA_STATUS,
                'UNUSED_METADATAS,
                'LINT_ACCESS,
                'LEGACY_API,
                'DEPLOYMENT,
                'BACKUP,
                'APEX_TESTS,
                'AUDIT_TRAIL
              |]
            ],
    }
    in
  {
      allowedOrgTypes
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.enum [ "sandbox", "scratch" ]
                  ])
            ])
        | doc "Types of orgs allowed for config & development. If not set, sandbox and scratch are allowed by default"
        | optional,
      apexTestsMinCoverageOrgWide
        | Number
        | doc "Minimum percentage of apex code coverage accepted"
        | optional,
      autoCleanTypes
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
                        "caseentitlement",
                        "checkPermissions",
                        "dashboards",
                        "datadotcom",
                        "destructivechanges",
                        "flowPositions",
                        "localfields",
                        "listViewsMine",
                        "minimizeProfiles",
                        "productrequest",
                        "sensitiveMetadatas",
                        "systemDebug",
                        "v60"
                      ]
                  ])
            ])
        | doc "When saving a sfdx-hardis task, the list of cleanings will be automatically applied to sfdx sources"
        | optional,
      autoRemoveUserPermissions
        | Array (String)
        | doc "When saving a sfdx-hardis task, these permissions will be removed from profiles"
        | optional,
      autoRetrieveWhenPull
        | Array (String)
        | doc "When calling hardis:scratch:pull, if you define metadatas (named or not), they will also be retrieved using force:source:retrieve"
        | optional,
      availableProjects
        | Array (String)
        | doc "List of business projects that are managed in the same repository. Will be used to build git branch name when using hardis:work:new"
        | optional,
      availableTargetBranches
        | Array (String)
        | doc "List of git branches that can be used as target for merge requests"
        | optional,
      branchPrefixChoices
        | Array Dyn
        | doc "When calling hardis:work:new, you can override the default branch prefixes. Input title, value and description for each of them"
        | optional,
      cleanXmlPatterns
        | Array
          {
            globPattern
              | String
              | doc "Glob pattern to identify XML files to clean",
            xpaths
              | Array (String)
              | doc "XPaths to identify elements to remove",
          }
        | doc "List of patterns to automatically clean XML files"
        | optional,
      commandsPostDeploy
        | Array
          {
            command | String | doc "Command line to run",
            context
              | std.enum.TagOrString
              | [| 'process-deployment-only, 'check-deployment-only, 'all |]
              | doc "Context when the command must be run"
              | optional,
            id | String | doc "Identifier of the command (can be any string)",
            label | String | doc "Label of the command (what does it do ?)",
            skipIfError
              | Bool
              | doc "Do not run the command if there is a deployment error"
              | optional,
          }
        | doc "List of commands to run after a deployment"
        | optional,
      commandsPreDeploy
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        command = _js2n__-prdslib.isType '"String",
                        id = _js2n__-prdslib.isType '"String",
                        label = _js2n__-prdslib.isType '"String",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.records.required [ "command", "id", "label" ],
              _js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always
            ])
        | doc "List of commands to run before a deployment"
        | optional,
      customCommands
        | Array
          {
            commands
              | Array
                {
                  command
                    | String
                    | doc "Command line to run when clicking on the menu",
                  helpUrl
                    | String
                    | doc "URL for help page of the command"
                    | optional,
                  icon
                    | String
                    | doc "Icon (can be any of svg icons of this list: https://github.com/hardisgroupcom/vscode-sfdx-hardis/tree/master/resources"
                    | optional,
                  id
                    | String
                    | doc "Identifier of the command (can be any string)",
                  label
                    | String
                    | doc "Label of the command that will appear in menu",
                  tooltip
                    | String
                    | doc "Text that will appear when user will hover the command"
                    | optional,
                }
              | doc "List of commands of the menu"
              | optional,
            id | String | doc "Identifier of the menu (can be any string)",
            label | String | doc "Label of the menu",
          }
        | doc "List of custom commands for VsCode SFDX-Hardis extension"
        | optional,
      customCommandsPosition
        | std.enum.TagOrString
        | [| 'last, 'first |]
        | doc "Position of custom commands in the menu (first or last)"
        | optional,
      customOrgColors
        | {  .. }
        | doc "Custom colors set by VsCode SFDX Hardis"
        | optional,
      customPlugins
        | Array
          {
            helpUrl
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | doc "Url of plugin documentation"
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | doc "Name of the plugin npm package"
              | optional,
          }
        | doc "List of additional plugins that will be displayed in VsCode SFDX-Hardis Dependencies panel"
        | optional,
      dataPackages
        | Array
          {
            dataPath | String | doc "Path to SFDMU project",
            importInScratchOrgs | Bool | doc "Path to SFDMU project",
          }
        | doc "List of data packages"
        | optional,
      defaultPackageInstallationKey
        | String
        | doc "When generating a new package version protected with password, use this value as default package installation key"
        | optional,
      deploymentPlan
        | {
          packages
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            dataPath = _js2n__-prdslib.isType '"String",
                            label = _js2n__-prdslib.isType '"String",
                            order = _js2n__-prdslib.isType '"Number",
                            packageXmlFile = _js2n__-prdslib.isType '"String",
                            waitAfter = _js2n__-prdslib.isType '"Number",
                          } {} false _js2n__-prdslib.never
                      ]),
                  _js2n__-prdslib.records.required [ "label", "order" ],
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ])
            | doc "During deployment, main package.xml will be split into these packages. Can also contain data packages"
            | optional,
          ..
        }
        | doc "Deployment plan that will be performed during deployments. Can be based on packageXmlFile for sources or on dataPath for sfdmu data deployments"
        | optional,
      devHubAlias
        | String
        | doc "Dev Hub alias, usually DevHub_ProjectName"
        | optional,
      devHubUsername
        | String
        | doc "Dev Hub username, used to authenticate to DevHub from CI jobs"
        | optional,
      developmentBranch
        | String
        | doc "When creating a new sfdx-hardis task, this git branch is used as base to create the feature/debug sub branch. The merge request will later have this branch as target."
        | optional,
      extends
        | String
        | doc "You can base your local sfdx-hardis configuration on a remote config file. That allows you to have the same config base for all your projects"
        | optional,
      initPermissionSets
        | Array (
          _js2n__-prdslib.contract_from_predicate
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.isType '"String"
                  ],
                _js2n__-prdslib.records.record
                  { name = _js2n__-prdslib.isType '"String", } {} false
                  _js2n__-prdslib.never
              ])
        )
        | doc "When creating a scratch org, Admin user will be automatically assigned to those permission sets"
        | optional,
      installPackagesDuringCheckDeploy
        | Bool
        | doc "When calling deployment check command, installs any package referred within installedPackages property"
        | optional,
      installedPackages
        | Array
          {
            Id
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | optional,
            SubscriberPackageId
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | optional,
            SubscriberPackageName
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | optional,
            SubscriberPackageNamespace
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType 'Null
                  ])
              | optional,
            SubscriberPackageVersionId
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String"),
            SubscriberPackageVersionName
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | optional,
            SubscriberPackageVersionNumber
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | optional,
            installDuringDeployments
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"Bool")
              | doc "If true, during deployments this package will be installed in target org if not installed yet"
              | optional,
            installOnScratchOrgs
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"Bool")
              | doc "If true, this package will be installed when creating a new scratch org with sfdx-hardis"
              | optional,
            installationkey
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.isType '"String")
              | doc "Installation key for key-protected package"
              | optional,
          }
        | doc "Defines the list of packages installed on the project. Use "
        | optional,
      instanceUrl
        | String
        | doc "Salesforce instance URL used by CI for deployment or backups"
        | optional,
      linterIgnoreRightMetadataFile
        | String
        | doc "Ignore profiles or permission sets"
        | optional,
      listViewsToSetToMine
        | Array (String)
        | doc "List of ListView items to set to Mine after a delivery (that does not accept value 'Everything')"
        | optional,
      monitoringAllowedSectionsActions
        | {  .. }
        | doc "Override list of Setup Audit Trail elements that won't be considered as suspect by monitoring tools"
        | optional,
      monitoringCommands
        | Array
          {
            command | String | doc "Bash command to run",
            frequency | String | doc "daily or weekly" | optional,
            key
              | String
              | doc "Unique identifier of the monitoring command. Can be used with monitoringDisable"
              | optional,
            title | String | doc "Title of the command (will appear in logs)",
          }
        | doc "List of monitoring commands to run with command hardis:org:monitor:all"
        | optional,
      monitoringDisable
        | Array
          _js2n__-refsenv."_js2n__-:definitions/enum_monitoring_commands!contract"
        | doc "List of commands to skip during monitoring jobs"
        | optional,
      monitoringExcludeUsernames
        | Array (String)
        | doc "List of usernames to exclude while running monitoring commands"
        | optional,
      msTeamsWebhookUrl
        | String
        | doc "Url of the Ms Teams channel Web Hook that can be used to send ALL notifications"
        | optional,
      msTeamsWebhookUrlCritical
        | String
        | doc "Url of the Ms Teams channel Web Hook that can be used to send CRITICAL notifications"
        | optional,
      msTeamsWebhookUrlInfo
        | String
        | doc "Url of the Ms Teams channel Web Hook that can be used to send INFO notifications"
        | optional,
      msTeamsWebhookUrlSevere
        | String
        | doc "Url of the Ms Teams channel Web Hook that can be used to send SEVERE notifications"
        | optional,
      msTeamsWebhookUrlWarning
        | String
        | doc "Url of the Ms Teams channel Web Hook that can be used to send WARNING notifications"
        | optional,
      notificationsDisable
        | Array
          _js2n__-refsenv."_js2n__-:definitions/enum_notification_types!contract"
        | doc "List of notifications types to skip sending"
        | optional,
      packageNoOverwritePath
        | String
        | doc "Path to a custom package-no-overwrite XML file (used in smartDeploy command)"
        | optional,
      poolConfig
        | {
          maxScratchOrgsNumber
            | Number
            | doc "Maximum number of active scratch orgs in the scratch org pool"
            | optional,
          maxScratchOrgsNumberToCreateOnce
            | Number
            | doc "Maximum number of scratch orgs to create in one CI job"
            | optional,
          minScratchOrgRemainingDays
            | Number
            | doc "When pool scratch org is less than this number, it is deleted and another one is created"
            | optional,
          storageService
            | String
            | doc "Remote service allowing to store scratch org pool details"
            | optional,
          ..
        }
        | doc "Configuration allowing to generate and fetch scratch orgs from scratch org pool"
        | optional,
      productionBranch
        | String
        | doc "Name of the git branch corresponding to production environment"
        | optional,
      projectName
        | String
        | doc "Identifier for the project (can be the client and project)"
        | optional,
      retrofitBranch
        | String
        | doc "Name of the git branch where retrofit merge requests targets to"
        | optional,
      retrofitIgnoredFiles
        | Array (String)
        | doc "When calling hardis:org:retrieve:sources:retrofit, list of files to ignore (discard just after retrieve)"
        | optional,
      runtests
        | String
        | doc "WARNING: Use with caution, only in branch scoped config ! Can be a list of test classes if testLevel=RunSpecifiedTests, or a regex if testLevel=RunRepositoryTests"
        | optional,
      scratchOrgDuration
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.numbers.maximum 30,
              _js2n__-prdslib.numbers.minimum 1
            ])
        | doc "Defines the lifespan of the scratch org in number of days, from 1 to 30"
        | optional,
      scratchOrgInitApexScripts
        | Array (String)
        | doc "Apex scripts to call after scratch org initialization"
        | optional,
      sfdmuCanModify
        | String
        | doc "Instance host name to allow SFDMU to deploy data in a production org"
        | optional,
      skipCodeCoverage
        | Bool
        | doc "WARNING: Use with caution, only in branch scoped config ! Do not check code coverage for a deployment"
        | optional,
      skipMinimizeProfiles
        | Array (String)
        | doc "These profiles will not be reformatted by command hardis:project:clean:minimizeprofiles"
        | optional,
      skipUpdateForceIgnore
        | Bool
        | doc "Defines if sfdx-hardis will propose to upgrade local .forceignore file"
        | optional,
      skipUpdateGitIgnore
        | Bool
        | doc "Defines if sfdx-hardis will propose to upgrade local .gitignore file"
        | optional,
      sourcesToRetrofit
        | Array (String)
        | doc "List of metadata to retrieve for retrofit job"
        | optional,
      targetUsername
        | String
        | doc "Salesforce username used by CI for deployment or backups"
        | optional,
      testCoverageNotBlocking
        | Bool
        | doc "Does not make the deployment job fail if apex tests code coverage is failing"
        | optional,
      testLevel
        | std.enum.TagOrString
        | [|
          'RunAllTestsInOrg,
          'RunLocalTests,
          'RunRepositoryTestsExceptSeeAllData,
          'RunRepositoryTests,
          'RunSpecifiedTests,
          'NoTestRun
        |]
        | doc "WARNING: Use with caution, only in branch scoped config ! You can override default test level for deployments for special use cases, for example when you have SeeAllData=true you can use RunRepositoryTests associated with a regex in runtests option"
        | optional,
      useDeltaDeployment
        | Bool
        | doc "Defines if sfdx-hardis will deploy in delta from minor to major branches"
        | optional,
      useSmartDeploymentTests
        | Bool
        | doc "Define if smart deployment tests will be activated and run test classes only if necessary (see more in hardis:project:deploy:smart documentation"
        | optional,
    }