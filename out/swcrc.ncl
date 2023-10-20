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
          entryPoint
            | doc m%"
            Defines an entry point
            "%
            = {
                "$schema" | String | optional,
                callerOptions | { name | String | optional, } | optional,
                configFile
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                cwd | String | optional,
                disableFixer | Bool | optional,
                disableHygiene | Bool | optional,
                env
                  | {
                    bugfixes | Bool | optional,
                    coreJs | String | optional,
                    debug | Bool | optional,
                    dynamicImport | Bool | optional,
                    exclude
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.featureOrModule
                      ])
                      | optional,
                    forceAllTransforms | Bool | optional,
                    include
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.featureOrModule
                      ])
                      | optional,
                    loose | Bool | optional,
                    mode
                      | std.enum.TagOrString
                      | [| 'entry, 'usage |]
                      | optional,
                    shippedProposals | Bool | optional,
                    skip
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ])
                      | doc m%"
                      Skipped es-features. e.g.: 'core-js/modules/foo'
                      "%
                      | optional,
                    targets
                      | predicates.contract_from_predicate
                      (predicates.oneOf
                      [
                        definitions.predicate.envQuery,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record
                          { esmodules = predicates.isType '"Bool", }
                          {  }
                          false
                          predicates.never
                        ],
                        definitions.predicate.envVersions,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  }
                          { "" = definitions.predicate.envQueryOrVersion, }
                          true
                          predicates.always
                        ]
                      ])
                      | optional,
                  }
                  | optional,
                envName | String | optional,
                exclude
                  | definitions.contract.fileMatcher
                  | doc m%"
                  Matches the files to exclude
                  "%
                  | optional,
                filename | String | optional,
                globalMark | Number | optional,
                inputSourceMap
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                isModule | Bool | optional,
                jsc
                  | {
                    baseUrl
                      | String
                      | doc m%"
                      Should reflect "baseUrl" property in project's tsconfig.json . See https://www.typescriptlang.org/docs/handbook/module-resolution.html#base-url
                      "%
                      | optional,
                    experimental
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.minProperties 1,
                        predicates.records.record
                        {
                          keepImportAssertions = predicates.isType '"Bool",
                          plugins = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.items
                                  [
                                    predicates.allOf
                                    [
                                      predicates.isType '"String",
                                      predicates.strings.minLength 1
                                    ],
                                    predicates.allOf
                                    [
                                      predicates.isType 'Record,
                                      predicates.records.record {  } {  } true
                                      predicates.always
                                    ]
                                  ],
                                  predicates.arrays.maxItems 2,
                                  predicates.arrays.minItems 2
                                ]),
                                predicates.arrays.minItems 1
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ])
                      | doc m%"
                      Experimental options
                      https://swc.rs/docs/configuration/compilation#jscexperimental
                      "%
                      | optional,
                    externalHelpers
                      | Bool
                      | doc m%"
                      If true, this option will reduce the filesize by importing from an external module
                      "%
                      | optional,
                    keepClassNames
                      | Bool
                      | doc m%"
                      Preserve original class names
                      https://swc.rs/docs/configuration/compilation#jsckeepclassnames
                      "%
                      | optional,
                    loose
                      | Bool
                      | doc m%"
                      If true, swc generates more efficient code
                      "%
                      | optional,
                    minify
                      | {  .. }
                      | doc m%"
                      Minification options
                      https://swc.rs/docs/configuration/minification
                      "%
                      | optional,
                    parser
                      | predicates.contract_from_predicate
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.oneOf
                        [
                          predicates.records.record
                          {
                            classPrivateProperty = predicates.isType '"Bool",
                            classProperty = predicates.isType '"Bool",
                            decorators = predicates.isType '"Bool",
                            decoratorsBeforeExport = predicates.isType '"Bool",
                            dynamicImport = predicates.isType '"Bool",
                            exportDefaultFrom = predicates.isType '"Bool",
                            exportNamespaceFrom = predicates.isType '"Bool",
                            functionBind = predicates.isType '"Bool",
                            importAssertions = predicates.isType '"Bool",
                            importMeta = predicates.isType '"Bool",
                            jsx = predicates.isType '"Bool",
                            nullishCoalescing = predicates.isType '"Bool",
                            numericSeparator = predicates.isType '"Bool",
                            optionalChaining = predicates.isType '"Bool",
                            privateMethod = predicates.isType '"Bool",
                            syntax = predicates.enum [ "ecmascript" ],
                            topLevelAwait = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never,
                          predicates.records.record
                          {
                            decorators = predicates.isType '"Bool",
                            dts = predicates.isType '"Bool",
                            dynamicImport = predicates.isType '"Bool",
                            importAssertions = predicates.isType '"Bool",
                            noEarlyErrors = predicates.isType '"Bool",
                            syntax = predicates.enum [ "typescript" ],
                            tsx = predicates.isType '"Bool",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ])
                      | doc m%"
                      Configures the parser
                      "%
                      | optional,
                    paths
                      | {  .. }
                      | doc m%"
                      Should reflect "paths" property in project's tsconfig.json . See https://www.typescriptlang.org/docs/handbook/module-resolution.html#path-mapping
                      "%
                      | optional,
                    preserveAllComments
                      | Bool
                      | doc m%"
                      If true, all comments will be preserved during compilation
                      "%
                      | optional,
                    target
                      | std.enum.TagOrString
                      | [|
                        'esnext,
                        'es2022,
                        'es2021,
                        'es2020,
                        'es2019,
                        'es2018,
                        'es2017,
                        'es2016,
                        'es2015,
                        'es5,
                        'es3
                      |]
                      | doc m%"
                      Specifies the target environment
                      "%
                      | optional,
                    transform
                      | {
                        constModules
                          | {
                            globals
                              | predicates.contract_from_predicate
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record {  }
                                { "" = definitions.predicate.stringStringMap, }
                                true
                                predicates.always
                              ])
                              | optional,
                          }
                          | optional,
                        decoratorMetadata
                          | Bool
                          | doc m%"
                          If true, decorator metadata is emitted. Make sure "Reflect" is present.
                          "%
                          | optional,
                        hidden | { jest | Bool | optional, } | optional,
                        legacyDecorator | Bool | optional,
                        optimizer
                          | {
                            globals
                              | {
                                envs
                                  | predicates.contract_from_predicate
                                  (predicates.allOf
                                  [
                                    predicates.isType '"Array",
                                    predicates.arrays.arrayOf
                                    (predicates.isType '"String")
                                  ])
                                  | optional,
                                vars
                                  | definitions.contract.stringStringMap
                                  | optional,
                              }
                              | optional,
                            jsonify
                              | { minCost | Number | optional, }
                              | optional,
                          }
                          | optional,
                        react
                          | {
                            development | Bool | optional,
                            pragma | String | optional,
                            pragmaFrag | String | optional,
                            refresh | Bool | optional,
                            runtime
                              | std.enum.TagOrString
                              | [| 'classic, 'automatic |]
                              | optional,
                            throwIfNamespace | Bool | optional,
                            useBuiltins | Bool | optional,
                          }
                          | optional,
                        useDefineForClassFields
                          | Bool
                          | doc m%"
                          If false, the old behaviour is used and _defineProperty is not generated for class properties.
                          https://swc.rs/docs/configuration/compilation#jsctransformusedefineforclassfields
                          "%
                          | optional,
                      }
                      | optional,
                  }
                  | doc m%"
                  Main Jsc configuration
                  "%
                  | optional,
                minify
                  | Bool
                  | doc m%"
                  If true, swc will minify the output
                  "%
                  | optional,
                module
                  | {
                    globals | definitions.contract.stringStringMap | optional,
                    lazy
                      | predicates.contract_from_predicate
                      (predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ])
                      | optional,
                    moduleId
                      | String
                      | doc m%"
                      If emitting amd-modules and specified, swc emits a named amd module
                      "%
                      | optional,
                    noInterop
                      | Bool
                      | doc m%"
                      Disable the use of interopRequireDefault
                      "%
                      | optional,
                    resolveFully
                      | Bool
                      | doc m%"
                      Make resolver fully resolve index.js
                      "%
                      | optional,
                    strict
                      | Bool
                      | doc m%"
                      If true, the __esModule property won't be added to the export
                      "%
                      | optional,
                    strictMode
                      | Bool
                      | doc m%"
                      If true, swc emits the 'use strict' directive
                      "%
                      | optional,
                    type
                      | std.enum.TagOrString
                      | [| 'es6, 'umd, 'amd, 'commonjs |],
                  }
                  | doc m%"
                  Describes how swc will transpile the input
                  "%
                  | optional,
                root | String | optional,
                rootMode
                  | predicates.contract_from_predicate
                  (predicates.enum [ "root", "upward", "upward-optional" ])
                  | optional,
                skipHelperInjection | Bool | optional,
                sourceFileName | String | optional,
                sourceMaps
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | optional,
                sourceRoot | String | optional,
                swcrc | Bool | optional,
                test
                  | definitions.contract.fileMatcher
                  | doc m%"
                  Matches the files to include
                  "%
                  | optional,
              },
          envQuery
            | doc m%"
            Query
            "%
            = predicates.contract_from_predicate definitions.predicate.envQuery,
          envQueryOrVersion
            | doc m%"
            QueryOrVersion
            "%
            = predicates.contract_from_predicate
              definitions.predicate.envQueryOrVersion,
          envVersion = predicates.contract_from_predicate
              definitions.predicate.envVersion,
          envVersions = predicates.contract_from_predicate
              definitions.predicate.envVersions,
          featureOrModule = predicates.contract_from_predicate
              definitions.predicate.featureOrModule,
          fileMatcher = predicates.contract_from_predicate
              definitions.predicate.fileMatcher,
          stringStringMap = predicates.contract_from_predicate
              definitions.predicate.stringStringMap,
        },
    predicate = {
          entryPoint
            | doc m%"
            Defines an entry point
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  callerOptions = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { name = predicates.isType '"String", }
                        {  }
                        false
                        predicates.never
                      ],
                  configFile = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  cwd = predicates.isType '"String",
                  disableFixer = predicates.isType '"Bool",
                  disableHygiene = predicates.isType '"Bool",
                  env = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          bugfixes = predicates.isType '"Bool",
                          coreJs = predicates.isType '"String",
                          debug = predicates.isType '"Bool",
                          dynamicImport = predicates.isType '"Bool",
                          exclude = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.featureOrModule
                              ],
                          forceAllTransforms = predicates.isType '"Bool",
                          include = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                definitions.predicate.featureOrModule
                              ],
                          loose = predicates.isType '"Bool",
                          mode = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum [ "usage", "entry" ]
                              ],
                          shippedProposals = predicates.isType '"Bool",
                          skip = predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String")
                              ],
                          targets = predicates.oneOf
                              [
                                definitions.predicate.envQuery,
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record
                                  { esmodules = predicates.isType '"Bool", }
                                  {  }
                                  false
                                  predicates.never
                                ],
                                definitions.predicate.envVersions,
                                predicates.allOf
                                [
                                  predicates.isType 'Record,
                                  predicates.records.record {  }
                                  {
                                    "" =
                                      definitions.predicate.envQueryOrVersion,
                                  }
                                  true
                                  predicates.always
                                ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  envName = predicates.isType '"String",
                  exclude = definitions.predicate.fileMatcher,
                  filename = predicates.isType '"String",
                  globalMark = predicates.isType '"Number",
                  inputSourceMap = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  isModule = predicates.isType '"Bool",
                  jsc = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        {
                          baseUrl = predicates.isType '"String",
                          experimental = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.minProperties 1,
                                predicates.records.record
                                {
                                  keepImportAssertions = predicates.isType
                                      '"Bool",
                                  plugins = predicates.allOf
                                      [
                                        predicates.isType '"Array",
                                        predicates.arrays.arrayOf
                                        (predicates.allOf
                                        [
                                          predicates.isType '"Array",
                                          predicates.arrays.items
                                          [
                                            predicates.allOf
                                            [
                                              predicates.isType '"String",
                                              predicates.strings.minLength 1
                                            ],
                                            predicates.allOf
                                            [
                                              predicates.isType 'Record,
                                              predicates.records.record {  }
                                              {  }
                                              true
                                              predicates.always
                                            ]
                                          ],
                                          predicates.arrays.maxItems 2,
                                          predicates.arrays.minItems 2
                                        ]),
                                        predicates.arrays.minItems 1
                                      ],
                                }
                                {  }
                                false
                                predicates.never
                              ],
                          externalHelpers = predicates.isType '"Bool",
                          keepClassNames = predicates.isType '"Bool",
                          loose = predicates.isType '"Bool",
                          minify = predicates.isType 'Record,
                          parser = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.oneOf
                                [
                                  predicates.records.record
                                  {
                                    classPrivateProperty = predicates.isType
                                        '"Bool",
                                    classProperty = predicates.isType '"Bool",
                                    decorators = predicates.isType '"Bool",
                                    decoratorsBeforeExport = predicates.isType
                                        '"Bool",
                                    dynamicImport = predicates.isType '"Bool",
                                    exportDefaultFrom = predicates.isType
                                        '"Bool",
                                    exportNamespaceFrom = predicates.isType
                                        '"Bool",
                                    functionBind = predicates.isType '"Bool",
                                    importAssertions = predicates.isType
                                        '"Bool",
                                    importMeta = predicates.isType '"Bool",
                                    jsx = predicates.isType '"Bool",
                                    nullishCoalescing = predicates.isType
                                        '"Bool",
                                    numericSeparator = predicates.isType
                                        '"Bool",
                                    optionalChaining = predicates.isType
                                        '"Bool",
                                    privateMethod = predicates.isType '"Bool",
                                    syntax = predicates.enum [ "ecmascript" ],
                                    topLevelAwait = predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never,
                                  predicates.records.record
                                  {
                                    decorators = predicates.isType '"Bool",
                                    dts = predicates.isType '"Bool",
                                    dynamicImport = predicates.isType '"Bool",
                                    importAssertions = predicates.isType
                                        '"Bool",
                                    noEarlyErrors = predicates.isType '"Bool",
                                    syntax = predicates.enum [ "typescript" ],
                                    tsx = predicates.isType '"Bool",
                                  }
                                  {  }
                                  false
                                  predicates.never
                                ]
                              ],
                          paths = predicates.isType 'Record,
                          preserveAllComments = predicates.isType '"Bool",
                          target = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [
                                  "es3",
                                  "es5",
                                  "es2015",
                                  "es2016",
                                  "es2017",
                                  "es2018",
                                  "es2019",
                                  "es2020",
                                  "es2021",
                                  "es2022",
                                  "esnext"
                                ]
                              ],
                          transform = predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                {
                                  constModules = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          globals = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record {  }
                                                {
                                                  "" =
                                                    definitions.predicate.stringStringMap,
                                                }
                                                true
                                                predicates.always
                                              ],
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  decoratorMetadata = predicates.isType '"Bool",
                                  hidden = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        { jest = predicates.isType '"Bool", }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  legacyDecorator = predicates.isType '"Bool",
                                  optimizer = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          globals = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  envs = predicates.allOf
                                                      [
                                                        predicates.isType
                                                        '"Array",
                                                        predicates.arrays.arrayOf
                                                        (predicates.isType
                                                        '"String")
                                                      ],
                                                  vars =
                                                    definitions.predicate.stringStringMap,
                                                }
                                                {  }
                                                false
                                                predicates.never
                                              ],
                                          jsonify = predicates.allOf
                                              [
                                                predicates.isType 'Record,
                                                predicates.records.record
                                                {
                                                  minCost = predicates.isType
                                                      '"Number",
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
                                  react = predicates.allOf
                                      [
                                        predicates.isType 'Record,
                                        predicates.records.record
                                        {
                                          development = predicates.isType
                                              '"Bool",
                                          pragma = predicates.isType '"String",
                                          pragmaFrag = predicates.isType
                                              '"String",
                                          refresh = predicates.isType '"Bool",
                                          runtime = predicates.allOf
                                              [
                                                predicates.isType '"String",
                                                predicates.enum
                                                [ "automatic", "classic" ]
                                              ],
                                          throwIfNamespace = predicates.isType
                                              '"Bool",
                                          useBuiltins = predicates.isType
                                              '"Bool",
                                        }
                                        {  }
                                        false
                                        predicates.never
                                      ],
                                  useDefineForClassFields = predicates.isType
                                      '"Bool",
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
                  minify = predicates.isType '"Bool",
                  module = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.required [ "type" ],
                        predicates.records.record
                        {
                          globals = definitions.predicate.stringStringMap,
                          lazy = predicates.anyOf
                              [
                                predicates.isType '"Bool",
                                predicates.allOf
                                [
                                  predicates.isType '"Array",
                                  predicates.arrays.arrayOf
                                  (predicates.isType '"String")
                                ]
                              ],
                          moduleId = predicates.isType '"String",
                          noInterop = predicates.isType '"Bool",
                          resolveFully = predicates.isType '"Bool",
                          strict = predicates.isType '"Bool",
                          strictMode = predicates.isType '"Bool",
                          type = predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.enum
                                [ "commonjs", "amd", "umd", "es6" ]
                              ],
                        }
                        {  }
                        false
                        predicates.never
                      ],
                  root = predicates.isType '"String",
                  rootMode = predicates.enum
                      [ "root", "upward", "upward-optional" ],
                  skipHelperInjection = predicates.isType '"Bool",
                  sourceFileName = predicates.isType '"String",
                  sourceMaps = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  sourceRoot = predicates.isType '"String",
                  swcrc = predicates.isType '"Bool",
                  test = definitions.predicate.fileMatcher,
                }
                {  }
                false
                predicates.never
              ],
          envQuery
            | doc m%"
            Query
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
          envQueryOrVersion
            | doc m%"
            QueryOrVersion
            "%
            = predicates.oneOf
              [
                definitions.predicate.envQuery,
                definitions.predicate.envVersion
              ],
          envVersion = predicates.anyOf
              [ predicates.isType '"String", predicates.isType '"Number" ],
          envVersions = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.propertyNames
                (predicates.enum
                [
                  "chrome",
                  "ie",
                  "edge",
                  "firefox",
                  "safari",
                  "node",
                  "ios",
                  "samsung",
                  "opera",
                  "android",
                  "electron",
                  "phantom",
                  "operaMobile"
                ]),
                predicates.records.record {  }
                { "" = definitions.predicate.envVersion, }
                true
                predicates.always
              ],
          featureOrModule = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum
                  [
                    "transform-template-literals",
                    "transform-literals",
                    "transform-function-name",
                    "transform-arrow-functions",
                    "transform-block-scoped-functions",
                    "transform-classes",
                    "transform-object-super",
                    "transform-shorthand-properties",
                    "transform-duplicate-keys",
                    "transform-computed-properties",
                    "transform-for-of",
                    "transform-sticky-regex",
                    "transform-dotall-regex",
                    "transform-unicode-regex",
                    "transform-spread",
                    "transform-parameters",
                    "transform-destructuring",
                    "transform-block-scoping",
                    "transform-typeof-symbol",
                    "transform-new-target",
                    "transform-regenerator",
                    "transform-exponentiation-operator",
                    "transform-async-to-generator",
                    "proposal-async-generator-functions",
                    "proposal-object-rest-spread",
                    "proposal-unicode-property-regex",
                    "proposal-json-strings",
                    "proposal-optional-catch-binding",
                    "transform-named-capturing-groups-regex",
                    "transform-member-expression-literals",
                    "transform-property-literals",
                    "transform-reserved-words",
                    "proposal-nullish-coalescing-operator",
                    "proposal-optional-chaining",
                    "proposal-class-properties",
                    "proposal-numeric-separator",
                    "proposal-private-methods",
                    "transform-unicode-escapes"
                  ]
                ]
              ],
          fileMatcher = predicates.anyOf
              [
                predicates.isType '"String",
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf definitions.predicate.fileMatcher
                ]
              ],
          stringStringMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  }
                { "" = predicates.isType '"String", }
                true
                predicates.always
              ],
        },
  }
in

predicates.contract_from_predicate
(predicates.anyOf
[
  predicates.allOf
  [
    predicates.isType '"Array",
    predicates.arrays.arrayOf definitions.predicate.entryPoint
  ],
  definitions.predicate.entryPoint
])