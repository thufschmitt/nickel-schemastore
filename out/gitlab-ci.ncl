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
          "!reference" = predicates.contract_from_predicate
              definitions.predicate."!reference",
          after_script = predicates.contract_from_predicate
              definitions.predicate.after_script,
          allow_failure = predicates.contract_from_predicate
              definitions.predicate.allow_failure,
          artifacts = predicates.contract_from_predicate
              definitions.predicate.artifacts,
          before_script = predicates.contract_from_predicate
              definitions.predicate.before_script,
          cache = predicates.contract_from_predicate
              definitions.predicate.cache,
          changes = predicates.contract_from_predicate
              definitions.predicate.changes,
          exists = predicates.contract_from_predicate
              definitions.predicate.exists,
          filter = predicates.contract_from_predicate
              definitions.predicate.filter,
          filter_refs
            | doc m%"
            Filter job by different keywords that determine origin or state, or by supplying string/regex to check against branch/tag names.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.filter_refs,
          globalVariables = predicates.contract_from_predicate
              definitions.predicate.globalVariables,
          hooks = predicates.contract_from_predicate
              definitions.predicate.hooks,
          id_tokens = predicates.contract_from_predicate
              definitions.predicate.id_tokens,
          "if" = predicates.contract_from_predicate definitions.predicate."if",
          image = predicates.contract_from_predicate
              definitions.predicate.image,
          includeRules = predicates.contract_from_predicate
              definitions.predicate.includeRules,
          include_item = predicates.contract_from_predicate
              definitions.predicate.include_item,
          inputs = predicates.contract_from_predicate
              definitions.predicate.inputs,
          interruptible = predicates.contract_from_predicate
              definitions.predicate.interruptible,
          job = predicates.contract_from_predicate definitions.predicate.job,
          jobVariables = predicates.contract_from_predicate
              definitions.predicate.jobVariables,
          job_template = predicates.contract_from_predicate
              definitions.predicate.job_template,
          optional_script = predicates.contract_from_predicate
              definitions.predicate.optional_script,
          parallel
            | doc m%"
            Splits up a single job into multiple that run in parallel. Provides `CI_NODE_INDEX` and `CI_NODE_TOTAL` environment variables to the jobs.
            "%
            = predicates.contract_from_predicate definitions.predicate.parallel,
          parallel_matrix
            | doc m%"
            Use the `needs:parallel:matrix` keyword to specify parallelized jobs needed to be completed for the job to run. [Learn More](https://docs.gitlab.com/ee/ci/yaml/#needsparallelmatrix)
            "%
            = predicates.contract_from_predicate
              definitions.predicate.parallel_matrix,
          retry = predicates.contract_from_predicate
              definitions.predicate.retry,
          retry_errors = predicates.contract_from_predicate
              definitions.predicate.retry_errors,
          retry_max
            | doc m%"
            The number of times the job will be retried if it fails. Defaults to 0 and can max be retried 2 times (3 times total).
            "%
            = predicates.contract_from_predicate
              definitions.predicate.retry_max,
          rules = predicates.contract_from_predicate
              definitions.predicate.rules,
          rulesNeeds = predicates.contract_from_predicate
              definitions.predicate.rulesNeeds,
          rulesVariables = predicates.contract_from_predicate
              definitions.predicate.rulesVariables,
          script = predicates.contract_from_predicate
              definitions.predicate.script,
          secrets = predicates.contract_from_predicate
              definitions.predicate.secrets,
          services = predicates.contract_from_predicate
              definitions.predicate.services,
          start_in = predicates.contract_from_predicate
              definitions.predicate.start_in,
          string_file_list = predicates.contract_from_predicate
              definitions.predicate.string_file_list,
          tags = predicates.contract_from_predicate definitions.predicate.tags,
          timeout = predicates.contract_from_predicate
              definitions.predicate.timeout,
          when = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'delayed,
                  'manual,
                  'never,
                  'always,
                  'on_failure,
                  'on_success
                |]
              ],
          workflowName = predicates.contract_from_predicate
              definitions.predicate.workflowName,
        },
    predicate = {
          "!reference" = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ])
              ],
          after_script = definitions.predicate.optional_script,
          allow_failure = predicates.oneOf
              [
                predicates.isType '"Bool",
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "exit_codes" ],
                  predicates.records.record
                  { exit_codes = predicates.isType 'Integer, }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "exit_codes" ],
                  predicates.records.record
                  {
                    exit_codes = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType 'Integer),
                          predicates.arrays.minItems 1,
                          predicates.arrays.uniqueItems
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          artifacts = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  exclude = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1
                      ],
                  expire_in = predicates.isType '"String",
                  expose_as = predicates.isType '"String",
                  name = predicates.isType '"String",
                  paths = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1
                      ],
                  reports = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          browser_performance = predicates.isType '"String",
                          codequality = definitions.predicate.string_file_list,
                          container_scanning =
                            definitions.predicate.string_file_list,
                          coverage_report = predicates.allOf
                              [
                                predicates.anyOf
                                [
                                  predicates.isType 'Record,
                                  predicates.isType 'Null
                                ],
                                predicates.records.record
                                {
                                  coverage_format = predicates.enum
                                      [ "cobertura" ],
                                  path = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.strings.minLength 1
                                      ],
                                }
                                {  }
                                true
                                predicates.always
                              ],
                          cyclonedx = definitions.predicate.string_file_list,
                          dast = definitions.predicate.string_file_list,
                          dependency_scanning =
                            definitions.predicate.string_file_list,
                          dotenv = definitions.predicate.string_file_list,
                          junit = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String"),
                                  predicates.arrays.minItems 1
                                ]
                              ],
                          license_management =
                            definitions.predicate.string_file_list,
                          license_scanning =
                            definitions.predicate.string_file_list,
                          load_performance =
                            definitions.predicate.string_file_list,
                          lsif = definitions.predicate.string_file_list,
                          metrics = definitions.predicate.string_file_list,
                          requirements = definitions.predicate.string_file_list,
                          sast = definitions.predicate.string_file_list,
                          secret_detection =
                            definitions.predicate.string_file_list,
                          terraform = definitions.predicate.string_file_list,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  untracked = predicates.isType '"Bool",
                  when = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "on_success", "on_failure", "always" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          before_script = definitions.predicate.optional_script,
          cache = predicates.records.record
              {
                fallback_keys = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.maxItems 5
                    ],
                key = predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^(?!.*\\/)^(.*[^.]+.*)$"
                      ],
                      predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          files = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.maxItems 2,
                                predicates.arrays.minItems 1
                              ],
                          prefix = predicates.isType '"String",
                        }
                        {  }
                        true
                        predicates.always
                      ]
                    ],
                paths = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                policy = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "pull-push|pull|push|\\$\\w{1,255}"
                    ],
                unprotect = predicates.isType '"Bool",
                untracked = predicates.isType '"Bool",
                when = predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "on_success", "on_failure", "always" ]
                    ],
              }
              {  }
              true
              predicates.always,
          changes = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "paths" ],
                  predicates.records.record
                  {
                    compare_to = predicates.isType '"String",
                    paths = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          exists = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          filter = predicates.oneOf
              [
                predicates.isType 'Null,
                definitions.predicate.filter_refs,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    changes = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                    kubernetes = predicates.enum [ "active" ],
                    refs = definitions.predicate.filter_refs,
                    variables = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          filter_refs
            | doc m%"
            Filter job by different keywords that determine origin or state, or by supplying string/regex to check against branch/tag names.
            "%
            = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.oneOf
                  [
                    predicates.enum [ "branches" ],
                    predicates.enum [ "tags" ],
                    predicates.enum [ "api" ],
                    predicates.enum [ "external" ],
                    predicates.enum [ "pipelines" ],
                    predicates.enum [ "pushes" ],
                    predicates.enum [ "schedules" ],
                    predicates.enum [ "triggers" ],
                    predicates.enum [ "web" ]
                  ],
                  predicates.isType '"String"
                ])
              ],
          globalVariables = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  ".*" = predicates.oneOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            description = predicates.isType '"String",
                            expand = predicates.isType '"Bool",
                            options = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String"),
                                  predicates.arrays.minItems 1,
                                  predicates.arrays.uniqueItems
                                ],
                            value = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  additionalProperties = predicates.never,
                }
                true
                predicates.always
              ],
          hooks = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  pre_get_sources_script =
                    definitions.predicate.optional_script,
                }
                {  }
                false
                predicates.never
              ],
          id_tokens = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  ".*" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "aud" ],
                        predicates.records.record
                        {
                          aud = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String"),
                                  predicates.arrays.minItems 1,
                                  predicates.arrays.uniqueItems
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                true
                predicates.always
              ],
          "if" = predicates.isType '"String",
          image = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    entrypoint = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.minItems 1
                        ],
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    pull_policy = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [ "always", "never", "if-not-present" ]
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [ "always", "never", "if-not-present" ]
                            ]),
                            predicates.arrays.minItems 1,
                            predicates.arrays.uniqueItems
                          ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.strings.minLength 1,
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          includeRules = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      changes = definitions.predicate.changes,
                      exists = definitions.predicate.exists,
                      "if" = definitions.predicate."if",
                      when = predicates.oneOf
                          [
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "never", "always" ]
                            ],
                            predicates.isType 'Null
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.strings.minLength 1,
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]
                ])
              ],
          include_item = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.strings.pattern
                  "^(https?://|/?.?-?(?!\\w+://)\\w).+\\.ya?ml$"
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "local" ],
                  predicates.records.record
                  {
                    inputs = definitions.predicate.inputs,
                    local = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\.ya?ml$"
                        ],
                    rules = definitions.predicate.includeRules,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "file", "project" ],
                  predicates.records.record
                  {
                    file = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.pattern "\\.ya?ml$"
                          ],
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.strings.pattern "\\.ya?ml$"
                            ])
                          ]
                        ],
                    inputs = definitions.predicate.inputs,
                    project = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "(?:\\S/\\S|\\$\\S+)"
                        ],
                    ref = predicates.isType '"String",
                    rules = definitions.predicate.includeRules,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "template" ],
                  predicates.records.record
                  {
                    inputs = definitions.predicate.inputs,
                    rules = definitions.predicate.includeRules,
                    template = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "\\.ya?ml$"
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "component" ],
                  predicates.records.record
                  {
                    component = predicates.isType '"String",
                    inputs = definitions.predicate.inputs,
                    rules = definitions.predicate.includeRules,
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "remote" ],
                  predicates.records.record
                  {
                    inputs = definitions.predicate.inputs,
                    remote = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^https?://.+\\.ya?ml$"
                        ],
                    rules = definitions.predicate.includeRules,
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          inputs = predicates.isType 'Record,
          interruptible = predicates.isType '"Bool",
          job = definitions.predicate.job_template,
          jobVariables = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  ".*" = predicates.oneOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType '"Number"
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            expand = predicates.isType '"Bool",
                            value = predicates.isType '"String",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  additionalProperties = predicates.never,
                }
                true
                predicates.always
              ],
          job_template = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "start_in", "when" ],
                    predicates.records.record
                    { when = predicates.enum [ "delayed" ], }
                    {  }
                    true
                    predicates.always
                  ],
                  predicates.records.record
                  { when = predicates.not (predicates.enum [ "delayed" ]), }
                  {  }
                  true
                  predicates.always
                ],
                predicates.records.record
                {
                  after_script = definitions.predicate.after_script,
                  allow_failure = definitions.predicate.allow_failure,
                  artifacts = definitions.predicate.artifacts,
                  before_script = definitions.predicate.before_script,
                  cache = definitions.predicate.cache,
                  coverage = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^/.+/$"
                      ],
                  dependencies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  environment = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "name" ],
                          predicates.records.record
                          {
                            action = predicates.enum
                                [
                                  "start",
                                  "prepare",
                                  "stop",
                                  "verify",
                                  "access"
                                ],
                            auto_stop_in = predicates.isType '"String",
                            deployment_tier = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum
                                  [
                                    "production",
                                    "staging",
                                    "testing",
                                    "development",
                                    "other"
                                  ]
                                ],
                            kubernetes = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    namespace = predicates.allOf
                                        [
                                          predicates.isType '"String",
                                          predicates.strings.minLength 1
                                        ],
                                  }
                                  {  }
                                  true
                                  predicates.always
                                ],
                            name = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.minLength 1
                                ],
                            on_stop = predicates.isType '"String",
                            url = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "^(https?://.+|\\$[A-Za-z]+)"
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  except = definitions.predicate.filter,
                  extends = predicates.oneOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.minItems 1
                        ]
                      ],
                  hooks = definitions.predicate.hooks,
                  id_tokens = definitions.predicate.id_tokens,
                  image = definitions.predicate.image,
                  inherit = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          "default" = predicates.oneOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.enum
                                    [
                                      "after_script",
                                      "artifacts",
                                      "before_script",
                                      "cache",
                                      "image",
                                      "interruptible",
                                      "retry",
                                      "services",
                                      "tags",
                                      "timeout"
                                    ]
                                  ])
                                ]
                              ],
                          variables = predicates.oneOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  interruptible = definitions.predicate.interruptible,
                  needs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.oneOf
                        [
                          predicates.isType '"String",
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "job" ],
                            predicates.records.record
                            {
                              artifacts = predicates.isType '"Bool",
                              job = predicates.isType '"String",
                              "optional" = predicates.isType '"Bool",
                              parallel = definitions.predicate.parallel_matrix,
                            }
                            {  }
                            false
                            predicates.never
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "job", "pipeline" ],
                            predicates.records.record
                            {
                              artifacts = predicates.isType '"Bool",
                              job = predicates.isType '"String",
                              parallel = definitions.predicate.parallel_matrix,
                              pipeline = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ],
                          predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required
                            [ "job", "project", "ref" ],
                            predicates.records.record
                            {
                              artifacts = predicates.isType '"Bool",
                              job = predicates.isType '"String",
                              parallel = definitions.predicate.parallel_matrix,
                              project = predicates.isType '"String",
                              ref = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ]
                        ])
                      ],
                  only = definitions.predicate.filter,
                  pages_path_prefix = predicates.isType '"String",
                  parallel = definitions.predicate.parallel,
                  publish = predicates.isType '"String",
                  release = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "description", "tag_name" ],
                        predicates.records.record
                        {
                          assets = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "links" ],
                                predicates.records.record
                                {
                                  links = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.required
                                          [ "name", "url" ],
                                          predicates.records.record
                                          {
                                            filepath = predicates.isType
                                                '"String",
                                            link_type = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.enum
                                                  [
                                                    "runbook",
                                                    "package",
                                                    "image",
                                                    "other"
                                                  ]
                                                ],
                                            name = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.minLength 1
                                                ],
                                            url = predicates.allOf
                                                [
                                                  predicates.isType '"String",
                                                  predicates.strings.minLength 1
                                                ],
                                          }
                                          {  }
                                          false
                                          predicates.never
                                        ]),
                                        predicates.arrays.minItems 1
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          description = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                          milestones = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          name = predicates.isType '"String",
                          ref = predicates.isType '"String",
                          released_at = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.pattern
                                "^(?:[1-9]\\d{3}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1\\d|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[1-9]\\d(?:0[48]|[2468][048]|[13579][26])|(?:[2468][048]|[13579][26])00)-02-29)T(?:[01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d(?:Z|[+-][01]\\d:[0-5]\\d)$"
                              ],
                          tag_message = predicates.isType '"String",
                          tag_name = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.strings.minLength 1
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  resource_group = predicates.isType '"String",
                  retry = definitions.predicate.retry,
                  rules = definitions.predicate.rules,
                  script = definitions.predicate.script,
                  secrets = definitions.predicate.secrets,
                  services = definitions.predicate.services,
                  stage = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.strings.minLength 1,
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  start_in = definitions.predicate.start_in,
                  tags = definitions.predicate.tags,
                  timeout = definitions.predicate.timeout,
                  trigger = predicates.oneOf
                      [
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "project" ],
                          predicates.records.record
                          {
                            branch = predicates.isType '"String",
                            forward = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    pipeline_variables = predicates.isType
                                        '"Bool",
                                    yaml_variables = predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            project = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.strings.pattern
                                  "(?:\\S/\\S|\\$\\S+)"
                                ],
                            strategy = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "depend" ]
                                ],
                          }
                          {  }
                          false
                          predicates.never,
                          predicates.records.dependencies
                          { branch = [ "project" ], }
                        ],
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          {
                            forward = predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  {
                                    pipeline_variables = predicates.isType
                                        '"Bool",
                                    yaml_variables = predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ],
                            include = predicates.oneOf
                                [
                                  predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern "\\.ya?ml$"
                                  ],
                                  predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.oneOf
                                    [
                                      predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          local = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "\\.ya?ml$"
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                      predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          template = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "\\.ya?ml$"
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                      predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "artifact", "job" ],
                                        predicates.records.record
                                        {
                                          artifact = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "\\.ya?ml$"
                                              ],
                                          job = predicates.isType '"String",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                      predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.required
                                        [ "file", "project" ],
                                        predicates.records.record
                                        {
                                          file = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "\\.ya?ml$"
                                              ],
                                          project = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.pattern
                                                "(?:\\S/\\S|\\$\\S+)"
                                              ],
                                          ref = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.strings.minLength 1
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ]
                                    ]),
                                    predicates.arrays.maxItems 3
                                  ]
                                ],
                            strategy = predicates.allOf
                                [
                                  predicates.isType '"String",
                                  predicates.enum [ "depend" ]
                                ],
                          }
                          {  }
                          false
                          predicates.never
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "(?:\\S/\\S|\\$\\S+)"
                        ]
                      ],
                  variables = definitions.predicate.jobVariables,
                  when = definitions.predicate.when,
                }
                {  }
                false
                predicates.never
              ],
          optional_script = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                ]
              ],
          parallel
            | doc m%"
            Splits up a single job into multiple that run in parallel. Provides `CI_NODE_INDEX` and `CI_NODE_TOTAL` environment variables to the jobs.
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Integer,
                  predicates.numbers.maximum 200,
                  predicates.numbers.minimum 2
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "matrix" ],
                  predicates.records.record
                  {
                    matrix = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  } {  } true
                            (predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Array"
                            ])
                          ]),
                          predicates.arrays.maxItems 200
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          parallel_matrix
            | doc m%"
            Use the `needs:parallel:matrix` keyword to specify parallelized jobs needed to be completed for the job to run. [Learn More](https://docs.gitlab.com/ee/ci/yaml/#needsparallelmatrix)
            "%
            = predicates.oneOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "matrix" ],
                  predicates.records.record
                  {
                    matrix = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.record {  } {  } true
                            (predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType '"Number",
                              predicates.isType '"Array"
                            ])
                          ]),
                          predicates.arrays.maxItems 200
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          retry = predicates.oneOf
              [
                definitions.predicate.retry_max,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    max = definitions.predicate.retry_max,
                    when = predicates.oneOf
                        [
                          definitions.predicate.retry_errors,
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            definitions.predicate.retry_errors
                          ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          retry_errors = predicates.oneOf
              [
                predicates.const "always",
                predicates.const "unknown_failure",
                predicates.const "script_failure",
                predicates.const "api_failure",
                predicates.const "stuck_or_timeout_failure",
                predicates.const "runner_system_failure",
                predicates.const "runner_unsupported",
                predicates.const "stale_schedule",
                predicates.const "job_execution_timeout",
                predicates.const "archived_failure",
                predicates.const "unmet_prerequisites",
                predicates.const "scheduler_failure",
                predicates.const "data_integrity_failure"
              ],
          retry_max
            | doc m%"
            The number of times the job will be retried if it fails. Defaults to 0 and can max be retried 2 times (3 times total).
            "%
            = predicates.allOf
              [
                predicates.isType 'Integer,
                predicates.numbers.maximum 2,
                predicates.numbers.minimum 0
              ],
          rules = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      allow_failure = definitions.predicate.allow_failure,
                      changes = definitions.predicate.changes,
                      exists = definitions.predicate.exists,
                      "if" = definitions.predicate."if",
                      needs = definitions.predicate.rulesNeeds,
                      start_in = definitions.predicate.start_in,
                      variables = definitions.predicate.rulesVariables,
                      when = definitions.predicate.when,
                    }
                    {  }
                    false
                    predicates.never
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.strings.minLength 1,
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]
                ])
              ],
          rulesNeeds = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "job" ],
                    predicates.records.record
                    {
                      artifacts = predicates.isType '"Bool",
                      job = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                      "optional" = predicates.isType '"Bool",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ])
              ],
          rulesVariables = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  ".*" = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  additionalProperties = predicates.never,
                }
                true
                predicates.always
              ],
          script = predicates.oneOf
              [
                predicates.allOf
                [ predicates.isType '"String", predicates.strings.minLength 1 ],
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ]),
                  predicates.arrays.minItems 1
                ]
              ],
          secrets = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                {
                  ".*" = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.anyOf
                        [
                          predicates.allOf
                          [
                            predicates.records.required [ "vault" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ],
                          predicates.allOf
                          [
                            predicates.records.required [ "azure_key_vault" ],
                            predicates.records.record {  } {  } true
                            predicates.always
                          ]
                        ],
                        predicates.records.record
                        {
                          azure_key_vault = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "name" ],
                                predicates.records.record
                                {
                                  name = predicates.isType '"String",
                                  version = predicates.isType '"String",
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          file = predicates.isType '"Bool",
                          token = predicates.isType '"String",
                          vault = predicates.oneOf
                              [
                                predicates.isType '"String",
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.required
                                  [ "engine", "field", "path" ],
                                  predicates.records.record
                                  {
                                    engine = predicates.allOf
                                        [
                                          predicates.isType 'Record,
                                          predicates.records.required
                                          [ "name", "path" ],
                                          predicates.records.record
                                          {
                                            name = predicates.isType '"String",
                                            path = predicates.isType '"String",
                                          }
                                          {  }
                                          true
                                          predicates.always
                                        ],
                                    field = predicates.isType '"String",
                                    path = predicates.isType '"String",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                }
                true
                predicates.always
              ],
          services = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "name" ],
                    predicates.records.record
                    {
                      alias = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                      command = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String"),
                            predicates.arrays.minItems 1
                          ],
                      entrypoint = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.isType '"String"),
                            predicates.arrays.minItems 1
                          ],
                      name = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.strings.minLength 1
                          ],
                      pull_policy = predicates.oneOf
                          [
                            predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum
                              [ "always", "never", "if-not-present" ]
                            ],
                            predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "always", "never", "if-not-present" ]
                              ]),
                              predicates.arrays.minItems 1,
                              predicates.arrays.uniqueItems
                            ]
                          ],
                      variables = definitions.predicate.jobVariables,
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ])
              ],
          start_in = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          string_file_list = predicates.oneOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String")
                ]
              ],
          tags = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.strings.minLength 1,
                predicates.arrays.arrayOf
                (predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.minLength 1
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.strings.minLength 1,
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]
                ])
              ],
          timeout = predicates.allOf
              [ predicates.isType '"String", predicates.strings.minLength 1 ],
          when = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "on_success",
                  "on_failure",
                  "always",
                  "never",
                  "manual",
                  "delayed"
                ]
              ],
          workflowName = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.maxLength 255,
                predicates.strings.minLength 1
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
    "!reference" = definitions.predicate."!reference",
    "$schema" = predicates.isType '"String",
    after_script = definitions.predicate.after_script,
    before_script = definitions.predicate.before_script,
    cache = definitions.predicate.cache,
    "default" = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            "!reference" = definitions.predicate."!reference",
            after_script = definitions.predicate.after_script,
            artifacts = definitions.predicate.artifacts,
            before_script = definitions.predicate.before_script,
            cache = definitions.predicate.cache,
            hooks = definitions.predicate.hooks,
            image = definitions.predicate.image,
            interruptible = definitions.predicate.interruptible,
            retry = definitions.predicate.retry,
            services = definitions.predicate.services,
            tags = definitions.predicate.tags,
            timeout = definitions.predicate.timeout,
          }
          {  }
          false
          predicates.never
        ],
    image = definitions.predicate.image,
    include = predicates.oneOf
        [
          definitions.predicate.include_item,
          predicates.allOf
          [
            predicates.isType '"Array",
            predicates.arrays.arrayOf definitions.predicate.include_item
          ]
        ],
    pages = definitions.predicate.job,
    services = definitions.predicate.services,
    stages = predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String"),
          predicates.arrays.minItems 1,
          predicates.arrays.uniqueItems
        ],
    variables = definitions.predicate.globalVariables,
    workflow = predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record
          {
            name = definitions.predicate.workflowName,
            rules = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [
                      predicates.isType 'Record,
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.strings.minLength 1,
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ]
                    ],
                    predicates.records.record
                    {
                      changes = definitions.predicate.changes,
                      exists = definitions.predicate.exists,
                      "if" = definitions.predicate."if",
                      variables = definitions.predicate.rulesVariables,
                      when = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum [ "always", "never" ]
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ])
                ],
          }
          {  }
          true
          predicates.always
        ],
  }
  {
    "^[.]" = predicates.anyOf
        [ definitions.predicate.job_template, predicates.always ],
  }
  true
  definitions.predicate.job
])