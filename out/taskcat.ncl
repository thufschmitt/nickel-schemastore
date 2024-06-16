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
      "_js2n__-:definitions/GeneralConfig!contract"
        | doc "General configuration settings."
        = {
            artifact_regions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
              )
              | doc "List of AWS regions where artifacts need to be copied. This helps same region artifact bucket access to resources"
              | optional,
            auth
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc "AWS authentication section"
              | optional,
            parameters
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ])
                  ])
              | doc "Parameter key-values to pass to CloudFormation, parameters provided in global config take precedence"
              | optional,
            posthooks
              | Array _js2n__-refsenv."_js2n__-:definitions/HookData!contract"
              | doc "hooks to execute after executing tests"
              | optional,
            prehooks
              | Array _js2n__-refsenv."_js2n__-:definitions/HookData!contract"
              | doc "hooks to execute prior to executing tests"
              | optional,
            regions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
              )
              | doc "List of AWS regions"
              | optional,
            s3_bucket
              | String
              | doc "Name of S3 bucket to upload project to, if left out a bucket will be auto-generated"
              | optional,
            s3_regional_buckets
              | Bool
              | doc "Enable regional auto-buckets."
              | optional,
            tags
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc "Tags to apply to CloudFormation template"
              | optional,
          },
      "_js2n__-:definitions/HookData!contract"
        | doc "Hook definition"
        = {
            config | {  .. } | doc "hook configuration" | optional,
            type | String | doc "hook type" | optional,
          },
      "_js2n__-:definitions/HookData!predicate"
        | doc "Hook definition"
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  config = _js2n__-prdslib.isType 'Record,
                  type = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/ProjectConfig!contract"
        | doc "Project specific configuration section"
        = {
            artifact_regions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
              )
              | doc "List of AWS regions where artifacts need to be copied. This helps same region artifact bucket access to resources"
              | optional,
            auth
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc "AWS authentication section"
              | optional,
            az_blacklist
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "(afs1-az1|afs1-az2|afs1-az3|afs1-los1-az1|ape1-az1|ape1-az2|ape1-az3|apne1-az1|apne1-az2|apne1-az4|apne1-tpe1-az1|apne2-az1|apne2-az2|apne2-az3|apne2-az4|apne3-az1|apne3-az2|apne3-az3|aps1-az1|aps1-az2|aps1-az3|aps1-ccu1-az1|aps1-del1-az1|aps2-az1|aps2-az2|aps2-az3|apse1-az1|apse1-az2|apse1-az3|apse1-bkk1-az1|apse1-mnl1-az1|apse2-akl1-az1|apse2-az1|apse2-az2|apse2-az3|apse2-per1-az1|apse3-az1|apse3-az2|apse3-az3|apse4-az1|apse4-az2|apse4-az3|cac1-az1|cac1-az2|cac1-az4|caw1-az1|caw1-az2|caw1-az3|euc1-az1|euc1-az2|euc1-az3|euc1-ham1-az1|euc1-waw1-az1|euc2-az1|euc2-az2|euc2-az3|eun1-az1|eun1-az2|eun1-az3|eun1-cph1-az1|eun1-hel1-az1|eus1-az1|eus1-az2|eus1-az3|eus2-az1|eus2-az2|eus2-az3|euw1-az1|euw1-az2|euw1-az3|euw2-az1|euw2-az2|euw2-az3|euw3-az1|euw3-az2|euw3-az3|ilc1-az1|ilc1-az2|ilc1-az3|mec1-az1|mec1-az2|mec1-az3|mes1-az1|mes1-az2|mes1-az3|mes1-mct1-az1|sae1-az1|sae1-az2|sae1-az3|use1-atl1-az1|use1-az1|use1-az2|use1-az3|use1-az4|use1-az5|use1-az6|use1-bos1-az1|use1-bue1-az1|use1-chi2-az1|use1-dfw2-az1|use1-iah2-az1|use1-lim1-az1|use1-mci1-az1|use1-mia1-az1|use1-msp1-az1|use1-nyc1-az1|use1-phl1-az1|use1-qro1-az1|use1-scl1-az1|use2-az1|use2-az2|use2-az3|usw1-az1|usw1-az3|usw2-az1|usw2-az2|usw2-az3|usw2-az4|usw2-den1-az1|usw2-las1-az1|usw2-lax1-az1|usw2-lax1-az2|usw2-pdx1-az1|usw2-phx2-az1|usw2-sea1-az1)"
                    ])
              )
              | doc "List of Availablilty Zones ID's to exclude when generating availability zones"
              | optional,
            build_submodules
              | Bool
              | doc "Build Lambda zips recursively for submodules, set to false to disable"
              | optional,
            lambda_source_path
              | String
              | doc "Path relative to the project root containing Lambda zip files, default is 'lambda_functions/source'"
              | optional,
            lambda_zip_path
              | String
              | doc "Path relative to the project root to place Lambda zip files"
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[a-z0-9-/]*$"
                  ])
              | doc "Project name, used as s3 key prefix when uploading objects"
              | optional,
            org_id
              | String
              | doc "Organization ID to use when launching CFN Stacks. starts with o-. It is found on Organization Settings page"
              | optional,
            owner
              | String
              | doc "email address for project owner (not used at present)"
              | optional,
            package_lambda
              | Bool
              | doc "Package Lambda functions into zips before uploading to s3, set to false to disable"
              | optional,
            parameters
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType '"Array",
                              _js2n__-prdslib.arrays.arrayOf
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType 'Integer,
                                    _js2n__-prdslib.isType '"String"
                                  ])
                            ],
                          _js2n__-prdslib.isType '"Bool",
                          _js2n__-prdslib.isType 'Integer,
                          _js2n__-prdslib.isType '"String"
                        ])
                  ])
              | doc "Parameter key-values to pass to CloudFormation, parameters provided in global config take precedence"
              | optional,
            posthooks
              | Array _js2n__-refsenv."_js2n__-:definitions/HookData!contract"
              | doc "hooks to execute after executing tests"
              | optional,
            prehooks
              | Array _js2n__-refsenv."_js2n__-:definitions/HookData!contract"
              | doc "hooks to execute prior to executing tests"
              | optional,
            regions
              | Array (
                _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.strings.pattern
                        "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                    ])
              )
              | doc "List of AWS regions"
              | optional,
            role_name
              | String
              | doc "Role name to use when launching CFN Stacks."
              | optional,
            s3_bucket
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern "^[a-z0-9-]*$"
                  ])
              | doc "Name of S3 bucket to upload project to, if left out a bucket will be auto-generated"
              | optional,
            s3_enable_sig_v2
              | Bool
              | doc "Enable (deprecated) sigv2 access to auto-generated buckets"
              | optional,
            s3_object_acl
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.strings.pattern
                      "^(bucket-owner-full-control|bucket-owner-read|authenticated-read|aws-exec-read|public-read-write|public-read|private)$"
                  ])
              | doc "ACL for uploaded s3 objects"
              | optional,
            s3_regional_buckets
              | Bool
              | doc "Enable regional auto-buckets."
              | optional,
            shorten_stack_name
              | Bool
              | doc "Shorten stack names generated for tests, set to true to enable"
              | optional,
            tags
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc "Tags to apply to CloudFormation template"
              | optional,
            template
              | String
              | doc "path to template file relative to the project config file path"
              | optional,
          },
      "_js2n__-:definitions/TestConfig!predicate"
        | doc "Test specific configuration section."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  artifact_regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                              ])
                        ],
                  auth =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  az_blacklist =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "(afs1-az1|afs1-az2|afs1-az3|afs1-los1-az1|ape1-az1|ape1-az2|ape1-az3|apne1-az1|apne1-az2|apne1-az4|apne1-tpe1-az1|apne2-az1|apne2-az2|apne2-az3|apne2-az4|apne3-az1|apne3-az2|apne3-az3|aps1-az1|aps1-az2|aps1-az3|aps1-ccu1-az1|aps1-del1-az1|aps2-az1|aps2-az2|aps2-az3|apse1-az1|apse1-az2|apse1-az3|apse1-bkk1-az1|apse1-mnl1-az1|apse2-akl1-az1|apse2-az1|apse2-az2|apse2-az3|apse2-per1-az1|apse3-az1|apse3-az2|apse3-az3|apse4-az1|apse4-az2|apse4-az3|cac1-az1|cac1-az2|cac1-az4|caw1-az1|caw1-az2|caw1-az3|euc1-az1|euc1-az2|euc1-az3|euc1-ham1-az1|euc1-waw1-az1|euc2-az1|euc2-az2|euc2-az3|eun1-az1|eun1-az2|eun1-az3|eun1-cph1-az1|eun1-hel1-az1|eus1-az1|eus1-az2|eus1-az3|eus2-az1|eus2-az2|eus2-az3|euw1-az1|euw1-az2|euw1-az3|euw2-az1|euw2-az2|euw2-az3|euw3-az1|euw3-az2|euw3-az3|ilc1-az1|ilc1-az2|ilc1-az3|mec1-az1|mec1-az2|mec1-az3|mes1-az1|mes1-az2|mes1-az3|mes1-mct1-az1|sae1-az1|sae1-az2|sae1-az3|use1-atl1-az1|use1-az1|use1-az2|use1-az3|use1-az4|use1-az5|use1-az6|use1-bos1-az1|use1-bue1-az1|use1-chi2-az1|use1-dfw2-az1|use1-iah2-az1|use1-lim1-az1|use1-mci1-az1|use1-mia1-az1|use1-msp1-az1|use1-nyc1-az1|use1-phl1-az1|use1-qro1-az1|use1-scl1-az1|use2-az1|use2-az2|use2-az3|usw1-az1|usw1-az3|usw2-az1|usw2-az2|usw2-az3|usw2-az4|usw2-den1-az1|usw2-las1-az1|usw2-lax1-az1|usw2-lax1-az2|usw2-pdx1-az1|usw2-phx2-az1|usw2-sea1-az1)"
                              ])
                        ],
                  parameters =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType '"Array",
                                    _js2n__-prdslib.arrays.arrayOf
                                      (_js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType 'Integer,
                                          _js2n__-prdslib.isType '"String"
                                        ])
                                  ],
                                _js2n__-prdslib.isType '"Bool",
                                _js2n__-prdslib.isType 'Integer,
                                _js2n__-prdslib.isType '"String"
                              ])
                        ],
                  posthooks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HookData!predicate"
                        ],
                  prehooks =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            _js2n__-refsenv."_js2n__-:definitions/HookData!predicate"
                        ],
                  regions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.strings.pattern
                                  "^(ap|eu|us|sa|ca|cn|af|me|il|us-gov)-(central|south|north|east|west|southeast|southwest|northeast|northwest)-[0-9]$"
                              ])
                        ],
                  role_name = _js2n__-prdslib.isType '"String",
                  s3_bucket =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern "^[a-z0-9-]*$"
                        ],
                  s3_regional_buckets = _js2n__-prdslib.isType '"Bool",
                  stack_name = _js2n__-prdslib.isType '"String",
                  stack_name_prefix = _js2n__-prdslib.isType '"String",
                  stack_name_suffix = _js2n__-prdslib.isType '"String",
                  tags =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.isType '"String")
                        ],
                  template = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  {
      general
        | _js2n__-refsenv."_js2n__-:definitions/GeneralConfig!contract"
        | optional,
      project
        | _js2n__-refsenv."_js2n__-:definitions/ProjectConfig!contract"
        | optional,
      tests
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                _js2n__-refsenv."_js2n__-:definitions/TestConfig!predicate"
            ])
        | optional,
    }