class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.69.tar.gz"
  sha256 "bac63bc67359d4761468916fa11e37089a0e40dbbc565a54bf3bce3cb09ed967"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e8b181901172ff7ed4c152db13735b79a4d7719c612331611aaca667f8d6ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e8b181901172ff7ed4c152db13735b79a4d7719c612331611aaca667f8d6ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8e8b181901172ff7ed4c152db13735b79a4d7719c612331611aaca667f8d6ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b46cd4cbc6aa4d57cda103e1c5449270e8676d6a9f65395607247a2a0cf597b1"
    sha256 cellar: :any,                 x86_64_linux:  "743975d762eacf560e7bdd5355e164915b1fe800c8e7ecc9a7ea6d0b41b11048"
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
