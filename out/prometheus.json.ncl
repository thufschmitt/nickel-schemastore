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
          auth = predicates.contract_from_predicate definitions.predicate.auth,
          authorization
            | doc m%"
            Sets the `Authorization` header on every scrape request with the configured credentials.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.authorization,
          azure_sd_configs
            | doc m%"
            List of Azure service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.azure_sd_configs,
          basic_auth
            | doc m%"
            Sets the `Authorization` header on every remote write request with the configured username and password. password and password_file are mutually exclusive.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.basic_auth,
          bearer_token
            | doc m%"
            Sets the `Authorization` header on every scrape request with the configured bearer token. It is mutually exclusive with `bearer_token_file`.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.bearer_token,
          bearer_token_file
            | doc m%"
            Sets the `Authorization` header on every scrape request with the bearer token read from the configured file. It is mutually exclusive with `bearer_token`.
            "%
            = definitions.contract.filepath,
          consul_sd_configs
            | doc m%"
            List of Consul service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.consul_sd_configs,
          digitalocean_sd_configs
            | doc m%"
            List of DigitalOcean service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.digitalocean_sd_configs,
          dns_sd_configs
            | doc m%"
            List of DNS service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dns_sd_configs,
          docker_sd_configs
            | doc m%"
            List of Docker service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.docker_sd_configs,
          dockerswarm_sd_configs
            | doc m%"
            List of Docker Swarm service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.dockerswarm_sd_configs,
          duration = predicates.contract_from_predicate
              definitions.predicate.duration,
          ec2_sd_configs
            | doc m%"
            List of EC2 service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.ec2_sd_configs,
          eureka_sd_configs
            | doc m%"
            List of Eureka service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.eureka_sd_configs,
          file_sd_configs
            | doc m%"
            List of file service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.file_sd_configs,
          filepath = predicates.contract_from_predicate
              definitions.predicate.filepath,
          filepath_glob = String,
          gce_sd_configs
            | doc m%"
            List of GCE service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.gce_sd_configs,
          hetzner_sd_configs
            | doc m%"
            List of Hetzner service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.hetzner_sd_configs,
          http_sd_configs
            | doc m%"
            List of HTTP service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.http_sd_configs,
          kubernetes_sd_configs
            | doc m%"
            List of Kubernetes service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kubernetes_sd_configs,
          kuma_sd_configs
            | doc m%"
            List of Kuma service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.kuma_sd_configs,
          label_name = predicates.contract_from_predicate
              definitions.predicate.label_name,
          label_value = String,
          labels = predicates.contract_from_predicate
              definitions.predicate.labels,
          lightsail_sd_configs
            | doc m%"
            List of Lightsail service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.lightsail_sd_configs,
          linode_sd_configs
            | doc m%"
            List of Linode service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.linode_sd_configs,
          marathon_sd_configs
            | doc m%"
            List of Marathon service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.marathon_sd_configs,
          nerve_sd_configs
            | doc m%"
            List of AirBnB's Nerve service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.nerve_sd_configs,
          oauth2
            | doc m%"
            Optional OAuth 2.0 configuration. Cannot be used at the same time as basic_auth or authorization.
            "%
            = predicates.contract_from_predicate definitions.predicate.oauth2,
          openstack_sd_configs
            | doc m%"
            List of OpenStack service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.openstack_sd_configs,
          puppetdb_sd_configs
            | doc m%"
            List of PuppetDB service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.puppetdb_sd_configs,
          relabel_configs = predicates.contract_from_predicate
              definitions.predicate.relabel_configs,
          scaleway_sd_configs
            | doc m%"
            List of Scaleway service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.scaleway_sd_configs,
          scheme = predicates.contract_from_predicate
              definitions.predicate.scheme,
          serverset_sd_configs
            | doc m%"
            List of Zookeeper Serverset service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.serverset_sd_configs,
          sigv4
            | doc m%"
            Optionally configures AWS's Signature Verification 4 signing process to sign requests.
            "%
            = predicates.contract_from_predicate definitions.predicate.sigv4,
          static_configs
            | doc m%"
            List of labeled statically configured targets for this job.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.static_configs,
          tls_config = predicates.contract_from_predicate
              definitions.predicate.tls_config,
          triton_sd_configs
            | doc m%"
            List of Triton service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.triton_sd_configs,
          uyuni_sd_configs
            | doc m%"
            List of Uyuni service discovery configurations.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.uyuni_sd_configs,
        },
    predicate = {
          auth = predicates.allOf
              [
                predicates.ifThenElse
                (predicates.not
                (predicates.records.record
                { basic_auth = predicates.const null, }
                {  }
                true
                predicates.always))
                (predicates.records.record
                {
                  authorization = predicates.const null,
                  bearer_token = predicates.const null,
                  bearer_token_file = predicates.const null,
                  oauth2 = predicates.const null,
                  sigv4 = predicates.const null,
                }
                {  }
                true
                predicates.always)
                predicates.always,
                predicates.ifThenElse
                (predicates.not
                (predicates.records.record
                { authorization = predicates.const null, }
                {  }
                true
                predicates.always))
                (predicates.records.record
                {
                  basic_auth = predicates.const null,
                  bearer_token = predicates.const null,
                  bearer_token_file = predicates.const null,
                  oauth2 = predicates.const null,
                  sigv4 = predicates.const null,
                }
                {  }
                true
                predicates.always)
                predicates.always,
                predicates.ifThenElse
                (predicates.not
                (predicates.records.record { sigv4 = predicates.const null, }
                {  }
                true
                predicates.always))
                (predicates.records.record
                {
                  authorization = predicates.const null,
                  basic_auth = predicates.const null,
                  bearer_token = predicates.const null,
                  bearer_token_file = predicates.const null,
                  oauth2 = predicates.const null,
                }
                {  }
                true
                predicates.always)
                predicates.always,
                predicates.ifThenElse
                (predicates.not
                (predicates.records.record { oauth2 = predicates.const null, }
                {  }
                true
                predicates.always))
                (predicates.records.record
                {
                  authorization = predicates.const null,
                  basic_auth = predicates.const null,
                  bearer_token = predicates.const null,
                  bearer_token_file = predicates.const null,
                  sigv4 = predicates.const null,
                }
                {  }
                true
                predicates.always)
                predicates.always,
                predicates.ifThenElse
                (predicates.not
                (predicates.records.record
                { bearer_token = predicates.const null, }
                {  }
                true
                predicates.always))
                (predicates.records.record
                {
                  authorization = predicates.const null,
                  basic_auth = predicates.const null,
                  bearer_token_file = predicates.const null,
                  oauth2 = predicates.const null,
                  sigv4 = predicates.const null,
                }
                {  }
                true
                predicates.always)
                predicates.always,
                predicates.ifThenElse
                (predicates.not
                (predicates.records.record
                { bearer_token_file = predicates.const null, }
                {  }
                true
                predicates.always))
                (predicates.records.record
                {
                  authorization = predicates.const null,
                  basic_auth = predicates.const null,
                  bearer_token = predicates.const null,
                  oauth2 = predicates.const null,
                  sigv4 = predicates.const null,
                }
                {  }
                true
                predicates.always)
                predicates.always
              ],
          authorization
            | doc m%"
            Sets the `Authorization` header on every scrape request with the configured credentials.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "credentials" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "credentials_file" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  credentials = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  credentials_file = definitions.predicate.filepath,
                  type = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          azure_sd_configs
            | doc m%"
            List of Azure service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          basic_auth
            | doc m%"
            Sets the `Authorization` header on every remote write request with the configured username and password. password and password_file are mutually exclusive.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "password" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "password_file" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "username" ],
                predicates.records.record
                {
                  password = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  password_file = definitions.predicate.filepath,
                  username = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          bearer_token
            | doc m%"
            Sets the `Authorization` header on every scrape request with the configured bearer token. It is mutually exclusive with `bearer_token_file`.
            "%
            = predicates.anyOf
              [ predicates.isType '"String", predicates.isType 'Null ],
          bearer_token_file
            | doc m%"
            Sets the `Authorization` header on every scrape request with the bearer token read from the configured file. It is mutually exclusive with `bearer_token`.
            "%
            = definitions.predicate.filepath,
          consul_sd_configs
            | doc m%"
            List of Consul service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          digitalocean_sd_configs
            | doc m%"
            List of DigitalOcean service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          dns_sd_configs
            | doc m%"
            List of DNS service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "names" ],
                  predicates.records.record
                  {
                    names = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.minItems 1
                        ],
                    port = predicates.anyOf
                        [ predicates.isType 'Integer, predicates.isType 'Null ],
                    refresh_interval = definitions.predicate.duration,
                    type = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Null
                          ],
                          predicates.enum [ "SRV", "A", "AAAA" ]
                        ],
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          docker_sd_configs
            | doc m%"
            List of Docker service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          dockerswarm_sd_configs
            | doc m%"
            List of Docker Swarm service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          duration = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.strings.pattern "^[0-9]+(ms|[smhdwy])$"
              ],
          ec2_sd_configs
            | doc m%"
            List of EC2 service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          eureka_sd_configs
            | doc m%"
            List of Eureka service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          file_sd_configs
            | doc m%"
            List of file service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    files = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String"),
                          predicates.arrays.minItems 1
                        ],
                    refresh_interval = definitions.predicate.duration,
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          filepath = predicates.anyOf
              [ predicates.isType '"String", predicates.isType 'Null ],
          filepath_glob = predicates.isType '"String",
          gce_sd_configs
            | doc m%"
            List of GCE service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          hetzner_sd_configs
            | doc m%"
            List of Hetzner service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          http_sd_configs
            | doc m%"
            List of HTTP service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  definitions.predicate.auth,
                  predicates.records.required [ "url" ],
                  predicates.records.record
                  {
                    authorization = definitions.predicate.authorization,
                    basic_auth = definitions.predicate.basic_auth,
                    bearer_token = definitions.predicate.bearer_token,
                    bearer_token_file = definitions.predicate.bearer_token_file,
                    follow_redirects = predicates.anyOf
                        [ predicates.isType '"Bool", predicates.isType 'Null ],
                    oauth2 = definitions.predicate.oauth2,
                    proxy_url = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    refresh_interval = definitions.predicate.duration,
                    tls_config = definitions.predicate.tls_config,
                    url = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          kubernetes_sd_configs
            | doc m%"
            List of Kubernetes service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  definitions.predicate.auth,
                  predicates.records.record
                  {
                    api_server = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    authorization = definitions.predicate.authorization,
                    basic_auth = definitions.predicate.basic_auth,
                    bearer_token = definitions.predicate.bearer_token,
                    bearer_token_file = definitions.predicate.bearer_token_file,
                    follow_redirects = predicates.anyOf
                        [ predicates.isType '"Bool", predicates.isType 'Null ],
                    kubeconfig_file = definitions.predicate.filepath,
                    namespaces = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType 'Record,
                            predicates.isType 'Null
                          ],
                          predicates.records.record
                          {
                            names = predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ],
                            own_namespace = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ],
                    oauth2 = definitions.predicate.oauth2,
                    proxy_url = predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ],
                    role = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [ "endpoints", "service", "pod", "node", "ingress" ]
                        ],
                    selectors = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"Array",
                            predicates.isType 'Null
                          ],
                          predicates.arrays.arrayOf
                          (predicates.allOf
                          [
                            predicates.isType 'Record,
                            predicates.records.required [ "role" ],
                            predicates.records.record
                            {
                              field = predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.isType 'Null
                                  ],
                              label = predicates.anyOf
                                  [
                                    predicates.isType '"String",
                                    predicates.isType 'Null
                                  ],
                              role = predicates.isType '"String",
                            }
                            {  }
                            false
                            predicates.never
                          ])
                        ],
                    tls_config = definitions.predicate.tls_config,
                  }
                  {  }
                  false
                  predicates.never
                ])
              ],
          kuma_sd_configs
            | doc m%"
            List of Kuma service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          label_name = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern "^[a-zA-Z_][a-zA-Z0-9_]*$"
              ],
          label_value = predicates.isType '"String",
          labels = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record {  }
                {
                  "^[a-zA-Z_][a-zA-Z0-9_]*$" =
                    definitions.predicate.label_value,
                }
                false
                predicates.never
              ],
          lightsail_sd_configs
            | doc m%"
            List of Lightsail service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          linode_sd_configs
            | doc m%"
            List of Linode service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          marathon_sd_configs
            | doc m%"
            List of Marathon service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          nerve_sd_configs
            | doc m%"
            List of AirBnB's Nerve service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          oauth2
            | doc m%"
            Optional OAuth 2.0 configuration. Cannot be used at the same time as basic_auth or authorization.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "client_secret" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "client_secret_file" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.required [ "client_id", "token_url" ],
                predicates.records.record
                {
                  client_id = predicates.anyOf [ predicates.isType '"String" ],
                  client_secret = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  client_secret_file = definitions.predicate.filepath,
                  endpoint_params = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType 'Record, predicates.isType 'Null ],
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  scopes = predicates.allOf
                      [
                        predicates.anyOf
                        [ predicates.isType '"Array", predicates.isType 'Null ],
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"String",
                          predicates.isType 'Null
                        ])
                      ],
                  tls_config = definitions.predicate.tls_config,
                  token_url = predicates.anyOf [ predicates.isType '"String" ],
                }
                {  }
                false
                predicates.never
              ],
          openstack_sd_configs
            | doc m%"
            List of OpenStack service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          puppetdb_sd_configs
            | doc m%"
            List of PuppetDB service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          relabel_configs = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.ifThenElse
                  (predicates.records.record
                  { action = predicates.const "replace", }
                  {  }
                  true
                  predicates.always)
                  (predicates.allOf
                  [
                    predicates.records.required [ "target_label" ],
                    predicates.records.record {  } {  } true predicates.always
                  ])
                  predicates.always,
                  predicates.records.record
                  {
                    action = predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum
                          [
                            "replace",
                            "lowercase",
                            "uppercase",
                            "keep",
                            "drop",
                            "keepequal",
                            "dropequal",
                            "hashmod",
                            "labelmap",
                            "labeldrop",
                            "labelkeep"
                          ]
                        ],
                    modulus = predicates.isType 'Integer,
                    regex = predicates.always,
                    replacement = predicates.isType '"String",
                    separator = predicates.isType '"String",
                    source_labels = predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.label_name
                        ],
                    target_label = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          scaleway_sd_configs
            | doc m%"
            List of Scaleway service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          scheme = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"String", predicates.isType 'Null ],
                predicates.enum [ "http", "https", null ]
              ],
          serverset_sd_configs
            | doc m%"
            List of Zookeeper Serverset service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          sigv4
            | doc m%"
            Optionally configures AWS's Signature Verification 4 signing process to sign requests.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  access_key = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  profile = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  region = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  role_arn = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  secret_key = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          static_configs
            | doc m%"
            List of labeled statically configured targets for this job.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf
                (predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    labels = definitions.predicate.labels,
                    targets = predicates.allOf
                        [
                          predicates.anyOf
                          [
                            predicates.isType '"Array",
                            predicates.isType 'Null
                          ],
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ])
              ],
          tls_config = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType 'Record, predicates.isType 'Null ],
                predicates.records.record
                {
                  ca_file = definitions.predicate.filepath,
                  cert_file = definitions.predicate.filepath,
                  insecure_skip_verify = predicates.anyOf
                      [ predicates.isType '"Bool", predicates.isType 'Null ],
                  key_file = definitions.predicate.filepath,
                  server_name = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          triton_sd_configs
            | doc m%"
            List of Triton service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
          uyuni_sd_configs
            | doc m%"
            List of Uyuni service discovery configurations.
            "%
            = predicates.allOf
              [
                predicates.anyOf
                [ predicates.isType '"Array", predicates.isType 'Null ],
                predicates.arrays.arrayOf (predicates.isType 'Record)
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.anyOf [ predicates.isType 'Record, predicates.isType 'Null ],
  predicates.records.record
  {
    alerting = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Record, predicates.isType 'Null ],
          predicates.records.record
          {
            alert_relabel_configs = definitions.predicate.relabel_configs,
            alertmanagers = predicates.allOf
                [
                  predicates.anyOf
                  [ predicates.isType '"Array", predicates.isType 'Null ],
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    definitions.predicate.auth,
                    predicates.records.record
                    {
                      api_version = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Null
                          ],
                      authorization = definitions.predicate.authorization,
                      azure_sd_configs = definitions.predicate.azure_sd_configs,
                      basic_auth = definitions.predicate.basic_auth,
                      bearer_token = definitions.predicate.bearer_token,
                      bearer_token_file =
                        definitions.predicate.bearer_token_file,
                      consul_sd_configs =
                        definitions.predicate.consul_sd_configs,
                      digitalocean_sd_configs =
                        definitions.predicate.digitalocean_sd_configs,
                      dns_sd_configs = definitions.predicate.dns_sd_configs,
                      docker_sd_configs =
                        definitions.predicate.docker_sd_configs,
                      dockerswarm_sd_configs =
                        definitions.predicate.dockerswarm_sd_configs,
                      ec2_sd_configs = definitions.predicate.ec2_sd_configs,
                      eureka_sd_configs =
                        definitions.predicate.eureka_sd_configs,
                      file_sd_configs = definitions.predicate.file_sd_configs,
                      follow_redirects = predicates.anyOf
                          [
                            predicates.isType '"Bool",
                            predicates.isType 'Null
                          ],
                      gce_sd_configs = definitions.predicate.gce_sd_configs,
                      hetzner_sd_configs =
                        definitions.predicate.hetzner_sd_configs,
                      http_sd_configs = definitions.predicate.http_sd_configs,
                      kubernetes_sd_configs =
                        definitions.predicate.kubernetes_sd_configs,
                      kuma_sd_configs = definitions.predicate.kuma_sd_configs,
                      lightsail_sd_configs =
                        definitions.predicate.lightsail_sd_configs,
                      linode_sd_configs =
                        definitions.predicate.linode_sd_configs,
                      marathon_sd_configs =
                        definitions.predicate.marathon_sd_configs,
                      nerve_sd_configs = definitions.predicate.nerve_sd_configs,
                      oauth2 = definitions.predicate.oauth2,
                      openstack_sd_configs =
                        definitions.predicate.openstack_sd_configs,
                      path_prefix = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Null
                          ],
                      proxy_url = predicates.anyOf
                          [
                            predicates.isType '"String",
                            predicates.isType 'Null
                          ],
                      puppetdb_sd_configs =
                        definitions.predicate.puppetdb_sd_configs,
                      relabel_configs = definitions.predicate.relabel_configs,
                      scaleway_sd_configs =
                        definitions.predicate.scaleway_sd_configs,
                      scheme = definitions.predicate.scheme,
                      serverset_sd_configs =
                        definitions.predicate.serverset_sd_configs,
                      static_configs = definitions.predicate.static_configs,
                      timeout = definitions.predicate.duration,
                      tls_config = definitions.predicate.tls_config,
                      triton_sd_configs =
                        definitions.predicate.triton_sd_configs,
                      uyuni_sd_configs = definitions.predicate.uyuni_sd_configs,
                    }
                    {  }
                    true
                    predicates.always
                  ])
                ],
          }
          {  }
          true
          predicates.always
        ],
    global = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType 'Record, predicates.isType 'Null ],
          predicates.records.record
          {
            evaluation_interval = definitions.predicate.duration,
            external_labels = definitions.predicate.labels,
            query_log_file = definitions.predicate.filepath,
            scrape_interval = definitions.predicate.duration,
            scrape_timeout = definitions.predicate.duration,
          }
          {  }
          false
          predicates.never
        ],
    remote_read = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            definitions.predicate.auth,
            predicates.records.required [ "url" ],
            predicates.records.record
            {
              authorization = definitions.predicate.authorization,
              basic_auth = definitions.predicate.basic_auth,
              bearer_token = definitions.predicate.bearer_token,
              bearer_token_file = definitions.predicate.bearer_token_file,
              follow_redirects = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              headers = predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ],
              name = predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
              oauth2 = definitions.predicate.oauth2,
              proxy_url = predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
              read_recent = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              remote_timeout = definitions.predicate.duration,
              required_matchers = definitions.predicate.labels,
              tls_config = definitions.predicate.tls_config,
              url = predicates.isType '"String",
            }
            {  }
            false
            predicates.never
          ])
        ],
    remote_write = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            definitions.predicate.auth,
            predicates.records.required [ "url" ],
            predicates.records.record
            {
              authorization = definitions.predicate.authorization,
              basic_auth = definitions.predicate.basic_auth,
              bearer_token = definitions.predicate.bearer_token,
              bearer_token_file = definitions.predicate.bearer_token_file,
              follow_redirects = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              headers = predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ],
              metadata_config = predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record
                    {
                      max_samples_per_send = predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                      send = predicates.anyOf
                          [
                            predicates.isType '"Bool",
                            predicates.isType 'Null
                          ],
                      send_interval = definitions.predicate.duration,
                    }
                    {  }
                    false
                    predicates.never
                  ],
              name = predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
              oauth2 = definitions.predicate.oauth2,
              proxy_url = predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
              queue_config = predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record
                    {
                      batch_send_deadline = definitions.predicate.duration,
                      capacity = predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                      max_backoff = definitions.predicate.duration,
                      max_samples_per_send = predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                      max_shards = predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                      min_backoff = definitions.predicate.duration,
                      min_shards = predicates.anyOf
                          [
                            predicates.isType 'Integer,
                            predicates.isType 'Null
                          ],
                      retry_on_http_429 = predicates.anyOf
                          [
                            predicates.isType '"Bool",
                            predicates.isType 'Null
                          ],
                    }
                    {  }
                    false
                    predicates.never
                  ],
              remote_timeout = definitions.predicate.duration,
              send_exemplars = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              sigv4 = definitions.predicate.sigv4,
              tls_config = definitions.predicate.tls_config,
              url = predicates.isType '"String",
              write_relabel_configs = definitions.predicate.relabel_configs,
            }
            {  }
            false
            predicates.never
          ])
        ],
    rule_files = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf definitions.predicate.filepath_glob
        ],
    scrape_config_files = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf definitions.predicate.filepath_glob
        ],
    scrape_configs = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            definitions.predicate.auth,
            predicates.records.required [ "job_name" ],
            predicates.records.record
            {
              authorization = definitions.predicate.authorization,
              azure_sd_configs = definitions.predicate.azure_sd_configs,
              basic_auth = definitions.predicate.basic_auth,
              bearer_token = definitions.predicate.bearer_token,
              bearer_token_file = definitions.predicate.bearer_token_file,
              body_size_limit = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
              consul_sd_configs = definitions.predicate.consul_sd_configs,
              digitalocean_sd_configs =
                definitions.predicate.digitalocean_sd_configs,
              dns_sd_configs = definitions.predicate.dns_sd_configs,
              docker_sd_configs = definitions.predicate.docker_sd_configs,
              dockerswarm_sd_configs =
                definitions.predicate.dockerswarm_sd_configs,
              ec2_sd_configs = definitions.predicate.ec2_sd_configs,
              eureka_sd_configs = definitions.predicate.eureka_sd_configs,
              file_sd_configs = definitions.predicate.file_sd_configs,
              follow_redirects = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              gce_sd_configs = definitions.predicate.gce_sd_configs,
              hetzner_sd_configs = definitions.predicate.hetzner_sd_configs,
              honor_labels = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              honor_timestamps = predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType 'Null ],
              http_sd_configs = definitions.predicate.http_sd_configs,
              job_name = predicates.isType '"String",
              kubernetes_sd_configs =
                definitions.predicate.kubernetes_sd_configs,
              kuma_sd_configs = definitions.predicate.kuma_sd_configs,
              label_limit = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
              label_name_length_limit = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
              label_value_length_limit = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
              lightsail_sd_configs = definitions.predicate.lightsail_sd_configs,
              linode_sd_configs = definitions.predicate.linode_sd_configs,
              marathon_sd_configs = definitions.predicate.marathon_sd_configs,
              metric_relabel_configs = definitions.predicate.relabel_configs,
              metrics_path = predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
              nerve_sd_configs = definitions.predicate.nerve_sd_configs,
              oauth2 = definitions.predicate.oauth2,
              openstack_sd_configs = definitions.predicate.openstack_sd_configs,
              params = predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType 'Record, predicates.isType 'Null ],
                    predicates.records.record {  } {  } true
                    (predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ])
                  ],
              proxy_url = predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ],
              puppetdb_sd_configs = definitions.predicate.puppetdb_sd_configs,
              relabel_configs = definitions.predicate.relabel_configs,
              sample_limit = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
              scaleway_sd_configs = definitions.predicate.scaleway_sd_configs,
              scheme = definitions.predicate.scheme,
              scrape_interval = definitions.predicate.duration,
              scrape_timeout = definitions.predicate.duration,
              serverset_sd_configs = definitions.predicate.serverset_sd_configs,
              static_configs = definitions.predicate.static_configs,
              target_limit = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
              tls_config = definitions.predicate.tls_config,
              triton_sd_configs = definitions.predicate.triton_sd_configs,
              uyuni_sd_configs = definitions.predicate.uyuni_sd_configs,
            }
            {  }
            false
            predicates.never
          ])
        ],
    storage = predicates.allOf
        [
          predicates.anyOf
          [ predicates.isType '"Array", predicates.isType 'Null ],
          predicates.arrays.arrayOf
          (predicates.allOf
          [
            predicates.isType 'Record,
            predicates.records.record
            {
              max_exemplars = predicates.anyOf
                  [ predicates.isType 'Integer, predicates.isType 'Null ],
            }
            {  }
            false
            predicates.never
          ])
        ],
  }
  {  }
  false
  predicates.never
])