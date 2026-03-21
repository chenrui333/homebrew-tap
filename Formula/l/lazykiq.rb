class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "d2bff99ba82a5a66e7e0ecc15d1ed2a0260e356a0272298608ba46649c0b9b28"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5f7383c61901f41ceaa4fe84dcef7e00d56368683c4b9fe82b3e253475b2205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f7383c61901f41ceaa4fe84dcef7e00d56368683c4b9fe82b3e253475b2205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f7383c61901f41ceaa4fe84dcef7e00d56368683c4b9fe82b3e253475b2205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07d30e4d8b72b16981522fd22c716e0c598f4c320094912f3e037ef0213c1a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31fb9b6d90def151a364fefe83373f8f6eb9c513b201c0cbaf26ebdc4368cf8f"
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
