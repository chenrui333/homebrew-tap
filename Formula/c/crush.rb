class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "0eed78ff73ae9310b22b4fe9525f329c7708200ac2207b5c76e487bb786f9f8a"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e8ca9190ea4439277b3cdd37c06b7e43c7929c9e84750beedd0f9e5e6e3cec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c41adc89be0942d13544698d20afc2e82783d8cc772ec509fc73f97606888628"
    sha256 cellar: :any_skip_relocation, ventura:       "e0fa6a2262ea56a728f064523071440195eda087d0e8e1097ffbef68ae1af9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a82650bb21779f6d19eebd5efcc11981dc52361b76d12b70bd02e40980679ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "no providers configured", output
  end
end
