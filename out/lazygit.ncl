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
          color = predicates.contract_from_predicate
              definitions.predicate.color,
          custom-commands-prompts-key-property
            | doc m%"
            A key
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#common-fields
            "%
            = String,
          custom-commands-prompts-title-property
            | doc m%"
            A title
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#common-fields
            "%
            = String,
          custom-commands-prompts-type-property
            | doc m%"
            A type
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#common-fields
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'menuFromCommand, 'menu, 'confirm, 'input |]
              ],
          keybinding = predicates.contract_from_predicate
              definitions.predicate.keybinding,
        },
    predicate = {
          color = predicates.allOf
              [
                predicates.isType '"String",
                predicates.oneOf
                [
                  predicates.enum
                  [
                    "black",
                    "red",
                    "green",
                    "yellow",
                    "blue",
                    "magenta",
                    "cyan",
                    "white",
                    "bold",
                    "default",
                    "reverse",
                    "underline",
                    "strikethrough"
                  ],
                  predicates.strings.pattern "^#[0-9a-fA-F]{6}$"
                ]
              ],
          custom-commands-prompts-key-property
            | doc m%"
            A key
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#common-fields
            "%
            = predicates.isType '"String",
          custom-commands-prompts-title-property
            | doc m%"
            A title
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#common-fields
            "%
            = predicates.isType '"String",
          custom-commands-prompts-type-property
            | doc m%"
            A type
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#common-fields
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "input", "confirm", "menu", "menuFromCommand" ]
              ],
          keybinding = predicates.anyOf
              [ predicates.isType '"String", predicates.isType 'Null ],
        },
  }
in

{
  confirmOnQuit
    | Bool
    | doc m%"
    Whether to confirm on on quit
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  customCommands
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "command", "context", "key" ],
        predicates.records.record
        {
          after = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { checkForConflicts = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
          command = predicates.isType '"String",
          context = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "status",
                  "files",
                  "worktrees",
                  "localBranches",
                  "remotes",
                  "remoteBranches",
                  "tags",
                  "commits",
                  "reflogCommits",
                  "subCommits",
                  "commitFiles",
                  "stash",
                  "global"
                ]
              ],
          description = predicates.isType '"String",
          key = definitions.predicate.keybinding,
          loadingText = predicates.isType '"String",
          prompts = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.allOf
                  [
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "input", }
                    {  }
                    true
                    predicates.always)
                    (predicates.records.record
                    {
                      initialValue = predicates.isType '"String",
                      key =
                        definitions.predicate.custom-commands-prompts-key-property,
                      suggestions = predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.oneOf
                            [
                              predicates.records.record
                              {
                                preset = predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.enum
                                      [
                                        "authors",
                                        "branches",
                                        "files",
                                        "refs",
                                        "remotes",
                                        "remoteBranches",
                                        "tags"
                                      ]
                                    ],
                              }
                              {  }
                              false
                              predicates.never,
                              predicates.records.record
                              { command = predicates.isType '"String", }
                              {  }
                              false
                              predicates.never
                            ]
                          ],
                      title =
                        definitions.predicate.custom-commands-prompts-title-property,
                      type =
                        definitions.predicate.custom-commands-prompts-type-property,
                    }
                    {  }
                    false
                    predicates.never)
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "confirm", }
                    {  }
                    true
                    predicates.always)
                    (predicates.records.record
                    {
                      body = predicates.isType '"String",
                      key =
                        definitions.predicate.custom-commands-prompts-key-property,
                      title =
                        definitions.predicate.custom-commands-prompts-title-property,
                      type =
                        definitions.predicate.custom-commands-prompts-type-property,
                    }
                    {  }
                    false
                    predicates.never)
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "menu", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required [ "options" ],
                      predicates.records.record
                      {
                        key =
                          definitions.predicate.custom-commands-prompts-key-property,
                        options = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.required [ "value" ],
                                predicates.records.record
                                {
                                  description = predicates.isType '"String",
                                  name = predicates.isType '"String",
                                  value = predicates.allOf
                                      [
                                        predicates.isType '"String",
                                        predicates.strings.minLength 1
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ]),
                              predicates.arrays.uniqueItems
                            ],
                        title =
                          definitions.predicate.custom-commands-prompts-title-property,
                        type =
                          definitions.predicate.custom-commands-prompts-type-property,
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always,
                    predicates.ifThenElse
                    (predicates.records.record
                    { type = predicates.const "menuFromCommand", }
                    {  }
                    true
                    predicates.always)
                    (predicates.allOf
                    [
                      predicates.records.required [ "command" ],
                      predicates.records.record
                      {
                        command = predicates.isType '"String",
                        filter = predicates.isType '"String",
                        key =
                          definitions.predicate.custom-commands-prompts-key-property,
                        labelFormat = predicates.isType '"String",
                        title =
                          definitions.predicate.custom-commands-prompts-title-property,
                        type =
                          definitions.predicate.custom-commands-prompts-type-property,
                        valueFormat = predicates.isType '"String",
                      }
                      {  }
                      false
                      predicates.never
                    ])
                    predicates.always
                  ],
                  predicates.records.required [ "key", "title", "type" ],
                  predicates.records.record
                  {
                    key =
                      definitions.predicate.custom-commands-prompts-key-property,
                    title =
                      definitions.predicate.custom-commands-prompts-title-property,
                    type =
                      definitions.predicate.custom-commands-prompts-type-property,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          showOutput = predicates.isType '"Bool",
          stream = predicates.isType '"Bool",
          subprocess = predicates.isType '"Bool",
        }
        {  }
        false
        predicates.never
      ]),
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    Custom commands
    https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Command_Keybindings.md#custom-command-keybindings
    "%
    | optional,
  disableStartupPopups
    | Bool
    | doc m%"
    Whether to disable startup popups
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  git
    | {
      allBranchesLogCmd
        | String
        | doc m%"
        A log command
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      autoFetch
        | Bool
        | doc m%"
        Whether to automatically fetch
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      autoRefresh
        | Bool
        | doc m%"
        Whether to automatically refresh
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      branchLogCmd
        | String
        | doc m%"
        A log command
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      commit
        | {
          signOff
            | Bool
            | doc m%"
            Whether to sign commits off
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Commit settings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      commitPrefixes
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  }
          {
            "." = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "pattern", "replace" ],
                  predicates.records.record
                  {
                    pattern = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                    replace = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.minLength 1
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ],
          }
          false
          predicates.never
        ])
        | doc m%"
        Commit prefixes
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#predefined-commit-message-prefix
        "%
        | optional,
      diffContextSize
        | std.number.Integer
        | doc m%"
        how many lines of context are shown around a change in diffs
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      disableForcePushing
        | Bool
        | doc m%"
        Whether to disable force pushing
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      fetchAll
        | Bool
        | doc m%"
        Whether to fetch everything
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      log
        | {
          order
            | std.enum.TagOrString
            | [| '"default", 'topo-order, 'author-date-order, 'date-order |]
            | doc m%"
            A commit order
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          showGraph
            | std.enum.TagOrString
            | [| 'when-maximised, 'never, 'always |]
            | doc m%"
            Whether to show a graph
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          showWholeGraph
            | Bool
            | doc m%"
            Whether to show the whole graph
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Log settings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      mainBranches
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf
          (predicates.allOf
          [ predicates.isType '"String", predicates.strings.minLength 1 ]),
          predicates.arrays.uniqueItems
        ])
        | doc m%"
        Main branches
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      merging
        | {
          args
            | String
            | doc m%"
            Additional CLI arguments for 'git merge'
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          manualCommit
            | Bool
            | doc m%"
            Whether to use manual commits
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Merging settings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      overrideGpg
        | Bool
        | doc m%"
        Whether not to spawn a separate process while using GPG
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      paging
        | {
          colorArg
            | std.enum.TagOrString
            | [| 'never, 'always |]
            | doc m%"
            A pager color argument
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
            "%
            | optional,
          pager
            | predicates.contract_from_predicate
            (predicates.allOf
            [ predicates.isType '"String", predicates.strings.minLength 1 ])
            | doc m%"
            A pager
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
            "%
            | optional,
          useConfig
            | Bool
            | doc m%"
            Whether to use a config
            https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
            "%
            | optional,
        }
        | doc m%"
        Pager settings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
        "%
        | optional,
      parseEmoji
        | Bool
        | doc m%"
        Whether to parse emoji
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      skipHookPrefix
        | String
        | doc m%"
        A prefix to skip
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
    }
    | doc m%"
    Git settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  gui
    | {
      animateExplosion
        | Bool
        | doc m%"
        Whether to show explosion animation while nuking working tree
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      authorColors
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } { "." = definitions.predicate.color, }
          false
          predicates.never
        ])
        | doc m%"
        Author colors
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-author-color
        "%
        | optional,
      border
        | std.enum.TagOrString
        | [| 'hidden, 'rounded, 'double, 'single |]
        | doc m%"
        A border style
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      branchColors
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType 'Record,
          predicates.records.record {  } { "." = definitions.predicate.color, }
          false
          predicates.never
        ])
        | doc m%"
        Branch colors
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-branch-color
        "%
        | optional,
      commandLogSize
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        A command log size
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      commitLength
        | {
          show
            | Bool
            | doc m%"
            Whether to show the current commit length
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Settings of the current commit length
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      expandFocusedSidePanel
        | Bool
        | doc m%"
        Whether to expand focused side panel
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      language
        | std.enum.TagOrString
        | [| 'ru, 'ko, 'ja, 'nl, 'pl, 'zh-TW, 'zh-CN, 'en, 'auto |]
        | doc m%"
        A language
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      mainPanelSplitMode
        | std.enum.TagOrString
        | [| 'vertical, 'flexible, 'horizontal |]
        | doc m%"
        A split mode of the current main panel
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      mouseEvents
        | Bool
        | doc m%"
        Whether to enable mouse events
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      nerdFontsVersion
        | std.enum.TagOrString
        | [| '"", '"3", '"2" |]
        | doc m%"
        A nerd font version
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      scrollHeight
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
        | doc m%"
        A scroll height
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      scrollPastBottom
        | Bool
        | doc m%"
        Whether to allow scrolling past bottom of the current window
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      shortTimeFormat
        | String
        | doc m%"
        A short time format
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      showBottomLine
        | Bool
        | doc m%"
        Whether to show a bottom line unless there is an important information
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      showBranchCommitHash
        | Bool
        | doc m%"
        Whether to show a branch commit hash
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      showCommandLog
        | Bool
        | doc m%"
        Whether to show command log
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      showFileTree
        | Bool
        | doc m%"
        Whether to render render files in a tree format
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      showListFooter
        | Bool
        | doc m%"
        Whether to show list footer
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      showRandomTip
        | Bool
        | doc m%"
        Whether to show a random tip
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      sidePanelWidth
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"Number",
          predicates.numbers.maximum 1,
          predicates.numbers.minimum 0
        ])
        | doc m%"
        A width of the current side panel
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      skipDiscardChangeWarning
        | Bool
        | doc m%"
        Whether to disable change warning
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      skipRewordInEditorWarning
        | Bool
        | doc m%"
        Whether to skip a confirmation before launching a reword editor
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      skipStashWarning
        | Bool
        | doc m%"
        Whether to disable stash warning
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      splitDiff
        | std.enum.TagOrString
        | [| 'always, 'auto |]
        | doc m%"
        Whether to skip diff
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      theme
        | {
          activeBorderColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Active border colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          cherryPickedCommitBgColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Cherry picked commit background colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          cherryPickedCommitFgColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Cherry picked commit foreground colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          defaultFgColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Default foreground colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          inactiveBorderColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Inactive border colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          optionsTextColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Option text colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          searchingActiveBorderColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Searching active border colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          selectedLineBgColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Selected line background colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          selectedRangeBgColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Selected range background colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          unstagedChangesColor
            | predicates.contract_from_predicate
            (predicates.allOf
            [
              predicates.isType '"Array",
              predicates.arrays.arrayOf definitions.predicate.color,
              predicates.arrays.minItems 1,
              predicates.arrays.uniqueItems
            ])
            | doc m%"
            Unstaged changes colors of the current theme
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Settings of the current theme
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      timeFormat
        | String
        | doc m%"
        A time format
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      windowSize
        | std.enum.TagOrString
        | [| 'full, 'half, 'normal |]
        | doc m%"
        A window size
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
    }
    | doc m%"
    Settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  keybinding
    | {
      branches
        | {
          checkoutBranchByName
            | definitions.contract.keybinding
            | doc m%"
            A checkout branch by name keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          createPullRequest
            | definitions.contract.keybinding
            | doc m%"
            A create pull request keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          createTag
            | definitions.contract.keybinding
            | doc m%"
            A create tag keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          fastForward
            | definitions.contract.keybinding
            | doc m%"
            A fast forward keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          fetchRemote
            | definitions.contract.keybinding
            | doc m%"
            A fetch remote keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          forceCheckoutBranch
            | definitions.contract.keybinding
            | doc m%"
            A force checkout branch keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          mergeIntoCurrentBranch
            | definitions.contract.keybinding
            | doc m%"
            A merge into current branch keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          pushTag
            | definitions.contract.keybinding
            | doc m%"
            A push tag keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          rebaseBranch
            | definitions.contract.keybinding
            | doc m%"
            A rebase branch keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          renameBranch
            | definitions.contract.keybinding
            | doc m%"
            A rename branch keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          setUpstream
            | definitions.contract.keybinding
            | doc m%"
            A set upstream keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          viewGitFlowOptions
            | definitions.contract.keybinding
            | doc m%"
            A view git flow options keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          viewPullRequestOptions
            | definitions.contract.keybinding
            | doc m%"
            A view pull request options keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Branch keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      commitFiles
        | {
          checkoutCommitFile
            | definitions.contract.keybinding
            | doc m%"
            A checkout commit file keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Commit file keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      commits
        | {
          amendToCommit
            | definitions.contract.keybinding
            | doc m%"
            A amend to commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          checkoutCommit
            | definitions.contract.keybinding
            | doc m%"
            A checkout commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          cherryPickCopy
            | definitions.contract.keybinding
            | doc m%"
            A cherry pick copy keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          cherryPickCopyRange
            | definitions.contract.keybinding
            | doc m%"
            A cherry pick copy range keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          copyCommitMessageToClipboard
            | definitions.contract.keybinding
            | doc m%"
            A copy commit message to clipboard keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          createFixupCommit
            | definitions.contract.keybinding
            | doc m%"
            A create fixup commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          markCommitAsFixup
            | definitions.contract.keybinding
            | doc m%"
            A mark commit as fixup keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          moveDownCommit
            | definitions.contract.keybinding
            | doc m%"
            A move down commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          moveUpCommit
            | definitions.contract.keybinding
            | doc m%"
            A move up commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          openLogMenu
            | definitions.contract.keybinding
            | doc m%"
            A open log menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          pasteCommits
            | definitions.contract.keybinding
            | doc m%"
            A paste commits keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          pickCommit
            | definitions.contract.keybinding
            | doc m%"
            A pick commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          renameCommit
            | definitions.contract.keybinding
            | doc m%"
            A rename commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          renameCommitWithEditor
            | definitions.contract.keybinding
            | doc m%"
            A rename commit with editor keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          resetCherryPick
            | definitions.contract.keybinding
            | doc m%"
            A reset cherry pick keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          revertCommit
            | definitions.contract.keybinding
            | doc m%"
            A revert commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          squashAboveCommits
            | definitions.contract.keybinding
            | doc m%"
            A squash above commits keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          squashDown
            | definitions.contract.keybinding
            | doc m%"
            A squash down keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          tagCommit
            | definitions.contract.keybinding
            | doc m%"
            A tag commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          viewBisectOptions
            | definitions.contract.keybinding
            | doc m%"
            A view bisect options keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          viewResetOptions
            | definitions.contract.keybinding
            | doc m%"
            A view reset options keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Commit keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      files
        | {
          amendLastCommit
            | definitions.contract.keybinding
            | doc m%"
            A amend last commit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          commitChanges
            | definitions.contract.keybinding
            | doc m%"
            A commit changes keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          commitChangesWithEditor
            | definitions.contract.keybinding
            | doc m%"
            A commit changes with editor keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          commitChangesWithoutHook
            | definitions.contract.keybinding
            | doc m%"
            A commit changes without hook keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          fetch
            | definitions.contract.keybinding
            | doc m%"
            A fetch keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          ignoreFile
            | definitions.contract.keybinding
            | doc m%"
            A ignore file keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          openMergeTool
            | definitions.contract.keybinding
            | doc m%"
            A open merge tool keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          openStatusFilter
            | definitions.contract.keybinding
            | doc m%"
            A open status filter keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          refreshFiles
            | definitions.contract.keybinding
            | doc m%"
            A refresh files keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          stashAllChanges
            | definitions.contract.keybinding
            | doc m%"
            A stash all changes keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          toggleStagedAll
            | definitions.contract.keybinding
            | doc m%"
            A toggle staged all keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          toggleTreeView
            | definitions.contract.keybinding
            | doc m%"
            A toggle tree view keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          viewResetOptions
            | definitions.contract.keybinding
            | doc m%"
            A view reset options keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          viewStashOptions
            | definitions.contract.keybinding
            | doc m%"
            A view stash options keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        File keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      main
        | {
          pickBothHunks
            | definitions.contract.keybinding
            | doc m%"
            A pick both hunks keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          toggleDragSelect
            | definitions.contract.keybinding
            | doc m%"
            A toggle drag select keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          toggleDragSelect-alt
            | definitions.contract.keybinding
            | doc m%"
            A toggle drag select-alt keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          toggleSelectHunk
            | definitions.contract.keybinding
            | doc m%"
            A toggle select hunk keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Main keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      stash
        | {
          popStash
            | definitions.contract.keybinding
            | doc m%"
            A pop stash keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          renameStash
            | definitions.contract.keybinding
            | doc m%"
            A rename stash keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Stash keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      status
        | {
          checkForUpdate
            | definitions.contract.keybinding
            | doc m%"
            A check for update keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          recentRepos
            | definitions.contract.keybinding
            | doc m%"
            A recent repos keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Status keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      submodules
        | {
          bulkMenu
            | definitions.contract.keybinding
            | doc m%"
            A bulk menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          init
            | definitions.contract.keybinding
            | doc m%"
            An init keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          update
            | definitions.contract.keybinding
            | doc m%"
            An update keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Submodules keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      universal
        | {
          confirm
            | definitions.contract.keybinding
            | doc m%"
            A confirm keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          copyToClipboard
            | definitions.contract.keybinding
            | doc m%"
            A copy to clipboard keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          createPatchOptionsMenu
            | definitions.contract.keybinding
            | doc m%"
            A create patch options menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          createRebaseOptionsMenu
            | definitions.contract.keybinding
            | doc m%"
            A create rebase options menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          decreaseContextInDiffView
            | definitions.contract.keybinding
            | doc m%"
            A decrease context in diff view keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          diffingMenu
            | definitions.contract.keybinding
            | doc m%"
            A diffing menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          diffingMenu-alt
            | definitions.contract.keybinding
            | doc m%"
            A diffing menu-alt keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          edit
            | definitions.contract.keybinding
            | doc m%"
            A edit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          executeCustomCommand
            | definitions.contract.keybinding
            | doc m%"
            A execute custom command keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          extrasMenu
            | definitions.contract.keybinding
            | doc m%"
            A extras menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          filteringMenu
            | definitions.contract.keybinding
            | doc m%"
            A filtering menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          goInto
            | definitions.contract.keybinding
            | doc m%"
            A go into keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          gotoBottom
            | definitions.contract.keybinding
            | doc m%"
            A goto bottom keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          gotoTop
            | definitions.contract.keybinding
            | doc m%"
            A goto top keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          increaseContextInDiffView
            | definitions.contract.keybinding
            | doc m%"
            A increase context in diff view keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          jumpToBlock
            | Array Dyn
            | doc m%"
            A jump to block keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          new
            | definitions.contract.keybinding
            | doc m%"
            A new keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextBlock
            | definitions.contract.keybinding
            | doc m%"
            A next block keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextBlock-alt
            | definitions.contract.keybinding
            | doc m%"
            A next block-alt keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextItem
            | definitions.contract.keybinding
            | doc m%"
            A next item keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextItem-alt
            | definitions.contract.keybinding
            | doc m%"
            A next item-alt keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextMatch
            | definitions.contract.keybinding
            | doc m%"
            A next match keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextPage
            | definitions.contract.keybinding
            | doc m%"
            A next page keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextScreenMode
            | definitions.contract.keybinding
            | doc m%"
            A next screen mode keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          nextTab
            | definitions.contract.keybinding
            | doc m%"
            A next tab keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          openFile
            | definitions.contract.keybinding
            | doc m%"
            An open file keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          openRecentRepos
            | definitions.contract.keybinding
            | doc m%"
            An open recent repos keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          optionMenu
            | predicates.contract_from_predicate (predicates.isType 'Null)
            | doc m%"
            An option menu keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          optionMenu-alt1
            | definitions.contract.keybinding
            | doc m%"
            An option menu-alt1 keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevBlock
            | definitions.contract.keybinding
            | doc m%"
            A previous block keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevBlock-alt
            | definitions.contract.keybinding
            | doc m%"
            A previous block-alt keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevItem
            | definitions.contract.keybinding
            | doc m%"
            A previous item keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevItem-alt
            | definitions.contract.keybinding
            | doc m%"
            A previous item-alt keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevMatch
            | definitions.contract.keybinding
            | doc m%"
            A previous match keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevPage
            | definitions.contract.keybinding
            | doc m%"
            A previous page keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevScreenMode
            | definitions.contract.keybinding
            | doc m%"
            A previous screen mode keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          prevTab
            | definitions.contract.keybinding
            | doc m%"
            A previous tab keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          pullFiles
            | definitions.contract.keybinding
            | doc m%"
            A pull files keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          pushFiles
            | definitions.contract.keybinding
            | doc m%"
            A push files keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          quit
            | definitions.contract.keybinding
            | doc m%"
            A quit keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          quit-alt1
            | definitions.contract.keybinding
            | doc m%"
            A quit-alt1 keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          quitWithoutChangingDirectory
            | definitions.contract.keybinding
            | doc m%"
            A quit without changing directory keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          redo
            | definitions.contract.keybinding
            | doc m%"
            A redo keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          refresh
            | definitions.contract.keybinding
            | doc m%"
            A refresh keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          remove
            | definitions.contract.keybinding
            | doc m%"
            A remove keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          return
            | definitions.contract.keybinding
            | doc m%"
            A return keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollDownMain
            | definitions.contract.keybinding
            | doc m%"
            A scroll down main keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollDownMain-alt1
            | definitions.contract.keybinding
            | doc m%"
            A scroll down main-alt1 keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollDownMain-alt2
            | definitions.contract.keybinding
            | doc m%"
            A scroll down main-alt2 keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollLeft
            | definitions.contract.keybinding
            | doc m%"
            A scroll left keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollRight
            | definitions.contract.keybinding
            | doc m%"
            A scroll right keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollUpMain
            | definitions.contract.keybinding
            | doc m%"
            A scroll up main keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollUpMain-alt1
            | definitions.contract.keybinding
            | doc m%"
            A scroll up main-alt1 keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          scrollUpMain-alt2
            | definitions.contract.keybinding
            | doc m%"
            A scroll up main-alt2 keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          select
            | definitions.contract.keybinding
            | doc m%"
            A select keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          submitEditorText
            | definitions.contract.keybinding
            | doc m%"
            A submit editor text keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          togglePanel
            | definitions.contract.keybinding
            | doc m%"
            A toggle panel keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          toggleWhitespaceInDiffView
            | definitions.contract.keybinding
            | doc m%"
            A toggle whitespace in diff view keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
          undo
            | definitions.contract.keybinding
            | doc m%"
            An undo keybinding
            https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
            "%
            | optional,
        }
        | doc m%"
        Universal keybindings
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
    }
    | doc m%"
    Keybinding settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  notARepository
    | std.enum.TagOrString
    | [| 'quit, 'skip, 'create, 'prompt |]
    | doc m%"
    An action for non-repositories
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  os
    | {
      copyToClipboardCmd
        | String
        | doc m%"
        A copy to clipboard command
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
        "%
        | optional,
      edit
        | String
        | doc m%"
        An editor command
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
        "%
        | optional,
      editAtLine
        | String
        | doc m%"
        An editor command to open at specific line
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
        "%
        | optional,
      editAtLineAndWait
        | String
        | doc m%"
        An editor command to open at specific line and wait
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
        "%
        | optional,
      editPreset
        | predicates.contract_from_predicate
        (predicates.allOf
        [
          predicates.isType '"String",
          predicates.oneOf
          [
            predicates.enum
            [
              "vim",
              "nvim",
              "emacs",
              "nano",
              "vscode",
              "sublime",
              "bbedit",
              "kakoune",
              "helix",
              "xcode"
            ],
            predicates.const ""
          ]
        ])
        | doc m%"
        An edit preset
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
        "%
        | optional,
      open
        | String
        | doc m%"
        An editor command for non-text files
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
        "%
        | optional,
      openLink
        | String
        | doc m%"
        An open link
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
    }
    | doc m%"
    OS settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#configuring-file-editing
    "%
    | optional,
  promptToReturnFromSubprocess
    | Bool
    | doc m%"
    Whether to show confirmation on subprocess termination
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  quitOnTopLevelReturn
    | Bool
    | doc m%"
    Whether to quit on 'esc' press while there is nothing to cancel/close
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  refresher
    | {
      fetchInterval
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        A re-fetch interval in seconds
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      refreshInterval
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        A file/submodule refresh interval in seconds
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
    }
    | doc m%"
    Refresh settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
  services
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  }
      {
        "." = predicates.allOf
            [
              predicates.isType '"String",
              predicates.strings.pattern "^[^:]+:[^:]+$"
            ],
      }
      false
      predicates.never
    ])
    | doc m%"
    Service settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#custom-pull-request-urls
    "%
    | optional,
  update
    | {
      days
        | predicates.contract_from_predicate
        (predicates.allOf
        [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
        | doc m%"
        A day count
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
      method
        | std.enum.TagOrString
        | [| 'never, 'background, 'prompt |]
        | doc m%"
        A method
        https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
        "%
        | optional,
    }
    | doc m%"
    Update settings
    https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md#default
    "%
    | optional,
}