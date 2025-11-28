class Apisnip < Formula
  desc "TUI tool for trimming OpenAPI specifications down to size"
  homepage "https://github.com/Tuurlijk/apisnip"
  url "https://github.com/Tuurlijk/apisnip/archive/refs/tags/v1.4.59.tar.gz"
  sha256 "2e3f907e336ad8242cb2941ff0b80ef167966a16acba7ad9cb0d5e331b4afb63"
  license "MIT"
  head "https://github.com/Tuurlijk/apisnip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e40b12efe931be6bb01b43bb7462ff7922914d83e2306537433f967e472976f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d356a3981d5792b95cf6346deb973e21dee4e03bb70a428af51f3602f93ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1216562f5b4bc26b56961eeee9313f0207f725928b0b9c26d5d73bd6ec506eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21aaf8e5338f235c9686071830039bbe6b174912dc765e0594c872025d1a39be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1173c83d9d0171ff5146cc5766bd385e194e00dbcbf84178c3f44be9a7e1565"
  end

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
