class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "9ce4989a6b0f0c7daf8fa20dbbb88e724342e1e9d96b766f9f1c22da0f3955fc"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "feac86fbfe2b7b1e7810baf514f4d94ca44660ec5258bbc45e3d67ce7466906a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feac86fbfe2b7b1e7810baf514f4d94ca44660ec5258bbc45e3d67ce7466906a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feac86fbfe2b7b1e7810baf514f4d94ca44660ec5258bbc45e3d67ce7466906a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf353545a3d648c55e12276cd90dcc23fe9bd176ad81451e03e70ce91e86d439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca23d09c774c95fae8afc28e731950afbd85b499771d8a1cda6ab617ef5b4f9"
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
