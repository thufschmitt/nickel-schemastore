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
      "_js2n__-:definitions/refComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { ref = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/settingsAppearanceToolsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { appearanceTools = _js2n__-prdslib.isType '"Bool", } {} true
                _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsBackgroundProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  background =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              backgroundImage = _js2n__-prdslib.isType '"Bool",
                              backgroundSize = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsBlocksPropertiesComplete!predicate"
        | doc "Settings defined on a per-block basis."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "core/archives" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/audio" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/avatar" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/block" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/button" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/buttons" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/calendar" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/categories" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/code" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/column" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/columns" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-author-avatar" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-author-name" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-content" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-date" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-edit-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-reply-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comment-template" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comments" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comments-pagination" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comments-pagination-next" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comments-pagination-numbers" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comments-pagination-previous" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/comments-title" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/cover" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/details" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/embed" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/file" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/footnotes" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/freeform" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/gallery" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/group" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/heading" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/home-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/html" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/image" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/latest-comments" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/latest-posts" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/legacy-widget" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/list" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/list-item" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/loginout" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/media-text" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/missing" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/more" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/navigation" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/navigation-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/navigation-submenu" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/nextpage" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/page-list" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/page-list-item" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/paragraph" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-author" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-author-biography" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-author-name" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-comment" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-comments-count" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-comments-form" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-comments-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-content" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-date" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-excerpt" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-featured-image" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-navigation-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-template" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-terms" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/post-title" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/preformatted" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/pullquote" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-no-results" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-pagination" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-pagination-next" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-pagination-numbers" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-pagination-previous" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-title" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/query-total" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/quote" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/read-more" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/rss" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/search" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/separator" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/shortcode" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/site-logo" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/site-tagline" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/site-title" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/social-link" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/social-links" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/spacer" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/table" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/tag-cloud" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/template-part" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/term-description" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/text-columns" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/verse" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/video" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/widget-area" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                  "core/widget-group" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                }
                {
                  "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" =
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertiesComplete!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/settingsBorderProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  border =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              color = _js2n__-prdslib.isType '"Bool",
                              radius = _js2n__-prdslib.isType '"Bool",
                              style = _js2n__-prdslib.isType '"Bool",
                              width = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsColorProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              background = _js2n__-prdslib.isType '"Bool",
                              button = _js2n__-prdslib.isType '"Bool",
                              caption = _js2n__-prdslib.isType '"Bool",
                              custom = _js2n__-prdslib.isType '"Bool",
                              customDuotone = _js2n__-prdslib.isType '"Bool",
                              customGradient = _js2n__-prdslib.isType '"Bool",
                              defaultDuotone = _js2n__-prdslib.isType '"Bool",
                              defaultGradients = _js2n__-prdslib.isType '"Bool",
                              defaultPalette = _js2n__-prdslib.isType '"Bool",
                              duotone =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "colors", "name", "slug" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                colors =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.isType
                                                            '"String")
                                                      ],
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                              gradients =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "gradient", "name", "slug" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                gradient =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                              heading = _js2n__-prdslib.isType '"Bool",
                              link = _js2n__-prdslib.isType '"Bool",
                              palette =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "color", "name", "slug" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                color =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                              text = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsCustomAdditionalProperties!predicate"
        | doc "Generate custom CSS custom properties of the form `--wp--custom--{key}--{nested-key}: {value};`. `camelCased` keys are transformed to `kebab-case` as to follow the CSS property naming schema. Keys at different depth levels are separated by `--`, so keys should not include `--` in the name."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {} {} true
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-refsenv."_js2n__-:definitions/settingsCustomAdditionalProperties!predicate"
                  ])
            ],
      "_js2n__-:definitions/settingsCustomProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  custom =
                    _js2n__-refsenv."_js2n__-:definitions/settingsCustomAdditionalProperties!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsDimensionsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  dimensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              aspectRatio = _js2n__-prdslib.isType '"Bool",
                              aspectRatios =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                ratio =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} true _js2n__-prdslib.always
                                          ])
                                    ],
                              defaultAspectRatios =
                                _js2n__-prdslib.isType '"Bool",
                              minHeight = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsLayoutProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  layout =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allowCustomContentAndWideSize =
                                _js2n__-prdslib.isType '"Bool",
                              allowEditing = _js2n__-prdslib.isType '"Bool",
                              contentSize = _js2n__-prdslib.isType '"String",
                              wideSize = _js2n__-prdslib.isType '"String",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsLightboxProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  lightbox =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              allowEditing = _js2n__-prdslib.isType '"Bool",
                              enabled = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsPositionProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  position =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            { sticky = _js2n__-prdslib.isType '"Bool", } {}
                            false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/settingsAppearanceToolsProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsBackgroundProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsBorderProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsColorProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsDimensionsProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsLayoutProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsLightboxProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsPositionProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsShadowProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsSpacingProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsTypographyProperties!predicate",
              _js2n__-refsenv."_js2n__-:definitions/settingsCustomProperties!predicate"
            ],
      "_js2n__-:definitions/settingsPropertiesComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/settingsProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    _js2n__-refsenv."_js2n__-:definitions/settingsPropertyNames!predicate",
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/settingsPropertyNames!predicate" =
        _js2n__-prdslib.enum
            [
              "appearanceTools",
              "background",
              "border",
              "color",
              "dimensions",
              "layout",
              "lightbox",
              "position",
              "shadow",
              "spacing",
              "typography",
              "custom"
            ],
      "_js2n__-:definitions/settingsShadowProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  shadow =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              defaultPresets = _js2n__-prdslib.isType '"Bool",
                              presets =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.required
                                              [ "name", "shadow", "slug" ],
                                            _js2n__-prdslib.records.record
                                              {
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                shadow =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsSpacingProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  spacing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              blockGap =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"Bool",
                                      _js2n__-prdslib.isType 'Null
                                    ],
                              customSpacingSize =
                                _js2n__-prdslib.isType '"Bool",
                              defaultSpacingSizes =
                                _js2n__-prdslib.isType '"Bool",
                              margin = _js2n__-prdslib.isType '"Bool",
                              padding = _js2n__-prdslib.isType '"Bool",
                              spacingScale =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          increment =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.numbers.exclusiveMinimum
                                                    0
                                                ],
                                          mediumStep =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.numbers.exclusiveMinimum
                                                    0
                                                ],
                                          operator =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [ "+", "*" ]
                                                ],
                                          steps =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Integer,
                                                  _js2n__-prdslib.numbers.maximum
                                                    10,
                                                  _js2n__-prdslib.numbers.minimum
                                                    1
                                                ],
                                          unit =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.enum
                                                    [
                                                      "px",
                                                      "em",
                                                      "rem",
                                                      "%",
                                                      "vw",
                                                      "svw",
                                                      "lvw",
                                                      "dvw",
                                                      "vh",
                                                      "svh",
                                                      "lvh",
                                                      "dvh",
                                                      "vi",
                                                      "svi",
                                                      "lvi",
                                                      "dvi",
                                                      "vb",
                                                      "svb",
                                                      "lvb",
                                                      "dvb",
                                                      "vmin",
                                                      "svmin",
                                                      "lvmin",
                                                      "dvmin",
                                                      "vmax",
                                                      "svmax",
                                                      "lvmax",
                                                      "dvmax"
                                                    ]
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              spacingSizes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                size =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                              units =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String"),
                                      _js2n__-prdslib.arrays.minItems 1
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/settingsTypographyProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  typography =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              customFontSize = _js2n__-prdslib.isType '"Bool",
                              defaultFontSizes = _js2n__-prdslib.isType '"Bool",
                              dropCap = _js2n__-prdslib.isType '"Bool",
                              fluid =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              maxViewportWidth =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              minFontSize =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                              minViewportWidth =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ],
                                      _js2n__-prdslib.isType '"Bool"
                                    ],
                              fontFamilies =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                fontFace =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          '"Array",
                                                        _js2n__-prdslib.arrays.arrayOf
                                                          (_js2n__-prdslib.allOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                'Record,
                                                              _js2n__-prdslib.records.required
                                                                [
                                                                  "fontFamily",
                                                                  "src"
                                                                ],
                                                              _js2n__-prdslib.records.record
                                                                {
                                                                  ascentOverride =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  descentOverride =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontDisplay =
                                                                    _js2n__-prdslib.allOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.enum
                                                                            [
                                                                              "auto",
                                                                              "block",
                                                                              "fallback",
                                                                              "swap",
                                                                              "optional"
                                                                            ]
                                                                        ],
                                                                  fontFamily =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontFeatureSettings =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontStretch =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontStyle =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontVariant =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontVariationSettings =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  fontWeight =
                                                                    _js2n__-prdslib.oneOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.isType
                                                                            'Integer
                                                                        ],
                                                                  lineGapOverride =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  sizeAdjust =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                  src =
                                                                    _js2n__-prdslib.oneOf
                                                                        [
                                                                          _js2n__-prdslib.isType
                                                                            '"String",
                                                                          _js2n__-prdslib.allOf
                                                                            [
                                                                              _js2n__-prdslib.isType
                                                                                '"Array",
                                                                              _js2n__-prdslib.arrays.arrayOf
                                                                                (_js2n__-prdslib.isType
                                                                                  '"String")
                                                                            ]
                                                                        ],
                                                                  unicodeRange =
                                                                    _js2n__-prdslib.isType
                                                                        '"String",
                                                                } {} false
                                                                _js2n__-prdslib.never
                                                            ])
                                                      ],
                                                fontFamily =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                              fontSizes =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record
                                              {
                                                fluid =
                                                  _js2n__-prdslib.oneOf
                                                      [
                                                        _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                max =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                min =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                        _js2n__-prdslib.isType
                                                          '"Bool"
                                                      ],
                                                name =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                size =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                                slug =
                                                  _js2n__-prdslib.isType
                                                      '"String",
                                              } {} false _js2n__-prdslib.never
                                          ])
                                    ],
                              fontStyle = _js2n__-prdslib.isType '"Bool",
                              fontWeight = _js2n__-prdslib.isType '"Bool",
                              letterSpacing = _js2n__-prdslib.isType '"Bool",
                              lineHeight = _js2n__-prdslib.isType '"Bool",
                              textAlign = _js2n__-prdslib.isType '"Bool",
                              textColumns = _js2n__-prdslib.isType '"Bool",
                              textDecoration = _js2n__-prdslib.isType '"Bool",
                              textTransform = _js2n__-prdslib.isType '"Bool",
                              writingMode = _js2n__-prdslib.isType '"Bool",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stylesBlocksPropertiesComplete!predicate"
        | doc "Styles defined on a per-block basis using the block's selector."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "core/archives" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/audio" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/avatar" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/block" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/button" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/buttons" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/calendar" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/categories" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/code" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/column" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/columns" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-author-avatar" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-author-name" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-content" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-date" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-edit-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-reply-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comment-template" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comments" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comments-pagination" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comments-pagination-next" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comments-pagination-numbers" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comments-pagination-previous" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/comments-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/cover" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/details" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/embed" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/file" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/footnotes" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/freeform" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/gallery" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/group" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/heading" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/home-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/html" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/image" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/latest-comments" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/latest-posts" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/legacy-widget" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/list" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/list-item" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/loginout" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/media-text" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/missing" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/more" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/navigation" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/navigation-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/navigation-submenu" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/nextpage" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/page-list" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/page-list-item" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/paragraph" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-author" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-author-biography" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-author-name" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-comment" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-comments-count" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-comments-form" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-comments-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-content" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-date" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-excerpt" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-featured-image" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-navigation-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-template" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-terms" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/post-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/preformatted" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/pullquote" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-no-results" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-pagination" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-pagination-next" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-pagination-numbers" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-pagination-previous" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/query-total" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/quote" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/read-more" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/rss" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/search" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/separator" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/shortcode" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/site-logo" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/site-tagline" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/site-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/social-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/social-links" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/spacer" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/table" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/tag-cloud" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/template-part" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/term-description" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/text-columns" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/verse" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/video" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/widget-area" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/widget-group" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                }
                {
                  "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stylesElementsPropertiesComplete!predicate"
        | doc "Styles defined on a per-element basis using the element's selector."
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  button =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/stylesElementsPseudoSelectorsProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.propertyNames
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/stylesElementsPseudoSelectorsPropertyNames!predicate"
                                  ]),
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ]
                        ],
                  caption =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  cite =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  h1 =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  h2 =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  h3 =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  h4 =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  h5 =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  h6 =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  heading =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  link =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
                          _js2n__-refsenv."_js2n__-:definitions/stylesElementsPseudoSelectorsProperties!predicate",
                          _js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.propertyNames
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                                    _js2n__-refsenv."_js2n__-:definitions/stylesElementsPseudoSelectorsPropertyNames!predicate"
                                  ]),
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ]
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stylesElementsPseudoSelectorsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  ":active" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  ":any-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  ":focus" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  ":focus-visible" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  ":hover" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  ":link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                  ":visited" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesComplete!predicate",
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stylesElementsPseudoSelectorsPropertyNames!predicate" =
        _js2n__-prdslib.enum
            [
              ":active",
              ":any-link",
              ":focus",
              ":focus-visible",
              ":hover",
              ":link",
              ":visited"
            ],
      "_js2n__-:definitions/stylesProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  background =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              backgroundAttachment =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              backgroundImage =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              url =
                                                _js2n__-prdslib.isType
                                                    '"String",
                                            } {} false _js2n__-prdslib.never
                                        ]
                                    ],
                              backgroundPosition =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              backgroundRepeat =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              backgroundSize =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  border =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              bottom =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          color =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          style =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          width =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              color =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              left =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          color =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          style =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          width =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              radius =
                                _js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate",
                                      _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType 'Record,
                                          _js2n__-prdslib.records.record
                                            {
                                              bottomLeft =
                                                _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                    ],
                                              bottomRight =
                                                _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                    ],
                                              topLeft =
                                                _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                    ],
                                              topRight =
                                                _js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                    ],
                                            } {} true _js2n__-prdslib.always
                                        ]
                                    ],
                              right =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          color =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          style =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          width =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              style =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              top =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          color =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          style =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          width =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              width =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  color =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              background =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              gradient =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              text =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  css = _js2n__-prdslib.isType '"String",
                  dimensions =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              aspectRatio =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              minHeight =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} true _js2n__-prdslib.always
                        ],
                  filter =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              duotone =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  outline =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              color =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              offset =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              style =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              width =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  shadow =
                    _js2n__-prdslib.oneOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                        ],
                  spacing =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              blockGap =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              margin =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          bottom =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          left =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          right =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          top =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                              padding =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          bottom =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          left =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          right =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                          top =
                                            _js2n__-prdslib.oneOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                  typography =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              fontFamily =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              fontSize =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              fontStyle =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              fontWeight =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              letterSpacing =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              lineHeight =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              textAlign =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              textColumns =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              textDecoration =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              textTransform =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                              writingMode =
                                _js2n__-prdslib.oneOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-refsenv."_js2n__-:definitions/refComplete!predicate"
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      elements =
                        _js2n__-refsenv."_js2n__-:definitions/stylesElementsPropertiesComplete!predicate",
                      variations =
                        _js2n__-refsenv."_js2n__-:definitions/stylesVariationsPropertiesComplete!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                        _js2n__-prdslib.enum [ "elements", "variations" ]
                      ]),
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/stylesPropertiesComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/stylesPropertyNames!predicate" =
        _js2n__-prdslib.enum
            [
              "background",
              "border",
              "color",
              "css",
              "dimensions",
              "filter",
              "outline",
              "shadow",
              "spacing",
              "typography"
            ],
      "_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      elements =
                        _js2n__-refsenv."_js2n__-:definitions/stylesElementsPropertiesComplete!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                        _js2n__-prdslib.enum [ "elements" ]
                      ]),
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/stylesVariationBlocksPropertiesComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  "core/archives" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/audio" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/avatar" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/block" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/button" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/buttons" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/calendar" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/categories" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/code" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/column" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/columns" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-author-avatar" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-author-name" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-content" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-date" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-edit-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-reply-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comment-template" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comments" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comments-pagination" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comments-pagination-next" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comments-pagination-numbers" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comments-pagination-previous" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/comments-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/cover" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/details" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/embed" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/file" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/footnotes" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/freeform" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/gallery" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/group" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/heading" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/home-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/html" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/image" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/latest-comments" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/latest-posts" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/legacy-widget" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/list" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/list-item" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/loginout" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/media-text" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/missing" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/more" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/navigation" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/navigation-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/navigation-submenu" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/nextpage" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/page-list" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/page-list-item" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/paragraph" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-author" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-author-biography" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-author-name" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-comment" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-comments-count" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-comments-form" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-comments-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-content" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-date" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-excerpt" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-featured-image" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-navigation-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-template" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-terms" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/post-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/preformatted" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/pullquote" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-no-results" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-pagination" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-pagination-next" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-pagination-numbers" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-pagination-previous" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/query-total" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesPropertiesAndElementsComplete!predicate",
                  "core/quote" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/read-more" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/rss" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/search" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/separator" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/shortcode" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/site-logo" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/site-tagline" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/site-title" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/social-link" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/social-links" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/spacer" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/table" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/tag-cloud" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/template-part" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/term-description" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/text-columns" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/verse" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/video" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/widget-area" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                  "core/widget-group" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                }
                {
                  "^[a-z][a-z0-9-]*/[a-z][a-z0-9-]*$" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlockPropertiesComplete!predicate",
                } false _js2n__-prdslib.never
            ],
      "_js2n__-:definitions/stylesVariationProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      blocks =
                        _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlocksPropertiesComplete!predicate",
                      elements =
                        _js2n__-refsenv."_js2n__-:definitions/stylesElementsPropertiesComplete!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                        _js2n__-prdslib.enum [ "elements", "blocks" ]
                      ]),
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/stylesVariationPropertiesComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      blocks =
                        _js2n__-refsenv."_js2n__-:definitions/stylesVariationBlocksPropertiesComplete!predicate",
                      elements =
                        _js2n__-refsenv."_js2n__-:definitions/stylesElementsPropertiesComplete!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                        _js2n__-prdslib.enum [ "elements", "blocks" ]
                      ]),
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ],
      "_js2n__-:definitions/stylesVariationsProperties!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-z][a-z0-9-]*$" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationProperties!predicate",
                } true _js2n__-prdslib.always
            ],
      "_js2n__-:definitions/stylesVariationsPropertiesComplete!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record {}
                {
                  "^[a-z][a-z0-9-]*$" =
                    _js2n__-refsenv."_js2n__-:definitions/stylesVariationPropertiesComplete!predicate",
                } true _js2n__-prdslib.always
            ],
    }
    in
  {
      "$schema" | String | doc "JSON schema URI for theme.json." | optional,
      blockTypes
        | Array (String)
        | doc "List of block types that can use the block style variation this theme.json file represents."
        | optional,
      customTemplates
        | Array
          {
            name
              | String
              | doc "Filename, without extension, of the template in the templates folder.",
            postTypes
              | Array (String)
              | doc "List of post types that can use this custom template."
              | optional,
            title | String | doc "Title of the template, translatable.",
          }
        | doc "Additional metadata for custom templates defined in the templates folder."
        | optional,
      description
        | String
        | doc "Description of the global styles variation."
        | optional,
      patterns
        | Array (String)
        | doc "An array of pattern slugs to be registered from the Pattern Directory."
        | optional,
      settings
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/settingsProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      blocks =
                        _js2n__-refsenv."_js2n__-:definitions/settingsBlocksPropertiesComplete!predicate",
                      useRootPaddingAwareAlignments =
                        _js2n__-prdslib.isType '"Bool",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/settingsPropertyNames!predicate",
                        _js2n__-prdslib.enum
                          [ "useRootPaddingAwareAlignments", "blocks" ]
                      ]),
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ])
        | doc m%"
          Settings for the block editor and individual blocks. These include things like:
          - Which customization options should be available to the user. 
          - The default colors, font sizes... available to the user. 
          - CSS custom properties and class names used in styles.
          - And the default layout of the editor (widths and available alignments).
        "%
        | optional,
      slug
        | String
        | doc "Slug of the global styles variation. If not defined, the kebab-case title will be used."
        | optional,
      styles
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [
              _js2n__-refsenv."_js2n__-:definitions/stylesProperties!predicate",
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record
                    {
                      blocks =
                        _js2n__-refsenv."_js2n__-:definitions/stylesBlocksPropertiesComplete!predicate",
                      elements =
                        _js2n__-refsenv."_js2n__-:definitions/stylesElementsPropertiesComplete!predicate",
                      variations =
                        _js2n__-refsenv."_js2n__-:definitions/stylesVariationsProperties!predicate",
                    } {} true _js2n__-prdslib.always
                ],
              _js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.propertyNames
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-refsenv."_js2n__-:definitions/stylesPropertyNames!predicate",
                        _js2n__-prdslib.enum
                          [ "elements", "blocks", "variations" ]
                      ]),
                  _js2n__-prdslib.records.record {} {} true
                    _js2n__-prdslib.always
                ]
            ])
        | doc "Organized way to set CSS properties. Styles in the top-level will be added in the `body` selector."
        | optional,
      templateParts
        | Array
          {
            area
              | String
              | doc "The area the template part is used for. Block variations for `header` and `footer` values exist and will be used when the area is set to one of those."
              | optional,
            name
              | String
              | doc "Filename, without extension, of the template in the parts folder.",
            title
              | String
              | doc "Title of the template, translatable."
              | optional,
          }
        | doc "Additional metadata for template parts defined in the parts folder."
        | optional,
      title
        | String
        | doc "Title of the global styles variation. If not defined, the file name will be used."
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.allOf
            [ _js2n__-prdslib.isType 'Integer, _js2n__-prdslib.const 3 ])
        | doc "Version of theme.json to use.",
    }