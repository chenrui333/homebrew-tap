class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "7d8588660447987bcdb5f7324fb181b79e65451d13c438c2ec37a026da41f77a"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ceb62190610ec6e4bf103e5da8ad6709671b60ff1063dbad943634de2faf38d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ceb62190610ec6e4bf103e5da8ad6709671b60ff1063dbad943634de2faf38d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ceb62190610ec6e4bf103e5da8ad6709671b60ff1063dbad943634de2faf38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343a028696b88e532a3dc23a81f031ef32e80ff788debce60dc5f0fef8145d2d"
    sha256 cellar: :any,                 x86_64_linux:  "8e41074fa4303519231baf23d6735cfd635a7751cd0b51cd95a9f7d8bd27958c"
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
