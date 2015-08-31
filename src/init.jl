export @init

macro definit()
  :(if !isdefined(:__init__)
      const $(esc(:__inits__)) = Function[]
      function $(esc(:__init__))()
        @init
      end
    end)
end

function initm(ex)
  quote
    @definit
    push!($(esc(:__inits__)), () -> $(esc(ex)))
    nothing
  end
end

function initm()
  :(for f in __inits__
      f()
    end) |> esc
end

macro init(args...)
  initm(args...)
end

"Prevent init fns being called multiple times during precompilation."
macro guard(ex)
  :(current_module() == Main && $(esc(ex)))
end