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
          datatype
            | doc m%"
            Indicates limitations on the valid values a symbol may be assigned. When specified, the symbol value is attempted to be converted to this type. The datatype "choice" is supported only for parameter symbols and requires providing symbols.choices configuration for the symbol.
            "%
            = predicates.contract_from_predicate definitions.predicate.datatype,
          generatorCasing = predicates.contract_from_predicate
              definitions.predicate.generatorCasing,
          generatorCoalesce = predicates.contract_from_predicate
              definitions.predicate.generatorCoalesce,
          generatorConstant = predicates.contract_from_predicate
              definitions.predicate.generatorConstant,
          generatorGuid = predicates.contract_from_predicate
              definitions.predicate.generatorGuid,
          generatorJoin = predicates.contract_from_predicate
              definitions.predicate.generatorJoin,
          generatorNow = predicates.contract_from_predicate
              definitions.predicate.generatorNow,
          generatorPort = predicates.contract_from_predicate
              definitions.predicate.generatorPort,
          generatorRandom = predicates.contract_from_predicate
              definitions.predicate.generatorRandom,
          generatorRegex = predicates.contract_from_predicate
              definitions.predicate.generatorRegex,
          generatorRegexMatch = predicates.contract_from_predicate
              definitions.predicate.generatorRegexMatch,
          generatorSwitch = predicates.contract_from_predicate
              definitions.predicate.generatorSwitch,
          guid
            | doc m%"
            A guid string to be replaced in source files. Format and casing is not significant in the config as format and casing is preserved based on the particular guid in processed file(s).
            "%
            = predicates.contract_from_predicate definitions.predicate.guid,
          ice = predicates.contract_from_predicate definitions.predicate.ice,
          modifier = {
                condition
                  | String
                  | doc m%"
                  Boolean condition to indicate if the sources configuration should be included or ignored. If the condition evaluates to true or is not provided, the sources config will be used for creating the template. If it evaluates to false, the sources config will be ignored.
                  "%
                  | optional,
                copyOnly
                  | predicates.contract_from_predicate definitions.predicate.ice
                  | doc m%"
                  The set of globbing patterns indicating the content that was included by sources.include, that hasn't been excluded by sources.exclude that should be placed in the user's directory without modification.
                  "%
                  | optional,
                exclude
                  | predicates.contract_from_predicate definitions.predicate.ice
                  | doc m%"
                  The set of globbing patterns indicating the content that was included by sources.include that should not be processed.
                  "%
                  | optional,
                include
                  | predicates.contract_from_predicate definitions.predicate.ice
                  | doc m%"
                  The set of globbing patterns indicating the content to process in the path referred to by the source.
                  "%
                  | optional,
                rename
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.isType '"String")
                  ])
                  | doc m%"
                  The set of explicit renames to perform. Each key is a path to a file in the source, each value is a path to the target location.
                  "%
                  | optional,
                ..
              },
          source = predicates.contract_from_predicate
              definitions.predicate.source,
        },
    predicate = {
          datatype
            | doc m%"
            Indicates limitations on the valid values a symbol may be assigned. When specified, the symbol value is attempted to be converted to this type. The datatype "choice" is supported only for parameter symbols and requires providing symbols.choices configuration for the symbol.
            "%
            = predicates.anyOf
              [
                predicates.enum
                [ "choice", "bool", "float", "int", "hex", "text" ],
                predicates.strings.pattern "^(integer|string)$"
              ],
          generatorCasing = predicates.records.record
              {
                generator = predicates.enum [ "casing" ],
                parameters = predicates.allOf
                    [
                      predicates.records.required [ "source" ],
                      predicates.records.record
                      {
                        source = predicates.isType '"String",
                        toLower = predicates.isType '"Bool",
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
          generatorCoalesce = predicates.records.record
              {
                generator = predicates.enum [ "coalesce" ],
                parameters = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required
                      [ "fallbackVariableName", "sourceVariableName" ],
                      predicates.records.record
                      {
                        defaultValue = predicates.isType '"String",
                        fallbackVariableName = predicates.isType '"String",
                        sourceVariableName = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
          generatorConstant = predicates.records.record
              {
                generator = predicates.enum [ "constant" ],
                parameters = predicates.records.record
                    { value = predicates.isType '"String", }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorGuid = predicates.records.record
              {
                generator = predicates.enum [ "guid" ],
                parameters = predicates.records.record
                    {
                      defaultFormat = predicates.isType '"String",
                      format = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorJoin = predicates.records.record
              {
                generator = predicates.enum [ "join" ],
                parameters = predicates.records.record
                    {
                      removeEmptyValues = predicates.isType '"Bool",
                      separator = predicates.isType '"String",
                      symbols = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required [ "value" ],
                              predicates.records.record
                              {
                                type = predicates.enum [ "ref", "const" ],
                                value = predicates.isType '"String",
                              }
                              {  }
                              true
                              predicates.always
                            ])
                          ],
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorNow = predicates.records.record
              {
                generator = predicates.enum [ "now" ],
                parameters = predicates.records.record
                    {
                      format = predicates.isType '"String",
                      utc = predicates.isType '"Bool",
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorPort = predicates.records.record
              {
                generator = predicates.enum [ "port" ],
                parameters = predicates.records.record
                    {
                      fallback = predicates.isType 'Integer,
                      high = predicates.isType 'Integer,
                      low = predicates.isType 'Integer,
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorRandom = predicates.records.record
              {
                generator = predicates.enum [ "random" ],
                parameters = predicates.allOf
                    [
                      predicates.records.required [ "low" ],
                      predicates.records.record
                      {
                        high = predicates.isType 'Integer,
                        low = predicates.isType 'Integer,
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
          generatorRegex = predicates.records.record
              {
                generator = predicates.enum [ "regex" ],
                parameters = predicates.records.record
                    {
                      source = predicates.isType '"String",
                      steps = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.records.required
                              [ "regex", "replacement" ],
                              predicates.records.record
                              {
                                regex = predicates.isType '"String",
                                replacement = predicates.isType '"String",
                              }
                              {  }
                              true
                              predicates.always
                            ])
                          ],
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorRegexMatch = predicates.records.record
              {
                datatype = predicates.enum [ "bool" ],
                generator = predicates.enum [ "regexMatch" ],
                parameters = predicates.records.record
                    {
                      pattern = predicates.isType '"String",
                      source = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          generatorSwitch = predicates.records.record
              {
                generator = predicates.enum [ "switch" ],
                parameters = predicates.records.record
                    {
                      cases = predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.required
                              [ "condition", "value" ],
                              predicates.records.record
                              {
                                condition = predicates.isType '"String",
                                value = predicates.isType '"String",
                              }
                              {  }
                              true
                              predicates.always
                            ])
                          ],
                      datatype = definitions.predicate.datatype,
                      evaluator = predicates.enum
                          [ "C++", "C++2", "MSBUILD", "VB" ],
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          guid
            | doc m%"
            A guid string to be replaced in source files. Format and casing is not significant in the config as format and casing is preserved based on the particular guid in processed file(s).
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.strings.pattern
                "^\\{?[0-9A-Fa-f]{8}[-]?([0-9A-Fa-f]{4}[-]?){3}[0-9A-Fa-f]{12}\\}?$"
              ],
          ice = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf (predicates.isType '"String"),
                  predicates.arrays.uniqueItems
                ],
                predicates.isType '"String"
              ],
          modifier = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.isType '"String",
                  copyOnly = definitions.predicate.ice,
                  exclude = definitions.predicate.ice,
                  include = definitions.predicate.ice,
                  rename = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        (predicates.isType '"String")
                      ],
                }
                {  }
                true
                predicates.always
              ],
          source = predicates.allOf
              [
                predicates.isType 'Record,
                definitions.predicate.modifier,
                predicates.records.record
                {
                  modifiers = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.modifier
                      ],
                  source = predicates.isType '"String",
                  target = predicates.isType '"String",
                }
                {  }
                true
                predicates.always
              ],
        },
  }
in

{
  author
    | String
    | doc m%"
    The author of the template.
    "%,
  baselines
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.record
        {
          defaultOverrides = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                (predicates.isType '"String")
              ],
          description = predicates.isType '"String",
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    Alternate sets of defaults for symbols.
    "%
    | optional,
  classifications
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [ predicates.isType '"String", predicates.strings.minLength 1 ])
    ])
    | doc m%"
    Zero or more characteristics of the template that a user might search for it by.
    "%,
  constraints
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.oneOf
        [
          predicates.allOf
          [
            predicates.not
            (predicates.allOf
            [
              predicates.records.required [ "type" ],
              predicates.records.record
              {
                type = predicates.enum
                    [
                      "os",
                      "host",
                      "workload",
                      "sdk-version",
                      "project-capability"
                    ],
              }
              {  }
              true
              predicates.always
            ]),
            predicates.records.record
            {
              args = predicates.anyOf
                  [
                    predicates.isType '"Array",
                    predicates.isType 'Record,
                    predicates.isType '"String"
                  ],
            }
            {  }
            true
            predicates.always
          ],
          predicates.records.record
          {
            args = predicates.oneOf
                [
                  predicates.allOf
                  [
                    predicates.isType '"String",
                    predicates.enum [ "Windows", "Linux", "OSX" ]
                  ],
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "Windows", "Linux", "OSX" ]
                    ])
                  ]
                ],
            type = predicates.enum [ "os" ],
          }
          {  }
          true
          predicates.always,
          predicates.records.record
          {
            args = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.required [ "hostname" ],
                    predicates.records.record
                    {
                      hostname = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.oneOf
                            [
                              predicates.not
                              (predicates.enum
                              [ "dotnetcli", "vs", "vs-mac", "ide" ]),
                              predicates.enum
                              [ "dotnetcli", "vs", "vs-mac", "ide" ]
                            ]
                          ],
                      version = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ])
                ],
            type = predicates.enum [ "host" ],
          }
          {  }
          true
          predicates.always,
          predicates.records.record
          {
            args = predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]
                ],
            type = predicates.enum [ "workload" ],
          }
          {  }
          true
          predicates.always,
          predicates.records.record
          {
            args = predicates.oneOf
                [
                  predicates.isType '"String",
                  predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]
                ],
            type = predicates.enum [ "sdk-version" ],
          }
          {  }
          true
          predicates.always,
          predicates.records.record
          {
            args = predicates.isType '"String",
            type = predicates.enum [ "project-capability" ],
          }
          {  }
          true
          predicates.always
        ],
        predicates.records.required [ "type" ],
        predicates.records.record
        { args = predicates.always, type = predicates.isType '"String", }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    The constraints section defines the restrictions when the template can be run. Available since .NET SDK 7.0.100.
    "%
    | optional,
  defaultName
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The name to use during creation if no name has been specified by the user or provided from the host.
    "%
    | optional,
  description
    | String
    | doc m%"
    A description of the template's purpose or contents for use in help.
    "%
    | optional,
  forms
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.oneOf
        [
          predicates.not
          (predicates.allOf
          [
            predicates.records.required [ "identifier" ],
            predicates.records.record
            {
              identifier = predicates.enum
                  [
                    "lowerCaseInvariant",
                    "xmlEncode",
                    "safe_name",
                    "lower_safe_name",
                    "upperCaseInvariant",
                    "replace",
                    "safe_namespace",
                    "lower_safe_namespace",
                    "chain",
                    "lowerCase",
                    "identity",
                    "upperCase",
                    "jsonEncode",
                    "firstLowerCase",
                    "firstLowerCaseInvariant",
                    "firstUpperCase",
                    "firstUpperCaseInvariant",
                    "titleCase",
                    "kebabCase"
                  ],
            }
            {  }
            true
            predicates.always
          ]),
          predicates.records.record
          { identifier = predicates.enum [ "lowerCaseInvariant" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "xmlEncode" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "safe_name" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "lower_safe_name" ], }
          {  }
          true
          predicates.always,
          predicates.allOf
          [
            predicates.records.required [ "pattern", "replacement" ],
            predicates.records.record
            {
              identifier = predicates.enum [ "replace" ],
              pattern = predicates.isType '"String",
              replacement = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ],
          predicates.records.record
          { identifier = predicates.enum [ "safe_namespace" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "lower_safe_namespace" ], }
          {  }
          true
          predicates.always,
          predicates.allOf
          [
            predicates.records.required [ "steps" ],
            predicates.records.record
            {
              identifier = predicates.enum [ "chain" ],
              steps = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
            }
            {  }
            true
            predicates.always
          ],
          predicates.records.record
          { identifier = predicates.enum [ "lowerCase" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "identity" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "upperCase" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "upperCaseInvariant" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "jsonEncode" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "firstLowerCase" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "firstLowerCaseInvariant" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "firstUpperCase" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "firstUpperCaseInvariant" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "titleCase" ], }
          {  }
          true
          predicates.always,
          predicates.records.record
          { identifier = predicates.enum [ "kebabCase" ], }
          {  }
          true
          predicates.always
        ],
        predicates.records.record { identifier = predicates.isType '"String", }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    Custom value forms used by the template.
    "%
    | optional,
  generatorVersions
    | String
    | doc m%"
    The semantic version range of the Microsoft.TemplateEngine.Orchestrator.RunnableProjects package that this template is usable with. In older versions of the engine, the four octet version string is used but is matched against a constant which was never changed from 1.0.0.0 - either syntax is now accepted, however the four octet string will not be changed from 1.0.0.0.
    "%
    | optional,
  groupIdentity
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The ID of the group this template belongs to. When combined with the "tags" section, this allows multiple templates to be displayed as one, with the the decision for which one to use being presented as a choice in each one of the pivot categories (keys).
    "%
    | optional,
  guids
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.guid,
      predicates.arrays.uniqueItems
    ])
    | doc m%"
    A list of guids which appear in the template source and should be replaced in the template output. For each guid listed, a replacement guid is generated, and replaces all occurrences of the source guid in the output.
    "%
    | optional,
  identity
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    A unique name for this template.
    "%,
  name
    | predicates.contract_from_predicate
    (predicates.allOf
    [ predicates.isType '"String", predicates.strings.minLength 1 ])
    | doc m%"
    The name for the template that users should see.
    "%,
  placeholderFilename
    | String
    | doc m%"
    A filename that will be completely ignored except to indicate that its containing directory should be copied. This allows creation of an empty directory in the created template, by having a corresponding source directory containing just the placeholder file. Completely empty directories are ignored.
    "%
    | optional,
  postActions
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.allOf
        [
          predicates.allOf
          [
            predicates.records.required [ "actionId", "manualInstructions" ],
            predicates.records.record
            {
              actionId = definitions.predicate.guid,
              applyFileRenamesToArgs = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ],
              applyFileRenamesToManualInstructions = predicates.isType '"Bool",
              args = predicates.isType 'Record,
              condition = predicates.isType '"String",
              continueOnError = predicates.isType '"Bool",
              description = predicates.isType '"String",
              id = predicates.isType '"String",
              manualInstructions = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "text" ],
                      predicates.records.record
                      {
                        condition = predicates.isType '"String",
                        id = predicates.isType '"String",
                        text = predicates.isType '"String",
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
          predicates.oneOf
          [
            predicates.not
            (predicates.allOf
            [
              predicates.records.required [ "actionId" ],
              predicates.records.record
              {
                actionId = predicates.enum
                    [
                      "AC1156F7-BB77-4DB8-B28F-24EEBCCA1E5C",
                      "3A7C4B45-1F5D-4A30-959A-51B88E82B5D2",
                      "B17581D1-C5C9-4489-8F0A-004BE667B814",
                      "cb9a6cf3-4f5c-4860-b9d2-03a574959774",
                      "210D431B-A78B-4D2F-B762-4ED3E3EA9025",
                      "D396686C-DE0E-4DE6-906D-291CD29FC5DE",
                      "84C0DA21-51C8-4541-9940-6CA19AF04EE6"
                    ],
              }
              {  }
              true
              predicates.always
            ]),
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "AC1156F7-BB77-4DB8-B28F-24EEBCCA1E5C" ],
              args = predicates.records.record
                  {
                    args = predicates.isType '"String",
                    executable = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
            }
            {  }
            true
            predicates.always,
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "3A7C4B45-1F5D-4A30-959A-51B88E82B5D2" ],
              args = predicates.allOf
                  [
                    predicates.records.required [ "executable" ],
                    predicates.records.record
                    {
                      args = predicates.isType '"String",
                      executable = predicates.isType '"String",
                      redirectStandardError = predicates.isType '"Bool",
                      redirectStandardOutput = predicates.isType '"Bool",
                    }
                    {  }
                    true
                    predicates.always
                  ],
            }
            {  }
            true
            predicates.always,
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "B17581D1-C5C9-4489-8F0A-004BE667B814" ],
              args = predicates.allOf
                  [
                    predicates.records.required
                    [ "reference", "referenceType" ],
                    predicates.records.record
                    {
                      projectFileExtensions = predicates.isType '"String",
                      reference = predicates.isType '"String",
                      referenceType = predicates.allOf
                          [
                            predicates.isType '"String",
                            predicates.enum
                            [ "project", "package", "framework" ]
                          ],
                      targetFiles = predicates.oneOf
                          [
                            predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.arrays.uniqueItems
                              ])
                            ],
                            predicates.isType '"String"
                          ],
                      version = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ],
            }
            {  }
            true
            predicates.always,
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "cb9a6cf3-4f5c-4860-b9d2-03a574959774" ],
              args = predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    (predicates.oneOf
                    [
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.arrays.uniqueItems
                        ])
                      ],
                      predicates.isType '"String"
                    ])
                  ],
            }
            {  }
            true
            predicates.always,
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "210D431B-A78B-4D2F-B762-4ED3E3EA9025" ],
              args = predicates.records.record
                  {
                    files = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.arrays.uniqueItems
                            ])
                          ],
                          predicates.isType '"String"
                        ],
                  }
                  {  }
                  true
                  predicates.always,
            }
            {  }
            true
            predicates.always,
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "D396686C-DE0E-4DE6-906D-291CD29FC5DE" ],
              args = predicates.records.record
                  {
                    inRoot = predicates.isType '"Bool",
                    primaryOutputIndexes = predicates.isType '"String",
                    projectFiles = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.arrays.uniqueItems
                            ])
                          ],
                          predicates.isType '"String"
                        ],
                    solutionFolder = predicates.isType '"String",
                  }
                  {  }
                  true
                  predicates.always,
            }
            {  }
            true
            predicates.always,
            predicates.records.record
            {
              actionId = predicates.enum
                  [ "84C0DA21-51C8-4541-9940-6CA19AF04EE6" ],
              args = predicates.records.record
                  { files = predicates.isType '"String", }
                  {  }
                  true
                  predicates.always,
            }
            {  }
            true
            predicates.always
          ]
        ]
      ])
    ])
    | doc m%"
    Defines an ordered list of actions to perform after template generation. The post action information is provided to the creation broker, to act on as appropriate.
    "%
    | optional,
  precedence
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.anyOf
      [ predicates.isType 'Integer, predicates.isType '"String" ],
      predicates.strings.pattern "^([0-9]+)$"
    ])
    | doc m%"
    A value used to determine how preferred this template is among the other templates with the same groupIdentity (higher values are more preferred).
    "%
    | optional,
  preferDefaultName
    | predicates.contract_from_predicate
    (predicates.anyOf [ predicates.isType '"Bool" ])
    | doc m%"
    Indicated which behaviour to use when no `--name` is specified during template creation. If `true` it will use the template's `defaultName`. If no `defaultName` is found, or `preferDefaultName` is `false` it uses the fallback (output folder).
    "%
    | optional,
  preferNameDirectory
    | Bool
    | doc m%"
    Indicates whether to create a directory for the template if name is specified but an output directory is not set (instead of creating the content directly in the current directory).
    "%
    | optional,
  primaryOutputs
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.records.required [ "path" ],
        predicates.records.record
        {
          condition = predicates.isType '"String",
          path = predicates.isType '"String",
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    A list of important output paths created during template generation. These paths need to be added to the newly created project at the end of template creation.
    "%
    | optional,
  shortName
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.oneOf
      [
        predicates.isType '"String",
        predicates.allOf
        [
          predicates.isType '"Array",
          predicates.arrays.arrayOf (predicates.isType '"String")
        ]
      ],
      predicates.strings.minLength 1
    ]),
  sourceName
    | String
    | doc m%"
    The text in the source content to replace with the name the user specifies. The value of the 'sourceName' is available in built-in 'name' symbol that can be used as the source for creating other symbols and condition expressions. See important information about how to select correct 'sourceName' in https://github.com/dotnet/templating/wiki/Naming-and-default-value-forms.
    "%
    | optional,
  sources
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType '"Array",
      predicates.arrays.arrayOf definitions.predicate.source
    ])
    | doc m%"
    The set of mappings in the template content to user directories.
    "%
    | optional,
  symbols
    | predicates.contract_from_predicate
    (predicates.allOf
    [
      predicates.isType 'Record,
      predicates.records.record {  } {  } true
      (predicates.allOf
      [
        predicates.isType 'Record,
        predicates.oneOf
        [
          predicates.allOf
          [
            predicates.records.required [ "binding" ],
            predicates.records.record
            {
              binding = predicates.isType '"String",
              defaultValue = predicates.isType '"String",
              fileRename = predicates.isType '"String",
              onlyIf = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        after = predicates.isType '"String",
                        before = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              replaces = predicates.isType '"String",
              type = predicates.enum [ "bind" ],
            }
            {  }
            true
            predicates.always
          ],
          predicates.allOf
          [
            predicates.records.required [ "valueSource", "valueTransform" ],
            predicates.records.record
            {
              defaultValue = predicates.isType '"String",
              fileRename = predicates.isType '"String",
              onlyIf = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        after = predicates.isType '"String",
                        before = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              replaces = predicates.isType '"String",
              type = predicates.enum [ "derived" ],
              valueSource = predicates.isType '"String",
              valueTransform = predicates.isType '"String",
            }
            {  }
            true
            predicates.always
          ],
          predicates.allOf
          [
            predicates.oneOf
            [
              definitions.predicate.generatorCasing,
              definitions.predicate.generatorCoalesce,
              definitions.predicate.generatorConstant,
              definitions.predicate.generatorGuid,
              definitions.predicate.generatorNow,
              definitions.predicate.generatorPort,
              definitions.predicate.generatorRandom,
              definitions.predicate.generatorRegex,
              definitions.predicate.generatorRegexMatch,
              definitions.predicate.generatorSwitch,
              definitions.predicate.generatorJoin
            ],
            predicates.records.required [ "generator" ],
            predicates.records.record
            {
              fileRename = predicates.isType '"String",
              onlyIf = predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        after = predicates.isType '"String",
                        before = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ])
                  ],
              replaces = predicates.isType '"String",
              type = predicates.enum [ "generated" ],
            }
            {  }
            true
            predicates.always
          ],
          predicates.records.record
          {
            allowMultipleValues = predicates.isType '"Bool",
            choices = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.records.required [ "choice" ],
                    predicates.records.record
                    {
                      choice = predicates.isType '"String",
                      description = predicates.isType '"String",
                      displayName = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ])
                ],
            defaultValue = predicates.isType '"String",
            description = predicates.isType '"String",
            displayName = predicates.isType '"String",
            enableQuotelessLiterals = predicates.isType '"Bool",
            fileRename = predicates.isType '"String",
            forms = predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.record
                  {
                    global = predicates.oneOf
                        [
                          predicates.allOf
                          [
                            predicates.isType '"Array",
                            predicates.arrays.arrayOf
                            (predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.arrays.uniqueItems
                            ])
                          ],
                          predicates.isType '"String"
                        ],
                  }
                  {  }
                  true
                  predicates.always
                ],
            isEnabled = predicates.oneOf
                [ predicates.isType '"Bool", predicates.isType '"String" ],
            isRequired = predicates.oneOf
                [ predicates.isType '"Bool", predicates.isType '"String" ],
            onlyIf = predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      after = predicates.isType '"String",
                      before = predicates.isType '"String",
                    }
                    {  }
                    true
                    predicates.always
                  ])
                ],
            replaces = predicates.isType '"String",
            type = predicates.enum [ "parameter" ],
          }
          {  }
          true
          predicates.always,
          predicates.records.record
          {
            type = predicates.enum [ "computed" ],
            value = predicates.isType '"String",
          }
          {  }
          true
          predicates.always
        ],
        predicates.records.required [ "type" ],
        predicates.records.record
        {
          datatype = definitions.predicate.datatype,
          type = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "bind", "derived", "generated", "parameter", "computed" ]
              ],
        }
        {  }
        true
        predicates.always
      ])
    ])
    | doc m%"
    The symbols section defines variables and their values, the values may be the defined in terms of other symbols. When a defined symbol name is encountered anywhere in the template definition, it is replaced by the value defined in this configuration. The symbols configuration is a collection of key-value pairs. The keys are the symbol names, and the value contains key-value-pair configuration information on how to assign the symbol a value.
    "%
    | optional,
  tags
    | {
      language
        | String
        | doc m%"
        The programming language the template primarily contains or is intended for use with.
        "%
        | optional,
      type
        | predicates.contract_from_predicate
        (predicates.enum [ "project", "item", "solution" ])
        | doc m%"
        The type of template: project or item.
        "%,
      ..
    }
    | doc m%"
    Common information about templates, these are effectively interchangeable with choice type parameter symbols.
    "%,
  thirdPartyNotices
    | String
    | doc m%"
    An URL for a document indicating any libraries used by the template that are not owned/provided by the template author.
    "%
    | optional,
  ..
}