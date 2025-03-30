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
      project
        | {
          corePackage
            | std.enum.TagOrString
            | [| 'SERIOUS, 'LIGHT |]
            | doc "Project core package."
            | optional,
          description
            | String
            | doc "Description of the new project."
            | optional,
          envVariables
            | _js2n__-prdslib.contract_from_predicate
              (_js2n__-prdslib.allOf
                [
                  _js2n__-prdslib.isType 'Record,
                  _js2n__-prdslib.records.record {} {} true
                    (_js2n__-prdslib.isType '"String")
                ])
            | doc "List of environment variables of project configuration."
            | optional,
          name
            | String
            | doc "The name of the new project. Duplicates are allowed.",
          tags
            | Array (String)
            | doc "One or more string tags. Tags do not have functional meaning, they only provide better orientation in projects."
            | optional,
        }
        | doc "Only one project can be defined."
        | optional,
      services
        | Array
          {
            buildFromGit
              | String
              | doc "A URL of a Github or Gitlab repository used for a one-time build of your service."
              | optional,
            enableSubdomainAccess
              | Bool
              | doc "Set true, if you want to enable a public access to your service via a Zerops subdomain. Not suitable for production."
              | optional,
            envSecrets
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Record,
                    _js2n__-prdslib.records.record {} {} true
                      (_js2n__-prdslib.isType '"String")
                  ])
              | doc "List of key-value pairs. Environment variables that are blurred by default in Zerops GUI. Can be edited or deleted in Zerops GUI."
              | optional,
            hostname
              | String
              | doc "The unique service identifier. Limitations: duplicates in the same project forbidden; maximum 25 characters, lowercase ASCII letters (a-z) or numbers (0-9) only.",
            maxContainers
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 6
                  ])
              | doc "Maximum number of containers of the service."
              | optional,
            minContainers
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.allOf
                  [
                    _js2n__-prdslib.isType 'Integer,
                    _js2n__-prdslib.numbers.maximum 6
                  ])
              | doc "Minimum number of containers of the service."
              | optional,
            mode
              | std.enum.TagOrString
              | [| 'NON_HA, 'HA |]
              | doc "Defines the operation mode of the service."
              | optional,
            mount
              | Array (String)
              | doc "Mount shared storages to the service, buildFromGit must be filled."
              | optional,
            nginxConfig | String | doc "Insert full nginx config." | optional,
            objectStoragePolicy
              | std.enum.TagOrString
              | [|
                'public-read-write,
                'public-write,
                'public-objects-read,
                'public-read,
                'private,
                'custom
              |]
              | doc "Select a predefined AWS S3 bucket access policy."
              | optional,
            objectStorageRawPolicy
              | String
              | doc "Define your own AWS S3 bucket access policy. See AWS docs for details. Use {{ .BucketName }} placeholder if you need to use bucket name in your custom policy rules."
              | optional,
            objectStorageSize
              | Number
              | doc "Object storage size in GB."
              | optional,
            "priority"
              | std.number.Integer
              | doc "Services are sorted before creation by priority in descending order, i.e. the higher the priority the sooner the service is created."
              | optional,
            startWithoutCode
              | Bool
              | doc "Set true, if you want to start service without code."
              | optional,
            type
              | std.enum.TagOrString
              | [|
                '"valkey@7.2",
                '"ubuntu@24.04",
                '"ubuntu@22.04",
                '"typesense@27.1",
                '"static@latest",
                '"static@1.0",
                'static,
                'sharedstorage,
                'shared-storage,
                '"seaweedfs@3",
                '"rust@nightly",
                '"rust@1.80",
                '"rust@1.78",
                '"rust@1",
                'runtime,
                '"rabbitmq@3.9",
                '"qdrant@1.12",
                '"qdrant@1.10",
                '"python@3.9",
                '"python@3.12",
                '"python@3.11",
                '"postgresql@16",
                '"postgresql@14",
                '"postgresql@12",
                '"php-nginx@8.4+1.22",
                '"php-nginx@8.4",
                '"php-nginx@8.3+1.22",
                '"php-nginx@8.3",
                '"php-nginx@8.1+1.22",
                '"php-nginx@8.1",
                '"php-apache@8.4+2.4",
                '"php-apache@8.4",
                '"php-apache@8.3+2.4",
                '"php-apache@8.3",
                '"php-apache@8.1+2.4",
                '"php-apache@8.1",
                '"php-apache@8.0+2.4",
                'objectstorage,
                'object-storage,
                '"nodejs@22",
                '"nodejs@20",
                '"nodejs@18",
                '"nginx@latest",
                '"nginx@1.22",
                '"nats@2.10",
                '"meilisearch@1.10",
                '"mariadb@10.6",
                '"keydb@6",
                '"kafka@3.8",
                '"java@latest",
                '"java@21",
                '"java@17",
                'java,
                '"golang@1",
                '"go@1.22",
                '"go@1",
                '"gleam@1.5.1",
                '"gleam@1.5",
                '"gleam@1",
                '"elixir@1.16.2",
                '"elixir@1.16",
                '"elixir@1",
                '"elasticsearch@8.16",
                '"dotnet@9",
                '"dotnet@8",
                '"dotnet@7",
                '"dotnet@6",
                '"docker@latest",
                '"docker@26.1.5",
                '"docker@26.1",
                '"docker@26",
                '"deno@latest",
                '"deno@2.0.0",
                '"deno@2",
                '"deno@1.45.5",
                '"deno@1",
                '"bun@nightly",
                '"bun@latest",
                '"bun@canary",
                '"bun@1.2.2",
                '"bun@1.2",
                '"bun@1.1.34",
                '"bun@1.1",
                '"alpine@3.20",
                '"alpine@3.19",
                '"alpine@3.18",
                '"alpine@3.17",
                '"3.20",
                '"3.19",
                '"3.18",
                '"3.17",
                '"22.04"
              |]
              | doc "Specifies the service type and version.",
            verticalAutoscaling
              | {
                cpu
                  | std.number.Integer
                  | doc "Fixed CPU thread count that each container of the service will be set to."
                  | optional,
                cpuMode
                  | std.enum.TagOrString
                  | [| 'SHARED, 'DEDICATED |]
                  | doc "CPU mode that each container of the service will be set to."
                  | optional,
                disk
                  | Number
                  | doc "Fixed disk space in GB that each container of the service will be set to."
                  | optional,
                maxCpu
                  | std.number.Integer
                  | doc "Maximum CPU thread count that each container of the service can scale up to."
                  | optional,
                maxDisk
                  | Number
                  | doc "Maximum disk space in GB that each container of the service can scale up to."
                  | optional,
                maxRam
                  | Number
                  | doc "Maximum RAM in GB that each container of the service can scale up to."
                  | optional,
                maxVCpu | std.number.Integer | optional,
                minCpu
                  | std.number.Integer
                  | doc "Minimum CPU thread count that each container of the service can scale down to."
                  | optional,
                minDisk
                  | Number
                  | doc "Minimum disk space in GB that each container of the service can scale down to."
                  | optional,
                minFreeCpuCores
                  | Number
                  | doc "Minimum number of unused CPU cores before a container starts scaling."
                  | optional,
                minFreeCpuPercent
                  | Number
                  | doc "Minimum percentage of unused CPU cores before a container starts scaling."
                  | optional,
                minFreeRamGB
                  | Number
                  | doc "Minimum unused memory in GB before a container starts scaling."
                  | optional,
                minFreeRamPercent
                  | Number
                  | doc "Minimum percentage of unused memory before a container starts scaling."
                  | optional,
                minRam
                  | Number
                  | doc "Minimum RAM in GB that each container of the service can scale down to."
                  | optional,
                minVCpu | std.number.Integer | optional,
                ram
                  | Number
                  | doc "Fixed RAM in GB that each container of the service will be set to."
                  | optional,
                startCpuCoreCount
                  | std.number.Integer
                  | doc "Number of CPU cores with which each container starts."
                  | optional,
                swapEnabled
                  | Bool
                  | doc "Whether to enable swap memory for containers. Swap is enabled by default. Refer to documentation for more details."
                  | optional,
              }
              | doc "Vertical autoscaling settings."
              | optional,
            zeropsSetup
              | _js2n__-prdslib.contract_from_predicate
                (_js2n__-prdslib.oneOf
                  [
                    _js2n__-prdslib.allOf
                      [
                        _js2n__-prdslib.isType 'Record,
                        _js2n__-prdslib.records.record
                          {
                            build =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.required
                                      [ "deployFiles" ],
                                    _js2n__-prdslib.records.record
                                      {
                                        addToRunPrepare =
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
                                        base =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"String",
                                                    _js2n__-prdslib.enum
                                                      [
                                                        "22.04",
                                                        "24.04",
                                                        "3.17",
                                                        "3.18",
                                                        "3.19",
                                                        "3.20",
                                                        "alpine@3.17",
                                                        "alpine@3.18",
                                                        "alpine@3.19",
                                                        "alpine@3.20",
                                                        "alpine@latest",
                                                        "bun@1.1",
                                                        "bun@1.1.34",
                                                        "bun@1.2",
                                                        "bun@1.2.2",
                                                        "bun@canary",
                                                        "bun@latest",
                                                        "bun@nightly",
                                                        "deno@1",
                                                        "deno@1.45.5",
                                                        "deno@2.0.0",
                                                        "deno@latest",
                                                        "dotnet@6",
                                                        "dotnet@7",
                                                        "dotnet@8",
                                                        "dotnet@9",
                                                        "dotnet@latest",
                                                        "elixir@1",
                                                        "elixir@1.16",
                                                        "elixir@1.16.2",
                                                        "elixir@latest",
                                                        "gleam@1",
                                                        "gleam@1.5",
                                                        "gleam@1.5.1",
                                                        "gleam@latest",
                                                        "go@1",
                                                        "go@1.22",
                                                        "go@latest",
                                                        "golang@1",
                                                        "golang@latest",
                                                        "java@17",
                                                        "java@21",
                                                        "java@latest",
                                                        "nodejs@18",
                                                        "nodejs@20",
                                                        "nodejs@22",
                                                        "nodejs@latest",
                                                        "php@8.1",
                                                        "php@8.3",
                                                        "php@8.4",
                                                        "php@latest",
                                                        "python@3.11",
                                                        "python@3.12",
                                                        "python@latest",
                                                        "rust@1",
                                                        "rust@1.78",
                                                        "rust@1.80",
                                                        "rust@latest",
                                                        "rust@nightly",
                                                        "ubuntu@22.04",
                                                        "ubuntu@24.04",
                                                        "ubuntu@latest"
                                                      ]
                                                  ],
                                                _js2n__-prdslib.allOf
                                                  [
                                                    _js2n__-prdslib.isType
                                                      '"Array",
                                                    _js2n__-prdslib.arrays.arrayOf
                                                      (_js2n__-prdslib.allOf
                                                        [
                                                          _js2n__-prdslib.isType
                                                            '"String",
                                                          _js2n__-prdslib.enum
                                                            [
                                                              "22.04",
                                                              "24.04",
                                                              "3.17",
                                                              "3.18",
                                                              "3.19",
                                                              "3.20",
                                                              "alpine@3.17",
                                                              "alpine@3.18",
                                                              "alpine@3.19",
                                                              "alpine@3.20",
                                                              "alpine@latest",
                                                              "bun@1.1",
                                                              "bun@1.1.34",
                                                              "bun@1.2",
                                                              "bun@1.2.2",
                                                              "bun@canary",
                                                              "bun@latest",
                                                              "bun@nightly",
                                                              "deno@1",
                                                              "deno@1.45.5",
                                                              "deno@2.0.0",
                                                              "deno@latest",
                                                              "dotnet@6",
                                                              "dotnet@7",
                                                              "dotnet@8",
                                                              "dotnet@9",
                                                              "dotnet@latest",
                                                              "elixir@1",
                                                              "elixir@1.16",
                                                              "elixir@1.16.2",
                                                              "elixir@latest",
                                                              "gleam@1",
                                                              "gleam@1.5",
                                                              "gleam@1.5.1",
                                                              "gleam@latest",
                                                              "go@1",
                                                              "go@1.22",
                                                              "go@latest",
                                                              "golang@1",
                                                              "golang@latest",
                                                              "java@17",
                                                              "java@21",
                                                              "java@latest",
                                                              "nodejs@18",
                                                              "nodejs@20",
                                                              "nodejs@22",
                                                              "nodejs@latest",
                                                              "php@8.1",
                                                              "php@8.3",
                                                              "php@8.4",
                                                              "php@latest",
                                                              "python@3.11",
                                                              "python@3.12",
                                                              "python@latest",
                                                              "rust@1",
                                                              "rust@1.78",
                                                              "rust@1.80",
                                                              "rust@latest",
                                                              "rust@nightly",
                                                              "ubuntu@22.04",
                                                              "ubuntu@24.04",
                                                              "ubuntu@latest"
                                                            ]
                                                        ])
                                                  ]
                                              ],
                                        buildCommands =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        cache =
                                          _js2n__-prdslib.oneOf
                                              [
                                                _js2n__-prdslib.isType '"Bool",
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
                                        deploy =
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
                                        deployFiles =
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
                                        envVariables =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  (_js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.isType
                                                        '"Number",
                                                      _js2n__-prdslib.isType
                                                        '"Bool"
                                                    ])
                                              ],
                                        os =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "", "alpine", "ubuntu" ]
                                              ],
                                        prepareCommands =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                            deploy =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        readinessCheck =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    exec =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [ "command" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                command =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                    failureTimeout =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                    httpGet =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [
                                                                "path",
                                                                "port"
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                host =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                path =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                port =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                scheme =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                    retryPeriod =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        temporaryShutdown =
                                          _js2n__-prdslib.isType '"Bool",
                                      } {} false _js2n__-prdslib.never
                                  ],
                            extends =
                              _js2n__-prdslib.oneOf
                                  [
                                    _js2n__-prdslib.isType '"String",
                                    _js2n__-prdslib.allOf
                                      [
                                        _js2n__-prdslib.isType '"Array",
                                        _js2n__-prdslib.arrays.arrayOf
                                          (_js2n__-prdslib.isType '"String")
                                      ]
                                  ],
                            run =
                              _js2n__-prdslib.allOf
                                  [
                                    _js2n__-prdslib.isType 'Record,
                                    _js2n__-prdslib.records.record
                                      {
                                        base =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [
                                                    "22.04",
                                                    "24.04",
                                                    "3.17",
                                                    "3.18",
                                                    "3.19",
                                                    "3.20",
                                                    "alpine@3.17",
                                                    "alpine@3.18",
                                                    "alpine@3.19",
                                                    "alpine@3.20",
                                                    "alpine@latest",
                                                    "bun@1.1",
                                                    "bun@1.1.34",
                                                    "bun@1.2",
                                                    "bun@1.2.2",
                                                    "bun@canary",
                                                    "bun@latest",
                                                    "bun@nightly",
                                                    "deno@1",
                                                    "deno@1.45.5",
                                                    "deno@2.0.0",
                                                    "deno@latest",
                                                    "docker@26",
                                                    "docker@26.1",
                                                    "docker@26.1.5",
                                                    "docker@latest",
                                                    "dotnet@6",
                                                    "dotnet@7",
                                                    "dotnet@8",
                                                    "dotnet@9",
                                                    "dotnet@latest",
                                                    "elixir@1",
                                                    "elixir@1.16",
                                                    "elixir@1.16.2",
                                                    "elixir@latest",
                                                    "gleam@1",
                                                    "gleam@1.5",
                                                    "gleam@1.5.1",
                                                    "gleam@latest",
                                                    "go@1",
                                                    "go@1.22",
                                                    "go@latest",
                                                    "golang@1",
                                                    "golang@latest",
                                                    "java@17",
                                                    "java@21",
                                                    "java@latest",
                                                    "nginx@1.22",
                                                    "nginx@latest",
                                                    "nodejs@18",
                                                    "nodejs@20",
                                                    "nodejs@22",
                                                    "nodejs@latest",
                                                    "php-apache@8.1",
                                                    "php-apache@8.3",
                                                    "php-apache@8.4",
                                                    "php-apache@latest",
                                                    "php-nginx@8.1",
                                                    "php-nginx@8.3",
                                                    "php-nginx@8.4",
                                                    "php-nginx@latest",
                                                    "python@3.11",
                                                    "python@3.12",
                                                    "python@latest",
                                                    "runtime@latest",
                                                    "rust@1",
                                                    "rust@1.78",
                                                    "rust@1.80",
                                                    "rust@latest",
                                                    "rust@nightly",
                                                    "static",
                                                    "static@1.0",
                                                    "static@latest",
                                                    "ubuntu@22.04",
                                                    "ubuntu@24.04",
                                                    "ubuntu@latest"
                                                  ]
                                              ],
                                        crontab =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [
                                                          "allContainers",
                                                          "command",
                                                          "timing"
                                                        ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          allContainers =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          command =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          timing =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          workingDir =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        documentRoot =
                                          _js2n__-prdslib.isType '"String",
                                        envReplace =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.required
                                                  [ "delimiter", "target" ],
                                                _js2n__-prdslib.records.record
                                                  {
                                                    delimiter =
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
                                                    target =
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
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        envVariables =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {} {} true
                                                  (_js2n__-prdslib.oneOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        '"String",
                                                      _js2n__-prdslib.isType
                                                        '"Number",
                                                      _js2n__-prdslib.isType
                                                        '"Bool"
                                                    ])
                                              ],
                                        healthCheck =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    disconnectTimeout =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                    exec =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [ "command" ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                command =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                    execPeriod =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                    failureTimeout =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                    httpGet =
                                                      _js2n__-prdslib.allOf
                                                          [
                                                            _js2n__-prdslib.isType
                                                              'Record,
                                                            _js2n__-prdslib.records.required
                                                              [
                                                                "path",
                                                                "port"
                                                              ],
                                                            _js2n__-prdslib.records.record
                                                              {
                                                                host =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                path =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                                port =
                                                                  _js2n__-prdslib.isType
                                                                      'Integer,
                                                                scheme =
                                                                  _js2n__-prdslib.isType
                                                                      '"String",
                                                              } {} false
                                                              _js2n__-prdslib.never
                                                          ],
                                                    recoveryTimeout =
                                                      _js2n__-prdslib.isType
                                                          'Integer,
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        initCommands =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        os =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType
                                                  '"String",
                                                _js2n__-prdslib.enum
                                                  [ "", "alpine", "ubuntu" ]
                                              ],
                                        ports =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "port" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          description =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          httpSupport =
                                                            _js2n__-prdslib.isType
                                                                '"Bool",
                                                          port =
                                                            _js2n__-prdslib.isType
                                                                'Integer,
                                                          protocol =
                                                            _js2n__-prdslib.allOf
                                                                [
                                                                  _js2n__-prdslib.isType
                                                                    '"String",
                                                                  _js2n__-prdslib.enum
                                                                    [
                                                                      "tcp",
                                                                      "udp"
                                                                    ]
                                                                ],
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                        prepareCommands =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.isType
                                                    '"String")
                                              ],
                                        routing =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType 'Record,
                                                _js2n__-prdslib.records.record
                                                  {
                                                    redirects =
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
                                                                      "from",
                                                                      "to"
                                                                    ],
                                                                  _js2n__-prdslib.records.record
                                                                    {
                                                                      from =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                      preservePath =
                                                                        _js2n__-prdslib.isType
                                                                            '"Bool",
                                                                      preserveQuery =
                                                                        _js2n__-prdslib.isType
                                                                            '"Bool",
                                                                      status =
                                                                        _js2n__-prdslib.isType
                                                                            'Integer,
                                                                      to =
                                                                        _js2n__-prdslib.isType
                                                                            '"String",
                                                                    } {} false
                                                                    _js2n__-prdslib.never
                                                                ])
                                                          ],
                                                    root =
                                                      _js2n__-prdslib.isType
                                                          '"String",
                                                  } {} false
                                                  _js2n__-prdslib.never
                                              ],
                                        siteConfigPath =
                                          _js2n__-prdslib.isType '"String",
                                        start =
                                          _js2n__-prdslib.isType '"String",
                                        startCommands =
                                          _js2n__-prdslib.allOf
                                              [
                                                _js2n__-prdslib.isType '"Array",
                                                _js2n__-prdslib.arrays.arrayOf
                                                  (_js2n__-prdslib.allOf
                                                    [
                                                      _js2n__-prdslib.isType
                                                        'Record,
                                                      _js2n__-prdslib.records.required
                                                        [ "command" ],
                                                      _js2n__-prdslib.records.record
                                                        {
                                                          command =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                          initCommands =
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
                                                          workingDir =
                                                            _js2n__-prdslib.isType
                                                                '"String",
                                                        } {} false
                                                        _js2n__-prdslib.never
                                                    ])
                                              ],
                                      } {} false _js2n__-prdslib.never
                                  ],
                          } {} false _js2n__-prdslib.never
                      ],
                    _js2n__-prdslib.isType '"String"
                  ])
              | optional,
          }
        | optional,
    }