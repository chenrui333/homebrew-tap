class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.82.3.tar.gz"
  sha256 "cb69f10709782ed1efb41550c18099ec6c65521d6005c61710df9bb26d0b471c"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b2d8a16bf895ba3e0477420c32e7b2760f43cfb78eb4fb67460e820430fc55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b2d8a16bf895ba3e0477420c32e7b2760f43cfb78eb4fb67460e820430fc55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16b2d8a16bf895ba3e0477420c32e7b2760f43cfb78eb4fb67460e820430fc55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "839f62d50de583c67dbf18f8e1adca211666df7ff64a3214218b6c85758e18bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "099139868fbbedae9ade94a375b9fea389d97c24ede7da77fe5193f48ceccfbb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
