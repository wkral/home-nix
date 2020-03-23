function CodeBlock(block)
    local include = block.attributes["include"];
    if not include then
        return nil
    end

    local mt, content = pandoc.mediabag.fetch(include, ".")

    return pandoc.CodeBlock(content, block.attr)
end

return {
    { CodeBlock = CodeBlock }
}
