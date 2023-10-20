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
          address
            | doc m%"
            A physical or virtual address, or a range of addresses, in an 'addressable region' (memory or a binary file).
            "%
            = {
                absoluteAddress
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The address expressed as a byte offset from the start of the addressable region.
                  "%
                  | optional,
                fullyQualifiedName
                  | String
                  | doc m%"
                  A human-readable fully qualified name that is associated with the address.
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within run.addresses of the cached object for this address.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  An open-ended string that identifies the address kind. 'data', 'function', 'header','instruction', 'module', 'page', 'section', 'segment', 'stack', 'stackFrame', 'table' are well-known values.
                  "%
                  | optional,
                length
                  | std.number.Integer
                  | doc m%"
                  The number of bytes in this range of addresses.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A name that is associated with the address, e.g., '.text'.
                  "%
                  | optional,
                offsetFromParent
                  | std.number.Integer
                  | doc m%"
                  The byte offset of this address from the absolute or relative address of the parent object.
                  "%
                  | optional,
                parentIndex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within run.addresses of the parent object.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the address.
                  "%
                  | optional,
                relativeAddress
                  | std.number.Integer
                  | doc m%"
                  The address expressed as a byte offset from the absolute address of the top-most parent object.
                  "%
                  | optional,
              },
          artifact
            | doc m%"
            A single artifact. In some cases, this artifact might be nested within another artifact.
            "%
            = {
                contents
                  | definitions.contract.artifactContent
                  | doc m%"
                  The contents of the artifact.
                  "%
                  | optional,
                description
                  | definitions.contract.message
                  | doc m%"
                  A short description of the artifact.
                  "%
                  | optional,
                encoding
                  | String
                  | doc m%"
                  Specifies the encoding for an artifact object that refers to a text file.
                  "%
                  | optional,
                hashes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is the name of a hash function and each of whose values is the hashed value of the artifact produced by the specified hash function.
                  "%
                  | optional,
                lastModifiedTimeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which the artifact was most recently modified. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                length
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The length of the artifact in bytes.
                  "%
                  | optional,
                location
                  | definitions.contract.artifactLocation
                  | doc m%"
                  The location of the artifact.
                  "%
                  | optional,
                mimeType
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "[^/]+/.+"
                  ])
                  | doc m%"
                  The MIME type (RFC 2045) of the artifact.
                  "%
                  | optional,
                offset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The offset in bytes of the artifact within its containing artifact.
                  "%
                  | optional,
                parentIndex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  Identifies the index of the immediate parent of the artifact, if this artifact is nested.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the artifact.
                  "%
                  | optional,
                roles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.enum
                    [
                      "analysisTarget",
                      "attachment",
                      "responseFile",
                      "resultFile",
                      "standardStream",
                      "tracedFile",
                      "unmodified",
                      "modified",
                      "added",
                      "deleted",
                      "renamed",
                      "uncontrolled",
                      "driver",
                      "extension",
                      "translation",
                      "taxonomy",
                      "policy",
                      "referencedOnCommandLine",
                      "memoryContents",
                      "directory",
                      "userSpecifiedConfiguration",
                      "toolSpecifiedConfiguration",
                      "debugOutputFile"
                    ]),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The role or roles played by the artifact in the analysis.
                  "%
                  | optional,
                sourceLanguage
                  | String
                  | doc m%"
                  Specifies the source language for any artifact object that refers to a text file that contains source code.
                  "%
                  | optional,
              },
          artifactChange
            | doc m%"
            A change to a single artifact.
            "%
            = {
                artifactLocation
                  | definitions.contract.artifactLocation
                  | doc m%"
                  The location of the artifact to change.
                  "%,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the change.
                  "%
                  | optional,
                replacements
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.replacement,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of replacement objects, each of which represents the replacement of a single region in a single artifact specified by 'artifactLocation'.
                  "%,
              },
          artifactContent
            | doc m%"
            Represents the contents of an artifact.
            "%
            = {
                binary
                  | String
                  | doc m%"
                  MIME Base64-encoded content from a binary artifact, or from a text artifact in its original encoding.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the artifact content.
                  "%
                  | optional,
                rendered
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  An alternate rendered representation of the artifact (e.g., a decompiled representation of a binary region).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  UTF-8-encoded content from a text artifact.
                  "%
                  | optional,
              },
          artifactLocation
            | doc m%"
            Specifies the location of an artifact.
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A short description of the artifact location.
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the run artifacts array of the artifact object associated with the artifact location.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the artifact location.
                  "%
                  | optional,
                uri
                  | String
                  | doc m%"
                  A string containing a valid relative or absolute URI.
                  "%
                  | optional,
                uriBaseId
                  | String
                  | doc m%"
                  A string which indirectly specifies the absolute URI with respect to which a relative URI in the "uri" property is interpreted.
                  "%
                  | optional,
              },
          attachment
            | doc m%"
            An artifact relevant to a result.
            "%
            = {
                artifactLocation
                  | definitions.contract.artifactLocation
                  | doc m%"
                  The location of the attachment.
                  "%,
                description
                  | definitions.contract.message
                  | doc m%"
                  A message describing the role played by the attachment.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the attachment.
                  "%
                  | optional,
                rectangles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.rectangle,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of rectangles specifying areas of interest within the image.
                  "%
                  | optional,
                regions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.region,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of regions of interest within the attachment.
                  "%
                  | optional,
              },
          codeFlow
            | doc m%"
            A set of threadFlows which together describe a pattern of code execution relevant to detecting a result.
            "%
            = {
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the code flow.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the code flow.
                  "%
                  | optional,
                threadFlows
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.threadFlow,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of one or more unique threadFlow objects, each of which describes the progress of a program through a thread of execution.
                  "%,
              },
          configurationOverride
            | doc m%"
            Information about how a specific rule or notification was reconfigured at runtime.
            "%
            = {
                configuration
                  | definitions.contract.reportingConfiguration
                  | doc m%"
                  Specifies how the rule or notification was configured during the scan.
                  "%,
                descriptor
                  | definitions.contract.reportingDescriptorReference
                  | doc m%"
                  A reference used to locate the descriptor whose configuration was overridden.
                  "%,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the configuration override.
                  "%
                  | optional,
              },
          conversion
            | doc m%"
            Describes how a converter transformed the output of a static analysis tool from the analysis tool's native output format into the SARIF format.
            "%
            = {
                analysisToolLogFiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.artifactLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The locations of the analysis tool's per-run log files.
                  "%
                  | optional,
                invocation
                  | definitions.contract.invocation
                  | doc m%"
                  An invocation object that describes the invocation of the converter.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the conversion.
                  "%
                  | optional,
                tool
                  | definitions.contract.tool
                  | doc m%"
                  A tool object that describes the converter.
                  "%,
              },
          edge
            | doc m%"
            Represents a directed edge in a graph.
            "%
            = {
                id
                  | String
                  | doc m%"
                  A string that uniquely identifies the edge within its graph.
                  "%,
                label
                  | definitions.contract.message
                  | doc m%"
                  A short description of the edge.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the edge.
                  "%
                  | optional,
                sourceNodeId
                  | String
                  | doc m%"
                  Identifies the source node (the node at which the edge starts).
                  "%,
                targetNodeId
                  | String
                  | doc m%"
                  Identifies the target node (the node at which the edge ends).
                  "%,
              },
          edgeTraversal
            | doc m%"
            Represents the traversal of a single edge during a graph traversal.
            "%
            = {
                edgeId
                  | String
                  | doc m%"
                  Identifies the edge being traversed.
                  "%,
                finalState
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.multiformatMessageString
                  ])
                  | doc m%"
                  The values of relevant expressions after the edge has been traversed.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message to display to the user as the edge is traversed.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the edge traversal.
                  "%
                  | optional,
                stepOverEdgeCount
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The number of edge traversals necessary to return from a nested graph.
                  "%
                  | optional,
              },
          exception = {
                innerExceptions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.exception,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  An array of exception objects each of which is considered a cause of this exception.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  A string that identifies the kind of exception, for example, the fully qualified type name of an object that was thrown, or the symbolic name of a signal.
                  "%
                  | optional,
                message
                  | String
                  | doc m%"
                  A message that describes the exception.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the exception.
                  "%
                  | optional,
                stack
                  | definitions.contract.stack
                  | doc m%"
                  The sequence of function calls leading to the exception.
                  "%
                  | optional,
                ..
              },
          externalProperties = {
                addresses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.address,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  Addresses that will be merged with a separate run.
                  "%
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.artifact,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of artifact objects that will be merged with a separate run.
                  "%
                  | optional,
                conversion
                  | definitions.contract.conversion
                  | doc m%"
                  A conversion object that will be merged with a separate run.
                  "%
                  | optional,
                driver
                  | definitions.contract.toolComponent
                  | doc m%"
                  The analysis tool object that will be merged with a separate run.
                  "%
                  | optional,
                extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Tool extensions that will be merged with a separate run.
                  "%
                  | optional,
                externalizedProperties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information that will be merged with a separate run.
                  "%
                  | optional,
                graphs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.graph,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of graph objects that will be merged with a separate run.
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for this external properties object, in the form of a GUID.
                  "%
                  | optional,
                invocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.invocation,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  Describes the invocation of the analysis tool that will be merged with a separate run.
                  "%
                  | optional,
                logicalLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.logicalLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of logical locations such as namespaces, types or functions that will be merged with a separate run.
                  "%
                  | optional,
                policies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Tool policies that will be merged with a separate run.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the external properties.
                  "%
                  | optional,
                results
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.result,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  An array of result objects that will be merged with a separate run.
                  "%
                  | optional,
                runGuid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for the run associated with this external properties object, in the form of a GUID.
                  "%
                  | optional,
                schema
                  | String
                  | doc m%"
                  The URI of the JSON schema corresponding to the version of the external property file format.
                  "%
                  | optional,
                taxonomies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Tool taxonomies that will be merged with a separate run.
                  "%
                  | optional,
                threadFlowLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.threadFlowLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of threadFlowLocation objects that will be merged with a separate run.
                  "%
                  | optional,
                translations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Tool translations that will be merged with a separate run.
                  "%
                  | optional,
                version
                  | predicates.contract_from_predicate
                  (predicates.enum [ "2.1.0" ])
                  | doc m%"
                  The SARIF format version of this external properties object.
                  "%
                  | optional,
                webRequests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.webRequest,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Requests that will be merged with a separate run.
                  "%
                  | optional,
                webResponses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.webResponse,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Responses that will be merged with a separate run.
                  "%
                  | optional,
                ..
              },
          externalPropertyFileReference = predicates.contract_from_predicate
              definitions.predicate.externalPropertyFileReference,
          externalPropertyFileReferences
            | doc m%"
            References to external property files that should be inlined with the content of a root log file.
            "%
            = {
                addresses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.addresses arrays to be merged with the root log file.
                  "%
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.artifacts arrays to be merged with the root log file.
                  "%
                  | optional,
                conversion
                  | definitions.contract.externalPropertyFileReference
                  | doc m%"
                  An external property file containing a run.conversion object to be merged with the root log file.
                  "%
                  | optional,
                driver
                  | definitions.contract.externalPropertyFileReference
                  | doc m%"
                  An external property file containing a run.driver object to be merged with the root log file.
                  "%
                  | optional,
                extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.extensions arrays to be merged with the root log file.
                  "%
                  | optional,
                externalizedProperties
                  | definitions.contract.externalPropertyFileReference
                  | doc m%"
                  An external property file containing a run.properties object to be merged with the root log file.
                  "%
                  | optional,
                graphs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing a run.graphs object to be merged with the root log file.
                  "%
                  | optional,
                invocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.invocations arrays to be merged with the root log file.
                  "%
                  | optional,
                logicalLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.logicalLocations arrays to be merged with the root log file.
                  "%
                  | optional,
                policies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.policies arrays to be merged with the root log file.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the external property files.
                  "%
                  | optional,
                results
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.results arrays to be merged with the root log file.
                  "%
                  | optional,
                taxonomies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.taxonomies arrays to be merged with the root log file.
                  "%
                  | optional,
                threadFlowLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.threadFlowLocations arrays to be merged with the root log file.
                  "%
                  | optional,
                translations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.translations arrays to be merged with the root log file.
                  "%
                  | optional,
                webRequests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.requests arrays to be merged with the root log file.
                  "%
                  | optional,
                webResponses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.externalPropertyFileReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of external property files containing run.responses arrays to be merged with the root log file.
                  "%
                  | optional,
              },
          fix
            | doc m%"
            A proposed fix for the problem represented by a result object. A fix specifies a set of artifacts to modify. For each artifact, it specifies a set of bytes to remove, and provides a set of new bytes to replace them.
            "%
            = {
                artifactChanges
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.artifactChange,
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  One or more artifact changes that comprise a fix for a result.
                  "%,
                description
                  | definitions.contract.message
                  | doc m%"
                  A message that describes the proposed fix, enabling viewers to present the proposed change to an end user.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the fix.
                  "%
                  | optional,
              },
          graph
            | doc m%"
            A network of nodes and directed edges that describes some aspect of the structure of the code (for example, a call graph).
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of the graph.
                  "%
                  | optional,
                edges
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.edge,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of edge objects representing the edges of the graph.
                  "%
                  | optional,
                nodes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.node,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of node objects representing the nodes of the graph.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the graph.
                  "%
                  | optional,
              },
          graphTraversal
            | doc m%"
            Represents a path through a graph.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.graphTraversal,
          invocation
            | doc m%"
            The runtime environment of the analysis tool run.
            "%
            = {
                account
                  | String
                  | doc m%"
                  The account that ran the analysis tool.
                  "%
                  | optional,
                arguments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  An array of strings, containing in order the command line arguments passed to the tool from the operating system.
                  "%
                  | optional,
                commandLine
                  | String
                  | doc m%"
                  The command line used to invoke the tool.
                  "%
                  | optional,
                endTimeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which the run ended. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                environmentVariables
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The environment variables associated with the analysis tool process, expressed as key/value pairs.
                  "%
                  | optional,
                executableLocation
                  | definitions.contract.artifactLocation
                  | doc m%"
                  An absolute URI specifying the location of the analysis tool's executable.
                  "%
                  | optional,
                executionSuccessful
                  | Bool
                  | doc m%"
                  Specifies whether the tool's execution completed successfully.
                  "%,
                exitCode
                  | std.number.Integer
                  | doc m%"
                  The process exit code.
                  "%
                  | optional,
                exitCodeDescription
                  | String
                  | doc m%"
                  The reason for the process exit.
                  "%
                  | optional,
                exitSignalName
                  | String
                  | doc m%"
                  The name of the signal that caused the process to exit.
                  "%
                  | optional,
                exitSignalNumber
                  | std.number.Integer
                  | doc m%"
                  The numeric value of the signal that caused the process to exit.
                  "%
                  | optional,
                machine
                  | String
                  | doc m%"
                  The machine that hosted the analysis tool run.
                  "%
                  | optional,
                notificationConfigurationOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.configurationOverride,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of configurationOverride objects that describe notifications related runtime overrides.
                  "%
                  | optional,
                processId
                  | std.number.Integer
                  | doc m%"
                  The process id for the analysis tool run.
                  "%
                  | optional,
                processStartFailureMessage
                  | String
                  | doc m%"
                  The reason given by the operating system that the process failed to start.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the invocation.
                  "%
                  | optional,
                responseFiles
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.artifactLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The locations of any response files specified on the tool's command line.
                  "%
                  | optional,
                ruleConfigurationOverrides
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.configurationOverride,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of configurationOverride objects that describe rules related runtime overrides.
                  "%
                  | optional,
                startTimeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which the run started. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                stderr
                  | definitions.contract.artifactLocation
                  | doc m%"
                  A file containing the standard error stream from the process that was invoked.
                  "%
                  | optional,
                stdin
                  | definitions.contract.artifactLocation
                  | doc m%"
                  A file containing the standard input stream to the process that was invoked.
                  "%
                  | optional,
                stdout
                  | definitions.contract.artifactLocation
                  | doc m%"
                  A file containing the standard output stream from the process that was invoked.
                  "%
                  | optional,
                stdoutStderr
                  | definitions.contract.artifactLocation
                  | doc m%"
                  A file containing the interleaved standard output and standard error stream from the process that was invoked.
                  "%
                  | optional,
                toolConfigurationNotifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.notification,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  A list of conditions detected by the tool that are relevant to the tool's configuration.
                  "%
                  | optional,
                toolExecutionNotifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.notification,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  A list of runtime conditions detected by the tool during the analysis.
                  "%
                  | optional,
                workingDirectory
                  | definitions.contract.artifactLocation
                  | doc m%"
                  The working directory for the analysis tool run.
                  "%
                  | optional,
              },
          location
            | doc m%"
            A location within a programming artifact.
            "%
            = {
                annotations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.region,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of regions relevant to the location.
                  "%
                  | optional,
                id
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  Value that distinguishes this location from all other locations within a single result object.
                  "%
                  | optional,
                logicalLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.logicalLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The logical locations associated with the result.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the location.
                  "%
                  | optional,
                physicalLocation
                  | definitions.contract.physicalLocation
                  | doc m%"
                  Identifies the artifact and region.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the location.
                  "%
                  | optional,
                relationships
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.locationRelationship,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of objects that describe relationships between this location and others.
                  "%
                  | optional,
              },
          locationRelationship
            | doc m%"
            Information about the relation of one location to another.
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of the location relationship.
                  "%
                  | optional,
                kinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of distinct strings that categorize the relationship. Well-known kinds include 'includes', 'isIncludedBy' and 'relevant'.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the location relationship.
                  "%
                  | optional,
                target
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  A reference to the related location.
                  "%,
              },
          logicalLocation
            | doc m%"
            A logical location of a construct that produced a result.
            "%
            = {
                decoratedName
                  | String
                  | doc m%"
                  The machine-readable name for the logical location, such as a mangled function name provided by a C++ compiler that encodes calling convention, return type and other details along with the function name.
                  "%
                  | optional,
                fullyQualifiedName
                  | String
                  | doc m%"
                  The human-readable fully qualified name of the logical location.
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the logical locations array.
                  "%
                  | optional,
                kind
                  | String
                  | doc m%"
                  The type of construct this logical location component refers to. Should be one of 'function', 'member', 'module', 'namespace', 'parameter', 'resource', 'returnType', 'type', 'variable', 'object', 'array', 'property', 'value', 'element', 'text', 'attribute', 'comment', 'declaration', 'dtd' or 'processingInstruction', if any of those accurately describe the construct.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Identifies the construct in which the result occurred. For example, this property might contain the name of a class or a method.
                  "%
                  | optional,
                parentIndex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  Identifies the index of the immediate parent of the construct in which the result was detected. For example, this property might point to a logical location that represents the namespace that holds a type.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the logical location.
                  "%
                  | optional,
              },
          message
            | doc m%"
            Encapsulates a message intended to be read by the end user.
            "%
            = predicates.contract_from_predicate definitions.predicate.message,
          multiformatMessageString
            | doc m%"
            A message string or message format string rendered in multiple formats.
            "%
            = {
                markdown
                  | String
                  | doc m%"
                  A Markdown message string or format string.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the message.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  A plain text message string or format string.
                  "%,
              },
          node
            | doc m%"
            Represents a node in a graph.
            "%
            = {
                children
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.node,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Array of child nodes.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A string that uniquely identifies the node within its graph.
                  "%,
                label
                  | definitions.contract.message
                  | doc m%"
                  A short description of the node.
                  "%
                  | optional,
                location
                  | definitions.contract.location
                  | doc m%"
                  A code location associated with the node.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the node.
                  "%
                  | optional,
              },
          notification
            | doc m%"
            Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool.
            "%
            = {
                associatedRule
                  | definitions.contract.reportingDescriptorReference
                  | doc m%"
                  A reference used to locate the rule descriptor associated with this notification.
                  "%
                  | optional,
                descriptor
                  | definitions.contract.reportingDescriptorReference
                  | doc m%"
                  A reference used to locate the descriptor relevant to this notification.
                  "%
                  | optional,
                exception
                  | definitions.contract.exception
                  | doc m%"
                  The runtime exception, if any, relevant to this notification.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum [ "none", "note", "warning", "error" ])
                  | doc m%"
                  A value specifying the severity level of the notification.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.location,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The locations relevant to this notification.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message that describes the condition that was encountered.
                  "%,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the notification.
                  "%
                  | optional,
                threadId
                  | std.number.Integer
                  | doc m%"
                  The thread identifier of the code that generated the notification.
                  "%
                  | optional,
                timeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which the analysis tool generated the notification.
                  "%
                  | optional,
              },
          physicalLocation
            | doc m%"
            A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.physicalLocation,
          propertyBag
            | doc m%"
            Key/value pairs that provide additional information about the object.
            "%
            = {
                tags
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of distinct strings that provide additional information.
                  "%
                  | optional,
                ..
              },
          rectangle
            | doc m%"
            An area within an image.
            "%
            = {
                bottom
                  | Number
                  | doc m%"
                  The Y coordinate of the bottom edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
                left
                  | Number
                  | doc m%"
                  The X coordinate of the left edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the rectangle.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the rectangle.
                  "%
                  | optional,
                right
                  | Number
                  | doc m%"
                  The X coordinate of the right edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
                top
                  | Number
                  | doc m%"
                  The Y coordinate of the top edge of the rectangle, measured in the image's natural units.
                  "%
                  | optional,
              },
          region
            | doc m%"
            A region within an artifact where a result was detected.
            "%
            = {
                byteLength
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The length of the region in bytes.
                  "%
                  | optional,
                byteOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The zero-based offset from the beginning of the artifact of the first byte in the region.
                  "%
                  | optional,
                charLength
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  The length of the region in characters.
                  "%
                  | optional,
                charOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The zero-based offset from the beginning of the artifact of the first character in the region.
                  "%
                  | optional,
                endColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The column number of the character following the end of the region.
                  "%
                  | optional,
                endLine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The line number of the last character in the region.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the region.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the region.
                  "%
                  | optional,
                snippet
                  | definitions.contract.artifactContent
                  | doc m%"
                  The portion of the artifact contents within the specified region.
                  "%
                  | optional,
                sourceLanguage
                  | String
                  | doc m%"
                  Specifies the source language, if any, of the portion of the artifact specified by the region object.
                  "%
                  | optional,
                startColumn
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The column number of the first character in the region.
                  "%
                  | optional,
                startLine
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  The line number of the first character in the region.
                  "%
                  | optional,
              },
          replacement
            | doc m%"
            The replacement of a single region of an artifact.
            "%
            = {
                deletedRegion
                  | definitions.contract.region
                  | doc m%"
                  The region of the artifact to delete.
                  "%,
                insertedContent
                  | definitions.contract.artifactContent
                  | doc m%"
                  The content to insert at the location specified by the 'deletedRegion' property.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the replacement.
                  "%
                  | optional,
              },
          reportingConfiguration
            | doc m%"
            Information about a rule or notification that can be configured at runtime.
            "%
            = {
                enabled
                  | Bool
                  | doc m%"
                  Specifies whether the report may be produced during the scan.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum [ "none", "note", "warning", "error" ])
                  | doc m%"
                  Specifies the failure level for the report.
                  "%
                  | optional,
                parameters
                  | definitions.contract.propertyBag
                  | doc m%"
                  Contains configuration information specific to a report.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the reporting configuration.
                  "%
                  | optional,
                rank
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 100,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  Specifies the relative priority of the report. Used for analysis output only.
                  "%
                  | optional,
              },
          reportingDescriptor
            | doc m%"
            Metadata that describes a specific report produced by the tool, as part of the analysis it provides or its runtime reporting.
            "%
            = {
                defaultConfiguration
                  | definitions.contract.reportingConfiguration
                  | doc m%"
                  Default reporting configuration information.
                  "%
                  | optional,
                deprecatedGuids
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.strings.pattern
                      "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                    ]),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of unique identifies in the form of a GUID by which this report was known in some previous version of the analysis tool.
                  "%
                  | optional,
                deprecatedIds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of stable, opaque identifiers by which this report was known in some previous version of the analysis tool.
                  "%
                  | optional,
                deprecatedNames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of readable identifiers by which this report was known in some previous version of the analysis tool.
                  "%
                  | optional,
                fullDescription
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  A description of the report. Should, as far as possible, provide details sufficient to enable resolution of any problem indicated by the result.
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A unique identifier for the reporting descriptor in the form of a GUID.
                  "%
                  | optional,
                help
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  Provides the primary documentation for the report, useful when there is no online documentation.
                  "%
                  | optional,
                helpUri
                  | String
                  | doc m%"
                  A URI where the primary documentation for the report can be found.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A stable, opaque identifier for the report.
                  "%,
                messageStrings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.multiformatMessageString
                  ])
                  | doc m%"
                  A set of name/value pairs with arbitrary names. Each value is a multiformatMessageString object, which holds message strings in plain text and (optionally) Markdown format. The strings can include placeholders, which can be used to construct a message in combination with an arbitrary number of additional string arguments.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A report identifier that is understandable to an end user.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the report.
                  "%
                  | optional,
                relationships
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.reportingDescriptorRelationship,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of objects that describe relationships between this reporting descriptor and others.
                  "%
                  | optional,
                shortDescription
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  A concise description of the report. Should be a single sentence that is understandable when visible space is limited to a single line of text.
                  "%
                  | optional,
              },
          reportingDescriptorReference
            | doc m%"
            Information about how to locate a relevant reporting descriptor.
            "%
            = predicates.contract_from_predicate
              definitions.predicate.reportingDescriptorReference,
          reportingDescriptorRelationship
            | doc m%"
            Information about the relation of one reporting descriptor to another.
            "%
            = {
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of the reporting descriptor relationship.
                  "%
                  | optional,
                kinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of distinct strings that categorize the relationship. Well-known kinds include 'canPrecede', 'canFollow', 'willPrecede', 'willFollow', 'superset', 'subset', 'equal', 'disjoint', 'relevant', and 'incomparable'.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the reporting descriptor reference.
                  "%
                  | optional,
                target
                  | definitions.contract.reportingDescriptorReference
                  | doc m%"
                  A reference to the related reporting descriptor.
                  "%,
              },
          result
            | doc m%"
            A result produced by an analysis tool.
            "%
            = {
                analysisTarget
                  | definitions.contract.artifactLocation
                  | doc m%"
                  Identifies the artifact that the analysis tool was instructed to scan. This need not be the same as the artifact where the result actually occurred.
                  "%
                  | optional,
                attachments
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.attachment,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of artifacts relevant to the result.
                  "%
                  | optional,
                baselineState
                  | predicates.contract_from_predicate
                  (predicates.enum [ "new", "unchanged", "updated", "absent" ])
                  | doc m%"
                  The state of a result relative to a baseline of a previous run.
                  "%
                  | optional,
                codeFlows
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.codeFlow,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  An array of 'codeFlow' objects relevant to the result.
                  "%
                  | optional,
                correlationGuid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for the equivalence class of logically identical results to which this result belongs, in the form of a GUID.
                  "%
                  | optional,
                fingerprints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of strings each of which individually defines a stable, unique identity for the result.
                  "%
                  | optional,
                fixes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.fix,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'fix' objects, each of which represents a proposed fix to the problem indicated by the result.
                  "%
                  | optional,
                graphTraversals
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.graphTraversal,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of one or more unique 'graphTraversal' objects.
                  "%
                  | optional,
                graphs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.graph,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of zero or more unique graph objects associated with the result.
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for the result in the form of a GUID.
                  "%
                  | optional,
                hostedViewerUri
                  | String
                  | doc m%"
                  An absolute URI at which the result can be viewed.
                  "%
                  | optional,
                kind
                  | predicates.contract_from_predicate
                  (predicates.enum
                  [
                    "notApplicable",
                    "pass",
                    "fail",
                    "review",
                    "open",
                    "informational"
                  ])
                  | doc m%"
                  A value that categorizes results by evaluation state.
                  "%
                  | optional,
                level
                  | predicates.contract_from_predicate
                  (predicates.enum [ "none", "note", "warning", "error" ])
                  | doc m%"
                  A value specifying the severity level of the result.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.location,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  The set of locations where the result was detected. Specify only one location unless the problem indicated by the result can only be corrected by making a change at every specified location.
                  "%
                  | optional,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message that describes the result. The first sentence of the message only will be displayed when visible space is limited.
                  "%,
                occurrenceCount
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 1 ])
                  | doc m%"
                  A positive integer specifying the number of times this logically unique result was observed in this run.
                  "%
                  | optional,
                partialFingerprints
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  A set of strings that contribute to the stable, unique identity of the result.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the result.
                  "%
                  | optional,
                provenance
                  | definitions.contract.resultProvenance
                  | doc m%"
                  Information about how and when the result was detected.
                  "%
                  | optional,
                rank
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 100,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  A number representing the priority or importance of the result.
                  "%
                  | optional,
                relatedLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.location,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of locations relevant to this result.
                  "%
                  | optional,
                rule
                  | definitions.contract.reportingDescriptorReference
                  | doc m%"
                  A reference used to locate the rule descriptor relevant to this result.
                  "%
                  | optional,
                ruleId
                  | String
                  | doc m%"
                  The stable, unique identifier of the rule, if any, to which this notification is relevant. This member can be used to retrieve rule metadata from the rules dictionary, if it exists.
                  "%
                  | optional,
                ruleIndex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the tool component rules array of the rule object associated with this result.
                  "%
                  | optional,
                stacks
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.stack,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of 'stack' objects relevant to the result.
                  "%
                  | optional,
                suppressions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.suppression,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of suppressions relevant to this result.
                  "%
                  | optional,
                taxa
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.reportingDescriptorReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of references to taxonomy reporting descriptors that are applicable to the result.
                  "%
                  | optional,
                webRequest
                  | definitions.contract.webRequest
                  | doc m%"
                  A web request associated with this result.
                  "%
                  | optional,
                webResponse
                  | definitions.contract.webResponse
                  | doc m%"
                  A web response associated with this result.
                  "%
                  | optional,
                workItemUris
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The URIs of the work items associated with this result.
                  "%
                  | optional,
              },
          resultProvenance
            | doc m%"
            Contains information about how and when a result was detected.
            "%
            = {
                conversionSources
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.physicalLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of physicalLocation objects which specify the portions of an analysis tool's output that a converter transformed into the result.
                  "%
                  | optional,
                firstDetectionRunGuid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A GUID-valued string equal to the automationDetails.guid property of the run in which the result was first detected.
                  "%
                  | optional,
                firstDetectionTimeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which the result was first detected. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                invocationIndex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the run.invocations array of the invocation object which describes the tool invocation that detected the result.
                  "%
                  | optional,
                lastDetectionRunGuid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A GUID-valued string equal to the automationDetails.guid property of the run in which the result was most recently detected.
                  "%
                  | optional,
                lastDetectionTimeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which the result was most recently detected. See "Date/time properties" in the SARIF spec for the required format.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the result.
                  "%
                  | optional,
              },
          run
            | doc m%"
            Describes a single run of an analysis tool, and contains the reported output of that run.
            "%
            = {
                addresses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.address,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  Addresses associated with this run instance, if any.
                  "%
                  | optional,
                artifacts
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.artifact,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of artifact objects relevant to the run.
                  "%
                  | optional,
                automationDetails
                  | definitions.contract.runAutomationDetails
                  | doc m%"
                  Automation details that describe this run.
                  "%
                  | optional,
                baselineGuid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  The 'guid' property of a previous SARIF 'run' that comprises the baseline that was used to compute result 'baselineState' properties for the run.
                  "%
                  | optional,
                columnKind
                  | predicates.contract_from_predicate
                  (predicates.enum [ "utf16CodeUnits", "unicodeCodePoints" ])
                  | doc m%"
                  Specifies the unit in which the tool measures columns.
                  "%
                  | optional,
                conversion
                  | definitions.contract.conversion
                  | doc m%"
                  A conversion object that describes how a converter transformed an analysis tool's native reporting format into the SARIF format.
                  "%
                  | optional,
                defaultEncoding
                  | String
                  | doc m%"
                  Specifies the default encoding for any artifact object that refers to a text file.
                  "%
                  | optional,
                defaultSourceLanguage
                  | String
                  | doc m%"
                  Specifies the default source language for any artifact object that refers to a text file that contains source code.
                  "%
                  | optional,
                externalPropertyFileReferences
                  | definitions.contract.externalPropertyFileReferences
                  | doc m%"
                  References to external property files that should be inlined with the content of a root log file.
                  "%
                  | optional,
                graphs
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.graph,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of zero or more unique graph objects associated with the run.
                  "%
                  | optional,
                invocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.invocation,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  Describes the invocation of the analysis tool.
                  "%
                  | optional,
                language
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[a-zA-Z]{2}|^[a-zA-Z]{2}-[a-zA-Z]{2}?$"
                  ])
                  | doc m%"
                  The language of the messages emitted into the log file during this run (expressed as an ISO 639-1 two-letter lowercase culture code) and an optional region (expressed as an ISO 3166-1 two-letter uppercase subculture code associated with a country or region). The casing is recommended but not required (in order for this data to conform to RFC5646).
                  "%
                  | optional,
                logicalLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.logicalLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of logical locations such as namespaces, types or functions.
                  "%
                  | optional,
                newlineSequences
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 1,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An ordered list of character sequences that were treated as line breaks when computing region information for the run.
                  "%
                  | optional,
                originalUriBaseIds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.artifactLocation
                  ])
                  | doc m%"
                  The artifact location specified by each uriBaseId symbol on the machine where the tool originally ran.
                  "%
                  | optional,
                policies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Contains configurations that may potentially override both reportingDescriptor.defaultConfiguration (the tool's default severities) and invocation.configurationOverrides (severities established at run-time from the command line).
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the run.
                  "%
                  | optional,
                redactionTokens
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of strings used to replace sensitive information in a redaction-aware property.
                  "%
                  | optional,
                results
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.result,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  The set of results contained in an SARIF log. The results array can be omitted when a run is solely exporting rules metadata. It must be present (but may be empty) if a log file represents an actual scan.
                  "%
                  | optional,
                runAggregates
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.runAutomationDetails,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Automation details that describe the aggregate of runs to which this run belongs.
                  "%
                  | optional,
                specialLocations
                  | definitions.contract.specialLocations
                  | doc m%"
                  A specialLocations object that defines locations of special significance to SARIF consumers.
                  "%
                  | optional,
                taxonomies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of toolComponent objects relevant to a taxonomy in which results are categorized.
                  "%
                  | optional,
                threadFlowLocations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.threadFlowLocation,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of threadFlowLocation objects cached at run level.
                  "%
                  | optional,
                tool
                  | definitions.contract.tool
                  | doc m%"
                  Information about the tool or tool pipeline that generated the results in this run. A run can only contain results produced by a single tool or tool pipeline. A run can aggregate results from multiple log files, as long as context around the tool run (tool command-line arguments and the like) is identical for all aggregated files.
                  "%,
                translations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The set of available translations of the localized data provided by the tool.
                  "%
                  | optional,
                versionControlProvenance
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.versionControlDetails,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Specifies the revision in version control of the artifacts that were scanned.
                  "%
                  | optional,
                webRequests
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.webRequest,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of request objects cached at run level.
                  "%
                  | optional,
                webResponses
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.webResponse,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of response objects cached at run level.
                  "%
                  | optional,
              },
          runAutomationDetails
            | doc m%"
            Information that describes a run's identity and role within an engineering system process.
            "%
            = {
                correlationGuid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for the equivalence class of runs to which this object's containing run object belongs in the form of a GUID.
                  "%
                  | optional,
                description
                  | definitions.contract.message
                  | doc m%"
                  A description of the identity and role played within the engineering system by this object's containing run object.
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for this object's containing run object in the form of a GUID.
                  "%
                  | optional,
                id
                  | String
                  | doc m%"
                  A hierarchical string that uniquely identifies this object's containing run object.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the run automation details.
                  "%
                  | optional,
              },
          specialLocations
            | doc m%"
            Defines locations of special significance to SARIF consumers.
            "%
            = {
                displayBase
                  | definitions.contract.artifactLocation
                  | doc m%"
                  Provides a suggestion to SARIF consumers to display file paths relative to the specified location.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the special locations.
                  "%
                  | optional,
                ..
              },
          stack
            | doc m%"
            A call stack that is relevant to a result.
            "%
            = {
                frames
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.stackFrame,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  An array of stack frames that represents a sequence of calls, rendered in reverse chronological order, that comprise the call stack.
                  "%,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to this call stack.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the stack.
                  "%
                  | optional,
              },
          stackFrame
            | doc m%"
            A function call within a stack trace.
            "%
            = {
                location
                  | definitions.contract.location
                  | doc m%"
                  The location to which this stack frame refers.
                  "%
                  | optional,
                module
                  | String
                  | doc m%"
                  The name of the module that contains the code of this stack frame.
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  The parameters of the call that is executing.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the stack frame.
                  "%
                  | optional,
                threadId
                  | std.number.Integer
                  | doc m%"
                  The thread identifier of the stack frame.
                  "%
                  | optional,
              },
          suppression
            | doc m%"
            A suppression that is relevant to a result.
            "%
            = {
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A stable, unique identifier for the suppression in the form of a GUID.
                  "%
                  | optional,
                justification
                  | String
                  | doc m%"
                  A string representing the justification for the suppression.
                  "%
                  | optional,
                kind
                  | predicates.contract_from_predicate
                  (predicates.enum [ "inSource", "external" ])
                  | doc m%"
                  A string that indicates where the suppression is persisted.
                  "%,
                location
                  | definitions.contract.location
                  | doc m%"
                  Identifies the location associated with the suppression.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the suppression.
                  "%
                  | optional,
                state
                  | predicates.contract_from_predicate
                  (predicates.enum [ "accepted", "underReview", "rejected" ])
                  | doc m%"
                  A string that indicates the state of the suppression.
                  "%
                  | optional,
              },
          threadFlow = {
                id
                  | String
                  | doc m%"
                  An string that uniquely identifies the threadFlow within the codeFlow in which it occurs.
                  "%
                  | optional,
                immutableState
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.multiformatMessageString
                  ])
                  | doc m%"
                  Values of relevant expressions at the start of the thread flow that remain constant.
                  "%
                  | optional,
                initialState
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.multiformatMessageString
                  ])
                  | doc m%"
                  Values of relevant expressions at the start of the thread flow that may change during thread flow execution.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.threadFlowLocation,
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  A temporally ordered array of 'threadFlowLocation' objects, each of which describes a location visited by the tool while producing the result.
                  "%,
                message
                  | definitions.contract.message
                  | doc m%"
                  A message relevant to the thread flow.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the thread flow.
                  "%
                  | optional,
                ..
              },
          threadFlowLocation
            | doc m%"
            A location visited by an analysis tool while simulating or monitoring the execution of a program.
            "%
            = {
                executionOrder
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  An integer representing the temporal order in which execution reached this location.
                  "%
                  | optional,
                executionTimeUtc
                  | String
                  | doc m%"
                  The Coordinated Universal Time (UTC) date and time at which this location was executed.
                  "%
                  | optional,
                importance
                  | predicates.contract_from_predicate
                  (predicates.enum [ "important", "essential", "unimportant" ])
                  | doc m%"
                  Specifies the importance of this location in understanding the code flow in which it occurs. The order from most to least important is "essential", "important", "unimportant". Default: "important".
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the run threadFlowLocations array.
                  "%
                  | optional,
                kinds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String"),
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  A set of distinct strings that categorize the thread flow location. Well-known kinds include 'acquire', 'release', 'enter', 'exit', 'call', 'return', 'branch', 'implicit', 'false', 'true', 'caution', 'danger', 'unknown', 'unreachable', 'taint', 'function', 'handler', 'lock', 'memory', 'resource', 'scope' and 'value'.
                  "%
                  | optional,
                location
                  | definitions.contract.location
                  | doc m%"
                  The code location.
                  "%
                  | optional,
                module
                  | String
                  | doc m%"
                  The name of the module that contains the code that is executing.
                  "%
                  | optional,
                nestingLevel
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType 'Integer, predicates.numbers.minimum 0 ])
                  | doc m%"
                  An integer representing a containment hierarchy within the thread flow.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the threadflow location.
                  "%
                  | optional,
                stack
                  | definitions.contract.stack
                  | doc m%"
                  The call stack leading to this location.
                  "%
                  | optional,
                state
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.multiformatMessageString
                  ])
                  | doc m%"
                  A dictionary, each of whose keys specifies a variable or expression, the associated value of which represents the variable or expression value. For an annotation of kind 'continuation', for example, this dictionary might hold the current assumed values of a set of global variables.
                  "%
                  | optional,
                taxa
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.reportingDescriptorReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of references to rule or taxonomy reporting descriptors that are applicable to the thread flow location.
                  "%
                  | optional,
                webRequest
                  | definitions.contract.webRequest
                  | doc m%"
                  A web request associated with this thread flow location.
                  "%
                  | optional,
                webResponse
                  | definitions.contract.webResponse
                  | doc m%"
                  A web response associated with this thread flow location.
                  "%
                  | optional,
              },
          tool
            | doc m%"
            The analysis tool that was run.
            "%
            = {
                driver
                  | definitions.contract.toolComponent
                  | doc m%"
                  The analysis tool that was run.
                  "%,
                extensions
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponent,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  Tool extensions that contributed to or reconfigured the analysis tool that was run.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the tool.
                  "%
                  | optional,
              },
          toolComponent
            | doc m%"
            A component, such as a plug-in or the driver, of the analysis tool that was run.
            "%
            = {
                associatedComponent
                  | definitions.contract.toolComponentReference
                  | doc m%"
                  The component which is strongly associated with this component. For a translation, this refers to the component which has been translated. For an extension, this is the driver that provides the extension's plugin model.
                  "%
                  | optional,
                contents
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.enum [ "localizedData", "nonLocalizedData" ]),
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  The kinds of data contained in this object.
                  "%
                  | optional,
                dottedQuadFileVersion
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                  ])
                  | doc m%"
                  The binary version of the tool component's primary executable file expressed as four non-negative integers separated by a period (for operating systems that express file versions in this way).
                  "%
                  | optional,
                downloadUri
                  | String
                  | doc m%"
                  The absolute URI from which the tool component can be downloaded.
                  "%
                  | optional,
                fullDescription
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  A comprehensive description of the tool component.
                  "%
                  | optional,
                fullName
                  | String
                  | doc m%"
                  The name of the tool component along with its version and any other useful identifying information, such as its locale.
                  "%
                  | optional,
                globalMessageStrings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.multiformatMessageString
                  ])
                  | doc m%"
                  A dictionary, each of whose keys is a resource identifier and each of whose values is a multiformatMessageString object, which holds message strings in plain text and (optionally) Markdown format. The strings can include placeholders, which can be used to construct a message in combination with an arbitrary number of additional string arguments.
                  "%
                  | optional,
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  A unique identifier for the tool component in the form of a GUID.
                  "%
                  | optional,
                informationUri
                  | String
                  | doc m%"
                  The absolute URI at which information about this version of the tool component can be found.
                  "%
                  | optional,
                isComprehensive
                  | Bool
                  | doc m%"
                  Specifies whether this object contains a complete definition of the localizable and/or non-localizable data for this component, as opposed to including only data that is relevant to the results persisted to this log file.
                  "%
                  | optional,
                language
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[a-zA-Z]{2}|^[a-zA-Z]{2}-[a-zA-Z]{2}?$"
                  ])
                  | doc m%"
                  The language of the messages emitted into the log file during this run (expressed as an ISO 639-1 two-letter lowercase language code) and an optional region (expressed as an ISO 3166-1 two-letter uppercase subculture code associated with a country or region). The casing is recommended but not required (in order for this data to conform to RFC5646).
                  "%
                  | optional,
                localizedDataSemanticVersion
                  | String
                  | doc m%"
                  The semantic version of the localized strings defined in this component; maintained by components that provide translations.
                  "%
                  | optional,
                locations
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.artifactLocation,
                    predicates.arrays.minItems 0
                  ])
                  | doc m%"
                  An array of the artifactLocation objects associated with the tool component.
                  "%
                  | optional,
                minimumRequiredLocalizedDataSemanticVersion
                  | String
                  | doc m%"
                  The minimum value of localizedDataSemanticVersion required in translations consumed by this component; used by components that consume translations.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name of the tool component.
                  "%,
                notifications
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.reportingDescriptor,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of reportingDescriptor objects relevant to the notifications related to the configuration and runtime execution of the tool component.
                  "%
                  | optional,
                organization
                  | String
                  | doc m%"
                  The organization or company that produced the tool component.
                  "%
                  | optional,
                product
                  | String
                  | doc m%"
                  A product suite to which the tool component belongs.
                  "%
                  | optional,
                productSuite
                  | String
                  | doc m%"
                  A localizable string containing the name of the suite of products to which the tool component belongs.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the tool component.
                  "%
                  | optional,
                releaseDateUtc
                  | String
                  | doc m%"
                  A string specifying the UTC date (and optionally, the time) of the component's release.
                  "%
                  | optional,
                rules
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.reportingDescriptor,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of reportingDescriptor objects relevant to the analysis performed by the tool component.
                  "%
                  | optional,
                semanticVersion
                  | String
                  | doc m%"
                  The tool component version in the format specified by Semantic Versioning 2.0.
                  "%
                  | optional,
                shortDescription
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  A brief description of the tool component.
                  "%
                  | optional,
                supportedTaxonomies
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.toolComponentReference,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of toolComponentReference objects to declare the taxonomies supported by the tool component.
                  "%
                  | optional,
                taxa
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.reportingDescriptor,
                    predicates.arrays.minItems 0,
                    predicates.arrays.uniqueItems
                  ])
                  | doc m%"
                  An array of reportingDescriptor objects relevant to the definitions of both standalone and tool-defined taxonomies.
                  "%
                  | optional,
                translationMetadata
                  | definitions.contract.translationMetadata
                  | doc m%"
                  Translation metadata, required for a translation, not populated by other component types.
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  The tool component version, in whatever format the component natively provides.
                  "%
                  | optional,
              },
          toolComponentReference
            | doc m%"
            
            "%
            = {
                guid
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.strings.pattern
                    "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                  ])
                  | doc m%"
                  The 'guid' property of the referenced toolComponent.
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  An index into the referenced toolComponent in tool.extensions.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The 'name' property of the referenced toolComponent.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the toolComponentReference.
                  "%
                  | optional,
                ..
              },
          translationMetadata
            | doc m%"
            Provides additional metadata related to translation.
            "%
            = {
                downloadUri
                  | String
                  | doc m%"
                  The absolute URI from which the translation metadata can be downloaded.
                  "%
                  | optional,
                fullDescription
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  A comprehensive description of the translation metadata.
                  "%
                  | optional,
                fullName
                  | String
                  | doc m%"
                  The full name associated with the translation metadata.
                  "%
                  | optional,
                informationUri
                  | String
                  | doc m%"
                  The absolute URI from which information related to the translation metadata can be downloaded.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  The name associated with the translation metadata.
                  "%,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the translation metadata.
                  "%
                  | optional,
                shortDescription
                  | definitions.contract.multiformatMessageString
                  | doc m%"
                  A brief description of the translation metadata.
                  "%
                  | optional,
                ..
              },
          versionControlDetails
            | doc m%"
            Specifies the information necessary to retrieve a desired revision from a version control system.
            "%
            = {
                asOfTimeUtc
                  | String
                  | doc m%"
                  A Coordinated Universal Time (UTC) date and time that can be used to synchronize an enlistment to the state of the repository at that time.
                  "%
                  | optional,
                branch
                  | String
                  | doc m%"
                  The name of a branch containing the revision.
                  "%
                  | optional,
                mappedTo
                  | definitions.contract.artifactLocation
                  | doc m%"
                  The location in the local file system to which the root of the repository was mapped at the time of the analysis.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the version control details.
                  "%
                  | optional,
                repositoryUri
                  | String
                  | doc m%"
                  The absolute URI of the repository.
                  "%,
                revisionId
                  | String
                  | doc m%"
                  A string that uniquely and permanently identifies the revision within the repository.
                  "%
                  | optional,
                revisionTag
                  | String
                  | doc m%"
                  A tag that has been applied to the revision.
                  "%
                  | optional,
              },
          webRequest
            | doc m%"
            A web request object.
            "%
            = {
                body
                  | definitions.contract.artifactContent
                  | doc m%"
                  The body of the request.
                  "%
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The request headers.
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the run.webRequests array of the request object associated with this result.
                  "%
                  | optional,
                method
                  | String
                  | doc m%"
                  The HTTP method. Well-known values are 'GET', 'PUT', 'POST', 'DELETE', 'PATCH', 'HEAD', 'OPTIONS', 'TRACE', 'CONNECT'.
                  "%
                  | optional,
                parameters
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The request parameters.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the request.
                  "%
                  | optional,
                protocol
                  | String
                  | doc m%"
                  The request protocol. Example: 'http'.
                  "%
                  | optional,
                target
                  | String
                  | doc m%"
                  The target of the request.
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  The request version. Example: '1.1'.
                  "%
                  | optional,
                ..
              },
          webResponse
            | doc m%"
            A web response object.
            "%
            = {
                body
                  | definitions.contract.artifactContent
                  | doc m%"
                  The body of the response.
                  "%
                  | optional,
                headers
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The response headers.
                  "%
                  | optional,
                index
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Integer,
                    predicates.numbers.minimum (-1)
                  ])
                  | doc m%"
                  The index within the run.webResponses array of the response object associated with this result.
                  "%
                  | optional,
                noResponseReceived
                  | Bool
                  | doc m%"
                  Specifies whether a response was received from the server.
                  "%
                  | optional,
                properties
                  | definitions.contract.propertyBag
                  | doc m%"
                  Key/value pairs that provide additional information about the response.
                  "%
                  | optional,
                protocol
                  | String
                  | doc m%"
                  The response protocol. Example: 'http'.
                  "%
                  | optional,
                reasonPhrase
                  | String
                  | doc m%"
                  The response reason. Example: 'Not found'.
                  "%
                  | optional,
                statusCode
                  | std.number.Integer
                  | doc m%"
                  The response status code. Example: 451.
                  "%
                  | optional,
                version
                  | String
                  | doc m%"
                  The response version. Example: '1.1'.
                  "%
                  | optional,
                ..
              },
        },
    predicate = {
          address
            | doc m%"
            A physical or virtual address, or a range of addresses, in an 'addressable region' (memory or a binary file).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  absoluteAddress = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  fullyQualifiedName = predicates.isType '"String",
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  kind = predicates.isType '"String",
                  length = predicates.isType 'Integer,
                  name = predicates.isType '"String",
                  offsetFromParent = predicates.isType 'Integer,
                  parentIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  properties = definitions.predicate.propertyBag,
                  relativeAddress = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          artifact
            | doc m%"
            A single artifact. In some cases, this artifact might be nested within another artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contents = definitions.predicate.artifactContent,
                  description = definitions.predicate.message,
                  encoding = predicates.isType '"String",
                  hashes = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  lastModifiedTimeUtc = predicates.isType '"String",
                  length = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  location = definitions.predicate.artifactLocation,
                  mimeType = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "[^/]+/.+"
                      ],
                  offset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  parentIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  properties = definitions.predicate.propertyBag,
                  roles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum
                        [
                          "analysisTarget",
                          "attachment",
                          "responseFile",
                          "resultFile",
                          "standardStream",
                          "tracedFile",
                          "unmodified",
                          "modified",
                          "added",
                          "deleted",
                          "renamed",
                          "uncontrolled",
                          "driver",
                          "extension",
                          "translation",
                          "taxonomy",
                          "policy",
                          "referencedOnCommandLine",
                          "memoryContents",
                          "directory",
                          "userSpecifiedConfiguration",
                          "toolSpecifiedConfiguration",
                          "debugOutputFile"
                        ]),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  sourceLanguage = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          artifactChange
            | doc m%"
            A change to a single artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "artifactLocation", "replacements" ],
                predicates.records.record
                {
                  artifactLocation = definitions.predicate.artifactLocation,
                  properties = definitions.predicate.propertyBag,
                  replacements = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.replacement,
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          artifactContent
            | doc m%"
            Represents the contents of an artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  binary = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  rendered = definitions.predicate.multiformatMessageString,
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          artifactLocation
            | doc m%"
            Specifies the location of an artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  properties = definitions.predicate.propertyBag,
                  uri = predicates.isType '"String",
                  uriBaseId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          attachment
            | doc m%"
            An artifact relevant to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "artifactLocation" ],
                predicates.records.record
                {
                  artifactLocation = definitions.predicate.artifactLocation,
                  description = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  rectangles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.rectangle,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  regions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.region,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          codeFlow
            | doc m%"
            A set of threadFlows which together describe a pattern of code execution relevant to detecting a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "threadFlows" ],
                predicates.records.record
                {
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  threadFlows = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.threadFlow,
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          configurationOverride
            | doc m%"
            Information about how a specific rule or notification was reconfigured at runtime.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "configuration", "descriptor" ],
                predicates.records.record
                {
                  configuration = definitions.predicate.reportingConfiguration,
                  descriptor =
                    definitions.predicate.reportingDescriptorReference,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          conversion
            | doc m%"
            Describes how a converter transformed the output of a static analysis tool from the analysis tool's native output format into the SARIF format.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tool" ],
                predicates.records.record
                {
                  analysisToolLogFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.artifactLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  invocation = definitions.predicate.invocation,
                  properties = definitions.predicate.propertyBag,
                  tool = definitions.predicate.tool,
                }
                {  }
                false
                predicates.never
              ],
          edge
            | doc m%"
            Represents a directed edge in a graph.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required
                [ "id", "sourceNodeId", "targetNodeId" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  label = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  sourceNodeId = predicates.isType '"String",
                  targetNodeId = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          edgeTraversal
            | doc m%"
            Represents the traversal of a single edge during a graph traversal.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "edgeId" ],
                predicates.records.record
                {
                  edgeId = predicates.isType '"String",
                  finalState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  stepOverEdgeCount = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          exception = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  innerExceptions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.exception,
                        predicates.arrays.minItems 0
                      ],
                  kind = predicates.isType '"String",
                  message = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  stack = definitions.predicate.stack,
                }
                {  }
                true
                predicates.always
              ],
          externalProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addresses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.address,
                        predicates.arrays.minItems 0
                      ],
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.artifact,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  conversion = definitions.predicate.conversion,
                  driver = definitions.predicate.toolComponent,
                  extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  externalizedProperties = definitions.predicate.propertyBag,
                  graphs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.graph,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  invocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.invocation,
                        predicates.arrays.minItems 0
                      ],
                  logicalLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.logicalLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  policies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                  results = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.result,
                        predicates.arrays.minItems 0
                      ],
                  runGuid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  schema = predicates.isType '"String",
                  taxonomies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  threadFlowLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.threadFlowLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  translations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  version = predicates.enum [ "2.1.0" ],
                  webRequests = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.webRequest,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webResponses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.webResponse,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                true
                predicates.always
              ],
          externalPropertyFileReference = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "location" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "guid" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  itemCount = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  location = definitions.predicate.artifactLocation,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                true
                predicates.always
              ],
          externalPropertyFileReferences
            | doc m%"
            References to external property files that should be inlined with the content of a root log file.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  addresses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  conversion =
                    definitions.predicate.externalPropertyFileReference,
                  driver = definitions.predicate.externalPropertyFileReference,
                  extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  externalizedProperties =
                    definitions.predicate.externalPropertyFileReference,
                  graphs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  invocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  logicalLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  policies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                  results = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  taxonomies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  threadFlowLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  translations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webRequests = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webResponses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.externalPropertyFileReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          fix
            | doc m%"
            A proposed fix for the problem represented by a result object. A fix specifies a set of artifacts to modify. For each artifact, it specifies a set of bytes to remove, and provides a set of new bytes to replace them.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "artifactChanges" ],
                predicates.records.record
                {
                  artifactChanges = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.artifactChange,
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  description = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          graph
            | doc m%"
            A network of nodes and directed edges that describes some aspect of the structure of the code (for example, a call graph).
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  edges = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.edge,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  nodes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.node,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          graphTraversal
            | doc m%"
            Represents a path through a graph.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "runGraphIndex" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "resultGraphIndex" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  edgeTraversals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.edgeTraversal,
                        predicates.arrays.minItems 0
                      ],
                  immutableState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  initialState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  properties = definitions.predicate.propertyBag,
                  resultGraphIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  runGraphIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                }
                {  }
                false
                predicates.never
              ],
          invocation
            | doc m%"
            The runtime environment of the analysis tool run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "executionSuccessful" ],
                predicates.records.record
                {
                  account = predicates.isType '"String",
                  arguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0
                      ],
                  commandLine = predicates.isType '"String",
                  endTimeUtc = predicates.isType '"String",
                  environmentVariables = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  executableLocation = definitions.predicate.artifactLocation,
                  executionSuccessful = predicates.isType '"Bool",
                  exitCode = predicates.isType 'Integer,
                  exitCodeDescription = predicates.isType '"String",
                  exitSignalName = predicates.isType '"String",
                  exitSignalNumber = predicates.isType 'Integer,
                  machine = predicates.isType '"String",
                  notificationConfigurationOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.configurationOverride,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  processId = predicates.isType 'Integer,
                  processStartFailureMessage = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  responseFiles = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.artifactLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  ruleConfigurationOverrides = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.configurationOverride,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  startTimeUtc = predicates.isType '"String",
                  stderr = definitions.predicate.artifactLocation,
                  stdin = definitions.predicate.artifactLocation,
                  stdout = definitions.predicate.artifactLocation,
                  stdoutStderr = definitions.predicate.artifactLocation,
                  toolConfigurationNotifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.notification,
                        predicates.arrays.minItems 0
                      ],
                  toolExecutionNotifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.notification,
                        predicates.arrays.minItems 0
                      ],
                  workingDirectory = definitions.predicate.artifactLocation,
                }
                {  }
                false
                predicates.never
              ],
          location
            | doc m%"
            A location within a programming artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  annotations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.region,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  id = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  logicalLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.logicalLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  message = definitions.predicate.message,
                  physicalLocation = definitions.predicate.physicalLocation,
                  properties = definitions.predicate.propertyBag,
                  relationships = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.locationRelationship,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          locationRelationship
            | doc m%"
            Information about the relation of one location to another.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "target" ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  kinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                  target = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          logicalLocation
            | doc m%"
            A logical location of a construct that produced a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  decoratedName = predicates.isType '"String",
                  fullyQualifiedName = predicates.isType '"String",
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  kind = predicates.isType '"String",
                  name = predicates.isType '"String",
                  parentIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          message
            | doc m%"
            Encapsulates a message intended to be read by the end user.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "text" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  arguments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0
                      ],
                  id = predicates.isType '"String",
                  markdown = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          multiformatMessageString
            | doc m%"
            A message string or message format string rendered in multiple formats.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "text" ],
                predicates.records.record
                {
                  markdown = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          node
            | doc m%"
            Represents a node in a graph.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  children = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.node,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  id = predicates.isType '"String",
                  label = definitions.predicate.message,
                  location = definitions.predicate.location,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          notification
            | doc m%"
            Describes a condition relevant to the tool itself, as opposed to being relevant to a target being analyzed by the tool.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message" ],
                predicates.records.record
                {
                  associatedRule =
                    definitions.predicate.reportingDescriptorReference,
                  descriptor =
                    definitions.predicate.reportingDescriptorReference,
                  exception = definitions.predicate.exception,
                  level = predicates.enum
                      [ "none", "note", "warning", "error" ],
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.location,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  threadId = predicates.isType 'Integer,
                  timeUtc = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          physicalLocation
            | doc m%"
            A physical location relevant to a result. Specifies a reference to a programming artifact together with a range of bytes or characters within that artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "address" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "artifactLocation" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  address = definitions.predicate.address,
                  artifactLocation = definitions.predicate.artifactLocation,
                  contextRegion = definitions.predicate.region,
                  properties = definitions.predicate.propertyBag,
                  region = definitions.predicate.region,
                }
                {  }
                false
                predicates.never
              ],
          propertyBag
            | doc m%"
            Key/value pairs that provide additional information about the object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  tags = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                true
                predicates.always
              ],
          rectangle
            | doc m%"
            An area within an image.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bottom = predicates.isType '"Number",
                  left = predicates.isType '"Number",
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  right = predicates.isType '"Number",
                  top = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          region
            | doc m%"
            A region within an artifact where a result was detected.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  byteLength = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  byteOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  charLength = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  charOffset = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  endColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  endLine = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                  snippet = definitions.predicate.artifactContent,
                  sourceLanguage = predicates.isType '"String",
                  startColumn = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  startLine = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          replacement
            | doc m%"
            The replacement of a single region of an artifact.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "deletedRegion" ],
                predicates.records.record
                {
                  deletedRegion = definitions.predicate.region,
                  insertedContent = definitions.predicate.artifactContent,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          reportingConfiguration
            | doc m%"
            Information about a rule or notification that can be configured at runtime.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  enabled = predicates.isType '"Bool",
                  level = predicates.enum
                      [ "none", "note", "warning", "error" ],
                  parameters = definitions.predicate.propertyBag,
                  properties = definitions.predicate.propertyBag,
                  rank = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 100,
                        predicates.numbers.minimum (-1)
                      ],
                }
                {  }
                false
                predicates.never
              ],
          reportingDescriptor
            | doc m%"
            Metadata that describes a specific report produced by the tool, as part of the analysis it provides or its runtime reporting.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "id" ],
                predicates.records.record
                {
                  defaultConfiguration =
                    definitions.predicate.reportingConfiguration,
                  deprecatedGuids = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.strings.pattern
                          "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                        ]),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  deprecatedIds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  deprecatedNames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  fullDescription =
                    definitions.predicate.multiformatMessageString,
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  help = definitions.predicate.multiformatMessageString,
                  helpUri = predicates.isType '"String",
                  id = predicates.isType '"String",
                  messageStrings = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  name = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  relationships = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.reportingDescriptorRelationship,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  shortDescription =
                    definitions.predicate.multiformatMessageString,
                }
                {  }
                false
                predicates.never
              ],
          reportingDescriptorReference
            | doc m%"
            Information about how to locate a relevant reporting descriptor.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.anyOf
                [
                  predicates.allOf
                  [
                    predicates.records.required [ "index" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "guid" ],
                    predicates.records.record {  } {  } true predicates.always
                  ],
                  predicates.allOf
                  [
                    predicates.records.required [ "id" ],
                    predicates.records.record {  } {  } true predicates.always
                  ]
                ],
                predicates.records.record
                {
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  id = predicates.isType '"String",
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  properties = definitions.predicate.propertyBag,
                  toolComponent = definitions.predicate.toolComponentReference,
                }
                {  }
                false
                predicates.never
              ],
          reportingDescriptorRelationship
            | doc m%"
            Information about the relation of one reporting descriptor to another.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "target" ],
                predicates.records.record
                {
                  description = definitions.predicate.message,
                  kinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                  target = definitions.predicate.reportingDescriptorReference,
                }
                {  }
                false
                predicates.never
              ],
          result
            | doc m%"
            A result produced by an analysis tool.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "message" ],
                predicates.records.record
                {
                  analysisTarget = definitions.predicate.artifactLocation,
                  attachments = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.attachment,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  baselineState = predicates.enum
                      [ "new", "unchanged", "updated", "absent" ],
                  codeFlows = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.codeFlow,
                        predicates.arrays.minItems 0
                      ],
                  correlationGuid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  fingerprints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  fixes = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.fix,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  graphTraversals = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.graphTraversal,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  graphs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.graph,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  hostedViewerUri = predicates.isType '"String",
                  kind = predicates.enum
                      [
                        "notApplicable",
                        "pass",
                        "fail",
                        "review",
                        "open",
                        "informational"
                      ],
                  level = predicates.enum
                      [ "none", "note", "warning", "error" ],
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.location,
                        predicates.arrays.minItems 0
                      ],
                  message = definitions.predicate.message,
                  occurrenceCount = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 1
                      ],
                  partialFingerprints = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  properties = definitions.predicate.propertyBag,
                  provenance = definitions.predicate.resultProvenance,
                  rank = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 100,
                        predicates.numbers.minimum (-1)
                      ],
                  relatedLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.location,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  rule = definitions.predicate.reportingDescriptorReference,
                  ruleId = predicates.isType '"String",
                  ruleIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  stacks = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.stack,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  suppressions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.suppression,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  taxa = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.reportingDescriptorReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webRequest = definitions.predicate.webRequest,
                  webResponse = definitions.predicate.webResponse,
                  workItemUris = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          resultProvenance
            | doc m%"
            Contains information about how and when a result was detected.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  conversionSources = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.physicalLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  firstDetectionRunGuid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  firstDetectionTimeUtc = predicates.isType '"String",
                  invocationIndex = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  lastDetectionRunGuid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  lastDetectionTimeUtc = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          run
            | doc m%"
            Describes a single run of an analysis tool, and contains the reported output of that run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "tool" ],
                predicates.records.record
                {
                  addresses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.address,
                        predicates.arrays.minItems 0
                      ],
                  artifacts = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.artifact,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  automationDetails =
                    definitions.predicate.runAutomationDetails,
                  baselineGuid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  columnKind = predicates.enum
                      [ "utf16CodeUnits", "unicodeCodePoints" ],
                  conversion = definitions.predicate.conversion,
                  defaultEncoding = predicates.isType '"String",
                  defaultSourceLanguage = predicates.isType '"String",
                  externalPropertyFileReferences =
                    definitions.predicate.externalPropertyFileReferences,
                  graphs = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.graph,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  invocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.invocation,
                        predicates.arrays.minItems 0
                      ],
                  language = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[a-zA-Z]{2}|^[a-zA-Z]{2}-[a-zA-Z]{2}?$"
                      ],
                  logicalLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.logicalLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  newlineSequences = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 1,
                        predicates.arrays.uniqueItems
                      ],
                  originalUriBaseIds = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.artifactLocation
                      ],
                  policies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                  redactionTokens = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  results = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.result,
                        predicates.arrays.minItems 0
                      ],
                  runAggregates = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.runAutomationDetails,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  specialLocations = definitions.predicate.specialLocations,
                  taxonomies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  threadFlowLocations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.threadFlowLocation,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  tool = definitions.predicate.tool,
                  translations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  versionControlProvenance = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.versionControlDetails,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webRequests = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.webRequest,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webResponses = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.webResponse,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                }
                {  }
                false
                predicates.never
              ],
          runAutomationDetails
            | doc m%"
            Information that describes a run's identity and role within an engineering system process.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  correlationGuid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  description = definitions.predicate.message,
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  id = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          specialLocations
            | doc m%"
            Defines locations of special significance to SARIF consumers.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  displayBase = definitions.predicate.artifactLocation,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                true
                predicates.always
              ],
          stack
            | doc m%"
            A call stack that is relevant to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "frames" ],
                predicates.records.record
                {
                  frames = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.stackFrame,
                        predicates.arrays.minItems 0
                      ],
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          stackFrame
            | doc m%"
            A function call within a stack trace.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  location = definitions.predicate.location,
                  module = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0
                      ],
                  properties = definitions.predicate.propertyBag,
                  threadId = predicates.isType 'Integer,
                }
                {  }
                false
                predicates.never
              ],
          suppression
            | doc m%"
            A suppression that is relevant to a result.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "kind" ],
                predicates.records.record
                {
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  justification = predicates.isType '"String",
                  kind = predicates.enum [ "inSource", "external" ],
                  location = definitions.predicate.location,
                  properties = definitions.predicate.propertyBag,
                  state = predicates.enum
                      [ "accepted", "underReview", "rejected" ],
                }
                {  }
                false
                predicates.never
              ],
          threadFlow = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "locations" ],
                predicates.records.record
                {
                  id = predicates.isType '"String",
                  immutableState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  initialState = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.threadFlowLocation,
                        predicates.arrays.minItems 1
                      ],
                  message = definitions.predicate.message,
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                true
                predicates.always
              ],
          threadFlowLocation
            | doc m%"
            A location visited by an analysis tool while simulating or monitoring the execution of a program.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  executionOrder = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  executionTimeUtc = predicates.isType '"String",
                  importance = predicates.enum
                      [ "important", "essential", "unimportant" ],
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  kinds = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String"),
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  location = definitions.predicate.location,
                  module = predicates.isType '"String",
                  nestingLevel = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum 0
                      ],
                  properties = definitions.predicate.propertyBag,
                  stack = definitions.predicate.stack,
                  state = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  taxa = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.reportingDescriptorReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  webRequest = definitions.predicate.webRequest,
                  webResponse = definitions.predicate.webResponse,
                }
                {  }
                false
                predicates.never
              ],
          tool
            | doc m%"
            The analysis tool that was run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "driver" ],
                predicates.records.record
                {
                  driver = definitions.predicate.toolComponent,
                  extensions = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponent,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                false
                predicates.never
              ],
          toolComponent
            | doc m%"
            A component, such as a plug-in or the driver, of the analysis tool that was run.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  associatedComponent =
                    definitions.predicate.toolComponentReference,
                  contents = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.enum
                        [ "localizedData", "nonLocalizedData" ]),
                        predicates.arrays.uniqueItems
                      ],
                  dottedQuadFileVersion = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern "[0-9]+(\\.[0-9]+){3}"
                      ],
                  downloadUri = predicates.isType '"String",
                  fullDescription =
                    definitions.predicate.multiformatMessageString,
                  fullName = predicates.isType '"String",
                  globalMessageStrings = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.multiformatMessageString
                      ],
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  informationUri = predicates.isType '"String",
                  isComprehensive = predicates.isType '"Bool",
                  language = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[a-zA-Z]{2}|^[a-zA-Z]{2}-[a-zA-Z]{2}?$"
                      ],
                  localizedDataSemanticVersion = predicates.isType '"String",
                  locations = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.artifactLocation,
                        predicates.arrays.minItems 0
                      ],
                  minimumRequiredLocalizedDataSemanticVersion =
                    predicates.isType '"String",
                  name = predicates.isType '"String",
                  notifications = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.reportingDescriptor,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  organization = predicates.isType '"String",
                  product = predicates.isType '"String",
                  productSuite = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  releaseDateUtc = predicates.isType '"String",
                  rules = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.reportingDescriptor,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  semanticVersion = predicates.isType '"String",
                  shortDescription =
                    definitions.predicate.multiformatMessageString,
                  supportedTaxonomies = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.toolComponentReference,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  taxa = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.reportingDescriptor,
                        predicates.arrays.minItems 0,
                        predicates.arrays.uniqueItems
                      ],
                  translationMetadata =
                    definitions.predicate.translationMetadata,
                  version = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          toolComponentReference
            | doc m%"
            
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  guid = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.strings.pattern
                        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
                      ],
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  name = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                }
                {  }
                true
                predicates.always
              ],
          translationMetadata
            | doc m%"
            Provides additional metadata related to translation.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  downloadUri = predicates.isType '"String",
                  fullDescription =
                    definitions.predicate.multiformatMessageString,
                  fullName = predicates.isType '"String",
                  informationUri = predicates.isType '"String",
                  name = predicates.isType '"String",
                  properties = definitions.predicate.propertyBag,
                  shortDescription =
                    definitions.predicate.multiformatMessageString,
                }
                {  }
                true
                predicates.always
              ],
          versionControlDetails
            | doc m%"
            Specifies the information necessary to retrieve a desired revision from a version control system.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repositoryUri" ],
                predicates.records.record
                {
                  asOfTimeUtc = predicates.isType '"String",
                  branch = predicates.isType '"String",
                  mappedTo = definitions.predicate.artifactLocation,
                  properties = definitions.predicate.propertyBag,
                  repositoryUri = predicates.isType '"String",
                  revisionId = predicates.isType '"String",
                  revisionTag = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          webRequest
            | doc m%"
            A web request object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  body = definitions.predicate.artifactContent,
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  method = predicates.isType '"String",
                  parameters = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  properties = definitions.predicate.propertyBag,
                  protocol = predicates.isType '"String",
                  target = predicates.isType '"String",
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
          webResponse
            | doc m%"
            A web response object.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  body = definitions.predicate.artifactContent,
                  headers = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                  index = predicates.allOf
                      [
                        predicates.isType 'Integer,
                        predicates.numbers.minimum (-1)
                      ],
                  noResponseReceived = predicates.isType '"Bool",
                  properties = definitions.predicate.propertyBag,
                  protocol = predicates.isType '"String",
                  reasonPhrase = predicates.isType '"String",
                  statusCode = predicates.isType 'Integer,
                  version = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  "$schema"
    | String
    | doc m%"
    The URI of the JSON schema corresponding to the version.
    "%
    | optional,
  inlineExternalProperties
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.externalProperties,
      predicates.arrays.minItems 0,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    References to external property files that share data between runs.
    "%
    | optional,
  properties
    | definitions.contract.propertyBag
    | doc m%"
    Key/value pairs that provide additional information about the log file.
    "%
    | optional,
  runs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.run,
      predicates.arrays.minItems 0
    ])
    | doc m%"
    The set of runs contained in this log file.
    "%,
  version
    | predicates.contract_from_predicate (predicates.enum [ "2.1.0" ])
    | doc m%"
    The SARIF format version of this log file.
    "%,
}