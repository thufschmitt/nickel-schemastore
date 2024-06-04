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
      "_js2n__-:definitions/filetype_list!predicate"
        | doc m%"
          List of filetypes
          To refer to all filetypes, use [ALL]
        "%
        = _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf (_js2n__-prdslib.isType '"String")
            ],
      "_js2n__-:definitions/linter_list!contract"
        | doc m%"
          List of linter IDs
          To refer to all linters, use [ALL]
        "%
        = Array (String),
      "_js2n__-:definitions/template_string!predicate"
        | doc "String where \"${key1} ${key2}\" will be expanded into \"value1 value2\""
        = _js2n__-prdslib.isType '"String",
    }
    in
  {
      actions
        | {
          definitions
            | Array
              {
                description
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                display_name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                enabled | Bool | optional,
                id
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                interactive | Bool | optional,
                notify_on_error | Bool | optional,
                output_type | String | optional,
                packages_file
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                run
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                run_from
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                runtime | String | optional,
                triggers
                  | Array
                    {
                      files
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      git_hooks
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      schedule
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                ..
              }
            | optional,
          disabled
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            )
            | optional,
          enabled
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            )
            | optional,
          ..
        }
        | optional,
      api
        | {
          address
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | optional,
          ..
        }
        | optional,
      cli
        | {
          check_for_upgrades | Bool | optional,
          options
            | Array
              {
                args
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                commands
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                ..
              }
            | optional,
          sha256
            | {
              darwin_arm64
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              darwin_x86_64
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              linux_x86_64
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              ..
            }
            | optional,
          version
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | optional,
          ..
        }
        | optional,
      daemon
        | {
          check_for_upgrades | Bool | optional,
          log_level | String | optional,
          monitor_repository | Bool | optional,
          ..
        }
        | optional,
      downloads
        | Array
          {
            args
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  ])
              | optional,
            downloads
              | Array
                {
                  cpu
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        ])
                    | optional,
                  os
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {} {} true
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        ])
                    | optional,
                  sha256
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                    | optional,
                  strip_components | std.number.Integer | optional,
                  url
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                    | optional,
                  version
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                    | optional,
                  ..
                }
              | optional,
            executable | Bool | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | optional,
            version
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | optional,
            ..
          }
        | optional,
      environments
        | Array
          {
            environment
              | Array
                {
                  list
                    | Array (
                      _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Number",
                            _js2n__-prdslib.isType '"Bool"
                          ])
                    )
                    | optional,
                  name
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                    | optional,
                  "optional" | Bool | optional,
                  value
                    | _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                    | optional,
                  ..
                }
              | optional,
            name
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
              | optional,
            ..
          }
        | optional,
      lint
        | {
          allow
            | Array
              {
                linters
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                paths
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                ..
              }
            | optional,
          bazel
            | {
              all_targets_query
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              compiler_override_paths
                | Array
                  {
                    cpu | String | optional,
                    os | String | optional,
                    path
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Number",
                            _js2n__-prdslib.isType '"Bool"
                          ])
                      | optional,
                    ..
                  }
                | optional,
              paths
                | {
                  system
                    | Array (
                      _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Number",
                            _js2n__-prdslib.isType '"Bool"
                          ])
                    )
                    | optional,
                  workspace
                    | Array (
                      _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Number",
                            _js2n__-prdslib.isType '"Bool"
                          ])
                    )
                    | optional,
                  ..
                }
                | optional,
              ..
            }
            | optional,
          comment_formats
            | Array
              {
                leading_delimiter
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                trailing_delimiter
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                ..
              }
            | optional,
          compile_commands | String | optional,
          default_max_file_size | std.number.Integer | optional,
          definitions
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        affects_cache =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool"
                                    ])
                              ],
                        allow_empty_files = _js2n__-prdslib.isType '"Bool",
                        batch = _js2n__-prdslib.isType '"Bool",
                        cache_results = _js2n__-prdslib.isType '"Bool",
                        command =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool"
                                    ])
                              ],
                        commands =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          allow_empty_files =
                                            _js2n__-prdslib.isType '"Bool",
                                          batch =
                                            _js2n__-prdslib.isType '"Bool",
                                          cache_results =
                                            _js2n__-prdslib.isType '"Bool",
                                          disable_upstream =
                                            _js2n__-prdslib.isType '"Bool",
                                          enabled =
                                            _js2n__-prdslib.isType '"Bool",
                                          error_codes =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      'Integer)
                                                ],
                                          formatter =
                                            _js2n__-prdslib.isType '"Bool",
                                          in_place =
                                            _js2n__-prdslib.isType '"Bool",
                                          max_file_size =
                                            _js2n__-prdslib.isType 'Integer,
                                          name =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          output =
                                            _js2n__-prdslib.isType '"String",
                                          parse_regex =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          parser =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {
                                                      run =
                                                        _js2n__-prdslib.anyOf
                                                            [
                                                              _js2n__-prdslib.isType
                                                                '"String",
                                                              _js2n__-prdslib.isType
                                                                '"Number",
                                                              _js2n__-prdslib.isType
                                                                '"Bool"
                                                            ],
                                                      runtime =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          prepare_run =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          read_output_from =
                                            _js2n__-prdslib.isType '"String",
                                          run =
                                            _js2n__-refsenv."_js2n__-:definitions/template_string!predicate",
                                          run_from_root_target =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          run_linter_from =
                                            _js2n__-prdslib.isType '"String",
                                          run_when =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      '"String")
                                                ],
                                          stdin =
                                            _js2n__-prdslib.isType '"Bool",
                                          success_codes =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    (_js2n__-prdslib.isType
                                                      'Integer)
                                                ],
                                          supports_sandbox =
                                            _js2n__-prdslib.isType '"Bool",
                                        } {} true _js2n__-prdslib.always
                                    ])
                              ],
                        deprecated =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        direct_configs =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool"
                                    ])
                              ],
                        disable_upstream = _js2n__-prdslib.isType '"Bool",
                        disabled = _js2n__-prdslib.isType '"Bool",
                        download =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        enabled = _js2n__-prdslib.isType '"Bool",
                        environment =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.oneOf
                                        [
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "name", "value" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                          _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.records.required
                                                [ "list", "name" ],
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ]
                                        ],
                                      _js2n__-prdslib.records.record
                                        {
                                          list =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"Array",
                                                  _js2n__-prdslib.arrays.arrayOf
                                                    _js2n__-refsenv."_js2n__-:definitions/template_string!predicate"
                                                ],
                                          name =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          "optional" =
                                            _js2n__-prdslib.isType '"Bool",
                                          value =
                                            _js2n__-refsenv."_js2n__-:definitions/template_string!predicate",
                                        } {} true _js2n__-prdslib.always
                                    ])
                              ],
                        error_codes =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType 'Integer)
                              ],
                        extra_packages =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool"
                                    ])
                              ],
                        files =
                          _js2n__-refsenv."_js2n__-:definitions/filetype_list!predicate",
                        formatter = _js2n__-prdslib.isType '"Bool",
                        good_without_config = _js2n__-prdslib.isType '"Bool",
                        hold_the_line = _js2n__-prdslib.isType '"Bool",
                        in_place = _js2n__-prdslib.isType '"Bool",
                        include_lfs = _js2n__-prdslib.isType '"Bool",
                        include_scanner_type = _js2n__-prdslib.isType '"String",
                        is_manual = _js2n__-prdslib.isType '"Bool",
                        is_recommended = _js2n__-prdslib.isType '"Bool",
                        issue_url_format =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        known_bad_versions =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool"
                                    ])
                              ],
                        known_good_version =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        name =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        package =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        plugin_url =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        prepare_command =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.anyOf
                                    [
                                      _js2n__-prdslib.isType '"String",
                                      _js2n__-prdslib.isType '"Number",
                                      _js2n__-prdslib.isType '"Bool"
                                    ])
                              ],
                        query_compile_commands = _js2n__-prdslib.isType '"Bool",
                        read_output_from = _js2n__-prdslib.isType '"String",
                        run_from_root_file =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        run_from_root_target =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        run_linter_from = _js2n__-prdslib.isType '"String",
                        run_timeout =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        run_when =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType '"String")
                              ],
                        runtime = _js2n__-prdslib.isType '"String",
                        stdin = _js2n__-prdslib.isType '"Bool",
                        success_codes =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.isType 'Integer)
                              ],
                        symlinks =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType '"Array",
                                _js2n__-prdslib.arrays.arrayOf
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          from =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                          to =
                                            _js2n__-prdslib.anyOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    '"String",
                                                  _js2n__-prdslib.isType
                                                    '"Number",
                                                  _js2n__-prdslib.isType '"Bool"
                                                ],
                                        } {} true _js2n__-prdslib.always
                                    ])
                              ],
                        type = _js2n__-prdslib.isType '"String",
                        version =
                          _js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ],
                        version_command =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.record
                                  {
                                    parse_regex =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.isType '"Bool"
                                          ],
                                    run =
                                      _js2n__-prdslib.anyOf
                                          [
                                            _js2n__-prdslib.isType '"String",
                                            _js2n__-prdslib.isType '"Number",
                                            _js2n__-prdslib.isType '"Bool"
                                          ],
                                  } {} true _js2n__-prdslib.always
                              ],
                      } {} true _js2n__-prdslib.always,
                    _js2n__-prdslib.records.dependencies
                      {
                        download =
                          _js2n__-prdslib.not
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.records.required
                                    [ "package" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ]),
                        package =
                          _js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.records.required
                                      [ "runtime" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ],
                                _js2n__-prdslib.not
                                  (_js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.records.required
                                        [ "download" ],
                                      _js2n__-prdslib.records.record {} {} true
                                        _js2n__-prdslib.always
                                    ])
                              ],
                      }
                  ])
            )
            | optional,
          disabled
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            )
            | optional,
          do_not_recommend_linters
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            )
            | optional,
          downloads
            | Array
              {
                args
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                      ])
                  | optional,
                downloads
                  | Array
                    {
                      cpu
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.isType '"Bool"
                                  ])
                            ])
                        | optional,
                      os
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record {} {} true
                                (_js2n__-prdslib.anyOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.isType '"Number",
                                    _js2n__-prdslib.isType '"Bool"
                                  ])
                            ])
                        | optional,
                      sha256
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      strip_components | std.number.Integer | optional,
                      url
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      version
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                executable | Bool | optional,
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                ..
              }
            | optional,
          enabled
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record {} {} true
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.records.record
                                {
                                  commands =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.isType '"Bool"
                                              ])
                                        ],
                                  name =
                                    _js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.isType '"Bool"
                                        ],
                                  packages =
                                    _js2n__-prdslib.allOf
                                        [
                                          _js2n__-prdslib.isType '"Array",
                                          _js2n__-prdslib.arrays.arrayOf
                                            (_js2n__-prdslib.anyOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.isType
                                                  '"Number",
                                                _js2n__-prdslib.isType '"Bool"
                                              ])
                                        ],
                                } {} true _js2n__-prdslib.always
                            ])
                      ]
                  ])
            )
            | optional,
          environments
            | Array
              {
                environment
                  | Array
                    {
                      list
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      "optional" | Bool | optional,
                      value
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                ..
              }
            | optional,
          files
            | Array
              {
                comments
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                extensions
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                filenames
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                inherit
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                regexes
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                shebangs
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                ..
              }
            | optional,
          ignore
            | Array
              {
                linters
                  | _js2n__-refsenv."_js2n__-:definitions/linter_list!contract"
                  | optional,
                paths
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | doc "Paths to exclude from linting"
                  | optional,
                ..
              }
            | optional,
          landing_mode
            | Array
              {
                landing_mode | String | optional,
                linters
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                ..
              }
            | optional,
          linters
            | Array
              {
                affects_cache
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                allow_empty_files | Bool | optional,
                batch | Bool | optional,
                cache_results | Bool | optional,
                command
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                commands
                  | Array
                    {
                      allow_empty_files | Bool | optional,
                      batch | Bool | optional,
                      cache_results | Bool | optional,
                      disable_upstream | Bool | optional,
                      enabled | Bool | optional,
                      error_codes | Array std.number.Integer | optional,
                      formatter | Bool | optional,
                      in_place | Bool | optional,
                      max_file_size | std.number.Integer | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      output | String | optional,
                      parse_regex
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      parser
                        | {
                          run
                            | _js2n__-prdslib.contract_from_predicate
                              (_js2n__-prdslib.anyOf
                                [
                                  _js2n__-prdslib.isType '"String",
                                  _js2n__-prdslib.isType '"Number",
                                  _js2n__-prdslib.isType '"Bool"
                                ])
                            | optional,
                          runtime | String | optional,
                          ..
                        }
                        | optional,
                      prepare_run
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      read_output_from | String | optional,
                      run
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      run_from_root_target
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      run_linter_from | String | optional,
                      run_when | Array (String) | optional,
                      stdin | Bool | optional,
                      success_codes | Array std.number.Integer | optional,
                      supports_sandbox | Bool | optional,
                      ..
                    }
                  | optional,
                deprecated
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                direct_configs
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                disable_upstream | Bool | optional,
                disabled | Bool | optional,
                download
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                enabled | Bool | optional,
                environment
                  | Array
                    {
                      list
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      "optional" | Bool | optional,
                      value
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                error_codes | Array std.number.Integer | optional,
                extra_packages
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                files
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                formatter | Bool | optional,
                good_without_config | Bool | optional,
                hold_the_line | Bool | optional,
                in_place | Bool | optional,
                include_lfs | Bool | optional,
                include_scanner_type | String | optional,
                is_manual | Bool | optional,
                is_recommended | Bool | optional,
                issue_url_format
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                known_bad_versions
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                known_good_version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                name
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                package
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                plugin_url
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                prepare_command
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                query_compile_commands | Bool | optional,
                read_output_from | String | optional,
                run_from_root_file
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                run_from_root_target
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                run_linter_from | String | optional,
                run_timeout
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                run_when | Array (String) | optional,
                runtime | String | optional,
                stdin | Bool | optional,
                success_codes | Array std.number.Integer | optional,
                symlinks
                  | Array
                    {
                      from
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      to
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                type | String | optional,
                version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                version_command
                  | {
                    parse_regex
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Number",
                            _js2n__-prdslib.isType '"Bool"
                          ])
                      | optional,
                    run
                      | _js2n__-prdslib.contract_from_predicate
                        (_js2n__-prdslib.anyOf
                          [
                            _js2n__-prdslib.isType '"String",
                            _js2n__-prdslib.isType '"Number",
                            _js2n__-prdslib.isType '"Bool"
                          ])
                      | optional,
                    ..
                  }
                  | optional,
                ..
              }
            | optional,
          runtimes
            | Array
              {
                download
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                enabled | Bool | optional,
                known_good_version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                linter_environment
                  | Array
                    {
                      list
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      "optional" | Bool | optional,
                      value
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                runtime_environment
                  | Array
                    {
                      list
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      "optional" | Bool | optional,
                      value
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                system_version | String | optional,
                type | String | optional,
                version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                version_commands
                  | Array
                    {
                      parse_regex
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      run
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                ..
              }
            | optional,
          shared_configs
            | Array
              {
                file
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                regex
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                ..
              }
            | optional,
          threshold
            | Array
              {
                level | String | optional,
                linters
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                ..
              }
            | optional,
          triggers
            | Array
              {
                files
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                linters
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                paths
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                regexes
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                targets
                  | Array (
                    _js2n__-prdslib.contract_from_predicate
                      (_js2n__-prdslib.anyOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.isType '"Number",
                          _js2n__-prdslib.isType '"Bool"
                        ])
                  )
                  | optional,
                ..
              }
            | optional,
          ..
        }
        | optional,
      "merge"
        | {
          required_statuses
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            )
            | optional,
          statuses
            | Array (
              _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.anyOf
                  [
                    _js2n__-prdslib.isType '"String",
                    _js2n__-prdslib.isType '"Number",
                    _js2n__-prdslib.isType '"Bool"
                  ])
            )
            | optional,
          ..
        }
        | optional,
      notifications
        | {
          sleep
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            "priority" =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record {} {} true
                                      (_js2n__-prdslib.anyOf
                                        [
                                          _js2n__-prdslib.isType '"String",
                                          _js2n__-prdslib.isType '"Number",
                                          _js2n__-prdslib.isType '"Bool"
                                        ])
                                  ],
                          } {} true _js2n__-prdslib.always
                      ])
                ])
            | optional,
          ..
        }
        | optional,
      plugin_url
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool"
            ])
        | optional,
      plugins
        | {
          sources
            | Array
              {
                id
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                import_to_global | Bool | optional,
                local
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                ref
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                uri
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                ..
              }
            | optional,
          ..
        }
        | optional,
      repo
        | {
          git
            | {
              allowed_user_email_domains
                | Array (
                  _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                )
                | optional,
              branch_name_format
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              new_files_warning_threshold_kb | std.number.Integer | optional,
              ..
            }
            | optional,
          repo
            | {
              host
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              name
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              owner
                | _js2n__-prdslib.contract_from_predicate
                  (_js2n__-prdslib.anyOf
                    [
                      _js2n__-prdslib.isType '"String",
                      _js2n__-prdslib.isType '"Number",
                      _js2n__-prdslib.isType '"Bool"
                    ])
                | optional,
              ..
            }
            | optional,
          trunk_branch
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | optional,
          trunk_primary_remote
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.anyOf
                [
                  _js2n__-prdslib.isType '"String",
                  _js2n__-prdslib.isType '"Number",
                  _js2n__-prdslib.isType '"Bool"
                ])
            | optional,
          use_branch_upstream | Bool | optional,
          ..
        }
        | optional,
      required_trunk_version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.anyOf
            [
              _js2n__-prdslib.isType '"String",
              _js2n__-prdslib.isType '"Number",
              _js2n__-prdslib.isType '"Bool"
            ])
        | optional,
      runtimes
        | {
          definitions
            | Array
              {
                download
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                enabled | Bool | optional,
                known_good_version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                linter_environment
                  | Array
                    {
                      list
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      "optional" | Bool | optional,
                      value
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                runtime_environment
                  | Array
                    {
                      list
                        | Array (
                          _js2n__-prdslib.contract_from_predicate
                            (_js2n__-prdslib.anyOf
                              [
                                _js2n__-prdslib.isType '"String",
                                _js2n__-prdslib.isType '"Number",
                                _js2n__-prdslib.isType '"Bool"
                              ])
                        )
                        | optional,
                      name
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      "optional" | Bool | optional,
                      value
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                system_version | String | optional,
                type | String | optional,
                version
                  | _js2n__-prdslib.contract_from_predicate
                    (_js2n__-prdslib.anyOf
                      [
                        _js2n__-prdslib.isType '"String",
                        _js2n__-prdslib.isType '"Number",
                        _js2n__-prdslib.isType '"Bool"
                      ])
                  | optional,
                version_commands
                  | Array
                    {
                      parse_regex
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      run
                        | _js2n__-prdslib.contract_from_predicate
                          (_js2n__-prdslib.anyOf
                            [
                              _js2n__-prdslib.isType '"String",
                              _js2n__-prdslib.isType '"Number",
                              _js2n__-prdslib.isType '"Bool"
                            ])
                        | optional,
                      ..
                    }
                  | optional,
                ..
              }
            | optional,
          enabled | Array (String) | optional,
          ..
        }
        | optional,
      version
        | _js2n__-prdslib.contract_from_predicate
          (_js2n__-prdslib.enum [ "0.1", 0.1 ])
        | doc "The trunk config version being parsed. The only possible value is 0.1.",
      ..
    }