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
      "_js2n__-:definitions/apt-deb!predicate"
        | doc "deb repositories"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "key-id", "type", "url" ],
              _js2n__-prdslib.records.record
                {
                  architectures =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  components =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 0,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  formats =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.enum [ "deb", "deb-src" ]
                              ]),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  key-id =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[A-Z0-9]{40}$"
                        ],
                  key-server = _js2n__-prdslib.isType '"String",
                  path = _js2n__-prdslib.isType '"String",
                  suites =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String"),
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "apt" ]
                        ],
                  url = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/apt-ppa!predicate"
        | doc "PPA repository"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "ppa", "type" ],
              _js2n__-prdslib.records.record
                {
                  ppa = _js2n__-prdslib.isType '"String",
                  type =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.enum [ "apt" ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/build-environment-grammar!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.maxProperties 1,
                        _js2n__-prdslib.records.minProperties 1,
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.isType '"String")
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^on\\s+.+$" =
                              _js2n__-refsenv."_js2n__-:definitions/build-environment-grammar!predicate",
                          } false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^to\\s+.+$" =
                              _js2n__-refsenv."_js2n__-:definitions/build-environment-grammar!predicate",
                          } false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^else$" =
                              _js2n__-refsenv."_js2n__-:definitions/build-environment-grammar!predicate",
                          } false _js2n__-prdslib.never
                      ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/environment!predicate"
        | doc "environment entries"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.arrays.minItems 1,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.strings.minLength 1
                      ],
                    _js2n__-prdslib.isType '"Number"
                  ])
            ],
      "_js2n__-:definitions/grammar-array!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^on\\s+.+$" =
                              _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                          } false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^to\\s+.+$" =
                              _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                          } false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^try$" =
                              _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                          } false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {}
                          {
                            "^else$" =
                              _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                          } false _js2n__-prdslib.never
                      ]
                  ]),
              _js2n__-prdslib.arrays.uniqueItems
            ],
      "_js2n__-:definitions/grammar-string!predicate" =
        _js2n__-prdslib.oneOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType '"Array",
                  _js2n__-prdslib.arrays.arrayOf
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.oneOf
                          [
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {}
                                  {
                                    "^on\\s+.+$" =
                                      _js2n__-refsenv."_js2n__-:definitions/grammar-string!predicate",
                                  } false _js2n__-prdslib.never
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {}
                                  {
                                    "^to\\s+.+$" =
                                      _js2n__-refsenv."_js2n__-:definitions/grammar-string!predicate",
                                  } false _js2n__-prdslib.never
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {}
                                  {
                                    "^try$" =
                                      _js2n__-refsenv."_js2n__-:definitions/grammar-string!predicate",
                                  } false _js2n__-prdslib.never
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record {}
                                  {
                                    "^else$" =
                                      _js2n__-refsenv."_js2n__-:definitions/grammar-string!predicate",
                                  } false _js2n__-prdslib.never
                              ],
                            _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern "else fail"
                              ]
                          ],
                        _js2n__-prdslib.arrays.uniqueItems
                      ])
                ]
            ],
      "_js2n__-:definitions/system-username-scope!predicate"
        | doc "short-form user configuration (<username>: <scope>)"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.enum [ "shared" ]
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.records.required [ "type" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ],
                          _js2n__-prdslib.not
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.records.required [ "base" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ])
                        ],
                      _js2n__-prdslib.records.record
                        {
                          type =
                            _js2n__-prdslib.enum [ "base", "kernel", "snapd" ],
                        } {} true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.records.required [ "base" ],
                          _js2n__-prdslib.records.record {} {} true
                            _js2n__-prdslib.always
                        ],
                      _js2n__-prdslib.records.record
                        { type = _js2n__-prdslib.enum [ "app", "gadget" ], } {}
                        true _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "build-base" ],
                      _js2n__-prdslib.records.record
                        { base = _js2n__-prdslib.enum [ "bare" ], } {} true
                        _js2n__-prdslib.always
                    ]
                ],
              _js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required
                        [ "description", "summary", "version" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ],
                  _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.records.required [ "adopt-info" ],
                      _js2n__-prdslib.records.record {} {} true
                        _js2n__-prdslib.always
                    ]
                ]
            ],
          _js2n__-prdslib.records.required [ "name", "parts" ],
          _js2n__-prdslib.records.record
            {
              adopt-info = _js2n__-prdslib.isType '"String",
              apps =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-zA-Z0-9](?:-?[a-zA-Z0-9])*$" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.required
                                    [ "command" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      activates-on =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      adapter =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "none", "legacy", "full" ]
                                            ],
                                      after =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      aliases =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      "^[a-zA-Z0-9][-_.a-zA-Z0-9]*$"
                                                  ]),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      autostart =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[A-Za-z0-9. _#:$-]+\\.desktop$"
                                            ],
                                      before =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      bus-name =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[A-Za-z0-9/. _#:$-]*$"
                                            ],
                                      command =
                                        _js2n__-prdslib.isType '"String",
                                      command-chain =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      "^[A-Za-z0-9/._#:$-]*$"
                                                  ])
                                            ],
                                      common-id =
                                        _js2n__-prdslib.isType '"String",
                                      completer =
                                        _js2n__-prdslib.isType '"String",
                                      daemon =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "simple",
                                                  "forking",
                                                  "oneshot",
                                                  "notify",
                                                  "dbus"
                                                ]
                                            ],
                                      desktop =
                                        _js2n__-prdslib.isType '"String",
                                      environment =
                                        _js2n__-refsenv."_js2n__-:definitions/environment!predicate",
                                      extensions =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.enum
                                                  [
                                                    "flutter-stable",
                                                    "flutter-beta",
                                                    "flutter-dev",
                                                    "flutter-master",
                                                    "gnome",
                                                    "gnome-3-28",
                                                    "gnome-3-34",
                                                    "gnome-3-38",
                                                    "kde-neon",
                                                    "ros1-noetic",
                                                    "ros1-noetic-desktop",
                                                    "ros1-noetic-perception",
                                                    "ros1-noetic-robot",
                                                    "ros1-noetic-ros-base",
                                                    "ros1-noetic-ros-core",
                                                    "ros2-foxy",
                                                    "ros2-foxy-ros-base",
                                                    "ros2-foxy-ros-core",
                                                    "ros2-foxy-desktop",
                                                    "ros2-humble",
                                                    "ros2-humble-ros-base",
                                                    "ros2-humble-ros-core",
                                                    "ros2-humble-desktop"
                                                  ]),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      install-mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [ "enable", "disable" ]
                                            ],
                                      passthrough =
                                        _js2n__-prdslib.isType 'Record,
                                      plugs =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      post-stop-command =
                                        _js2n__-prdslib.isType '"String",
                                      refresh-mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "endure",
                                                  "restart",
                                                  "ignore-running"
                                                ]
                                            ],
                                      reload-command =
                                        _js2n__-prdslib.isType '"String",
                                      restart-condition =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "on-success",
                                                  "on-failure",
                                                  "on-abnormal",
                                                  "on-abort",
                                                  "on-watchdog",
                                                  "always",
                                                  "never"
                                                ]
                                            ],
                                      restart-delay =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[0-9]+(ns|us|ms|s|m)*$"
                                            ],
                                      slots =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      sockets =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {
                                                  "^[a-z][a-z0-9_-]*$" =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.required
                                                            [ "listen-stream" ],
                                                          _js2n__-prdslib.records.record
                                                            {
                                                              listen-stream =
                                                                _js2n__-prdslib.anyOf
                                                                    [
                                                                      _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            'Integer,
                                                                          _js2n__-prdslib.numbers.maximum
                                                                            65535,
                                                                          _js2n__-prdslib.numbers.minimum
                                                                            1
                                                                        ],
                                                                      _js2n__-prdslib.isType
                                                                        '"String"
                                                                    ],
                                                              socket-mode =
                                                                _js2n__-prdslib.isType
                                                                    'Integer,
                                                            } {} false
                                                            _js2n__-prdslib.never
                                                        ],
                                                } false _js2n__-prdslib.never
                                            ],
                                      start-timeout =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[0-9]+(ns|us|ms|s|m)*$"
                                            ],
                                      stop-command =
                                        _js2n__-prdslib.isType '"String",
                                      stop-mode =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "sigterm",
                                                  "sigterm-all",
                                                  "sighup",
                                                  "sighup-all",
                                                  "sigusr1",
                                                  "sigusr1-all",
                                                  "sigusr2",
                                                  "sigusr2-all",
                                                  "sigint",
                                                  "sigint-all"
                                                ]
                                            ],
                                      stop-timeout =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[0-9]+(ns|us|ms|s|m)*$"
                                            ],
                                      timer = _js2n__-prdslib.isType '"String",
                                      watchdog-timeout =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.strings.pattern
                                                "^[0-9]+(ns|us|ms|s|m)*$"
                                            ],
                                    } {} false _js2n__-prdslib.never,
                                  _js2n__-prdslib.records.dependencies
                                    {
                                      activates-on = [ "daemon" ],
                                      after = [ "daemon" ],
                                      before = [ "daemon" ],
                                      bus-name = [ "daemon" ],
                                      install-mode = [ "daemon" ],
                                      post-stop-command = [ "daemon" ],
                                      refresh-mode = [ "daemon" ],
                                      reload-command = [ "daemon" ],
                                      restart-condition = [ "daemon" ],
                                      restart-delay = [ "daemon" ],
                                      start-timeout = [ "daemon" ],
                                      stop-command = [ "daemon" ],
                                      stop-mode = [ "daemon" ],
                                      stop-timeout = [ "daemon" ],
                                      timer = [ "daemon" ],
                                      watchdog-timeout = [ "daemon" ],
                                    }
                                ],
                        } false _js2n__-prdslib.never
                    ],
              architectures =
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
                                _js2n__-prdslib.records.required [ "build-on" ],
                                _js2n__-prdslib.records.record
                                  {
                                    build-on =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.minItems
                                                  1,
                                                _js2n__-prdslib.arrays.uniqueItems
                                              ]
                                          ],
                                    run-on =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.minItems
                                                  1,
                                                _js2n__-prdslib.arrays.uniqueItems
                                              ]
                                          ],
                                  } {} false _js2n__-prdslib.never
                              ]
                          ]),
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              assumes =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.items
                        [ _js2n__-prdslib.isType '"String" ],
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              base = _js2n__-prdslib.isType '"String",
              build-base = _js2n__-prdslib.isType '"String",
              build-packages =
                _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
              compression =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "lzo", "xz" ]
                    ],
              confinement =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "classic", "devmode", "strict" ]
                    ],
              contact =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"String" ],
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                      _js2n__-prdslib.isType '"String"
                    ],
              description =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern ".+"
                    ],
              donation =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"String" ],
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                      _js2n__-prdslib.isType '"String"
                    ],
              environment =
                _js2n__-refsenv."_js2n__-:definitions/environment!predicate",
              epoch = _js2n__-prdslib.always,
              frameworks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.items
                        [ _js2n__-prdslib.isType '"String" ],
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              grade =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum [ "stable", "devel" ]
                    ],
              hooks =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^[a-z](?:-?[a-z0-9])*$" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.records.record
                                    {
                                      command-chain =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.pattern
                                                      "^[A-Za-z0-9/._#:$-]*$"
                                                  ])
                                            ],
                                      environment =
                                        _js2n__-refsenv."_js2n__-:definitions/environment!predicate",
                                      passthrough =
                                        _js2n__-prdslib.isType 'Record,
                                      plugs =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                    } {} false _js2n__-prdslib.never
                                ],
                        } false _js2n__-prdslib.never
                    ],
              icon = _js2n__-prdslib.isType '"String",
              issues =
                _js2n__-prdslib.oneOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.items
                            [ _js2n__-prdslib.isType '"String" ],
                          _js2n__-prdslib.arrays.minItems 1,
                          _js2n__-prdslib.arrays.uniqueItems
                        ],
                      _js2n__-prdslib.isType '"String"
                    ],
              layout = _js2n__-prdslib.isType 'Record,
              license = _js2n__-prdslib.isType '"String",
              name =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 40
                        ],
                      _js2n__-prdslib.strings.pattern
                        "^[a-z0-9-]*[a-z][a-z0-9-]*$",
                      _js2n__-prdslib.strings.pattern "^[^-]",
                      _js2n__-prdslib.strings.pattern "[^-]$",
                      _js2n__-prdslib.not (_js2n__-prdslib.strings.pattern "--")
                    ],
              package-repositories =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.items
                        [
                          _js2n__-prdslib.oneOf
                            [
                              _js2n__-refsenv."_js2n__-:definitions/apt-deb!predicate",
                              _js2n__-refsenv."_js2n__-:definitions/apt-ppa!predicate"
                            ]
                        ],
                      _js2n__-prdslib.arrays.minItems 0,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              parts =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.minProperties 1,
                      _js2n__-prdslib.records.record {}
                        {
                          "^(?!plugins$)[a-z0-9][a-z0-9+-]*$" =
                            _js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.isType 'Null
                                    ],
                                  _js2n__-prdslib.records.minProperties 1,
                                  _js2n__-prdslib.records.required [ "plugin" ],
                                  _js2n__-prdslib.records.record
                                    {
                                      after =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      build-attributes =
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
                                                        "core22-step-dependencies",
                                                        "enable-patchelf",
                                                        "no-patchelf",
                                                        "no-install",
                                                        "debug",
                                                        "keep-execstack"
                                                      ]
                                                  ]),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      build-environment =
                                        _js2n__-refsenv."_js2n__-:definitions/build-environment-grammar!predicate",
                                      build-packages =
                                        _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                                      build-snaps =
                                        _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                                      disable-parallel =
                                        _js2n__-prdslib.isType '"Bool",
                                      filesets =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.isType
                                                  '"Array")
                                            ],
                                      organize =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true
                                                (_js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.strings.minLength
                                                      1
                                                  ])
                                            ],
                                      override-build =
                                        _js2n__-prdslib.isType '"String",
                                      override-prime =
                                        _js2n__-prdslib.isType '"String",
                                      override-pull =
                                        _js2n__-prdslib.isType '"String",
                                      override-stage =
                                        _js2n__-prdslib.isType '"String",
                                      parse-info =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      plugin = _js2n__-prdslib.isType '"String",
                                      prime =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      source =
                                        _js2n__-refsenv."_js2n__-:definitions/grammar-string!predicate",
                                      source-branch =
                                        _js2n__-prdslib.isType '"String",
                                      source-checksum =
                                        _js2n__-prdslib.isType '"String",
                                      source-commit =
                                        _js2n__-prdslib.isType '"String",
                                      source-depth =
                                        _js2n__-prdslib.isType 'Integer,
                                      source-subdir =
                                        _js2n__-prdslib.isType '"String",
                                      source-submodules =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.minItems 0,
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      source-tag =
                                        _js2n__-prdslib.isType '"String",
                                      source-type =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"String",
                                              _js2n__-prdslib.enum
                                                [
                                                  "bzr",
                                                  "git",
                                                  "hg",
                                                  "mercurial",
                                                  "subversion",
                                                  "svn",
                                                  "tar",
                                                  "zip",
                                                  "deb",
                                                  "rpm",
                                                  "7z",
                                                  "local"
                                                ]
                                            ],
                                      stage =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType '"Array",
                                              _js2n__-prdslib.arrays.arrayOf
                                                (_js2n__-prdslib.isType
                                                  '"String"),
                                              _js2n__-prdslib.arrays.uniqueItems
                                            ],
                                      stage-packages =
                                        _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                                      stage-snaps =
                                        _js2n__-refsenv."_js2n__-:definitions/grammar-array!predicate",
                                    } {} true _js2n__-prdslib.always
                                ],
                        } false _js2n__-prdslib.never
                    ],
              passthrough = _js2n__-prdslib.isType 'Record,
              plugs = _js2n__-prdslib.isType 'Record,
              slots = _js2n__-prdslib.isType 'Record,
              source-code = _js2n__-prdslib.isType '"String",
              summary =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 78
                    ],
              system-usernames =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.records.record {}
                        {
                          "^snap_(daemon|microk8s|aziotedge|aziotdu)$" =
                            _js2n__-prdslib.oneOf
                                [
                                  _js2n__-refsenv."_js2n__-:definitions/system-username-scope!predicate",
                                  _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.required
                                        [ "scope" ],
                                      _js2n__-prdslib.records.record
                                        {
                                          scope =
                                            _js2n__-refsenv."_js2n__-:definitions/system-username-scope!predicate",
                                        } {} false _js2n__-prdslib.never
                                    ]
                                ],
                        } false _js2n__-prdslib.never
                    ],
              title =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.maxLength 40
                    ],
              type =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.enum
                        [ "app", "base", "gadget", "kernel", "snapd" ]
                    ],
              ua-services =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"Array",
                      _js2n__-prdslib.arrays.items
                        [ _js2n__-prdslib.isType '"String" ],
                      _js2n__-prdslib.arrays.minItems 1,
                      _js2n__-prdslib.arrays.uniqueItems
                    ],
              version =
                _js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.strings.maxLength 32,
                          _js2n__-prdslib.strings.pattern
                            "^[a-zA-Z0-9](?:[a-zA-Z0-9:.+~-]*[a-zA-Z0-9+~])?$"
                        ]
                    ],
              version-script = _js2n__-prdslib.isType '"String",
              website = _js2n__-prdslib.isType '"String",
            } {} false _js2n__-prdslib.never,
          _js2n__-prdslib.records.dependencies
            {
              license-agreement = [ "license" ],
              license-version = [ "license" ],
            }
        ])