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
          buildConfig
            | doc m%"
            Build section defines configuration values for the build command.
            "%
            = {
                changesFile | String | optional,
                cleanupCacheHistory
                  | Bool
                  | doc m%"
                  If set to true, cleans up historical cache data when building.
                  "%
                  | optional,
                content | definitions.contract.fileMappingContent | optional,
                debug
                  | Bool
                  | doc m%"
                  Run in debug mode. With debug mode, raw model and view model will be exported automatically when it encounters error when applying templates. If not specified, it is false.
                  "%
                  | optional,
                debugOutput
                  | String
                  | doc m%"
                  The output folder for files generated for debugging purpose when in debug mode. If not specified, it is ${TempPath}/docfx.
                  "%
                  | optional,
                dest | String | optional,
                disableGitFeatures
                  | definitions.contract.disableGitFeatures
                  | optional,
                dryRun
                  | Bool
                  | doc m%"
                  If set to true, template will not be actually applied to the documents. This option is always used with `--exportRawModel` or `--exportViewModel`, so that only raw model files or view model files are generated.
                  "%
                  | optional,
                exportRawModel
                  | Bool
                  | doc m%"
                  If set to true, data model to run template script will be extracted in `.raw.json` extension.
                  "%
                  | optional,
                exportViewModel
                  | Bool
                  | doc m%"
                  If set to true, data model to apply template will be extracted in `.view.json` extension.
                  "%
                  | optional,
                externalReference
                  | definitions.contract.fileMappingExternalReferences
                  | optional,
                fileMetadata
                  | {  .. }
                  | doc m%"
                  Contains metadata that will be applied to specific files.
                  "%
                  | optional,
                fileMetadataFiles
                  | definitions.contract.fileMetadataFiles
                  | optional,
                "force"
                  | Bool
                  | doc m%"
                  
                  "%
                  | optional,
                forcePostProcess
                  | Bool
                  | doc m%"
                  Force to re-process the documentation in post processors. It will be cascaded from force option.
                  "%
                  | optional,
                globalMetadata
                  | {  .. }
                  | doc m%"
                  Contains metadata that will be applied to every file, in key-value pair format.
                  "%
                  | optional,
                globalMetadataFiles
                  | definitions.contract.globalMetadataFiles
                  | optional,
                intermediateFolder | String | optional,
                keepFileLink
                  | Bool
                  | doc m%"
                  If set to true, DocFX does not copy file to the output folder. Instead, it saves a link_to_path property inside manifest.json.
                  "%
                  | optional,
                lruSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Set the LRU cached model count (approximately the same as the count of input files). By default, it is 8192 for 64bit and 3072 for 32bit process. With LRU cache enabled, memory usage decreases and time consumed increases. If set to 0, Lru cache is disabled.
                  "%
                  | optional,
                markdownEngineName
                  | String
                  | doc m%"
                  Set the name of markdown engine, default is dfm, and another build-in engine is gfm.
                  "%
                  | optional,
                markdownEngineProperties
                  | {  .. }
                  | doc m%"
                  Set the parameters for markdown engine.
                  "%
                  | optional,
                maxParallelism
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  Set the max parallelism, 0 (default) is same as the count of CPU cores.
                  "%
                  | optional,
                noLangKeyword
                  | Bool
                  | doc m%"
                  Disable default lang keyword, e.g. `null`.
                  "%
                  | optional,
                overwrite
                  | definitions.contract.fileMappingOverwrite
                  | optional,
                port
                  | String
                  | doc m%"
                  Specify the port of the hosted website.
                  "%
                  | optional,
                postProcessors
                  | predicates.contract_from_predicate
                  (predicates.oneOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | optional,
                rawModelOutputFolder
                  | String
                  | doc m%"
                  Specify the output folder for the raw model. If not set, the raw model will be generated to the same folder as the output documentation.
                  "%
                  | optional,
                resource | definitions.contract.fileMappingResource | optional,
                serve
                  | Bool
                  | doc m%"
                  
                  "%
                  | optional,
                template | definitions.contract.template | optional,
                theme | definitions.contract.theme | optional,
                viewModelOutputFolder
                  | String
                  | doc m%"
                  Specify the output folder for the view model. If not set, the view model will be generated to the same folder as the output documentation.
                  "%
                  | optional,
                xref | definitions.contract.xref | optional,
              },
          disableGitFeatures
            | doc m%"
            If set to true, DocFX would not fetch Git related information for articles.
            "%
            = Bool,
          exclude
            | doc m%"
            The file glob pattern collection for files that should be excluded, with path relative to property `src`/`cwd` if value is set.
            "%
            = predicates.contract_from_predicate definitions.predicate.exclude,
          fileMappingContent
            | doc m%"
            Contains all the files to generate documentation, including metadata `yml` files and conceptual `md` files.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileMappingContent,
          fileMappingExternalReferences
            | doc m%"
            [Obsoleted] Contains `rpk` files that define the external references.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileMappingExternalReferences,
          fileMappingItem = {
                case
                  | Bool
                  | doc m%"
                  Pattern match will be case sensitive.
                  By default the pattern is case insensitive.
                  "%
                  | optional,
                cwd
                  | String
                  | doc m%"
                  [Obsoleted] Defines the root folder for the source files, it has the same meaning as `src`
                  "%
                  | optional,
                dest
                  | String
                  | doc m%"
                  The destination folder for the files if copy/transform is used.
                  "%
                  | optional,
                dot
                  | Bool
                  | doc m%"
                  Allow files start with `.` to be matched even if `.` is not explicitly specified in the pattern.
                  By default files start with `.` will not be matched by `*` unless the pattern starts with `.`.
                  "%
                  | optional,
                exclude | definitions.contract.exclude | optional,
                files | definitions.contract.files,
                name
                  | String
                  | doc m%"
                  The name of current item, the value is not used for now.
                  "%
                  | optional,
                noEscape
                  | Bool
                  | doc m%"
                  Disable the usage of `\` to escape values.
                  By default the usage is enabled.
                  "%
                  | optional,
                noExpand
                  | Bool
                  | doc m%"
                  Disable `{a,b}c` => `["ac", "bc"]`. By default the usage is enabled.
                  "%
                  | optional,
                noGlobStar
                  | Bool
                  | doc m%"
                  Disable the usage of `**` to match everything including `/` when it is the beginning of the pattern or is after `/`.
                  By default the usage is enable.
                  "%
                  | optional,
                noNegate
                  | Bool
                  | doc m%"
                  Disable pattern begin with `!` to mean negate.
                  By default the usage is enabled.
                  "%
                  | optional,
                rootTocPath
                  | String
                  | doc m%"
                  The Root TOC Path used for navbar in current version, relative to output root.
                  If not set, will use the toc in output root in current version if exists.
                  "%
                  | optional,
                src
                  | String
                  | doc m%"
                  Defines the root folder for the source files, it has the same meaning as `cwd`
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  Version name for the current file-mapping item.
                  If not set, treat the current file-mapping item as in default version.
                  Mappings with the same version name will be built together.
                  Cross reference doesn't support cross different versions.
                  "%
                  | optional,
              },
          fileMappingOverwrite
            | doc m%"
            Contains all the conceptual files which contains yaml header with `uid` and is intended to override the existing metadata `yml` files.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileMappingOverwrite,
          fileMappingResource
            | doc m%"
            Contains all the resource files that conceptual and metadata files dependent on, e.g. image files.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileMappingResource,
          fileMappingSrc
            | doc m%"
            Defines the source projects to have metadata generated.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileMappingSrc,
          fileMetadataFiles
            | doc m%"
            Specify a list of JSON file path containing fileMetadata settings, as similar to `{"key":"value"}`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.fileMetadataFiles,
          files
            | doc m%"
            The file glob pattern collection, with path relative to property `src`/`cwd` if value is set.
            "%
            = predicates.contract_from_predicate definitions.predicate.files,
          globalMetadataFiles
            | doc m%"
            Specify a list of JSON file path containing globalMetadata settings, as similar to `{"key":"value"}`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.globalMetadataFiles,
          metadataConfig
            | doc m%"
            Metadata section defines an array of source projects and their output folder.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.metadataConfig,
          metadataConfigItem = {
                dest
                  | String
                  | doc m%"
                  Defines the output folder of the generated metadata files.
                  "%,
                disableDefaultFilter
                  | Bool
                  | doc m%"
                  If set to true, disables default API visibility filter rule.
                  "%
                  | optional,
                disableGitFeatures
                  | definitions.contract.disableGitFeatures
                  | optional,
                filter
                  | String
                  | doc m%"
                  Defines the filter configuration file.
                  "%
                  | optional,
                "force"
                  | Bool
                  | doc m%"
                  If set to true, it would disable incremental build.
                  "%
                  | optional,
                raw | Bool | optional,
                shouldSkipMarkup
                  | Bool
                  | doc m%"
                  If set to true, DocFX would not render triple-slash-comments in source code as markdown.
                  "%
                  | optional,
                src | definitions.contract.fileMappingSrc,
                useCompatibilityFileName
                  | Bool
                  | doc m%"
                   If set to true, DocFX would keep ` in comment id instead of replacing it with -.
                  "%
                  | optional,
              },
          template
            | doc m%"
            The latter ones will override the former ones if the name of the file inside the template collides. If omitted, embedded default template will be used.
            "%
            = predicates.contract_from_predicate definitions.predicate.template,
          theme
            | doc m%"
            The themes applied to the documentation. Theme is used to customize the styles generated by `template`. It can be a string or an array. The latter ones will override the former ones if the name of the file inside the template collides. If omitted, no theme will be applied, the default theme inside the template will be used.
            "%
            = predicates.contract_from_predicate definitions.predicate.theme,
          xref
            | doc m%"
            Specifies the urls of xrefmap used by content files. Currently, it supports following scheme: http, https, ftp, file, embedded.
            "%
            = predicates.contract_from_predicate definitions.predicate.xref,
        },
    predicate = {
          buildConfig
            | doc m%"
            Build section defines configuration values for the build command.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  changesFile = predicates.isType '"String",
                  cleanupCacheHistory = predicates.isType '"Bool",
                  content = definitions.predicate.fileMappingContent,
                  debug = predicates.isType '"Bool",
                  debugOutput = predicates.isType '"String",
                  dest = predicates.isType '"String",
                  disableGitFeatures = definitions.predicate.disableGitFeatures,
                  dryRun = predicates.isType '"Bool",
                  exportRawModel = predicates.isType '"Bool",
                  exportViewModel = predicates.isType '"Bool",
                  externalReference =
                    definitions.predicate.fileMappingExternalReferences,
                  fileMetadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  fileMetadataFiles = definitions.predicate.fileMetadataFiles,
                  "force" = predicates.isType '"Bool",
                  forcePostProcess = predicates.isType '"Bool",
                  globalMetadata = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  globalMetadataFiles =
                    definitions.predicate.globalMetadataFiles,
                  intermediateFolder = predicates.isType '"String",
                  keepFileLink = predicates.isType '"Bool",
                  lruSize = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  markdownEngineName = predicates.isType '"String",
                  markdownEngineProperties = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        predicates.always
                      ],
                  maxParallelism = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  noLangKeyword = predicates.isType '"Bool",
                  overwrite = definitions.predicate.fileMappingOverwrite,
                  port = predicates.isType '"String",
                  postProcessors = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  rawModelOutputFolder = predicates.isType '"String",
                  resource = definitions.predicate.fileMappingResource,
                  serve = predicates.isType '"Bool",
                  template = definitions.predicate.template,
                  theme = definitions.predicate.theme,
                  viewModelOutputFolder = predicates.isType '"String",
                  xref = definitions.predicate.xref,
                }
                {  }
                false
                predicates.never
              ],
          disableGitFeatures
            | doc m%"
            If set to true, DocFX would not fetch Git related information for articles.
            "%
            = predicates.isType '"Bool",
          exclude
            | doc m%"
            The file glob pattern collection for files that should be excluded, with path relative to property `src`/`cwd` if value is set.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          fileMappingContent
            | doc m%"
            Contains all the files to generate documentation, including metadata `yml` files and conceptual `md` files.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.fileMappingItem
                ]
              ],
          fileMappingExternalReferences
            | doc m%"
            [Obsoleted] Contains `rpk` files that define the external references.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.fileMappingItem
                ]
              ],
          fileMappingItem = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "files" ],
                predicates.records.record
                {
                  case = predicates.isType '"Bool",
                  cwd = predicates.isType '"String",
                  dest = predicates.isType '"String",
                  dot = predicates.isType '"Bool",
                  exclude = definitions.predicate.exclude,
                  files = definitions.predicate.files,
                  name = predicates.isType '"String",
                  noEscape = predicates.isType '"Bool",
                  noExpand = predicates.isType '"Bool",
                  noGlobStar = predicates.isType '"Bool",
                  noNegate = predicates.isType '"Bool",
                  rootTocPath = predicates.isType '"String",
                  src = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          fileMappingOverwrite
            | doc m%"
            Contains all the conceptual files which contains yaml header with `uid` and is intended to override the existing metadata `yml` files.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.fileMappingItem
                ]
              ],
          fileMappingResource
            | doc m%"
            Contains all the resource files that conceptual and metadata files dependent on, e.g. image files.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.fileMappingItem
                ]
              ],
          fileMappingSrc
            | doc m%"
            Defines the source projects to have metadata generated.
            "%
            = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  definitions.predicate.fileMappingItem
                ]
              ],
          fileMetadataFiles
            | doc m%"
            Specify a list of JSON file path containing fileMetadata settings, as similar to `{"key":"value"}`.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          files
            | doc m%"
            The file glob pattern collection, with path relative to property `src`/`cwd` if value is set.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          globalMetadataFiles
            | doc m%"
            Specify a list of JSON file path containing globalMetadata settings, as similar to `{"key":"value"}`.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          metadataConfig
            | doc m%"
            Metadata section defines an array of source projects and their output folder.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                definitions.predicate.metadataConfigItem
              ],
          metadataConfigItem = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "dest", "src" ],
                predicates.records.record
                {
                  dest = predicates.isType '"String",
                  disableDefaultFilter = predicates.isType '"Bool",
                  disableGitFeatures = definitions.predicate.disableGitFeatures,
                  filter = predicates.isType '"String",
                  "force" = predicates.isType '"Bool",
                  raw = predicates.isType '"Bool",
                  shouldSkipMarkup = predicates.isType '"Bool",
                  src = definitions.predicate.fileMappingSrc,
                  useCompatibilityFileName = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          template
            | doc m%"
            The latter ones will override the former ones if the name of the file inside the template collides. If omitted, embedded default template will be used.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          theme
            | doc m%"
            The themes applied to the documentation. Theme is used to customize the styles generated by `template`. It can be a string or an array. The latter ones will override the former ones if the name of the file inside the template collides. If omitted, no theme will be applied, the default theme inside the template will be used.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          xref
            | doc m%"
            Specifies the urls of xrefmap used by content files. Currently, it supports following scheme: http, https, ftp, file, embedded.
            "%
            = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.records.record
  {
    build = definitions.predicate.buildConfig,
    metadata = definitions.predicate.metadataConfig,
  }
  {  }
  true
  predicates.always
])