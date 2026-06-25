class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.51.tar.gz"
  sha256 "c8ebae2b6e431c248ee3a467bb07984f103110ca0b6429914b66a0bd3bd6a562"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e446d1e9f53af770e4b1b962b71282a455be383d96af1ad8d696929fe1fe0201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e446d1e9f53af770e4b1b962b71282a455be383d96af1ad8d696929fe1fe0201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e446d1e9f53af770e4b1b962b71282a455be383d96af1ad8d696929fe1fe0201"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d50adfabe0a27c60ffb81e11a8e21607e05a22f99cfce2f2db5944561901c86c"
    sha256 cellar: :any,                 x86_64_linux:  "22ebd20b6a1772acac72ec600209737b4472c414cbd0933f2081fbc2b674a86b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
