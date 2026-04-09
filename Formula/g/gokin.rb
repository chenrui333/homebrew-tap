class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.57.5.tar.gz"
  sha256 "afcd1ee76ac556ad068d26f205a0530fba86075686c634c533b0452928364418"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df166405a035fbc9d5c6fe55b807351fd77102ac72e0a8a245eb1238463cefd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df166405a035fbc9d5c6fe55b807351fd77102ac72e0a8a245eb1238463cefd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df166405a035fbc9d5c6fe55b807351fd77102ac72e0a8a245eb1238463cefd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fab665c2acb0700cb1bfff04b77fff9191308d6708557e03a986d0b2a3258b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd6e5b8900a877c58b9ad5bf7305eb4b4ae88576d6267d7c8b099543e68b44e"
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
