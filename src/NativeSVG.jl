module NativeSVG

export SVG
export str, cdata

const PRIMITIVES = Dict(
    :svg => true,
    :g => true,
    :defs => true,
    :use => false,
    :desc => true,
    :title => true,
    :style => true,
    :path => false,
    :line => false,
    :rect => false,
    :polygon => false,
    :polyline => false,
    :circle => false,
    :ellipse => false,
    :text => true,
    :tspan => true,
    :textPath => true,
    :linearGradient => true,
    :radialGradient => true,
    :stop => false,
    :pattern => true,
    :marker => true,
    :clipPath => true,
    :style => true,
    :foreignObject => true,
    :mask => true,
)

for primitive in keys(PRIMITIVES)
    eval(quote
        export $primitive
    end)
end

include("svg.jl")
end
