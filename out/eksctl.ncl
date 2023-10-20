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
          AZSubnetMapping
            | doc m%"
            holds subnet to AZ mappings. If the key is an AZ, that also becomes the name of the subnet otherwise use the key to refer to this subnet.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.AZSubnetMapping,
          AZSubnetSpec = predicates.contract_from_predicate
              definitions.predicate.AZSubnetSpec,
          Addon
            | doc m%"
            holds the EKS addon configuration
            "%
            = predicates.contract_from_predicate definitions.predicate.Addon,
          CapacityReservation
            | doc m%"
            defines a nodegroup's Capacity Reservation targeting option
            "%
            = predicates.contract_from_predicate
              definitions.predicate.CapacityReservation,
          CapacityReservationTarget = predicates.contract_from_predicate
              definitions.predicate.CapacityReservationTarget,
          ClusterCloudWatch
            | doc m%"
            contains config parameters related to CloudWatch
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterCloudWatch,
          ClusterCloudWatchLogging
            | doc m%"
            container config parameters related to cluster logging
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterCloudWatchLogging,
          ClusterConfig
            | doc m%"
            a simple config, to be replaced with Cluster API
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterConfig,
          ClusterEndpoints
            | doc m%"
            holds cluster api server endpoint access information
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterEndpoints,
          ClusterIAM
            | doc m%"
            holds all IAM attributes of a cluster
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterIAM,
          ClusterIAMMeta
            | doc m%"
            holds information we can use to create ObjectMeta for service accounts
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterIAMMeta,
          ClusterIAMServiceAccount
            | doc m%"
            holds an IAM service account metadata and configuration
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterIAMServiceAccount,
          ClusterIAMServiceAccountStatus
            | doc m%"
            holds status of the IAM service account
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterIAMServiceAccountStatus,
          ClusterMeta
            | doc m%"
            contains general cluster information
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterMeta,
          ClusterNAT
            | doc m%"
            NAT config
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterNAT,
          ClusterSubnets
            | doc m%"
            holds private and public subnets
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterSubnets,
          ClusterVPC
            | doc m%"
            holds global subnet and all child subnets
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ClusterVPC,
          FargateProfile
            | doc m%"
            defines the settings used to schedule workload onto Fargate.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FargateProfile,
          FargateProfileSelector
            | doc m%"
            defines rules to select workload to schedule onto Fargate.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FargateProfileSelector,
          Flux
            | doc m%"
            groups all configuration options related to a Git repository used for GitOps Toolkit (Flux v2).
            "%
            = predicates.contract_from_predicate definitions.predicate.Flux,
          FluxFlags
            | doc m%"
            a map of string for passing arbitrary flags to Flux bootstrap
            "%
            = predicates.contract_from_predicate
              definitions.predicate.FluxFlags,
          GitOps
            | doc m%"
            groups all configuration options related to enabling GitOps Toolkit on a cluster and linking it to a Git repository. Note: this will replace the older Git types
            "%
            = predicates.contract_from_predicate definitions.predicate.GitOps,
          IAMIdentityMapping
            | doc m%"
            contains IAM accounts, users, roles and services that will be added to the aws-auth configmap to enable access to the cluster
            "%
            = predicates.contract_from_predicate
              definitions.predicate.IAMIdentityMapping,
          IdentityProvider
            | doc m%"
            holds an identity provider configuration. See [the example eksctl config](https://github.com/eksctl-io/eksctl/blob/main/examples/27-oidc-provider.yaml).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.IdentityProvider,
          InlineDocument
            | doc m%"
            holds any arbitrary JSON/YAML documents, such as extra config parameters or IAM policies
            "%
            = predicates.contract_from_predicate
              definitions.predicate.InlineDocument,
          InstanceSelector
            | doc m%"
            holds EC2 instance selector options
            "%
            = predicates.contract_from_predicate
              definitions.predicate.InstanceSelector,
          Karpenter
            | doc m%"
            provides configuration options
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Karpenter,
          KubernetesNetworkConfig
            | doc m%"
            contains cluster networking options
            "%
            = predicates.contract_from_predicate
              definitions.predicate.KubernetesNetworkConfig,
          LaunchTemplate = predicates.contract_from_predicate
              definitions.predicate.LaunchTemplate,
          ManagedNodeGroup
            | doc m%"
            represents an EKS-managed nodegroup TODO Validate for unmapped fields and throw an error
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ManagedNodeGroup,
          MetricsCollection
            | doc m%"
            used by the scaling config, see [cloudformation docs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-metricscollection.html)
            "%
            = predicates.contract_from_predicate
              definitions.predicate.MetricsCollection,
          NodeGroup
            | doc m%"
            holds configuration attributes that are specific to an unmanaged nodegroup
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroup,
          NodeGroupBottlerocket
            | doc m%"
            holds the configuration for Bottlerocket based NodeGroups.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupBottlerocket,
          NodeGroupIAM
            | doc m%"
            holds all IAM attributes of a NodeGroup
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupIAM,
          NodeGroupIAMAddonPolicies
            | doc m%"
            holds all IAM addon policies
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupIAMAddonPolicies,
          NodeGroupInstancesDistribution
            | doc m%"
            holds the configuration for [spot instances](/usage/spot-instances/)
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupInstancesDistribution,
          NodeGroupSGs
            | doc m%"
            controls security groups for this nodegroup
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupSGs,
          NodeGroupSSH
            | doc m%"
            holds all the ssh access configuration to a NodeGroup
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupSSH,
          NodeGroupTaint
            | doc m%"
            represents a Kubernetes taint
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupTaint,
          NodeGroupUpdateConfig
            | doc m%"
            contains the configuration for updating NodeGroups.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.NodeGroupUpdateConfig,
          OIDCIdentityProvider
            | doc m%"
            holds the spec of an OIDC provider to use for EKS authzn
            "%
            = predicates.contract_from_predicate
              definitions.predicate.OIDCIdentityProvider,
          Outpost
            | doc m%"
            holds the Outpost configuration.
            "%
            = predicates.contract_from_predicate definitions.predicate.Outpost,
          Placement
            | doc m%"
            specifies placement group information
            "%
            = predicates.contract_from_predicate
              definitions.predicate.Placement,
          PrivateCluster
            | doc m%"
            defines the configuration for a fully-private cluster.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.PrivateCluster,
          SecretsEncryption
            | doc m%"
            defines the configuration for KMS encryption provider
            "%
            = predicates.contract_from_predicate
              definitions.predicate.SecretsEncryption,
          VolumeMapping
            | doc m%"
            Additional Volume Configurations
            "%
            = predicates.contract_from_predicate
              definitions.predicate.VolumeMapping,
          WellKnownPolicies
            | doc m%"
            for attaching common IAM policies
            "%
            = predicates.contract_from_predicate
              definitions.predicate.WellKnownPolicies,
          "github.com|aws|aws-sdk-go-v2|service|eks|types.ResolveConflicts" =
            String,
          "github.com|weaveworks|eksctl|pkg|utils|ipnet.IPNet"
            | doc m%"
            an IP address in CIDR notation
            "%
            = predicates.contract_from_predicate
              definitions.predicate."github.com|weaveworks|eksctl|pkg|utils|ipnet.IPNet",
          "k8s.io|api|core|v1.TaintEffect"
            | doc m%"
            +enum
            "%
            = predicates.contract_from_predicate
              definitions.predicate."k8s.io|api|core|v1.TaintEffect",
          taintsWrapper
            | doc m%"
            handles unmarshalling both map[string]string and []NodeGroupTaint
            "%
            = predicates.contract_from_predicate
              definitions.predicate.taintsWrapper,
        },
    predicate = {
          AZSubnetMapping
            | doc m%"
            holds subnet to AZ mappings. If the key is an AZ, that also becomes the name of the subnet otherwise use the key to refer to this subnet.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.AZSubnetSpec
              ],
          AZSubnetSpec = predicates.records.record
              {
                az = predicates.isType '"String",
                cidr =
                  definitions.predicate."github.com|weaveworks|eksctl|pkg|utils|ipnet.IPNet",
                id = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          Addon
            | doc m%"
            holds the EKS addon configuration
            "%
            = predicates.allOf
              [
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  attachPolicy = definitions.predicate.InlineDocument,
                  attachPolicyARNs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  configurationValues = predicates.isType '"String",
                  name = predicates.isType '"String",
                  owners = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  permissionsBoundary = predicates.isType '"String",
                  publishers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  resolveConflicts =
                    definitions.predicate."github.com|aws|aws-sdk-go-v2|service|eks|types.ResolveConflicts",
                  serviceAccountRoleARN = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  types = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  version = predicates.isType '"String",
                  wellKnownPolicies = definitions.predicate.WellKnownPolicies,
                }
                {  }
                false
                predicates.never
              ],
          CapacityReservation
            | doc m%"
            defines a nodegroup's Capacity Reservation targeting option
            "%
            = predicates.records.record
              {
                capacityReservationPreference = predicates.isType '"String",
                capacityReservationTarget =
                  definitions.predicate.CapacityReservationTarget,
              }
              {  }
              false
              predicates.never,
          CapacityReservationTarget = predicates.records.record
              {
                capacityReservationID = predicates.isType '"String",
                capacityReservationResourceGroupARN = predicates.isType
                    '"String",
              }
              {  }
              false
              predicates.never,
          ClusterCloudWatch
            | doc m%"
            contains config parameters related to CloudWatch
            "%
            = predicates.records.record
              {
                clusterLogging = definitions.predicate.ClusterCloudWatchLogging,
              }
              {  }
              false
              predicates.never,
          ClusterCloudWatchLogging
            | doc m%"
            container config parameters related to cluster logging
            "%
            = predicates.records.record
              {
                enableTypes = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "api",
                          "audit",
                          "authenticator",
                          "controllerManager",
                          "scheduler",
                          "all",
                          "*"
                        ]
                      ])
                    ],
                logRetentionInDays = predicates.isType 'Integer,
              }
              {  }
              false
              predicates.never,
          ClusterConfig
            | doc m%"
            a simple config, to be replaced with Cluster API
            "%
            = predicates.allOf
              [
                predicates.records.required
                [ "apiVersion", "kind", "metadata" ],
                predicates.records.record
                {
                  addons = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Addon
                      ],
                  apiVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "eksctl.io/v1alpha5" ]
                      ],
                  availabilityZones = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  cloudWatch = definitions.predicate.ClusterCloudWatch,
                  fargateProfiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FargateProfile
                      ],
                  gitops = definitions.predicate.GitOps,
                  iam = definitions.predicate.ClusterIAM,
                  iamIdentityMappings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.IAMIdentityMapping
                      ],
                  identityProviders = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.IdentityProvider
                      ],
                  karpenter = definitions.predicate.Karpenter,
                  kind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ClusterConfig" ]
                      ],
                  kubernetesNetworkConfig =
                    definitions.predicate.KubernetesNetworkConfig,
                  localZones = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  managedNodeGroups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.ManagedNodeGroup
                      ],
                  metadata = definitions.predicate.ClusterMeta,
                  nodeGroups = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.NodeGroup
                      ],
                  outpost = definitions.predicate.Outpost,
                  privateCluster = definitions.predicate.PrivateCluster,
                  secretsEncryption = definitions.predicate.SecretsEncryption,
                  vpc = definitions.predicate.ClusterVPC,
                }
                {  }
                false
                predicates.never
              ],
          ClusterEndpoints
            | doc m%"
            holds cluster api server endpoint access information
            "%
            = predicates.records.record
              {
                privateAccess = predicates.isType '"Bool",
                publicAccess = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never,
          ClusterIAM
            | doc m%"
            holds all IAM attributes of a cluster
            "%
            = predicates.records.record
              {
                fargatePodExecutionRoleARN = predicates.isType '"String",
                fargatePodExecutionRolePermissionsBoundary = predicates.isType
                    '"String",
                serviceAccounts = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.ClusterIAMServiceAccount
                    ],
                serviceRoleARN = predicates.isType '"String",
                serviceRolePermissionsBoundary = predicates.isType '"String",
                vpcResourceControllerPolicy = predicates.isType '"Bool",
                withOIDC = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never,
          ClusterIAMMeta
            | doc m%"
            holds information we can use to create ObjectMeta for service accounts
            "%
            = predicates.records.record
              {
                annotations = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ],
                labels = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ],
                name = predicates.isType '"String",
                namespace = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          ClusterIAMServiceAccount
            | doc m%"
            holds an IAM service account metadata and configuration
            "%
            = predicates.records.record
              {
                attachPolicy = definitions.predicate.InlineDocument,
                attachPolicyARNs = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                attachRoleARN = predicates.isType '"String",
                metadata = definitions.predicate.ClusterIAMMeta,
                permissionsBoundary = predicates.isType '"String",
                roleName = predicates.isType '"String",
                roleOnly = predicates.isType '"Bool",
                status = definitions.predicate.ClusterIAMServiceAccountStatus,
                tags = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      (predicates.isType '"String")
                    ],
                wellKnownPolicies = definitions.predicate.WellKnownPolicies,
              }
              {  }
              false
              predicates.never,
          ClusterIAMServiceAccountStatus
            | doc m%"
            holds status of the IAM service account
            "%
            = predicates.records.record
              { roleARN = predicates.isType '"String", }
              {  }
              false
              predicates.never,
          ClusterMeta
            | doc m%"
            contains general cluster information
            "%
            = predicates.allOf
              [
                predicates.records.required [ "name", "region" ],
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  name = predicates.isType '"String",
                  region = predicates.isType '"String",
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  version = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "1.23", "1.24", "1.25", "1.26", "1.27", "1.28" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          ClusterNAT
            | doc m%"
            NAT config
            "%
            = predicates.records.record
              {
                gateway = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "HighlyAvailable", "Single", "Disable" ]
                    ],
              }
              {  }
              false
              predicates.never,
          ClusterSubnets
            | doc m%"
            holds private and public subnets
            "%
            = predicates.records.record
              {
                private = definitions.predicate.AZSubnetMapping,
                public = definitions.predicate.AZSubnetMapping,
              }
              {  }
              false
              predicates.never,
          ClusterVPC
            | doc m%"
            holds global subnet and all child subnets
            "%
            = predicates.records.record
              {
                autoAllocateIPv6 = predicates.isType '"Bool",
                cidr =
                  definitions.predicate."github.com|weaveworks|eksctl|pkg|utils|ipnet.IPNet",
                clusterEndpoints = definitions.predicate.ClusterEndpoints,
                extraCIDRs = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                extraIPv6CIDRs = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                hostnameType = predicates.isType '"String",
                id = predicates.isType '"String",
                ipv6Cidr = predicates.isType '"String",
                ipv6Pool = predicates.isType '"String",
                manageSharedNodeSecurityGroupRules = predicates.isType '"Bool",
                nat = definitions.predicate.ClusterNAT,
                publicAccessCIDRs = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                securityGroup = predicates.isType '"String",
                sharedNodeSecurityGroup = predicates.isType '"String",
                subnets = definitions.predicate.ClusterSubnets,
              }
              {  }
              false
              predicates.never,
          FargateProfile
            | doc m%"
            defines the settings used to schedule workload onto Fargate.
            "%
            = predicates.allOf
              [
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  podExecutionRoleARN = predicates.isType '"String",
                  selectors = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FargateProfileSelector
                      ],
                  status = predicates.isType '"String",
                  subnets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FargateProfileSelector
            | doc m%"
            defines rules to select workload to schedule onto Fargate.
            "%
            = predicates.allOf
              [
                predicates.records.required [ "namespace" ],
                predicates.records.record
                {
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  namespace = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Flux
            | doc m%"
            groups all configuration options related to a Git repository used for GitOps Toolkit (Flux v2).
            "%
            = predicates.records.record
              {
                flags = definitions.predicate.FluxFlags,
                gitProvider = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          FluxFlags
            | doc m%"
            a map of string for passing arbitrary flags to Flux bootstrap
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          GitOps
            | doc m%"
            groups all configuration options related to enabling GitOps Toolkit on a cluster and linking it to a Git repository. Note: this will replace the older Git types
            "%
            = predicates.records.record { flux = definitions.predicate.Flux, }
              {  }
              false
              predicates.never,
          IAMIdentityMapping
            | doc m%"
            contains IAM accounts, users, roles and services that will be added to the aws-auth configmap to enable access to the cluster
            "%
            = predicates.records.record
              {
                account = predicates.isType '"String",
                arn = predicates.isType '"String",
                groups = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                namespace = predicates.isType '"String",
                noDuplicateARNs = predicates.isType '"Bool",
                serviceName = predicates.isType '"String",
                username = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          IdentityProvider
            | doc m%"
            holds an identity provider configuration. See [the example eksctl config](https://github.com/eksctl-io/eksctl/blob/main/examples/27-oidc-provider.yaml).
            "%
            = predicates.allOf
              [
                predicates.oneOf [ definitions.predicate.OIDCIdentityProvider ],
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "oidc" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          InlineDocument
            | doc m%"
            holds any arbitrary JSON/YAML documents, such as extra config parameters or IAM policies
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true predicates.always
              ],
          InstanceSelector
            | doc m%"
            holds EC2 instance selector options
            "%
            = predicates.records.record
              {
                cpuArchitecture = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "x86_64", "amd64", "arm64" ]
                    ],
                gpus = predicates.isType 'Integer,
                memory = predicates.isType '"String",
                vCPUs = predicates.isType 'Integer,
              }
              {  }
              false
              predicates.never,
          Karpenter
            | doc m%"
            provides configuration options
            "%
            = predicates.allOf
              [
                predicates.records.required [ "version" ],
                predicates.records.record
                {
                  createServiceAccount = predicates.isType '"Bool",
                  defaultInstanceProfile = predicates.isType '"String",
                  version = predicates.isType '"String",
                  withSpotInterruptionQueue = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          KubernetesNetworkConfig
            | doc m%"
            contains cluster networking options
            "%
            = predicates.records.record
              {
                ipFamily = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "IPv4", "IPv6" ]
                    ],
                serviceIPv4CIDR = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          LaunchTemplate = predicates.allOf
              [
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          ManagedNodeGroup
            | doc m%"
            represents an EKS-managed nodegroup TODO Validate for unmapped fields and throw an error
            "%
            = predicates.allOf
              [
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  additionalVolumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.VolumeMapping
                      ],
                  ami = predicates.isType '"String",
                  amiFamily = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "AmazonLinux2",
                          "Ubuntu2004",
                          "Ubuntu1804",
                          "Bottlerocket",
                          "WindowsServer2019CoreContainer",
                          "WindowsServer2019FullContainer",
                          "WindowsServer2022CoreContainer",
                          "WindowsServer2022FullContainer"
                        ]
                      ],
                  asgSuspendProcesses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  availabilityZones = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  bottlerocket = definitions.predicate.NodeGroupBottlerocket,
                  capacityReservation =
                    definitions.predicate.CapacityReservation,
                  desiredCapacity = predicates.isType 'Integer,
                  disableIMDSv1 = predicates.isType '"Bool",
                  disablePodIMDS = predicates.isType '"Bool",
                  ebsOptimized = predicates.isType '"Bool",
                  efaEnabled = predicates.isType '"Bool",
                  enableDetailedMonitoring = predicates.isType '"Bool",
                  iam = definitions.predicate.NodeGroupIAM,
                  instanceName = predicates.isType '"String",
                  instancePrefix = predicates.isType '"String",
                  instanceSelector = definitions.predicate.InstanceSelector,
                  instanceType = predicates.isType '"String",
                  instanceTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  launchTemplate = definitions.predicate.LaunchTemplate,
                  maxPodsPerNode = predicates.isType 'Integer,
                  maxSize = predicates.isType 'Integer,
                  minSize = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  outpostARN = predicates.isType '"String",
                  overrideBootstrapCommand = predicates.isType '"String",
                  placement = definitions.predicate.Placement,
                  preBootstrapCommands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  privateNetworking = predicates.isType '"Bool",
                  propagateASGTags = predicates.isType '"Bool",
                  releaseVersion = predicates.isType '"String",
                  securityGroups = definitions.predicate.NodeGroupSGs,
                  spot = predicates.isType '"Bool",
                  ssh = definitions.predicate.NodeGroupSSH,
                  subnets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  taints = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.NodeGroupTaint
                      ],
                  updateConfig = definitions.predicate.NodeGroupUpdateConfig,
                  volumeEncrypted = predicates.isType '"Bool",
                  volumeIOPS = predicates.isType 'Integer,
                  volumeKmsKeyID = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                  volumeSize = predicates.isType 'Integer,
                  volumeThroughput = predicates.isType 'Integer,
                  volumeType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "gp2", "gp3", "io1", "sc1", "st1" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MetricsCollection
            | doc m%"
            used by the scaling config, see [cloudformation docs](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-metricscollection.html)
            "%
            = predicates.allOf
              [
                predicates.records.required [ "granularity" ],
                predicates.records.record
                {
                  granularity = predicates.isType '"String",
                  metrics = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          NodeGroup
            | doc m%"
            holds configuration attributes that are specific to an unmanaged nodegroup
            "%
            = predicates.allOf
              [
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  additionalVolumes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.VolumeMapping
                      ],
                  ami = predicates.isType '"String",
                  amiFamily = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [
                          "AmazonLinux2",
                          "Ubuntu2004",
                          "Ubuntu1804",
                          "Bottlerocket",
                          "WindowsServer2019CoreContainer",
                          "WindowsServer2019FullContainer",
                          "WindowsServer2022CoreContainer",
                          "WindowsServer2022FullContainer"
                        ]
                      ],
                  asgMetricsCollection = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.MetricsCollection
                      ],
                  asgSuspendProcesses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  availabilityZones = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  bottlerocket = definitions.predicate.NodeGroupBottlerocket,
                  capacityReservation =
                    definitions.predicate.CapacityReservation,
                  classicLoadBalancerNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  clusterDNS = predicates.isType '"String",
                  containerRuntime = predicates.isType '"String",
                  cpuCredits = predicates.isType '"String",
                  desiredCapacity = predicates.isType 'Integer,
                  disableIMDSv1 = predicates.isType '"Bool",
                  disablePodIMDS = predicates.isType '"Bool",
                  ebsOptimized = predicates.isType '"Bool",
                  efaEnabled = predicates.isType '"Bool",
                  enableDetailedMonitoring = predicates.isType '"Bool",
                  iam = definitions.predicate.NodeGroupIAM,
                  instanceName = predicates.isType '"String",
                  instancePrefix = predicates.isType '"String",
                  instanceSelector = definitions.predicate.InstanceSelector,
                  instanceType = predicates.isType '"String",
                  instancesDistribution =
                    definitions.predicate.NodeGroupInstancesDistribution,
                  kubeletExtraConfig = definitions.predicate.InlineDocument,
                  labels = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  localZones = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  maxInstanceLifetime = predicates.isType 'Integer,
                  maxPodsPerNode = predicates.isType 'Integer,
                  maxSize = predicates.isType 'Integer,
                  minSize = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  outpostARN = predicates.isType '"String",
                  overrideBootstrapCommand = predicates.isType '"String",
                  placement = definitions.predicate.Placement,
                  preBootstrapCommands = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  privateNetworking = predicates.isType '"Bool",
                  propagateASGTags = predicates.isType '"Bool",
                  securityGroups = definitions.predicate.NodeGroupSGs,
                  ssh = definitions.predicate.NodeGroupSSH,
                  subnets = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  taints = definitions.predicate.taintsWrapper,
                  targetGroupARNs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  updateConfig = definitions.predicate.NodeGroupUpdateConfig,
                  volumeEncrypted = predicates.isType '"Bool",
                  volumeIOPS = predicates.isType 'Integer,
                  volumeKmsKeyID = predicates.isType '"String",
                  volumeName = predicates.isType '"String",
                  volumeSize = predicates.isType 'Integer,
                  volumeThroughput = predicates.isType 'Integer,
                  volumeType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "gp2", "gp3", "io1", "sc1", "st1" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          NodeGroupBottlerocket
            | doc m%"
            holds the configuration for Bottlerocket based NodeGroups.
            "%
            = predicates.records.record
              {
                enableAdminContainer = predicates.isType '"Bool",
                settings = definitions.predicate.InlineDocument,
              }
              {  }
              false
              predicates.never,
          NodeGroupIAM
            | doc m%"
            holds all IAM attributes of a NodeGroup
            "%
            = predicates.records.record
              {
                attachPolicy = definitions.predicate.InlineDocument,
                attachPolicyARNs = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                instanceProfileARN = predicates.isType '"String",
                instanceRoleARN = predicates.isType '"String",
                instanceRoleName = predicates.isType '"String",
                instanceRolePermissionsBoundary = predicates.isType '"String",
                withAddonPolicies =
                  definitions.predicate.NodeGroupIAMAddonPolicies,
              }
              {  }
              false
              predicates.never,
          NodeGroupIAMAddonPolicies
            | doc m%"
            holds all IAM addon policies
            "%
            = predicates.records.record
              {
                albIngress = predicates.isType '"Bool",
                appMesh = predicates.isType '"Bool",
                appMeshPreview = predicates.isType '"Bool",
                autoScaler = predicates.isType '"Bool",
                awsLoadBalancerController = predicates.isType '"Bool",
                certManager = predicates.isType '"Bool",
                cloudWatch = predicates.isType '"Bool",
                ebs = predicates.isType '"Bool",
                efs = predicates.isType '"Bool",
                externalDNS = predicates.isType '"Bool",
                fsx = predicates.isType '"Bool",
                imageBuilder = predicates.isType '"Bool",
                xRay = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never,
          NodeGroupInstancesDistribution
            | doc m%"
            holds the configuration for [spot instances](/usage/spot-instances/)
            "%
            = predicates.allOf
              [
                predicates.records.required [ "instanceTypes" ],
                predicates.records.record
                {
                  capacityRebalance = predicates.isType '"Bool",
                  instanceTypes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  maxPrice = predicates.isType '"Number",
                  onDemandBaseCapacity = predicates.isType 'Integer,
                  onDemandPercentageAboveBaseCapacity = predicates.isType
                      'Integer,
                  spotAllocationStrategy = predicates.isType '"String",
                  spotInstancePools = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          NodeGroupSGs
            | doc m%"
            controls security groups for this nodegroup
            "%
            = predicates.records.record
              {
                attachIDs = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                withLocal = predicates.isType '"Bool",
                withShared = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never,
          NodeGroupSSH
            | doc m%"
            holds all the ssh access configuration to a NodeGroup
            "%
            = predicates.records.record
              {
                allow = predicates.isType '"Bool",
                enableSsm = predicates.isType '"Bool",
                publicKey = predicates.isType '"String",
                publicKeyName = predicates.isType '"String",
                publicKeyPath = predicates.isType '"String",
                sourceSecurityGroupIds = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
              }
              {  }
              false
              predicates.never,
          NodeGroupTaint
            | doc m%"
            represents a Kubernetes taint
            "%
            = predicates.records.record
              {
                effect = definitions.predicate."k8s.io|api|core|v1.TaintEffect",
                key = predicates.isType '"String",
                value = predicates.isType '"String",
              }
              {  }
              false
              predicates.never,
          NodeGroupUpdateConfig
            | doc m%"
            contains the configuration for updating NodeGroups.
            "%
            = predicates.records.record
              {
                maxUnavailable = predicates.isType 'Integer,
                maxUnavailablePercentage = predicates.isType 'Integer,
              }
              {  }
              false
              predicates.never,
          OIDCIdentityProvider
            | doc m%"
            holds the spec of an OIDC provider to use for EKS authzn
            "%
            = predicates.allOf
              [
                predicates.records.required [ "clientID", "issuerURL", "name" ],
                predicates.records.record
                {
                  clientID = predicates.isType '"String",
                  groupsClaim = predicates.isType '"String",
                  groupsPrefix = predicates.isType '"String",
                  issuerURL = predicates.isType '"String",
                  name = predicates.isType '"String",
                  requiredClaims = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  tags = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  usernameClaim = predicates.isType '"String",
                  usernamePrefix = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Outpost
            | doc m%"
            holds the Outpost configuration.
            "%
            = predicates.records.record
              {
                controlPlaneInstanceType = predicates.isType '"String",
                controlPlaneOutpostARN = predicates.isType '"String",
                controlPlanePlacement = definitions.predicate.Placement,
              }
              {  }
              false
              predicates.never,
          Placement
            | doc m%"
            specifies placement group information
            "%
            = predicates.records.record
              { groupName = predicates.isType '"String", }
              {  }
              false
              predicates.never,
          PrivateCluster
            | doc m%"
            defines the configuration for a fully-private cluster.
            "%
            = predicates.records.record
              {
                additionalEndpointServices = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                enabled = predicates.isType '"Bool",
                skipEndpointCreation = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never,
          SecretsEncryption
            | doc m%"
            defines the configuration for KMS encryption provider
            "%
            = predicates.allOf
              [
                predicates.records.required [ "keyARN" ],
                predicates.records.record
                { keyARN = predicates.isType '"String", }
                {  }
                false
                predicates.never
              ],
          VolumeMapping
            | doc m%"
            Additional Volume Configurations
            "%
            = predicates.records.record
              {
                snapshotID = predicates.isType '"String",
                volumeEncrypted = predicates.isType '"Bool",
                volumeIOPS = predicates.isType 'Integer,
                volumeKmsKeyID = predicates.isType '"String",
                volumeName = predicates.isType '"String",
                volumeSize = predicates.isType 'Integer,
                volumeThroughput = predicates.isType 'Integer,
                volumeType = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "gp2", "gp3", "io1", "sc1", "st1" ]
                    ],
              }
              {  }
              false
              predicates.never,
          WellKnownPolicies
            | doc m%"
            for attaching common IAM policies
            "%
            = predicates.records.record
              {
                autoScaler = predicates.isType '"Bool",
                awsLoadBalancerController = predicates.isType '"Bool",
                certManager = predicates.isType '"Bool",
                ebsCSIController = predicates.isType '"Bool",
                efsCSIController = predicates.isType '"Bool",
                externalDNS = predicates.isType '"Bool",
                imageBuilder = predicates.isType '"Bool",
              }
              {  }
              false
              predicates.never,
          "github.com|aws|aws-sdk-go-v2|service|eks|types.ResolveConflicts" =
            predicates.isType '"String",
          "github.com|weaveworks|eksctl|pkg|utils|ipnet.IPNet"
            | doc m%"
            an IP address in CIDR notation
            "%
            = predicates.isType '"String",
          "k8s.io|api|core|v1.TaintEffect"
            | doc m%"
            +enum
            "%
            = predicates.isType '"String",
          taintsWrapper
            | doc m%"
            handles unmarshalling both map[string]string and []NodeGroupTaint
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf definitions.predicate.NodeGroupTaint
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[ predicates.isType 'Record, definitions.predicate.ClusterConfig ])