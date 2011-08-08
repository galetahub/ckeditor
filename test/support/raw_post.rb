module RawPost
  def raw_post(action, params, body, content_type = nil)
    @request.env['RAW_POST_DATA'] = body
    @request.env['CONTENT_TYPE'] = content_type
    response = post(action, params)
    @request.env.delete('RAW_POST_DATA')
    response
  end
end
