class Apisnip < Formula
  desc "TUI tool for trimming OpenAPI specifications down to size"
  homepage "https://github.com/Tuurlijk/apisnip"
  url "https://github.com/Tuurlijk/apisnip/archive/refs/tags/v1.4.60.tar.gz"
  sha256 "96469b1f13d14a62ee17928995bc3fec0ec2356c44ed3524dfb6eef8279a0b55"
  license "MIT"
  head "https://github.com/Tuurlijk/apisnip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ce51fa959687d4909276c2a7aa57f520bb9606636640c0ab2235013fe6ddb5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebff86fcb46e44be851fb05563f2889f32df34a28c2cbfb27e3f365489b2172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aadbd684c323308b5ec2429787c272eb9cee96dbd3e14c8abca581616829e7ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a86d552c435dc89b73c12694c1e048383f721ded52489bfdf6ab87ae32aaf15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9344b42bc70a98011d992d699c6706e8baceeb958b454423ca359c0faa3232d3"
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
