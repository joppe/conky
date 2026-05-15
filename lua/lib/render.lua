require("cairo")
require("imlib2")

function render_image(file, position, size)
	local show = imlib_load_image(file)

	if show == nil then
		return
	end

	imlib_context_set_image(show)

	local scaled = imlib_create_cropped_scaled_image(
		0,
		0,
		imlib_image_get_width(),
		imlib_image_get_height(),
		size.width,
		size.height
	)

	imlib_free_image()
	imlib_context_set_image(scaled)
	imlib_render_image_on_drawable(position.x, position.y)
	imlib_free_image()

	show = nil
end

function render_ring(cr, position, radius, thickness, angle, color)
	cairo_arc(cr, position.x, position.y, radius, angle.start, angle.stop)
	cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
	cairo_set_line_width(cr, thickness)
	cairo_stroke(cr)
end

function render_text(cr, text, font, size, position, color)
	local extents = cairo_text_extents_t:create()

	cairo_select_font_face(cr, font, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size(cr, size)
	cairo_text_extents(cr, text, extents)
	cairo_set_source_rgba(cr, color.r, color.g, color.b, color.a)
	cairo_move_to(cr, position.x, position.y)
	cairo_show_text(cr, text)
	cairo_stroke(cr)

	return {
		width = extents.width,
		height = extents.height,
	}
end

function render_duotone_text(cr, highlight, normal, font, size, position, gap)
	local size_pre =
		render_text(cr, highlight.text, font, size, position, hex_to_rgba(highlight.color, highlight.alpha))
	local size_post = render_text(
		cr,
		normal.text,
		font,
		size,
		{ x = position.x + gap + size_pre.width, y = position.y },
		hex_to_rgba(normal.color, normal.alpha)
	)

	return {
		width = size_pre.width + gap + size_post.width,
		height = size_pre.height,
	}
end

function render_table(cr, texts, configs, position, gap)
	local new_position = { x = position.x, y = position.y }

	for i in pairs(texts) do
		local row = texts[i]
		local dimensions = { width = 0, height = 0 }

		for j in pairs(row) do
			local column = row[j]
			local config = configs[j]

			dimensions = render_text(cr, column, config.font, config.size, new_position, config.color)

			new_position.x = new_position.x + dimensions.width + gap.x
		end

		new_position.x = position.x
		new_position.y = new_position.y + dimensions.height + gap.y
	end
end
