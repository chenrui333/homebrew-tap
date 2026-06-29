class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.57.tar.gz"
  sha256 "d98269c1dfa9c2df46f9a9f06a560d691e09e07eae6efc247c014f518164b065"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "580302bf37d9cc466f59ac6b7b0a817a41105f1c9b5a2340c1231d6eeb76883e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "580302bf37d9cc466f59ac6b7b0a817a41105f1c9b5a2340c1231d6eeb76883e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580302bf37d9cc466f59ac6b7b0a817a41105f1c9b5a2340c1231d6eeb76883e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286bc36a7efc2cb8b449884d7fc51af8b57cdedc82119c7304e770b8b86e0cbd"
    sha256 cellar: :any,                 x86_64_linux:  "bb356637782cc89e7ce0fa5bf40f640a65ebb40c95effbdb1b0b295a8f2e56fe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
