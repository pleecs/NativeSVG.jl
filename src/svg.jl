struct SVG
    data::Array{UInt8,1}
end

const BUFFER = IOBuffer()

Base.showable(::MIME"image/svg+xml", _::NativeSVG.SVG) = true

function Base.show(io::IO, svg::NativeSVG.SVG)
    write(io, String(copy(svg.data)))
end

function Base.show(io::IO, ::MIME"image/svg+xml", svg::NativeSVG.SVG)
    write(io, svg.data)
end

function Base.write(filename::AbstractString, svg::NativeSVG.SVG)
    open(filename, "w") do io
        println(io, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
        write(io, svg.data)
    end
    return nothing
end

function SVG(f::Function, io::IOBuffer = BUFFER; kwargs...)
    svg(
        ;
        xmlns = "http://www.w3.org/2000/svg",
        kwargs...
    ) do
        f()
    end
    SVG(take!(BUFFER))
end

function str(txt::String, io::IOBuffer = BUFFER)
    println(io, txt)
end

function cdata(txt::String, io::IOBuffer = BUFFER)
    println(io, "<![CDATA[")
    println(io, txt)
    println(io, "]]>")
end

for primitive in keys(PRIMITIVES)
    eval(quote
        function $primitive(io::IOBuffer = BUFFER; kwargs...)
            print(io, "<", $primitive)
            for (arg, val) in kwargs
                print(io, " ", replacenotallowed(arg), "=\"", val, "\"")
            end
            println(io, "/>")
        end
    end)
end

for primitive in keys(filter(d -> last(d), PRIMITIVES))
    eval(quote
        function $primitive(f::Function, io::IOBuffer = BUFFER; kwargs...)
            print(io, "<", $primitive)
            for (arg, val) in kwargs
                print(io, " ", replacenotallowed(arg), "=\"", val, "\"")
            end
            println(io, ">")
            f()
            println(io, "</", $primitive, ">")
        end
    end)
end

function replacenotallowed(sym::Symbol)
    String(replace(collect(String(sym)), '_' => '-', '!' => ':'))
end

