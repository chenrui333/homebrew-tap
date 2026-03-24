class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ed90a5a0ba67b08fe1306c69ab3383e7db76394ab23ea2d6d3dbf9ee2b3ea7a1"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2f3b06d7330395c23d81ee451ff12f862e905d5be9712baafbef7ee86cbbf9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2f3b06d7330395c23d81ee451ff12f862e905d5be9712baafbef7ee86cbbf9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2f3b06d7330395c23d81ee451ff12f862e905d5be9712baafbef7ee86cbbf9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f7dcb737152c30ac7143c814eb62d6a4e8d38b4150b9b1bdff3ca961077f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a288c23bbd8417cd558584b3a096dca48740011293844de3ec5a714fd6346fe3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuiltBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/lazykiq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazykiq --version")
    output = shell_output("#{bin}/lazykiq --redis not-a-url 2>&1", 1)
    assert_match "parse redis url", output
  end
end
