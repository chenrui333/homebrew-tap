class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "0eaefa16e655d1e4957e85009d29c3d3a3070890639c05ba2b89d7e89841c77e"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3ad900052bcda47c40dfc77729d427907cb1d2ee76b1b90610b75d6182e9114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3ad900052bcda47c40dfc77729d427907cb1d2ee76b1b90610b75d6182e9114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3ad900052bcda47c40dfc77729d427907cb1d2ee76b1b90610b75d6182e9114"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e1f087c4f731e4d281c485aeeb9013e8ff14ca5b010178512cc52a09202eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02cf905ed3e290474464c970bbc66e670c3eccc533021febe81799e2f8c7b771"
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
