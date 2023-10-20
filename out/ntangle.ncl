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
          Join
            | doc m%"
            The 'Join' object defines a join to another (or same) table within the logical CDC entity.  The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required.
            "%
            = {
                alias
                  | String
                  | doc m%"
                  Will automatically default where not specified.
                  "%
                  | optional,
                aliasColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each alias value should be formatted as 'Column' + '^' + 'Alias'; e.g. 'PCODE^ProductCode'
                  "%
                  | optional,
                cdcEnable
                  | Bool
                  | doc m%"
                  Defaults to 'false'. This option can be overridden for each underlying table referenced.
                  "%
                  | optional,
                excludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates no 'Columns' are to be excluded.
                  "%
                  | optional,
                excludeColumnsFromETag
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Defaults to 'CodeGeneration.CdcExcludeColumnsFromETag'.
                  "%
                  | optional,
                identifierMapping
                  | Bool
                  | doc m%"
                  This indicates whether to create a new 'GlobalId' property on the _entity_ to house the global mapping identifier to be the reference outside of the specific database realm as a replacement to the existing primary key column(s).
                  "%
                  | optional,
                identifierName
                  | String
                  | doc m%"
                  This indicates whether to create a new 'GlobalId' property on the _entity_ to house the global mapping identifier to be the reference outside of the specific database realm as a replacement to the existing primary key column(s).
                  "%
                  | optional,
                includeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that all 'Columns' are to be included.
                  "%
                  | optional,
                includeColumnsOnDelete
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where a column is not specified in this list its corresponding .NET property will be automatically cleared by the 'CdcDataOrchestrator' as the data is technically considered as non-existing.
                  "%
                  | optional,
                joinCardinality
                  | std.enum.TagOrString
                  | [| 'OneToOne, 'OneToMany |]
                  | doc m%"
                  Defaults to 'OneToMany'. This represents the Parent ('JoinTo') to child (_this_) relationship.
                  "%
                  | optional,
                joinTo
                  | String
                  | doc m%"
                  Defaults to parent 'Table.Name'.
                  "%
                  | optional,
                mappings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.JoinMapping
                  ])
                  | optional,
                model
                  | String
                  | doc m%"
                  Defaults to 'Name'.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A unique name is required where the same 'Table' is referenced more than once within a logical CDC entity. However, generally, this will represent the unique name of the table within the database.
                  "%,
                on
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.JoinOn
                  ])
                  | optional,
                property
                  | String
                  | doc m%"
                  Defaults to 'Model' where 'JoinCardinality' is 'OneToOne'; otherwise, it will be the 'Model' pluralized.
                  "%
                  | optional,
                querySizeMultiplier
                  | Number
                  | doc m%"
                  Defaults to '1.0'. This is applied to the execute stored procedure '@MaxQuerySize' parameter to allow tailoring on the join query ('TOP') sizes to optimize selection. Must be greater than zero and less than or equal to 100.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'Cdc.Schema'; i.e. same schema.
                  "%
                  | optional,
                table
                  | String
                  | doc m%"
                  Defaults to 'Name'. This is used to specify the actual underlying database table name (required where the 'Name' has been changed to enable uniqueness).
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'Full, 'Right, 'Left, 'Inner, 'Cdc |]
                  | doc m%"
                  Defaults to 'Cdc'. The 'Cdc' value indicates this is a related secondary table (within a logical CDC entity) that also has Change Data Capture turned on and equally needs to be monitored for changes.
                  "%
                  | optional,
                ..
              },
          JoinMapping
            | doc m%"
            The 'JoinMapping' object defines one or more related table identifier mappings.
            "%
            = {
                name | String,
                schema
                  | String
                  | doc m%"
                  Defaults to the owning (parent) table schema.
                  "%
                  | optional,
                table | String,
                ..
              },
          JoinOn
            | doc m%"
            The 'JoinOn' object defines the join on characteristics for a 'Join' object.
            "%
            = {
                name | String,
                toColumn
                  | String
                  | doc m%"
                  Defaults to 'Name'; i.e. assumes same name.
                  "%
                  | optional,
                toStatement | String | optional,
                ..
              },
          Root
            | doc m%"
            The 'RootConfig' object defines the global properties that are used to drive the underlying database-driven CDC-oriented code-generation.
            "%
            = {
                autoDotNetRename
                  | std.enum.TagOrString
                  | [| 'SnakeKebabToPascalCase, 'PascalCase, 'None |]
                  | doc m%"
                  Defaults to 'SnakeKebabToPascalCase' which will remove any underscores or hyphens separating each word and capitalize the first character of each; e.g. 'internal-customer_id' would be renamed as 'InternalCustomerId'. The 'PascalCase' option will capatilize the first character only.
                  "%
                  | optional,
                cdcEnable
                  | Bool
                  | doc m%"
                  Defaults to 'false'. This option can be overridden for each underlying table referenced.
                  "%
                  | optional,
                cdcSchema
                  | String
                  | doc m%"
                  Defaults to 'NTangle' (literal).
                  "%
                  | optional,
                cdcSchemaCreate
                  | Bool
                  | doc m%"
                  Defaults to 'false'.
                  "%
                  | optional,
                eventActionFormat
                  | std.enum.TagOrString
                  | [| 'PastTense, 'None |]
                  | doc m%"
                  Defaults to 'None' (no formatting required, i.e. as-is).
                  "%
                  | optional,
                eventSourceFormat
                  | std.enum.TagOrString
                  | [| 'NameAndTableKey, 'NameAndKey, 'NameOnly |]
                  | doc m%"
                  Defaults to 'NameAndTableKey' (being the child 'Cdc.ModelName' appended with the corresponding table key).
                  "%
                  | optional,
                eventSourceKind
                  | std.enum.TagOrString
                  | [| 'RelativeOrAbsolute, 'Relative, 'Absolute, 'None |]
                  | doc m%"
                  Defaults to 'Relative' (being a relative path).
                  "%
                  | optional,
                eventSourceRoot
                  | String
                  | doc m%"
                  The event source is only updated where an 'EventSourceKind' is not 'None'.
                  "%
                  | optional,
                eventSubjectFormat
                  | std.enum.TagOrString
                  | [| 'NameAndTableKey, 'NameAndKey, 'NameOnly |]
                  | doc m%"
                  Defaults to 'NameOnly'.
                  "%
                  | optional,
                eventSubjectRoot
                  | String
                  | doc m%"
                  Used to enable the sending of messages to the likes of EventHubs, Service Broker, Kafka, etc.
                  "%
                  | optional,
                eventTypeRoot
                  | String
                  | doc m%"
                  Used to enable the sending of messages to the likes of EventHubs, Service Broker, Kafka, etc. Defaults to 'EventSubjectRoot'.
                  "%
                  | optional,
                excludeColumnsFromETag
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                identifierMapping
                  | Bool
                  | doc m%"
                  Where set to 'true' each underlying 'Table' and corresponding 'Join' must set 'IdentifierMapping' explicitly.
                  "%
                  | optional,
                identifierMappingStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'spIdentifierMappingCreate' (literal).
                  "%
                  | optional,
                identifierMappingTable
                  | String
                  | doc m%"
                  Defaults to 'IdentifierMapping' (literal).
                  "%
                  | optional,
                identifierMappingType
                  | std.enum.TagOrString
                  | [| 'Guid, 'Long, 'Int, '"String" |]
                  | doc m%"
                  Defaults to 'String'.
                  "%
                  | optional,
                isDeletedColumn
                  | String
                  | doc m%"
                  Defaults to 'IsDeleted'.
                  "%
                  | optional,
                jsonSerializer
                  | std.enum.TagOrString
                  | [| 'Newtonsoft, 'SystemText |]
                  | doc m%"
                  Defaults to 'SystemText'.
                  "%
                  | optional,
                namespaceBase
                  | String
                  | doc m%"
                  Defaults to 'AppName' (runtime parameter). For example 'Avanade.Application'.
                  "%
                  | optional,
                namespaceOutbox
                  | String
                  | doc m%"
                  Defaults to 'NamespacePublisher'.
                  "%
                  | optional,
                namespacePublisher
                  | String
                  | doc m%"
                  Defaults to 'NamespaceBase' + '.Publisher' (literal). For example 'Avanade.Application.Publisher'.
                  "%
                  | optional,
                outbox
                  | Bool
                  | doc m%"
                  Defaults to 'false'.
                  "%
                  | optional,
                outboxDequeueStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'spEventOutboxDequeue' (literal).
                  "%
                  | optional,
                outboxEnqueueStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'spEventOutboxEnqueue' (literal).
                  "%
                  | optional,
                outboxSchema
                  | String
                  | doc m%"
                  Defaults to 'Outbox' (literal).
                  "%
                  | optional,
                outboxSchemaCreate
                  | Bool
                  | doc m%"
                  Defaults to 'false'.
                  "%
                  | optional,
                outboxTable
                  | String
                  | doc m%"
                  Defaults to 'EventOutbox' (literal).
                  "%
                  | optional,
                pathBase
                  | String
                  | doc m%"
                  Defaults to 'AppName' (runtime parameter). For example 'Avanade.Application'.
                  "%
                  | optional,
                pathDatabase
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.Database' (literal). For example 'Avanade.Application.Database'.
                  "%
                  | optional,
                pathDatabaseMigrations
                  | String
                  | doc m%"
                  Defaults to 'PathDatabase' + '/Migrations' (literal). For example 'Avanade.Application.Database/Migrations'.
                  "%
                  | optional,
                pathDatabaseSchema
                  | String
                  | doc m%"
                  Defaults to 'PathDatabase' + '/Schema' (literal). For example 'Avanade.Application.Database/Schema'.
                  "%
                  | optional,
                pathDotNetPublisher
                  | String
                  | doc m%"
                  Defaults to 'PathBase' + '.Publisher' (literal). For example 'Avanade.Application.Publisher'.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  This is used as the default 'Schema' for all child objects. Defaults to 'dbo' (literal).
                  "%
                  | optional,
                service
                  | std.enum.TagOrString
                  | [| 'Service, 'HostedService, 'None |]
                  | doc m%"
                  Defaults to 'None'. A 'HostedService' is an 'IHostedService' implementation enabling long-running execution; whereas, 'Service' is intended for self-managed execution.
                  "%
                  | optional,
                tables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Table
                  ])
                  | doc m%"
                  A 'Table' object provides the primary database table configuration for Change Data Capture (CDC), including multiple child table joins to form a composite entity.
                  "%
                  | optional,
                versionTrackingTable
                  | String
                  | doc m%"
                  Defaults to 'VersionTracking' (literal).
                  "%
                  | optional,
                ..
              },
          Table
            | doc m%"
            The 'Table' object enables the definition of the primary table, one-or-more child tables and their respective join relationships, to enable Change Data Capture (CDC) event publishing. The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required.
            "%
            = {
                alias
                  | String
                  | doc m%"
                  Will automatically default where not specified; for example a table named 'Person' will default to 'p'.
                  "%
                  | optional,
                aliasColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each alias value should be formatted as 'Column' + '^' + 'Alias'; e.g. 'PCODE^ProductCode'.
                  "%
                  | optional,
                batchTrackingTable
                  | String
                  | doc m%"
                  Defaults to 'Name' + 'BatchTracking' (literal).
                  "%
                  | optional,
                cdcEnable
                  | Bool
                  | doc m%"
                  Defaults to 'false'. This option can be overridden for each underlying table referenced.
                  "%
                  | optional,
                cdcSchema
                  | String
                  | doc m%"
                  Defaults to 'Root.CdcSchema'.
                  "%
                  | optional,
                completeStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'sp' (literal) + 'Name' + 'BatchComplete' (literal); e.g. 'spNameBatchComplete'.
                  "%
                  | optional,
                database
                  | String
                  | doc m%"
                  Defaults to 'IDatabase'.
                  "%
                  | optional,
                eventSource
                  | String
                  | doc m%"
                  Defaults to 'Schema' + '/' (literal) + 'Name' (as lowercase). Note: when used in code-generation the 'Root.EventSourceRoot' will be prepended where specified.
                  "%
                  | optional,
                eventSourceFormat
                  | std.enum.TagOrString
                  | [| 'NameAndTableKey, 'NameAndKey, 'NameOnly |]
                  | doc m%"
                  Defaults to 'Root.EventSourceFormat'.
                  "%
                  | optional,
                eventSubject
                  | String
                  | doc m%"
                  Defaults to 'ModelName'. Note: when used in code-generation the 'Root.EventSubjectRoot' will be prepended where specified.
                  "%
                  | optional,
                eventSubjectFormat
                  | std.enum.TagOrString
                  | [| 'NameAndTableKey, 'NameAndKey, 'NameOnly |]
                  | doc m%"
                  Defaults to 'Root.EventSubjectFormat'.
                  "%
                  | optional,
                eventType
                  | String
                  | doc m%"
                  Defaults to 'ModelName'. Note: when used in code-generation the 'Root.EventTypeRoot' will be prepended where specified.
                  "%
                  | optional,
                excludeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates no 'Columns' are to be excluded.
                  "%
                  | optional,
                excludeColumnsFromETag
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Defaults to 'Root.CdcExcludeColumnsFromETag'.
                  "%
                  | optional,
                executeStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'sp' (literal) + 'Name' + 'BatchExecute' (literal); e.g. 'spNameBatchExecute'.
                  "%
                  | optional,
                identifierMapping
                  | Bool
                  | doc m%"
                  This indicates whether to create a new 'GlobalId' property on the _entity_ to house the global mapping identifier to be the reference outside of the specific database realm as a replacement to the existing primary key column(s).
                  "%
                  | optional,
                identifierName
                  | String
                  | doc m%"
                  This indicates whether to create a new 'GlobalId' property on the _entity_ to house the global mapping identifier to be the reference outside of the specific database realm as a replacement to the existing primary key column(s).
                  "%
                  | optional,
                includeColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where not specified this indicates that all 'Columns' are to be included.
                  "%
                  | optional,
                includeColumnsOnDelete
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Where a column is not specified in this list its corresponding .NET property will be automatically cleared by the 'CdcDataOrchestrator' as the data is technically considered as non-existing.
                  "%
                  | optional,
                isDeletedColumn
                  | String
                  | doc m%"
                  Defaults to 'Root.ColumnIsDeleted'.
                  "%
                  | optional,
                joins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Join
                  ])
                  | doc m%"
                  A 'Join' object provides the configuration for a table join.
                  "%
                  | optional,
                mappings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.TableMapping
                  ])
                  | optional,
                model
                  | String
                  | doc m%"
                  Defaults to 'Name'.
                  "%
                  | optional,
                name | String,
                orchestratorCtorParams
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Each constructor parameter should be formatted as 'Type' + '^' + 'Name'; e.g. 'IConfiguration^Config'. Where the 'Name' portion is not specified it will be inferred.
                  "%
                  | optional,
                partitionKey
                  | String
                  | doc m%"
                  A partition key can be specified using either 'PartitionKey' or 'PartitionKeyColumns'.
                  "%
                  | optional,
                partitionKeyColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  A partition key can be specified using either 'PartitionKey' or 'PartitionKeyColumns'.
                  "%
                  | optional,
                resetStoredProcedure
                  | String
                  | doc m%"
                  Defaults to 'sp' (literal) + 'Name' + 'BatchReset' (literal); e.g. 'spNameBatchReset'.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  Defaults to 'Root.Schema'.
                  "%
                  | optional,
                service
                  | std.enum.TagOrString
                  | [| 'Service, 'HostedService, 'None |]
                  | doc m%"
                  Defaults to 'Root.Service'. A 'HostedService' is an 'IHostedService' implementation enabling long-running execution; whereas, 'Service' is intended for self-managed execution.
                  "%
                  | optional,
                table
                  | String
                  | doc m%"
                  Defaults to 'Name'. This is used to specify the actual underlying database table name (required where the 'Name' has been changed to enable uniqueness).
                  "%
                  | optional,
                tenantIdColumns
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | optional,
                where
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Where
                  ])
                  | doc m%"
                  A 'Where' object provides the configuration for a table where clause.
                  "%
                  | optional,
                ..
              },
          TableMapping
            | doc m%"
            The 'TableMapping' object defines one or more related table identifier mappings.
            "%
            = {
                name | String,
                schema
                  | String
                  | doc m%"
                  Defaults to the owning (parent) table schema.
                  "%
                  | optional,
                table | String,
                ..
              },
          Where
            | doc m%"
            This should only be used where the column value is largely immutable; otherwise, unintended side-effects may occur. _NTangle_ uses the condition explictily and does not attempt to handle value change to infer creation or deletion of data as a result of the underlying change; as such, this should be used cautiously. Note that the 'where' is applied when querying the 'cdc.fn_cdc_get_all_changes_...' function, not the underlying table itself.
            "%
            = {
                name
                  | String
                  | doc m%"
                  The column name.
                  "%,
                nullable
                  | std.enum.TagOrString
                  | [| 'ISNOTNULL, 'ISNULL |]
                  | doc m%"
                  This enables statements such as 'WHERE (COL IS NULL)' or 'WHERE (COL IS NULL OR COL = VALUE)' (where .
                  "%
                  | optional,
                operator
                  | std.enum.TagOrString
                  | [| 'LIKE, 'GE, 'GT, 'LE, 'LT, 'NE, 'EQ |]
                  | doc m%"
                  Defaults to 'EQ' where 'Value' is specified.
                  "%
                  | optional,
                value
                  | String
                  | doc m%"
                  This must be valid formatted/escaped SQL.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          Join
            | doc m%"
            The 'Join' object defines a join to another (or same) table within the logical CDC entity.  The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  aliasColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  cdcEnable = predicates.isType '"Bool",
                  excludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  excludeColumnsFromETag = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  identifierMapping = predicates.isType '"Bool",
                  identifierName = predicates.isType '"String",
                  includeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeColumnsOnDelete = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  joinCardinality = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "OneToMany", "OneToOne" ]
                      ],
                  joinTo = predicates.isType '"String",
                  mappings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.JoinMapping
                      ],
                  model = predicates.isType '"String",
                  name = predicates.isType '"String",
                  on = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.JoinOn
                      ],
                  property = predicates.isType '"String",
                  querySizeMultiplier = predicates.isType '"Number",
                  schema = predicates.isType '"String",
                  table = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "Cdc", "Inner", "Left", "Right", "Full" ]
                      ],
                }
                {  }
                true
                predicates.always
              ],
          JoinMapping
            | doc m%"
            The 'JoinMapping' object defines one or more related table identifier mappings.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "table" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  table = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          JoinOn
            | doc m%"
            The 'JoinOn' object defines the join on characteristics for a 'Join' object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  toColumn = predicates.isType '"String",
                  toStatement = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Root
            | doc m%"
            The 'RootConfig' object defines the global properties that are used to drive the underlying database-driven CDC-oriented code-generation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autoDotNetRename = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "None", "PascalCase", "SnakeKebabToPascalCase" ]
                      ],
                  cdcEnable = predicates.isType '"Bool",
                  cdcSchema = predicates.isType '"String",
                  cdcSchemaCreate = predicates.isType '"Bool",
                  eventActionFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "PastTense" ]
                      ],
                  eventSourceFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "NameOnly", "NameAndKey", "NameAndTableKey" ]
                      ],
                  eventSourceKind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "None", "Absolute", "Relative", "RelativeOrAbsolute" ]
                      ],
                  eventSourceRoot = predicates.isType '"String",
                  eventSubjectFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "NameOnly", "NameAndKey", "NameAndTableKey" ]
                      ],
                  eventSubjectRoot = predicates.isType '"String",
                  eventTypeRoot = predicates.isType '"String",
                  excludeColumnsFromETag = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  identifierMapping = predicates.isType '"Bool",
                  identifierMappingStoredProcedure = predicates.isType
                      '"String",
                  identifierMappingTable = predicates.isType '"String",
                  identifierMappingType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "String", "Int", "Long", "Guid" ]
                      ],
                  isDeletedColumn = predicates.isType '"String",
                  jsonSerializer = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "SystemText", "Newtonsoft" ]
                      ],
                  namespaceBase = predicates.isType '"String",
                  namespaceOutbox = predicates.isType '"String",
                  namespacePublisher = predicates.isType '"String",
                  outbox = predicates.isType '"Bool",
                  outboxDequeueStoredProcedure = predicates.isType '"String",
                  outboxEnqueueStoredProcedure = predicates.isType '"String",
                  outboxSchema = predicates.isType '"String",
                  outboxSchemaCreate = predicates.isType '"Bool",
                  outboxTable = predicates.isType '"String",
                  pathBase = predicates.isType '"String",
                  pathDatabase = predicates.isType '"String",
                  pathDatabaseMigrations = predicates.isType '"String",
                  pathDatabaseSchema = predicates.isType '"String",
                  pathDotNetPublisher = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  service = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "HostedService", "Service" ]
                      ],
                  tables = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Table
                      ],
                  versionTrackingTable = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Table
            | doc m%"
            The 'Table' object enables the definition of the primary table, one-or-more child tables and their respective join relationships, to enable Change Data Capture (CDC) event publishing. The 'IncludeColumns' and 'ExcludeColumns' provide a shorthand to include or exclude selected columns; with the 'AliasColumns' providing a means to rename where required.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  alias = predicates.isType '"String",
                  aliasColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  batchTrackingTable = predicates.isType '"String",
                  cdcEnable = predicates.isType '"Bool",
                  cdcSchema = predicates.isType '"String",
                  completeStoredProcedure = predicates.isType '"String",
                  database = predicates.isType '"String",
                  eventSource = predicates.isType '"String",
                  eventSourceFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "NameOnly", "NameAndKey", "NameAndTableKey" ]
                      ],
                  eventSubject = predicates.isType '"String",
                  eventSubjectFormat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "NameOnly", "NameAndKey", "NameAndTableKey" ]
                      ],
                  eventType = predicates.isType '"String",
                  excludeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  excludeColumnsFromETag = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  executeStoredProcedure = predicates.isType '"String",
                  identifierMapping = predicates.isType '"Bool",
                  identifierName = predicates.isType '"String",
                  includeColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  includeColumnsOnDelete = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  isDeletedColumn = predicates.isType '"String",
                  joins = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Join
                      ],
                  mappings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.TableMapping
                      ],
                  model = predicates.isType '"String",
                  name = predicates.isType '"String",
                  orchestratorCtorParams = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  partitionKey = predicates.isType '"String",
                  partitionKeyColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  resetStoredProcedure = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  service = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "None", "HostedService", "Service" ]
                      ],
                  table = predicates.isType '"String",
                  tenantIdColumns = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  where = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Where
                      ],
                }
                {  }
                true
                predicates.always
              ],
          TableMapping
            | doc m%"
            The 'TableMapping' object defines one or more related table identifier mappings.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name", "table" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  schema = predicates.isType '"String",
                  table = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          Where
            | doc m%"
            This should only be used where the column value is largely immutable; otherwise, unintended side-effects may occur. _NTangle_ uses the condition explictily and does not attempt to handle value change to infer creation or deletion of data as a result of the underlying change; as such, this should be used cautiously. Note that the 'where' is applied when querying the 'cdc.fn_cdc_get_all_changes_...' function, not the underlying table itself.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  name = predicates.isType '"String",
                  nullable = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "ISNULL", "ISNOTNULL" ]
                      ],
                  operator = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum
                        [ "EQ", "NE", "LT", "LE", "GT", "GE", "LIKE" ]
                      ],
                  value = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate definitions.predicate.Root