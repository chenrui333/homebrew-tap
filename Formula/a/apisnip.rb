class Apisnip < Formula
  desc "TUI tool for trimming OpenAPI specifications down to size"
  homepage "https://github.com/Tuurlijk/apisnip"
  url "https://github.com/Tuurlijk/apisnip/archive/refs/tags/v1.4.59.tar.gz"
  sha256 "2e3f907e336ad8242cb2941ff0b80ef167966a16acba7ad9cb0d5e331b4afb63"
  license "MIT"
  head "https://github.com/Tuurlijk/apisnip.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apisnip --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      (testpath/"minimal.yaml").write <<~YAML
        ---
        swagger: '2.0'
        info:
          version: 0.0.0
          title: Simple API
        paths:
          /:
            get:
              responses:
                200:
                  description: OK
      YAML

      output_log = testpath/"output.log"
      pid = spawn bin/"apisnip", testpath/"minimal.yaml", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "1 endpoints for #{testpath}/minimal.yaml", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
