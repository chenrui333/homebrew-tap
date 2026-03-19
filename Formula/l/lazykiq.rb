class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "b9b6b2df5cc51a51f56218a6646b5edea2e18b15b57a369851a67cf8469e582a"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc8ab479853d9b4614d8d2b68fa6e9a608d413c60e0b7a4011532396fb1a6332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc8ab479853d9b4614d8d2b68fa6e9a608d413c60e0b7a4011532396fb1a6332"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8ab479853d9b4614d8d2b68fa6e9a608d413c60e0b7a4011532396fb1a6332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59c78c9ee4b070e516fbdf89b0b18ec872e7d4e8895af3897f1bc842f19bd9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26494fa0a09c648b372abbf738e99d8a262f9846edc7462dbed6e1d3251a050c"
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
