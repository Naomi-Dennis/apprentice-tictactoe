class MainIO
  def initialize(stdin:, stdout:)
    @stdin = stdin
    @stdout = stdout
  end

  def gets
    @stdin.gets
  end

end
