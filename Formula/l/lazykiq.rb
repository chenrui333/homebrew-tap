class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ed90a5a0ba67b08fe1306c69ab3383e7db76394ab23ea2d6d3dbf9ee2b3ea7a1"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4685c238242107db33a0c25ce6eed22a0b15275402490d50422a0cc927880d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4685c238242107db33a0c25ce6eed22a0b15275402490d50422a0cc927880d0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4685c238242107db33a0c25ce6eed22a0b15275402490d50422a0cc927880d0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "297d8f3114fd18a2f6f68f1a5ff8dbd810aa78874706556dc4a7f65c39b9b4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9be52d8127feb40a831973f58e9a8f5adc4f87af454c3679e923b7c715aa921"
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
