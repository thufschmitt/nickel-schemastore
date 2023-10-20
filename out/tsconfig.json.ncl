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
          "//" = predicates.contract_from_predicate definitions.predicate."//",
          buildOptionsDefinition = predicates.contract_from_predicate
              definitions.predicate.buildOptionsDefinition,
          compileOnSaveDefinition = predicates.contract_from_predicate
              definitions.predicate.compileOnSaveDefinition,
          compilerOptionsDefinition = predicates.contract_from_predicate
              definitions.predicate.compilerOptionsDefinition,
          excludeDefinition = predicates.contract_from_predicate
              definitions.predicate.excludeDefinition,
          extendsDefinition = predicates.contract_from_predicate
              definitions.predicate.extendsDefinition,
          filesDefinition = predicates.contract_from_predicate
              definitions.predicate.filesDefinition,
          includeDefinition = predicates.contract_from_predicate
              definitions.predicate.includeDefinition,
          referencesDefinition = predicates.contract_from_predicate
              definitions.predicate.referencesDefinition,
          tsNodeDefinition = predicates.contract_from_predicate
              definitions.predicate.tsNodeDefinition,
          tsNodeModuleTypes = {  .. },
          typeAcquisitionDefinition = predicates.contract_from_predicate
              definitions.predicate.typeAcquisitionDefinition,
          watchOptionsDefinition = predicates.contract_from_predicate
              definitions.predicate.watchOptionsDefinition,
        },
    predicate = {
          "//" = predicates.always,
          buildOptionsDefinition = predicates.records.record
              {
                buildOptions = predicates.records.record
                    {
                      assumeChangesOnlyAffectDirectDependencies =
                        predicates.isType '"Bool",
                      dry = predicates.isType '"Bool",
                      "force" = predicates.isType '"Bool",
                      incremental = predicates.isType '"Bool",
                      traceResolution = predicates.isType '"Bool",
                      verbose = predicates.isType '"Bool",
                    }
                    {  }
                    true
                    predicates.always,
              }
              {  }
              true
              predicates.always,
          compileOnSaveDefinition = predicates.records.record
              { compileOnSave = predicates.isType '"Bool", }
              {  }
              true
              predicates.always,
          compilerOptionsDefinition = predicates.records.record
              {
                compilerOptions = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        allowArbitraryExtensions = predicates.isType '"Bool",
                        allowImportingTsExtensions = predicates.isType '"Bool",
                        allowJs = predicates.isType '"Bool",
                        allowSyntheticDefaultImports = predicates.isType
                            '"Bool",
                        allowUmdGlobalAccess = predicates.isType '"Bool",
                        allowUnreachableCode = predicates.isType '"Bool",
                        allowUnusedLabels = predicates.isType '"Bool",
                        alwaysStrict = predicates.isType '"Bool",
                        assumeChangesOnlyAffectDirectDependencies =
                          predicates.isType '"Bool",
                        baseUrl = predicates.isType '"String",
                        charset = predicates.isType '"String",
                        checkJs = predicates.isType '"Bool",
                        composite = predicates.isType '"Bool",
                        customConditions = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        declaration = predicates.isType '"Bool",
                        declarationDir = predicates.anyOf
                            [
                              predicates.isType '"String",
                              predicates.isType 'Null
                            ],
                        declarationMap = predicates.isType '"Bool",
                        diagnostics = predicates.isType '"Bool",
                        disableReferencedProjectLoad = predicates.isType
                            '"Bool",
                        disableSizeLimit = predicates.isType '"Bool",
                        disableSolutionSearching = predicates.isType '"Bool",
                        disableSourceOfProjectReferenceRedirect =
                          predicates.isType '"Bool",
                        downlevelIteration = predicates.isType '"Bool",
                        emitBOM = predicates.isType '"Bool",
                        emitDeclarationOnly = predicates.isType '"Bool",
                        emitDecoratorMetadata = predicates.isType '"Bool",
                        esModuleInterop = predicates.isType '"Bool",
                        exactOptionalPropertyTypes = predicates.isType '"Bool",
                        experimentalDecorators = predicates.isType '"Bool",
                        extendedDiagnostics = predicates.isType '"Bool",
                        fallbackPolling = predicates.enum
                            [
                              "fixedPollingInterval",
                              "priorityPollingInterval",
                              "dynamicPriorityPolling",
                              "fixedInterval",
                              "priorityInterval",
                              "dynamicPriority",
                              "fixedChunkSize"
                            ],
                        forceConsistentCasingInFileNames = predicates.isType
                            '"Bool",
                        generateCpuProfile = predicates.isType '"String",
                        importHelpers = predicates.isType '"Bool",
                        importsNotUsedAsValues = predicates.enum
                            [ "remove", "preserve", "error" ],
                        incremental = predicates.isType '"Bool",
                        inlineSourceMap = predicates.isType '"Bool",
                        inlineSources = predicates.isType '"Bool",
                        isolatedModules = predicates.isType '"Bool",
                        jsx = predicates.enum
                            [
                              "preserve",
                              "react",
                              "react-jsx",
                              "react-jsxdev",
                              "react-native"
                            ],
                        jsxFactory = predicates.isType '"String",
                        jsxFragmentFactory = predicates.isType '"String",
                        jsxImportSource = predicates.isType '"String",
                        keyofStringsOnly = predicates.isType '"Bool",
                        lib = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType '"String",
                                predicates.anyOf
                                [
                                  predicates.enum
                                  [
                                    "ES5",
                                    "ES6",
                                    "ES2015",
                                    "ES2015.Collection",
                                    "ES2015.Core",
                                    "ES2015.Generator",
                                    "ES2015.Iterable",
                                    "ES2015.Promise",
                                    "ES2015.Proxy",
                                    "ES2015.Reflect",
                                    "ES2015.Symbol.WellKnown",
                                    "ES2015.Symbol",
                                    "ES2016",
                                    "ES2016.Array.Include",
                                    "ES2017",
                                    "ES2017.Intl",
                                    "ES2017.Object",
                                    "ES2017.SharedMemory",
                                    "ES2017.String",
                                    "ES2017.TypedArrays",
                                    "ES2018",
                                    "ES2018.AsyncGenerator",
                                    "ES2018.AsyncIterable",
                                    "ES2018.Intl",
                                    "ES2018.Promise",
                                    "ES2018.Regexp",
                                    "ES2019",
                                    "ES2019.Array",
                                    "ES2019.Intl",
                                    "ES2019.Object",
                                    "ES2019.String",
                                    "ES2019.Symbol",
                                    "ES2020",
                                    "ES2020.BigInt",
                                    "ES2020.Promise",
                                    "ES2020.String",
                                    "ES2020.Symbol.WellKnown",
                                    "ESNext",
                                    "ESNext.Array",
                                    "ESNext.AsyncIterable",
                                    "ESNext.BigInt",
                                    "ESNext.Intl",
                                    "ESNext.Promise",
                                    "ESNext.String",
                                    "ESNext.Symbol",
                                    "DOM",
                                    "DOM.Iterable",
                                    "ScriptHost",
                                    "WebWorker",
                                    "WebWorker.ImportScripts",
                                    "Webworker.Iterable",
                                    "ES7",
                                    "ES2021",
                                    "ES2020.SharedMemory",
                                    "ES2020.Intl",
                                    "ES2020.Date",
                                    "ES2020.Number",
                                    "ES2021.Promise",
                                    "ES2021.String",
                                    "ES2021.WeakRef",
                                    "ESNext.WeakRef",
                                    "ES2021.Intl",
                                    "ES2022",
                                    "ES2022.Array",
                                    "ES2022.Error",
                                    "ES2022.Intl",
                                    "ES2022.Object",
                                    "ES2022.String",
                                    "ES2022.SharedMemory",
                                    "ES2022.RegExp",
                                    "ES2023",
                                    "ES2023.Array"
                                  ],
                                  predicates.strings.pattern
                                  "^[Ee][Ss]5|[Ee][Ss]6|[Ee][Ss]7$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2015(\\.([Cc][Oo][Ll][Ll][Ee][Cc][Tt][Ii][Oo][Nn]|[Cc][Oo][Rr][Ee]|[Gg][Ee][Nn][Ee][Rr][Aa][Tt][Oo][Rr]|[Ii][Tt][Ee][Rr][Aa][Bb][Ll][Ee]|[Pp][Rr][Oo][Mm][Ii][Ss][Ee]|[Pp][Rr][Oo][Xx][Yy]|[Rr][Ee][Ff][Ll][Ee][Cc][Tt]|[Ss][Yy][Mm][Bb][Oo][Ll].[Ww][Ee][Ll][Ll][Kk][Nn][Oo][Ww][Nn]|[Ss][Yy][Mm][Bb][Oo][Ll]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2016(\\.[Aa][Rr][Rr][Aa][Yy].[Ii][Nn][Cc][Ll][Uu][Dd][Ee])?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2017(\\.([Ii][Nn][Tt][Ll]|[Oo][Bb][Jj][Ee][Cc][Tt]|[Ss][Hh][Aa][Rr][Ee][Dd][Mm][Ee][Mm][Oo][Rr][Yy]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Tt][Yy][Pp][Ee][Dd][Aa][Rr][Rr][Aa][Yy][Ss]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2018(\\.([Aa][Ss][Yy][Nn][Cc][Ii][Tt][Ee][Rr][Aa][Bb][Ll][Ee]|[Ii][Nn][Tt][Ll]|[Pp][Rr][Oo][Mm][Ii][Ss][Ee]|[Rr][Ee][Gg][Ee][Xx][Pp]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2019(\\.([Aa][Rr][Rr][Aa][Yy]|[Oo][Bb][Jj][Ee][Cc][Tt]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ss][Yy][Mm][Bb][Oo][Ll]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2020(\\.([Bb][Ii][Gg][Ii][Nn][Tt]|[Pp][Rr][Oo][Mm][Ii][Ss][Ee]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ss][Yy][Mm][Bb][Oo][Ll].[Ww][Ee][Ll][Ll][Kk][Nn][Oo][Ww][Nn]|[Dd][Aa][Tt][Ee]|[Nn][Uu][Mm][Bb][Ee][Rr]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2021(\\.([Ii][Nn][Tt][Ll]|[Pp][Rr][Oo][Mm][Ii][Ss][Ee]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ww][Ee][Aa][Kk][Rr][Ee][Ff]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2022(\\.([Aa][Rr][Rr][Aa][Yy]|[Ee][Rr][Rr][Oo][Rr]|[Ii][Nn][Tt][Ll]|[Oo][Bb][Jj][Ee][Cc][Tt]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ss][Hh][Aa][Rr][Ee][Dd][Mm][Ee][Mm][Oo][Rr][Yy]|[Rr][Ee][Gg][Ee][Xx][Pp]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss]2023(\\.([Aa][Rr][Rr][Aa][Yy]))?$",
                                  predicates.strings.pattern
                                  "^[Ee][Ss][Nn][Ee][Xx][Tt](\\.([Aa][Rr][Rr][Aa][Yy]|[Aa][Ss][Yy][Nn][Cc][Ii][Tt][Ee][Rr][Aa][Bb][Ll][Ee]|[Bb][Ii][Gg][Ii][Nn][Tt]|[Ii][Nn][Tt][Ll]|[Pp][Rr][Oo][Mm][Ii][Ss][Ee]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ss][Yy][Mm][Bb][Oo][Ll]|[Ww][Ee][Aa][Kk][Rr][Ee][Ff]))?$",
                                  predicates.strings.pattern
                                  "^[Dd][Oo][Mm](\\.[Ii][Tt][Ee][Rr][Aa][Bb][Ll][Ee])?$",
                                  predicates.strings.pattern
                                  "^[Ss][Cc][Rr][Ii][Pp][Tt][Hh][Oo][Ss][Tt]$",
                                  predicates.strings.pattern
                                  "^[Ww][Ee][Bb][Ww][Oo][Rr][Kk][Ee][Rr](\\.[Ii][Mm][Pp][Oo][Rr][Tt][Ss][Cc][Rr][Ii][Pp][Tt][Ss])?$"
                                ]
                              ]),
                              predicates.arrays.uniqueItems
                            ],
                        listEmittedFiles = predicates.isType '"Bool",
                        listFiles = predicates.isType '"Bool",
                        listFilesOnly = predicates.isType '"Bool",
                        mapRoot = predicates.isType '"String",
                        maxNodeModuleJsDepth = predicates.isType '"Number",
                        module = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.anyOf
                              [
                                predicates.enum
                                [
                                  "CommonJS",
                                  "AMD",
                                  "System",
                                  "UMD",
                                  "ES6",
                                  "ES2015",
                                  "ES2020",
                                  "ESNext",
                                  "None",
                                  "ES2022",
                                  "Node16",
                                  "NodeNext"
                                ],
                                predicates.strings.pattern
                                "^([Cc][Oo][Mm][Mm][Oo][Nn][Jj][Ss]|[AaUu][Mm][Dd]|[Ss][Yy][Ss][Tt][Ee][Mm]|[Ee][Ss]([356]|20(1[567]|2[02])|[Nn][Ee][Xx][Tt])|[Nn][Oo][dD][Ee]16|[Nn][Oo][Dd][Ee][Nn][Ee][Xx][Tt]|[Nn][Oo][Nn][Ee])$"
                              ]
                            ],
                        moduleDetection = predicates.enum
                            [ "auto", "legacy", "force" ],
                        moduleResolution = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.anyOf
                              [
                                predicates.enum
                                [
                                  "Classic",
                                  "Node",
                                  "Node10",
                                  "Node16",
                                  "NodeNext",
                                  "Bundler"
                                ],
                                predicates.strings.pattern
                                "^(([Nn]ode)|([Nn]ode1[06])|([Nn]ode[Nn]ext)|([Cc]lassic)|([Bb]undler))$"
                              ]
                            ],
                        newLine = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.anyOf
                              [
                                predicates.enum [ "crlf", "lf" ],
                                predicates.strings.pattern "^(CRLF|LF|crlf|lf)$"
                              ]
                            ],
                        noEmit = predicates.isType '"Bool",
                        noEmitHelpers = predicates.isType '"Bool",
                        noEmitOnError = predicates.isType '"Bool",
                        noErrorTruncation = predicates.isType '"Bool",
                        noFallthroughCasesInSwitch = predicates.isType '"Bool",
                        noImplicitAny = predicates.isType '"Bool",
                        noImplicitOverride = predicates.isType '"Bool",
                        noImplicitReturns = predicates.isType '"Bool",
                        noImplicitThis = predicates.isType '"Bool",
                        noImplicitUseStrict = predicates.isType '"Bool",
                        noLib = predicates.isType '"Bool",
                        noPropertyAccessFromIndexSignature = predicates.isType
                            '"Bool",
                        noResolve = predicates.isType '"Bool",
                        noStrictGenericChecks = predicates.isType '"Bool",
                        noUncheckedIndexedAccess = predicates.isType '"Bool",
                        noUnusedLocals = predicates.isType '"Bool",
                        noUnusedParameters = predicates.isType '"Bool",
                        outDir = predicates.isType '"String",
                        outFile = predicates.isType '"String",
                        paths = predicates.allOf
                            [
                              predicates.isType 'Record,
                              predicates.records.record {  } {  } true
                              (predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.arrayOf
                                (predicates.isType '"String"),
                                predicates.arrays.uniqueItems
                              ])
                            ],
                        plugins = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.allOf
                              [
                                predicates.isType 'Record,
                                predicates.records.record
                                { name = predicates.isType '"String", }
                                {  }
                                true
                                predicates.always
                              ])
                            ],
                        preserveConstEnums = predicates.isType '"Bool",
                        preserveSymlinks = predicates.isType '"Bool",
                        preserveValueImports = predicates.isType '"Bool",
                        preserveWatchOutput = predicates.isType '"Bool",
                        pretty = predicates.isType '"Bool",
                        reactNamespace = predicates.isType '"String",
                        removeComments = predicates.isType '"Bool",
                        resolveJsonModule = predicates.isType '"Bool",
                        resolvePackageJsonExports = predicates.isType '"Bool",
                        resolvePackageJsonImports = predicates.isType '"Bool",
                        rootDir = predicates.isType '"String",
                        rootDirs = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        skipDefaultLibCheck = predicates.isType '"Bool",
                        skipLibCheck = predicates.isType '"Bool",
                        sourceMap = predicates.isType '"Bool",
                        sourceRoot = predicates.isType '"String",
                        strict = predicates.isType '"Bool",
                        strictBindCallApply = predicates.isType '"Bool",
                        strictFunctionTypes = predicates.isType '"Bool",
                        strictNullChecks = predicates.isType '"Bool",
                        strictPropertyInitialization = predicates.isType
                            '"Bool",
                        stripInternal = predicates.isType '"Bool",
                        suppressExcessPropertyErrors = predicates.isType
                            '"Bool",
                        suppressImplicitAnyIndexErrors = predicates.isType
                            '"Bool",
                        target = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.anyOf
                              [
                                predicates.enum
                                [
                                  "ES3",
                                  "ES5",
                                  "ES6",
                                  "ES2015",
                                  "ES2016",
                                  "ES2017",
                                  "ES2018",
                                  "ES2019",
                                  "ES2020",
                                  "ES2021",
                                  "ES2022",
                                  "ES2023",
                                  "ESNext"
                                ],
                                predicates.strings.pattern
                                "^([Ee][Ss]([356]|(20(1[56789]|2[0123]))|[Nn][Ee][Xx][Tt]))$"
                              ]
                            ],
                        traceResolution = predicates.isType '"Bool",
                        tsBuildInfoFile = predicates.isType '"String",
                        typeRoots = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        types = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        useDefineForClassFields = predicates.isType '"Bool",
                        useUnknownInCatchVariables = predicates.isType '"Bool",
                        verbatimModuleSyntax = predicates.isType '"Bool",
                        watch = predicates.isType '"Bool",
                        watchDirectory = predicates.enum
                            [
                              "useFsEvents",
                              "fixedPollingInterval",
                              "dynamicPriorityPolling",
                              "fixedChunkSizePolling"
                            ],
                        watchFile = predicates.enum
                            [
                              "fixedPollingInterval",
                              "priorityPollingInterval",
                              "dynamicPriorityPolling",
                              "useFsEvents",
                              "useFsEventsOnParentDirectory",
                              "fixedChunkSizePolling"
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
          excludeDefinition = predicates.records.record
              {
                exclude = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always,
          extendsDefinition = predicates.records.record
              {
                extends = predicates.oneOf
                    [
                      predicates.isType '"String",
                      predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ]
                    ],
              }
              {  }
              true
              predicates.always,
          filesDefinition = predicates.records.record
              {
                files = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always,
          includeDefinition = predicates.records.record
              {
                include = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String"),
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always,
          referencesDefinition = predicates.records.record
              {
                references = predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      (predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record
                        { path = predicates.isType '"String", }
                        {  }
                        true
                        predicates.always
                      ]),
                      predicates.arrays.uniqueItems
                    ],
              }
              {  }
              true
              predicates.always,
          tsNodeDefinition = predicates.records.record
              {
                ts-node = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        compiler = predicates.isType '"String",
                        compilerHost = predicates.isType '"Bool",
                        compilerOptions = predicates.allOf
                            [
                              predicates.isType 'Record,
                              definitions.predicate."compilerOptionsDefinition/properties/compilerOptions",
                              predicates.records.record {  } {  } true
                              predicates.always
                            ],
                        emit = predicates.isType '"Bool",
                        esm = predicates.isType '"Bool",
                        experimentalReplAwait = predicates.isType '"Bool",
                        experimentalResolver = predicates.isType '"Bool",
                        experimentalSpecifierResolution = predicates.allOf
                            [
                              predicates.isType '"String",
                              predicates.enum [ "explicit", "node" ]
                            ],
                        files = predicates.isType '"Bool",
                        ignore = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        ignoreDiagnostics = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.anyOf
                              [
                                predicates.isType '"String",
                                predicates.isType '"Number"
                              ])
                            ],
                        logError = predicates.isType '"Bool",
                        moduleTypes = definitions.predicate.tsNodeModuleTypes,
                        preferTsExts = predicates.isType '"Bool",
                        pretty = predicates.isType '"Bool",
                        require = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String")
                            ],
                        scope = predicates.isType '"Bool",
                        scopeDir = predicates.isType '"String",
                        skipIgnore = predicates.isType '"Bool",
                        swc = predicates.isType '"Bool",
                        transpileOnly = predicates.isType '"Bool",
                        transpiler = predicates.anyOf
                            [
                              predicates.allOf
                              [
                                predicates.isType '"Array",
                                predicates.arrays.items
                                [
                                  predicates.isType '"String",
                                  predicates.allOf
                                  [
                                    predicates.isType 'Record,
                                    predicates.records.record {  } {  } true
                                    predicates.always
                                  ]
                                ],
                                predicates.arrays.maxItems 2,
                                predicates.arrays.minItems 2
                              ],
                              predicates.isType '"String"
                            ],
                        typeCheck = predicates.isType '"Bool",
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
          tsNodeModuleTypes = predicates.isType 'Record,
          typeAcquisitionDefinition = predicates.records.record
              {
                typeAcquisition = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        enable = predicates.isType '"Bool",
                        exclude = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        include = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
          watchOptionsDefinition = predicates.records.record
              {
                watchOptions = predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record
                      {
                        excludeDirectories = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        excludeFiles = predicates.allOf
                            [
                              predicates.isType '"Array",
                              predicates.arrays.arrayOf
                              (predicates.isType '"String"),
                              predicates.arrays.uniqueItems
                            ],
                        fallbackPolling = predicates.isType '"String",
                        "force" = predicates.isType '"String",
                        synchronousWatchDirectory = predicates.isType '"Bool",
                        watchDirectory = predicates.isType '"String",
                        watchFile = predicates.isType '"String",
                      }
                      {  }
                      true
                      predicates.always
                    ],
              }
              {  }
              true
              predicates.always,
        },
  }
in

predicates.contract_from_predicate
(predicates.allOf
[
  predicates.isType 'Record,
  predicates.allOf
  [
    definitions.predicate.compilerOptionsDefinition,
    definitions.predicate.compileOnSaveDefinition,
    definitions.predicate.typeAcquisitionDefinition,
    definitions.predicate.extendsDefinition,
    definitions.predicate.watchOptionsDefinition,
    definitions.predicate.buildOptionsDefinition,
    definitions.predicate.tsNodeDefinition,
    predicates.anyOf
    [
      definitions.predicate.filesDefinition,
      definitions.predicate.excludeDefinition,
      definitions.predicate.includeDefinition,
      definitions.predicate.referencesDefinition
    ]
  ]
])