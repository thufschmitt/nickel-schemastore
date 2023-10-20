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
          generic-memory = predicates.contract_from_predicate
              definitions.predicate.generic-memory,
          hooks = predicates.contract_from_predicate
              definitions.predicate.hooks,
          hooks-parameters = {
                command
                  | String
                  | doc m%"
                  Defines the actual command that is executed as a Cloud Foundry task.
                  "%,
                disk-quota
                  | definitions.contract.generic-memory
                  | doc m%"
                  Defines the disk space that is available to the Cloud Foundry task.
                  "%
                  | optional,
                memory
                  | definitions.contract.generic-memory
                  | doc m%"
                  Defines the memory that is available to the Cloud Foundry task.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Defines the name of the Cloud Foundry task that should be executed.
                  "%
                  | optional,
                ..
              },
          module-parameters = {
                app-name
                  | String
                  | doc m%"
                  The name of the application in the Cloud Foundry environment to be deployed for this module, based on the module name.
                  "%
                  | optional,
                buildpack
                  | String
                  | doc m%"
                  The name or the URL of a custom buildpack required by the application.
                  "%
                  | optional,
                buildpacks
                  | definitions.contract.module-parameters-buildpacks
                  | doc m%"
                  An array of buildpacks. If a buildpack parameter already exists, it will be overwritten by the buildpacks listed in the buildpacks parameter, so that you have to include it in the array.
                  "%
                  | optional,
                command
                  | String
                  | doc m%"
                  A custom command required to start the application.
                  "%
                  | optional,
                create-service-broker
                  | Bool
                  | doc m%"
                  Specifies whether [true|false] a service broker should be registered for the application module; default value is: false.
                  "%
                  | optional,
                dependency-type
                  | std.enum.TagOrString
                  | [| 'soft, 'hard |]
                  | doc m%"
                  Defines the memory allocated to the application.
                  "%
                  | optional,
                disk-quota
                  | definitions.contract.generic-memory
                  | doc m%"
                  The disk space that will be available to the application. This parameter requires a unit of measurement M, MB, G, or GB in upper or lower case.
                  "%
                  | optional,
                docker
                  | definitions.contract.module-parameters-docker
                  | doc m%"
                  Creates a module from a docker image. When using a docker image parameter, we do not need to specify the module in the MANIFEST.mf file.When uploading a docker image, the content of a module is not needed.
                  "%
                  | optional,
                domain
                  | String
                  | doc m%"
                  The domain on which the application will be available later.
                  "%
                  | optional,
                domains
                  | definitions.contract.module-parameters-domains
                  | doc m%"
                  The domains on which the application will be available later. The resulting application routes will be the Cartesian product of the domains and hosts. That is, a separate route for each host is constructed on each domain.
                  "%
                  | optional,
                enable-ssh
                  | Bool
                  | doc m%"
                  Enables use of SSH within an application. Supported for the Diego container runtime environment only.
                  "%
                  | optional,
                health-check-http-endpoint
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "^/.+"
                  ])
                  | doc m%"
                  A http health check defaults to using '/' as its endpoint, but you can specify a custom endpoint.
                  "%
                  | optional,
                health-check-invocation-timeout
                  | std.number.Integer
                  | doc m%"
                  The timeout in seconds for individual health check requests for http and port health checks.
                  "%
                  | optional,
                health-check-timeout
                  | std.number.Integer
                  | doc m%"
                  The timeout is the amount of time (in seconds) allowed to elapse between starting up an app and the first healthy response.
                  "%
                  | optional,
                health-check-type
                  | std.enum.TagOrString
                  | [| 'http, 'process, 'port |]
                  | doc m%"
                  Defines how the module will be monitored for availability.
                  "%
                  | optional,
                host
                  | String
                  | doc m%"
                  The hostname or subdomain where an application is available later.
                  "%
                  | optional,
                hosts
                  | definitions.contract.module-parameters-hosts
                  | doc m%"
                  The hostnames or subdomain where an application is available later.
                  "%
                  | optional,
                idle-domain
                  | String
                  | doc m%"
                  The idle domain on which the idle application will be available during blue-green deploy.
                  "%
                  | optional,
                idle-domains
                  | definitions.contract.module-parameters-domains
                  | doc m%"
                  The domains on which the idle application will be available during blue-green deploy. The resulting application routes will be the Cartesian product of the domains and hosts. That is, a separate route for each host is constructed on each domain.
                  "%
                  | optional,
                idle-host
                  | String
                  | doc m%"
                  The hostname or subdomain where the idle application will be available during blue-green deploy.
                  "%
                  | optional,
                idle-hosts
                  | definitions.contract.module-parameters-hosts
                  | doc m%"
                  The hostnames or subdomain where the idle application will be available during blue-green deploy.
                  "%
                  | optional,
                instances
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The number of application instances that will be started during the deployment.
                  "%
                  | optional,
                keep-existing
                  | definitions.contract.module-parameters-keep-existing
                  | doc m%"
                  Defines the application attributes which will be kept after the deployment or blue-green deployment has finished. The supported attributes which could be kept are application environment, application bindings and application routes. If not specified, the default values are false, which indicates that each application attribute will be updated with the new values presented in the deployment descriptor.
                  "%
                  | optional,
                keep-existing-routes
                  | Bool
                  | doc m%"
                  When specified on module level, it indicates if the existing routes of the module's corresponding application should be kept even if they are not defined within the deployment and/or extension descriptors.When specified on global level, under the parameters section of the descriptor, it indicates if the existing routes of all applications within that MTA should be kept.The module-level variant of the parameter has priority over the global parameter.This parameter is typically used when users want to keep the routes they have mapped manually by using the cf map-route command. We discourage this approach, as manual operations could lead to inconsistent deployment results and difficult troubleshooting. We recommend you to define all routes in the deployment and/or extension descriptors, which allows for their automatic management.
                  "%
                  | optional,
                memory
                  | definitions.contract.generic-memory
                  | doc m%"
                  Defines the memory allocated to the application.
                  "%
                  | optional,
                no-route
                  | Bool
                  | doc m%"
                  Defines if a route should be assigned to the application.
                  "%
                  | optional,
                no-start
                  | Bool
                  | doc m%"
                  Start/do not start the application during deployment. This parameter setting overrides the command-line option --no-start. If you explicitly set the no-start to false for the module foo in the example provided, then the module foo is started on deployment, even if you also specify the command-line option --no-start with the cf deploy command.
                  "%
                  | optional,
                restart-on-env-change
                  | definitions.contract.module-parameters-restart-on-env-change
                  | doc m%"
                  Specifies whether an application should be restarted if an environment variable has been changed in one of the following categories: vcap-application, vcap-services, user-provided. If you set these parameters to false, the changes in environment are not consumable by a running instances of the application. If your application depends on the latest environment, it might become outdated.
                  "%
                  | optional,
                routes
                  | definitions.contract.module-parameters-routes
                  | doc m%"
                  A parameter that lists multiple HTTP routes. It is a combination of the old parameters host, domain, port and route-path, which encompasses the full addresses to which to bind a module. In case the new routes parameter and the old ones are available, the routes value is used and the values of the old parameters are ignored. Each route for the application is created if it does not already exist. A routes parameter consists of one or many HTTP routes following the pattern myhost.my.domain/path
                  "%
                  | optional,
                service-broker-name
                  | String
                  | doc m%"
                  The name of the service broker in the Cloud Foundry environment to be created and registered for the specified application module.
                  "%
                  | optional,
                service-broker-password
                  | String
                  | doc m%"
                  The password used for authentication by the XS controller at the service broker when performing service-related requests. The parameter is mandatory if create-service-broker: true.
                  "%
                  | optional,
                service-broker-space-scoped
                  | Bool
                  | doc m%"
                  Makes the service plans of the broker visible only within the targeted space.
                  "%
                  | optional,
                service-broker-url
                  | String
                  | doc m%"
                  Specifies the value of the service broker universal resource locator (URL) to register; service requests are sent to this URL. The parameter is mandatory if create-service-broker: true.
                  "%
                  | optional,
                service-broker-user
                  | String
                  | doc m%"
                  The name of the user required for authentication by the XS controller at the service broker when performing service-related requests. The parameter is mandatory if create-service-broker: true.
                  "%
                  | optional,
                stack
                  | String
                  | doc m%"
                  Use this parameter to define which prebuilt root file system (rootfs) you want to use.
                  "%
                  | optional,
                tasks
                  | definitions.contract.module-parameters-tasks
                  | doc m%"
                  Specify tasks, which are available for execution in the current droplet of the application. Also provide use of environment variables which are specified with the env scope.
                  "%
                  | optional,
                upload-timeout
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The application upload timeout in seconds.
                  "%
                  | optional,
                ..
              },
          module-parameters-buildpacks = predicates.contract_from_predicate
              definitions.predicate.module-parameters-buildpacks,
          module-parameters-docker = {
                image
                  | String
                  | doc m%"
                  An image parameter is a docker image from the Docker Hub or somewhere else. eg. cloudfoundry/test-app
                  "%
                  | optional,
                password
                  | String
                  | doc m%"
                  The password is optional, but if a Docker image from a private repository is uploaded, then it is mandatory.
                  "%
                  | optional,
                username
                  | String
                  | doc m%"
                  The username is optional, but if a Docker image from a private repository is uploaded, then it is mandatory.
                  "%
                  | optional,
                ..
              },
          module-parameters-domains = predicates.contract_from_predicate
              definitions.predicate.module-parameters-domains,
          module-parameters-hosts = predicates.contract_from_predicate
              definitions.predicate.module-parameters-hosts,
          module-parameters-keep-existing = {
                env
                  | Bool
                  | doc m%"
                  Keep the existing environment
                  "%
                  | optional,
                routes
                  | Bool
                  | doc m%"
                  Keep the existing routes
                  "%
                  | optional,
                service-bindings
                  | Bool
                  | doc m%"
                  Keep the existing Service bindings
                  "%
                  | optional,
                ..
              },
          module-parameters-restart-on-env-change =
            predicates.contract_from_predicate
              definitions.predicate.module-parameters-restart-on-env-change,
          module-parameters-routes = predicates.contract_from_predicate
              definitions.predicate.module-parameters-routes,
          module-parameters-tasks = predicates.contract_from_predicate
              definitions.predicate.module-parameters-tasks,
          module-provides = predicates.contract_from_predicate
              definitions.predicate.module-provides,
          module-provides-parameters = {
                visibility
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.resource-configuration-target
                  ])
                  | optional,
                ..
              },
          module-requires = predicates.contract_from_predicate
              definitions.predicate.module-requires,
          module-requires-parameters = {
                content-target
                  | Bool
                  | doc m%"
                  Specify that the resource would be used as a target for the module content deployment.
                  "%
                  | optional,
                ..
              },
          module-type = predicates.contract_from_predicate
              definitions.predicate.module-type,
          properties-metadata = predicates.contract_from_predicate
              definitions.predicate.properties-metadata,
          resource-configuration-target = {
                org
                  | String
                  | doc m%"
                  The org in which the configuration will be looked for
                  "%
                  | optional,
                space
                  | String
                  | doc m%"
                  The space in which the configuration will be looked for
                  "%
                  | optional,
                ..
              },
          resource-parameters = {
                config
                  | {  .. }
                  | doc m%"
                  Map value, containing the service creation configuration, for example, url and user credentials (user and password).
                  "%
                  | optional,
                provider-id
                  | String
                  | doc m%"
                  The resource from the provider MTA <mta-id>:<mta-provides-dependency-name>.
                  "%
                  | optional,
                provider-nid
                  | std.enum.TagOrString
                  | [| 'mta |]
                  | doc m%"
                  When used for cross-MTA dependency resolution the provider-nid is always 'mta'.
                  "%
                  | optional,
                service
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.anyOf
                    [
                      predicates.enum
                      [
                        "application-logs",
                        "auditlog",
                        "rabbitmq",
                        "autoscaler",
                        "portal-services",
                        "fs-storage",
                        "hana",
                        "jobscheduler",
                        "xsuaa",
                        "connectivity",
                        "destination",
                        "feature-flags",
                        "redis",
                        "ml-foundation-services",
                        "mongodb",
                        "objectstore",
                        "postgresql"
                      ],
                      predicates.isType '"String"
                    ]
                  ])
                  | doc m%"
                  Name of the service to create.
                  "%
                  | optional,
                service-broker
                  | String
                  | doc m%"
                  The name of the service broker to be used.
                  "%
                  | optional,
                service-key-name
                  | String
                  | doc m%"
                  Used when consuming an existing service key. Specifies the name of the service key. See Consumption of existing service keys for more information.
                  "%
                  | optional,
                service-name
                  | String
                  | doc m%"
                  Service instance name. Default value is the resource name.
                  "%
                  | optional,
                service-plan
                  | String
                  | doc m%"
                  Name of the service plan to be used.
                  "%
                  | optional,
                service-tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Some services employ a list of custom tags, which provide an easier way for applications to parse <VCAP_SERVICES> for credentials. You can provide custom tags when creating a service instance. For more information, see Service Tags.
                  "%
                  | optional,
                siteId
                  | String
                  | doc m%"
                  A globally unique ID (GUID) for your Fiori LaunchPad site.
                  "%
                  | optional,
                skip-service-updates
                  | definitions.contract.resource-skip-service-updates
                  | doc m%"
                  Map value, containing the service components (parameters, plan, tags) to skip when updating a service.
                  "%
                  | optional,
                syslog-drain-url
                  | String
                  | doc m%"
                  URL to which logs for bound applications are streamed.
                  "%
                  | optional,
                target
                  | definitions.contract.resource-configuration-target
                  | doc m%"
                  The name of the organization and space in which the provider MTA is deployed.
                  "%
                  | optional,
                version
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(-(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?$"
                  ])
                  | doc m%"
                  The version of the provider MTA.
                  "%
                  | optional,
                ..
              },
          resource-requires = predicates.contract_from_predicate
              definitions.predicate.resource-requires,
          resource-skip-service-updates = {
                parameters
                  | Bool
                  | doc m%"
                  The configuration parameters which will be passed to the service broker.
                  "%
                  | optional,
                plan
                  | Bool
                  | doc m%"
                  The service plan.
                  "%
                  | optional,
                syslog-drain-url
                  | Bool
                  | doc m%"
                  URL to which logs for bound applications are streamed.
                  "%
                  | optional,
                tags
                  | Bool
                  | doc m%"
                  The custom tags for a service instance.
                  "%
                  | optional,
                ..
              },
          resource-type = predicates.contract_from_predicate
              definitions.predicate.resource-type,
        },
    predicate = {
          generic-memory = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[1-9][0-9]*(M|MB|G|GB|m|mb|g|gb)$"
              ],
          hooks = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name", "type" ],
                  predicates.records.record
                  {
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                        ],
                    parameters = definitions.predicate.hooks-parameters,
                    parameters-metadata =
                      definitions.predicate.properties-metadata,
                    phases = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [
                              "application.before-stop.live",
                              "application.before-stop.idle",
                              "application.after-stop.live",
                              "application.after-stop.idle",
                              "application.before-unmap-routes",
                              "deploy.application.before-stop",
                              "blue-green.application.before-stop.idle",
                              "blue-green.application.before-stop.live",
                              "deploy.application.after-stop",
                              "blue-green.application.after-stop.idle",
                              "blue-green.application.after-stop.live",
                              "deploy.application.before-unmap-routes",
                              "blue-green.application.before-unmap-routes.live",
                              "blue-green.application.before-unmap-routes.idle",
                              "deploy.application.before-start",
                              "blue-green.application.before-start.idle",
                              "blue-green.application.before-start.live"
                            ]
                          ])
                        ],
                    requires = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "name" ],
                            predicates.records.record
                            {
                              name = predicates.allOf
                                  [
                                    predicates.isType '"String",
                                    predicates.strings.pattern
                                    "^[A-Za-z0-9_\\-\\.]+$"
                                  ],
                              parameters = predicates.isType 'Record,
                              parameters-metadata =
                                definitions.predicate.properties-metadata,
                            }
                            {  }
                            true
                            predicates.always
                          ])
                        ],
                    type = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "task" ]
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          hooks-parameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "command" ],
                predicates.records.record
                {
                  command = predicates.isType '"String",
                  disk-quota = definitions.predicate.generic-memory,
                  memory = definitions.predicate.generic-memory,
                  name = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          module-parameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  app-name = predicates.isType '"String",
                  buildpack = predicates.isType '"String",
                  buildpacks =
                    definitions.predicate.module-parameters-buildpacks,
                  command = predicates.isType '"String",
                  create-service-broker = predicates.isType '"Bool",
                  dependency-type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "hard", "soft" ]
                      ],
                  disk-quota = definitions.predicate.generic-memory,
                  docker = definitions.predicate.module-parameters-docker,
                  domain = predicates.isType '"String",
                  domains = definitions.predicate.module-parameters-domains,
                  enable-ssh = predicates.isType '"Bool",
                  health-check-http-endpoint = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "^/.+"
                      ],
                  health-check-invocation-timeout = predicates.isType 'Integer,
                  health-check-timeout = predicates.isType 'Integer,
                  health-check-type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "port", "process", "http" ]
                      ],
                  host = predicates.isType '"String",
                  hosts = definitions.predicate.module-parameters-hosts,
                  idle-domain = predicates.isType '"String",
                  idle-domains =
                    definitions.predicate.module-parameters-domains,
                  idle-host = predicates.isType '"String",
                  idle-hosts = definitions.predicate.module-parameters-hosts,
                  instances = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  keep-existing =
                    definitions.predicate.module-parameters-keep-existing,
                  keep-existing-routes = predicates.isType '"Bool",
                  memory = definitions.predicate.generic-memory,
                  no-route = predicates.isType '"Bool",
                  no-start = predicates.isType '"Bool",
                  restart-on-env-change =
                    definitions.predicate.module-parameters-restart-on-env-change,
                  routes = definitions.predicate.module-parameters-routes,
                  service-broker-name = predicates.isType '"String",
                  service-broker-password = predicates.isType '"String",
                  service-broker-space-scoped = predicates.isType '"Bool",
                  service-broker-url = predicates.isType '"String",
                  service-broker-user = predicates.isType '"String",
                  stack = predicates.isType '"String",
                  tasks = definitions.predicate.module-parameters-tasks,
                  upload-timeout = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                true
                predicates.always
              ],
          module-parameters-buildpacks = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          module-parameters-docker = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  image = predicates.isType '"String",
                  password = predicates.isType '"String",
                  username = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          module-parameters-domains = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          module-parameters-hosts = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          module-parameters-keep-existing = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  env = predicates.isType '"Bool",
                  routes = predicates.isType '"Bool",
                  service-bindings = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          module-parameters-restart-on-env-change = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.records.record
                {
                  user-provided = predicates.isType '"Bool",
                  vcap-application = predicates.isType '"Bool",
                  vcap-services = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always)
              ],
          module-parameters-routes = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "route" ],
                  predicates.records.record
                  { route = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always
                ])
              ],
          module-parameters-tasks = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "command", "name" ],
                  predicates.records.record
                  {
                    command = predicates.isType '"String",
                    disk-quota = definitions.predicate.generic-memory,
                    memory = definitions.predicate.generic-memory,
                    name = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          module-provides = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                        ],
                    parameters =
                      definitions.predicate.module-provides-parameters,
                    parameters-metadata =
                      definitions.predicate.properties-metadata,
                    properties = predicates.isType 'Record,
                    properties-metadata =
                      definitions.predicate.properties-metadata,
                    public = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          module-provides-parameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  visibility = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.resource-configuration-target
                      ],
                }
                {  }
                true
                predicates.always
              ],
          module-requires = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    list = predicates.isType '"String",
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                        ],
                    parameters =
                      definitions.predicate.module-requires-parameters,
                    parameters-metadata =
                      definitions.predicate.properties-metadata,
                    properties = predicates.isType 'Record,
                    properties-metadata =
                      definitions.predicate.properties-metadata,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          module-requires-parameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { content-target = predicates.isType '"Bool", }
                {  }
                true
                predicates.always
              ],
          module-type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.anyOf
                [
                  predicates.enum
                  [
                    "application",
                    "binary",
                    "business-logging",
                    "com.sap.application.content",
                    "com.sap.html5.application-content",
                    "com.sap.portal.site-content",
                    "com.sap.xs.hdi",
                    "com.sap.xs.hdi-dynamic",
                    "custom",
                    "dotnet_core",
                    "go",
                    "java",
                    "java.tomcat",
                    "java.tomee",
                    "javascript.nodejs",
                    "nodejs",
                    "php",
                    "python",
                    "ruby",
                    "staticfile"
                  ],
                  predicates.isType '"String"
                ]
              ],
          properties-metadata = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    "optional" = predicates.isType '"Bool",
                    overwritable = predicates.isType '"Bool",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          resource-configuration-target = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  org = predicates.isType '"String",
                  space = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          resource-parameters = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  config = predicates.isType 'Record,
                  provider-id = predicates.isType '"String",
                  provider-nid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "mta" ]
                      ],
                  service = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.anyOf
                        [
                          predicates.enum
                          [
                            "application-logs",
                            "auditlog",
                            "rabbitmq",
                            "autoscaler",
                            "portal-services",
                            "fs-storage",
                            "hana",
                            "jobscheduler",
                            "xsuaa",
                            "connectivity",
                            "destination",
                            "feature-flags",
                            "redis",
                            "ml-foundation-services",
                            "mongodb",
                            "objectstore",
                            "postgresql"
                          ],
                          predicates.isType '"String"
                        ]
                      ],
                  service-broker = predicates.isType '"String",
                  service-key-name = predicates.isType '"String",
                  service-name = predicates.isType '"String",
                  service-plan = predicates.isType '"String",
                  service-tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  siteId = predicates.isType '"String",
                  skip-service-updates =
                    definitions.predicate.resource-skip-service-updates,
                  syslog-drain-url = predicates.isType '"String",
                  target = definitions.predicate.resource-configuration-target,
                  version = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(-(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?$"
                      ],
                }
                {  }
                true
                predicates.always
              ],
          resource-requires = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "name" ],
                  predicates.records.record
                  {
                    name = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
                        ],
                    parameters = predicates.isType 'Record,
                    parameters-metadata =
                      definitions.predicate.properties-metadata,
                    properties = predicates.isType 'Record,
                    properties-metadata =
                      definitions.predicate.properties-metadata,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          resource-skip-service-updates = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parameters = predicates.isType '"Bool",
                  plan = predicates.isType '"Bool",
                  syslog-drain-url = predicates.isType '"Bool",
                  tags = predicates.isType '"Bool",
                }
                {  }
                true
                predicates.always
              ],
          resource-type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.anyOf
                [
                  predicates.enum
                  [
                    "org.cloudfoundry.managed-service",
                    "org.cloudfoundry.existing-service",
                    "org.cloudfoundry.existing-service-key",
                    "org.cloudfoundry.user-provided-service",
                    "configuration"
                  ],
                  predicates.isType '"String"
                ]
              ],
        },
  }
in

{
  ID
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
    ])
    | doc m%"
    A globally unique ID of this MTA. Unlimited string of unicode characters.
    "%,
  _schema-version
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern "^(\\d+\\.)?(\\d+\\.)?(\\*|\\d+)$"
    ])
    | doc m%"
    Used to indicate to an MTA processing tool (e.g. a deployer), which schema version was taken as the base when authoring a descriptor.
    "%,
  copyright
    | String
    | doc m%"
    A copyright statement from the provider.
    "%
    | optional,
  description
    | String
    | doc m%"
    A non-translatable description of this MTA. This is not a text for application users.
    "%
    | optional,
  hooks
    | definitions.contract.hooks
    | doc m%"
    A list of hooks that will be executed for the MTA.
    "%
    | optional,
  module-types
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "extends", "name" ],
        predicates.records.record
        {
          extends = predicates.isType '"String",
          name = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
              ],
          parameters = predicates.isType 'Record,
          parameters-metadata = definitions.predicate.properties-metadata,
          properties = predicates.isType 'Record,
          properties-metadata = definitions.predicate.properties-metadata,
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    A list of custom module type definitions that will be used by the MTA application.
    "%
    | optional,
  modules
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "name", "type" ],
        predicates.records.record
        {
          deployed-after = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          description = predicates.isType '"String",
          hooks = definitions.predicate.hooks,
          name = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
              ],
          parameters = definitions.predicate.module-parameters,
          parameters-metadata = definitions.predicate.properties-metadata,
          path = predicates.isType '"String",
          properties = predicates.isType 'Record,
          properties-metadata = definitions.predicate.properties-metadata,
          provides = definitions.predicate.module-provides,
          requires = definitions.predicate.module-requires,
          type = definitions.predicate.module-type,
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    A list of modules to be deployed by the MTA application.
    "%
    | optional,
  parameters
    | {  .. }
    | doc m%"
    Global parameters related to the MTA application.
    "%
    | optional,
  parameters-metadata
    | definitions.contract.properties-metadata
    | doc m%"
    Additional information about the MTA's parameters.
    "%
    | optional,
  provider
    | String
    | doc m%"
    The provider or vendor of this software.
    "%
    | optional,
  resource-types
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "extends", "name" ],
        predicates.records.record
        {
          extends = predicates.isType '"String",
          name = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
              ],
          parameters = predicates.isType 'Record,
          parameters-metadata = definitions.predicate.properties-metadata,
          properties = predicates.isType 'Record,
          properties-metadata = definitions.predicate.properties-metadata,
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    A list of custom resource type definitions that will be used by the MTA application.
    "%
    | optional,
  resources
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "name" ],
        predicates.records.record
        {
          active = predicates.isType '"Bool",
          description = predicates.isType '"String",
          hooks = definitions.predicate.hooks,
          name = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[A-Za-z0-9_\\-\\.]+$"
              ],
          "optional" = predicates.isType '"Bool",
          parameters = definitions.predicate.resource-parameters,
          parameters-metadata = definitions.predicate.properties-metadata,
          processed-after = predicates.allOf
              [
                predicates.isType '"Array",
                predicates.arrays.arrayOf (predicates.isType '"String")
              ],
          properties = predicates.isType 'Record,
          properties-metadata = definitions.predicate.properties-metadata,
          requires = definitions.predicate.resource-requires,
          type = definitions.predicate.resource-type,
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    A list of resources to be deployed by the MTA application.
    "%
    | optional,
  version
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"String",
      predicates.strings.pattern
      "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(-(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(\\.(0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*)?(\\+[0-9a-zA-Z-]+(\\.[0-9a-zA-Z-]+)*)?$"
    ])
    | doc m%"
    Application version. Shall follow the semantic versioning standard.
    "%,
  ..
}