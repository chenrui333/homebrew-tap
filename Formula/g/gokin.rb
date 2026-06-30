class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.59.tar.gz"
  sha256 "07bab3d1a6e13197517a969837e28824899a25feea8b6a12d84cb20860a87f51"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f570a5473dc7bf3f8744634fcec9c59b5fd8c91f3c4f7b6c7bb5426be3a8c382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f570a5473dc7bf3f8744634fcec9c59b5fd8c91f3c4f7b6c7bb5426be3a8c382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f570a5473dc7bf3f8744634fcec9c59b5fd8c91f3c4f7b6c7bb5426be3a8c382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28a7a4ca6124154ff2fad9d2726695becb0e44f8fc9af006872a8b6f36deb6d8"
    sha256 cellar: :any,                 x86_64_linux:  "fde9b132c753dea7faace576075cbe71ebe0e8a442139462fcdf3f5debd17df0"
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
