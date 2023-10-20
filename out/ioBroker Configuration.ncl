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
          DatabaseBackupOptions = {
                "// files" | String,
                "// hours" | String,
                "// path" | String,
                "// period" | String,
                disabled | Bool,
                files
                  | Number
                  | doc m%"
                  Minimal number of backup files, after the deletion will be executed according to backupTime settings
                  "%,
                hours
                  | Number
                  | doc m%"
                  All backups older than configured hours will be deleted. But only if the number of files is greater than of backupNumber
                  "%,
                path
                  | String
                  | doc m%"
                  Absolute path to backup directory or empty to backup in data directory
                  "%,
                period
                  | Number
                  | doc m%"
                  by default backup every 2 hours. Time is in minutes. To disable backup set the value to 0
                  "%,
              },
          DatabaseOptions = {
                "// type" | String,
                backup | definitions.contract.DatabaseBackupOptions,
                connectTimeout | Number,
                dataDir | String,
                host | String,
                jsonlOptions | definitions.contract.JsonlOptions,
                options
                  | {
                    auth_pass | String,
                    db | Number,
                    family | Number,
                    retry_max_count | Number,
                    retry_max_delay | Number,
                  },
                port | Number,
                type
                  | std.enum.TagOrString
                  | [| 'redis, 'file, 'jsonl |]
                  | doc m%"
                  Possible values: 'file' - [port 9001], 'jsonl' - [port 9001], 'redis' - [port 6379 or 26379 for sentinel].
                  "%,
                writeFileInterval | Number,
              },
          IoBJson
            | doc m%"
            The ioBroker global config
            "%
            = {
                "// dataDir" | String,
                "// dnsResolution" | String,
                dataDir
                  | String
                  | doc m%"
                  Always relative to iobroker.js-controller/
                  "%,
                dnsResolution
                  | std.enum.TagOrString
                  | [| 'ipv4first, 'verbatim |]
                  | doc m%"
                  Use 'verbatim' for ipv6 first, else use 'ipv4first'
                  "%,
                log
                  | {
                    level | String,
                    maxDays | Number,
                    noStdout | Bool,
                    transport | {  .. },
                  },
                multihostService
                  | { enabled | Bool, password | String, secure | Bool, },
                objects | definitions.contract.ObjectsDatabaseOptions,
                plugins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "enabled" ],
                      predicates.records.record
                      { enabled = predicates.isType '"Bool", }
                      {  }
                      true
                      predicates.always
                    ])
                  ]),
                states | definitions.contract.DatabaseOptions,
                system
                  | {
                    "// allowShellCommands" | String,
                    "// checkDiskInterval" | String,
                    "// compact" | String,
                    "// memLimitError" | String,
                    "// memLimitWarn" | String,
                    "// statisticsInterval" | String,
                    allowShellCommands
                      | Bool
                      | doc m%"
                      Allow execution of "shell" sendToHost commands
                      "%,
                    checkDiskInterval
                      | Number
                      | doc m%"
                      Interval how often the disk size will be checked in ms
                      "%,
                    compact
                      | Bool
                      | doc m%"
                      Controller will try to start the instances as a part of the same process. No spawn will be done. Only by adapters that support it and have flag compact flag in io-package.json
                      "%,
                    hostname
                      | String
                      | doc m%"
                      if empty, determine use real hostname
                      "%,
                    instanceStartInterval
                      | Number
                      | doc m%"
                      interval to wait between multiple instances starts
                      "%,
                    memLimitError
                      | Number
                      | doc m%"
                      If the available RAM is below this threshold on adapter start, an error will be logged.
                      "%,
                    memLimitWarn
                      | Number
                      | doc m%"
                      If the available RAM is below this threshold on adapter start, a warning will be logged.
                      "%,
                    memoryLimitMB
                      | Number
                      | doc m%"
                      do not use more than memory limit mb by ioB process (0 to deactivate)
                      "%,
                    statisticsInterval
                      | Number
                      | doc m%"
                      Interval how often the counters for input/output in adapters and controller will be updated in ms
                      "%,
                  },
              },
          JsonlOptions = {
                "// autoCompress (1)" | String,
                "// autoCompress (2)" | String,
                "// autoCompress (3)" | String,
                "// ignoreReadErrors" | String,
                "// throttleFS (1)" | String,
                "// throttleFS (2)" | String,
                autoCompress
                  | { sizeFactor | Number, sizeFactorMinimumSize | Number, }
                  | doc m%"
                  The JSONL DB is append-only and will contain unnecessary entries after a while. It will be compressed when the uncompressed size is >= size * sizeFactor AND >= sizeFactorMinimumSize Note that too low values here will cause the DB to be rewritten often.
                  "%,
                ignoreReadErrors
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Bool", predicates.const true ])
                  | doc m%"
                  If single lines in the DB are corrupted, they can be ignored without losing the whole DB.
                  "%,
                throttleFS
                  | {
                    "// intervalMs" | String,
                    "// maxBufferedCommands" | String,
                    intervalMs
                      | Number
                      | doc m%"
                      Write to the database file no more than every intervalMs milliseconds.
                      "%,
                    maxBufferedCommands
                      | Number
                      | doc m%"
                      Force writing after this many changes have been buffered. This reduces memory consumption and data loss in case of a crash.
                      "%,
                  }
                  | doc m%"
                  By default, the database immediately writes to the database file. Write accesses can be reduced using the throttleFS option. Be aware that buffered changes will be lost in case the process crashes
                  "%,
              },
          ObjectsDatabaseOptions = {
                "// type" | String,
                backup | definitions.contract.DatabaseBackupOptions,
                connectTimeout | Number,
                dataDir | String,
                host | String,
                jsonlOptions | definitions.contract.JsonlOptions,
                maxQueue | Number,
                noFileCache | Bool,
                options
                  | {
                    auth_pass | String,
                    db | Number,
                    family | Number,
                    retry_max_count | Number,
                    retry_max_delay | Number,
                  },
                port | Number,
                type
                  | std.enum.TagOrString
                  | [| 'redis, 'file, 'jsonl |]
                  | doc m%"
                  Possible values: 'file' - [port 9001], 'jsonl' - [port 9001], 'redis' - [port 6379 or 26379 for sentinel].
                  "%,
                writeFileInterval | Number,
              },
        },
    predicate = {
          DatabaseBackupOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "// files",
                  "// hours",
                  "// path",
                  "// period",
                  "disabled",
                  "files",
                  "hours",
                  "path",
                  "period"
                ],
                predicates.records.record
                {
                  "// files" = predicates.isType '"String",
                  "// hours" = predicates.isType '"String",
                  "// path" = predicates.isType '"String",
                  "// period" = predicates.isType '"String",
                  disabled = predicates.isType '"Bool",
                  files = predicates.isType '"Number",
                  hours = predicates.isType '"Number",
                  path = predicates.isType '"String",
                  period = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          DatabaseOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "// type",
                  "backup",
                  "connectTimeout",
                  "dataDir",
                  "host",
                  "jsonlOptions",
                  "options",
                  "port",
                  "type",
                  "writeFileInterval"
                ],
                predicates.records.record
                {
                  "// type" = predicates.isType '"String",
                  backup = definitions.predicate.DatabaseBackupOptions,
                  connectTimeout = predicates.isType '"Number",
                  dataDir = predicates.isType '"String",
                  host = predicates.isType '"String",
                  jsonlOptions = definitions.predicate.JsonlOptions,
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [
                          "auth_pass",
                          "db",
                          "family",
                          "retry_max_count",
                          "retry_max_delay"
                        ],
                        predicates.records.record
                        {
                          auth_pass = predicates.isType '"String",
                          db = predicates.isType '"Number",
                          family = predicates.isType '"Number",
                          retry_max_count = predicates.isType '"Number",
                          retry_max_delay = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  port = predicates.isType '"Number",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "jsonl", "file", "redis" ]
                      ],
                  writeFileInterval = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          IoBJson
            | doc m%"
            The ioBroker global config
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "// dataDir",
                  "// dnsResolution",
                  "dataDir",
                  "dnsResolution",
                  "log",
                  "multihostService",
                  "objects",
                  "plugins",
                  "states",
                  "system"
                ],
                predicates.records.record
                {
                  "// dataDir" = predicates.isType '"String",
                  "// dnsResolution" = predicates.isType '"String",
                  dataDir = predicates.isType '"String",
                  dnsResolution = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "verbatim", "ipv4first" ]
                      ],
                  log = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "level", "maxDays", "noStdout", "transport" ],
                        predicates.records.record
                        {
                          level = predicates.isType '"String",
                          maxDays = predicates.isType '"Number",
                          noStdout = predicates.isType '"Bool",
                          transport = predicates.isType 'Record,
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  multihostService = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "enabled", "password", "secure" ],
                        predicates.records.record
                        {
                          enabled = predicates.isType '"Bool",
                          password = predicates.isType '"String",
                          secure = predicates.isType '"Bool",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  objects = definitions.predicate.ObjectsDatabaseOptions,
                  plugins = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "enabled" ],
                          predicates.records.record
                          { enabled = predicates.isType '"Bool", }
                          {  }
                          true
                          predicates.always
                        ])
                      ],
                  states = definitions.predicate.DatabaseOptions,
                  system = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [
                          "// allowShellCommands",
                          "// checkDiskInterval",
                          "// compact",
                          "// memLimitError",
                          "// memLimitWarn",
                          "// statisticsInterval",
                          "allowShellCommands",
                          "checkDiskInterval",
                          "compact",
                          "hostname",
                          "instanceStartInterval",
                          "memLimitError",
                          "memLimitWarn",
                          "memoryLimitMB",
                          "statisticsInterval"
                        ],
                        predicates.records.record
                        {
                          "// allowShellCommands" = predicates.isType '"String",
                          "// checkDiskInterval" = predicates.isType '"String",
                          "// compact" = predicates.isType '"String",
                          "// memLimitError" = predicates.isType '"String",
                          "// memLimitWarn" = predicates.isType '"String",
                          "// statisticsInterval" = predicates.isType '"String",
                          allowShellCommands = predicates.isType '"Bool",
                          checkDiskInterval = predicates.isType '"Number",
                          compact = predicates.isType '"Bool",
                          hostname = predicates.isType '"String",
                          instanceStartInterval = predicates.isType '"Number",
                          memLimitError = predicates.isType '"Number",
                          memLimitWarn = predicates.isType '"Number",
                          memoryLimitMB = predicates.isType '"Number",
                          statisticsInterval = predicates.isType '"Number",
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
          JsonlOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "// autoCompress (1)",
                  "// autoCompress (2)",
                  "// autoCompress (3)",
                  "// ignoreReadErrors",
                  "// throttleFS (1)",
                  "// throttleFS (2)",
                  "autoCompress",
                  "ignoreReadErrors",
                  "throttleFS"
                ],
                predicates.records.record
                {
                  "// autoCompress (1)" = predicates.isType '"String",
                  "// autoCompress (2)" = predicates.isType '"String",
                  "// autoCompress (3)" = predicates.isType '"String",
                  "// ignoreReadErrors" = predicates.isType '"String",
                  "// throttleFS (1)" = predicates.isType '"String",
                  "// throttleFS (2)" = predicates.isType '"String",
                  autoCompress = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [ "sizeFactor", "sizeFactorMinimumSize" ],
                        predicates.records.record
                        {
                          sizeFactor = predicates.isType '"Number",
                          sizeFactorMinimumSize = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  ignoreReadErrors = predicates.allOf
                      [ predicates.isType '"Bool", predicates.const true ],
                  throttleFS = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [
                          "// intervalMs",
                          "// maxBufferedCommands",
                          "intervalMs",
                          "maxBufferedCommands"
                        ],
                        predicates.records.record
                        {
                          "// intervalMs" = predicates.isType '"String",
                          "// maxBufferedCommands" = predicates.isType
                              '"String",
                          intervalMs = predicates.isType '"Number",
                          maxBufferedCommands = predicates.isType '"Number",
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
          ObjectsDatabaseOptions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [
                  "// type",
                  "backup",
                  "connectTimeout",
                  "dataDir",
                  "host",
                  "jsonlOptions",
                  "maxQueue",
                  "noFileCache",
                  "options",
                  "port",
                  "type",
                  "writeFileInterval"
                ],
                predicates.records.record
                {
                  "// type" = predicates.isType '"String",
                  backup = definitions.predicate.DatabaseBackupOptions,
                  connectTimeout = predicates.isType '"Number",
                  dataDir = predicates.isType '"String",
                  host = predicates.isType '"String",
                  jsonlOptions = definitions.predicate.JsonlOptions,
                  maxQueue = predicates.isType '"Number",
                  noFileCache = predicates.isType '"Bool",
                  options = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required
                        [
                          "auth_pass",
                          "db",
                          "family",
                          "retry_max_count",
                          "retry_max_delay"
                        ],
                        predicates.records.record
                        {
                          auth_pass = predicates.isType '"String",
                          db = predicates.isType '"Number",
                          family = predicates.isType '"Number",
                          retry_max_count = predicates.isType '"Number",
                          retry_max_delay = predicates.isType '"Number",
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  port = predicates.isType '"Number",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "jsonl", "file", "redis" ]
                      ],
                  writeFileInterval = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
        },
  }
in

definitions.contract.IoBJson