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
      "_js2n__-:then/else/then/definitions/metadata!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  copyright = _js2n__-prdslib.isType '"String",
                  name = _js2n__-prdslib.isType '"String",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/else/then/definitions/metadata-3.0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  copyright = _js2n__-prdslib.isType '"String",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 80,
                          _js2n__-prdslib.strings.minLength 3,
                          _js2n__-prdslib.strings.pattern
                            "^(?:@[0-9a-z-_.]+\\/)?[a-z][0-9a-z-_.]*$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/else/then/else/else/else/then/definitions/shims!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  collections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          modules =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {}
                                                    {
                                                      ".+" =
                                                        _js2n__-prdslib.isType
                                                            '"String",
                                                    } false
                                                    _js2n__-prdslib.never
                                                ],
                                        } {} false _js2n__-prdslib.never
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                  configurations =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            { ".+" = _js2n__-prdslib.isType 'Record, } false
                            _js2n__-prdslib.never
                        ],
                  dependencies =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record {}
                            {
                              ".+" =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType '"Array",
                                      _js2n__-prdslib.arrays.arrayOf
                                        (_js2n__-prdslib.isType '"String")
                                    ],
                            } false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/else/then/else/else/then/definitions/middleware!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:then/else/then/else/then/definitions/task!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                { path = _js2n__-prdslib.isType '"String", } {} false
                _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        bundleDefinition =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleDefinition!predicate",
                        bundleOptions =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleOptions!predicate",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-2.4!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        bundleDefinition =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleDefinition-2.4!predicate",
                        bundleOptions =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleOptions!predicate",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-3.0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        bundleDefinition =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleDefinition-2.4!predicate",
                        bundleOptions =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleOptions-3.0!predicate",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-3.2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record
                      {
                        bundleDefinition =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleDefinition-3.2!predicate",
                        bundleOptions =
                          _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-bundleOptions-3.0!predicate",
                      } {} false _js2n__-prdslib.never
                  ]),
              _js2n__-prdslib.records.record {} {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-bundleDefinition!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  defaultFileTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  sections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "filters", "mode" ],
                                _js2n__-prdslib.records.record
                                  {
                                    declareRawModules =
                                      _js2n__-prdslib.isType '"Bool",
                                    filters =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    mode =
                                      _js2n__-prdslib.enum
                                          [
                                            "raw",
                                            "preload",
                                            "require",
                                            "provided"
                                          ],
                                    name = _js2n__-prdslib.isType '"String",
                                    renderer = _js2n__-prdslib.isType '"Bool",
                                    resolve = _js2n__-prdslib.isType '"Bool",
                                    resolveConditional =
                                      _js2n__-prdslib.isType '"Bool",
                                    sort = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-bundleDefinition-2.4!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  defaultFileTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  sections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "filters", "mode" ],
                                _js2n__-prdslib.records.record
                                  {
                                    declareRawModules =
                                      _js2n__-prdslib.isType '"Bool",
                                    filters =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    mode =
                                      _js2n__-prdslib.enum
                                          [
                                            "raw",
                                            "preload",
                                            "require",
                                            "provided",
                                            "bundleInfo"
                                          ],
                                    name = _js2n__-prdslib.isType '"String",
                                    renderer = _js2n__-prdslib.isType '"Bool",
                                    resolve = _js2n__-prdslib.isType '"Bool",
                                    resolveConditional =
                                      _js2n__-prdslib.isType '"Bool",
                                    sort = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-bundleDefinition-3.2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  defaultFileTypes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  name = _js2n__-prdslib.isType '"String",
                  sections =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.records.required
                                  [ "filters", "mode" ],
                                _js2n__-prdslib.records.record
                                  {
                                    declareRawModules =
                                      _js2n__-prdslib.isType '"Bool",
                                    filters =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType '"Array",
                                            _js2n__-prdslib.arrays.arrayOf
                                              (_js2n__-prdslib.isType '"String")
                                          ],
                                    mode =
                                      _js2n__-prdslib.enum
                                          [
                                            "raw",
                                            "preload",
                                            "require",
                                            "provided",
                                            "bundleInfo",
                                            "depCache"
                                          ],
                                    name = _js2n__-prdslib.isType '"String",
                                    renderer = _js2n__-prdslib.isType '"Bool",
                                    resolve = _js2n__-prdslib.isType '"Bool",
                                    resolveConditional =
                                      _js2n__-prdslib.isType '"Bool",
                                    sort = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-bundleOptions!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addTryCatchRestartWrapper = _js2n__-prdslib.isType '"Bool",
                  decorateBootstrapModule = _js2n__-prdslib.isType '"Bool",
                  numberOfParts = _js2n__-prdslib.isType '"Number",
                  optimize = _js2n__-prdslib.isType '"Bool",
                  usePredefineCalls = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-bundles-bundleOptions-3.0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  addTryCatchRestartWrapper = _js2n__-prdslib.isType '"Bool",
                  decorateBootstrapModule = _js2n__-prdslib.isType '"Bool",
                  numberOfParts = _js2n__-prdslib.isType '"Number",
                  optimize = _js2n__-prdslib.isType '"Bool",
                  sourceMap = _js2n__-prdslib.isType '"Bool",
                  usePredefineCalls = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-componentPreload!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  namespaces =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  namespaces =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  paths =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-libraryPreload!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-minification!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-resources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/builder-settings!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  includeDependency =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includeDependencyRegExp =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                  includeDependencyTree =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/customTasks!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType '"Array",
              _js2n__-prdslib.arrays.arrayOf
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "beforeTask", "name" ],
                        _js2n__-prdslib.records.record
                          {
                            beforeTask = _js2n__-prdslib.isType '"String",
                            configuration = _js2n__-prdslib.always,
                            name = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.required
                          [ "afterTask", "name" ],
                        _js2n__-prdslib.records.record
                          {
                            afterTask = _js2n__-prdslib.isType '"String",
                            configuration = _js2n__-prdslib.always,
                            name = _js2n__-prdslib.isType '"String",
                          } {} false _js2n__-prdslib.never
                      ]
                  ])
            ],
      "_js2n__-:then/then/definitions/framework!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  libraries =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.not
                                    (_js2n__-prdslib.anyOf
                                      [
                                        _js2n__-prdslib.records.record
                                          {
                                            "optional" =
                                              _js2n__-prdslib.enum
                                                  [ false, null ],
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.records.record
                                          {
                                            development =
                                              _js2n__-prdslib.enum
                                                  [ false, null ],
                                          } {} true _js2n__-prdslib.always,
                                        _js2n__-prdslib.not
                                          (_js2n__-prdslib.records.record
                                            {
                                              "optional" =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always),
                                        _js2n__-prdslib.not
                                          (_js2n__-prdslib.records.record
                                            {
                                              development =
                                                _js2n__-prdslib.isType '"Bool",
                                            } {} true _js2n__-prdslib.always)
                                      ]))
                                  (_js2n__-prdslib.records.record
                                    { name = _js2n__-prdslib.isType '"String", }
                                    {} false _js2n__-prdslib.never)
                                  _js2n__-prdslib.always,
                                _js2n__-prdslib.records.required [ "name" ],
                                _js2n__-prdslib.records.record
                                  {
                                    development =
                                      _js2n__-prdslib.isType '"Bool",
                                    name = _js2n__-prdslib.isType '"String",
                                    "optional" = _js2n__-prdslib.isType '"Bool",
                                  } {} false _js2n__-prdslib.never
                              ])
                        ],
                  name = _js2n__-prdslib.enum [ "OpenUI5", "SAPUI5" ],
                  version =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.pattern
                            "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/metadata!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  allowSapInternal = _js2n__-prdslib.isType '"Bool",
                  copyright = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  name = _js2n__-prdslib.isType '"String",
                  sapInternal = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/metadata-3.0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.required [ "name" ],
              _js2n__-prdslib.records.record
                {
                  allowSapInternal = _js2n__-prdslib.isType '"Bool",
                  copyright = _js2n__-prdslib.isType '"String",
                  deprecated = _js2n__-prdslib.isType '"Bool",
                  name =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"String",
                          _js2n__-prdslib.strings.maxLength 80,
                          _js2n__-prdslib.strings.minLength 3,
                          _js2n__-prdslib.strings.pattern
                            "^(?:@[0-9a-z-_.]+\\/)?[a-z][0-9a-z-_.]*$"
                        ],
                  sapInternal = _js2n__-prdslib.isType '"Bool",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/definitions/resources-configuration-propertiesFileSourceEncoding!predicate"
        | doc "By default, the UI5 Tooling expects *.properties files to be UTF-8 encoded."
        = _js2n__-prdslib.enum [ "UTF-8", "ISO-8859-1" ],
      "_js2n__-:then/then/definitions/server!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customMiddleware =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.oneOf
                              [
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "beforeMiddleware", "name" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        beforeMiddleware =
                                          _js2n__-prdslib.isType '"String",
                                        configuration = _js2n__-prdslib.always,
                                        mountPath =
                                          _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ],
                                _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "afterMiddleware", "name" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        afterMiddleware =
                                          _js2n__-prdslib.isType '"String",
                                        configuration = _js2n__-prdslib.always,
                                        mountPath =
                                          _js2n__-prdslib.isType '"String",
                                        name = _js2n__-prdslib.isType '"String",
                                      } {} false _js2n__-prdslib.never
                                  ]
                              ])
                        ],
                  settings =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              httpPort = _js2n__-prdslib.isType '"Number",
                              httpsPort = _js2n__-prdslib.isType '"Number",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/else/else/then/definitions/builder-specVersion-2.5!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/else/else/then/definitions/builder-specVersion-3.1!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/else/else/then/definitions/resources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              paths =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record {}
                                        {
                                          ".+" =
                                            _js2n__-prdslib.isType '"String",
                                        } false _js2n__-prdslib.never
                                    ],
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/else/then/definitions/builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/else/then/definitions/builder-specVersion-2.5!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  excludes =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType '"Array",
                          _js2n__-prdslib.arrays.arrayOf
                            (_js2n__-prdslib.isType '"String")
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.3!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  libraryPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-libraryPreload!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.4!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-2.4!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  libraryPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-libraryPreload!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.5!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-2.4!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  libraryPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-libraryPreload!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.6!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-2.4!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  libraryPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-libraryPreload!predicate",
                  minification =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-minification!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-specVersion-3.0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-3.0!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  libraryPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-libraryPreload!predicate",
                  minification =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-minification!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/builder-specVersion-3.2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-3.2!predicate",
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  jsdoc =
                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-jsdoc!predicate",
                  libraryPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-libraryPreload!predicate",
                  minification =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-minification!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/else/then/definitions/resources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              paths =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          src =
                                            _js2n__-prdslib.isType '"String",
                                          test =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              propertiesFileSourceEncoding =
                                _js2n__-refsenv."_js2n__-:then/then/definitions/resources-configuration-propertiesFileSourceEncoding!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder-specVersion-2.3!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder-specVersion-2.4!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-2.4!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder-specVersion-2.5!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-2.4!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder-specVersion-2.6!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-2.4!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  minification =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-minification!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder-specVersion-3.0!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-3.0!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  minification =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-minification!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/builder-specVersion-3.2!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  bundles =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-bundles-3.2!predicate",
                  cachebuster =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              signatureType =
                                _js2n__-prdslib.enum [ "time", "hash" ],
                            } {} false _js2n__-prdslib.never
                        ],
                  componentPreload =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-componentPreload-specVersion-2.3!predicate",
                  customTasks =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/customTasks!predicate",
                  minification =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-minification!predicate",
                  resources =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-resources!predicate",
                  settings =
                    _js2n__-refsenv."_js2n__-:then/then/definitions/builder-settings!predicate",
                } {} false _js2n__-prdslib.never
            ],
      "_js2n__-:then/then/else/then/definitions/resources!predicate" =
        _js2n__-prdslib.allOf
            [
              _js2n__-prdslib.isType 'Record,
              _js2n__-prdslib.records.record
                {
                  configuration =
                    _js2n__-prdslib.allOf
                        [
                          _js2n__-prdslib.isType 'Record,
                          _js2n__-prdslib.records.record
                            {
                              paths =
                                _js2n__-prdslib.allOf
                                    [
                                      _js2n__-prdslib.isType 'Record,
                                      _js2n__-prdslib.records.record
                                        {
                                          webapp =
                                            _js2n__-prdslib.isType '"String",
                                        } {} false _js2n__-prdslib.never
                                    ],
                              propertiesFileSourceEncoding =
                                _js2n__-refsenv."_js2n__-:then/then/definitions/resources-configuration-propertiesFileSourceEncoding!predicate",
                            } {} false _js2n__-prdslib.never
                        ],
                } {} false _js2n__-prdslib.never
            ],
    }
    in
  _js2n__-prdslib.contract_from_predicate
      (_js2n__-prdslib.allOf
        [
          _js2n__-prdslib.isType 'Record,
          _js2n__-prdslib.ifThenElse
            (_js2n__-prdslib.records.record
              {
                specVersion =
                  _js2n__-prdslib.enum
                      [
                        "3.2",
                        "3.1",
                        "3.0",
                        "2.6",
                        "2.5",
                        "2.4",
                        "2.3",
                        "2.2",
                        "2.1",
                        "2.0"
                      ],
              } {} true _js2n__-prdslib.always)
            (_js2n__-prdslib.allOf
              [
                _js2n__-prdslib.isType 'Record,
                _js2n__-prdslib.ifThenElse
                  (_js2n__-prdslib.records.record
                    { kind = _js2n__-prdslib.enum [ "project", null ], } {} true
                    _js2n__-prdslib.always)
                  (_js2n__-prdslib.allOf
                    [
                      _js2n__-prdslib.isType 'Record,
                      _js2n__-prdslib.ifThenElse
                        (_js2n__-prdslib.records.record
                          { type = _js2n__-prdslib.const null, } {} true
                          _js2n__-prdslib.always) _js2n__-prdslib.always
                        (_js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const "application", } {}
                            true _js2n__-prdslib.always)
                          (_js2n__-prdslib.allOf
                            [
                              _js2n__-prdslib.isType 'Record,
                              _js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    specVersion =
                                      _js2n__-prdslib.enum [ "3.2" ],
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.records.record
                                  {
                                    builder =
                                      _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder-specVersion-3.2!predicate",
                                    customConfiguration =
                                      _js2n__-prdslib.allOf
                                          [
                                            _js2n__-prdslib.isType 'Record,
                                            _js2n__-prdslib.records.record {} {}
                                              true _js2n__-prdslib.always
                                          ],
                                    framework =
                                      _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                    kind =
                                      _js2n__-prdslib.enum [ "project", null ],
                                    metadata =
                                      _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                    resources =
                                      _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                    server =
                                      _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                    specVersion =
                                      _js2n__-prdslib.enum [ "3.2" ],
                                    type =
                                      _js2n__-prdslib.enum [ "application" ],
                                  } {} false _js2n__-prdslib.never)
                                (_js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      specVersion =
                                        _js2n__-prdslib.enum [ "3.0", "3.1" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      builder =
                                        _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder-specVersion-3.0!predicate",
                                      customConfiguration =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                      framework =
                                        _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                      kind =
                                        _js2n__-prdslib.enum
                                            [ "project", null ],
                                      metadata =
                                        _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                      resources =
                                        _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                      server =
                                        _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                      specVersion =
                                        _js2n__-prdslib.enum [ "3.0", "3.1" ],
                                      type =
                                        _js2n__-prdslib.enum [ "application" ],
                                    } {} false _js2n__-prdslib.never)
                                  (_js2n__-prdslib.ifThenElse
                                    (_js2n__-prdslib.records.record
                                      {
                                        specVersion =
                                          _js2n__-prdslib.enum [ "2.6" ],
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.records.record
                                      {
                                        builder =
                                          _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder-specVersion-2.6!predicate",
                                        customConfiguration =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        framework =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                        kind =
                                          _js2n__-prdslib.enum
                                              [ "project", null ],
                                        metadata =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                        resources =
                                          _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                        server =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                        specVersion =
                                          _js2n__-prdslib.enum [ "2.6" ],
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "application" ],
                                      } {} false _js2n__-prdslib.never)
                                    (_js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          specVersion =
                                            _js2n__-prdslib.enum [ "2.5" ],
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.records.record
                                        {
                                          builder =
                                            _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder-specVersion-2.5!predicate",
                                          customConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          framework =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "project", null ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                          resources =
                                            _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                          server =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum [ "2.5" ],
                                          type =
                                            _js2n__-prdslib.enum
                                                [ "application" ],
                                        } {} false _js2n__-prdslib.never)
                                      (_js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            specVersion =
                                              _js2n__-prdslib.enum [ "2.4" ],
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            builder =
                                              _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder-specVersion-2.4!predicate",
                                            customConfiguration =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            framework =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "project", null ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                            resources =
                                              _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                            server =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum [ "2.4" ],
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "application" ],
                                          } {} false _js2n__-prdslib.never)
                                        (_js2n__-prdslib.ifThenElse
                                          (_js2n__-prdslib.records.record
                                            {
                                              specVersion =
                                                _js2n__-prdslib.enum [ "2.3" ],
                                            } {} true _js2n__-prdslib.always)
                                          (_js2n__-prdslib.records.record
                                            {
                                              builder =
                                                _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder-specVersion-2.3!predicate",
                                              customConfiguration =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                              framework =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                              kind =
                                                _js2n__-prdslib.enum
                                                    [ "project", null ],
                                              metadata =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                              resources =
                                                _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                              server =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                              specVersion =
                                                _js2n__-prdslib.enum [ "2.3" ],
                                              type =
                                                _js2n__-prdslib.enum
                                                    [ "application" ],
                                            } {} false _js2n__-prdslib.never)
                                          (_js2n__-prdslib.ifThenElse
                                            (_js2n__-prdslib.records.record
                                              {
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [ "2.1", "2.2" ],
                                              } {} true _js2n__-prdslib.always)
                                            (_js2n__-prdslib.records.record
                                              {
                                                builder =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder!predicate",
                                                customConfiguration =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {} {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                framework =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                                kind =
                                                  _js2n__-prdslib.enum
                                                      [ "project", null ],
                                                metadata =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                resources =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                                server =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [ "2.1", "2.2" ],
                                                type =
                                                  _js2n__-prdslib.enum
                                                      [ "application" ],
                                              } {} false _js2n__-prdslib.never)
                                            (_js2n__-prdslib.records.record
                                              {
                                                builder =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/builder!predicate",
                                                framework =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                                kind =
                                                  _js2n__-prdslib.enum
                                                      [ "project", null ],
                                                metadata =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                resources =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/then/definitions/resources!predicate",
                                                server =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [ "2.0" ],
                                                type =
                                                  _js2n__-prdslib.enum
                                                      [ "application" ],
                                              } {} false
                                              _js2n__-prdslib.never))))))),
                              _js2n__-prdslib.records.required
                                [ "metadata", "specVersion", "type" ],
                              _js2n__-prdslib.records.record {} {} true
                                _js2n__-prdslib.always
                            ])
                          (_js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "library", } {}
                              true _js2n__-prdslib.always)
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      specVersion =
                                        _js2n__-prdslib.enum [ "3.2" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      builder =
                                        _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-specVersion-3.2!predicate",
                                      customConfiguration =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                      framework =
                                        _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                      kind =
                                        _js2n__-prdslib.enum
                                            [ "project", null ],
                                      metadata =
                                        _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                      resources =
                                        _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                      server =
                                        _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                      specVersion =
                                        _js2n__-prdslib.enum [ "3.2" ],
                                      type = _js2n__-prdslib.enum [ "library" ],
                                    } {} false _js2n__-prdslib.never)
                                  (_js2n__-prdslib.ifThenElse
                                    (_js2n__-prdslib.records.record
                                      {
                                        specVersion =
                                          _js2n__-prdslib.enum [ "3.0", "3.1" ],
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.records.record
                                      {
                                        builder =
                                          _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-specVersion-3.0!predicate",
                                        customConfiguration =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        framework =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                        kind =
                                          _js2n__-prdslib.enum
                                              [ "project", null ],
                                        metadata =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                        resources =
                                          _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                        server =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                        specVersion =
                                          _js2n__-prdslib.enum [ "3.0", "3.1" ],
                                        type =
                                          _js2n__-prdslib.enum [ "library" ],
                                      } {} false _js2n__-prdslib.never)
                                    (_js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          specVersion =
                                            _js2n__-prdslib.enum [ "2.6" ],
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.records.record
                                        {
                                          builder =
                                            _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.6!predicate",
                                          customConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          framework =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "project", null ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                          resources =
                                            _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                          server =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum [ "2.6" ],
                                          type =
                                            _js2n__-prdslib.enum [ "library" ],
                                        } {} false _js2n__-prdslib.never)
                                      (_js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            specVersion =
                                              _js2n__-prdslib.enum [ "2.5" ],
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            builder =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.5!predicate",
                                            customConfiguration =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            framework =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "project", null ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                            resources =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                            server =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum [ "2.5" ],
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "library" ],
                                          } {} false _js2n__-prdslib.never)
                                        (_js2n__-prdslib.ifThenElse
                                          (_js2n__-prdslib.records.record
                                            {
                                              specVersion =
                                                _js2n__-prdslib.enum [ "2.4" ],
                                            } {} true _js2n__-prdslib.always)
                                          (_js2n__-prdslib.records.record
                                            {
                                              builder =
                                                _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.4!predicate",
                                              customConfiguration =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                              framework =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                              kind =
                                                _js2n__-prdslib.enum
                                                    [ "project", null ],
                                              metadata =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                              resources =
                                                _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                              server =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                              specVersion =
                                                _js2n__-prdslib.enum [ "2.4" ],
                                              type =
                                                _js2n__-prdslib.enum
                                                    [ "library" ],
                                            } {} false _js2n__-prdslib.never)
                                          (_js2n__-prdslib.ifThenElse
                                            (_js2n__-prdslib.records.record
                                              {
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [ "2.3" ],
                                              } {} true _js2n__-prdslib.always)
                                            (_js2n__-prdslib.records.record
                                              {
                                                builder =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder-specVersion-2.3!predicate",
                                                customConfiguration =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {} {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                framework =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                                kind =
                                                  _js2n__-prdslib.enum
                                                      [ "project", null ],
                                                metadata =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                resources =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                                server =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [ "2.3" ],
                                                type =
                                                  _js2n__-prdslib.enum
                                                      [ "library" ],
                                              } {} false _js2n__-prdslib.never)
                                            (_js2n__-prdslib.ifThenElse
                                              (_js2n__-prdslib.records.record
                                                {
                                                  specVersion =
                                                    _js2n__-prdslib.enum
                                                        [ "2.1", "2.2" ],
                                                } {} true
                                                _js2n__-prdslib.always)
                                              (_js2n__-prdslib.records.record
                                                {
                                                  builder =
                                                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder!predicate",
                                                  customConfiguration =
                                                    _js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            'Record,
                                                          _js2n__-prdslib.records.record
                                                            {} {} true
                                                            _js2n__-prdslib.always
                                                        ],
                                                  framework =
                                                    _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                                  kind =
                                                    _js2n__-prdslib.enum
                                                        [ "project", null ],
                                                  metadata =
                                                    _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                  resources =
                                                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                                  server =
                                                    _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                                  specVersion =
                                                    _js2n__-prdslib.enum
                                                        [ "2.1", "2.2" ],
                                                  type =
                                                    _js2n__-prdslib.enum
                                                        [ "library" ],
                                                } {} false
                                                _js2n__-prdslib.never)
                                              (_js2n__-prdslib.records.record
                                                {
                                                  builder =
                                                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/builder!predicate",
                                                  framework =
                                                    _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                                  kind =
                                                    _js2n__-prdslib.enum
                                                        [ "project", null ],
                                                  metadata =
                                                    _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                  resources =
                                                    _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                                  server =
                                                    _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                                  specVersion =
                                                    _js2n__-prdslib.enum
                                                        [ "2.0" ],
                                                  type =
                                                    _js2n__-prdslib.enum
                                                        [ "library" ],
                                                } {} false
                                                _js2n__-prdslib.never))))))),
                                _js2n__-prdslib.records.required
                                  [ "metadata", "specVersion", "type" ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ])
                            (_js2n__-prdslib.ifThenElse
                              (_js2n__-prdslib.records.record
                                {
                                  type = _js2n__-prdslib.const "theme-library",
                                } {} true _js2n__-prdslib.always)
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.ifThenElse
                                    (_js2n__-prdslib.records.record
                                      {
                                        specVersion =
                                          _js2n__-prdslib.enum
                                              [ "3.0", "3.1", "3.2" ],
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.records.record
                                      {
                                        builder =
                                          _js2n__-refsenv."_js2n__-:then/then/else/else/else/then/definitions/builder-specVersion-2.5!predicate",
                                        customConfiguration =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        framework =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                        kind =
                                          _js2n__-prdslib.enum
                                              [ "project", null ],
                                        metadata =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                        resources =
                                          _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                        server =
                                          _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                        specVersion =
                                          _js2n__-prdslib.enum
                                              [ "3.0", "3.1", "3.2" ],
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "theme-library" ],
                                      } {} false _js2n__-prdslib.never)
                                    (_js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [ "2.5", "2.6" ],
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.records.record
                                        {
                                          builder =
                                            _js2n__-refsenv."_js2n__-:then/then/else/else/else/then/definitions/builder-specVersion-2.5!predicate",
                                          customConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          framework =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "project", null ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                          resources =
                                            _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                          server =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [ "2.5", "2.6" ],
                                          type =
                                            _js2n__-prdslib.enum
                                                [ "theme-library" ],
                                        } {} false _js2n__-prdslib.never)
                                      (_js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            specVersion =
                                              _js2n__-prdslib.enum
                                                  [
                                                    "2.1",
                                                    "2.2",
                                                    "2.3",
                                                    "2.4"
                                                  ],
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            builder =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/else/then/definitions/builder!predicate",
                                            customConfiguration =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            framework =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "project", null ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                            resources =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                            server =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum
                                                  [
                                                    "2.1",
                                                    "2.2",
                                                    "2.3",
                                                    "2.4"
                                                  ],
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "theme-library" ],
                                          } {} false _js2n__-prdslib.never)
                                        (_js2n__-prdslib.records.record
                                          {
                                            builder =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/else/then/definitions/builder!predicate",
                                            framework =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/framework!predicate",
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "project", null ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                            resources =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/then/definitions/resources!predicate",
                                            server =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum [ "2.0" ],
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "theme-library" ],
                                          } {} false _js2n__-prdslib.never))),
                                  _js2n__-prdslib.records.required
                                    [ "metadata", "specVersion", "type" ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ])
                              (_js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  { type = _js2n__-prdslib.const "module", } {}
                                  true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [ "3.1", "3.2" ],
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.records.record
                                        {
                                          builder =
                                            _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/builder-specVersion-3.1!predicate",
                                          customConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "project", null ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                          resources =
                                            _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/resources!predicate",
                                          server =
                                            _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [ "3.1", "3.2" ],
                                          type =
                                            _js2n__-prdslib.enum [ "module" ],
                                        } {} false _js2n__-prdslib.never)
                                      (_js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            specVersion =
                                              _js2n__-prdslib.enum [ "3.0" ],
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            builder =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/builder-specVersion-2.5!predicate",
                                            customConfiguration =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "project", null ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/metadata-3.0!predicate",
                                            resources =
                                              _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/resources!predicate",
                                            server =
                                              _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum [ "3.0" ],
                                            type =
                                              _js2n__-prdslib.enum [ "module" ],
                                          } {} false _js2n__-prdslib.never)
                                        (_js2n__-prdslib.ifThenElse
                                          (_js2n__-prdslib.records.record
                                            {
                                              specVersion =
                                                _js2n__-prdslib.enum
                                                    [ "2.5", "2.6" ],
                                            } {} true _js2n__-prdslib.always)
                                          (_js2n__-prdslib.records.record
                                            {
                                              builder =
                                                _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/builder-specVersion-2.5!predicate",
                                              customConfiguration =
                                                _js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.record
                                                        {} {} true
                                                        _js2n__-prdslib.always
                                                    ],
                                              kind =
                                                _js2n__-prdslib.enum
                                                    [ "project", null ],
                                              metadata =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                              resources =
                                                _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/resources!predicate",
                                              server =
                                                _js2n__-refsenv."_js2n__-:then/then/definitions/server!predicate",
                                              specVersion =
                                                _js2n__-prdslib.enum
                                                    [ "2.5", "2.6" ],
                                              type =
                                                _js2n__-prdslib.enum
                                                    [ "module" ],
                                            } {} false _js2n__-prdslib.never)
                                          (_js2n__-prdslib.ifThenElse
                                            (_js2n__-prdslib.records.record
                                              {
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [
                                                        "2.1",
                                                        "2.2",
                                                        "2.3",
                                                        "2.4"
                                                      ],
                                              } {} true _js2n__-prdslib.always)
                                            (_js2n__-prdslib.records.record
                                              {
                                                customConfiguration =
                                                  _js2n__-prdslib.allOf
                                                      [
                                                        _js2n__-prdslib.isType
                                                          'Record,
                                                        _js2n__-prdslib.records.record
                                                          {} {} true
                                                          _js2n__-prdslib.always
                                                      ],
                                                kind =
                                                  _js2n__-prdslib.enum
                                                      [ "project", null ],
                                                metadata =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                resources =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/resources!predicate",
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [
                                                        "2.1",
                                                        "2.2",
                                                        "2.3",
                                                        "2.4"
                                                      ],
                                                type =
                                                  _js2n__-prdslib.enum
                                                      [ "module" ],
                                              } {} false _js2n__-prdslib.never)
                                            (_js2n__-prdslib.records.record
                                              {
                                                kind =
                                                  _js2n__-prdslib.enum
                                                      [ "project", null ],
                                                metadata =
                                                  _js2n__-refsenv."_js2n__-:then/then/definitions/metadata!predicate",
                                                resources =
                                                  _js2n__-refsenv."_js2n__-:then/then/else/else/else/else/then/definitions/resources!predicate",
                                                specVersion =
                                                  _js2n__-prdslib.enum
                                                      [ "2.0" ],
                                                type =
                                                  _js2n__-prdslib.enum
                                                      [ "module" ],
                                              } {} false
                                              _js2n__-prdslib.never)))),
                                    _js2n__-prdslib.records.required
                                      [ "metadata", "specVersion", "type" ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ]) _js2n__-prdslib.always)))),
                      _js2n__-prdslib.records.required
                        [ "specVersion", "type" ],
                      _js2n__-prdslib.records.record
                        {
                          kind = _js2n__-prdslib.enum [ "project", null ],
                          specVersion =
                            _js2n__-prdslib.enum
                                [
                                  "3.2",
                                  "3.1",
                                  "3.0",
                                  "2.6",
                                  "2.5",
                                  "2.4",
                                  "2.3",
                                  "2.2",
                                  "2.1",
                                  "2.0"
                                ],
                          type =
                            _js2n__-prdslib.enum
                                [
                                  "application",
                                  "library",
                                  "theme-library",
                                  "module"
                                ],
                        } {} true _js2n__-prdslib.always
                    ])
                  (_js2n__-prdslib.ifThenElse
                    (_js2n__-prdslib.records.record
                      { kind = _js2n__-prdslib.enum [ "extension" ], } {} true
                      _js2n__-prdslib.always)
                    (_js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.ifThenElse
                          (_js2n__-prdslib.records.record
                            { type = _js2n__-prdslib.const null, } {} true
                            _js2n__-prdslib.always) _js2n__-prdslib.always
                          (_js2n__-prdslib.ifThenElse
                            (_js2n__-prdslib.records.record
                              { type = _js2n__-prdslib.const "task", } {} true
                              _js2n__-prdslib.always)
                            (_js2n__-prdslib.allOf
                              [
                                _js2n__-prdslib.isType 'Record,
                                _js2n__-prdslib.ifThenElse
                                  (_js2n__-prdslib.records.record
                                    {
                                      specVersion =
                                        _js2n__-prdslib.enum
                                            [ "3.0", "3.1", "3.2" ],
                                    } {} true _js2n__-prdslib.always)
                                  (_js2n__-prdslib.records.record
                                    {
                                      customConfiguration =
                                        _js2n__-prdslib.allOf
                                            [
                                              _js2n__-prdslib.isType 'Record,
                                              _js2n__-prdslib.records.record {}
                                                {} true _js2n__-prdslib.always
                                            ],
                                      kind =
                                        _js2n__-prdslib.enum [ "extension" ],
                                      metadata =
                                        _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata-3.0!predicate",
                                      specVersion =
                                        _js2n__-prdslib.enum
                                            [ "3.0", "3.1", "3.2" ],
                                      task =
                                        _js2n__-refsenv."_js2n__-:then/else/then/else/then/definitions/task!predicate",
                                      type = _js2n__-prdslib.enum [ "task" ],
                                    } {} false _js2n__-prdslib.never)
                                  (_js2n__-prdslib.ifThenElse
                                    (_js2n__-prdslib.records.record
                                      {
                                        specVersion =
                                          _js2n__-prdslib.enum
                                              [
                                                "2.1",
                                                "2.2",
                                                "2.3",
                                                "2.4",
                                                "2.5",
                                                "2.6"
                                              ],
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.records.record
                                      {
                                        customConfiguration =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        kind =
                                          _js2n__-prdslib.enum [ "extension" ],
                                        metadata =
                                          _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                                        specVersion =
                                          _js2n__-prdslib.enum
                                              [
                                                "2.1",
                                                "2.2",
                                                "2.3",
                                                "2.4",
                                                "2.5",
                                                "2.6"
                                              ],
                                        task =
                                          _js2n__-refsenv."_js2n__-:then/else/then/else/then/definitions/task!predicate",
                                        type = _js2n__-prdslib.enum [ "task" ],
                                      } {} false _js2n__-prdslib.never)
                                    (_js2n__-prdslib.records.record
                                      {
                                        kind =
                                          _js2n__-prdslib.enum [ "extension" ],
                                        metadata =
                                          _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                                        specVersion =
                                          _js2n__-prdslib.enum [ "2.0" ],
                                        task =
                                          _js2n__-refsenv."_js2n__-:then/else/then/else/then/definitions/task!predicate",
                                        type = _js2n__-prdslib.enum [ "task" ],
                                      } {} false _js2n__-prdslib.never)),
                                _js2n__-prdslib.records.required
                                  [
                                    "kind",
                                    "metadata",
                                    "specVersion",
                                    "task",
                                    "type"
                                  ],
                                _js2n__-prdslib.records.record {} {} true
                                  _js2n__-prdslib.always
                              ])
                            (_js2n__-prdslib.ifThenElse
                              (_js2n__-prdslib.records.record
                                {
                                  type =
                                    _js2n__-prdslib.const "server-middleware",
                                } {} true _js2n__-prdslib.always)
                              (_js2n__-prdslib.allOf
                                [
                                  _js2n__-prdslib.isType 'Record,
                                  _js2n__-prdslib.ifThenElse
                                    (_js2n__-prdslib.records.record
                                      {
                                        specVersion =
                                          _js2n__-prdslib.enum
                                              [ "3.0", "3.1", "3.2" ],
                                      } {} true _js2n__-prdslib.always)
                                    (_js2n__-prdslib.records.record
                                      {
                                        customConfiguration =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  _js2n__-prdslib.always
                                              ],
                                        kind =
                                          _js2n__-prdslib.enum [ "extension" ],
                                        metadata =
                                          _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata-3.0!predicate",
                                        middleware =
                                          _js2n__-refsenv."_js2n__-:then/else/then/else/else/then/definitions/middleware!predicate",
                                        specVersion =
                                          _js2n__-prdslib.enum
                                              [ "3.0", "3.1", "3.2" ],
                                        type =
                                          _js2n__-prdslib.enum
                                              [ "server-middleware" ],
                                      } {} false _js2n__-prdslib.never)
                                    (_js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [
                                                  "2.1",
                                                  "2.2",
                                                  "2.3",
                                                  "2.4",
                                                  "2.5",
                                                  "2.6"
                                                ],
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.records.record
                                        {
                                          customConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "extension" ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                                          middleware =
                                            _js2n__-refsenv."_js2n__-:then/else/then/else/else/then/definitions/middleware!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [
                                                  "2.1",
                                                  "2.2",
                                                  "2.3",
                                                  "2.4",
                                                  "2.5",
                                                  "2.6"
                                                ],
                                          type =
                                            _js2n__-prdslib.enum
                                                [ "server-middleware" ],
                                        } {} false _js2n__-prdslib.never)
                                      (_js2n__-prdslib.records.record
                                        {
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "extension" ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                                          middleware =
                                            _js2n__-refsenv."_js2n__-:then/else/then/else/else/then/definitions/middleware!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum [ "2.0" ],
                                          type =
                                            _js2n__-prdslib.enum
                                                [ "server-middleware" ],
                                        } {} false _js2n__-prdslib.never)),
                                  _js2n__-prdslib.records.required
                                    [
                                      "kind",
                                      "metadata",
                                      "middleware",
                                      "specVersion",
                                      "type"
                                    ],
                                  _js2n__-prdslib.records.record {} {} true
                                    _js2n__-prdslib.always
                                ])
                              (_js2n__-prdslib.ifThenElse
                                (_js2n__-prdslib.records.record
                                  {
                                    type = _js2n__-prdslib.const "project-shim",
                                  } {} true _js2n__-prdslib.always)
                                (_js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.ifThenElse
                                      (_js2n__-prdslib.records.record
                                        {
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [ "3.0", "3.1", "3.2" ],
                                        } {} true _js2n__-prdslib.always)
                                      (_js2n__-prdslib.records.record
                                        {
                                          customConfiguration =
                                            _js2n__-prdslib.allOf
                                                [
                                                  _js2n__-prdslib.isType
                                                    'Record,
                                                  _js2n__-prdslib.records.record
                                                    {} {} true
                                                    _js2n__-prdslib.always
                                                ],
                                          kind =
                                            _js2n__-prdslib.enum
                                                [ "extension" ],
                                          metadata =
                                            _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata-3.0!predicate",
                                          shims =
                                            _js2n__-refsenv."_js2n__-:then/else/then/else/else/else/then/definitions/shims!predicate",
                                          specVersion =
                                            _js2n__-prdslib.enum
                                                [ "3.0", "3.1", "3.2" ],
                                          type =
                                            _js2n__-prdslib.enum
                                                [ "project-shim" ],
                                        } {} false _js2n__-prdslib.never)
                                      (_js2n__-prdslib.ifThenElse
                                        (_js2n__-prdslib.records.record
                                          {
                                            specVersion =
                                              _js2n__-prdslib.enum
                                                  [
                                                    "2.1",
                                                    "2.2",
                                                    "2.3",
                                                    "2.4",
                                                    "2.5",
                                                    "2.6"
                                                  ],
                                          } {} true _js2n__-prdslib.always)
                                        (_js2n__-prdslib.records.record
                                          {
                                            customConfiguration =
                                              _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      'Record,
                                                    _js2n__-prdslib.records.record
                                                      {} {} true
                                                      _js2n__-prdslib.always
                                                  ],
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "extension" ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                                            shims =
                                              _js2n__-refsenv."_js2n__-:then/else/then/else/else/else/then/definitions/shims!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum
                                                  [
                                                    "2.1",
                                                    "2.2",
                                                    "2.3",
                                                    "2.4",
                                                    "2.5",
                                                    "2.6"
                                                  ],
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "project-shim" ],
                                          } {} false _js2n__-prdslib.never)
                                        (_js2n__-prdslib.records.record
                                          {
                                            kind =
                                              _js2n__-prdslib.enum
                                                  [ "extension" ],
                                            metadata =
                                              _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                                            shims =
                                              _js2n__-refsenv."_js2n__-:then/else/then/else/else/else/then/definitions/shims!predicate",
                                            specVersion =
                                              _js2n__-prdslib.enum [ "2.0" ],
                                            type =
                                              _js2n__-prdslib.enum
                                                  [ "project-shim" ],
                                          } {} false _js2n__-prdslib.never)),
                                    _js2n__-prdslib.records.required
                                      [
                                        "kind",
                                        "metadata",
                                        "shims",
                                        "specVersion",
                                        "type"
                                      ],
                                    _js2n__-prdslib.records.record {} {} true
                                      _js2n__-prdslib.always
                                  ]) _js2n__-prdslib.always))),
                        _js2n__-prdslib.records.required
                          [ "kind", "metadata", "specVersion", "type" ],
                        _js2n__-prdslib.records.record
                          {
                            kind = _js2n__-prdslib.enum [ "extension" ],
                            metadata =
                              _js2n__-refsenv."_js2n__-:then/else/then/definitions/metadata!predicate",
                            specVersion =
                              _js2n__-prdslib.enum
                                  [
                                    "3.2",
                                    "3.1",
                                    "3.0",
                                    "2.6",
                                    "2.5",
                                    "2.4",
                                    "2.3",
                                    "2.2",
                                    "2.1",
                                    "2.0"
                                  ],
                            type =
                              _js2n__-prdslib.enum
                                  [
                                    "task",
                                    "server-middleware",
                                    "project-shim"
                                  ],
                          } {} true _js2n__-prdslib.always
                      ]) _js2n__-prdslib.always),
                _js2n__-prdslib.records.required [ "specVersion" ],
                _js2n__-prdslib.records.record
                  {
                    kind =
                      _js2n__-prdslib.enum [ "project", "extension", null ],
                    specVersion =
                      _js2n__-prdslib.enum
                          [
                            "3.2",
                            "3.1",
                            "3.0",
                            "2.6",
                            "2.5",
                            "2.4",
                            "2.3",
                            "2.2",
                            "2.1",
                            "2.0"
                          ],
                  } {} true _js2n__-prdslib.always
              ])
            (_js2n__-prdslib.ifThenElse
              (_js2n__-prdslib.records.record
                { specVersion = _js2n__-prdslib.enum [ "1.1", "1.0", "0.1" ], }
                {} true _js2n__-prdslib.always)
              (_js2n__-prdslib.records.record {} {} true _js2n__-prdslib.always)
              _js2n__-prdslib.always),
          _js2n__-prdslib.records.required [ "specVersion" ],
          _js2n__-prdslib.records.record
            {
              specVersion =
                _js2n__-prdslib.enum
                    [
                      "3.2",
                      "3.1",
                      "3.0",
                      "2.6",
                      "2.5",
                      "2.4",
                      "2.3",
                      "2.2",
                      "2.1",
                      "2.0",
                      "1.1",
                      "1.0",
                      "0.1"
                    ],
            } {} true _js2n__-prdslib.always
        ])