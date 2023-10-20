# DO NOT EDIT
# This file was automatically generated using json-schema-to-nickel
let predicates =
{
    allOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `allOf preds` succeeds if all of the predicates in `preds` succeed
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.1]
      "%
      = fun preds x => std.array.fold_right
          (fun pred acc => let result = pred x in
            if !result.success then result else acc)
          { error = "", success = true, }
          preds,
    always : Dyn -> { success: Bool, error: String }
      = std.function.const { error = "", success = true, },
    anyOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `anyOf preds` succeeds if at least one of the predicates in `preds` succeeds
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.2]
      "%
      = fun preds x => (fun result => if result.success then
            { error = "", success = true, }
            else
            {
              error = m%"
                  anyOf: none of the options matched%{std.string.join "\n"
                  result.errors}
                  "%,
              success = false,
            })
          (std.array.fold_right
          (fun pred acc => let result = pred x in
            if result.success || acc.success then
            { errors = [  ], success = true, }
            else
            {
              errors = [
                      m%"
                      - %{result.error}
                      "%
                    ] @
                    acc.errors,
              success = false,
            })
          { errors = [  ], success = false, }
          preds),
    arrays = {
          additionalItems
            : (Dyn -> { success: Bool, error: String }) -> Number -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.2]
            "%
            = fun pred start x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                let value_length = std.array.length x in
                if start >= value_length then
                { error = "", success = true, }
                else
                (arrayOf pred ((std.array.slice start value_length x) | Dyn))),
          arrayOf
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Apply a predicate to all elements of an array, succeeding if all
            applications succeed. If the value isn't an array, fail.
            "%
            = fun pred x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                std.array.fold_right
                (fun x acc => let result = pred x in
                  if !result.success then result else acc)
                { error = "", success = true, }
                x),
          contains
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.6]
            "%
            = fun pred x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                (fun result => if result.success then
                  { error = "", success = true, }
                  else
                  {
                    error = m%"
                        contains: no elements matched%{std.string.join "\n"
                        result.errors}
                        "%,
                    success = false,
                  })
                (std.array.fold_right
                (fun x acc => let result = pred x in
                  if result.success || acc.success then
                  { errors = [  ], success = true, }
                  else
                  {
                    errors = [
                            m%"
                            - %{result.error}
                            "%
                          ] @
                          acc.errors,
                    success = false,
                  })
                { errors = [  ], success = false, }
                x)),
          items
            : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.1]
            "%
            = fun preds x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let x  | Array Dyn = x in
                let length_to_check =
                std.number.min (std.array.length preds) (std.array.length x)
                in
                
                std.array.fold_right
                (fun i acc => let result =
                  std.array.at i preds (std.array.at i x)
                  in
                  
                  if !result.success then result else acc)
                { error = "", success = true, }
                (std.array.range 0 length_to_check)),
          maxItems
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `maxItems n x` fails if `x` is an array of length strictly greater than `n` and succeeds otherwise.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.3]
            "%
            = fun n x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (if (std.array.length (x | Array Dyn)) > n then
                {
                    error = m%"
                        array is longer than %{std.string.from_number n} items
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          minItems
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `minItems n x` fails if `x` is an array of length strictly smaller than `n` and succeeds otherwise.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.4]
            "%
            = fun n x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (if (std.array.length (x | Array Dyn)) < n then
                {
                    error = m%"
                        array is shorter than %{std.string.from_number n} items
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          uniqueItems
            : Dyn -> { success: Bool, error: String }
            | doc m%"
            Succeeds for any array if its elements are pairwise distinct.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.4.5]
            "%
            = let find_duplicate 
                : Array Dyn -> {
                  has_duplicate: Bool,
                  duplicate: Dyn,
                  seen: { _ : Bool }
                } =
              std.array.fold_right
                (fun elt acc => if acc.has_duplicate then acc else
                  (let index = std.serialize 'Json elt in
                  if std.record.has_field index acc.seen then
                  { duplicate = elt, has_duplicate = true, seen = acc.seen, }
                  else
                  {
                    duplicate = null,
                    has_duplicate = false,
                    seen = std.record.insert index true acc.seen,
                  }))
                { duplicate = null, has_duplicate = false, seen = {  }, }
              in
              
              fun x => if !(std.is_array x) then
                { error = "", success = true, }
                else
                (let {has_duplicate  | Dyn, duplicate  | Dyn, ..} =
                find_duplicate (x | Array Dyn)
                in
                
                if has_duplicate then
                {
                    error = m%"
                        duplicate found: %{std.serialize 'Json duplicate}
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
        },
    const
      : Dyn -> Dyn -> { success: Bool, error: String }
      | doc m%"
      `const value x` succeeds if and only if `x` is equalt to `value`
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.3]
      "%
      = fun value x => if x == value then { error = "", success = true, } else
          {
            error = m%"
                expected %{std.serialize 'Json value}
                "%,
            success = false,
          },
    contract_from_predicate
      : (Dyn -> { success: Bool, error: String }) -> Dyn -> Dyn -> Dyn
      = fun predicate label value => let {success  | Dyn, error  | Dyn} =
          predicate value
          in
          
          if success then value else
          ((std.contract.blame_with_message error label) | Dyn),
    enum
      : Array Dyn -> Dyn -> { success: Bool, error: String }
      | doc m%"
      `enum values x` succeeds if and only if `x` is equal to one of the elements of `values`.
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.1.2]
      "%
      = let checkEqual =
        fun input variant => (input == variant) ||
            ((std.is_enum input) &&
            (((std.string.from_enum input) == variant) | Bool))
        in
        
        fun values x => std.array.fold_right
          (fun value acc => if checkEqual x value then
            { error = "", success = true, }
            else
            acc)
          {
            error = m%"
                expected one of %{std.serialize 'Json (values | Dyn)}
                "%,
            success = false,
          }
          values,
    from_simple_predicate
      : String -> (Dyn -> Bool) -> Dyn -> { success: Bool, error: String }
      | doc m%"
      Convert a simple boolean predicate into a predicate supporting error messages
      "%
      = fun error' pred x => { error = error', success = pred x, },
    ifThenElse
      : (Dyn -> { success: Bool, error: String }) -> (Dyn -> {
        success: Bool,
        error: String
      }) -> (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `ifThenElse i t e` first checks if the predicate `i` succeeds. If it does, it's equivalent to `t`, otherwise it's equivalent to `e`.
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.6]
      "%
      = fun i t e x => let {success  | Dyn, ..} = i x in
          if success then t x else (e x),
    isType
      : [| '"Array", '"Bool", 'Integer, 'Null, '"Number", 'Record, '"String" |]
      -> Dyn -> { success: Bool, error: String }
      = fun t => (match {'Integer => from_simple_predicate "expected an integer"
            (fun x => (std.is_number x) &&
              (std.number.is_integer (x | Number))),
            'Null => from_simple_predicate "expected `null`"
            (fun x => x == null),
            _ => from_simple_predicate
            m%"
            value is not of type %{std.string.from_enum t}
            "%
            (fun x => (std.typeof x) == t)
          })
          t,
    never : Dyn -> { success: Bool, error: String }
      = std.function.const { error = "never", success = false, },
    not
      : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `not pred` succeeds if and only if `pred` fails
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.4]
      "%
      = fun pred x => let result = pred x in
          if result.success then
          {
              error = "Inverted predicate succeeded unexpectedly",
              success = false,
            }
          else
          { error = "", success = true, },
    numbers = {
          exclusiveMaximum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.3]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) < limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected an exclusive maximum of %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          exclusiveMinimum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.5]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) > limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected an exclusive minimum of %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          maximum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.2]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) <= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a maximum of %{std.string.from_number limit}
                      "%,
                  success = false,
                }),
          minimum
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.4]
            "%
            = fun limit x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if (x | Number) >= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a minimum of %{std.string.from_number limit}
                      "%,
                  success = false,
                }),
          multipleOf
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.2.1]
            "%
            = fun mult x => if !(std.is_number x) then
                { error = "", success = true, }
                else
                (if std.number.is_integer ((x | Number) / mult) then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a multiple of %{std.string.from_number mult}
                      "%,
                  success = false,
                }),
        },
    oneOf
      : Array (Dyn -> { success: Bool, error: String }) -> Dyn -> {
        success: Bool,
        error: String
      }
      | doc m%"
      `oneOf preds` succeeds if precisely one of the predicates in `preds` succeeds
      Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.7.3]
      "%
      = fun preds x => let count_true 
            : Array { success: Bool, error: String } -> Number =
          fun results => std.array.fold_left
              (fun n b => if b.success then n + 1 else n)
              0
              results
          in
          
          let results = std.array.map (fun pred => pred x) preds in
          let count = count_true results in
          if count == 0 then
          let errors =
            std.array.map
              (fun result => m%"
                - %{result.error}
                "%)
              results
            in
            
            {
              error = m%"
                  oneOf: none of the options matched%{std.string.join "\n"
                  errors}
                  "%,
              success = false,
            }
          else
          (if count > 1 then
          {
              error = "oneOf: more than one of the options matched",
              success = false,
            }
          else
          { error = "", success = true, }),
    records = {
          dependencies
            : { _ : Dyn } -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.7]
            "%
            = let mustHaveFields 
                : Array String -> { _ : Dyn } -> {
                  success: Bool,
                  error: String
                } =
              fun fields x => std.array.fold_right
                  (fun field acc => if !(std.record.has_field field x) then
                    {
                        error = m%"
                            expected field `%{field}`
                            "%,
                        success = false,
                      }
                    else
                    acc)
                  { error = "", success = true, }
                  fields
              in
              
              fun deps x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (let x  | { _ : Dyn } = x in
                std.array.fold_right
                (fun {field  | Dyn, value  | Dyn} => fun acc =>
                  if !(std.record.has_field field x) then acc else
                    (let result =
                    if std.is_array value then
                      mustHaveFields (value | Array String) x
                      else
                      (let pred  | Dyn -> { success: Bool, error: String } =
                      value
                      in
                      
                      pred (x | Dyn))
                    in
                    
                    if !result.success then
                    {
                        error = m%"
                            dependency of `%{field}` failed: %{result.error}
                            "%,
                        success = false,
                      }
                    else
                    acc))
                { error = "", success = true, }
                (std.record.to_array deps)),
          maxProperties
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `maxProperties n x` fails if `x` is a record containing stricly more than `n` fields.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun n x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (if (std.record.length (x | { _ : Dyn })) > n then
                {
                    error = m%"
                        record contains more than %{std.string.from_number
                        n} fields
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          minProperties
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            `minProperties n x` fails if `x` is a record containing stricly less than `n` fields.
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.1]
            "%
            = fun n x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (if (std.record.length (x | { _ : Dyn })) < n then
                {
                    error = m%"
                        record contains fewer than %{std.string.from_number
                        n} fields
                        "%,
                    success = false,
                  }
                else
                { error = "", success = true, }),
          propertyNames
            : (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.8]
            "%
            = fun pred x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (std.array.fold_right
                (fun field acc => let result = pred (field | Dyn) in
                  if !result.success then
                  {
                      error = m%"
                          field `%{field}` did not validate against `propertyNames` schema
                          "%,
                      success = false,
                    }
                  else
                  acc)
                { error = "", success = true, }
                (std.record.fields (x | { _ : Dyn }))),
          record
            : { _ : Dyn -> { success: Bool, error: String } } -> { _ : Dyn -> {
              success: Bool,
              error: String
            } } -> Bool -> (Dyn -> { success: Bool, error: String }) -> Dyn -> {
              success: Bool,
              error: String
            }
            | doc m%"
            `record properties patternProperties additionalAllowed
            additionalProperties x` is a combination of the `properties`,
            `patternProperties` and `additionalProperties` validation keywords in
            JSON schema.
            
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5]
            "%
            =
            fun properties patternProperties additionalAllowed additionalProperties x =>
              if !(std.is_record x) then { error = "", success = true, } else
                (let x  | { _ : Dyn } = x in
                let check_properties 
                  : { success: Bool, error: String, checked: { _ : Bool } } =
                std.array.fold_right
                  (fun {field  | Dyn, value  | Dyn} => fun acc =>
                    if !(std.record.has_field field x) then acc else
                      (let result = value x."%{field}" in
                      if !result.success then
                      {
                          checked : { _ : Bool }
                            = {  },
                          error = m%"
                              field `%{field}` didn't validate: %{result.error}
                              "%,
                          success = false,
                        }
                      else
                      {
                        checked = std.record.insert field true acc.checked,
                        error = acc.error,
                        success = acc.success,
                      }))
                  { checked = {  }, error = "", success = true, }
                  (std.record.to_array properties)
                in
                
                let matching_fields  : String -> { _ : Dyn } =
                fun pattern => let matcher = std.string.is_match pattern in
                    std.array.fold_left
                    (fun acc => fun {field  | Dyn, value  | Dyn} => if matcher
                        field then
                        std.record.insert field value acc
                        else
                        acc)
                    {  }
                    (std.record.to_array x)
                in
                
                let check_pattern_properties 
                  : { success: Bool, error: String, checked: { _ : Bool } } =
                std.array.fold_right
                  (fun {field  | Dyn = pattern, value  | Dyn = pred} =>
                  fun acc => let result =
                      std.array.fold_right
                        (fun {field  | Dyn, value  | Dyn} => fun acc =>
                          let result = pred value in
                            if !result.success then
                            {
                                checked : { _ : Bool }
                                  = {  },
                                error = m%"
                                    field `%{field}` didn't validate: %{result.error}
                                    "%,
                                success = false,
                              }
                            else
                            {
                              checked = std.record.insert field true
                                  acc.checked,
                              error = acc.error,
                              success = acc.success,
                            })
                        {
                          checked : { _ : Bool }
                            = {  },
                          error = "",
                          success = true,
                        }
                        (std.record.to_array (matching_fields pattern))
                      in
                      
                      if !result.success then result else
                      {
                        checked = std.array.fold_left
                            (fun r field => if !(std.record.has_field field
                              r) then
                              std.record.insert field true r
                              else
                              r)
                            acc.checked
                            (std.record.fields result.checked),
                        error = acc.error,
                        success = acc.success,
                      })
                  { checked : { _ : Bool } = {  }, error = "", success = true, }
                  (std.record.to_array patternProperties)
                in
                
                let remaining_fields =
                std.array.fold_left
                  (fun acc field => if !(std.record.has_field field acc) then
                    acc
                    else
                    (std.record.remove field acc))
                  x
                  ((std.record.fields check_properties.checked) @
                    (std.record.fields check_pattern_properties.checked))
                in
                
                let check_additional_properties 
                  : { success: Bool, error: String } =
                if (!additionalAllowed) &&
                  (!(std.record.is_empty remaining_fields)) then
                  {
                      error = m%"
                          extra fields %{std.serialize 'Json
                          ((std.record.fields remaining_fields) | Dyn)}
                          "%,
                      success = false,
                    }
                  else
                  (std.array.fold_right
                  (fun {field  | Dyn, value  | Dyn} => fun acc => let result =
                      additionalProperties value
                      in
                      
                      if !result.success then
                      {
                          error = m%"
                              field `%{field}` didn't validate: %{result.error}
                              "%,
                          success = false,
                        }
                      else
                      acc)
                  { error = "", success = true, }
                  (std.record.to_array remaining_fields))
                in
                
                if !check_properties.success then
                { error = check_properties.error, success = false, }
                else
                (if !check_pattern_properties.success then
                { error = check_pattern_properties.error, success = false, }
                else
                check_additional_properties)),
          required
            : Array String -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.5.3]
            "%
            = fun fields x => if !(std.is_record x) then
                { error = "", success = true, }
                else
                (std.array.fold_right
                (fun field acc => if !(std.record.has_field field
                  (x | { _ : Dyn })) then
                  {
                      error = m%"
                          missing required field %{field}
                          "%,
                      success = false,
                    }
                  else
                  acc)
                { error = "", success = true, }
                fields),
        },
    strings = {
          maxLength
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.1]
            "%
            = fun limit x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if (std.string.length (x | String)) <= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string of length no larger than %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          minLength
            : Number -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.2]
            "%
            = fun limit x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if (std.string.length (x | String)) >= limit then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string of length no smaller than %{std.string.from_number
                      limit}
                      "%,
                  success = false,
                }),
          pattern
            : String -> Dyn -> { success: Bool, error: String }
            | doc m%"
            Cf. [https://datatracker.ietf.org/doc/html/draft-handrews-json-schema-validation-01#section-6.3.3]
            "%
            = fun pattern x => if !(std.is_string x) then
                { error = "", success = true, }
                else
                (if std.string.is_match pattern (x | String) then
                { error = "", success = true, }
                else
                {
                  error = m%"
                      expected a string matching the pattern `%{pattern}`
                      "%,
                  success = false,
                }),
        },
  }
in

let rec definitions =
{
    contract = {
          CacheFormat = std.contract.Sequence
              [ std.enum.TagOrString, [| 'universal, 'legacy |] ],
          CacheSettings = {
                cacheFormat
                  | predicates.contract_from_predicate
                  definitions.predicate.CacheFormat
                  | doc m%"
                  Format of the cache file.
                  - `legacy` - use absolute paths in the cache file
                  - `universal` - use a sharable format.
                  "%
                  | optional,
                cacheLocation
                  | predicates.contract_from_predicate
                  definitions.predicate.FSPathResolvable
                  | doc m%"
                  Path to the cache location. Can be a file or a directory. If none specified `.cspellcache` will be used. Relative paths are relative to the config file in which it is defined.
                  
                  A prefix of `${cwd}` is replaced with the current working directory.
                  "%
                  | optional,
                cacheStrategy
                  | predicates.contract_from_predicate
                  definitions.predicate.CacheStrategy
                  | doc m%"
                  Strategy to use for detecting changed files, default: metadata
                  "%
                  | optional,
                useCache
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Store the results of processed files in order to only operate on the changed ones.
                  "%
                  | optional,
              },
          CacheStrategy
            | doc m%"
            The Strategy to use to detect if a file has changed.
            - `metadata` - uses the file system timestamp and size to detect changes (fastest).
            - `content` - uses a hash of the file content to check file changes (slower - more accurate).
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'content, 'metadata |] ],
          CharacterSet
            | doc m%"
            This is a set of characters that can include `-` or `|`
            - `-` - indicates a range of characters: `a-c` => `abc`
            - `|` - is a group separator, indicating that the characters on either side    are not related.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CharacterSet,
          CharacterSetCosts = {
                characters
                  | predicates.contract_from_predicate
                  definitions.predicate.CharacterSet
                  | doc m%"
                  This is a set of characters that can include `-` or `|`
                  - `-` - indicates a range of characters: `a-c` => `abc`
                  - `|` - is a group separator, indicating that the characters on either side    are not related.
                  "%,
                cost
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  the cost to insert / delete / replace / swap the characters in a group
                  "%,
                penalty
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The penalty cost to apply if the accent is used. This is used to discourage
                  "%
                  | optional,
              },
          CostMapDefInsDel = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  A description to describe the purpose of the map.
                  "%
                  | optional,
                insDel
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to insert/delete one of the substrings in the map. Note: insert/delete costs are symmetrical.
                  "%,
                map
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The set of substrings to map, these are generally single character strings.
                  
                  Multiple sets can be defined by using a `|` to separate them.
                  
                  Example: `"eéê|aåá"` contains two different sets.
                  
                  To add a multi-character substring use `()`.
                  
                  Example: `"f(ph)(gh)"` results in the following set: `f`, `ph`, `gh`.
                  
                  - To match the beginning of a word, use `^`: `"(^I)""`.
                  - To match the end of a word, use `$`: `"(e$)(ing$)"`.
                  "%,
                penalty
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  Add a penalty to the final cost. This is used to discourage certain suggestions.
                  
                  Example: ```yaml # Match adding/removing `-` to the end of a word. map: "$(-$)" replace: 50 penalty: 100 ```
                  
                  This makes adding a `-` to the end of a word more expensive.
                  
                  Think of it as taking the toll way for speed but getting the bill later.
                  "%
                  | optional,
                replace
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to replace of of the substrings in the map with another substring in the map. Example: Map['a', 'i'] This would be the cost to substitute `a` with `i`: Like `bat` to `bit` or the reverse.
                  "%
                  | optional,
                swap
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to swap two adjacent substrings found in the map. Example: Map['e', 'i'] This represents the cost to change `ei` to `ie` or the reverse.
                  "%
                  | optional,
              },
          CostMapDefReplace = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  A description to describe the purpose of the map.
                  "%
                  | optional,
                insDel
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to insert/delete one of the substrings in the map. Note: insert/delete costs are symmetrical.
                  "%
                  | optional,
                map
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The set of substrings to map, these are generally single character strings.
                  
                  Multiple sets can be defined by using a `|` to separate them.
                  
                  Example: `"eéê|aåá"` contains two different sets.
                  
                  To add a multi-character substring use `()`.
                  
                  Example: `"f(ph)(gh)"` results in the following set: `f`, `ph`, `gh`.
                  
                  - To match the beginning of a word, use `^`: `"(^I)""`.
                  - To match the end of a word, use `$`: `"(e$)(ing$)"`.
                  "%,
                penalty
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  Add a penalty to the final cost. This is used to discourage certain suggestions.
                  
                  Example: ```yaml # Match adding/removing `-` to the end of a word. map: "$(-$)" replace: 50 penalty: 100 ```
                  
                  This makes adding a `-` to the end of a word more expensive.
                  
                  Think of it as taking the toll way for speed but getting the bill later.
                  "%
                  | optional,
                replace
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to replace of of the substrings in the map with another substring in the map. Example: Map['a', 'i'] This would be the cost to substitute `a` with `i`: Like `bat` to `bit` or the reverse.
                  "%,
                swap
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to swap two adjacent substrings found in the map. Example: Map['e', 'i'] This represents the cost to change `ei` to `ie` or the reverse.
                  "%
                  | optional,
              },
          CostMapDefSwap = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  A description to describe the purpose of the map.
                  "%
                  | optional,
                insDel
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to insert/delete one of the substrings in the map. Note: insert/delete costs are symmetrical.
                  "%
                  | optional,
                map
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  The set of substrings to map, these are generally single character strings.
                  
                  Multiple sets can be defined by using a `|` to separate them.
                  
                  Example: `"eéê|aåá"` contains two different sets.
                  
                  To add a multi-character substring use `()`.
                  
                  Example: `"f(ph)(gh)"` results in the following set: `f`, `ph`, `gh`.
                  
                  - To match the beginning of a word, use `^`: `"(^I)""`.
                  - To match the end of a word, use `$`: `"(e$)(ing$)"`.
                  "%,
                penalty
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  Add a penalty to the final cost. This is used to discourage certain suggestions.
                  
                  Example: ```yaml # Match adding/removing `-` to the end of a word. map: "$(-$)" replace: 50 penalty: 100 ```
                  
                  This makes adding a `-` to the end of a word more expensive.
                  
                  Think of it as taking the toll way for speed but getting the bill later.
                  "%
                  | optional,
                replace
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to replace of of the substrings in the map with another substring in the map. Example: Map['a', 'i'] This would be the cost to substitute `a` with `i`: Like `bat` to `bit` or the reverse.
                  "%
                  | optional,
                swap
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to swap two adjacent substrings found in the map. Example: Map['e', 'i'] This represents the cost to change `ei` to `ie` or the reverse.
                  "%,
              },
          CustomDictionaryPath
            | doc m%"
            A File System Path to a dictionary file.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CustomDictionaryPath,
          CustomDictionaryScope
            | doc m%"
            Specifies the scope of a dictionary.
            "%
            = std.contract.Sequence
              [ std.enum.TagOrString, [| 'folder, 'workspace, 'user |] ],
          DictionaryDefinition = predicates.contract_from_predicate
              definitions.predicate.DictionaryDefinition,
          DictionaryDefinitionAlternate
            | doc m%"
            Only for legacy dictionary definitions.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryDefinitionAlternate,
          DictionaryDefinitionAugmented
            | doc m%"
            Used to provide extra data related to the dictionary
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryDefinitionAugmented,
          DictionaryDefinitionCustom
            | doc m%"
            For Defining Custom dictionaries. They are generally scoped to a `user`, `workspace`, or `folder`. When `addWords` is true, indicates that the spell checker can add words to the file.
            
            Note: only plain text files with one word per line are supported at this moment.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryDefinitionCustom,
          DictionaryDefinitionInline
            | doc m%"
            Inline Dictionary Definitions
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryDefinitionInline,
          DictionaryDefinitionInlineFlagWords = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional description.
                  "%
                  | optional,
                flagWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to always be considered incorrect. Words found in `flagWords` override `words`.
                  
                  Format of `flagWords`
                  - single word entry - `word`
                  - with suggestions - `word:suggestion` or `word->suggestion, suggestions`
                  
                  Example: ```ts "flagWords": [   "color: colour",   "incase: in case, encase",   "canot->cannot",   "cancelled->canceled" ] ```
                  "%,
                ignoreWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be ignored. An ignored word will not show up as an error, even if it is also in the `flagWords`.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryId
                  | doc m%"
                  This is the name of a dictionary.
                  
                  Name Format:
                  - Must contain at least 1 number or letter.
                  - Spaces are allowed.
                  - Leading and trailing space will be removed.
                  - Names ARE case-sensitive.
                  - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
                  "%,
                noSuggest
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Indicate that suggestions should not come from this dictionary. Words in this dictionary are considered correct, but will not be used when making spell correction suggestions.
                  
                  Note: if a word is suggested by another dictionary, but found in this dictionary, it will be removed from the set of possible suggestions.
                  "%
                  | optional,
                repMap
                  | predicates.contract_from_predicate
                  definitions.predicate.ReplaceMap
                  | doc m%"
                  Replacement pairs.
                  "%
                  | optional,
                suggestWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of suggested replacements for words. Suggested words provide a way to make preferred suggestions on word replacements. To hint at a preferred change, but not to require it.
                  
                  Format of `suggestWords`
                  - Single suggestion (possible auto fix)     - `word: suggestion`     - `word->suggestion`
                  - Multiple suggestions (not auto fixable)    - `word: first, second, third`    - `word->first, second, third`
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryFileTypes
                  | doc m%"
                  Type of file:
                  - S - single word per line,
                  - W - each line can contain one or more words separated by space,
                  - C - each line is treated like code (Camel Case is allowed).
                  
                  Default is S.
                  
                  C is the slowest to load due to the need to split each line based upon code splitting rules.
                  "%
                  | optional,
                useCompounds
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Use Compounds.
                  "%
                  | optional,
                words
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be considered correct.
                  "%
                  | optional,
              },
          DictionaryDefinitionInlineIgnoreWords = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional description.
                  "%
                  | optional,
                flagWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to always be considered incorrect. Words found in `flagWords` override `words`.
                  
                  Format of `flagWords`
                  - single word entry - `word`
                  - with suggestions - `word:suggestion` or `word->suggestion, suggestions`
                  
                  Example: ```ts "flagWords": [   "color: colour",   "incase: in case, encase",   "canot->cannot",   "cancelled->canceled" ] ```
                  "%
                  | optional,
                ignoreWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be ignored. An ignored word will not show up as an error, even if it is also in the `flagWords`.
                  "%,
                name
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryId
                  | doc m%"
                  This is the name of a dictionary.
                  
                  Name Format:
                  - Must contain at least 1 number or letter.
                  - Spaces are allowed.
                  - Leading and trailing space will be removed.
                  - Names ARE case-sensitive.
                  - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
                  "%,
                noSuggest
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Indicate that suggestions should not come from this dictionary. Words in this dictionary are considered correct, but will not be used when making spell correction suggestions.
                  
                  Note: if a word is suggested by another dictionary, but found in this dictionary, it will be removed from the set of possible suggestions.
                  "%
                  | optional,
                repMap
                  | predicates.contract_from_predicate
                  definitions.predicate.ReplaceMap
                  | doc m%"
                  Replacement pairs.
                  "%
                  | optional,
                suggestWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of suggested replacements for words. Suggested words provide a way to make preferred suggestions on word replacements. To hint at a preferred change, but not to require it.
                  
                  Format of `suggestWords`
                  - Single suggestion (possible auto fix)     - `word: suggestion`     - `word->suggestion`
                  - Multiple suggestions (not auto fixable)    - `word: first, second, third`    - `word->first, second, third`
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryFileTypes
                  | doc m%"
                  Type of file:
                  - S - single word per line,
                  - W - each line can contain one or more words separated by space,
                  - C - each line is treated like code (Camel Case is allowed).
                  
                  Default is S.
                  
                  C is the slowest to load due to the need to split each line based upon code splitting rules.
                  "%
                  | optional,
                useCompounds
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Use Compounds.
                  "%
                  | optional,
                words
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be considered correct.
                  "%
                  | optional,
              },
          DictionaryDefinitionInlineWords = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional description.
                  "%
                  | optional,
                flagWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to always be considered incorrect. Words found in `flagWords` override `words`.
                  
                  Format of `flagWords`
                  - single word entry - `word`
                  - with suggestions - `word:suggestion` or `word->suggestion, suggestions`
                  
                  Example: ```ts "flagWords": [   "color: colour",   "incase: in case, encase",   "canot->cannot",   "cancelled->canceled" ] ```
                  "%
                  | optional,
                ignoreWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be ignored. An ignored word will not show up as an error, even if it is also in the `flagWords`.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryId
                  | doc m%"
                  This is the name of a dictionary.
                  
                  Name Format:
                  - Must contain at least 1 number or letter.
                  - Spaces are allowed.
                  - Leading and trailing space will be removed.
                  - Names ARE case-sensitive.
                  - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
                  "%,
                noSuggest
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Indicate that suggestions should not come from this dictionary. Words in this dictionary are considered correct, but will not be used when making spell correction suggestions.
                  
                  Note: if a word is suggested by another dictionary, but found in this dictionary, it will be removed from the set of possible suggestions.
                  "%
                  | optional,
                repMap
                  | predicates.contract_from_predicate
                  definitions.predicate.ReplaceMap
                  | doc m%"
                  Replacement pairs.
                  "%
                  | optional,
                suggestWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of suggested replacements for words. Suggested words provide a way to make preferred suggestions on word replacements. To hint at a preferred change, but not to require it.
                  
                  Format of `suggestWords`
                  - Single suggestion (possible auto fix)     - `word: suggestion`     - `word->suggestion`
                  - Multiple suggestions (not auto fixable)    - `word: first, second, third`    - `word->first, second, third`
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryFileTypes
                  | doc m%"
                  Type of file:
                  - S - single word per line,
                  - W - each line can contain one or more words separated by space,
                  - C - each line is treated like code (Camel Case is allowed).
                  
                  Default is S.
                  
                  C is the slowest to load due to the need to split each line based upon code splitting rules.
                  "%
                  | optional,
                useCompounds
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Use Compounds.
                  "%
                  | optional,
                words
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be considered correct.
                  "%,
              },
          DictionaryDefinitionPreferred = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional description.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryId
                  | doc m%"
                  This is the name of a dictionary.
                  
                  Name Format:
                  - Must contain at least 1 number or letter.
                  - Spaces are allowed.
                  - Leading and trailing space will be removed.
                  - Names ARE case-sensitive.
                  - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
                  "%,
                noSuggest
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Indicate that suggestions should not come from this dictionary. Words in this dictionary are considered correct, but will not be used when making spell correction suggestions.
                  
                  Note: if a word is suggested by another dictionary, but found in this dictionary, it will be removed from the set of possible suggestions.
                  "%
                  | optional,
                path
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryPath
                  | doc m%"
                  Path to the file.
                  "%,
                repMap
                  | predicates.contract_from_predicate
                  definitions.predicate.ReplaceMap
                  | doc m%"
                  Replacement pairs.
                  "%
                  | optional,
                type
                  | predicates.contract_from_predicate
                  definitions.predicate.DictionaryFileTypes
                  | doc m%"
                  Type of file:
                  - S - single word per line,
                  - W - each line can contain one or more words separated by space,
                  - C - each line is treated like code (Camel Case is allowed).
                  
                  Default is S.
                  
                  C is the slowest to load due to the need to split each line based upon code splitting rules.
                  "%
                  | optional,
                useCompounds
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Use Compounds.
                  "%
                  | optional,
              },
          DictionaryFileTypes = std.contract.Sequence
              [ std.enum.TagOrString, [| 'T, 'C, 'W, 'S |] ],
          DictionaryId
            | doc m%"
            This is the name of a dictionary.
            
            Name Format:
            - Must contain at least 1 number or letter.
            - Spaces are allowed.
            - Leading and trailing space will be removed.
            - Names ARE case-sensitive.
            - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryId,
          DictionaryInformation
            | doc m%"
            Use by dictionary authors to help improve the quality of suggestions given from the dictionary.
            
            Added with `v5.16.0`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryInformation,
          DictionaryNegRef
            | doc m%"
            This a negative reference to a named dictionary.
            
            It is used to exclude or include a dictionary by name.
            
            The reference starts with 1 or more `!`.
            - `!<dictionary_name>` - Used to exclude the dictionary matching `<dictionary_name>`.
            - `!!<dictionary_name>` - Used to re-include a dictionary matching `<dictionary_name>`.    Overrides `!<dictionary_name>`.
            - `!!!<dictionary_name>` - Used to exclude a dictionary matching `<dictionary_name>`.    Overrides `!!<dictionary_name>`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryNegRef,
          DictionaryPath
            | doc m%"
            A File System Path to a dictionary file. Pattern: `^.*\.(?:txt|trie|dic)(?:\.gz)?$`
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryPath,
          DictionaryRef
            | doc m%"
            This a reference to a named dictionary. It is expected to match the name of a dictionary.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryRef,
          DictionaryReference
            | doc m%"
            Reference to a dictionary by name. One of:
            -  {@link  DictionaryRef } 
            -  {@link  DictionaryNegRef }
            "%
            = predicates.contract_from_predicate
              definitions.predicate.DictionaryReference,
          EditCosts = {
                accentCosts
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to add / remove an accent This should be very cheap, it helps with fixing accent issues.
                  "%
                  | optional,
                baseCost
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  This is the base cost for making an edit.
                  "%
                  | optional,
                capsCosts
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The cost to change capitalization. This should be very cheap, it helps with fixing capitalization issues.
                  "%
                  | optional,
                firstLetterPenalty
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The extra cost incurred for changing the first letter of a word. This value should be less than `100 - baseCost`.
                  "%
                  | optional,
                nonAlphabetCosts
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  This is the cost for characters not in the alphabet.
                  "%
                  | optional,
              },
          FSPathResolvable
            | doc m%"
            A File System Path.
            
            Special Properties:
            - `${cwd}` prefix - will be replaced with the current working directory.
            - Relative paths are relative to the configuration file.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FSPathResolvable,
          FeatureEnableOnly = Bool,
          Features
            | doc m%"
            Features are behaviors or settings that can be explicitly configured.
            "%
            = predicates.contract_from_predicate definitions.predicate.Features,
          FsDictionaryPath
            | doc m%"
            A File System Path. Relative paths are relative to the configuration file.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FsDictionaryPath,
          FsPath
            | doc m%"
            A File System Path. Relative paths are relative to the configuration file.
            "%
            = predicates.contract_from_predicate definitions.predicate.FsPath,
          Glob
            | doc m%"
            These are glob expressions.
            "%
            = predicates.contract_from_predicate definitions.predicate.Glob,
          HunspellInformation = {
                aff
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Selected Hunspell AFF content. The content must be UTF-8
                  
                  Sections:
                  - TRY
                  - MAP
                  - REP
                  - KEY
                  - ICONV
                  - OCONV
                  
                  Example: ```hunspell # Comment TRY aeistlunkodmrvpgjhäõbüoöfcwzxðqþ` MAP aàâäAÀÂÄ MAP eéèêëEÉÈÊË MAP iîïyIÎÏY MAP oôöOÔÖ MAP (IJ)(Ĳ) ```
                  "%,
                costs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      accentCosts = predicates.isType '"Number",
                      baseCost = predicates.isType '"Number",
                      capsCosts = predicates.isType '"Number",
                      firstLetterPenalty = predicates.isType '"Number",
                      ioConvertCost = predicates.isType '"Number",
                      keyboardCost = predicates.isType '"Number",
                      mapCost = predicates.isType '"Number",
                      nonAlphabetCosts = predicates.isType '"Number",
                      replaceCosts = predicates.isType '"Number",
                      tryCharCost = predicates.isType '"Number",
                    }
                    {  }
                    false
                    predicates.never
                  ])
                  | doc m%"
                  The costs to apply when using the hunspell settings
                  "%
                  | optional,
              },
          LanguageId = predicates.contract_from_predicate
              definitions.predicate.LanguageId,
          LanguageIdMultiple
            | doc m%"
            This can be 'typescript,cpp,json,literal haskell', etc.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LanguageIdMultiple,
          LanguageIdMultipleNeg
            | doc m%"
            This can be 'typescript,cpp,json,literal haskell', etc.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LanguageIdMultipleNeg,
          LanguageIdSingle
            | doc m%"
            This can be '*', 'typescript', 'cpp', 'json', etc.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.LanguageIdSingle,
          LanguageSetting = {
                allowCompoundWords
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  True to enable compound word checking. See [Case Sensitivity](https://cspell.org/docs/case-sensitive/) for more details.
                  "%
                  | optional,
                caseSensitive
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Determines if words must match case and accent rules.
                  
                  - `false` - Case is ignored and accents can be missing on the entire word.   Incorrect accents or partially missing accents will be marked as incorrect.
                  - `true` - Case and accents are enforced.
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional description of configuration.
                  "%
                  | optional,
                dictionaries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DictionaryReference
                  ])
                  | doc m%"
                  Optional list of dictionaries to use. Each entry should match the name of the dictionary.
                  
                  To remove a dictionary from the list, add `!` before the name.
                  
                  For example, `!typescript` will turn off the dictionary with the name `typescript`.
                  
                  See the [Dictionaries](https://cspell.org/docs/dictionaries/) and [Custom Dictionaries](https://cspell.org/docs/dictionaries-custom/) for more details.
                  "%
                  | optional,
                dictionaryDefinitions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DictionaryDefinition
                  ])
                  | doc m%"
                  Define additional available dictionaries.
                  
                  For example, you can use the following to add a custom dictionary:
                  
                  ```json "dictionaryDefinitions": [   { "name": "custom-words", "path": "./custom-words.txt"} ], "dictionaries": ["custom-words"] ```
                  "%
                  | optional,
                enabled
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Is the spell checker enabled.
                  "%
                  | optional,
                flagWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to always be considered incorrect. Words found in `flagWords` override `words`.
                  
                  Format of `flagWords`
                  - single word entry - `word`
                  - with suggestions - `word:suggestion` or `word->suggestion, suggestions`
                  
                  Example: ```ts "flagWords": [   "color: colour",   "incase: in case, encase",   "canot->cannot",   "cancelled->canceled" ] ```
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional identifier.
                  "%
                  | optional,
                ignoreRegExpList
                  | predicates.contract_from_predicate
                  definitions.predicate.RegExpPatternList
                  | doc m%"
                  List of regular expression patterns or pattern names to exclude from spell checking.
                  
                  Example: `["href"]` - to exclude html href pattern.
                  
                  Regular expressions use JavaScript regular expression syntax.
                  
                  Example: to ignore ALL-CAPS words
                  
                  JSON ```json "ignoreRegExpList": ["/\\b[A-Z]+\\b/g"] ```
                  
                  YAML ```yaml ignoreRegExpList:   - >-    /\b[A-Z]+\b/g ```
                  
                  By default, several patterns are excluded. See [Configuration](https://cspell.org/configuration/patterns) for more details.
                  
                  While you can create your own patterns, you can also leverage several patterns that are [built-in to CSpell](https://cspell.org/types/cspell-types/types/PredefinedPatterns.html).
                  "%
                  | optional,
                ignoreWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be ignored. An ignored word will not show up as an error, even if it is also in the `flagWords`.
                  "%
                  | optional,
                includeRegExpList
                  | predicates.contract_from_predicate
                  definitions.predicate.RegExpPatternList
                  | doc m%"
                  List of regular expression patterns or defined pattern names to match for spell checking.
                  
                  If this property is defined, only text matching the included patterns will be checked.
                  
                  While you can create your own patterns, you can also leverage several patterns that are [built-in to CSpell](https://cspell.org/types/cspell-types/types/PredefinedPatterns.html).
                  "%
                  | optional,
                languageId
                  | predicates.contract_from_predicate
                  definitions.predicate.MatchingFileType
                  | doc m%"
                  The language id.  Ex: "typescript", "html", or "php".  "*" -- will match all languages.
                  "%,
                local
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.LocaleId,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.LocaleId
                    ]
                  ])
                  | doc m%"
                  Deprecated - The locale filter, matches against the language. This can be a comma separated list. "*" will match all locales.
                  "%
                  | optional,
                locale
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.LocaleId,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.LocaleId
                    ]
                  ])
                  | doc m%"
                  The locale filter, matches against the language. This can be a comma separated list. "*" will match all locales.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional name of configuration.
                  "%
                  | optional,
                noSuggestDictionaries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DictionaryReference
                  ])
                  | doc m%"
                  Optional list of dictionaries that will not be used for suggestions. Words in these dictionaries are considered correct, but will not be used when making spell correction suggestions.
                  
                  Note: if a word is suggested by another dictionary, but found in one of these dictionaries, it will be removed from the set of possible suggestions.
                  "%
                  | optional,
                patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RegExpPatternDefinition
                  ])
                  | doc m%"
                  Defines a list of patterns that can be used with the `ignoreRegExpList` and `includeRegExpList` options.
                  
                  For example:
                  
                  ```javascript "ignoreRegExpList": ["comments"], "patterns": [   {     "name": "comment-single-line",     "pattern": "/#.*​/g"   },   {     "name": "comment-multi-line",     "pattern": "/(?:\\/\\*[\\s\\S]*?\\*\\/)/g"   },   // You can also combine multiple named patterns into one single named pattern   {     "name": "comments",     "pattern": ["comment-single-line", "comment-multi-line"]   } ] ``` Defines a list of patterns that can be used with the `ignoreRegExpList` and `includeRegExpList` options.
                  "%
                  | optional,
                suggestWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of suggested replacements for words. Suggested words provide a way to make preferred suggestions on word replacements. To hint at a preferred change, but not to require it.
                  
                  Format of `suggestWords`
                  - Single suggestion (possible auto fix)     - `word: suggestion`     - `word->suggestion`
                  - Multiple suggestions (not auto fixable)    - `word: first, second, third`    - `word->first, second, third`
                  "%
                  | optional,
                words
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be considered correct.
                  "%
                  | optional,
              },
          LocaleId
            | doc m%"
            This is a written language locale like: 'en', 'en-GB', 'fr', 'es', 'de', etc.
            "%
            = predicates.contract_from_predicate definitions.predicate.LocaleId,
          MatchingFileType = predicates.contract_from_predicate
              definitions.predicate.MatchingFileType,
          OverrideSettings = {
                allowCompoundWords
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  True to enable compound word checking. See [Case Sensitivity](https://cspell.org/docs/case-sensitive/) for more details.
                  "%
                  | optional,
                caseSensitive
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Determines if words must match case and accent rules.
                  
                  - `false` - Case is ignored and accents can be missing on the entire word.   Incorrect accents or partially missing accents will be marked as incorrect.
                  - `true` - Case and accents are enforced.
                  "%
                  | optional,
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional description of configuration.
                  "%
                  | optional,
                dictionaries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DictionaryReference
                  ])
                  | doc m%"
                  Optional list of dictionaries to use. Each entry should match the name of the dictionary.
                  
                  To remove a dictionary from the list, add `!` before the name.
                  
                  For example, `!typescript` will turn off the dictionary with the name `typescript`.
                  
                  See the [Dictionaries](https://cspell.org/docs/dictionaries/) and [Custom Dictionaries](https://cspell.org/docs/dictionaries-custom/) for more details.
                  "%
                  | optional,
                dictionaryDefinitions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DictionaryDefinition
                  ])
                  | doc m%"
                  Define additional available dictionaries.
                  
                  For example, you can use the following to add a custom dictionary:
                  
                  ```json "dictionaryDefinitions": [   { "name": "custom-words", "path": "./custom-words.txt"} ], "dictionaries": ["custom-words"] ```
                  "%
                  | optional,
                enableFiletypes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LanguageIdSingle,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Enable / Disable checking file types (languageIds).
                  
                  These are in additional to the file types specified by `cSpell.enabledLanguageIds`.
                  
                  To disable a language, prefix with `!` as in `!json`,
                  
                  Example: ``` jsonc       // enable checking for jsonc !json       // disable checking for json kotlin      // enable checking for kotlin ```
                  "%
                  | optional,
                enabled
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Is the spell checker enabled.
                  "%
                  | optional,
                enabledLanguageIds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LanguageIdSingle
                  ])
                  | doc m%"
                  languageIds for the files to spell check.
                  "%
                  | optional,
                filename
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Glob,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.Glob
                    ]
                  ])
                  | doc m%"
                  Glob pattern or patterns to match against.
                  "%,
                flagWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to always be considered incorrect. Words found in `flagWords` override `words`.
                  
                  Format of `flagWords`
                  - single word entry - `word`
                  - with suggestions - `word:suggestion` or `word->suggestion, suggestions`
                  
                  Example: ```ts "flagWords": [   "color: colour",   "incase: in case, encase",   "canot->cannot",   "cancelled->canceled" ] ```
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional identifier.
                  "%
                  | optional,
                ignoreRegExpList
                  | predicates.contract_from_predicate
                  definitions.predicate.RegExpPatternList
                  | doc m%"
                  List of regular expression patterns or pattern names to exclude from spell checking.
                  
                  Example: `["href"]` - to exclude html href pattern.
                  
                  Regular expressions use JavaScript regular expression syntax.
                  
                  Example: to ignore ALL-CAPS words
                  
                  JSON ```json "ignoreRegExpList": ["/\\b[A-Z]+\\b/g"] ```
                  
                  YAML ```yaml ignoreRegExpList:   - >-    /\b[A-Z]+\b/g ```
                  
                  By default, several patterns are excluded. See [Configuration](https://cspell.org/configuration/patterns) for more details.
                  
                  While you can create your own patterns, you can also leverage several patterns that are [built-in to CSpell](https://cspell.org/types/cspell-types/types/PredefinedPatterns.html).
                  "%
                  | optional,
                ignoreWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be ignored. An ignored word will not show up as an error, even if it is also in the `flagWords`.
                  "%
                  | optional,
                includeRegExpList
                  | predicates.contract_from_predicate
                  definitions.predicate.RegExpPatternList
                  | doc m%"
                  List of regular expression patterns or defined pattern names to match for spell checking.
                  
                  If this property is defined, only text matching the included patterns will be checked.
                  
                  While you can create your own patterns, you can also leverage several patterns that are [built-in to CSpell](https://cspell.org/types/cspell-types/types/PredefinedPatterns.html).
                  "%
                  | optional,
                language
                  | predicates.contract_from_predicate
                  definitions.predicate.LocaleId
                  | doc m%"
                  Sets the locale.
                  "%
                  | optional,
                languageId
                  | predicates.contract_from_predicate
                  definitions.predicate.MatchingFileType
                  | doc m%"
                  Sets the programming language id to match file type.
                  "%
                  | optional,
                languageSettings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.LanguageSetting
                  ])
                  | doc m%"
                  Additional settings for individual languages.
                  
                  See [Language Settings](https://cspell.org/configuration/language-settings/) for more details.
                  "%
                  | optional,
                loadDefaultConfiguration
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  By default, the bundled dictionary configurations are loaded. Explicitly setting this to `false` will prevent ALL default configuration from being loaded.
                  "%
                  | optional,
                maxDuplicateProblems
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The maximum number of times the same word can be flagged as an error in a file.
                  "%
                  | optional,
                maxNumberOfProblems
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The maximum number of problems to report in a file.
                  "%
                  | optional,
                minWordLength
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The minimum length of a word before checking it against a dictionary.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Optional name of configuration.
                  "%
                  | optional,
                noSuggestDictionaries
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.DictionaryReference
                  ])
                  | doc m%"
                  Optional list of dictionaries that will not be used for suggestions. Words in these dictionaries are considered correct, but will not be used when making spell correction suggestions.
                  
                  Note: if a word is suggested by another dictionary, but found in one of these dictionaries, it will be removed from the set of possible suggestions.
                  "%
                  | optional,
                numSuggestions
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  Number of suggestions to make.
                  "%
                  | optional,
                patterns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.RegExpPatternDefinition
                  ])
                  | doc m%"
                  Defines a list of patterns that can be used with the `ignoreRegExpList` and `includeRegExpList` options.
                  
                  For example:
                  
                  ```javascript "ignoreRegExpList": ["comments"], "patterns": [   {     "name": "comment-single-line",     "pattern": "/#.*​/g"   },   {     "name": "comment-multi-line",     "pattern": "/(?:\\/\\*[\\s\\S]*?\\*\\/)/g"   },   // You can also combine multiple named patterns into one single named pattern   {     "name": "comments",     "pattern": ["comment-single-line", "comment-multi-line"]   } ] ``` Defines a list of patterns that can be used with the `ignoreRegExpList` and `includeRegExpList` options.
                  "%
                  | optional,
                pnpFiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The PnP files to search for. Note: `.mjs` files are not currently supported.
                  "%
                  | optional,
                suggestWords
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A list of suggested replacements for words. Suggested words provide a way to make preferred suggestions on word replacements. To hint at a preferred change, but not to require it.
                  
                  Format of `suggestWords`
                  - Single suggestion (possible auto fix)     - `word: suggestion`     - `word->suggestion`
                  - Multiple suggestions (not auto fixable)    - `word: first, second, third`    - `word->first, second, third`
                  "%
                  | optional,
                suggestionNumChanges
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The maximum number of changes allowed on a word to be considered a suggestions.
                  
                  For example, appending an `s` onto `example` -> `examples` is considered 1 change.
                  
                  Range: between 1 and 5.
                  "%
                  | optional,
                suggestionsTimeout
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The maximum amount of time in milliseconds to generate suggestions for a word.
                  "%
                  | optional,
                usePnP
                  | predicates.contract_from_predicate
                  (predicates.isType '"Bool")
                  | doc m%"
                  Packages managers like Yarn 2 use a `.pnp.cjs` file to assist in loading packages stored in the repository.
                  
                  When true, the spell checker will search up the directory structure for the existence of a PnP file and load it.
                  "%
                  | optional,
                words
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  List of words to be considered correct.
                  "%
                  | optional,
              },
          Pattern = String,
          PatternAdjustment = {
                id
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Id of the Adjustment, i.e. `short-compound`
                  "%,
                penalty
                  | predicates.contract_from_predicate
                  (predicates.isType '"Number")
                  | doc m%"
                  The amount of penalty to apply.
                  "%,
                regexp
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  RegExp pattern to match
                  "%,
              },
          PatternId
            | doc m%"
            This matches the name in a pattern definition.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PatternId,
          PatternRef
            | doc m%"
            A PatternRef is a Pattern or PatternId.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PatternRef,
          PredefinedPatterns = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'Everything,
                  'UUID,
                  'Urls,
                  'UnicodeRef,
                  'string,
                  'SpellCheckerIgnoreInDocSetting,
                  'SpellCheckerDisableNext,
                  'SpellCheckerDisableLine,
                  'SpellCheckerDisableBlock,
                  'SpellCheckerDisable,
                  'HashStrings,
                  'SHA,
                  'SshRsa,
                  'RsaCert,
                  'PublicKey,
                  'PhpHereDoc,
                  'href,
                  'HexValues,
                  'EscapeCharacters,
                  'Email,
                  'CommitHashLink,
                  'CommitHash,
                  'CSSHexValue,
                  'CStyleHexValue,
                  'CStyleComment,
                  'Base64SingleLine,
                  'Base64MultiLine,
                  'Base64
                |]
              ],
          RegExpPatternDefinition = {
                description
                  | predicates.contract_from_predicate
                  (predicates.isType '"String")
                  | doc m%"
                  Description of the pattern.
                  "%
                  | optional,
                name
                  | predicates.contract_from_predicate
                  definitions.predicate.PatternId
                  | doc m%"
                  Pattern name, used as an identifier in ignoreRegExpList and includeRegExpList. It is possible to redefine one of the predefined patterns to override its value.
                  "%,
                pattern
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Pattern,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.Pattern
                    ]
                  ])
                  | doc m%"
                  RegExp pattern or array of RegExp patterns.
                  "%,
              },
          RegExpPatternList
            | doc m%"
            A list of pattern names or regular expressions.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.RegExpPatternList,
          ReplaceEntry = predicates.contract_from_predicate
              definitions.predicate.ReplaceEntry,
          ReplaceMap = predicates.contract_from_predicate
              definitions.predicate.ReplaceMap,
          ReporterModuleName
            | doc m%"
            The module or path to the the reporter to load.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ReporterModuleName,
          ReporterOptions
            | doc m%"
            Options to send to the reporter. These are defined by the reporter.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ReporterOptions,
          ReporterSettings
            | doc m%"
            Declare a reporter to use.
            
            `default` - is a special name for the default cli reporter.
            
            Examples:
            - `"default"` - to use the default reporter
            - `"@cspell/cspell-json-reporter"` - use the cspell JSON reporter.
            - `["@cspell/cspell-json-reporter", { "outFile": "out.json" }]`
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ReporterSettings,
          Serializable = predicates.contract_from_predicate
              definitions.predicate.Serializable,
          SimpleGlob
            | doc m%"
            Simple Glob string, the root will be globRoot.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SimpleGlob,
          SuggestionCostMapDef
            | doc m%"
            A WeightedMapDef enables setting weights for edits between related characters and substrings.
            
            Multiple groups can be defined using a `|`. A multi-character substring is defined using `()`.
            
            For example, in some languages, some letters sound alike.
            
            ```yaml   map: 'sc(sh)(sch)(ss)|t(tt)' # two groups.   replace: 50    # Make it 1/2 the cost of a normal edit to replace a `t` with `tt`. ```
            
            The following could be used to make inserting, removing, or replacing vowels cheaper. ```yaml   map: 'aeiouy'   insDel: 50     # Make it is cheaper to insert or delete a vowel.   replace: 45    # It is even cheaper to replace one with another. ```
            
            Note: the default edit distance is 100.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SuggestionCostMapDef,
          SuggestionCostsDefs = predicates.contract_from_predicate
              definitions.predicate.SuggestionCostsDefs,
          Version = predicates.contract_from_predicate
              definitions.predicate.Version,
          VersionLatest
            | doc m%"
            Configuration File Version.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.VersionLatest,
          VersionLegacy
            | doc m%"
            Legacy Configuration File Versions.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.VersionLegacy,
        },
    predicate = {
          CacheFormat = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "legacy", "universal" ]
              ],
          CacheSettings = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cacheFormat = definitions.predicate.CacheFormat,
                  cacheLocation = definitions.predicate.FSPathResolvable,
                  cacheStrategy = definitions.predicate.CacheStrategy,
                  useCache = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          CacheStrategy
            | doc m%"
            The Strategy to use to detect if a file has changed.
            - `metadata` - uses the file system timestamp and size to detect changes (fastest).
            - `content` - uses a hash of the file content to check file changes (slower - more accurate).
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "metadata", "content" ]
              ],
          CharacterSet
            | doc m%"
            This is a set of characters that can include `-` or `|`
            - `-` - indicates a range of characters: `a-c` => `abc`
            - `|` - is a group separator, indicating that the characters on either side    are not related.
            "%
            = predicates.isType '"String",
          CharacterSetCosts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "characters", "cost" ],
                predicates.records.record
                {
                  characters = definitions.predicate.CharacterSet,
                  cost = predicates.isType '"Number",
                  penalty = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          CostMapDefInsDel = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "insDel", "map" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  insDel = predicates.isType '"Number",
                  map = predicates.isType '"String",
                  penalty = predicates.isType '"Number",
                  replace = predicates.isType '"Number",
                  swap = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          CostMapDefReplace = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "map", "replace" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  insDel = predicates.isType '"Number",
                  map = predicates.isType '"String",
                  penalty = predicates.isType '"Number",
                  replace = predicates.isType '"Number",
                  swap = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          CostMapDefSwap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "map", "swap" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  insDel = predicates.isType '"Number",
                  map = predicates.isType '"String",
                  penalty = predicates.isType '"Number",
                  replace = predicates.isType '"Number",
                  swap = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          CustomDictionaryPath
            | doc m%"
            A File System Path to a dictionary file.
            "%
            = definitions.predicate.FsDictionaryPath,
          CustomDictionaryScope
            | doc m%"
            Specifies the scope of a dictionary.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "user", "workspace", "folder" ]
              ],
          DictionaryDefinition = predicates.anyOf
              [
                definitions.predicate.DictionaryDefinitionPreferred,
                definitions.predicate.DictionaryDefinitionCustom,
                definitions.predicate.DictionaryDefinitionAugmented,
                definitions.predicate.DictionaryDefinitionInline,
                definitions.predicate.DictionaryDefinitionAlternate
              ],
          DictionaryDefinitionAlternate
            | doc m%"
            Only for legacy dictionary definitions.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "file", "name" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  file = definitions.predicate.DictionaryPath,
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  repMap = definitions.predicate.ReplaceMap,
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DictionaryDefinitionAugmented
            | doc m%"
            Used to provide extra data related to the dictionary
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "path" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  dictionaryInformation =
                    definitions.predicate.DictionaryInformation,
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  path = definitions.predicate.DictionaryPath,
                  repMap = definitions.predicate.ReplaceMap,
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DictionaryDefinitionCustom
            | doc m%"
            For Defining Custom dictionaries. They are generally scoped to a `user`, `workspace`, or `folder`. When `addWords` is true, indicates that the spell checker can add words to the file.
            
            Note: only plain text files with one word per line are supported at this moment.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "addWords", "name", "path" ],
                predicates.records.record
                {
                  addWords = predicates.isType '"Bool",
                  description = predicates.isType '"String",
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  path = definitions.predicate.CustomDictionaryPath,
                  repMap = definitions.predicate.ReplaceMap,
                  scope = predicates.anyOf
                      [
                        definitions.predicate.CustomDictionaryScope,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.CustomDictionaryScope
                        ]
                      ],
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DictionaryDefinitionInline
            | doc m%"
            Inline Dictionary Definitions
            "%
            = predicates.anyOf
              [
                definitions.predicate.DictionaryDefinitionInlineWords,
                definitions.predicate.DictionaryDefinitionInlineIgnoreWords,
                definitions.predicate.DictionaryDefinitionInlineFlagWords
              ],
          DictionaryDefinitionInlineFlagWords = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "flagWords", "name" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  flagWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignoreWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  repMap = definitions.predicate.ReplaceMap,
                  suggestWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                  words = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DictionaryDefinitionInlineIgnoreWords = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "ignoreWords", "name" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  flagWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignoreWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  repMap = definitions.predicate.ReplaceMap,
                  suggestWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                  words = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DictionaryDefinitionInlineWords = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "words" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  flagWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  ignoreWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  repMap = definitions.predicate.ReplaceMap,
                  suggestWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                  words = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          DictionaryDefinitionPreferred = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "path" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  name = definitions.predicate.DictionaryId,
                  noSuggest = predicates.isType '"Bool",
                  path = definitions.predicate.DictionaryPath,
                  repMap = definitions.predicate.ReplaceMap,
                  type = definitions.predicate.DictionaryFileTypes,
                  useCompounds = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          DictionaryFileTypes = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "S", "W", "C", "T" ]
              ],
          DictionaryId
            | doc m%"
            This is the name of a dictionary.
            
            Name Format:
            - Must contain at least 1 number or letter.
            - Spaces are allowed.
            - Leading and trailing space will be removed.
            - Names ARE case-sensitive.
            - Must not contain `*`, `!`, `;`, `,`, `{`, `}`, `[`, `]`, `~`.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?=[^!*,;{}[\\]~\\n]+$)(?=(.*\\w)).+$"
              ],
          DictionaryInformation
            | doc m%"
            Use by dictionary authors to help improve the quality of suggestions given from the dictionary.
            
            Added with `v5.16.0`.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accents = predicates.anyOf
                      [
                        definitions.predicate.CharacterSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.CharacterSetCosts
                        ]
                      ],
                  adjustments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.PatternAdjustment
                      ],
                  alphabet = predicates.anyOf
                      [
                        definitions.predicate.CharacterSet,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.CharacterSetCosts
                        ]
                      ],
                  costs = definitions.predicate.EditCosts,
                  hunspellInformation =
                    definitions.predicate.HunspellInformation,
                  ignore = definitions.predicate.CharacterSet,
                  locale = predicates.isType '"String",
                  suggestionEditCosts =
                    definitions.predicate.SuggestionCostsDefs,
                }
                {  }
                false
                predicates.never
              ],
          DictionaryNegRef
            | doc m%"
            This a negative reference to a named dictionary.
            
            It is used to exclude or include a dictionary by name.
            
            The reference starts with 1 or more `!`.
            - `!<dictionary_name>` - Used to exclude the dictionary matching `<dictionary_name>`.
            - `!!<dictionary_name>` - Used to re-include a dictionary matching `<dictionary_name>`.    Overrides `!<dictionary_name>`.
            - `!!!<dictionary_name>` - Used to exclude a dictionary matching `<dictionary_name>`.    Overrides `!!<dictionary_name>`.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^(?=!+[^!*,;{}[\\]~\\n]+$)(?=(.*\\w)).+$"
              ],
          DictionaryPath
            | doc m%"
            A File System Path to a dictionary file. Pattern: `^.*\.(?:txt|trie|dic)(?:\.gz)?$`
            "%
            = predicates.isType '"String",
          DictionaryRef
            | doc m%"
            This a reference to a named dictionary. It is expected to match the name of a dictionary.
            "%
            = definitions.predicate.DictionaryId,
          DictionaryReference
            | doc m%"
            Reference to a dictionary by name. One of:
            -  {@link  DictionaryRef } 
            -  {@link  DictionaryNegRef }
            "%
            = predicates.anyOf
              [
                definitions.predicate.DictionaryRef,
                definitions.predicate.DictionaryNegRef
              ],
          EditCosts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  accentCosts = predicates.isType '"Number",
                  baseCost = predicates.isType '"Number",
                  capsCosts = predicates.isType '"Number",
                  firstLetterPenalty = predicates.isType '"Number",
                  nonAlphabetCosts = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          FSPathResolvable
            | doc m%"
            A File System Path.
            
            Special Properties:
            - `${cwd}` prefix - will be replaced with the current working directory.
            - Relative paths are relative to the configuration file.
            "%
            = definitions.predicate.FsPath,
          FeatureEnableOnly = predicates.isType '"Bool",
          Features
            | doc m%"
            Features are behaviors or settings that can be explicitly configured.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  weighted-suggestions =
                    definitions.predicate.FeatureEnableOnly,
                }
                {  }
                false
                predicates.never
              ],
          FsDictionaryPath
            | doc m%"
            A File System Path. Relative paths are relative to the configuration file.
            "%
            = predicates.isType '"String",
          FsPath
            | doc m%"
            A File System Path. Relative paths are relative to the configuration file.
            "%
            = predicates.isType '"String",
          Glob
            | doc m%"
            These are glob expressions.
            "%
            = definitions.predicate.SimpleGlob,
          HunspellInformation = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "aff" ],
                predicates.records.record
                {
                  aff = predicates.isType '"String",
                  costs = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          accentCosts = predicates.isType '"Number",
                          baseCost = predicates.isType '"Number",
                          capsCosts = predicates.isType '"Number",
                          firstLetterPenalty = predicates.isType '"Number",
                          ioConvertCost = predicates.isType '"Number",
                          keyboardCost = predicates.isType '"Number",
                          mapCost = predicates.isType '"Number",
                          nonAlphabetCosts = predicates.isType '"Number",
                          replaceCosts = predicates.isType '"Number",
                          tryCharCost = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LanguageId = predicates.anyOf
              [
                definitions.predicate.LanguageIdSingle,
                definitions.predicate.LanguageIdMultiple,
                definitions.predicate.LanguageIdMultipleNeg
              ],
          LanguageIdMultiple
            | doc m%"
            This can be 'typescript,cpp,json,literal haskell', etc.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^([-\\w_\\s]+)(,[-\\w_\\s]+)*$"
              ],
          LanguageIdMultipleNeg
            | doc m%"
            This can be 'typescript,cpp,json,literal haskell', etc.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(![-\\w_\\s]+)(,![-\\w_\\s]+)*$"
              ],
          LanguageIdSingle
            | doc m%"
            This can be '*', 'typescript', 'cpp', 'json', etc.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^(!?[-\\w_\\s]+)|(\\*)$"
              ],
          LanguageSetting = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "languageId" ],
                predicates.records.record
                {
                  allowCompoundWords = predicates.isType '"Bool",
                  caseSensitive = predicates.isType '"Bool",
                  description = predicates.isType '"String",
                  dictionaries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DictionaryReference
                      ],
                  dictionaryDefinitions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DictionaryDefinition
                      ],
                  enabled = predicates.isType '"Bool",
                  flagWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.isType '"String",
                  ignoreRegExpList = definitions.predicate.RegExpPatternList,
                  ignoreWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeRegExpList = definitions.predicate.RegExpPatternList,
                  languageId = definitions.predicate.MatchingFileType,
                  local = predicates.anyOf
                      [
                        definitions.predicate.LocaleId,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.LocaleId
                        ]
                      ],
                  locale = predicates.anyOf
                      [
                        definitions.predicate.LocaleId,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.LocaleId
                        ]
                      ],
                  name = predicates.isType '"String",
                  noSuggestDictionaries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DictionaryReference
                      ],
                  patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RegExpPatternDefinition
                      ],
                  suggestWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  words = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LocaleId
            | doc m%"
            This is a written language locale like: 'en', 'en-GB', 'fr', 'es', 'de', etc.
            "%
            = predicates.isType '"String",
          MatchingFileType = predicates.anyOf
              [
                definitions.predicate.LanguageId,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.LanguageId
                ]
              ],
          OverrideSettings = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "filename" ],
                predicates.records.record
                {
                  allowCompoundWords = predicates.isType '"Bool",
                  caseSensitive = predicates.isType '"Bool",
                  description = predicates.isType '"String",
                  dictionaries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DictionaryReference
                      ],
                  dictionaryDefinitions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DictionaryDefinition
                      ],
                  enableFiletypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LanguageIdSingle,
                        predicates.arrays.uniqueItems
                      ],
                  enabled = predicates.isType '"Bool",
                  enabledLanguageIds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LanguageIdSingle
                      ],
                  filename = predicates.anyOf
                      [
                        definitions.predicate.Glob,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf definitions.predicate.Glob
                        ]
                      ],
                  flagWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  id = predicates.isType '"String",
                  ignoreRegExpList = definitions.predicate.RegExpPatternList,
                  ignoreWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeRegExpList = definitions.predicate.RegExpPatternList,
                  language = definitions.predicate.LocaleId,
                  languageId = definitions.predicate.MatchingFileType,
                  languageSettings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.LanguageSetting
                      ],
                  loadDefaultConfiguration = predicates.isType '"Bool",
                  maxDuplicateProblems = predicates.isType '"Number",
                  maxNumberOfProblems = predicates.isType '"Number",
                  minWordLength = predicates.isType '"Number",
                  name = predicates.isType '"String",
                  noSuggestDictionaries = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.DictionaryReference
                      ],
                  numSuggestions = predicates.isType '"Number",
                  patterns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.RegExpPatternDefinition
                      ],
                  pnpFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  suggestWords = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  suggestionNumChanges = predicates.isType '"Number",
                  suggestionsTimeout = predicates.isType '"Number",
                  usePnP = predicates.isType '"Bool",
                  words = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Pattern = predicates.isType '"String",
          PatternAdjustment = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id", "penalty", "regexp" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  penalty = predicates.isType '"Number",
                  regexp = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          PatternId
            | doc m%"
            This matches the name in a pattern definition.
            "%
            = predicates.isType '"String",
          PatternRef
            | doc m%"
            A PatternRef is a Pattern or PatternId.
            "%
            = predicates.anyOf
              [
                definitions.predicate.Pattern,
                definitions.predicate.PatternId,
                definitions.predicate.PredefinedPatterns
              ],
          PredefinedPatterns = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "Base64",
                  "Base64MultiLine",
                  "Base64SingleLine",
                  "CStyleComment",
                  "CStyleHexValue",
                  "CSSHexValue",
                  "CommitHash",
                  "CommitHashLink",
                  "Email",
                  "EscapeCharacters",
                  "HexValues",
                  "href",
                  "PhpHereDoc",
                  "PublicKey",
                  "RsaCert",
                  "SshRsa",
                  "SHA",
                  "HashStrings",
                  "SpellCheckerDisable",
                  "SpellCheckerDisableBlock",
                  "SpellCheckerDisableLine",
                  "SpellCheckerDisableNext",
                  "SpellCheckerIgnoreInDocSetting",
                  "string",
                  "UnicodeRef",
                  "Urls",
                  "UUID",
                  "Everything"
                ]
              ],
          RegExpPatternDefinition = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "pattern" ],
                predicates.records.record
                {
                  description = predicates.isType '"String",
                  name = definitions.predicate.PatternId,
                  pattern = predicates.anyOf
                      [
                        definitions.predicate.Pattern,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.Pattern
                        ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RegExpPatternList
            | doc m%"
            A list of pattern names or regular expressions.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.PatternRef
              ],
          ReplaceEntry = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String"),
                predicates.arrays.maxItems 2,
                predicates.arrays.minItems 2
              ],
          ReplaceMap = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.ReplaceEntry
              ],
          ReporterModuleName
            | doc m%"
            The module or path to the the reporter to load.
            "%
            = predicates.isType '"String",
          ReporterOptions
            | doc m%"
            Options to send to the reporter. These are defined by the reporter.
            "%
            = definitions.predicate.Serializable,
          ReporterSettings
            | doc m%"
            Declare a reporter to use.
            
            `default` - is a special name for the default cli reporter.
            
            Examples:
            - `"default"` - to use the default reporter
            - `"@cspell/cspell-json-reporter"` - use the cspell JSON reporter.
            - `["@cspell/cspell-json-reporter", { "outFile": "out.json" }]`
            "%
            = predicates.anyOf
              [
                definitions.predicate.ReporterModuleName,
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.ReporterModuleName,
                  predicates.arrays.maxItems 1,
                  predicates.arrays.minItems 1
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.items
                  [
                    definitions.predicate.ReporterModuleName,
                    definitions.predicate.ReporterOptions
                  ],
                  predicates.arrays.maxItems 2,
                  predicates.arrays.minItems 2
                ]
              ],
          Serializable = predicates.anyOf
              [
                predicates.isType '"Number",
                predicates.isType '"String",
                predicates.isType '"Bool",
                predicates.isType 'Null,
                predicates.isType 'Record
              ],
          SimpleGlob
            | doc m%"
            Simple Glob string, the root will be globRoot.
            "%
            = predicates.isType '"String",
          SuggestionCostMapDef
            | doc m%"
            A WeightedMapDef enables setting weights for edits between related characters and substrings.
            
            Multiple groups can be defined using a `|`. A multi-character substring is defined using `()`.
            
            For example, in some languages, some letters sound alike.
            
            ```yaml   map: 'sc(sh)(sch)(ss)|t(tt)' # two groups.   replace: 50    # Make it 1/2 the cost of a normal edit to replace a `t` with `tt`. ```
            
            The following could be used to make inserting, removing, or replacing vowels cheaper. ```yaml   map: 'aeiouy'   insDel: 50     # Make it is cheaper to insert or delete a vowel.   replace: 45    # It is even cheaper to replace one with another. ```
            
            Note: the default edit distance is 100.
            "%
            = predicates.anyOf
              [
                definitions.predicate.CostMapDefReplace,
                definitions.predicate.CostMapDefInsDel,
                definitions.predicate.CostMapDefSwap
              ],
          SuggestionCostsDefs = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.SuggestionCostMapDef
              ],
          Version = predicates.anyOf
              [
                definitions.predicate.VersionLatest,
                definitions.predicate.VersionLegacy
              ],
          VersionLatest
            | doc m%"
            Configuration File Version.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.const "0.2" ],
          VersionLegacy
            | doc m%"
            Legacy Configuration File Versions.
            "%
            = predicates.allOf
              [ predicates.isType '"String", predicates.const "0.1" ],
        },
  }
in

{
  "$schema"
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    Url to JSON Schema
    "%
    | optional,
  allowCompoundWords
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    True to enable compound word checking. See [Case Sensitivity](https://cspell.org/docs/case-sensitive/) for more details.
    "%
    | optional,
  cache
    | predicates.contract_from_predicate definitions.predicate.CacheSettings
    | doc m%"
    Define cache settings.
    "%
    | optional,
  caseSensitive
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Determines if words must match case and accent rules.
    
    - `false` - Case is ignored and accents can be missing on the entire word.   Incorrect accents or partially missing accents will be marked as incorrect.
    - `true` - Case and accents are enforced.
    "%
    | optional,
  description
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    Optional description of configuration.
    "%
    | optional,
  dictionaries
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.DictionaryReference
    ])
    | doc m%"
    Optional list of dictionaries to use. Each entry should match the name of the dictionary.
    
    To remove a dictionary from the list, add `!` before the name.
    
    For example, `!typescript` will turn off the dictionary with the name `typescript`.
    
    See the [Dictionaries](https://cspell.org/docs/dictionaries/) and [Custom Dictionaries](https://cspell.org/docs/dictionaries-custom/) for more details.
    "%
    | optional,
  dictionaryDefinitions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.DictionaryDefinition
    ])
    | doc m%"
    Define additional available dictionaries.
    
    For example, you can use the following to add a custom dictionary:
    
    ```json "dictionaryDefinitions": [   { "name": "custom-words", "path": "./custom-words.txt"} ], "dictionaries": ["custom-words"] ```
    "%
    | optional,
  enableFiletypes
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.LanguageIdSingle,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Enable / Disable checking file types (languageIds).
    
    These are in additional to the file types specified by `cSpell.enabledLanguageIds`.
    
    To disable a language, prefix with `!` as in `!json`,
    
    Example: ``` jsonc       // enable checking for jsonc !json       // disable checking for json kotlin      // enable checking for kotlin ```
    "%
    | optional,
  enableGlobDot
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Enable scanning files and directories beginning with `.` (period).
    
    By default, CSpell does not scan `hidden` files.
    "%
    | optional,
  enabled
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Is the spell checker enabled.
    "%
    | optional,
  enabledLanguageIds
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.LanguageIdSingle
    ])
    | doc m%"
    languageIds for the files to spell check.
    "%
    | optional,
  failFast
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Exit with non-zero code as soon as an issue/error is encountered (useful for CI or git hooks)
    "%
    | optional,
  features
    | predicates.contract_from_predicate definitions.predicate.Features
    | doc m%"
    Configure CSpell features.
    "%
    | optional,
  files
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Glob
    ])
    | doc m%"
    Glob patterns of files to be checked.
    
    Glob patterns are relative to the `globRoot` of the configuration file that defines them.
    "%
    | optional,
  flagWords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of words to always be considered incorrect. Words found in `flagWords` override `words`.
    
    Format of `flagWords`
    - single word entry - `word`
    - with suggestions - `word:suggestion` or `word->suggestion, suggestions`
    
    Example: ```ts "flagWords": [   "color: colour",   "incase: in case, encase",   "canot->cannot",   "cancelled->canceled" ] ```
    "%
    | optional,
  gitignoreRoot
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.FsPath,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.FsPath
      ]
    ])
    | doc m%"
    Tells the spell checker to searching for `.gitignore` files when it reaches a matching root.
    "%
    | optional,
  globRoot
    | predicates.contract_from_predicate definitions.predicate.FSPathResolvable
    | doc m%"
    The root to use for glob patterns found in this configuration. Default: location of the configuration file.   For compatibility reasons, config files with version 0.1, the glob root will   default to be `${cwd}`.
    
    Use `globRoot` to define a different location. `globRoot` can be relative to the location of this configuration file. Defining globRoot, does not impact imported configurations.
    
    Special Values:
    - `${cwd}` - will be replaced with the current working directory.
    - `.` - will be the location of the containing configuration file.
    "%
    | optional,
  id
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    Optional identifier.
    "%
    | optional,
  ignorePaths
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.Glob
    ])
    | doc m%"
    Glob patterns of files to be ignored.
    
    Glob patterns are relative to the `globRoot` of the configuration file that defines them.
    "%
    | optional,
  ignoreRegExpList
    | predicates.contract_from_predicate definitions.predicate.RegExpPatternList
    | doc m%"
    List of regular expression patterns or pattern names to exclude from spell checking.
    
    Example: `["href"]` - to exclude html href pattern.
    
    Regular expressions use JavaScript regular expression syntax.
    
    Example: to ignore ALL-CAPS words
    
    JSON ```json "ignoreRegExpList": ["/\\b[A-Z]+\\b/g"] ```
    
    YAML ```yaml ignoreRegExpList:   - >-    /\b[A-Z]+\b/g ```
    
    By default, several patterns are excluded. See [Configuration](https://cspell.org/configuration/patterns) for more details.
    
    While you can create your own patterns, you can also leverage several patterns that are [built-in to CSpell](https://cspell.org/types/cspell-types/types/PredefinedPatterns.html).
    "%
    | optional,
  ignoreWords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of words to be ignored. An ignored word will not show up as an error, even if it is also in the `flagWords`.
    "%
    | optional,
  "import"
    | predicates.contract_from_predicate
    (predicates.anyOf
    [
      definitions.predicate.FsPath,
      predicates.allOf
      [
        predicates.isType '"Array",
        predicates.arrays.arrayOf definitions.predicate.FsPath
      ]
    ])
    | doc m%"
    Allows this configuration to inherit configuration for one or more other files.
    
    See [Importing / Extending Configuration](https://cspell.org/configuration/imports/) for more details.
    "%
    | optional,
  includeRegExpList
    | predicates.contract_from_predicate definitions.predicate.RegExpPatternList
    | doc m%"
    List of regular expression patterns or defined pattern names to match for spell checking.
    
    If this property is defined, only text matching the included patterns will be checked.
    
    While you can create your own patterns, you can also leverage several patterns that are [built-in to CSpell](https://cspell.org/types/cspell-types/types/PredefinedPatterns.html).
    "%
    | optional,
  language
    | predicates.contract_from_predicate definitions.predicate.LocaleId
    | doc m%"
    Current active spelling language. This specifies the language locale to use in choosing the general dictionary.
    
    For example:
    
    - "en-GB" for British English.
    - "en,nl" to enable both English and Dutch.
    "%
    | optional,
  languageId
    | predicates.contract_from_predicate definitions.predicate.MatchingFileType
    | doc m%"
    Forces the spell checker to assume a give language id. Used mainly as an Override.
    "%
    | optional,
  languageSettings
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.LanguageSetting
    ])
    | doc m%"
    Additional settings for individual languages.
    
    See [Language Settings](https://cspell.org/configuration/language-settings/) for more details.
    "%
    | optional,
  loadDefaultConfiguration
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    By default, the bundled dictionary configurations are loaded. Explicitly setting this to `false` will prevent ALL default configuration from being loaded.
    "%
    | optional,
  maxDuplicateProblems
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    The maximum number of times the same word can be flagged as an error in a file.
    "%
    | optional,
  maxNumberOfProblems
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    The maximum number of problems to report in a file.
    "%
    | optional,
  minWordLength
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    The minimum length of a word before checking it against a dictionary.
    "%
    | optional,
  name
    | predicates.contract_from_predicate (predicates.isType '"String")
    | doc m%"
    Optional name of configuration.
    "%
    | optional,
  noConfigSearch
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Prevents searching for local configuration when checking individual documents.
    "%
    | optional,
  noSuggestDictionaries
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.DictionaryReference
    ])
    | doc m%"
    Optional list of dictionaries that will not be used for suggestions. Words in these dictionaries are considered correct, but will not be used when making spell correction suggestions.
    
    Note: if a word is suggested by another dictionary, but found in one of these dictionaries, it will be removed from the set of possible suggestions.
    "%
    | optional,
  numSuggestions
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    Number of suggestions to make.
    "%
    | optional,
  overrides
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.OverrideSettings
    ])
    | doc m%"
    Overrides are used to apply settings for specific files in your project.
    
    For example:
    
    ```javascript "overrides": [   // Force `*.hrr` and `*.crr` files to be treated as `cpp` files:   {     "filename": "**​/{*.hrr,*.crr}",     "languageId": "cpp"   },   // Force `*.txt` to use the Dutch dictionary (Dutch dictionary needs to be installed separately):   {     "language": "nl",     "filename": "**​/dutch/**​/*.txt"   } ] ```
    "%
    | optional,
  patterns
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.RegExpPatternDefinition
    ])
    | doc m%"
    Defines a list of patterns that can be used with the `ignoreRegExpList` and `includeRegExpList` options.
    
    For example:
    
    ```javascript "ignoreRegExpList": ["comments"], "patterns": [   {     "name": "comment-single-line",     "pattern": "/#.*​/g"   },   {     "name": "comment-multi-line",     "pattern": "/(?:\\/\\*[\\s\\S]*?\\*\\/)/g"   },   // You can also combine multiple named patterns into one single named pattern   {     "name": "comments",     "pattern": ["comment-single-line", "comment-multi-line"]   } ] ``` Defines a list of patterns that can be used with the `ignoreRegExpList` and `includeRegExpList` options.
    "%
    | optional,
  pnpFiles
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    The PnP files to search for. Note: `.mjs` files are not currently supported.
    "%
    | optional,
  readonly
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Indicate that the configuration file should not be modified. This is used to prevent tools like the VS Code Spell Checker from modifying the file to add words and other configuration.
    "%
    | optional,
  reporters
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.ReporterSettings
    ])
    | doc m%"
    Define which reports to use. `default` - is a special name for the default cli reporter.
    
    Examples:
    - `["default"]` - to use the default reporter
    - `["@cspell/cspell-json-reporter"]` - use the cspell JSON reporter.
    - `[["@cspell/cspell-json-reporter", { "outFile": "out.json" }]]`
    - `[ "default", ["@cspell/cspell-json-reporter", { "outFile": "out.json" }]]` - Use both the default reporter and the cspell-json-reporter.
    "%
    | optional,
  showStatus
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Show status.
    "%
    | optional,
  spellCheckDelayMs
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    Delay in ms after a document has changed before checking it for spelling errors.
    "%
    | optional,
  suggestWords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    A list of suggested replacements for words. Suggested words provide a way to make preferred suggestions on word replacements. To hint at a preferred change, but not to require it.
    
    Format of `suggestWords`
    - Single suggestion (possible auto fix)     - `word: suggestion`     - `word->suggestion`
    - Multiple suggestions (not auto fixable)    - `word: first, second, third`    - `word->first, second, third`
    "%
    | optional,
  suggestionNumChanges
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    The maximum number of changes allowed on a word to be considered a suggestions.
    
    For example, appending an `s` onto `example` -> `examples` is considered 1 change.
    
    Range: between 1 and 5.
    "%
    | optional,
  suggestionsTimeout
    | predicates.contract_from_predicate (predicates.isType '"Number")
    | doc m%"
    The maximum amount of time in milliseconds to generate suggestions for a word.
    "%
    | optional,
  useGitignore
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Tells the spell checker to load `.gitignore` files and skip files that match the globs in the `.gitignore` files found.
    "%
    | optional,
  usePnP
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Packages managers like Yarn 2 use a `.pnp.cjs` file to assist in loading packages stored in the repository.
    
    When true, the spell checker will search up the directory structure for the existence of a PnP file and load it.
    "%
    | optional,
  userWords
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    Words to add to global dictionary -- should only be in the user config file.
    "%
    | optional,
  validateDirectives
    | predicates.contract_from_predicate (predicates.isType '"Bool")
    | doc m%"
    Verify that the in-document directives are correct.
    "%
    | optional,
  version
    | predicates.contract_from_predicate definitions.predicate.Version
    | doc m%"
    Configuration format version of the settings file.
    
    This controls how the settings in the configuration file behave.
    "%
    | optional,
  words
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf (predicates.isType '"String")
    ])
    | doc m%"
    List of words to be considered correct.
    "%
    | optional,
}