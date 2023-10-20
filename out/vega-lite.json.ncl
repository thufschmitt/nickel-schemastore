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
          Aggregate = predicates.contract_from_predicate
              definitions.predicate.Aggregate,
          AggregateOp = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'variancep,
                  'variance,
                  'values,
                  'valid,
                  'sum,
                  'stdevp,
                  'stdev,
                  'ci1,
                  'ci0,
                  'q3,
                  'q1,
                  'missing,
                  'min,
                  'median,
                  'mean,
                  'max,
                  'distinct,
                  'count,
                  'average,
                  'argmin,
                  'argmax
                |]
              ],
          AggregateTransform = {
                aggregate
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.AggregatedFieldDef
                  ])
                  | doc m%"
                  Array of objects that define fields to aggregate.
                  "%,
                groupby
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  The data fields to group by. If not specified, a single group containing all data objects will be used.
                  "%
                  | optional,
              },
          AggregatedFieldDef = {
                as
                  | String
                  | doc m%"
                  The output field names to use for each aggregated field.
                  "%,
                field
                  | String
                  | doc m%"
                  The data field for which to compute aggregate function.
                  "%,
                op
                  | definitions.contract.AggregateOp
                  | doc m%"
                  The aggregation operations to apply to the fields, such as sum, average or count.
                  See the [full list of supported aggregation operations](https://vega.github.io/vega-lite/docs/aggregate.html#supported-aggregation-operations)
                  for more information.
                  "%,
              },
          Anchor = std.contract.Sequence
              [ std.enum.TagOrString, [| 'end, 'middle, 'start |] ],
          AndFilter = {
                and
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FilterOperand
                  ]),
              },
          AnyMark = predicates.contract_from_predicate
              definitions.predicate.AnyMark,
          AutoSizeParams = {
                contains
                  | std.enum.TagOrString
                  | [| 'padding, 'content |]
                  | doc m%"
                  Determines how size calculation should be performed, one of `"content"` or `"padding"`. The default setting (`"content"`) interprets the width and height settings as the data rectangle (plotting) dimensions, to which padding is then added. In contrast, the `"padding"` setting includes the padding within the view size calculations, such that the width and height settings indicate the **total** intended size of the view.
                  
                  __Default value__: `"content"`
                  "%
                  | optional,
                resize
                  | Bool
                  | doc m%"
                  A boolean flag indicating if autosize layout should be re-calculated on every view update.
                  
                  __Default value__: `false`
                  "%
                  | optional,
                type
                  | definitions.contract.AutosizeType
                  | doc m%"
                  The sizing format type. One of `"pad"`, `"fit"` or `"none"`. See the [autosize type](https://vega.github.io/vega-lite/docs/size.html#autosize) documentation for descriptions of each.
                  
                  __Default value__: `"pad"`
                  "%
                  | optional,
              },
          AutosizeType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'none, 'fit, 'pad |] ],
          Axis = {
                domain
                  | Bool
                  | doc m%"
                  A boolean flag indicating if the domain (the axis baseline) should be included as part of the axis.
                  
                  __Default value:__ `true`
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  The formatting pattern for labels. This is D3's [number format pattern](https://github.com/d3/d3-format#locale_format) for quantitative fields and D3's [time format pattern](https://github.com/d3/d3-time-format#locale_format) for time field.
                  
                  See the [format documentation](format.html) for more information.
                  
                  __Default value:__  derived from [numberFormat](config.html#format) config for quantitative fields and from [timeFormat](config.html#format) config for temporal fields.
                  "%
                  | optional,
                grid
                  | Bool
                  | doc m%"
                  A boolean flag indicating if grid lines should be included as part of the axis
                  
                  __Default value:__ `true` for [continuous scales](scale.html#continuous) that are not binned; otherwise, `false`.
                  "%
                  | optional,
                labelAngle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum (-360)
                  ])
                  | doc m%"
                  The rotation angle of the axis labels.
                  
                  __Default value:__ `-90` for nominal and ordinal fields; `0` otherwise.
                  "%
                  | optional,
                labelBound
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if labels should be hidden if they exceed the axis range. If `false `(the default) no bounds overlap analysis is performed. If `true`, labels will be hidden if they exceed the axis range by more than 1 pixel. If this property is a number, it specifies the pixel tolerance: the maximum amount by which a label bounding box may exceed the axis range.
                  
                  __Default value:__ `false`.
                  "%
                  | optional,
                labelFlush
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if the first and last axis labels should be aligned flush with the scale range. Flush alignment for a horizontal axis will left-align the first label and right-align the last label. For vertical axes, bottom and top text baselines are applied instead. If this property is a number, it also indicates the number of pixels by which to offset the first and last labels; for example, a value of 2 will flush-align the first and last labels and also push them 2 pixels outward from the center of the axis. The additional adjustment can sometimes help the labels better visually group with corresponding axis ticks.
                  
                  __Default value:__ `true` for axis of a continuous x-scale. Otherwise, `false`.
                  "%
                  | optional,
                labelOverlap
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "parity" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "greedy" ]
                    ]
                  ])
                  | doc m%"
                  The strategy to use for resolving overlap of axis labels. If `false` (the default), no overlap reduction is attempted. If set to `true` or `"parity"`, a strategy of removing every other label is used (this works well for standard linear axes). If set to `"greedy"`, a linear scan of the labels is performed, removing any labels that overlaps with the last visible label (this often works better for log-scaled axes).
                  
                  __Default value:__ `true` for non-nominal fields with non-log scales; `"greedy"` for log scales; otherwise `false`.
                  "%
                  | optional,
                labelPadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between axis and text labels.
                  "%
                  | optional,
                labels
                  | Bool
                  | doc m%"
                  A boolean flag indicating if labels should be included as part of the axis.
                  
                  __Default value:__  `true`.
                  "%
                  | optional,
                maxExtent
                  | Number
                  | doc m%"
                  The maximum extent in pixels that axis ticks and labels should use. This determines a maximum offset value for axis titles.
                  
                  __Default value:__ `undefined`.
                  "%
                  | optional,
                minExtent
                  | Number
                  | doc m%"
                  The minimum extent in pixels that axis ticks and labels should use. This determines a minimum offset value for axis titles.
                  
                  __Default value:__ `30` for y-axis; `undefined` for x-axis.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The offset, in pixels, by which to displace the axis from the edge of the enclosing group or data rectangle.
                  
                  __Default value:__ derived from the [axis config](config.html#facet-scale-config)'s `offset` (`0` by default)
                  "%
                  | optional,
                orient
                  | definitions.contract.AxisOrient
                  | doc m%"
                  The orientation of the axis. One of `"top"`, `"bottom"`, `"left"` or `"right"`. The orientation can be used to further specialize the axis type (e.g., a y axis oriented for the right edge of the chart).
                  
                  __Default value:__ `"bottom"` for x-axes and `"left"` for y-axes.
                  "%
                  | optional,
                position
                  | Number
                  | doc m%"
                  The anchor position of the axis in pixels. For x-axis with top or bottom orientation, this sets the axis group x coordinate. For y-axis with left or right orientation, this sets the axis group y coordinate.
                  
                  __Default value__: `0`
                  "%
                  | optional,
                tickCount
                  | Number
                  | doc m%"
                  A desired number of ticks, for axes visualizing quantitative scales. The resulting number may be different so that values are "nice" (multiples of 2, 5, 10) and lie within the underlying scale's range.
                  "%
                  | optional,
                tickSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size in pixels of axis ticks.
                  "%
                  | optional,
                ticks
                  | Bool
                  | doc m%"
                  Boolean value that determines whether the axis should include ticks.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A title for the field. If `null`, the title will be removed.
                  
                  __Default value:__  derived from the field's name and transformation function (`aggregate`, `bin` and `timeUnit`).  If the field has an aggregate function, the function is displayed as a part of the title (e.g., `"Sum of Profit"`). If the field is binned or has a time unit applied, the applied function will be denoted in parentheses (e.g., `"Profit (binned)"`, `"Transaction Date (year-month)"`).  Otherwise, the title is simply the field name.
                  
                  __Note__: You can customize the default field title format by providing the [`fieldTitle` property in the [config](config.html) or [`fieldTitle` function via the `compile` function's options](compile.html#field-title).
                  "%
                  | optional,
                titleMaxLength
                  | Number
                  | doc m%"
                  Max length for axis title if the title is automatically generated from the field's description.
                  "%
                  | optional,
                titlePadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between title and axis.
                  "%
                  | optional,
                values
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Number")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.DateTime
                    ]
                  ])
                  | doc m%"
                  Explicitly set the visible axis tick values.
                  "%
                  | optional,
                zindex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  A non-positive integer indicating z-index of the axis.
                  If zindex is 0, axes should be drawn behind all chart elements.
                  To put them in front, use `"zindex = 1"`.
                  
                  __Default value:__ `1` (in front of the marks) for actual axis and `0` (behind the marks) for grids.
                  "%
                  | optional,
              },
          AxisConfig = {
                bandPosition
                  | Number
                  | doc m%"
                  An interpolation fraction indicating where, for `band` scales, axis ticks should be positioned. A value of `0` places ticks at the left edge of their bands. A value of `0.5` places ticks in the middle of their bands.
                  "%
                  | optional,
                domain
                  | Bool
                  | doc m%"
                  A boolean flag indicating if the domain (the axis baseline) should be included as part of the axis.
                  
                  __Default value:__ `true`
                  "%
                  | optional,
                domainColor
                  | String
                  | doc m%"
                  Color of axis domain line.
                  
                  __Default value:__  (none, using Vega default).
                  "%
                  | optional,
                domainWidth
                  | Number
                  | doc m%"
                  Stroke width of axis domain line
                  
                  __Default value:__  (none, using Vega default).
                  "%
                  | optional,
                grid
                  | Bool
                  | doc m%"
                  A boolean flag indicating if grid lines should be included as part of the axis
                  
                  __Default value:__ `true` for [continuous scales](scale.html#continuous) that are not binned; otherwise, `false`.
                  "%
                  | optional,
                gridColor
                  | String
                  | doc m%"
                  Color of gridlines.
                  "%
                  | optional,
                gridDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the grid dash array.
                  "%
                  | optional,
                gridOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity of grid (value between [0,1])
                  
                  __Default value:__ (`1` by default)
                  "%
                  | optional,
                gridWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The grid width, in pixels.
                  "%
                  | optional,
                labelAngle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum (-360)
                  ])
                  | doc m%"
                  The rotation angle of the axis labels.
                  
                  __Default value:__ `-90` for nominal and ordinal fields; `0` otherwise.
                  "%
                  | optional,
                labelBound
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if labels should be hidden if they exceed the axis range. If `false `(the default) no bounds overlap analysis is performed. If `true`, labels will be hidden if they exceed the axis range by more than 1 pixel. If this property is a number, it specifies the pixel tolerance: the maximum amount by which a label bounding box may exceed the axis range.
                  
                  __Default value:__ `false`.
                  "%
                  | optional,
                labelColor
                  | String
                  | doc m%"
                  The color of the tick label, can be in hex color code or regular color name.
                  "%
                  | optional,
                labelFlush
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if the first and last axis labels should be aligned flush with the scale range. Flush alignment for a horizontal axis will left-align the first label and right-align the last label. For vertical axes, bottom and top text baselines are applied instead. If this property is a number, it also indicates the number of pixels by which to offset the first and last labels; for example, a value of 2 will flush-align the first and last labels and also push them 2 pixels outward from the center of the axis. The additional adjustment can sometimes help the labels better visually group with corresponding axis ticks.
                  
                  __Default value:__ `true` for axis of a continuous x-scale. Otherwise, `false`.
                  "%
                  | optional,
                labelFont
                  | String
                  | doc m%"
                  The font of the tick label.
                  "%
                  | optional,
                labelFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size of the label, in pixels.
                  "%
                  | optional,
                labelLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis tick labels.
                  "%
                  | optional,
                labelOverlap
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "parity" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "greedy" ]
                    ]
                  ])
                  | doc m%"
                  The strategy to use for resolving overlap of axis labels. If `false` (the default), no overlap reduction is attempted. If set to `true` or `"parity"`, a strategy of removing every other label is used (this works well for standard linear axes). If set to `"greedy"`, a linear scan of the labels is performed, removing any labels that overlaps with the last visible label (this often works better for log-scaled axes).
                  
                  __Default value:__ `true` for non-nominal fields with non-log scales; `"greedy"` for log scales; otherwise `false`.
                  "%
                  | optional,
                labelPadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between axis and text labels.
                  "%
                  | optional,
                labels
                  | Bool
                  | doc m%"
                  A boolean flag indicating if labels should be included as part of the axis.
                  
                  __Default value:__  `true`.
                  "%
                  | optional,
                maxExtent
                  | Number
                  | doc m%"
                  The maximum extent in pixels that axis ticks and labels should use. This determines a maximum offset value for axis titles.
                  
                  __Default value:__ `undefined`.
                  "%
                  | optional,
                minExtent
                  | Number
                  | doc m%"
                  The minimum extent in pixels that axis ticks and labels should use. This determines a minimum offset value for axis titles.
                  
                  __Default value:__ `30` for y-axis; `undefined` for x-axis.
                  "%
                  | optional,
                shortTimeLabels
                  | Bool
                  | doc m%"
                  Whether month names and weekday names should be abbreviated.
                  
                  __Default value:__  `false`
                  "%
                  | optional,
                tickColor
                  | String
                  | doc m%"
                  The color of the axis's tick.
                  "%
                  | optional,
                tickRound
                  | Bool
                  | doc m%"
                  Boolean flag indicating if pixel position values should be rounded to the nearest integer.
                  "%
                  | optional,
                tickSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size in pixels of axis ticks.
                  "%
                  | optional,
                tickWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width, in pixels, of ticks.
                  "%
                  | optional,
                ticks
                  | Bool
                  | doc m%"
                  Boolean value that determines whether the axis should include ticks.
                  "%
                  | optional,
                titleAlign
                  | String
                  | doc m%"
                  Horizontal text alignment of axis titles.
                  "%
                  | optional,
                titleAngle
                  | Number
                  | doc m%"
                  Angle in degrees of axis titles.
                  "%
                  | optional,
                titleBaseline
                  | String
                  | doc m%"
                  Vertical text baseline for axis titles.
                  "%
                  | optional,
                titleColor
                  | String
                  | doc m%"
                  Color of the title, can be in hex color code or regular color name.
                  "%
                  | optional,
                titleFont
                  | String
                  | doc m%"
                  Font of the title. (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                titleFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Font size of the title.
                  "%
                  | optional,
                titleFontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Font weight of the title. (e.g., `"bold"`).
                  "%
                  | optional,
                titleLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis titles.
                  "%
                  | optional,
                titleMaxLength
                  | Number
                  | doc m%"
                  Max length for axis title if the title is automatically generated from the field's description.
                  "%
                  | optional,
                titlePadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between title and axis.
                  "%
                  | optional,
                titleX
                  | Number
                  | doc m%"
                  X-coordinate of the axis title relative to the axis group.
                  "%
                  | optional,
                titleY
                  | Number
                  | doc m%"
                  Y-coordinate of the axis title relative to the axis group.
                  "%
                  | optional,
              },
          AxisConfigMixins = {
                axis
                  | definitions.contract.AxisConfig
                  | doc m%"
                  Axis configuration, which determines default properties for all `x` and `y` [axes](axis.html). For a full list of axis configuration options, please see the [corresponding section of the axis documentation](axis.html#config).
                  "%
                  | optional,
                axisBand
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for axes with "band" scales.
                  "%
                  | optional,
                axisBottom
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for x-axis along the bottom edge of the chart.
                  "%
                  | optional,
                axisLeft
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for y-axis along the left edge of the chart.
                  "%
                  | optional,
                axisRight
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for y-axis along the right edge of the chart.
                  "%
                  | optional,
                axisTop
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for x-axis along the top edge of the chart.
                  "%
                  | optional,
                axisX
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  X-axis specific config.
                  "%
                  | optional,
                axisY
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Y-axis specific config.
                  "%
                  | optional,
              },
          AxisOrient = std.contract.Sequence
              [ std.enum.TagOrString, [| 'bottom, 'left, 'right, 'top |] ],
          AxisResolveMap = {
                x | definitions.contract.ResolveMode | optional,
                y | definitions.contract.ResolveMode | optional,
              },
          BarConfig = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                binSpacing
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Offset between bar for binned field.  Ideal value for this is either 0 (Preferred by statisticians) or 1 (Vega-Lite Default, D3 example style).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Default color.  Note that `fill` and `stroke` have higher precedence than `color` and will override `color`.
                  
                  __Default value:__ <span style="color: #4682b4;">&#9632;</span> `"#4682b4"`
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                continuousBandSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The default size of the bars on continuous scales.
                  
                  __Default value:__ `5`
                  "%
                  | optional,
                discreteBandSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size of the bars.  If unspecified, the default size is  `bandSize-1`,
                  which provides 1 pixel offset between bars.
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                filled
                  | Bool
                  | doc m%"
                  Whether the mark's color should be used as fill color instead of stroke color.
                  
                  __Default value:__ `true` for all marks except `point` and `false` for `point`.
                  
                  __Applicable for:__ `bar`, `point`, `circle`, `square`, and `area` marks.
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The pixel area each the point/circle/square.
                  For example: in the case of circles, the radius is determined in part by the square root of the size value.
                  
                  __Default value:__ `30`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
              },
          BaseBin = {
                base
                  | Number
                  | doc m%"
                  The number base to use for automatic bin determination (default is base 10).
                  
                  __Default value:__ `10`
                  "%
                  | optional,
                divide
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number"),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Scale factors indicating allowable subdivisions. The default value is [5, 2], which indicates that for base 10 numbers (the default base), the method may consider dividing bin sizes by 5 and/or 2. For example, for an initial step size of 10, the method can check if bin sizes of 2 (= 10/5), 5 (= 10/2), or 1 (= 10/(5*2)) might also satisfy the given constraints.
                  
                  __Default value:__ `[5, 2]`
                  "%
                  | optional,
                maxbins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 2 ])
                  | doc m%"
                  Maximum number of bins.
                  
                  __Default value:__ `6` for `row`, `column` and `shape` channels; `10` for other channels
                  "%
                  | optional,
                minstep
                  | Number
                  | doc m%"
                  A minimum allowable step size (particularly useful for integer values).
                  "%
                  | optional,
                nice
                  | Bool
                  | doc m%"
                  If true (the default), attempts to make the bin boundaries use human-friendly boundaries, such as multiples of ten.
                  "%
                  | optional,
                step
                  | Number
                  | doc m%"
                  An exact step size to use between bins.
                  
                  __Note:__ If provided, options such as maxbins will be ignored.
                  "%
                  | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number"),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of allowable step sizes to choose from.
                  "%
                  | optional,
              },
          BaseSelectionDef = {
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
              },
          BaseSpec = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          BinParams
            | doc m%"
            Binning properties or boolean flag for determining whether to bin data or not.
            "%
            = {
                base
                  | Number
                  | doc m%"
                  The number base to use for automatic bin determination (default is base 10).
                  
                  __Default value:__ `10`
                  "%
                  | optional,
                divide
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number"),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  Scale factors indicating allowable subdivisions. The default value is [5, 2], which indicates that for base 10 numbers (the default base), the method may consider dividing bin sizes by 5 and/or 2. For example, for an initial step size of 10, the method can check if bin sizes of 2 (= 10/5), 5 (= 10/2), or 1 (= 10/(5*2)) might also satisfy the given constraints.
                  
                  __Default value:__ `[5, 2]`
                  "%
                  | optional,
                extent
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number"),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2
                  ])
                  | doc m%"
                  A two-element (`[min, max]`) array indicating the range of desired bin values.
                  "%
                  | optional,
                maxbins
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 2 ])
                  | doc m%"
                  Maximum number of bins.
                  
                  __Default value:__ `6` for `row`, `column` and `shape` channels; `10` for other channels
                  "%
                  | optional,
                minstep
                  | Number
                  | doc m%"
                  A minimum allowable step size (particularly useful for integer values).
                  "%
                  | optional,
                nice
                  | Bool
                  | doc m%"
                  If true (the default), attempts to make the bin boundaries use human-friendly boundaries, such as multiples of ten.
                  "%
                  | optional,
                step
                  | Number
                  | doc m%"
                  An exact step size to use between bins.
                  
                  __Note:__ If provided, options such as maxbins will be ignored.
                  "%
                  | optional,
                steps
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number"),
                    predicates.arrays.minItems 1
                  ])
                  | doc m%"
                  An array of allowable step sizes to choose from.
                  "%
                  | optional,
              },
          BinTransform = {
                as
                  | String
                  | doc m%"
                  The output fields at which to write the start and end bin values.
                  "%,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  An object indicating bin properties, or simply `true` for using default bin parameters.
                  "%,
                field
                  | String
                  | doc m%"
                  The data field to bin.
                  "%,
              },
          BoxPlotConfig = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Default color.  Note that `fill` and `stroke` have higher precedence than `color` and will override `color`.
                  
                  __Default value:__ <span style="color: #4682b4;">&#9632;</span> `"#4682b4"`
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                filled
                  | Bool
                  | doc m%"
                  Whether the mark's color should be used as fill color instead of stroke color.
                  
                  __Default value:__ `true` for all marks except `point` and `false` for `point`.
                  
                  __Applicable for:__ `bar`, `point`, `circle`, `square`, and `area` marks.
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                size
                  | Number
                  | doc m%"
                  Size of the box and mid tick of a box plot 
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
              },
          BoxPlotConfigMixins = {
                box
                  | definitions.contract.BoxPlotConfig
                  | doc m%"
                  Box Config 
                  "%
                  | optional,
                boxMid | definitions.contract.MarkConfig | optional,
                boxWhisker | definitions.contract.MarkConfig | optional,
              },
          BrushConfig = {
                fill
                  | String
                  | doc m%"
                  The fill color of the interval mark.
                  
                  __Default value:__ `#333333`
                  "%
                  | optional,
                fillOpacity
                  | Number
                  | doc m%"
                  The fill opacity of the interval mark (a value between 0 and 1).
                  
                  __Default value:__ `0.125`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  The stroke color of the interval mark.
                  
                  __Default value:__ `#ffffff`
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke and space lengths,
                  for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) with which to begin drawing the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | Number
                  | doc m%"
                  The stroke opacity of the interval mark (a value between 0 and 1).
                  "%
                  | optional,
                strokeWidth
                  | Number
                  | doc m%"
                  The stroke width of the interval mark.
                  "%
                  | optional,
              },
          CalculateTransform = {
                as
                  | String
                  | doc m%"
                  The field for storing the computed formula value.
                  "%,
                calculate
                  | String
                  | doc m%"
                  A string containing a Vega Expression. Use the variable `datum` to refer to the current data object.
                  "%,
              },
          CompositeMarkConfigMixins = definitions.contract.BoxPlotConfigMixins,
          CompositeUnitSpec
            | doc m%"
            Unit spec that can have a composite mark.
            "%
            = definitions.contract.CompositeUnitSpecAlias,
          CompositeUnitSpecAlias = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                encoding
                  | definitions.contract.Encoding
                  | doc m%"
                  A key-value mapping between encoding channels and definition of fields.
                  "%,
                height
                  | Number
                  | doc m%"
                  The height of a visualization.
                  
                  __Default value:__
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its y-channel has a [continuous scale](scale.html#continuous), the height will be the value of [`config.view.height`](spec.html#config).
                  - For y-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the height is [determined by the range step, paddings, and the cardinality of the field mapped to y-channel](scale.html#band). Otherwise, if the `rangeStep` is `null`, the height will be the value of [`config.view.height`](spec.html#config).
                  - If no field is mapped to `y` channel, the `height` will be the value of `rangeStep`.
                  
                  __Note__: For plots with [`row` and `column` channels](encoding.html#facet), this represents the height of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
                mark
                  | definitions.contract.AnyMark
                  | doc m%"
                  A string describing the mark type (one of `"bar"`, `"circle"`, `"square"`, `"tick"`, `"line"`,
                  `"area"`, `"point"`, `"rule"`, and `"text"`) or a [mark definition object](mark.html#mark-def).
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                selection
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.SelectionDef
                  ])
                  | doc m%"
                  A key-value mapping between selection names and definitions.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width of a visualization.
                  
                  __Default value:__ This will be determined by the following rules:
                  
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its x-channel has a [continuous scale](scale.html#continuous), the width will be the value of [`config.view.width`](spec.html#config).
                  - For x-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the width is [determined by the range step, paddings, and the cardinality of the field mapped to x-channel](scale.html#band).   Otherwise, if the `rangeStep` is `null`, the width will be the value of [`config.view.width`](spec.html#config).
                  - If no field is mapped to `x` channel, the `width` will be the value of [`config.scale.textXRangeStep`](size.html#default-width-and-height) for `text` mark and the value of `rangeStep` for other marks.
                  
                  __Note:__ For plots with [`row` and `column` channels](encoding.html#facet), this represents the width of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
              },
          "Conditional<MarkPropFieldDef>" = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                legend
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Legend, predicates.isType 'Null ])
                  | doc m%"
                  An object defining properties of the legend.
                  If `null`, the legend for the encoding channel will be removed.
                  
                  __Default value:__ If undefined, default [legend properties](legend.html) are applied.
                  "%
                  | optional,
                scale
                  | definitions.contract.Scale
                  | doc m%"
                  An object defining properties of the channel's scale, which is the function that transforms values in the data domain (numbers, dates, strings, etc) to visual values (pixels, colors, sizes) of the encoding channels.
                  
                  __Default value:__ If undefined, default [scale properties](scale.html) are applied.
                  "%
                  | optional,
                selection
                  | definitions.contract.SelectionOperand
                  | doc m%"
                  A [selection name](selection.html), or a series of [composed selections](selection.html#compose).
                  "%,
                sort
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.SortOrder,
                    definitions.predicate.SortField,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sort order for the encoded field.
                  Supported `sort` values include `"ascending"`, `"descending"` and `null` (no sorting).
                  For fields with discrete domains, `sort` can also be a [sort field definition object](sort.html#sort-field).
                  
                  __Default value:__ `"ascending"`
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          "Conditional<TextFieldDef>" = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  The [formatting pattern](format.html) for a text field. If not defined, this will be determined automatically.
                  "%
                  | optional,
                selection
                  | definitions.contract.SelectionOperand
                  | doc m%"
                  A [selection name](selection.html), or a series of [composed selections](selection.html#compose).
                  "%,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          "Conditional<ValueDef>" = {
                selection
                  | definitions.contract.SelectionOperand
                  | doc m%"
                  A [selection name](selection.html), or a series of [composed selections](selection.html#compose).
                  "%,
                value
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Number",
                    predicates.isType '"String",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  A constant value in visual domain (e.g., `"red"` / "#0099ff" for color, values between `0` to `1` for opacity).
                  "%,
              },
          Config = {
                area
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Area-Specific Config 
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                axis
                  | definitions.contract.AxisConfig
                  | doc m%"
                  Axis configuration, which determines default properties for all `x` and `y` [axes](axis.html). For a full list of axis configuration options, please see the [corresponding section of the axis documentation](axis.html#config).
                  "%
                  | optional,
                axisBand
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for axes with "band" scales.
                  "%
                  | optional,
                axisBottom
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for x-axis along the bottom edge of the chart.
                  "%
                  | optional,
                axisLeft
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for y-axis along the left edge of the chart.
                  "%
                  | optional,
                axisRight
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for y-axis along the right edge of the chart.
                  "%
                  | optional,
                axisTop
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Specific axis config for x-axis along the top edge of the chart.
                  "%
                  | optional,
                axisX
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  X-axis specific config.
                  "%
                  | optional,
                axisY
                  | definitions.contract.VgAxisConfig
                  | doc m%"
                  Y-axis specific config.
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                bar
                  | definitions.contract.BarConfig
                  | doc m%"
                  Bar-Specific Config 
                  "%
                  | optional,
                circle
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Circle-Specific Config 
                  "%
                  | optional,
                countTitle
                  | String
                  | doc m%"
                  Default axis and legend title for count fields.
                  
                  __Default value:__ `'Number of Records'`.
                  "%
                  | optional,
                fieldTitle
                  | std.enum.TagOrString
                  | [| 'plain, 'functional, 'verbal |]
                  | doc m%"
                  Defines how Vega-Lite generates title for fields.  There are three possible styles:
                  - `"verbal"` (Default) - displays function in a verbal style (e.g., "Sum of field", "Year-month of date", "field (binned)").
                  - `"function"` - displays function using parentheses and capitalized texts (e.g., "SUM(field)", "YEARMONTH(date)", "BIN(field)").
                  - `"plain"` - displays only the field name without functions (e.g., "field", "date", "field").
                  "%
                  | optional,
                invalidValues
                  | std.enum.TagOrString
                  | [| 'filter |]
                  | doc m%"
                  Defines how Vega-Lite should handle invalid values (`null` and `NaN`).
                  - If set to `"filter"` (default), all data items with null values are filtered.
                  - If `null`, all data items are included. In this case, invalid values will be interpreted as zeroes.
                  "%
                  | optional,
                legend
                  | definitions.contract.LegendConfig
                  | doc m%"
                  Legend configuration, which determines default properties for all [legends](legend.html). For a full list of legend configuration options, please see the [corresponding section of in the legend documentation](legend.html#config).
                  "%
                  | optional,
                line
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Line-Specific Config 
                  "%
                  | optional,
                mark
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Mark Config 
                  "%
                  | optional,
                numberFormat
                  | String
                  | doc m%"
                  D3 Number format for axis labels and text tables. For example "s" for SI units. Use [D3's number format pattern](https://github.com/d3/d3-format#locale_format).
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                point
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Point-Specific Config 
                  "%
                  | optional,
                range
                  | definitions.contract.RangeConfig
                  | doc m%"
                  An object hash that defines default range arrays or schemes for using with scales.
                  For a full list of scale range configuration options, please see the [corresponding section of the scale documentation](scale.html#config).
                  "%
                  | optional,
                rect
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Rect-Specific Config 
                  "%
                  | optional,
                rule
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Rule-Specific Config 
                  "%
                  | optional,
                scale
                  | definitions.contract.ScaleConfig
                  | doc m%"
                  Scale configuration determines default properties for all [scales](scale.html). For a full list of scale configuration options, please see the [corresponding section of the scale documentation](scale.html#config).
                  "%
                  | optional,
                selection
                  | definitions.contract.SelectionConfig
                  | doc m%"
                  An object hash for defining default properties for each type of selections. 
                  "%
                  | optional,
                square
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Square-Specific Config 
                  "%
                  | optional,
                stack
                  | definitions.contract.StackOffset
                  | doc m%"
                  Default stack offset for stackable mark. 
                  "%
                  | optional,
                style
                  | definitions.contract.StyleConfigIndex
                  | doc m%"
                  An object hash that defines key-value mappings to determine default properties for marks with a given [style](mark.html#mark-def).  The keys represent styles names; the value are valid [mark configuration objects](mark.html#config).  
                  "%
                  | optional,
                text
                  | definitions.contract.TextConfig
                  | doc m%"
                  Text-Specific Config 
                  "%
                  | optional,
                tick
                  | definitions.contract.TickConfig
                  | doc m%"
                  Tick-Specific Config 
                  "%
                  | optional,
                timeFormat
                  | String
                  | doc m%"
                  Default datetime format for axis and legend labels. The format can be set directly on each axis and legend. Use [D3's time format pattern](https://github.com/d3/d3-time-format#locale_format).
                  
                  __Default value:__ `'%b %d, %Y'`.
                  "%
                  | optional,
                title
                  | definitions.contract.VgTitleConfig
                  | doc m%"
                  Title configuration, which determines default properties for all [titles](title.html). For a full list of title configuration options, please see the [corresponding section of the title documentation](title.html#config).
                  "%
                  | optional,
                view
                  | definitions.contract.ViewConfig
                  | doc m%"
                  Default properties for [single view plots](spec.html#single). 
                  "%
                  | optional,
              },
          CsvDataFormat = {
                parse
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [ predicates.isType '"String", predicates.enum [ "auto" ] ],
                    predicates.isType 'Record
                  ])
                  | doc m%%"
                  If set to auto (the default), perform automatic type inference to determine the desired data types.
                  Alternatively, a parsing directive object can be provided for explicit data types. Each property of the object corresponds to a field name, and the value to the desired data type (one of `"number"`, `"boolean"` or `"date"`).
                  For example, `"parse": {"modified_on": "date"}` parses the `modified_on` field in each input record a Date value.
                  
                  For `"date"`, we parse data based using Javascript's [`Date.parse()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse).
                  For Specific date formats can be provided (e.g., `{foo: 'date:"%m%d%Y"'}`), using the [d3-time-format syntax](https://github.com/d3/d3-time-format#locale_format). UTC date format parsing is supported similarly (e.g., `{foo: 'utc:"%m%d%Y"'}`). See more about [UTC time](timeunit.html#utc)
                  "%%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'tsv, 'csv |]
                  | doc m%"
                  Type of input data: `"json"`, `"csv"`, `"tsv"`.
                  The default format type is determined by the extension of the file URL.
                  If no extension is detected, `"json"` will be used by default.
                  "%
                  | optional,
              },
          Data = predicates.contract_from_predicate definitions.predicate.Data,
          DataFormat = predicates.contract_from_predicate
              definitions.predicate.DataFormat,
          DataFormatBase = {
                parse
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [ predicates.isType '"String", predicates.enum [ "auto" ] ],
                    predicates.isType 'Record
                  ])
                  | doc m%%"
                  If set to auto (the default), perform automatic type inference to determine the desired data types.
                  Alternatively, a parsing directive object can be provided for explicit data types. Each property of the object corresponds to a field name, and the value to the desired data type (one of `"number"`, `"boolean"` or `"date"`).
                  For example, `"parse": {"modified_on": "date"}` parses the `modified_on` field in each input record a Date value.
                  
                  For `"date"`, we parse data based using Javascript's [`Date.parse()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse).
                  For Specific date formats can be provided (e.g., `{foo: 'date:"%m%d%Y"'}`), using the [d3-time-format syntax](https://github.com/d3/d3-time-format#locale_format). UTC date format parsing is supported similarly (e.g., `{foo: 'utc:"%m%d%Y"'}`). See more about [UTC time](timeunit.html#utc)
                  "%%
                  | optional,
                type
                  | definitions.contract.DataFormatType
                  | doc m%"
                  Type of input data: `"json"`, `"csv"`, `"tsv"`.
                  The default format type is determined by the extension of the file URL.
                  If no extension is detected, `"json"` will be used by default.
                  "%
                  | optional,
              },
          DataFormatType = std.contract.Sequence
              [ std.enum.TagOrString, [| 'topojson, 'tsv, 'csv, 'json |] ],
          DateTime
            | doc m%"
            Object for defining datetime in Vega-Lite Filter.
            If both month and quarter are provided, month has higher precedence.
            `day` cannot be combined with other date.
            We accept string for month and day names.
            "%
            = {
                date
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 31,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Integer value representing the date from 1-31.
                  "%
                  | optional,
                day
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Day, predicates.isType '"String" ])
                  | doc m%"
                  Value representing the day of a week.  This can be one of: (1) integer value -- `1` represents Monday; (2) case-insensitive day name (e.g., `"Monday"`);  (3) case-insensitive, 3-character short day name (e.g., `"Mon"`).   <br/> **Warning:** A DateTime definition object with `day`** should not be combined with `year`, `quarter`, `month`, or `date`.
                  "%
                  | optional,
                hours
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 23,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Integer value representing the hour of a day from 0-23.
                  "%
                  | optional,
                milliseconds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 999,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Integer value representing the millisecond segment of time.
                  "%
                  | optional,
                minutes
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 59,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Integer value representing the minute segment of time from 0-59.
                  "%
                  | optional,
                month
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Month, predicates.isType '"String" ])
                  | doc m%"
                  One of: (1) integer value representing the month from `1`-`12`. `1` represents January;  (2) case-insensitive month name (e.g., `"January"`);  (3) case-insensitive, 3-character short month name (e.g., `"Jan"`). 
                  "%
                  | optional,
                quarter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 4,
                    predicates.numbers.minimum 1
                  ])
                  | doc m%"
                  Integer value representing the quarter of the year (from 1-4).
                  "%
                  | optional,
                seconds
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 59,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Integer value representing the second segment (0-59) of a time value
                  "%
                  | optional,
                utc
                  | Bool
                  | doc m%"
                  A boolean flag indicating if date time is in utc time. If false, the date time is in local time
                  "%
                  | optional,
                year
                  | Number
                  | doc m%"
                  Integer value representing the year.
                  "%
                  | optional,
              },
          Day = predicates.contract_from_predicate definitions.predicate.Day,
          Encoding = {
                color
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  Color of the marks – either fill or stroke color based on mark type.
                  By default, `color` represents fill color for `"area"`, `"bar"`, `"tick"`,
                  `"text"`, `"circle"`, and `"square"` / stroke color for `"line"` and `"point"`.
                  
                  __Default value:__ If undefined, the default color depends on [mark config](config.html#mark)'s `color` property.
                  
                  _Note:_ See the scale documentation for more information about customizing [color scheme](scale.html#scheme).
                  "%
                  | optional,
                detail
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDef,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.FieldDef
                    ]
                  ])
                  | doc m%"
                  Additional levels of detail for grouping data in aggregate views and
                  in line and area marks without mapping data to a specific visual channel.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  Opacity of the marks – either can be a value or a range.
                  
                  __Default value:__ If undefined, the default opacity depends on [mark config](config.html#mark)'s `opacity` property.
                  "%
                  | optional,
                order
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.OrderFieldDef,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.OrderFieldDef
                    ]
                  ])
                  | doc m%"
                  Stack order for stacked marks or order of data points in line marks for connected scatter plots.
                  
                  __Note__: In aggregate plots, `order` field should be `aggregate`d to avoid creating additional aggregation grouping.
                  "%
                  | optional,
                shape
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  The symbol's shape (only for `point` marks). The supported values are
                  `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`,
                  or `"triangle-down"`, or else a custom SVG path string.
                  __Default value:__ If undefined, the default shape depends on [mark config](config.html#point-config)'s `shape` property.
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  Size of the mark.
                  - For `"point"`, `"square"` and `"circle"`, – the symbol size, or pixel area of the mark.
                  - For `"bar"` and `"tick"` – the bar and tick's size.
                  - For `"text"` – the text's font size.
                  - Size is currently unsupported for `"line"`, `"area"`, and `"rect"`.
                  "%
                  | optional,
                text
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TextFieldDefWithCondition,
                    definitions.predicate.TextValueDefWithCondition
                  ])
                  | doc m%"
                  Text of the `text` mark.
                  "%
                  | optional,
                tooltip
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TextFieldDefWithCondition,
                    definitions.predicate.TextValueDefWithCondition
                  ])
                  | doc m%"
                  The tooltip text to show upon mouse hover.
                  "%
                  | optional,
                x
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PositionFieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  X coordinates of the marks, or width of horizontal `"bar"` and `"area"`.
                  "%
                  | optional,
                x2
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  X2 coordinates for ranged  `"area"`, `"bar"`, `"rect"`, and  `"rule"`.
                  "%
                  | optional,
                y
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PositionFieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  Y coordinates of the marks, or height of vertical `"bar"` and `"area"`.
                  "%
                  | optional,
                y2
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  Y2 coordinates for ranged  `"area"`, `"bar"`, `"rect"`, and  `"rule"`.
                  "%
                  | optional,
              },
          EncodingWithFacet = {
                color
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  Color of the marks – either fill or stroke color based on mark type.
                  By default, `color` represents fill color for `"area"`, `"bar"`, `"tick"`,
                  `"text"`, `"circle"`, and `"square"` / stroke color for `"line"` and `"point"`.
                  
                  __Default value:__ If undefined, the default color depends on [mark config](config.html#mark)'s `color` property.
                  
                  _Note:_ See the scale documentation for more information about customizing [color scheme](scale.html#scheme).
                  "%
                  | optional,
                column
                  | definitions.contract.FacetFieldDef
                  | doc m%"
                  Horizontal facets for trellis plots.
                  "%
                  | optional,
                detail
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDef,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.FieldDef
                    ]
                  ])
                  | doc m%"
                  Additional levels of detail for grouping data in aggregate views and
                  in line and area marks without mapping data to a specific visual channel.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  Opacity of the marks – either can be a value or a range.
                  
                  __Default value:__ If undefined, the default opacity depends on [mark config](config.html#mark)'s `opacity` property.
                  "%
                  | optional,
                order
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.OrderFieldDef,
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate.OrderFieldDef
                    ]
                  ])
                  | doc m%"
                  Stack order for stacked marks or order of data points in line marks for connected scatter plots.
                  
                  __Note__: In aggregate plots, `order` field should be `aggregate`d to avoid creating additional aggregation grouping.
                  "%
                  | optional,
                row
                  | definitions.contract.FacetFieldDef
                  | doc m%"
                  Vertical facets for trellis plots.
                  "%
                  | optional,
                shape
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  The symbol's shape (only for `point` marks). The supported values are
                  `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`,
                  or `"triangle-down"`, or else a custom SVG path string.
                  __Default value:__ If undefined, the default shape depends on [mark config](config.html#point-config)'s `shape` property.
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.MarkPropFieldDefWithCondition,
                    definitions.predicate.MarkPropValueDefWithCondition
                  ])
                  | doc m%"
                  Size of the mark.
                  - For `"point"`, `"square"` and `"circle"`, – the symbol size, or pixel area of the mark.
                  - For `"bar"` and `"tick"` – the bar and tick's size.
                  - For `"text"` – the text's font size.
                  - Size is currently unsupported for `"line"`, `"area"`, and `"rect"`.
                  "%
                  | optional,
                text
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TextFieldDefWithCondition,
                    definitions.predicate.TextValueDefWithCondition
                  ])
                  | doc m%"
                  Text of the `text` mark.
                  "%
                  | optional,
                tooltip
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.TextFieldDefWithCondition,
                    definitions.predicate.TextValueDefWithCondition
                  ])
                  | doc m%"
                  The tooltip text to show upon mouse hover.
                  "%
                  | optional,
                x
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PositionFieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  X coordinates of the marks, or width of horizontal `"bar"` and `"area"`.
                  "%
                  | optional,
                x2
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  X2 coordinates for ranged  `"area"`, `"bar"`, `"rect"`, and  `"rule"`.
                  "%
                  | optional,
                y
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.PositionFieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  Y coordinates of the marks, or height of vertical `"bar"` and `"area"`.
                  "%
                  | optional,
                y2
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FieldDef,
                    definitions.predicate.ValueDef
                  ])
                  | doc m%"
                  Y2 coordinates for ranged  `"area"`, `"bar"`, `"rect"`, and  `"rule"`.
                  "%
                  | optional,
              },
          EqualFilter = {
                equal
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.isType '"Number",
                    predicates.isType '"Bool",
                    definitions.predicate.DateTime
                  ])
                  | doc m%"
                  The value that the field should be equal to.
                  "%,
                field
                  | String
                  | doc m%"
                  Field to be filtered.
                  "%,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit for the field to be filtered.
                  "%
                  | optional,
              },
          FacetFieldDef = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                header
                  | definitions.contract.Header
                  | doc m%"
                  An object defining properties of a facet's header.
                  "%
                  | optional,
                sort
                  | definitions.contract.SortOrder
                  | doc m%"
                  Sort order for a facet field.
                  This can be `"ascending"`, `"descending"`.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          FacetMapping = {
                column
                  | definitions.contract.FacetFieldDef
                  | doc m%"
                  Horizontal facets for trellis plots.
                  "%
                  | optional,
                row
                  | definitions.contract.FacetFieldDef
                  | doc m%"
                  Vertical facets for trellis plots.
                  "%
                  | optional,
              },
          FacetSpec = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                facet
                  | definitions.contract.FacetMapping
                  | doc m%"
                  An object that describes mappings between `row` and `column` channels and their field definitions.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for facets.
                  "%
                  | optional,
                spec
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.LayerSpec,
                    definitions.predicate.CompositeUnitSpec
                  ])
                  | doc m%"
                  A specification of the view that gets faceted.
                  "%,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          FacetedCompositeUnitSpecAlias = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                encoding
                  | definitions.contract.EncodingWithFacet
                  | doc m%"
                  A key-value mapping between encoding channels and definition of fields.
                  "%,
                height
                  | Number
                  | doc m%"
                  The height of a visualization.
                  
                  __Default value:__
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its y-channel has a [continuous scale](scale.html#continuous), the height will be the value of [`config.view.height`](spec.html#config).
                  - For y-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the height is [determined by the range step, paddings, and the cardinality of the field mapped to y-channel](scale.html#band). Otherwise, if the `rangeStep` is `null`, the height will be the value of [`config.view.height`](spec.html#config).
                  - If no field is mapped to `y` channel, the `height` will be the value of `rangeStep`.
                  
                  __Note__: For plots with [`row` and `column` channels](encoding.html#facet), this represents the height of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
                mark
                  | definitions.contract.AnyMark
                  | doc m%"
                  A string describing the mark type (one of `"bar"`, `"circle"`, `"square"`, `"tick"`, `"line"`,
                  `"area"`, `"point"`, `"rule"`, and `"text"`) or a [mark definition object](mark.html#mark-def).
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                selection
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.SelectionDef
                  ])
                  | doc m%"
                  A key-value mapping between selection names and definitions.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width of a visualization.
                  
                  __Default value:__ This will be determined by the following rules:
                  
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its x-channel has a [continuous scale](scale.html#continuous), the width will be the value of [`config.view.width`](spec.html#config).
                  - For x-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the width is [determined by the range step, paddings, and the cardinality of the field mapped to x-channel](scale.html#band).   Otherwise, if the `rangeStep` is `null`, the width will be the value of [`config.view.width`](spec.html#config).
                  - If no field is mapped to `x` channel, the `width` will be the value of [`config.scale.textXRangeStep`](size.html#default-width-and-height) for `text` mark and the value of `rangeStep` for other marks.
                  
                  __Note:__ For plots with [`row` and `column` channels](encoding.html#facet), this represents the width of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
              },
          FacetedUnitSpec
            | doc m%"
            Unit spec that can have a composite mark and row or column channels.
            "%
            = definitions.contract.FacetedCompositeUnitSpecAlias,
          FieldDef
            | doc m%"
            Definition object for a data field, its type and transformation of an encoding channel.
            "%
            = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          FieldDefBase = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
              },
          Filter = predicates.contract_from_predicate
              definitions.predicate.Filter,
          FilterOperand = predicates.contract_from_predicate
              definitions.predicate.FilterOperand,
          FilterTransform = {
                filter
                  | definitions.contract.FilterOperand
                  | doc m%"
                  The `filter` property must be either (1) a filter object for [equal-filters](filter.html#equalfilter),
                  [range-filters](filter.html#rangefilter), [one-of filters](filter.html#oneoffilter), or [selection filters](filter.html#selectionfilter);
                  (2) a [Vega Expression](filter.html#expression) string,
                  where `datum` can be used to refer to the current data object; or (3) an array of filters (either objects or expression strings) that must all be true for a datum to pass the filter and be included.
                  "%,
              },
          FontStyle = std.contract.Sequence
              [ std.enum.TagOrString, [| 'italic, 'normal |] ],
          FontWeight = std.contract.Sequence
              [ std.enum.TagOrString, [| 'bold, 'normal |] ],
          FontWeightNumber = predicates.contract_from_predicate
              definitions.predicate.FontWeightNumber,
          Guide = {
                format
                  | String
                  | doc m%"
                  The formatting pattern for labels. This is D3's [number format pattern](https://github.com/d3/d3-format#locale_format) for quantitative fields and D3's [time format pattern](https://github.com/d3/d3-time-format#locale_format) for time field.
                  
                  See the [format documentation](format.html) for more information.
                  
                  __Default value:__  derived from [numberFormat](config.html#format) config for quantitative fields and from [timeFormat](config.html#format) config for temporal fields.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A title for the field. If `null`, the title will be removed.
                  
                  __Default value:__  derived from the field's name and transformation function (`aggregate`, `bin` and `timeUnit`).  If the field has an aggregate function, the function is displayed as a part of the title (e.g., `"Sum of Profit"`). If the field is binned or has a time unit applied, the applied function will be denoted in parentheses (e.g., `"Profit (binned)"`, `"Transaction Date (year-month)"`).  Otherwise, the title is simply the field name.
                  
                  __Note__: You can customize the default field title format by providing the [`fieldTitle` property in the [config](config.html) or [`fieldTitle` function via the `compile` function's options](compile.html#field-title).
                  "%
                  | optional,
              },
          HConcatSpec = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                hconcat
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Spec
                  ])
                  | doc m%"
                  A list of views that should be concatenated and put into a row.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for horizontally concatenated charts.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          Header
            | doc m%"
            Headers of row / column channels for faceted plots.
            "%
            = {
                format
                  | String
                  | doc m%"
                  The formatting pattern for labels. This is D3's [number format pattern](https://github.com/d3/d3-format#locale_format) for quantitative fields and D3's [time format pattern](https://github.com/d3/d3-time-format#locale_format) for time field.
                  
                  __Default value:__  derived from [numberFormat](config.html#format) config for quantitative fields and from [timeFormat](config.html#format) config for temporal fields.
                  "%
                  | optional,
                title
                  | String
                  | doc m%"
                  A title for the axis. Shows field name and its function by default.
                  
                  __Default value:__  derived from the field's name and transformation function applied e.g, "field_name", "SUM(field_name)", "BIN(field_name)", "YEAR(field_name)".
                  "%
                  | optional,
              },
          HorizontalAlign = std.contract.Sequence
              [ std.enum.TagOrString, [| 'center, 'right, 'left |] ],
          InlineData = {
                format
                  | definitions.contract.DataFormat
                  | doc m%"
                  An object that specifies the format for parsing the data values.
                  "%
                  | optional,
                values
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Number")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Bool")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType 'Record)
                    ],
                    predicates.isType '"String",
                    predicates.isType 'Record
                  ])
                  | doc m%"
                  The full data set, included inline. This can be an array of objects or primitive values or a string.
                  Arrays of primitive values are ingested as objects with a `data` property. Strings are parsed according to the specified format type.
                  "%,
              },
          Interpolate = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'monotone,
                  'bundle,
                  'cardinal-closed,
                  'cardinal-open,
                  'cardinal,
                  'basis-closed,
                  'basis-open,
                  'basis,
                  'step-after,
                  'step-before,
                  'step,
                  'linear-closed,
                  'linear
                |]
              ],
          InterpolateParams = {
                gamma | Number | optional,
                type
                  | std.enum.TagOrString
                  | [| 'cubehelix-long, 'cubehelix, 'rgb |],
              },
          IntervalSelection = {
                bind
                  | std.enum.TagOrString
                  | [| 'scales |]
                  | doc m%"
                  Establishes a two-way binding between the interval selection and the scales
                  used within the same view. This allows a user to interactively pan and
                  zoom the view.
                  "%
                  | optional,
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                mark
                  | definitions.contract.BrushConfig
                  | doc m%"
                  An interval selection also adds a rectangle mark to depict the
                  extents of the interval. The `mark` property can be used to customize the
                  appearance of the mark.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
                translate
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  When truthy, allows a user to interactively move an interval selection
                  back-and-forth. Can be `true`, `false` (to disable panning), or a
                  [Vega event stream definition](https://vega.github.io/vega/docs/event-streams/)
                  which must include a start and end event to trigger continuous panning.
                  
                  __Default value:__ `true`, which corresponds to
                  `[mousedown, window:mouseup] > window:mousemove!` which corresponds to
                  clicks and dragging within an interval selection to reposition it.
                  "%
                  | optional,
                type | std.enum.TagOrString | [| 'interval |],
                zoom
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  When truthy, allows a user to interactively resize an interval selection.
                  Can be `true`, `false` (to disable zooming), or a [Vega event stream
                  definition](https://vega.github.io/vega/docs/event-streams/). Currently,
                  only `wheel` events are supported.
                  
                  
                  __Default value:__ `true`, which corresponds to `wheel!`.
                  "%
                  | optional,
              },
          IntervalSelectionConfig = {
                bind
                  | std.enum.TagOrString
                  | [| 'scales |]
                  | doc m%"
                  Establishes a two-way binding between the interval selection and the scales
                  used within the same view. This allows a user to interactively pan and
                  zoom the view.
                  "%
                  | optional,
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                mark
                  | definitions.contract.BrushConfig
                  | doc m%"
                  An interval selection also adds a rectangle mark to depict the
                  extents of the interval. The `mark` property can be used to customize the
                  appearance of the mark.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
                translate
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  When truthy, allows a user to interactively move an interval selection
                  back-and-forth. Can be `true`, `false` (to disable panning), or a
                  [Vega event stream definition](https://vega.github.io/vega/docs/event-streams/)
                  which must include a start and end event to trigger continuous panning.
                  
                  __Default value:__ `true`, which corresponds to
                  `[mousedown, window:mouseup] > window:mousemove!` which corresponds to
                  clicks and dragging within an interval selection to reposition it.
                  "%
                  | optional,
                zoom
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  When truthy, allows a user to interactively resize an interval selection.
                  Can be `true`, `false` (to disable zooming), or a [Vega event stream
                  definition](https://vega.github.io/vega/docs/event-streams/). Currently,
                  only `wheel` events are supported.
                  
                  
                  __Default value:__ `true`, which corresponds to `wheel!`.
                  "%
                  | optional,
              },
          JsonDataFormat = {
                parse
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [ predicates.isType '"String", predicates.enum [ "auto" ] ],
                    predicates.isType 'Record
                  ])
                  | doc m%%"
                  If set to auto (the default), perform automatic type inference to determine the desired data types.
                  Alternatively, a parsing directive object can be provided for explicit data types. Each property of the object corresponds to a field name, and the value to the desired data type (one of `"number"`, `"boolean"` or `"date"`).
                  For example, `"parse": {"modified_on": "date"}` parses the `modified_on` field in each input record a Date value.
                  
                  For `"date"`, we parse data based using Javascript's [`Date.parse()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse).
                  For Specific date formats can be provided (e.g., `{foo: 'date:"%m%d%Y"'}`), using the [d3-time-format syntax](https://github.com/d3/d3-time-format#locale_format). UTC date format parsing is supported similarly (e.g., `{foo: 'utc:"%m%d%Y"'}`). See more about [UTC time](timeunit.html#utc)
                  "%%
                  | optional,
                property
                  | String
                  | doc m%"
                  The JSON property containing the desired data.
                  This parameter can be used when the loaded JSON file may have surrounding structure or meta-data.
                  For example `"property": "values.features"` is equivalent to retrieving `json.values.features`
                  from the loaded JSON object.
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'json |]
                  | doc m%"
                  Type of input data: `"json"`, `"csv"`, `"tsv"`.
                  The default format type is determined by the extension of the file URL.
                  If no extension is detected, `"json"` will be used by default.
                  "%
                  | optional,
              },
          LayerSpec = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                height
                  | Number
                  | doc m%"
                  The height of a visualization.
                  
                  __Default value:__
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its y-channel has a [continuous scale](scale.html#continuous), the height will be the value of [`config.view.height`](spec.html#config).
                  - For y-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the height is [determined by the range step, paddings, and the cardinality of the field mapped to y-channel](scale.html#band). Otherwise, if the `rangeStep` is `null`, the height will be the value of [`config.view.height`](spec.html#config).
                  - If no field is mapped to `y` channel, the `height` will be the value of `rangeStep`.
                  
                  __Note__: For plots with [`row` and `column` channels](encoding.html#facet), this represents the height of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
                layer
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.LayerSpec,
                      definitions.predicate.CompositeUnitSpec
                    ])
                  ])
                  | doc m%"
                  Layer or single view specifications to be layered.
                  
                  __Note__: Specifications inside `layer` cannot use `row` and `column` channels as layering facet specifications is not allowed.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for layers.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width of a visualization.
                  
                  __Default value:__ This will be determined by the following rules:
                  
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its x-channel has a [continuous scale](scale.html#continuous), the width will be the value of [`config.view.width`](spec.html#config).
                  - For x-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the width is [determined by the range step, paddings, and the cardinality of the field mapped to x-channel](scale.html#band).   Otherwise, if the `rangeStep` is `null`, the width will be the value of [`config.view.width`](spec.html#config).
                  - If no field is mapped to `x` channel, the `width` will be the value of [`config.scale.textXRangeStep`](size.html#default-width-and-height) for `text` mark and the value of `rangeStep` for other marks.
                  
                  __Note:__ For plots with [`row` and `column` channels](encoding.html#facet), this represents the width of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
              },
          LayoutSizeMixins = {
                height
                  | Number
                  | doc m%"
                  The height of a visualization.
                  
                  __Default value:__
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its y-channel has a [continuous scale](scale.html#continuous), the height will be the value of [`config.view.height`](spec.html#config).
                  - For y-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the height is [determined by the range step, paddings, and the cardinality of the field mapped to y-channel](scale.html#band). Otherwise, if the `rangeStep` is `null`, the height will be the value of [`config.view.height`](spec.html#config).
                  - If no field is mapped to `y` channel, the `height` will be the value of `rangeStep`.
                  
                  __Note__: For plots with [`row` and `column` channels](encoding.html#facet), this represents the height of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width of a visualization.
                  
                  __Default value:__ This will be determined by the following rules:
                  
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its x-channel has a [continuous scale](scale.html#continuous), the width will be the value of [`config.view.width`](spec.html#config).
                  - For x-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the width is [determined by the range step, paddings, and the cardinality of the field mapped to x-channel](scale.html#band).   Otherwise, if the `rangeStep` is `null`, the width will be the value of [`config.view.width`](spec.html#config).
                  - If no field is mapped to `x` channel, the `width` will be the value of [`config.scale.textXRangeStep`](size.html#default-width-and-height) for `text` mark and the value of `rangeStep` for other marks.
                  
                  __Note:__ For plots with [`row` and `column` channels](encoding.html#facet), this represents the width of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
              },
          Legend
            | doc m%"
            Properties of a legend or boolean flag for determining whether to show it.
            "%
            = {
                entryPadding
                  | Number
                  | doc m%"
                  Padding (in pixels) between legend entries in a symbol legend.
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  The formatting pattern for labels. This is D3's [number format pattern](https://github.com/d3/d3-format#locale_format) for quantitative fields and D3's [time format pattern](https://github.com/d3/d3-time-format#locale_format) for time field.
                  
                  See the [format documentation](format.html) for more information.
                  
                  __Default value:__  derived from [numberFormat](config.html#format) config for quantitative fields and from [timeFormat](config.html#format) config for temporal fields.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The offset, in pixels, by which to displace the legend from the edge of the enclosing group or data rectangle.
                  
                  __Default value:__  `0`
                  "%
                  | optional,
                orient
                  | definitions.contract.LegendOrient
                  | doc m%"
                  The orientation of the legend, which determines how the legend is positioned within the scene. One of "left", "right", "top-left", "top-right", "bottom-left", "bottom-right", "none".
                  
                  __Default value:__ `"right"`
                  "%
                  | optional,
                padding
                  | Number
                  | doc m%"
                  The padding, in pixels, between the legend and axis.
                  "%
                  | optional,
                tickCount
                  | Number
                  | doc m%"
                  The desired number of tick values for quantitative legends.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType 'Null ])
                  | doc m%"
                  A title for the field. If `null`, the title will be removed.
                  
                  __Default value:__  derived from the field's name and transformation function (`aggregate`, `bin` and `timeUnit`).  If the field has an aggregate function, the function is displayed as a part of the title (e.g., `"Sum of Profit"`). If the field is binned or has a time unit applied, the applied function will be denoted in parentheses (e.g., `"Profit (binned)"`, `"Transaction Date (year-month)"`).  Otherwise, the title is simply the field name.
                  
                  __Note__: You can customize the default field title format by providing the [`fieldTitle` property in the [config](config.html) or [`fieldTitle` function via the `compile` function's options](compile.html#field-title).
                  "%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'gradient, 'symbol |]
                  | doc m%"
                  The type of the legend. Use `"symbol"` to create a discrete legend and `"gradient"` for a continuous color gradient.
                  
                  __Default value:__ `"gradient"` for non-binned quantitative fields and temporal fields; `"symbol"` otherwise.
                  "%
                  | optional,
                values
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Number")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.DateTime
                    ]
                  ])
                  | doc m%"
                  Explicitly set the visible legend values.
                  "%
                  | optional,
                zindex
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  A non-positive integer indicating z-index of the legend.
                  If zindex is 0, legend should be drawn behind all chart elements.
                  To put them in front, use zindex = 1.
                  "%
                  | optional,
              },
          LegendConfig = {
                cornerRadius
                  | Number
                  | doc m%"
                  Corner radius for the full legend.
                  "%
                  | optional,
                entryPadding
                  | Number
                  | doc m%"
                  Padding (in pixels) between legend entries in a symbol legend.
                  "%
                  | optional,
                fillColor
                  | String
                  | doc m%"
                  Background fill color for the full legend.
                  "%
                  | optional,
                gradientHeight
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The height of the gradient, in pixels.
                  "%
                  | optional,
                gradientLabelBaseline
                  | String
                  | doc m%"
                  Text baseline for color ramp gradient labels.
                  "%
                  | optional,
                gradientLabelLimit
                  | Number
                  | doc m%"
                  The maximum allowed length in pixels of color ramp gradient labels.
                  "%
                  | optional,
                gradientLabelOffset
                  | Number
                  | doc m%"
                  Vertical offset in pixels for color ramp gradient labels.
                  "%
                  | optional,
                gradientStrokeColor
                  | String
                  | doc m%"
                  The color of the gradient stroke, can be in hex color code or regular color name.
                  "%
                  | optional,
                gradientStrokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the gradient stroke, in pixels.
                  "%
                  | optional,
                gradientWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the gradient, in pixels.
                  "%
                  | optional,
                labelAlign
                  | String
                  | doc m%"
                  The alignment of the legend label, can be left, middle or right.
                  "%
                  | optional,
                labelBaseline
                  | String
                  | doc m%"
                  The position of the baseline of legend label, can be top, middle or bottom.
                  "%
                  | optional,
                labelColor
                  | String
                  | doc m%"
                  The color of the legend label, can be in hex color code or regular color name.
                  "%
                  | optional,
                labelFont
                  | String
                  | doc m%"
                  The font of the legend label.
                  "%
                  | optional,
                labelFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size of legend label.
                  
                  __Default value:__ `10`.
                  "%
                  | optional,
                labelLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis tick labels.
                  "%
                  | optional,
                labelOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The offset of the legend label.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The offset, in pixels, by which to displace the legend from the edge of the enclosing group or data rectangle.
                  
                  __Default value:__  `0`
                  "%
                  | optional,
                orient
                  | definitions.contract.LegendOrient
                  | doc m%"
                  The orientation of the legend, which determines how the legend is positioned within the scene. One of "left", "right", "top-left", "top-right", "bottom-left", "bottom-right", "none".
                  
                  __Default value:__ `"right"`
                  "%
                  | optional,
                padding
                  | Number
                  | doc m%"
                  The padding, in pixels, between the legend and axis.
                  "%
                  | optional,
                shortTimeLabels
                  | Bool
                  | doc m%"
                  Whether month names and weekday names should be abbreviated.
                  
                  __Default value:__  `false`
                  "%
                  | optional,
                strokeColor
                  | String
                  | doc m%"
                  Border stroke color for the full legend.
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  Border stroke dash pattern for the full legend.
                  "%
                  | optional,
                strokeWidth
                  | Number
                  | doc m%"
                  Border stroke width for the full legend.
                  "%
                  | optional,
                symbolColor
                  | String
                  | doc m%"
                  The color of the legend symbol,
                  "%
                  | optional,
                symbolSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size of the legend symbol, in pixels.
                  "%
                  | optional,
                symbolStrokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the symbol's stroke.
                  "%
                  | optional,
                symbolType
                  | String
                  | doc m%"
                  Default shape type (such as "circle") for legend symbols.
                  "%
                  | optional,
                titleAlign
                  | String
                  | doc m%"
                  Horizontal text alignment for legend titles.
                  "%
                  | optional,
                titleBaseline
                  | String
                  | doc m%"
                  Vertical text baseline for legend titles.
                  "%
                  | optional,
                titleColor
                  | String
                  | doc m%"
                  The color of the legend title, can be in hex color code or regular color name.
                  "%
                  | optional,
                titleFont
                  | String
                  | doc m%"
                  The font of the legend title.
                  "%
                  | optional,
                titleFontSize
                  | Number
                  | doc m%"
                  The font size of the legend title.
                  "%
                  | optional,
                titleFontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  The font weight of the legend title.
                  "%
                  | optional,
                titleLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis titles.
                  "%
                  | optional,
                titlePadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between title and legend.
                  "%
                  | optional,
              },
          LegendOrient = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'none,
                  'bottom-right,
                  'bottom-left,
                  'top-right,
                  'top-left,
                  'right,
                  'left
                |]
              ],
          LegendResolveMap = {
                color | definitions.contract.ResolveMode | optional,
                opacity | definitions.contract.ResolveMode | optional,
                shape | definitions.contract.ResolveMode | optional,
                size | definitions.contract.ResolveMode | optional,
              },
          LocalMultiTimeUnit = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'secondsmilliseconds,
                  'minutesseconds,
                  'hoursminutesseconds,
                  'hoursminutes,
                  'monthdate,
                  'quartermonth,
                  'yearmonthdatehoursminutesseconds,
                  'yearmonthdatehoursminutes,
                  'yearmonthdatehours,
                  'yearmonthdate,
                  'yearmonth,
                  'yearquartermonth,
                  'yearquarter
                |]
              ],
          LocalSingleTimeUnit = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'milliseconds,
                  'seconds,
                  'minutes,
                  'hours,
                  'date,
                  'day,
                  'month,
                  'quarter,
                  'year
                |]
              ],
          LookupData = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  Secondary data source to lookup in.
                  "%,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Fields in foreign data to lookup.
                  If not specified, the entire object is queried.
                  "%
                  | optional,
                key
                  | String
                  | doc m%"
                  Key in data to lookup.
                  "%,
              },
          LookupTransform = {
                as
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  The field or fields for storing the computed formula value.
                  If `from.fields` is specified, the transform will use the same names for `as`.
                  If `from.fields` is not specified, `as` has to be a string and we put the whole object into the data under the specified name.
                  "%
                  | optional,
                "default"
                  | String
                  | doc m%"
                  The default value to use if lookup fails.
                  
                  __Default value:__ `null`
                  "%
                  | optional,
                from
                  | definitions.contract.LookupData
                  | doc m%"
                  Secondary data reference.
                  "%,
                lookup
                  | String
                  | doc m%"
                  Key in primary data source.
                  "%,
              },
          Mark
            | doc m%"
            All types of primitive marks.
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'square,
                  'circle,
                  'rule,
                  'rect,
                  'tick,
                  'text,
                  'point,
                  'line,
                  'bar,
                  'area
                |]
              ],
          MarkConfig = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Default color.  Note that `fill` and `stroke` have higher precedence than `color` and will override `color`.
                  
                  __Default value:__ <span style="color: #4682b4;">&#9632;</span> `"#4682b4"`
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                filled
                  | Bool
                  | doc m%"
                  Whether the mark's color should be used as fill color instead of stroke color.
                  
                  __Default value:__ `true` for all marks except `point` and `false` for `point`.
                  
                  __Applicable for:__ `bar`, `point`, `circle`, `square`, and `area` marks.
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The pixel area each the point/circle/square.
                  For example: in the case of circles, the radius is determined in part by the square root of the size value.
                  
                  __Default value:__ `30`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
              },
          MarkConfigMixins = {
                area
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Area-Specific Config 
                  "%
                  | optional,
                bar
                  | definitions.contract.BarConfig
                  | doc m%"
                  Bar-Specific Config 
                  "%
                  | optional,
                circle
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Circle-Specific Config 
                  "%
                  | optional,
                line
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Line-Specific Config 
                  "%
                  | optional,
                mark
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Mark Config 
                  "%
                  | optional,
                point
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Point-Specific Config 
                  "%
                  | optional,
                rect
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Rect-Specific Config 
                  "%
                  | optional,
                rule
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Rule-Specific Config 
                  "%
                  | optional,
                square
                  | definitions.contract.MarkConfig
                  | doc m%"
                  Square-Specific Config 
                  "%
                  | optional,
                text
                  | definitions.contract.TextConfig
                  | doc m%"
                  Text-Specific Config 
                  "%
                  | optional,
                tick
                  | definitions.contract.TickConfig
                  | doc m%"
                  Tick-Specific Config 
                  "%
                  | optional,
              },
          MarkDef = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                clip
                  | Bool
                  | doc m%"
                  Whether a mark be clipped to the enclosing group's width and height.
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Default color.  Note that `fill` and `stroke` have higher precedence than `color` and will override `color`.
                  
                  __Default value:__ <span style="color: #4682b4;">&#9632;</span> `"#4682b4"`
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                filled
                  | Bool
                  | doc m%"
                  Whether the mark's color should be used as fill color instead of stroke color.
                  
                  __Default value:__ `true` for all marks except `point` and `false` for `point`.
                  
                  __Applicable for:__ `bar`, `point`, `circle`, `square`, and `area` marks.
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The pixel area each the point/circle/square.
                  For example: in the case of circles, the radius is determined in part by the square root of the size value.
                  
                  __Default value:__ `30`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                style
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  A string or array of strings indicating the name of custom styles to apply to the mark. A style is a named collection of mark property defaults defined within the [style configuration](mark.html#style-config). If style is an array, later styles will override earlier styles. Any [mark properties](encoding.html#mark-prop) explicitly defined within the `encoding` will override a style default.
                  
                  __Default value:__ The mark's name.  For example, a bar mark will have style `"bar"` by default.
                  __Note:__ Any specified style will augment the default style. For example, a bar mark with `"style": "foo"` will receive from `config.style.bar` and `config.style.foo` (the specified style `"foo"` has higher precedence).
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
                type
                  | definitions.contract.Mark
                  | doc m%"
                  The mark type.
                  One of `"bar"`, `"circle"`, `"square"`, `"tick"`, `"line"`,
                  `"area"`, `"point"`, `"rule"`, and `"text"`.
                  "%,
              },
          MarkPropFieldDef
            | doc m%"
            Field definition of a mark property, which can contain a legend.
            "%
            = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                legend
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Legend, predicates.isType 'Null ])
                  | doc m%"
                  An object defining properties of the legend.
                  If `null`, the legend for the encoding channel will be removed.
                  
                  __Default value:__ If undefined, default [legend properties](legend.html) are applied.
                  "%
                  | optional,
                scale
                  | definitions.contract.Scale
                  | doc m%"
                  An object defining properties of the channel's scale, which is the function that transforms values in the data domain (numbers, dates, strings, etc) to visual values (pixels, colors, sizes) of the encoding channels.
                  
                  __Default value:__ If undefined, default [scale properties](scale.html) are applied.
                  "%
                  | optional,
                sort
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.SortOrder,
                    definitions.predicate.SortField,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sort order for the encoded field.
                  Supported `sort` values include `"ascending"`, `"descending"` and `null` (no sorting).
                  For fields with discrete domains, `sort` can also be a [sort field definition object](sort.html#sort-field).
                  
                  __Default value:__ `"ascending"`
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          MarkPropFieldDefWithCondition
            | doc m%"
            A FieldDef with Condition<ValueDef>
            {
               condition: {value: ...},
               field: ...,
               ...
            }
            "%
            = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                condition
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate."Conditional<ValueDef>",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."Conditional<ValueDef>"
                    ]
                  ])
                  | doc m%"
                  One or more value definition(s) with a selection predicate.
                  
                  __Note:__ A field definition's `condition` property can only contain [value definitions](encoding.html#value)
                  since Vega-Lite only allows at mosty  one encoded field per encoding channel.
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                legend
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Legend, predicates.isType 'Null ])
                  | doc m%"
                  An object defining properties of the legend.
                  If `null`, the legend for the encoding channel will be removed.
                  
                  __Default value:__ If undefined, default [legend properties](legend.html) are applied.
                  "%
                  | optional,
                scale
                  | definitions.contract.Scale
                  | doc m%"
                  An object defining properties of the channel's scale, which is the function that transforms values in the data domain (numbers, dates, strings, etc) to visual values (pixels, colors, sizes) of the encoding channels.
                  
                  __Default value:__ If undefined, default [scale properties](scale.html) are applied.
                  "%
                  | optional,
                sort
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.SortOrder,
                    definitions.predicate.SortField,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sort order for the encoded field.
                  Supported `sort` values include `"ascending"`, `"descending"` and `null` (no sorting).
                  For fields with discrete domains, `sort` can also be a [sort field definition object](sort.html#sort-field).
                  
                  __Default value:__ `"ascending"`
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          MarkPropValueDefWithCondition
            | doc m%"
            A ValueDef with Condition<ValueDef | FieldDef>
            {
               condition: {field: ...} | {value: ...},
               value: ...,
            }
            "%
            = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate."Conditional<MarkPropFieldDef>",
                    definitions.predicate."Conditional<ValueDef>",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."Conditional<ValueDef>"
                    ]
                  ])
                  | doc m%"
                  A field definition or one or more value definition(s) with a selection predicate.
                  "%
                  | optional,
                value
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Number",
                    predicates.isType '"String",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  A constant value in visual domain.
                  "%
                  | optional,
              },
          Month = predicates.contract_from_predicate
              definitions.predicate.Month,
          MultiSelection = {
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                nearest
                  | Bool
                  | doc m%"
                  When true, an invisible voronoi diagram is computed to accelerate discrete
                  selection. The data value _nearest_ the mouse cursor is added to the selection.
                  
                  See the [nearest transform](nearest.html) documentation for more information.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
                toggle
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Controls whether data values should be toggled or only ever inserted into
                  multi selections. Can be `true`, `false` (for insertion only), or a
                  [Vega expression](https://vega.github.io/vega/docs/expressions/).
                  
                  __Default value:__ `true`, which corresponds to `event.shiftKey` (i.e.,
                  data values are toggled when a user interacts with the shift-key pressed).
                  
                  See the [toggle transform](toggle.html) documentation for more information.
                  "%
                  | optional,
                type | std.enum.TagOrString | [| 'multi |],
              },
          MultiSelectionConfig = {
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                nearest
                  | Bool
                  | doc m%"
                  When true, an invisible voronoi diagram is computed to accelerate discrete
                  selection. The data value _nearest_ the mouse cursor is added to the selection.
                  
                  See the [nearest transform](nearest.html) documentation for more information.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
                toggle
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Bool" ])
                  | doc m%"
                  Controls whether data values should be toggled or only ever inserted into
                  multi selections. Can be `true`, `false` (for insertion only), or a
                  [Vega expression](https://vega.github.io/vega/docs/expressions/).
                  
                  __Default value:__ `true`, which corresponds to `event.shiftKey` (i.e.,
                  data values are toggled when a user interacts with the shift-key pressed).
                  
                  See the [toggle transform](toggle.html) documentation for more information.
                  "%
                  | optional,
              },
          MultiTimeUnit = predicates.contract_from_predicate
              definitions.predicate.MultiTimeUnit,
          NamedData = {
                format
                  | definitions.contract.DataFormat
                  | doc m%"
                  An object that specifies the format for parsing the data.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Provide a placeholder name and bind data at runtime.
                  "%,
              },
          NiceTime = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'year, 'month, 'week, 'day, 'hour, 'minute, 'second |]
              ],
          NotFilter = { not | definitions.contract.FilterOperand, },
          OneOfFilter = {
                field
                  | String
                  | doc m%"
                  Field to be filtered
                  "%,
                oneOf
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Number")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Bool")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.DateTime
                    ]
                  ])
                  | doc m%"
                  A set of values that the `field`'s value should be a member of,
                  for a data item included in the filtered data.
                  "%,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  time unit for the field to be filtered.
                  "%
                  | optional,
              },
          OrFilter = {
                or
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.FilterOperand
                  ]),
              },
          OrderFieldDef = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                sort
                  | definitions.contract.SortOrder
                  | doc m%"
                  The sort order. One of `"ascending"` (default) or `"descending"`.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          Orient = std.contract.Sequence
              [ std.enum.TagOrString, [| 'vertical, 'horizontal |] ],
          Padding = predicates.contract_from_predicate
              definitions.predicate.Padding,
          PositionFieldDef = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                axis
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ definitions.predicate.Axis, predicates.isType 'Null ])
                  | doc m%"
                  An object defining properties of axis's gridlines, ticks and labels.
                  If `null`, the axis for the encoding channel will be removed.
                  
                  __Default value:__ If undefined, default [axis properties](axis.html) are applied.
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                scale
                  | definitions.contract.Scale
                  | doc m%"
                  An object defining properties of the channel's scale, which is the function that transforms values in the data domain (numbers, dates, strings, etc) to visual values (pixels, colors, sizes) of the encoding channels.
                  
                  __Default value:__ If undefined, default [scale properties](scale.html) are applied.
                  "%
                  | optional,
                sort
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.SortOrder,
                    definitions.predicate.SortField,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sort order for the encoded field.
                  Supported `sort` values include `"ascending"`, `"descending"` and `null` (no sorting).
                  For fields with discrete domains, `sort` can also be a [sort field definition object](sort.html#sort-field).
                  
                  __Default value:__ `"ascending"`
                  "%
                  | optional,
                stack
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.StackOffset,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Type of stacking offset if the field should be stacked.
                  `stack` is only applicable for `x` and `y` channels with continuous domains.
                  For example, `stack` of `y` can be used to customize stacking for a vertical bar chart.
                  
                  `stack` can be one of the following values:
                  - `"zero"`: stacking with baseline offset at zero value of the scale (for creating typical stacked [bar](stack.html#bar) and [area](stack.html#area) chart).
                  - `"normalize"` - stacking with normalized domain (for creating [normalized stacked bar and area charts](stack.html#normalized). <br/>
                  -`"center"` - stacking with center baseline (for [streamgraph](stack.html#streamgraph)).
                  - `null` - No-stacking. This will produce layered [bar](stack.html#layered-bar-chart) and area chart.
                  
                  __Default value:__ `zero` for plots with all of the following conditions are true:
                  (1) the mark is `bar` or `area`;
                  (2) the stacked measure channel (x or y) has a linear scale;
                  (3) At least one of non-position channels mapped to an unaggregated field that is different from x and y.  Otherwise, `null` by default.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          RangeConfig = predicates.contract_from_predicate
              definitions.predicate.RangeConfig,
          RangeConfigValue = predicates.contract_from_predicate
              definitions.predicate.RangeConfigValue,
          RangeFilter = {
                field
                  | String
                  | doc m%"
                  Field to be filtered
                  "%,
                range
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      predicates.isType '"Number",
                      definitions.predicate.DateTime
                    ]),
                    predicates.arrays.maxItems 2,
                    predicates.arrays.minItems 2
                  ])
                  | doc m%"
                  An array of inclusive minimum and maximum values
                  for a field value of a data item to be included in the filtered data.
                  "%,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  time unit for the field to be filtered.
                  "%
                  | optional,
              },
          Repeat = {
                column
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Horizontal repeated views.
                  "%
                  | optional,
                row
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  Vertical repeated views.
                  "%
                  | optional,
              },
          RepeatRef
            | doc m%"
            Reference to a repeated value.
            "%
            = { repeat | std.enum.TagOrString | [| 'column, 'row |], },
          RepeatSpec = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                repeat
                  | definitions.contract.Repeat
                  | doc m%"
                  An object that describes what fields should be repeated into views that are laid out as a `row` or `column`.
                  "%,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale and legend resolutions for repeated charts.
                  "%
                  | optional,
                spec | definitions.contract.Spec,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          Resolve
            | doc m%"
            Defines how scales, axes, and legends from different specs should be combined. Resolve is a mapping from `scale`, `axis`, and `legend` to a mapping from channels to resolutions.
            "%
            = {
                axis | definitions.contract.AxisResolveMap | optional,
                legend | definitions.contract.LegendResolveMap | optional,
                scale | definitions.contract.ScaleResolveMap | optional,
              },
          ResolveMode = std.contract.Sequence
              [ std.enum.TagOrString, [| 'shared, 'independent |] ],
          Scale = {
                base
                  | Number
                  | doc m%"
                  The logarithm base of the `log` scale (default `10`).
                  "%
                  | optional,
                clamp
                  | Bool
                  | doc m%"
                  If `true`, values that exceed the data domain are clamped to either the minimum or maximum range value
                  
                  __Default value:__ derived from the [scale config](config.html#scale-config)'s `clamp` (`true` by default).
                  "%
                  | optional,
                domain
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Number")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Bool")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf definitions.predicate.DateTime
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "unaggregated" ]
                    ],
                    definitions.predicate.SelectionDomain
                  ])
                  | doc m%"
                  Customized domain values.
                  
                  For _quantitative_ fields, `domain` can take the form of a two-element array with minimum and maximum values.  [Piecewise scales](scale.html#piecewise) can be created by providing a `domain` with more than two entries.
                  If the input field is aggregated, `domain` can also be a string value `"unaggregated"`, indicating that the domain should include the raw data values prior to the aggregation.
                  
                  For _temporal_ fields, `domain` can be a two-element array minimum and maximum values, in the form of either timestamps or the [DateTime definition objects](types.html#datetime).
                  
                  For _ordinal_ and _nominal_ fields, `domain` can be an array that lists valid input values.
                  
                  The `selection` property can be used to [interactively determine](selection.html#scale-domains) the scale domain.
                  "%
                  | optional,
                exponent
                  | Number
                  | doc m%"
                  The exponent of the `pow` scale.
                  "%
                  | optional,
                interpolate
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.Interpolate,
                    definitions.predicate.InterpolateParams
                  ])
                  | doc m%"
                  The interpolation method for range values. By default, a general interpolator for numbers, dates, strings and colors (in RGB space) is used. For color ranges, this property allows interpolation in alternative color spaces. Legal values include `rgb`, `hsl`, `hsl-long`, `lab`, `hcl`, `hcl-long`, `cubehelix` and `cubehelix-long` ('-long' variants use longer paths in polar coordinate spaces). If object-valued, this property accepts an object with a string-valued _type_ property and an optional numeric _gamma_ property applicable to rgb and cubehelix interpolators. For more, see the [d3-interpolate documentation](https://github.com/d3/d3-interpolate).
                  "%
                  | optional,
                nice
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.isType '"Number",
                    definitions.predicate.NiceTime,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.required [ "interval", "step" ],
                      predicates.records.record
                      {
                        interval = predicates.isType '"String",
                        step = predicates.isType '"Number",
                      }
                      {  }
                      false
                      predicates.never
                    ]
                  ])
                  | doc m%"
                  Extending the domain so that it starts and ends on nice round values. This method typically modifies the scale's domain, and may only extend the bounds to the nearest round value. Nicing is useful if the domain is computed from data and may be irregular. For example, for a domain of _[0.201479…, 0.996679…]_, a nice domain might be _[0.2, 1.0]_.
                  
                  For quantitative scales such as linear, `nice` can be either a boolean flag or a number. If `nice` is a number, it will represent a desired tick count. This allows greater control over the step size used to extend the bounds, guaranteeing that the returned ticks will exactly cover the domain.
                  
                  For temporal fields with time and utc scales, the `nice` value can be a string indicating the desired time interval. Legal values are `"millisecond"`, `"second"`, `"minute"`, `"hour"`, `"day"`, `"week"`, `"month"`, and `"year"`. Alternatively, `time` and `utc` scales can accept an object-valued interval specifier of the form `{"interval": "month", "step": 3}`, which includes a desired number of interval steps. Here, the domain would snap to quarter (Jan, Apr, Jul, Oct) boundaries.
                  
                  __Default value:__ `true` for unbinned _quantitative_ fields; `false` otherwise.
                  "%
                  | optional,
                padding
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  For _[continuous](scale.html#continuous)_ scales, expands the scale domain to accommodate the specified number of pixels on each of the scale range. The scale range must represent pixels for this parameter to function as intended. Padding adjustment is performed prior to all other adjustments, including the effects of the zero, nice, domainMin, and domainMax properties.
                  
                  For _[band](scale.html#band)_ scales, shortcut for setting `paddingInner` and `paddingOuter` to the same value.
                  
                  For _[point](scale.html#point)_ scales, alias for `paddingOuter`.
                  
                  __Default value:__ For _continuous_ scales, derived from the [scale config](scale.html#config)'s `continuousPadding`.
                  For _band and point_ scales, see `paddingInner` and `paddingOuter`.
                  "%
                  | optional,
                paddingInner
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The inner padding (spacing) within each band step of band scales, as a fraction of the step size. This value must lie in the range [0,1].
                  
                  For point scale, this property is invalid as point scales do not have internal band widths (only step sizes between bands).
                  
                  __Default value:__ derived from the [scale config](scale.html#config)'s `bandPaddingInner`.
                  "%
                  | optional,
                paddingOuter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The outer padding (spacing) at the ends of the range of band and point scales,
                  as a fraction of the step size. This value must lie in the range [0,1].
                  
                  __Default value:__ derived from the [scale config](scale.html#config)'s `bandPaddingOuter` for band scales and `pointPadding` for point scales.
                  "%
                  | optional,
                range
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"Number")
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ],
                    predicates.isType '"String"
                  ])
                  | doc m%"
                  The range of the scale. One of:
                  
                  - A string indicating a [pre-defined named scale range](scale.html#range-config) (e.g., example, `"symbol"`, or `"diverging"`).
                  
                  - For [continuous scales](scale.html#continuous), two-element array indicating  minimum and maximum values, or an array with more than two entries for specifying a [piecewise scale](scale.html#piecewise).
                  
                  - For [discrete](scale.html#discrete) and [discretizing](scale.html#discretizing) scales, an array of desired output values.
                  
                  __Notes:__
                  
                  1) For [sequential](scale.html#sequential), [ordinal](scale.html#ordinal), and discretizing color scales, you can also specify a color [`scheme`](scale.html#scheme) instead of `range`.
                  
                  2) Any directly specified `range` for `x` and `y` channels will be ignored. Range can be customized via the view's corresponding [size](size.html) (`width` and `height`) or via [range steps and paddings properties](#range-step) for [band](#band) and [point](#point) scales.
                  "%
                  | optional,
                rangeStep
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Number", predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The distance between the starts of adjacent bands or points in [band](scale.html#band) and [point](scale.html#point) scales.
                  
                  If `rangeStep` is `null` or if the view contains the scale's corresponding [size](size.html) (`width` for `x` scales and `height` for `y` scales), `rangeStep` will be automatically determined to fit the size of the view.
                  
                  __Default value:__  derived the [scale config](config.html#scale-config)'s `textXRangeStep` (`90` by default) for x-scales of `text` marks and `rangeStep` (`21` by default) for x-scales of other marks and y-scales.
                  
                  __Warning__: If `rangeStep` is `null` and the cardinality of the scale's domain is higher than `width` or `height`, the rangeStep might become less than one pixel and the mark might not appear correctly.
                  "%
                  | optional,
                round
                  | Bool
                  | doc m%"
                  If `true`, rounds numeric output values to integers. This can be helpful for snapping to the pixel grid.
                  
                  __Default value:__ `false`.
                  "%
                  | optional,
                scheme
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.SchemeParams
                  ])
                  | doc m%"
                  A string indicating a color [scheme](scale.html#scheme) name (e.g., `"category10"` or `"viridis"`) or a [scheme parameter object](scale.html#scheme-params).
                  
                  Discrete color schemes may be used with [discrete](scale.html#discrete) or [discretizing](scale.html#discretizing) scales. Continuous color schemes are intended for use with [sequential](scales.html#sequential) scales.
                  
                  For the full list of supported scheme, please refer to the [Vega Scheme](https://vega.github.io/vega/docs/schemes/#reference) reference.
                  "%
                  | optional,
                type
                  | definitions.contract.ScaleType
                  | doc m%"
                  The type of scale.  Vega-Lite supports the following categories of scale types:
                  
                  1) [**Continuous Scales**](scale.html#continuous) -- mapping continuous domains to continuous output ranges ([`"linear"`](scale.html#linear), [`"pow"`](scale.html#pow), [`"sqrt"`](scale.html#sqrt), [`"log"`](scale.html#log), [`"time"`](scale.html#time), [`"utc"`](scale.html#utc), [`"sequential"`](scale.html#sequential)).
                  
                  2) [**Discrete Scales**](scale.html#discrete) -- mapping discrete domains to discrete ([`"ordinal"`](scale.html#ordinal)) or continuous ([`"band"`](scale.html#band) and [`"point"`](scale.html#point)) output ranges.
                  
                  3) [**Discretizing Scales**](scale.html#discretizing) -- mapping continuous domains to discrete output ranges ([`"bin-linear"`](scale.html#bin-linear) and [`"bin-ordinal"`](scale.html#bin-ordinal)).
                  
                  __Default value:__ please see the [scale type table](scale.html#type).
                  "%
                  | optional,
                zero
                  | Bool
                  | doc m%"
                  If `true`, ensures that a zero baseline value is included in the scale domain.
                  
                  __Default value:__ `true` for x and y channels if the quantitative field is not binned and no custom `domain` is provided; `false` otherwise.
                  
                  __Note:__ Log, time, and utc scales do not support `zero`.
                  "%
                  | optional,
              },
          ScaleConfig = {
                bandPaddingInner
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Default inner padding for `x` and `y` band-ordinal scales.
                  
                  __Default value:__ `0.1`
                  "%
                  | optional,
                bandPaddingOuter
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Default outer padding for `x` and `y` band-ordinal scales.
                  If not specified, by default, band scale's paddingOuter is paddingInner/2.
                  "%
                  | optional,
                clamp
                  | Bool
                  | doc m%"
                  If true, values that exceed the data domain are clamped to either the minimum or maximum range value
                  "%
                  | optional,
                continuousPadding
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Default padding for continuous scales.
                  
                  __Default:__ `5` for continuous x-scale of a vertical bar and continuous y-scale of a horizontal bar.; `0` otherwise.
                  "%
                  | optional,
                maxBandSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The default max value for mapping quantitative fields to bar's size/bandSize.
                  
                  If undefined (default), we will use the scale's `rangeStep` - 1.
                  "%
                  | optional,
                maxFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The default max value for mapping quantitative fields to text's size/fontSize.
                  
                  __Default value:__ `40`
                  "%
                  | optional,
                maxOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Default max opacity for mapping a field to opacity.
                  
                  __Default value:__ `0.8`
                  "%
                  | optional,
                maxSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Default max value for point size scale.
                  "%
                  | optional,
                maxStrokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Default max strokeWidth for strokeWidth  (or rule/line's size) scale.
                  
                  __Default value:__ `4`
                  "%
                  | optional,
                minBandSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The default min value for mapping quantitative fields to bar and tick's size/bandSize scale with zero=false.
                  
                  __Default value:__ `2`
                  "%
                  | optional,
                minFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The default min value for mapping quantitative fields to tick's size/fontSize scale with zero=false
                  
                  __Default value:__ `8`
                  "%
                  | optional,
                minOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Default minimum opacity for mapping a field to opacity.
                  
                  __Default value:__ `0.3`
                  "%
                  | optional,
                minSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Default minimum value for point size scale with zero=false.
                  
                  __Default value:__ `9`
                  "%
                  | optional,
                minStrokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Default minimum strokeWidth for strokeWidth (or rule/line's size) scale with zero=false.
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                pointPadding
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Default outer padding for `x` and `y` point-ordinal scales.
                  
                  __Default value:__ `0.5`
                  "%
                  | optional,
                rangeStep
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.anyOf
                    [ predicates.isType '"Number", predicates.isType 'Null ],
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Default range step for band and point scales of (1) the `y` channel
                  and (2) the `x` channel when the mark is not `text`.
                  
                  __Default value:__ `21`
                  "%
                  | optional,
                round
                  | Bool
                  | doc m%"
                  If true, rounds numeric output values to integers.
                  This can be helpful for snapping to the pixel grid.
                  (Only available for `x`, `y`, and `size` scales.)
                  "%
                  | optional,
                textXRangeStep
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Default range step for `x` band and point scales of text marks.
                  
                  __Default value:__ `90`
                  "%
                  | optional,
                useUnaggregatedDomain
                  | Bool
                  | doc m%"
                  Use the source data range before aggregation as scale domain instead of aggregated data for aggregate axis.
                  
                  This is equivalent to setting `domain` to `"unaggregate"` for aggregated _quantitative_ fields by default.
                  
                  This property only works with aggregate functions that produce values within the raw data domain (`"mean"`, `"average"`, `"median"`, `"q1"`, `"q3"`, `"min"`, `"max"`). For other aggregations that produce values outside of the raw data domain (e.g. `"count"`, `"sum"`), this property is ignored.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
              },
          ScaleFieldDef = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                scale
                  | definitions.contract.Scale
                  | doc m%"
                  An object defining properties of the channel's scale, which is the function that transforms values in the data domain (numbers, dates, strings, etc) to visual values (pixels, colors, sizes) of the encoding channels.
                  
                  __Default value:__ If undefined, default [scale properties](scale.html) are applied.
                  "%
                  | optional,
                sort
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.SortOrder,
                    definitions.predicate.SortField,
                    predicates.isType 'Null
                  ])
                  | doc m%"
                  Sort order for the encoded field.
                  Supported `sort` values include `"ascending"`, `"descending"` and `null` (no sorting).
                  For fields with discrete domains, `sort` can also be a [sort field definition object](sort.html#sort-field).
                  
                  __Default value:__ `"ascending"`
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          ScaleResolveMap = {
                color | definitions.contract.ResolveMode | optional,
                opacity | definitions.contract.ResolveMode | optional,
                shape | definitions.contract.ResolveMode | optional,
                size | definitions.contract.ResolveMode | optional,
                x | definitions.contract.ResolveMode | optional,
                y | definitions.contract.ResolveMode | optional,
              },
          ScaleType = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'band,
                  'point,
                  'bin-ordinal,
                  'ordinal,
                  'sequential,
                  'utc,
                  'time,
                  'sqrt,
                  'pow,
                  'log,
                  'bin-linear,
                  'linear
                |]
              ],
          SchemeParams = {
                extent
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  For sequential and diverging schemes only, determines the extent of the color range to use. For example `[0.2, 1]` will rescale the color scheme such that color values in the range _[0, 0.2)_ are excluded from the scheme.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  A color scheme name for sequential/ordinal scales (e.g., `"category10"` or `"viridis"`).
                  
                  For the full list of supported scheme, please refer to the [Vega Scheme](https://vega.github.io/vega/docs/schemes/#reference) reference.
                  "%,
              },
          SelectionAnd = {
                and
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SelectionOperand
                  ]),
              },
          SelectionConfig = {
                interval
                  | definitions.contract.IntervalSelectionConfig
                  | doc m%"
                  The default definition for an [`interval`](selection.html#type) selection. All properties and transformations
                  for an interval selection definition (except `type`) may be specified here.
                  
                  For instance, setting `interval` to `{"translate": false}` disables the ability to move
                  interval selections by default.
                  "%
                  | optional,
                multi
                  | definitions.contract.MultiSelectionConfig
                  | doc m%"
                  The default definition for a [`multi`](selection.html#type) selection. All properties and transformations
                  for a multi selection definition (except `type`) may be specified here.
                  
                  For instance, setting `multi` to `{"toggle": "event.altKey"}` adds additional values to
                  multi selections when clicking with the alt-key pressed by default.
                  "%
                  | optional,
                single
                  | definitions.contract.SingleSelectionConfig
                  | doc m%"
                  The default definition for a [`single`](selection.html#type) selection. All properties and transformations
                    for a single selection definition (except `type`) may be specified here.
                  
                  For instance, setting `single` to `{"on": "dblclick"}` populates single selections on double-click by default.
                  "%
                  | optional,
              },
          SelectionDef = predicates.contract_from_predicate
              definitions.predicate.SelectionDef,
          SelectionDomain = predicates.contract_from_predicate
              definitions.predicate.SelectionDomain,
          SelectionFilter = {
                selection
                  | definitions.contract.SelectionOperand
                  | doc m%"
                  Filter using a selection name.
                  "%,
              },
          SelectionNot = { not | definitions.contract.SelectionOperand, },
          SelectionOperand = predicates.contract_from_predicate
              definitions.predicate.SelectionOperand,
          SelectionOr = {
                or
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SelectionOperand
                  ]),
              },
          SelectionResolution = std.contract.Sequence
              [ std.enum.TagOrString, [| 'intersect, 'union, 'global |] ],
          SingleDefChannel = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'tooltip,
                  'text,
                  'opacity,
                  'color,
                  'shape,
                  'size,
                  'column,
                  'row,
                  'y2,
                  'x2,
                  'y,
                  'x
                |]
              ],
          SingleSelection = {
                bind
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VgBinding,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      definitions.predicate.VgBinding
                    ]
                  ])
                  | doc m%"
                  Establish a two-way binding between a single selection and input elements
                  (also known as dynamic query widgets). A binding takes the form of
                  Vega's [input element binding definition](https://vega.github.io/vega/docs/signals/#bind)
                  or can be a mapping between projected field/encodings and binding definitions.
                  
                  See the [bind transform](bind.html) documentation for more information.
                  "%
                  | optional,
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                nearest
                  | Bool
                  | doc m%"
                  When true, an invisible voronoi diagram is computed to accelerate discrete
                  selection. The data value _nearest_ the mouse cursor is added to the selection.
                  
                  See the [nearest transform](nearest.html) documentation for more information.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
                type | std.enum.TagOrString | [| 'single |],
              },
          SingleSelectionConfig = {
                bind
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.VgBinding,
                    predicates.allOf
                    [
                      predicates.isType 'Record,
                      predicates.records.record {  } {  } true
                      definitions.predicate.VgBinding
                    ]
                  ])
                  | doc m%"
                  Establish a two-way binding between a single selection and input elements
                  (also known as dynamic query widgets). A binding takes the form of
                  Vega's [input element binding definition](https://vega.github.io/vega/docs/signals/#bind)
                  or can be a mapping between projected field/encodings and binding definitions.
                  
                  See the [bind transform](bind.html) documentation for more information.
                  "%
                  | optional,
                empty
                  | std.enum.TagOrString
                  | [| 'none, 'all |]
                  | doc m%"
                  By default, all data values are considered to lie within an empty selection.
                  When set to `none`, empty selections contain no data values.
                  "%
                  | optional,
                encodings
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    definitions.predicate.SingleDefChannel
                  ])
                  | doc m%"
                  An array of encoding channels. The corresponding data field values
                  must match for a data tuple to fall within the selection.
                  "%
                  | optional,
                fields
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ])
                  | doc m%"
                  An array of field names whose values must match for a data tuple to
                  fall within the selection.
                  "%
                  | optional,
                nearest
                  | Bool
                  | doc m%"
                  When true, an invisible voronoi diagram is computed to accelerate discrete
                  selection. The data value _nearest_ the mouse cursor is added to the selection.
                  
                  See the [nearest transform](nearest.html) documentation for more information.
                  "%
                  | optional,
                on
                  | definitions.contract.VgEventStream
                  | doc m%"
                  A [Vega event stream](https://vega.github.io/vega/docs/event-streams/) (object or selector) that triggers the selection.
                  For interval selections, the event stream must specify a [start and end](https://vega.github.io/vega/docs/event-streams/#between-filters).
                  "%
                  | optional,
                resolve
                  | definitions.contract.SelectionResolution
                  | doc m%"
                  With layered and multi-view displays, a strategy that determines how
                  selections' data queries are resolved when applied in a filter transform,
                  conditional encoding rule, or scale domain.
                  "%
                  | optional,
              },
          SingleTimeUnit = predicates.contract_from_predicate
              definitions.predicate.SingleTimeUnit,
          SortField = {
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  The data [field](field.html) to sort by.
                  
                  __Default value:__ If unspecified, defaults to the field specified in the outer data reference.
                  "%
                  | optional,
                op
                  | definitions.contract.AggregateOp
                  | doc m%"
                  An [aggregate operation](aggregate.html#ops) to perform on the field prior to sorting (e.g., `"count"`, `"mean"` and `"median"`).
                  This property is required in cases where the sort field and the data reference field do not match.
                  The input data objects will be aggregated, grouped by the encoded data field.
                  
                  For a full list of operations, please see the documentation for [aggregate](aggregate.html#ops).
                  "%,
                order
                  | definitions.contract.SortOrder
                  | doc m%"
                  The sort order. One of `"ascending"` (default) or `"descending"`.
                  "%
                  | optional,
              },
          SortOrder = predicates.contract_from_predicate
              definitions.predicate.SortOrder,
          Spec = predicates.contract_from_predicate definitions.predicate.Spec,
          StackOffset = std.contract.Sequence
              [ std.enum.TagOrString, [| 'normalize, 'center, 'zero |] ],
          StyleConfigIndex = predicates.contract_from_predicate
              definitions.predicate.StyleConfigIndex,
          TextConfig = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Default color.  Note that `fill` and `stroke` have higher precedence than `color` and will override `color`.
                  
                  __Default value:__ <span style="color: #4682b4;">&#9632;</span> `"#4682b4"`
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                filled
                  | Bool
                  | doc m%"
                  Whether the mark's color should be used as fill color instead of stroke color.
                  
                  __Default value:__ `true` for all marks except `point` and `false` for `point`.
                  
                  __Applicable for:__ `bar`, `point`, `circle`, `square`, and `area` marks.
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                shortTimeLabels
                  | Bool
                  | doc m%"
                  Whether month names and weekday names should be abbreviated.
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The pixel area each the point/circle/square.
                  For example: in the case of circles, the radius is determined in part by the square root of the size value.
                  
                  __Default value:__ `30`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
              },
          TextFieldDef = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  The [formatting pattern](format.html) for a text field. If not defined, this will be determined automatically.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          TextFieldDefWithCondition
            | doc m%"
            A FieldDef with Condition<ValueDef>
            {
               condition: {value: ...},
               field: ...,
               ...
            }
            "%
            = {
                aggregate
                  | definitions.contract.Aggregate
                  | doc m%"
                  Aggregation function for the field
                  (e.g., `mean`, `sum`, `median`, `min`, `max`, `count`).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                bin
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    definitions.predicate.BinParams
                  ])
                  | doc m%"
                  A flag for binning a `quantitative` field, or [an object defining binning parameters](bin.html#params).
                  If `true`, default [binning parameters](bin.html) will be applied.
                  
                  __Default value:__ `false`
                  "%
                  | optional,
                condition
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate."Conditional<ValueDef>",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."Conditional<ValueDef>"
                    ]
                  ])
                  | doc m%"
                  One or more value definition(s) with a selection predicate.
                  
                  __Note:__ A field definition's `condition` property can only contain [value definitions](encoding.html#value)
                  since Vega-Lite only allows at mosty  one encoded field per encoding channel.
                  "%
                  | optional,
                field
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.RepeatRef
                  ])
                  | doc m%"
                  __Required.__ A string defining the name of the field from which to pull a data value
                  or an object defining iterated values from the [`repeat`](repeat.html) operator.
                  
                  __Note:__ `field` is not required if `aggregate` is `count`.
                  "%
                  | optional,
                format
                  | String
                  | doc m%"
                  The [formatting pattern](format.html) for a text field. If not defined, this will be determined automatically.
                  "%
                  | optional,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  Time unit (e.g., `year`, `yearmonth`, `month`, `hours`) for a temporal field.
                  or [a temporal field that gets casted as ordinal](type.html#cast).
                  
                  __Default value:__ `undefined` (None)
                  "%
                  | optional,
                type
                  | definitions.contract.Type
                  | doc m%"
                  The encoded field's type of measurement (`"quantitative"`, `"temporal"`, `"ordinal"`, or `"nominal"`).
                  "%,
              },
          TextValueDefWithCondition
            | doc m%"
            A ValueDef with Condition<ValueDef | FieldDef>
            {
               condition: {field: ...} | {value: ...},
               value: ...,
            }
            "%
            = {
                condition
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate."Conditional<TextFieldDef>",
                    definitions.predicate."Conditional<ValueDef>",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf
                      definitions.predicate."Conditional<ValueDef>"
                    ]
                  ])
                  | doc m%"
                  A field definition or one or more value definition(s) with a selection predicate.
                  "%
                  | optional,
                value
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Number",
                    predicates.isType '"String",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  A constant value in visual domain.
                  "%
                  | optional,
              },
          TickConfig = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                bandSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the ticks.
                  
                  __Default value:__  2/3 of rangeStep.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Default color.  Note that `fill` and `stroke` have higher precedence than `color` and will override `color`.
                  
                  __Default value:__ <span style="color: #4682b4;">&#9632;</span> `"#4682b4"`
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                filled
                  | Bool
                  | doc m%"
                  Whether the mark's color should be used as fill color instead of stroke color.
                  
                  __Default value:__ `true` for all marks except `point` and `false` for `point`.
                  
                  __Applicable for:__ `bar`, `point`, `circle`, `square`, and `area` marks.
                  
                  __Note:__ This property cannot be used in a [style config](mark.html#style-config).
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The pixel area each the point/circle/square.
                  For example: in the case of circles, the radius is determined in part by the square root of the size value.
                  
                  __Default value:__ `30`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
                thickness
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Thickness of the tick mark.
                  
                  __Default value:__  `1`
                  "%
                  | optional,
              },
          TimeUnit = predicates.contract_from_predicate
              definitions.predicate.TimeUnit,
          TimeUnitTransform = {
                as
                  | String
                  | doc m%"
                  The output field to write the timeUnit value.
                  "%,
                field
                  | String
                  | doc m%"
                  The data field to apply time unit.
                  "%,
                timeUnit
                  | definitions.contract.TimeUnit
                  | doc m%"
                  The timeUnit.
                  "%,
              },
          TitleBase = {
                anchor
                  | definitions.contract.Anchor
                  | doc m%"
                  The anchor position for placing the title. One of `"start"`, `"middle"`, or `"end"`. For example, with an orientation of top these anchor positions map to a left-, center-, or right-aligned title.
                  
                  __Default value:__ `"middle"` for [single](spec.html) and [layered](layer.html) views.
                  `"start"` for other composite views.
                  
                  __Note:__ [For now](https://github.com/vega/vega-lite/issues/2875), `anchor` is only customizable only for [single](spec.html) and [layered](layer.html) views.  For other composite views, `anchor` is always `"start"`.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The orthogonal offset in pixels by which to displace the title from its position along the edge of the chart.
                  "%
                  | optional,
                orient
                  | definitions.contract.TitleOrient
                  | doc m%"
                  The orientation of the title relative to the chart. One of `"top"` (the default), `"bottom"`, `"left"`, or `"right"`.
                  "%
                  | optional,
                style
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  A [mark style property](config.html#style) to apply to the title text mark.
                  
                  __Default value:__ `"group-title"`.
                  "%
                  | optional,
              },
          TitleOrient = std.contract.Sequence
              [ std.enum.TagOrString, [| 'right, 'left, 'bottom, 'top |] ],
          TitleParams = {
                anchor
                  | definitions.contract.Anchor
                  | doc m%"
                  The anchor position for placing the title. One of `"start"`, `"middle"`, or `"end"`. For example, with an orientation of top these anchor positions map to a left-, center-, or right-aligned title.
                  
                  __Default value:__ `"middle"` for [single](spec.html) and [layered](layer.html) views.
                  `"start"` for other composite views.
                  
                  __Note:__ [For now](https://github.com/vega/vega-lite/issues/2875), `anchor` is only customizable only for [single](spec.html) and [layered](layer.html) views.  For other composite views, `anchor` is always `"start"`.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The orthogonal offset in pixels by which to displace the title from its position along the edge of the chart.
                  "%
                  | optional,
                orient
                  | definitions.contract.TitleOrient
                  | doc m%"
                  The orientation of the title relative to the chart. One of `"top"` (the default), `"bottom"`, `"left"`, or `"right"`.
                  "%
                  | optional,
                style
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    predicates.allOf
                    [
                      predicates.isType '"Array",
                      predicates.arrays.arrayOf (predicates.isType '"String")
                    ]
                  ])
                  | doc m%"
                  A [mark style property](config.html#style) to apply to the title text mark.
                  
                  __Default value:__ `"group-title"`.
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  The title text.
                  "%,
              },
          "TopLevel<FacetSpec>" = {
                "$schema"
                  | String
                  | doc m%"
                  URL to [JSON schema](http://json-schema.org/) for a Vega-Lite specification. Unless you have a reason to change this, use `https://vega.github.io/schema/vega-lite/v2.json`. Setting the `$schema` property allows automatic validation and autocomplete in editors that support JSON schema.
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                config
                  | definitions.contract.Config
                  | doc m%"
                  Vega-Lite configuration object.  This property can only be defined at the top-level of a specification.
                  "%
                  | optional,
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                facet
                  | definitions.contract.FacetMapping
                  | doc m%"
                  An object that describes mappings between `row` and `column` channels and their field definitions.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for facets.
                  "%
                  | optional,
                spec
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.LayerSpec,
                    definitions.predicate.CompositeUnitSpec
                  ])
                  | doc m%"
                  A specification of the view that gets faceted.
                  "%,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          "TopLevel<FacetedUnitSpec>" = {
                "$schema"
                  | String
                  | doc m%"
                  URL to [JSON schema](http://json-schema.org/) for a Vega-Lite specification. Unless you have a reason to change this, use `https://vega.github.io/schema/vega-lite/v2.json`. Setting the `$schema` property allows automatic validation and autocomplete in editors that support JSON schema.
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                config
                  | definitions.contract.Config
                  | doc m%"
                  Vega-Lite configuration object.  This property can only be defined at the top-level of a specification.
                  "%
                  | optional,
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                encoding
                  | definitions.contract.EncodingWithFacet
                  | doc m%"
                  A key-value mapping between encoding channels and definition of fields.
                  "%,
                height
                  | Number
                  | doc m%"
                  The height of a visualization.
                  
                  __Default value:__
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its y-channel has a [continuous scale](scale.html#continuous), the height will be the value of [`config.view.height`](spec.html#config).
                  - For y-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the height is [determined by the range step, paddings, and the cardinality of the field mapped to y-channel](scale.html#band). Otherwise, if the `rangeStep` is `null`, the height will be the value of [`config.view.height`](spec.html#config).
                  - If no field is mapped to `y` channel, the `height` will be the value of `rangeStep`.
                  
                  __Note__: For plots with [`row` and `column` channels](encoding.html#facet), this represents the height of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
                mark
                  | definitions.contract.AnyMark
                  | doc m%"
                  A string describing the mark type (one of `"bar"`, `"circle"`, `"square"`, `"tick"`, `"line"`,
                  `"area"`, `"point"`, `"rule"`, and `"text"`) or a [mark definition object](mark.html#mark-def).
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                selection
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record {  } {  } true
                    definitions.predicate.SelectionDef
                  ])
                  | doc m%"
                  A key-value mapping between selection names and definitions.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width of a visualization.
                  
                  __Default value:__ This will be determined by the following rules:
                  
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its x-channel has a [continuous scale](scale.html#continuous), the width will be the value of [`config.view.width`](spec.html#config).
                  - For x-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the width is [determined by the range step, paddings, and the cardinality of the field mapped to x-channel](scale.html#band).   Otherwise, if the `rangeStep` is `null`, the width will be the value of [`config.view.width`](spec.html#config).
                  - If no field is mapped to `x` channel, the `width` will be the value of [`config.scale.textXRangeStep`](size.html#default-width-and-height) for `text` mark and the value of `rangeStep` for other marks.
                  
                  __Note:__ For plots with [`row` and `column` channels](encoding.html#facet), this represents the width of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
              },
          "TopLevel<HConcatSpec>" = {
                "$schema"
                  | String
                  | doc m%"
                  URL to [JSON schema](http://json-schema.org/) for a Vega-Lite specification. Unless you have a reason to change this, use `https://vega.github.io/schema/vega-lite/v2.json`. Setting the `$schema` property allows automatic validation and autocomplete in editors that support JSON schema.
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                config
                  | definitions.contract.Config
                  | doc m%"
                  Vega-Lite configuration object.  This property can only be defined at the top-level of a specification.
                  "%
                  | optional,
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                hconcat
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Spec
                  ])
                  | doc m%"
                  A list of views that should be concatenated and put into a row.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for horizontally concatenated charts.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          "TopLevel<LayerSpec>" = {
                "$schema"
                  | String
                  | doc m%"
                  URL to [JSON schema](http://json-schema.org/) for a Vega-Lite specification. Unless you have a reason to change this, use `https://vega.github.io/schema/vega-lite/v2.json`. Setting the `$schema` property allows automatic validation and autocomplete in editors that support JSON schema.
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                config
                  | definitions.contract.Config
                  | doc m%"
                  Vega-Lite configuration object.  This property can only be defined at the top-level of a specification.
                  "%
                  | optional,
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                height
                  | Number
                  | doc m%"
                  The height of a visualization.
                  
                  __Default value:__
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its y-channel has a [continuous scale](scale.html#continuous), the height will be the value of [`config.view.height`](spec.html#config).
                  - For y-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the height is [determined by the range step, paddings, and the cardinality of the field mapped to y-channel](scale.html#band). Otherwise, if the `rangeStep` is `null`, the height will be the value of [`config.view.height`](spec.html#config).
                  - If no field is mapped to `y` channel, the `height` will be the value of `rangeStep`.
                  
                  __Note__: For plots with [`row` and `column` channels](encoding.html#facet), this represents the height of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
                layer
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf
                    (predicates.anyOf
                    [
                      definitions.predicate.LayerSpec,
                      definitions.predicate.CompositeUnitSpec
                    ])
                  ])
                  | doc m%"
                  Layer or single view specifications to be layered.
                  
                  __Note__: Specifications inside `layer` cannot use `row` and `column` channels as layering facet specifications is not allowed.
                  "%,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for layers.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The width of a visualization.
                  
                  __Default value:__ This will be determined by the following rules:
                  
                  - If a view's [`autosize`](size.html#autosize) type is `"fit"` or its x-channel has a [continuous scale](scale.html#continuous), the width will be the value of [`config.view.width`](spec.html#config).
                  - For x-axis with a band or point scale: if [`rangeStep`](scale.html#band) is a numeric value or unspecified, the width is [determined by the range step, paddings, and the cardinality of the field mapped to x-channel](scale.html#band).   Otherwise, if the `rangeStep` is `null`, the width will be the value of [`config.view.width`](spec.html#config).
                  - If no field is mapped to `x` channel, the `width` will be the value of [`config.scale.textXRangeStep`](size.html#default-width-and-height) for `text` mark and the value of `rangeStep` for other marks.
                  
                  __Note:__ For plots with [`row` and `column` channels](encoding.html#facet), this represents the width of a single view.
                  
                  __See also:__ The documentation for [width and height](size.html) contains more examples.
                  "%
                  | optional,
              },
          "TopLevel<RepeatSpec>" = {
                "$schema"
                  | String
                  | doc m%"
                  URL to [JSON schema](http://json-schema.org/) for a Vega-Lite specification. Unless you have a reason to change this, use `https://vega.github.io/schema/vega-lite/v2.json`. Setting the `$schema` property allows automatic validation and autocomplete in editors that support JSON schema.
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                config
                  | definitions.contract.Config
                  | doc m%"
                  Vega-Lite configuration object.  This property can only be defined at the top-level of a specification.
                  "%
                  | optional,
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                repeat
                  | definitions.contract.Repeat
                  | doc m%"
                  An object that describes what fields should be repeated into views that are laid out as a `row` or `column`.
                  "%,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale and legend resolutions for repeated charts.
                  "%
                  | optional,
                spec | definitions.contract.Spec,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
              },
          "TopLevel<VConcatSpec>" = {
                "$schema"
                  | String
                  | doc m%"
                  URL to [JSON schema](http://json-schema.org/) for a Vega-Lite specification. Unless you have a reason to change this, use `https://vega.github.io/schema/vega-lite/v2.json`. Setting the `$schema` property allows automatic validation and autocomplete in editors that support JSON schema.
                  "%
                  | optional,
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                config
                  | definitions.contract.Config
                  | doc m%"
                  Vega-Lite configuration object.  This property can only be defined at the top-level of a specification.
                  "%
                  | optional,
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for vertically concatenated charts.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                vconcat
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Spec
                  ])
                  | doc m%"
                  A list of views that should be concatenated and put into a column.
                  "%,
              },
          TopLevelExtendedSpec = predicates.contract_from_predicate
              definitions.predicate.TopLevelExtendedSpec,
          TopLevelProperties = {
                autosize
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.AutosizeType,
                    definitions.predicate.AutoSizeParams
                  ])
                  | doc m%"
                  Sets how the visualization size should be determined. If a string, should be one of `"pad"`, `"fit"` or `"none"`.
                  Object values can additionally specify parameters for content sizing and automatic resizing.
                  `"fit"` is only supported for single and layered views that don't use `rangeStep`.
                  
                  __Default value__: `pad`
                  "%
                  | optional,
                background
                  | String
                  | doc m%"
                  CSS color property to use as the background of visualization.
                  
                  __Default value:__ none (transparent)
                  "%
                  | optional,
                padding
                  | definitions.contract.Padding
                  | doc m%"
                  The default visualization padding, in pixels, from the edge of the visualization canvas to the data rectangle.  If a number, specifies padding for all sides.
                  If an object, the value should have the format `{"left": 5, "top": 5, "right": 5, "bottom": 5}` to specify padding for each side of the visualization.
                  
                  __Default value__: `5`
                  "%
                  | optional,
              },
          TopoDataFormat = {
                feature
                  | String
                  | doc m%"
                  The name of the TopoJSON object set to convert to a GeoJSON feature collection.
                  For example, in a map of the world, there may be an object set named `"countries"`.
                  Using the feature property, we can extract this set and generate a GeoJSON feature object for each country.
                  "%
                  | optional,
                mesh
                  | String
                  | doc m%"
                  The name of the TopoJSON object set to convert to mesh.
                  Similar to the `feature` option, `mesh` extracts a named TopoJSON object set.
                    Unlike the `feature` option, the corresponding geo data is returned as a single, unified mesh instance, not as individual GeoJSON features.
                  Extracting a mesh is useful for more efficiently drawing borders or other geographic elements that you do not need to associate with specific regions such as individual countries, states or counties.
                  "%
                  | optional,
                parse
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.allOf
                    [ predicates.isType '"String", predicates.enum [ "auto" ] ],
                    predicates.isType 'Record
                  ])
                  | doc m%%"
                  If set to auto (the default), perform automatic type inference to determine the desired data types.
                  Alternatively, a parsing directive object can be provided for explicit data types. Each property of the object corresponds to a field name, and the value to the desired data type (one of `"number"`, `"boolean"` or `"date"`).
                  For example, `"parse": {"modified_on": "date"}` parses the `modified_on` field in each input record a Date value.
                  
                  For `"date"`, we parse data based using Javascript's [`Date.parse()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse).
                  For Specific date formats can be provided (e.g., `{foo: 'date:"%m%d%Y"'}`), using the [d3-time-format syntax](https://github.com/d3/d3-time-format#locale_format). UTC date format parsing is supported similarly (e.g., `{foo: 'utc:"%m%d%Y"'}`). See more about [UTC time](timeunit.html#utc)
                  "%%
                  | optional,
                type
                  | std.enum.TagOrString
                  | [| 'topojson |]
                  | doc m%"
                  Type of input data: `"json"`, `"csv"`, `"tsv"`.
                  The default format type is determined by the extension of the file URL.
                  If no extension is detected, `"json"` will be used by default.
                  "%
                  | optional,
              },
          Transform = predicates.contract_from_predicate
              definitions.predicate.Transform,
          Type
            | doc m%"
            Constants and utilities for data type  
             Data type based on level of measurement 
            "%
            = std.contract.Sequence
              [
                std.enum.TagOrString,
                [| 'nominal, 'temporal, 'ordinal, 'quantitative |]
              ],
          UrlData = {
                format
                  | definitions.contract.DataFormat
                  | doc m%"
                  An object that specifies the format for parsing the data file.
                  "%
                  | optional,
                url
                  | String
                  | doc m%"
                  An URL from which to load the data set. Use the `format.type` property
                  to ensure the loaded data is correctly parsed.
                  "%,
              },
          UtcMultiTimeUnit = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'utcsecondsmilliseconds,
                  'utcminutesseconds,
                  'utchoursminutesseconds,
                  'utchoursminutes,
                  'utcmonthdate,
                  'utcquartermonth,
                  'utcyearmonthdatehoursminutesseconds,
                  'utcyearmonthdatehoursminutes,
                  'utcyearmonthdatehours,
                  'utcyearmonthdate,
                  'utcyearmonth,
                  'utcyearquartermonth,
                  'utcyearquarter
                |]
              ],
          UtcSingleTimeUnit = std.contract.Sequence
              [
                std.enum.TagOrString,
                [|
                  'utcmilliseconds,
                  'utcseconds,
                  'utcminutes,
                  'utchours,
                  'utcdate,
                  'utcday,
                  'utcmonth,
                  'utcquarter,
                  'utcyear
                |]
              ],
          VConcatSpec = {
                data
                  | definitions.contract.Data
                  | doc m%"
                  An object describing the data source
                  "%
                  | optional,
                description
                  | String
                  | doc m%"
                  Description of this mark for commenting purpose.
                  "%
                  | optional,
                name
                  | String
                  | doc m%"
                  Name of the visualization for later reference.
                  "%
                  | optional,
                resolve
                  | definitions.contract.Resolve
                  | doc m%"
                  Scale, axis, and legend resolutions for vertically concatenated charts.
                  "%
                  | optional,
                title
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"String",
                    definitions.predicate.TitleParams
                  ])
                  | doc m%"
                  Title for the plot.
                  "%
                  | optional,
                transform
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Transform
                  ])
                  | doc m%"
                  An array of data transformations such as filter and new field calculation.
                  "%
                  | optional,
                vconcat
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf definitions.predicate.Spec
                  ])
                  | doc m%"
                  A list of views that should be concatenated and put into a column.
                  "%,
              },
          VLOnlyConfig = {
                countTitle
                  | String
                  | doc m%"
                  Default axis and legend title for count fields.
                  
                  __Default value:__ `'Number of Records'`.
                  "%
                  | optional,
                fieldTitle
                  | std.enum.TagOrString
                  | [| 'plain, 'functional, 'verbal |]
                  | doc m%"
                  Defines how Vega-Lite generates title for fields.  There are three possible styles:
                  - `"verbal"` (Default) - displays function in a verbal style (e.g., "Sum of field", "Year-month of date", "field (binned)").
                  - `"function"` - displays function using parentheses and capitalized texts (e.g., "SUM(field)", "YEARMONTH(date)", "BIN(field)").
                  - `"plain"` - displays only the field name without functions (e.g., "field", "date", "field").
                  "%
                  | optional,
                invalidValues
                  | std.enum.TagOrString
                  | [| 'filter |]
                  | doc m%"
                  Defines how Vega-Lite should handle invalid values (`null` and `NaN`).
                  - If set to `"filter"` (default), all data items with null values are filtered.
                  - If `null`, all data items are included. In this case, invalid values will be interpreted as zeroes.
                  "%
                  | optional,
                numberFormat
                  | String
                  | doc m%"
                  D3 Number format for axis labels and text tables. For example "s" for SI units. Use [D3's number format pattern](https://github.com/d3/d3-format#locale_format).
                  "%
                  | optional,
                scale
                  | definitions.contract.ScaleConfig
                  | doc m%"
                  Scale configuration determines default properties for all [scales](scale.html). For a full list of scale configuration options, please see the [corresponding section of the scale documentation](scale.html#config).
                  "%
                  | optional,
                selection
                  | definitions.contract.SelectionConfig
                  | doc m%"
                  An object hash for defining default properties for each type of selections. 
                  "%
                  | optional,
                stack
                  | definitions.contract.StackOffset
                  | doc m%"
                  Default stack offset for stackable mark. 
                  "%
                  | optional,
                timeFormat
                  | String
                  | doc m%"
                  Default datetime format for axis and legend labels. The format can be set directly on each axis and legend. Use [D3's time format pattern](https://github.com/d3/d3-time-format#locale_format).
                  
                  __Default value:__ `'%b %d, %Y'`.
                  "%
                  | optional,
                view
                  | definitions.contract.ViewConfig
                  | doc m%"
                  Default properties for [single view plots](spec.html#single). 
                  "%
                  | optional,
              },
          ValueDef
            | doc m%"
            Definition object for a constant value of an encoding channel.
            "%
            = {
                value
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Number",
                    predicates.isType '"String",
                    predicates.isType '"Bool"
                  ])
                  | doc m%"
                  A constant value in visual domain (e.g., `"red"` / "#0099ff" for color, values between `0` to `1` for opacity).
                  "%,
              },
          VerticalAlign = std.contract.Sequence
              [ std.enum.TagOrString, [| 'bottom, 'middle, 'top |] ],
          VgAxisBase
            | doc m%"
            Base object for Vega's Axis and Axis Config.
            All of these properties are both properties of Vega's Axis and Axis Config.
            "%
            = {
                domain
                  | Bool
                  | doc m%"
                  A boolean flag indicating if the domain (the axis baseline) should be included as part of the axis.
                  
                  __Default value:__ `true`
                  "%
                  | optional,
                grid
                  | Bool
                  | doc m%"
                  A boolean flag indicating if grid lines should be included as part of the axis
                  
                  __Default value:__ `true` for [continuous scales](scale.html#continuous) that are not binned; otherwise, `false`.
                  "%
                  | optional,
                labelAngle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum (-360)
                  ])
                  | doc m%"
                  The rotation angle of the axis labels.
                  
                  __Default value:__ `-90` for nominal and ordinal fields; `0` otherwise.
                  "%
                  | optional,
                labelBound
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if labels should be hidden if they exceed the axis range. If `false `(the default) no bounds overlap analysis is performed. If `true`, labels will be hidden if they exceed the axis range by more than 1 pixel. If this property is a number, it specifies the pixel tolerance: the maximum amount by which a label bounding box may exceed the axis range.
                  
                  __Default value:__ `false`.
                  "%
                  | optional,
                labelFlush
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if the first and last axis labels should be aligned flush with the scale range. Flush alignment for a horizontal axis will left-align the first label and right-align the last label. For vertical axes, bottom and top text baselines are applied instead. If this property is a number, it also indicates the number of pixels by which to offset the first and last labels; for example, a value of 2 will flush-align the first and last labels and also push them 2 pixels outward from the center of the axis. The additional adjustment can sometimes help the labels better visually group with corresponding axis ticks.
                  
                  __Default value:__ `true` for axis of a continuous x-scale. Otherwise, `false`.
                  "%
                  | optional,
                labelOverlap
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "parity" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "greedy" ]
                    ]
                  ])
                  | doc m%"
                  The strategy to use for resolving overlap of axis labels. If `false` (the default), no overlap reduction is attempted. If set to `true` or `"parity"`, a strategy of removing every other label is used (this works well for standard linear axes). If set to `"greedy"`, a linear scan of the labels is performed, removing any labels that overlaps with the last visible label (this often works better for log-scaled axes).
                  
                  __Default value:__ `true` for non-nominal fields with non-log scales; `"greedy"` for log scales; otherwise `false`.
                  "%
                  | optional,
                labelPadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between axis and text labels.
                  "%
                  | optional,
                labels
                  | Bool
                  | doc m%"
                  A boolean flag indicating if labels should be included as part of the axis.
                  
                  __Default value:__  `true`.
                  "%
                  | optional,
                maxExtent
                  | Number
                  | doc m%"
                  The maximum extent in pixels that axis ticks and labels should use. This determines a maximum offset value for axis titles.
                  
                  __Default value:__ `undefined`.
                  "%
                  | optional,
                minExtent
                  | Number
                  | doc m%"
                  The minimum extent in pixels that axis ticks and labels should use. This determines a minimum offset value for axis titles.
                  
                  __Default value:__ `30` for y-axis; `undefined` for x-axis.
                  "%
                  | optional,
                tickSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size in pixels of axis ticks.
                  "%
                  | optional,
                ticks
                  | Bool
                  | doc m%"
                  Boolean value that determines whether the axis should include ticks.
                  "%
                  | optional,
                titleMaxLength
                  | Number
                  | doc m%"
                  Max length for axis title if the title is automatically generated from the field's description.
                  "%
                  | optional,
                titlePadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between title and axis.
                  "%
                  | optional,
              },
          VgAxisConfig = {
                bandPosition
                  | Number
                  | doc m%"
                  An interpolation fraction indicating where, for `band` scales, axis ticks should be positioned. A value of `0` places ticks at the left edge of their bands. A value of `0.5` places ticks in the middle of their bands.
                  "%
                  | optional,
                domain
                  | Bool
                  | doc m%"
                  A boolean flag indicating if the domain (the axis baseline) should be included as part of the axis.
                  
                  __Default value:__ `true`
                  "%
                  | optional,
                domainColor
                  | String
                  | doc m%"
                  Color of axis domain line.
                  
                  __Default value:__  (none, using Vega default).
                  "%
                  | optional,
                domainWidth
                  | Number
                  | doc m%"
                  Stroke width of axis domain line
                  
                  __Default value:__  (none, using Vega default).
                  "%
                  | optional,
                grid
                  | Bool
                  | doc m%"
                  A boolean flag indicating if grid lines should be included as part of the axis
                  
                  __Default value:__ `true` for [continuous scales](scale.html#continuous) that are not binned; otherwise, `false`.
                  "%
                  | optional,
                gridColor
                  | String
                  | doc m%"
                  Color of gridlines.
                  "%
                  | optional,
                gridDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the grid dash array.
                  "%
                  | optional,
                gridOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity of grid (value between [0,1])
                  
                  __Default value:__ (`1` by default)
                  "%
                  | optional,
                gridWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The grid width, in pixels.
                  "%
                  | optional,
                labelAngle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum (-360)
                  ])
                  | doc m%"
                  The rotation angle of the axis labels.
                  
                  __Default value:__ `-90` for nominal and ordinal fields; `0` otherwise.
                  "%
                  | optional,
                labelBound
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if labels should be hidden if they exceed the axis range. If `false `(the default) no bounds overlap analysis is performed. If `true`, labels will be hidden if they exceed the axis range by more than 1 pixel. If this property is a number, it specifies the pixel tolerance: the maximum amount by which a label bounding box may exceed the axis range.
                  
                  __Default value:__ `false`.
                  "%
                  | optional,
                labelColor
                  | String
                  | doc m%"
                  The color of the tick label, can be in hex color code or regular color name.
                  "%
                  | optional,
                labelFlush
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"Bool", predicates.isType '"Number" ])
                  | doc m%"
                  Indicates if the first and last axis labels should be aligned flush with the scale range. Flush alignment for a horizontal axis will left-align the first label and right-align the last label. For vertical axes, bottom and top text baselines are applied instead. If this property is a number, it also indicates the number of pixels by which to offset the first and last labels; for example, a value of 2 will flush-align the first and last labels and also push them 2 pixels outward from the center of the axis. The additional adjustment can sometimes help the labels better visually group with corresponding axis ticks.
                  
                  __Default value:__ `true` for axis of a continuous x-scale. Otherwise, `false`.
                  "%
                  | optional,
                labelFont
                  | String
                  | doc m%"
                  The font of the tick label.
                  "%
                  | optional,
                labelFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size of the label, in pixels.
                  "%
                  | optional,
                labelLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis tick labels.
                  "%
                  | optional,
                labelOverlap
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    predicates.isType '"Bool",
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "parity" ]
                    ],
                    predicates.allOf
                    [
                      predicates.isType '"String",
                      predicates.enum [ "greedy" ]
                    ]
                  ])
                  | doc m%"
                  The strategy to use for resolving overlap of axis labels. If `false` (the default), no overlap reduction is attempted. If set to `true` or `"parity"`, a strategy of removing every other label is used (this works well for standard linear axes). If set to `"greedy"`, a linear scan of the labels is performed, removing any labels that overlaps with the last visible label (this often works better for log-scaled axes).
                  
                  __Default value:__ `true` for non-nominal fields with non-log scales; `"greedy"` for log scales; otherwise `false`.
                  "%
                  | optional,
                labelPadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between axis and text labels.
                  "%
                  | optional,
                labels
                  | Bool
                  | doc m%"
                  A boolean flag indicating if labels should be included as part of the axis.
                  
                  __Default value:__  `true`.
                  "%
                  | optional,
                maxExtent
                  | Number
                  | doc m%"
                  The maximum extent in pixels that axis ticks and labels should use. This determines a maximum offset value for axis titles.
                  
                  __Default value:__ `undefined`.
                  "%
                  | optional,
                minExtent
                  | Number
                  | doc m%"
                  The minimum extent in pixels that axis ticks and labels should use. This determines a minimum offset value for axis titles.
                  
                  __Default value:__ `30` for y-axis; `undefined` for x-axis.
                  "%
                  | optional,
                tickColor
                  | String
                  | doc m%"
                  The color of the axis's tick.
                  "%
                  | optional,
                tickRound
                  | Bool
                  | doc m%"
                  Boolean flag indicating if pixel position values should be rounded to the nearest integer.
                  "%
                  | optional,
                tickSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size in pixels of axis ticks.
                  "%
                  | optional,
                tickWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width, in pixels, of ticks.
                  "%
                  | optional,
                ticks
                  | Bool
                  | doc m%"
                  Boolean value that determines whether the axis should include ticks.
                  "%
                  | optional,
                titleAlign
                  | String
                  | doc m%"
                  Horizontal text alignment of axis titles.
                  "%
                  | optional,
                titleAngle
                  | Number
                  | doc m%"
                  Angle in degrees of axis titles.
                  "%
                  | optional,
                titleBaseline
                  | String
                  | doc m%"
                  Vertical text baseline for axis titles.
                  "%
                  | optional,
                titleColor
                  | String
                  | doc m%"
                  Color of the title, can be in hex color code or regular color name.
                  "%
                  | optional,
                titleFont
                  | String
                  | doc m%"
                  Font of the title. (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                titleFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Font size of the title.
                  "%
                  | optional,
                titleFontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  Font weight of the title. (e.g., `"bold"`).
                  "%
                  | optional,
                titleLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis titles.
                  "%
                  | optional,
                titleMaxLength
                  | Number
                  | doc m%"
                  Max length for axis title if the title is automatically generated from the field's description.
                  "%
                  | optional,
                titlePadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between title and axis.
                  "%
                  | optional,
                titleX
                  | Number
                  | doc m%"
                  X-coordinate of the axis title relative to the axis group.
                  "%
                  | optional,
                titleY
                  | Number
                  | doc m%"
                  Y-coordinate of the axis title relative to the axis group.
                  "%
                  | optional,
              },
          VgBinding = predicates.contract_from_predicate
              definitions.predicate.VgBinding,
          VgCheckboxBinding = {
                element | String | optional,
                input | std.enum.TagOrString | [| 'checkbox |],
              },
          VgEventStream = predicates.contract_from_predicate
              definitions.predicate.VgEventStream,
          VgGenericBinding = { element | String | optional, input | String, },
          VgLegendBase = {
                entryPadding
                  | Number
                  | doc m%"
                  Padding (in pixels) between legend entries in a symbol legend.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The offset, in pixels, by which to displace the legend from the edge of the enclosing group or data rectangle.
                  
                  __Default value:__  `0`
                  "%
                  | optional,
                orient
                  | definitions.contract.LegendOrient
                  | doc m%"
                  The orientation of the legend, which determines how the legend is positioned within the scene. One of "left", "right", "top-left", "top-right", "bottom-left", "bottom-right", "none".
                  
                  __Default value:__ `"right"`
                  "%
                  | optional,
                padding
                  | Number
                  | doc m%"
                  The padding, in pixels, between the legend and axis.
                  "%
                  | optional,
              },
          VgLegendConfig = {
                cornerRadius
                  | Number
                  | doc m%"
                  Corner radius for the full legend.
                  "%
                  | optional,
                entryPadding
                  | Number
                  | doc m%"
                  Padding (in pixels) between legend entries in a symbol legend.
                  "%
                  | optional,
                fillColor
                  | String
                  | doc m%"
                  Background fill color for the full legend.
                  "%
                  | optional,
                gradientHeight
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The height of the gradient, in pixels.
                  "%
                  | optional,
                gradientLabelBaseline
                  | String
                  | doc m%"
                  Text baseline for color ramp gradient labels.
                  "%
                  | optional,
                gradientLabelLimit
                  | Number
                  | doc m%"
                  The maximum allowed length in pixels of color ramp gradient labels.
                  "%
                  | optional,
                gradientLabelOffset
                  | Number
                  | doc m%"
                  Vertical offset in pixels for color ramp gradient labels.
                  "%
                  | optional,
                gradientStrokeColor
                  | String
                  | doc m%"
                  The color of the gradient stroke, can be in hex color code or regular color name.
                  "%
                  | optional,
                gradientStrokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the gradient stroke, in pixels.
                  "%
                  | optional,
                gradientWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the gradient, in pixels.
                  "%
                  | optional,
                labelAlign
                  | String
                  | doc m%"
                  The alignment of the legend label, can be left, middle or right.
                  "%
                  | optional,
                labelBaseline
                  | String
                  | doc m%"
                  The position of the baseline of legend label, can be top, middle or bottom.
                  "%
                  | optional,
                labelColor
                  | String
                  | doc m%"
                  The color of the legend label, can be in hex color code or regular color name.
                  "%
                  | optional,
                labelFont
                  | String
                  | doc m%"
                  The font of the legend label.
                  "%
                  | optional,
                labelFontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size of legend label.
                  
                  __Default value:__ `10`.
                  "%
                  | optional,
                labelLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis tick labels.
                  "%
                  | optional,
                labelOffset
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The offset of the legend label.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  The offset, in pixels, by which to displace the legend from the edge of the enclosing group or data rectangle.
                  
                  __Default value:__  `0`
                  "%
                  | optional,
                orient
                  | definitions.contract.LegendOrient
                  | doc m%"
                  The orientation of the legend, which determines how the legend is positioned within the scene. One of "left", "right", "top-left", "top-right", "bottom-left", "bottom-right", "none".
                  
                  __Default value:__ `"right"`
                  "%
                  | optional,
                padding
                  | Number
                  | doc m%"
                  The padding, in pixels, between the legend and axis.
                  "%
                  | optional,
                strokeColor
                  | String
                  | doc m%"
                  Border stroke color for the full legend.
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  Border stroke dash pattern for the full legend.
                  "%
                  | optional,
                strokeWidth
                  | Number
                  | doc m%"
                  Border stroke width for the full legend.
                  "%
                  | optional,
                symbolColor
                  | String
                  | doc m%"
                  The color of the legend symbol,
                  "%
                  | optional,
                symbolSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The size of the legend symbol, in pixels.
                  "%
                  | optional,
                symbolStrokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The width of the symbol's stroke.
                  "%
                  | optional,
                symbolType
                  | String
                  | doc m%"
                  Default shape type (such as "circle") for legend symbols.
                  "%
                  | optional,
                titleAlign
                  | String
                  | doc m%"
                  Horizontal text alignment for legend titles.
                  "%
                  | optional,
                titleBaseline
                  | String
                  | doc m%"
                  Vertical text baseline for legend titles.
                  "%
                  | optional,
                titleColor
                  | String
                  | doc m%"
                  The color of the legend title, can be in hex color code or regular color name.
                  "%
                  | optional,
                titleFont
                  | String
                  | doc m%"
                  The font of the legend title.
                  "%
                  | optional,
                titleFontSize
                  | Number
                  | doc m%"
                  The font size of the legend title.
                  "%
                  | optional,
                titleFontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [ predicates.isType '"String", predicates.isType '"Number" ])
                  | doc m%"
                  The font weight of the legend title.
                  "%
                  | optional,
                titleLimit
                  | Number
                  | doc m%"
                  Maximum allowed pixel width of axis titles.
                  "%
                  | optional,
                titlePadding
                  | Number
                  | doc m%"
                  The padding, in pixels, between title and legend.
                  "%
                  | optional,
              },
          VgMarkConfig = {
                align
                  | definitions.contract.HorizontalAlign
                  | doc m%"
                  The horizontal alignment of the text. One of `"left"`, `"right"`, `"center"`.
                  "%
                  | optional,
                angle
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 360,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The rotation angle of the text, in degrees.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  The vertical alignment of the text. One of `"top"`, `"middle"`, `"bottom"`.
                  
                  __Default value:__ `"middle"`
                  "%
                  | optional,
                dx
                  | Number
                  | doc m%"
                  The horizontal offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                dy
                  | Number
                  | doc m%"
                  The vertical offset, in pixels, between the text label and its anchor point. The offset is applied after rotation by the _angle_ property.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  Default Fill Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                fillOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  The typeface to set the text in (e.g., `"Helvetica Neue"`).
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The font size, in pixels.
                  "%
                  | optional,
                fontStyle
                  | definitions.contract.FontStyle
                  | doc m%"
                  The font style (e.g., `"italic"`).
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  The font weight (e.g., `"bold"`).
                  "%
                  | optional,
                interpolate
                  | definitions.contract.Interpolate
                  | doc m%"
                  The line interpolation method to use for line and area marks. One of the following:
                  - `"linear"`: piecewise linear segments, as in a polyline.
                  - `"linear-closed"`: close the linear segments to form a polygon.
                  - `"step"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"step-before"`: alternate between vertical and horizontal segments, as in a step function.
                  - `"step-after"`: alternate between horizontal and vertical segments, as in a step function.
                  - `"basis"`: a B-spline, with control point duplication on the ends.
                  - `"basis-open"`: an open B-spline; may not intersect the start or end.
                  - `"basis-closed"`: a closed B-spline, as in a loop.
                  - `"cardinal"`: a Cardinal spline, with control point duplication on the ends.
                  - `"cardinal-open"`: an open Cardinal spline; may not intersect the start or end, but will intersect other control points.
                  - `"cardinal-closed"`: a closed Cardinal spline, as in a loop.
                  - `"bundle"`: equivalent to basis, except the tension parameter is used to straighten the spline.
                  - `"monotone"`: cubic interpolation that preserves monotonicity in y.
                  "%
                  | optional,
                limit
                  | Number
                  | doc m%"
                  The maximum length of the text mark in pixels (default 0, indicating no limit). The text value will be automatically truncated if the rendered size exceeds the limit.
                  "%
                  | optional,
                opacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The overall opacity (value between [0,1]).
                  
                  __Default value:__ `0.7` for non-aggregate plots with `point`, `tick`, `circle`, or `square` marks or layered `bar` charts and `1` otherwise.
                  "%
                  | optional,
                orient
                  | definitions.contract.Orient
                  | doc m%"
                  The orientation of a non-stacked bar, tick, area, and line charts.
                  The value is either horizontal (default) or vertical.
                  - For bar, rule and tick, this determines whether the size of the bar and tick
                  should be applied to x or y dimension.
                  - For area, this property determines the orient property of the Vega output.
                  - For line, this property determines the sort order of the points in the line
                  if `config.sortLineBy` is not specified.
                  For stacked charts, this is always determined by the orientation of the stack;
                  therefore explicitly specified value will be ignored.
                  "%
                  | optional,
                radius
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Polar coordinate radial offset, in pixels, of the text label from the origin determined by the `x` and `y` properties.
                  "%
                  | optional,
                shape
                  | String
                  | doc m%"
                  The default symbol shape to use. One of: `"circle"` (default), `"square"`, `"cross"`, `"diamond"`, `"triangle-up"`, or `"triangle-down"`, or a custom SVG path.
                  
                  __Default value:__ `"circle"`
                  "%
                  | optional,
                size
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The pixel area each the point/circle/square.
                  For example: in the case of circles, the radius is determined in part by the square root of the size value.
                  
                  __Default value:__ `30`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  Default Stroke Color.  This has higher precedence than config.color
                  
                  __Default value:__ (None)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  "%
                  | optional,
                strokeOpacity
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ `1`
                  "%
                  | optional,
                strokeWidth
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The stroke width, in pixels.
                  "%
                  | optional,
                tension
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Number",
                    predicates.numbers.maximum 1,
                    predicates.numbers.minimum 0
                  ])
                  | doc m%"
                  Depending on the interpolation type, sets the tension parameter (for line and area marks).
                  "%
                  | optional,
                text
                  | String
                  | doc m%"
                  Placeholder text if the `text` channel is not specified
                  "%
                  | optional,
                theta
                  | Number
                  | doc m%"
                  Polar coordinate angle, in radians, of the text label from the origin determined by the `x` and `y` properties. Values for `theta` follow the same convention of `arc` mark `startAngle` and `endAngle` properties: angles are measured in radians, with `0` indicating "north".
                  "%
                  | optional,
              },
          VgRadioBinding = {
                element | String | optional,
                input | std.enum.TagOrString | [| 'radio |],
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          VgRangeBinding = {
                element | String | optional,
                input | std.enum.TagOrString | [| 'range |],
                max | Number | optional,
                min | Number | optional,
                step | Number | optional,
              },
          VgScheme = {
                count | Number | optional,
                extent
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | optional,
                scheme | String,
              },
          VgSelectBinding = {
                element | String | optional,
                input | std.enum.TagOrString | [| 'select |],
                options
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"String")
                  ]),
              },
          VgTitleConfig = {
                anchor
                  | definitions.contract.Anchor
                  | doc m%"
                  The anchor position for placing the title. One of `"start"`, `"middle"`, or `"end"`. For example, with an orientation of top these anchor positions map to a left-, center-, or right-aligned title.
                  
                  __Default value:__ `"middle"` for [single](spec.html) and [layered](layer.html) views.
                  `"start"` for other composite views.
                  
                  __Note:__ [For now](https://github.com/vega/vega-lite/issues/2875), `anchor` is only customizable only for [single](spec.html) and [layered](layer.html) views.  For other composite views, `anchor` is always `"start"`.
                  "%
                  | optional,
                angle
                  | Number
                  | doc m%"
                  Angle in degrees of title text.
                  "%
                  | optional,
                baseline
                  | definitions.contract.VerticalAlign
                  | doc m%"
                  Vertical text baseline for title text.
                  "%
                  | optional,
                color
                  | String
                  | doc m%"
                  Text color for title text.
                  "%
                  | optional,
                font
                  | String
                  | doc m%"
                  Font name for title text.
                  "%
                  | optional,
                fontSize
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  Font size in pixels for title text.
                  
                  __Default value:__ `10`.
                  "%
                  | optional,
                fontWeight
                  | predicates.contract_from_predicate
                  (predicates.anyOf
                  [
                    definitions.predicate.FontWeight,
                    definitions.predicate.FontWeightNumber
                  ])
                  | doc m%"
                  Font weight for title text.
                  "%
                  | optional,
                limit
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [ predicates.isType '"Number", predicates.numbers.minimum 0 ])
                  | doc m%"
                  The maximum allowed length in pixels of legend labels.
                  "%
                  | optional,
                offset
                  | Number
                  | doc m%"
                  Offset in pixels of the title from the chart body and axes.
                  "%
                  | optional,
                orient
                  | definitions.contract.TitleOrient
                  | doc m%"
                  Default title orientation ("top", "bottom", "left", or "right")
                  "%
                  | optional,
              },
          ViewConfig = {
                clip
                  | Bool
                  | doc m%"
                  Whether the view should be clipped.
                  "%
                  | optional,
                fill
                  | String
                  | doc m%"
                  The fill color.
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                fillOpacity
                  | Number
                  | doc m%"
                  The fill opacity (value between [0,1]).
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                height
                  | Number
                  | doc m%"
                  The default height of the single plot or each plot in a trellis plot when the visualization has a continuous (non-ordinal) y-scale with `rangeStep` = `null`.
                  
                  __Default value:__ `200`
                  "%
                  | optional,
                stroke
                  | String
                  | doc m%"
                  The stroke color.
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                strokeDash
                  | predicates.contract_from_predicate
                  (predicates.allOf
                  [
                    predicates.isType '"Array",
                    predicates.arrays.arrayOf (predicates.isType '"Number")
                  ])
                  | doc m%"
                  An array of alternating stroke, space lengths for creating dashed or dotted lines.
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                strokeDashOffset
                  | Number
                  | doc m%"
                  The offset (in pixels) into which to begin drawing with the stroke dash array.
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                strokeOpacity
                  | Number
                  | doc m%"
                  The stroke opacity (value between [0,1]).
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                strokeWidth
                  | Number
                  | doc m%"
                  The stroke width, in pixels.
                  
                  __Default value:__ (none)
                  "%
                  | optional,
                width
                  | Number
                  | doc m%"
                  The default width of the single plot or each plot in a trellis plot when the visualization has a continuous (non-ordinal) x-scale or ordinal x-scale with `rangeStep` = `null`.
                  
                  __Default value:__ `200`
                  "%
                  | optional,
              },
          VlOnlyGuideConfig = {
                shortTimeLabels
                  | Bool
                  | doc m%"
                  Whether month names and weekday names should be abbreviated.
                  
                  __Default value:__  `false`
                  "%
                  | optional,
              },
        },
    predicate = {
          Aggregate = definitions.predicate.AggregateOp,
          AggregateOp = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "argmax",
                  "argmin",
                  "average",
                  "count",
                  "distinct",
                  "max",
                  "mean",
                  "median",
                  "min",
                  "missing",
                  "q1",
                  "q3",
                  "ci0",
                  "ci1",
                  "stdev",
                  "stdevp",
                  "sum",
                  "valid",
                  "values",
                  "variance",
                  "variancep"
                ]
              ],
          AggregateTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "aggregate" ],
                predicates.records.record
                {
                  aggregate = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.AggregatedFieldDef
                      ],
                  groupby = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AggregatedFieldDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "as", "field", "op" ],
                predicates.records.record
                {
                  as = predicates.isType '"String",
                  field = predicates.isType '"String",
                  op = definitions.predicate.AggregateOp,
                }
                {  }
                false
                predicates.never
              ],
          Anchor = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "start", "middle", "end" ]
              ],
          AndFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "and" ],
                predicates.records.record
                {
                  and = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FilterOperand
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AnyMark = predicates.anyOf
              [ definitions.predicate.Mark, definitions.predicate.MarkDef ],
          AutoSizeParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  contains = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "content", "padding" ]
                      ],
                  resize = predicates.isType '"Bool",
                  type = definitions.predicate.AutosizeType,
                }
                {  }
                false
                predicates.never
              ],
          AutosizeType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "pad", "fit", "none" ]
              ],
          Axis = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  domain = predicates.isType '"Bool",
                  format = predicates.isType '"String",
                  grid = predicates.isType '"Bool",
                  labelAngle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum (-360)
                      ],
                  labelBound = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelFlush = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelOverlap = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "parity" ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "greedy" ]
                        ]
                      ],
                  labelPadding = predicates.isType '"Number",
                  labels = predicates.isType '"Bool",
                  maxExtent = predicates.isType '"Number",
                  minExtent = predicates.isType '"Number",
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.AxisOrient,
                  position = predicates.isType '"Number",
                  tickCount = predicates.isType '"Number",
                  tickSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  ticks = predicates.isType '"Bool",
                  title = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  titleMaxLength = predicates.isType '"Number",
                  titlePadding = predicates.isType '"Number",
                  values = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.DateTime
                        ]
                      ],
                  zindex = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          AxisConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bandPosition = predicates.isType '"Number",
                  domain = predicates.isType '"Bool",
                  domainColor = predicates.isType '"String",
                  domainWidth = predicates.isType '"Number",
                  grid = predicates.isType '"Bool",
                  gridColor = predicates.isType '"String",
                  gridDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  gridOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  gridWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelAngle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum (-360)
                      ],
                  labelBound = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelColor = predicates.isType '"String",
                  labelFlush = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelFont = predicates.isType '"String",
                  labelFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelLimit = predicates.isType '"Number",
                  labelOverlap = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "parity" ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "greedy" ]
                        ]
                      ],
                  labelPadding = predicates.isType '"Number",
                  labels = predicates.isType '"Bool",
                  maxExtent = predicates.isType '"Number",
                  minExtent = predicates.isType '"Number",
                  shortTimeLabels = predicates.isType '"Bool",
                  tickColor = predicates.isType '"String",
                  tickRound = predicates.isType '"Bool",
                  tickSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tickWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  ticks = predicates.isType '"Bool",
                  titleAlign = predicates.isType '"String",
                  titleAngle = predicates.isType '"Number",
                  titleBaseline = predicates.isType '"String",
                  titleColor = predicates.isType '"String",
                  titleFont = predicates.isType '"String",
                  titleFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  titleFontWeight = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  titleLimit = predicates.isType '"Number",
                  titleMaxLength = predicates.isType '"Number",
                  titlePadding = predicates.isType '"Number",
                  titleX = predicates.isType '"Number",
                  titleY = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          AxisConfigMixins = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  axis = definitions.predicate.AxisConfig,
                  axisBand = definitions.predicate.VgAxisConfig,
                  axisBottom = definitions.predicate.VgAxisConfig,
                  axisLeft = definitions.predicate.VgAxisConfig,
                  axisRight = definitions.predicate.VgAxisConfig,
                  axisTop = definitions.predicate.VgAxisConfig,
                  axisX = definitions.predicate.VgAxisConfig,
                  axisY = definitions.predicate.VgAxisConfig,
                }
                {  }
                false
                predicates.never
              ],
          AxisOrient = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "top", "right", "left", "bottom" ]
              ],
          AxisResolveMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  x = definitions.predicate.ResolveMode,
                  y = definitions.predicate.ResolveMode,
                }
                {  }
                false
                predicates.never
              ],
          BarConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  binSpacing = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  color = predicates.isType '"String",
                  continuousBandSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  discreteBandSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  filled = predicates.isType '"Bool",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          BaseBin = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  base = predicates.isType '"Number",
                  divide = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number"),
                        predicates.arrays.minItems 1
                      ],
                  maxbins = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 2
                      ],
                  minstep = predicates.isType '"Number",
                  nice = predicates.isType '"Bool",
                  step = predicates.isType '"Number",
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number"),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BaseSelectionDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                }
                {  }
                false
                predicates.never
              ],
          BaseSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BinParams
            | doc m%"
            Binning properties or boolean flag for determining whether to bin data or not.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  base = predicates.isType '"Number",
                  divide = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number"),
                        predicates.arrays.minItems 1
                      ],
                  extent = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number"),
                        predicates.arrays.maxItems 2,
                        predicates.arrays.minItems 2
                      ],
                  maxbins = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 2
                      ],
                  minstep = predicates.isType '"Number",
                  nice = predicates.isType '"Bool",
                  step = predicates.isType '"Number",
                  steps = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number"),
                        predicates.arrays.minItems 1
                      ],
                }
                {  }
                false
                predicates.never
              ],
          BinTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "as", "bin", "field" ],
                predicates.records.record
                {
                  as = predicates.isType '"String",
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          BoxPlotConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  color = predicates.isType '"String",
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  filled = predicates.isType '"Bool",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  size = predicates.isType '"Number",
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          BoxPlotConfigMixins = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  box = definitions.predicate.BoxPlotConfig,
                  boxMid = definitions.predicate.MarkConfig,
                  boxWhisker = definitions.predicate.MarkConfig,
                }
                {  }
                false
                predicates.never
              ],
          BrushConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.isType '"Number",
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.isType '"Number",
                  strokeWidth = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          CalculateTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "as", "calculate" ],
                predicates.records.record
                {
                  as = predicates.isType '"String",
                  calculate = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          CompositeMarkConfigMixins = definitions.predicate.BoxPlotConfigMixins,
          CompositeUnitSpec
            | doc m%"
            Unit spec that can have a composite mark.
            "%
            = definitions.predicate.CompositeUnitSpecAlias,
          CompositeUnitSpecAlias = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "encoding", "mark" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  encoding = definitions.predicate.Encoding,
                  height = predicates.isType '"Number",
                  mark = definitions.predicate.AnyMark,
                  name = predicates.isType '"String",
                  selection = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.SelectionDef
                      ],
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          "Conditional<MarkPropFieldDef>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selection", "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  legend = predicates.anyOf
                      [ definitions.predicate.Legend, predicates.isType 'Null ],
                  scale = definitions.predicate.Scale,
                  selection = definitions.predicate.SelectionOperand,
                  sort = predicates.anyOf
                      [
                        definitions.predicate.SortOrder,
                        definitions.predicate.SortField,
                        predicates.isType 'Null
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          "Conditional<TextFieldDef>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selection", "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  format = predicates.isType '"String",
                  selection = definitions.predicate.SelectionOperand,
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          "Conditional<ValueDef>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selection", "value" ],
                predicates.records.record
                {
                  selection = definitions.predicate.SelectionOperand,
                  value = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Config = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  area = definitions.predicate.MarkConfig,
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  axis = definitions.predicate.AxisConfig,
                  axisBand = definitions.predicate.VgAxisConfig,
                  axisBottom = definitions.predicate.VgAxisConfig,
                  axisLeft = definitions.predicate.VgAxisConfig,
                  axisRight = definitions.predicate.VgAxisConfig,
                  axisTop = definitions.predicate.VgAxisConfig,
                  axisX = definitions.predicate.VgAxisConfig,
                  axisY = definitions.predicate.VgAxisConfig,
                  background = predicates.isType '"String",
                  bar = definitions.predicate.BarConfig,
                  circle = definitions.predicate.MarkConfig,
                  countTitle = predicates.isType '"String",
                  fieldTitle = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "verbal", "functional", "plain" ]
                      ],
                  invalidValues = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "filter" ]
                      ],
                  legend = definitions.predicate.LegendConfig,
                  line = definitions.predicate.MarkConfig,
                  mark = definitions.predicate.MarkConfig,
                  numberFormat = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  point = definitions.predicate.MarkConfig,
                  range = definitions.predicate.RangeConfig,
                  rect = definitions.predicate.MarkConfig,
                  rule = definitions.predicate.MarkConfig,
                  scale = definitions.predicate.ScaleConfig,
                  selection = definitions.predicate.SelectionConfig,
                  square = definitions.predicate.MarkConfig,
                  stack = definitions.predicate.StackOffset,
                  style = definitions.predicate.StyleConfigIndex,
                  text = definitions.predicate.TextConfig,
                  tick = definitions.predicate.TickConfig,
                  timeFormat = predicates.isType '"String",
                  title = definitions.predicate.VgTitleConfig,
                  view = definitions.predicate.ViewConfig,
                }
                {  }
                false
                predicates.never
              ],
          CsvDataFormat = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parse = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "auto" ]
                        ],
                        predicates.isType 'Record
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "csv", "tsv" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Data = predicates.anyOf
              [
                definitions.predicate.UrlData,
                definitions.predicate.InlineData,
                definitions.predicate.NamedData
              ],
          DataFormat = predicates.anyOf
              [
                definitions.predicate.CsvDataFormat,
                definitions.predicate.JsonDataFormat,
                definitions.predicate.TopoDataFormat
              ],
          DataFormatBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parse = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "auto" ]
                        ],
                        predicates.isType 'Record
                      ],
                  type = definitions.predicate.DataFormatType,
                }
                {  }
                false
                predicates.never
              ],
          DataFormatType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "json", "csv", "tsv", "topojson" ]
              ],
          DateTime
            | doc m%"
            Object for defining datetime in Vega-Lite Filter.
            If both month and quarter are provided, month has higher precedence.
            `day` cannot be combined with other date.
            We accept string for month and day names.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  date = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 31,
                        predicates.numbers.minimum 1
                      ],
                  day = predicates.anyOf
                      [
                        definitions.predicate.Day,
                        predicates.isType '"String"
                      ],
                  hours = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 23,
                        predicates.numbers.minimum 0
                      ],
                  milliseconds = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 999,
                        predicates.numbers.minimum 0
                      ],
                  minutes = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 59,
                        predicates.numbers.minimum 0
                      ],
                  month = predicates.anyOf
                      [
                        definitions.predicate.Month,
                        predicates.isType '"String"
                      ],
                  quarter = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 4,
                        predicates.numbers.minimum 1
                      ],
                  seconds = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 59,
                        predicates.numbers.minimum 0
                      ],
                  utc = predicates.isType '"Bool",
                  year = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          Day = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.maximum 7,
                predicates.numbers.minimum 1
              ],
          Encoding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  color = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  detail = predicates.anyOf
                      [
                        definitions.predicate.FieldDef,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.FieldDef
                        ]
                      ],
                  opacity = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  order = predicates.anyOf
                      [
                        definitions.predicate.OrderFieldDef,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.OrderFieldDef
                        ]
                      ],
                  shape = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  size = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  text = predicates.anyOf
                      [
                        definitions.predicate.TextFieldDefWithCondition,
                        definitions.predicate.TextValueDefWithCondition
                      ],
                  tooltip = predicates.anyOf
                      [
                        definitions.predicate.TextFieldDefWithCondition,
                        definitions.predicate.TextValueDefWithCondition
                      ],
                  x = predicates.anyOf
                      [
                        definitions.predicate.PositionFieldDef,
                        definitions.predicate.ValueDef
                      ],
                  x2 = predicates.anyOf
                      [
                        definitions.predicate.FieldDef,
                        definitions.predicate.ValueDef
                      ],
                  y = predicates.anyOf
                      [
                        definitions.predicate.PositionFieldDef,
                        definitions.predicate.ValueDef
                      ],
                  y2 = predicates.anyOf
                      [
                        definitions.predicate.FieldDef,
                        definitions.predicate.ValueDef
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EncodingWithFacet = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  color = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  column = definitions.predicate.FacetFieldDef,
                  detail = predicates.anyOf
                      [
                        definitions.predicate.FieldDef,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.FieldDef
                        ]
                      ],
                  opacity = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  order = predicates.anyOf
                      [
                        definitions.predicate.OrderFieldDef,
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.OrderFieldDef
                        ]
                      ],
                  row = definitions.predicate.FacetFieldDef,
                  shape = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  size = predicates.anyOf
                      [
                        definitions.predicate.MarkPropFieldDefWithCondition,
                        definitions.predicate.MarkPropValueDefWithCondition
                      ],
                  text = predicates.anyOf
                      [
                        definitions.predicate.TextFieldDefWithCondition,
                        definitions.predicate.TextValueDefWithCondition
                      ],
                  tooltip = predicates.anyOf
                      [
                        definitions.predicate.TextFieldDefWithCondition,
                        definitions.predicate.TextValueDefWithCondition
                      ],
                  x = predicates.anyOf
                      [
                        definitions.predicate.PositionFieldDef,
                        definitions.predicate.ValueDef
                      ],
                  x2 = predicates.anyOf
                      [
                        definitions.predicate.FieldDef,
                        definitions.predicate.ValueDef
                      ],
                  y = predicates.anyOf
                      [
                        definitions.predicate.PositionFieldDef,
                        definitions.predicate.ValueDef
                      ],
                  y2 = predicates.anyOf
                      [
                        definitions.predicate.FieldDef,
                        definitions.predicate.ValueDef
                      ],
                }
                {  }
                false
                predicates.never
              ],
          EqualFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "equal", "field" ],
                predicates.records.record
                {
                  equal = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number",
                        predicates.isType '"Bool",
                        definitions.predicate.DateTime
                      ],
                  field = predicates.isType '"String",
                  timeUnit = definitions.predicate.TimeUnit,
                }
                {  }
                false
                predicates.never
              ],
          FacetFieldDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  header = definitions.predicate.Header,
                  sort = definitions.predicate.SortOrder,
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          FacetMapping = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  column = definitions.predicate.FacetFieldDef,
                  row = definitions.predicate.FacetFieldDef,
                }
                {  }
                false
                predicates.never
              ],
          FacetSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "facet", "spec" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  facet = definitions.predicate.FacetMapping,
                  name = predicates.isType '"String",
                  resolve = definitions.predicate.Resolve,
                  spec = predicates.anyOf
                      [
                        definitions.predicate.LayerSpec,
                        definitions.predicate.CompositeUnitSpec
                      ],
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          FacetedCompositeUnitSpecAlias = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "encoding", "mark" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  encoding = definitions.predicate.EncodingWithFacet,
                  height = predicates.isType '"Number",
                  mark = definitions.predicate.AnyMark,
                  name = predicates.isType '"String",
                  selection = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.SelectionDef
                      ],
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          FacetedUnitSpec
            | doc m%"
            Unit spec that can have a composite mark and row or column channels.
            "%
            = definitions.predicate.FacetedCompositeUnitSpecAlias,
          FieldDef
            | doc m%"
            Definition object for a data field, its type and transformation of an encoding channel.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          FieldDefBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                }
                {  }
                false
                predicates.never
              ],
          Filter = predicates.anyOf
              [
                definitions.predicate.EqualFilter,
                definitions.predicate.RangeFilter,
                definitions.predicate.OneOfFilter,
                definitions.predicate.SelectionFilter,
                predicates.isType '"String"
              ],
          FilterOperand = predicates.anyOf
              [
                definitions.predicate.NotFilter,
                definitions.predicate.AndFilter,
                definitions.predicate.OrFilter,
                definitions.predicate.Filter
              ],
          FilterTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "filter" ],
                predicates.records.record
                { filter = definitions.predicate.FilterOperand, }
                {  }
                false
                predicates.never
              ],
          FontStyle = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "normal", "italic" ]
              ],
          FontWeight = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "normal", "bold" ]
              ],
          FontWeightNumber = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.maximum 900,
                predicates.numbers.minimum 100
              ],
          Guide = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  title = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                }
                {  }
                false
                predicates.never
              ],
          HConcatSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "hconcat" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  hconcat = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Spec
                      ],
                  name = predicates.isType '"String",
                  resolve = definitions.predicate.Resolve,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Header
            | doc m%"
            Headers of row / column channels for faceted plots.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  format = predicates.isType '"String",
                  title = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          HorizontalAlign = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "left", "right", "center" ]
              ],
          InlineData = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "values" ],
                predicates.records.record
                {
                  format = definitions.predicate.DataFormat,
                  values = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType '"Bool")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType 'Record)
                        ],
                        predicates.isType '"String",
                        predicates.isType 'Record
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Interpolate = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "linear",
                  "linear-closed",
                  "step",
                  "step-before",
                  "step-after",
                  "basis",
                  "basis-open",
                  "basis-closed",
                  "cardinal",
                  "cardinal-open",
                  "cardinal-closed",
                  "bundle",
                  "monotone"
                ]
              ],
          InterpolateParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  gamma = predicates.isType '"Number",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "rgb", "cubehelix", "cubehelix-long" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          IntervalSelection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  bind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "scales" ]
                      ],
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  mark = definitions.predicate.BrushConfig,
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                  translate = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "interval" ]
                      ],
                  zoom = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          IntervalSelectionConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bind = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "scales" ]
                      ],
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  mark = definitions.predicate.BrushConfig,
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                  translate = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  zoom = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          JsonDataFormat = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  parse = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "auto" ]
                        ],
                        predicates.isType 'Record
                      ],
                  property = predicates.isType '"String",
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "json" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LayerSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "layer" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  height = predicates.isType '"Number",
                  layer = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.LayerSpec,
                          definitions.predicate.CompositeUnitSpec
                        ])
                      ],
                  name = predicates.isType '"String",
                  resolve = definitions.predicate.Resolve,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          LayoutSizeMixins = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  height = predicates.isType '"Number",
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          Legend
            | doc m%"
            Properties of a legend or boolean flag for determining whether to show it.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  entryPadding = predicates.isType '"Number",
                  format = predicates.isType '"String",
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.LegendOrient,
                  padding = predicates.isType '"Number",
                  tickCount = predicates.isType '"Number",
                  title = predicates.anyOf
                      [ predicates.isType '"String", predicates.isType 'Null ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "symbol", "gradient" ]
                      ],
                  values = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.DateTime
                        ]
                      ],
                  zindex = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          LegendConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cornerRadius = predicates.isType '"Number",
                  entryPadding = predicates.isType '"Number",
                  fillColor = predicates.isType '"String",
                  gradientHeight = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  gradientLabelBaseline = predicates.isType '"String",
                  gradientLabelLimit = predicates.isType '"Number",
                  gradientLabelOffset = predicates.isType '"Number",
                  gradientStrokeColor = predicates.isType '"String",
                  gradientStrokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  gradientWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelAlign = predicates.isType '"String",
                  labelBaseline = predicates.isType '"String",
                  labelColor = predicates.isType '"String",
                  labelFont = predicates.isType '"String",
                  labelFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelLimit = predicates.isType '"Number",
                  labelOffset = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.LegendOrient,
                  padding = predicates.isType '"Number",
                  shortTimeLabels = predicates.isType '"Bool",
                  strokeColor = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeWidth = predicates.isType '"Number",
                  symbolColor = predicates.isType '"String",
                  symbolSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  symbolStrokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  symbolType = predicates.isType '"String",
                  titleAlign = predicates.isType '"String",
                  titleBaseline = predicates.isType '"String",
                  titleColor = predicates.isType '"String",
                  titleFont = predicates.isType '"String",
                  titleFontSize = predicates.isType '"Number",
                  titleFontWeight = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  titleLimit = predicates.isType '"Number",
                  titlePadding = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          LegendOrient = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "left",
                  "right",
                  "top-left",
                  "top-right",
                  "bottom-left",
                  "bottom-right",
                  "none"
                ]
              ],
          LegendResolveMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  color = definitions.predicate.ResolveMode,
                  opacity = definitions.predicate.ResolveMode,
                  shape = definitions.predicate.ResolveMode,
                  size = definitions.predicate.ResolveMode,
                }
                {  }
                false
                predicates.never
              ],
          LocalMultiTimeUnit = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "yearquarter",
                  "yearquartermonth",
                  "yearmonth",
                  "yearmonthdate",
                  "yearmonthdatehours",
                  "yearmonthdatehoursminutes",
                  "yearmonthdatehoursminutesseconds",
                  "quartermonth",
                  "monthdate",
                  "hoursminutes",
                  "hoursminutesseconds",
                  "minutesseconds",
                  "secondsmilliseconds"
                ]
              ],
          LocalSingleTimeUnit = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "year",
                  "quarter",
                  "month",
                  "day",
                  "date",
                  "hours",
                  "minutes",
                  "seconds",
                  "milliseconds"
                ]
              ],
          LookupData = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "data", "key" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  key = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          LookupTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "from", "lookup" ],
                predicates.records.record
                {
                  as = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  "default" = predicates.isType '"String",
                  from = definitions.predicate.LookupData,
                  lookup = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          Mark
            | doc m%"
            All types of primitive marks.
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "area",
                  "bar",
                  "line",
                  "point",
                  "text",
                  "tick",
                  "rect",
                  "rule",
                  "circle",
                  "square"
                ]
              ],
          MarkConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  color = predicates.isType '"String",
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  filled = predicates.isType '"Bool",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          MarkConfigMixins = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  area = definitions.predicate.MarkConfig,
                  bar = definitions.predicate.BarConfig,
                  circle = definitions.predicate.MarkConfig,
                  line = definitions.predicate.MarkConfig,
                  mark = definitions.predicate.MarkConfig,
                  point = definitions.predicate.MarkConfig,
                  rect = definitions.predicate.MarkConfig,
                  rule = definitions.predicate.MarkConfig,
                  square = definitions.predicate.MarkConfig,
                  text = definitions.predicate.TextConfig,
                  tick = definitions.predicate.TickConfig,
                }
                {  }
                false
                predicates.never
              ],
          MarkDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  clip = predicates.isType '"Bool",
                  color = predicates.isType '"String",
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  filled = predicates.isType '"Bool",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  style = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                  type = definitions.predicate.Mark,
                }
                {  }
                false
                predicates.never
              ],
          MarkPropFieldDef
            | doc m%"
            Field definition of a mark property, which can contain a legend.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  legend = predicates.anyOf
                      [ definitions.predicate.Legend, predicates.isType 'Null ],
                  scale = definitions.predicate.Scale,
                  sort = predicates.anyOf
                      [
                        definitions.predicate.SortOrder,
                        definitions.predicate.SortField,
                        predicates.isType 'Null
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          MarkPropFieldDefWithCondition
            | doc m%"
            A FieldDef with Condition<ValueDef>
            {
               condition: {value: ...},
               field: ...,
               ...
            }
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  condition = predicates.anyOf
                      [
                        definitions.predicate."Conditional<ValueDef>",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."Conditional<ValueDef>"
                        ]
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  legend = predicates.anyOf
                      [ definitions.predicate.Legend, predicates.isType 'Null ],
                  scale = definitions.predicate.Scale,
                  sort = predicates.anyOf
                      [
                        definitions.predicate.SortOrder,
                        definitions.predicate.SortField,
                        predicates.isType 'Null
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          MarkPropValueDefWithCondition
            | doc m%"
            A ValueDef with Condition<ValueDef | FieldDef>
            {
               condition: {field: ...} | {value: ...},
               value: ...,
            }
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.anyOf
                      [
                        definitions.predicate."Conditional<MarkPropFieldDef>",
                        definitions.predicate."Conditional<ValueDef>",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."Conditional<ValueDef>"
                        ]
                      ],
                  value = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Month = predicates.allOf
              [
                predicates.isType '"Number",
                predicates.numbers.maximum 12,
                predicates.numbers.minimum 1
              ],
          MultiSelection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  nearest = predicates.isType '"Bool",
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                  toggle = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "multi" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MultiSelectionConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  nearest = predicates.isType '"Bool",
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                  toggle = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          MultiTimeUnit = predicates.anyOf
              [
                definitions.predicate.LocalMultiTimeUnit,
                definitions.predicate.UtcMultiTimeUnit
              ],
          NamedData = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  format = definitions.predicate.DataFormat,
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          NiceTime = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "second", "minute", "hour", "day", "week", "month", "year" ]
              ],
          NotFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "not" ],
                predicates.records.record
                { not = definitions.predicate.FilterOperand, }
                {  }
                false
                predicates.never
              ],
          OneOfFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field", "oneOf" ],
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  oneOf = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType '"Bool")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.DateTime
                        ]
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                }
                {  }
                false
                predicates.never
              ],
          OrFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "or" ],
                predicates.records.record
                {
                  or = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.FilterOperand
                      ],
                }
                {  }
                false
                predicates.never
              ],
          OrderFieldDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  sort = definitions.predicate.SortOrder,
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          Orient = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "horizontal", "vertical" ]
              ],
          Padding = predicates.allOf
              [
                predicates.anyOf
                [
                  predicates.isType '"Number",
                  predicates.allOf
                  [
                    predicates.isType 'Record,
                    predicates.records.record
                    {
                      bottom = predicates.isType '"Number",
                      left = predicates.isType '"Number",
                      right = predicates.isType '"Number",
                      top = predicates.isType '"Number",
                    }
                    {  }
                    false
                    predicates.never
                  ]
                ],
                predicates.numbers.minimum 0
              ],
          PositionFieldDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  axis = predicates.anyOf
                      [ definitions.predicate.Axis, predicates.isType 'Null ],
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  scale = definitions.predicate.Scale,
                  sort = predicates.anyOf
                      [
                        definitions.predicate.SortOrder,
                        definitions.predicate.SortField,
                        predicates.isType 'Null
                      ],
                  stack = predicates.anyOf
                      [
                        definitions.predicate.StackOffset,
                        predicates.isType 'Null
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          RangeConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  category = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        definitions.predicate.VgScheme
                      ],
                  diverging = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        definitions.predicate.VgScheme
                      ],
                  heatmap = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        definitions.predicate.VgScheme
                      ],
                  ordinal = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        definitions.predicate.VgScheme
                      ],
                  ramp = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        definitions.predicate.VgScheme
                      ],
                  symbol = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                true
                definitions.predicate.RangeConfigValue
              ],
          RangeConfigValue = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"Array",
                  predicates.arrays.arrayOf
                  (predicates.anyOf
                  [ predicates.isType '"Number", predicates.isType '"String" ])
                ],
                definitions.predicate.VgScheme,
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "step" ],
                  predicates.records.record
                  { step = predicates.isType '"Number", }
                  {  }
                  false
                  predicates.never
                ]
              ],
          RangeFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "field", "range" ],
                predicates.records.record
                {
                  field = predicates.isType '"String",
                  range = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          predicates.isType '"Number",
                          definitions.predicate.DateTime
                        ]),
                        predicates.arrays.maxItems 2,
                        predicates.arrays.minItems 2
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                }
                {  }
                false
                predicates.never
              ],
          Repeat = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  column = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  row = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RepeatRef
            | doc m%"
            Reference to a repeated value.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repeat" ],
                predicates.records.record
                {
                  repeat = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "row", "column" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          RepeatSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repeat", "spec" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  repeat = definitions.predicate.Repeat,
                  resolve = definitions.predicate.Resolve,
                  spec = definitions.predicate.Spec,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Resolve
            | doc m%"
            Defines how scales, axes, and legends from different specs should be combined. Resolve is a mapping from `scale`, `axis`, and `legend` to a mapping from channels to resolutions.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  axis = definitions.predicate.AxisResolveMap,
                  legend = definitions.predicate.LegendResolveMap,
                  scale = definitions.predicate.ScaleResolveMap,
                }
                {  }
                false
                predicates.never
              ],
          ResolveMode = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "independent", "shared" ]
              ],
          Scale = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  base = predicates.isType '"Number",
                  clamp = predicates.isType '"Bool",
                  domain = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf (predicates.isType '"Bool")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate.DateTime
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "unaggregated" ]
                        ],
                        definitions.predicate.SelectionDomain
                      ],
                  exponent = predicates.isType '"Number",
                  interpolate = predicates.anyOf
                      [
                        definitions.predicate.Interpolate,
                        definitions.predicate.InterpolateParams
                      ],
                  nice = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number",
                        definitions.predicate.NiceTime,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.required [ "interval", "step" ],
                          predicates.records.record
                          {
                            interval = predicates.isType '"String",
                            step = predicates.isType '"Number",
                          }
                          {  }
                          false
                          predicates.never
                        ]
                      ],
                  padding = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  paddingInner = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  paddingOuter = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  range = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"Number")
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ],
                        predicates.isType '"String"
                      ],
                  rangeStep = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType 'Null
                        ],
                        predicates.numbers.minimum 0
                      ],
                  round = predicates.isType '"Bool",
                  scheme = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.SchemeParams
                      ],
                  type = definitions.predicate.ScaleType,
                  zero = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ScaleConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bandPaddingInner = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  bandPaddingOuter = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  clamp = predicates.isType '"Bool",
                  continuousPadding = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  maxBandSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  maxFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  maxOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  maxSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  maxStrokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  minBandSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  minFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  minOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  minSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  minStrokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  pointPadding = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  rangeStep = predicates.allOf
                      [
                        predicates.anyOf
                        [
                          predicates.isType '"Number",
                          predicates.isType 'Null
                        ],
                        predicates.numbers.minimum 0
                      ],
                  round = predicates.isType '"Bool",
                  textXRangeStep = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  useUnaggregatedDomain = predicates.isType '"Bool",
                }
                {  }
                false
                predicates.never
              ],
          ScaleFieldDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  scale = definitions.predicate.Scale,
                  sort = predicates.anyOf
                      [
                        definitions.predicate.SortOrder,
                        definitions.predicate.SortField,
                        predicates.isType 'Null
                      ],
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          ScaleResolveMap = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  color = definitions.predicate.ResolveMode,
                  opacity = definitions.predicate.ResolveMode,
                  shape = definitions.predicate.ResolveMode,
                  size = definitions.predicate.ResolveMode,
                  x = definitions.predicate.ResolveMode,
                  y = definitions.predicate.ResolveMode,
                }
                {  }
                false
                predicates.never
              ],
          ScaleType = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "linear",
                  "bin-linear",
                  "log",
                  "pow",
                  "sqrt",
                  "time",
                  "utc",
                  "sequential",
                  "ordinal",
                  "bin-ordinal",
                  "point",
                  "band"
                ]
              ],
          SchemeParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "name" ],
                predicates.records.record
                {
                  extent = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  name = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          SelectionAnd = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "and" ],
                predicates.records.record
                {
                  and = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SelectionOperand
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SelectionConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  interval = definitions.predicate.IntervalSelectionConfig,
                  multi = definitions.predicate.MultiSelectionConfig,
                  single = definitions.predicate.SingleSelectionConfig,
                }
                {  }
                false
                predicates.never
              ],
          SelectionDef = predicates.anyOf
              [
                definitions.predicate.SingleSelection,
                definitions.predicate.MultiSelection,
                definitions.predicate.IntervalSelection
              ],
          SelectionDomain = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "selection" ],
                  predicates.records.record
                  {
                    field = predicates.isType '"String",
                    selection = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ],
                predicates.allOf
                [
                  predicates.isType 'Record,
                  predicates.records.required [ "selection" ],
                  predicates.records.record
                  {
                    encoding = predicates.isType '"String",
                    selection = predicates.isType '"String",
                  }
                  {  }
                  false
                  predicates.never
                ]
              ],
          SelectionFilter = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "selection" ],
                predicates.records.record
                { selection = definitions.predicate.SelectionOperand, }
                {  }
                false
                predicates.never
              ],
          SelectionNot = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "not" ],
                predicates.records.record
                { not = definitions.predicate.SelectionOperand, }
                {  }
                false
                predicates.never
              ],
          SelectionOperand = predicates.anyOf
              [
                definitions.predicate.SelectionNot,
                definitions.predicate.SelectionAnd,
                definitions.predicate.SelectionOr,
                predicates.isType '"String"
              ],
          SelectionOr = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "or" ],
                predicates.records.record
                {
                  or = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SelectionOperand
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SelectionResolution = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "global", "union", "intersect" ]
              ],
          SingleDefChannel = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "x",
                  "y",
                  "x2",
                  "y2",
                  "row",
                  "column",
                  "size",
                  "shape",
                  "color",
                  "opacity",
                  "text",
                  "tooltip"
                ]
              ],
          SingleSelection = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  bind = predicates.anyOf
                      [
                        definitions.predicate.VgBinding,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          definitions.predicate.VgBinding
                        ]
                      ],
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  nearest = predicates.isType '"Bool",
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "single" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          SingleSelectionConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bind = predicates.anyOf
                      [
                        definitions.predicate.VgBinding,
                        predicates.allOf
                        [
                          predicates.isType 'Record,
                          predicates.records.record {  } {  } true
                          definitions.predicate.VgBinding
                        ]
                      ],
                  empty = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "all", "none" ]
                      ],
                  encodings = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.SingleDefChannel
                      ],
                  fields = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                  nearest = predicates.isType '"Bool",
                  on = definitions.predicate.VgEventStream,
                  resolve = definitions.predicate.SelectionResolution,
                }
                {  }
                false
                predicates.never
              ],
          SingleTimeUnit = predicates.anyOf
              [
                definitions.predicate.LocalSingleTimeUnit,
                definitions.predicate.UtcSingleTimeUnit
              ],
          SortField = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "op" ],
                predicates.records.record
                {
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  op = definitions.predicate.AggregateOp,
                  order = definitions.predicate.SortOrder,
                }
                {  }
                false
                predicates.never
              ],
          SortOrder = predicates.anyOf
              [
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "ascending" ]
                ],
                predicates.allOf
                [
                  predicates.isType '"String",
                  predicates.enum [ "descending" ]
                ],
                predicates.isType 'Null
              ],
          Spec = predicates.anyOf
              [
                definitions.predicate.CompositeUnitSpec,
                definitions.predicate.LayerSpec,
                definitions.predicate.FacetSpec,
                definitions.predicate.RepeatSpec,
                definitions.predicate.VConcatSpec,
                definitions.predicate.HConcatSpec
              ],
          StackOffset = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "zero", "center", "normalize" ]
              ],
          StyleConfigIndex = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record {  } {  } true
                definitions.predicate.VgMarkConfig
              ],
          TextConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  color = predicates.isType '"String",
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  filled = predicates.isType '"Bool",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  shortTimeLabels = predicates.isType '"Bool",
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          TextFieldDef = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  format = predicates.isType '"String",
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          TextFieldDefWithCondition
            | doc m%"
            A FieldDef with Condition<ValueDef>
            {
               condition: {value: ...},
               field: ...,
               ...
            }
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "type" ],
                predicates.records.record
                {
                  aggregate = definitions.predicate.Aggregate,
                  bin = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        definitions.predicate.BinParams
                      ],
                  condition = predicates.anyOf
                      [
                        definitions.predicate."Conditional<ValueDef>",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."Conditional<ValueDef>"
                        ]
                      ],
                  field = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.RepeatRef
                      ],
                  format = predicates.isType '"String",
                  timeUnit = definitions.predicate.TimeUnit,
                  type = definitions.predicate.Type,
                }
                {  }
                false
                predicates.never
              ],
          TextValueDefWithCondition
            | doc m%"
            A ValueDef with Condition<ValueDef | FieldDef>
            {
               condition: {field: ...} | {value: ...},
               value: ...,
            }
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  condition = predicates.anyOf
                      [
                        definitions.predicate."Conditional<TextFieldDef>",
                        definitions.predicate."Conditional<ValueDef>",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          definitions.predicate."Conditional<ValueDef>"
                        ]
                      ],
                  value = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TickConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  bandSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  color = predicates.isType '"String",
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  filled = predicates.isType '"Bool",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                  thickness = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TimeUnit = predicates.anyOf
              [
                definitions.predicate.SingleTimeUnit,
                definitions.predicate.MultiTimeUnit
              ],
          TimeUnitTransform = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "as", "field", "timeUnit" ],
                predicates.records.record
                {
                  as = predicates.isType '"String",
                  field = predicates.isType '"String",
                  timeUnit = definitions.predicate.TimeUnit,
                }
                {  }
                false
                predicates.never
              ],
          TitleBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  anchor = definitions.predicate.Anchor,
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.TitleOrient,
                  style = predicates.anyOf
                      [
                        predicates.isType '"String",
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
          TitleOrient = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "top", "bottom", "left", "right" ]
              ],
          TitleParams = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "text" ],
                predicates.records.record
                {
                  anchor = definitions.predicate.Anchor,
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.TitleOrient,
                  style = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.allOf
                        [
                          predicates.isType '"Array",
                          predicates.arrays.arrayOf
                          (predicates.isType '"String")
                        ]
                      ],
                  text = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          "TopLevel<FacetSpec>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "facet", "spec" ],
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  config = definitions.predicate.Config,
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  facet = definitions.predicate.FacetMapping,
                  name = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  resolve = definitions.predicate.Resolve,
                  spec = predicates.anyOf
                      [
                        definitions.predicate.LayerSpec,
                        definitions.predicate.CompositeUnitSpec
                      ],
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "TopLevel<FacetedUnitSpec>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "encoding", "mark" ],
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  config = definitions.predicate.Config,
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  encoding = definitions.predicate.EncodingWithFacet,
                  height = predicates.isType '"Number",
                  mark = definitions.predicate.AnyMark,
                  name = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  selection = predicates.allOf
                      [
                        predicates.isType 'Record,
                        predicates.records.record {  } {  } true
                        definitions.predicate.SelectionDef
                      ],
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          "TopLevel<HConcatSpec>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "hconcat" ],
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  config = definitions.predicate.Config,
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  hconcat = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Spec
                      ],
                  name = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  resolve = definitions.predicate.Resolve,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "TopLevel<LayerSpec>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "layer" ],
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  config = definitions.predicate.Config,
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  height = predicates.isType '"Number",
                  layer = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        (predicates.anyOf
                        [
                          definitions.predicate.LayerSpec,
                          definitions.predicate.CompositeUnitSpec
                        ])
                      ],
                  name = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  resolve = definitions.predicate.Resolve,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          "TopLevel<RepeatSpec>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "repeat", "spec" ],
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  config = definitions.predicate.Config,
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  repeat = definitions.predicate.Repeat,
                  resolve = definitions.predicate.Resolve,
                  spec = definitions.predicate.Spec,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                }
                {  }
                false
                predicates.never
              ],
          "TopLevel<VConcatSpec>" = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "vconcat" ],
                predicates.records.record
                {
                  "$schema" = predicates.isType '"String",
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  config = definitions.predicate.Config,
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                  resolve = definitions.predicate.Resolve,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  vconcat = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Spec
                      ],
                }
                {  }
                false
                predicates.never
              ],
          TopLevelExtendedSpec = predicates.anyOf
              [
                definitions.predicate."TopLevel<FacetedUnitSpec>",
                definitions.predicate."TopLevel<LayerSpec>",
                definitions.predicate."TopLevel<FacetSpec>",
                definitions.predicate."TopLevel<RepeatSpec>",
                definitions.predicate."TopLevel<VConcatSpec>",
                definitions.predicate."TopLevel<HConcatSpec>"
              ],
          TopLevelProperties = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  autosize = predicates.anyOf
                      [
                        definitions.predicate.AutosizeType,
                        definitions.predicate.AutoSizeParams
                      ],
                  background = predicates.isType '"String",
                  padding = definitions.predicate.Padding,
                }
                {  }
                false
                predicates.never
              ],
          TopoDataFormat = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  feature = predicates.isType '"String",
                  mesh = predicates.isType '"String",
                  parse = predicates.anyOf
                      [
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "auto" ]
                        ],
                        predicates.isType 'Record
                      ],
                  type = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "topojson" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          Transform = predicates.anyOf
              [
                definitions.predicate.FilterTransform,
                definitions.predicate.CalculateTransform,
                definitions.predicate.LookupTransform,
                definitions.predicate.BinTransform,
                definitions.predicate.TimeUnitTransform,
                definitions.predicate.AggregateTransform
              ],
          Type
            | doc m%"
            Constants and utilities for data type  
             Data type based on level of measurement 
            "%
            = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [ "quantitative", "ordinal", "temporal", "nominal" ]
              ],
          UrlData = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "url" ],
                predicates.records.record
                {
                  format = definitions.predicate.DataFormat,
                  url = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          UtcMultiTimeUnit = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "utcyearquarter",
                  "utcyearquartermonth",
                  "utcyearmonth",
                  "utcyearmonthdate",
                  "utcyearmonthdatehours",
                  "utcyearmonthdatehoursminutes",
                  "utcyearmonthdatehoursminutesseconds",
                  "utcquartermonth",
                  "utcmonthdate",
                  "utchoursminutes",
                  "utchoursminutesseconds",
                  "utcminutesseconds",
                  "utcsecondsmilliseconds"
                ]
              ],
          UtcSingleTimeUnit = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum
                [
                  "utcyear",
                  "utcquarter",
                  "utcmonth",
                  "utcday",
                  "utcdate",
                  "utchours",
                  "utcminutes",
                  "utcseconds",
                  "utcmilliseconds"
                ]
              ],
          VConcatSpec = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "vconcat" ],
                predicates.records.record
                {
                  data = definitions.predicate.Data,
                  description = predicates.isType '"String",
                  name = predicates.isType '"String",
                  resolve = definitions.predicate.Resolve,
                  title = predicates.anyOf
                      [
                        predicates.isType '"String",
                        definitions.predicate.TitleParams
                      ],
                  transform = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf
                        definitions.predicate.Transform
                      ],
                  vconcat = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf definitions.predicate.Spec
                      ],
                }
                {  }
                false
                predicates.never
              ],
          VLOnlyConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  countTitle = predicates.isType '"String",
                  fieldTitle = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "verbal", "functional", "plain" ]
                      ],
                  invalidValues = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "filter" ]
                      ],
                  numberFormat = predicates.isType '"String",
                  scale = definitions.predicate.ScaleConfig,
                  selection = definitions.predicate.SelectionConfig,
                  stack = definitions.predicate.StackOffset,
                  timeFormat = predicates.isType '"String",
                  view = definitions.predicate.ViewConfig,
                }
                {  }
                false
                predicates.never
              ],
          ValueDef
            | doc m%"
            Definition object for a constant value of an encoding channel.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "value" ],
                predicates.records.record
                {
                  value = predicates.anyOf
                      [
                        predicates.isType '"Number",
                        predicates.isType '"String",
                        predicates.isType '"Bool"
                      ],
                }
                {  }
                false
                predicates.never
              ],
          VerticalAlign = predicates.allOf
              [
                predicates.isType '"String",
                predicates.enum [ "top", "middle", "bottom" ]
              ],
          VgAxisBase
            | doc m%"
            Base object for Vega's Axis and Axis Config.
            All of these properties are both properties of Vega's Axis and Axis Config.
            "%
            = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  domain = predicates.isType '"Bool",
                  grid = predicates.isType '"Bool",
                  labelAngle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum (-360)
                      ],
                  labelBound = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelFlush = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelOverlap = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "parity" ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "greedy" ]
                        ]
                      ],
                  labelPadding = predicates.isType '"Number",
                  labels = predicates.isType '"Bool",
                  maxExtent = predicates.isType '"Number",
                  minExtent = predicates.isType '"Number",
                  tickSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  ticks = predicates.isType '"Bool",
                  titleMaxLength = predicates.isType '"Number",
                  titlePadding = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VgAxisConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  bandPosition = predicates.isType '"Number",
                  domain = predicates.isType '"Bool",
                  domainColor = predicates.isType '"String",
                  domainWidth = predicates.isType '"Number",
                  grid = predicates.isType '"Bool",
                  gridColor = predicates.isType '"String",
                  gridDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  gridOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  gridWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelAngle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum (-360)
                      ],
                  labelBound = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelColor = predicates.isType '"String",
                  labelFlush = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.isType '"Number"
                      ],
                  labelFont = predicates.isType '"String",
                  labelFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelLimit = predicates.isType '"Number",
                  labelOverlap = predicates.anyOf
                      [
                        predicates.isType '"Bool",
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "parity" ]
                        ],
                        predicates.allOf
                        [
                          predicates.isType '"String",
                          predicates.enum [ "greedy" ]
                        ]
                      ],
                  labelPadding = predicates.isType '"Number",
                  labels = predicates.isType '"Bool",
                  maxExtent = predicates.isType '"Number",
                  minExtent = predicates.isType '"Number",
                  tickColor = predicates.isType '"String",
                  tickRound = predicates.isType '"Bool",
                  tickSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tickWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  ticks = predicates.isType '"Bool",
                  titleAlign = predicates.isType '"String",
                  titleAngle = predicates.isType '"Number",
                  titleBaseline = predicates.isType '"String",
                  titleColor = predicates.isType '"String",
                  titleFont = predicates.isType '"String",
                  titleFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  titleFontWeight = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  titleLimit = predicates.isType '"Number",
                  titleMaxLength = predicates.isType '"Number",
                  titlePadding = predicates.isType '"Number",
                  titleX = predicates.isType '"Number",
                  titleY = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VgBinding = predicates.anyOf
              [
                definitions.predicate.VgCheckboxBinding,
                definitions.predicate.VgRadioBinding,
                definitions.predicate.VgSelectBinding,
                definitions.predicate.VgRangeBinding,
                definitions.predicate.VgGenericBinding
              ],
          VgCheckboxBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input" ],
                predicates.records.record
                {
                  element = predicates.isType '"String",
                  input = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "checkbox" ]
                      ],
                }
                {  }
                false
                predicates.never
              ],
          VgEventStream = predicates.always,
          VgGenericBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input" ],
                predicates.records.record
                {
                  element = predicates.isType '"String",
                  input = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          VgLegendBase = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  entryPadding = predicates.isType '"Number",
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.LegendOrient,
                  padding = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VgLegendConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  cornerRadius = predicates.isType '"Number",
                  entryPadding = predicates.isType '"Number",
                  fillColor = predicates.isType '"String",
                  gradientHeight = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  gradientLabelBaseline = predicates.isType '"String",
                  gradientLabelLimit = predicates.isType '"Number",
                  gradientLabelOffset = predicates.isType '"Number",
                  gradientStrokeColor = predicates.isType '"String",
                  gradientStrokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  gradientWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelAlign = predicates.isType '"String",
                  labelBaseline = predicates.isType '"String",
                  labelColor = predicates.isType '"String",
                  labelFont = predicates.isType '"String",
                  labelFontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  labelLimit = predicates.isType '"Number",
                  labelOffset = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.LegendOrient,
                  padding = predicates.isType '"Number",
                  strokeColor = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeWidth = predicates.isType '"Number",
                  symbolColor = predicates.isType '"String",
                  symbolSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  symbolStrokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  symbolType = predicates.isType '"String",
                  titleAlign = predicates.isType '"String",
                  titleBaseline = predicates.isType '"String",
                  titleColor = predicates.isType '"String",
                  titleFont = predicates.isType '"String",
                  titleFontSize = predicates.isType '"Number",
                  titleFontWeight = predicates.anyOf
                      [
                        predicates.isType '"String",
                        predicates.isType '"Number"
                      ],
                  titleLimit = predicates.isType '"Number",
                  titlePadding = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VgMarkConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  align = definitions.predicate.HorizontalAlign,
                  angle = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 360,
                        predicates.numbers.minimum 0
                      ],
                  baseline = definitions.predicate.VerticalAlign,
                  dx = predicates.isType '"Number",
                  dy = predicates.isType '"Number",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontStyle = definitions.predicate.FontStyle,
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  interpolate = definitions.predicate.Interpolate,
                  limit = predicates.isType '"Number",
                  opacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  orient = definitions.predicate.Orient,
                  radius = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  shape = predicates.isType '"String",
                  size = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  strokeWidth = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  tension = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.maximum 1,
                        predicates.numbers.minimum 0
                      ],
                  text = predicates.isType '"String",
                  theta = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VgRadioBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input", "options" ],
                predicates.records.record
                {
                  element = predicates.isType '"String",
                  input = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "radio" ]
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          VgRangeBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input" ],
                predicates.records.record
                {
                  element = predicates.isType '"String",
                  input = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "range" ]
                      ],
                  max = predicates.isType '"Number",
                  min = predicates.isType '"Number",
                  step = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VgScheme = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "scheme" ],
                predicates.records.record
                {
                  count = predicates.isType '"Number",
                  extent = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  scheme = predicates.isType '"String",
                }
                {  }
                false
                predicates.never
              ],
          VgSelectBinding = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.required [ "input", "options" ],
                predicates.records.record
                {
                  element = predicates.isType '"String",
                  input = predicates.allOf
                      [
                        predicates.isType '"String",
                        predicates.enum [ "select" ]
                      ],
                  options = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"String")
                      ],
                }
                {  }
                false
                predicates.never
              ],
          VgTitleConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  anchor = definitions.predicate.Anchor,
                  angle = predicates.isType '"Number",
                  baseline = definitions.predicate.VerticalAlign,
                  color = predicates.isType '"String",
                  font = predicates.isType '"String",
                  fontSize = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  fontWeight = predicates.anyOf
                      [
                        definitions.predicate.FontWeight,
                        definitions.predicate.FontWeightNumber
                      ],
                  limit = predicates.allOf
                      [
                        predicates.isType '"Number",
                        predicates.numbers.minimum 0
                      ],
                  offset = predicates.isType '"Number",
                  orient = definitions.predicate.TitleOrient,
                }
                {  }
                false
                predicates.never
              ],
          ViewConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                {
                  clip = predicates.isType '"Bool",
                  fill = predicates.isType '"String",
                  fillOpacity = predicates.isType '"Number",
                  height = predicates.isType '"Number",
                  stroke = predicates.isType '"String",
                  strokeDash = predicates.allOf
                      [
                        predicates.isType '"Array",
                        predicates.arrays.arrayOf (predicates.isType '"Number")
                      ],
                  strokeDashOffset = predicates.isType '"Number",
                  strokeOpacity = predicates.isType '"Number",
                  strokeWidth = predicates.isType '"Number",
                  width = predicates.isType '"Number",
                }
                {  }
                false
                predicates.never
              ],
          VlOnlyGuideConfig = predicates.allOf
              [
                predicates.isType 'Record,
                predicates.records.record
                { shortTimeLabels = predicates.isType '"Bool", }
                {  }
                false
                predicates.never
              ],
        },
  }
in

predicates.contract_from_predicate definitions.predicate.TopLevelExtendedSpec