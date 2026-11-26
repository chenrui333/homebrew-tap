class Lazyenv < Formula
  desc "TUI tool for managing multiple .env files in the terminal"
  homepage "https://github.com/lazynop/lazyenv"
  url "https://github.com/lazynop/lazyenv/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7ddfa13936001d5b9b0ea483689ee8cb006269b9c2d8e0cb88bee9f60139d421"
  license "MIT"
  head "https://github.com/lazynop/lazyenv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a4c1c6dc1aac7b4f52342ba5a9f0b42942adf9e40f2bd413da50e7eb1b9a8dd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "840eedc4d7349442251e2993b5be252e66b019677fe22bab3462c0083abed310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "840eedc4d7349442251e2993b5be252e66b019677fe22bab3462c0083abed310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "916b082bbae9d9a6ce44edc5d3bfdb93f603191831d3384f522aff50c914ef99"
    sha256 cellar: :any,                 x86_64_linux:  "4b64af15fa95bacef4bef88793087d720162c632fa72c835b6e72974ff6561c1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyenv --version 2>&1")
  end
end
